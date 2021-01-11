#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([zmqfb], [0.1], [mmahmoud@cisco.com])
AC_CONFIG_SRCDIR([src/zmqfb_logger.cc])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_FILES([Makefile src/Makefile])

AC_DISABLE_STATIC
: ${CXXFLAGS=""}

# Checks for programs.
AC_PROG_CXX

# Checks for libraries.
AM_PROG_AR
LT_INIT

# Checks for header files.
AC_CHECK_HEADERS([arpa/inet.h inttypes.h netinet/in.h stdlib.h string.h strings.h unistd.h])

AM_INIT_AUTOMAKE([subdir-objects])
# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_MALLOC

# modified from gnulib/m4/visibility.m4
AC_DEFUN([CC_VISIBILITY],
[
    AC_REQUIRE([AC_PROG_CC])
    AC_MSG_CHECKING([for visibility support])
    AC_CACHE_VAL(gl_cv_cc_visibility, [
        gl_save_CFLAGS="$CFLAGS"
        # Add -Werror flag since some compilers, e.g. icc 7.1, don't support it,
        # but only warn about it instead of compilation failing
        CFLAGS="$CFLAGS -Werror -fvisibility=hidden"
        AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
            extern __attribute__((__visibility__("hidden"))) int hiddenvar;
            extern __attribute__((__visibility__("default"))) int exportedvar;
            extern __attribute__((__visibility__("hidden"))) int hiddenfunc (void);
            extern __attribute__((__visibility__("default"))) int exportedfunc (void);]],
            [[]])],
            [gl_cv_cc_visibility="yes"],
            [gl_cv_cc_visibility="no"])
    ])
    AC_MSG_RESULT([$gl_cv_cc_visibility])
    CFLAGS="$gl_save_CFLAGS"
    if test "x$gl_cv_cc_visibility" = "xyes"; then
        CFLAGS="${CFLAGS} -DSF_VISIBILITY -fvisibility=hidden"
        AC_DEFINE([HAVE_VISIBILITY],[1],
            [Define if the compiler supports visibility declarations.])
    fi
])
CC_VISIBILITY()

LPTHREAD=""
AC_CHECK_LIB([pthread], [pthread_create],
    [LOGGER_MOD_LIBS="${LOGGER_MOD_LIBS} -lzmq -lpthread -lm -lrt"], [LPTHREAD="no"], [ ])

if test "x$LPTHREAD" = "xno"; then
    echo
    echo "   ERROR!  pthread library not found"
    exit 1
fi


AC_SUBST(LOGGER_MOD_LIBS)

AC_OUTPUT
