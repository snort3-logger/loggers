import org.ajoberstar.grgit.Grgit

val BUILD_OUTPUT = project.file("target").absolutePath
val UBUNTU_VERSION = "bionic-20190515"
val DOCKER_IMAGE = "package/zmqfb"

tasks {
   
    named("build") {
        dependsOn(":dataplane:snort:zmqfb-plugin:buildImageForZmqFbCompilation")

        doLast {
            exec {
                val dockerRunCmd = "docker run --rm " +
                        "-v $BUILD_OUTPUT:$BUILD_OUTPUT " +
                        "--env BUILD_OUTPUT=$BUILD_OUTPUT " +
                        "--env PREFIX_DIR=/usr/local " +
                        "$DOCKER_IMAGE " +
                        "bash -c"
                val containerCmd = "umask 0000; " +
                        "env >> \$BUILD_OUTPUT/env.txt;" +
                        "apt-get update -qq;" +
                        "cd \$ZMQFB_SRC; " +
                        "./setup-flatc.sh; " +
                        "flatc --cpp --binary \$ZMQFB_SRC/src/IntrusionEvent.fbs; " +
                        "autoreconf -fisv; " +
                        "./configure --disable-static 'CXXFLAGS=-O3 -fno-rtti'; " +  
                        "mv -f /usr/local/include/snort/* /usr/local/include/; " +
                        "make VERBOSE=1 2>&1 | tee -a \$BUILD_OUTPUT/build_log.txt;" +
                        "checkinstall -y -d0 --pkgname libloggerzmqfb --pkgversion \$ZMQFB_VERSION --pkgrelease \$ZMQFB_RELEASE  --backup=no --strip=no --stripso=no --install=no --pakdir \$BUILD_OUTPUT 2>&1 | tee -a \$BUILD_OUTPUT/build_log.txt;" +
                        "chmod -R 777 \$BUILD_OUTPUT/ \$ZMQFB_SRC/;" +
                        "exit"
                val args = dockerRunCmd.split(" ").toMutableList()
                args.add(containerCmd)
                commandLine(args)
            }
        }
    }


    register<Exec>("buildImageForZmqFbCompilation") {
        group = "Build"
        description = "Builds the $DOCKER_IMAGE for compiling ZmqFb Source code"

        commandLine = listOf("bash", "-c", "docker build " +
                "--build-arg UBUNTU_VERSION=$UBUNTU_VERSION " +
                "-t $DOCKER_IMAGE -f zmqfb.Dockerfile .;"
        )
    }

    named("clean") {
        doLast {
            project.file(BUILD_OUTPUT).deleteRecursively()
        }
    }  
}
