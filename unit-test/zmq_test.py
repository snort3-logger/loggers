#!/usr/bin/python

import sys
import time
import zmq
import threading

rx_counter = 0
INTERVAL = 5

def display_stats():
    global rx_counter
    global timer
    timer = threading.Timer(INTERVAL, display_stats)
    timer.start()    
    print("Events/Sec : {0:5d}\n" .format(rx_counter/INTERVAL))
    rx_counter = 0

def emulate_0mq_server():
    global rx_counter
    context = zmq.Context()

    # Socket to receive messages on
    receiver = context.socket(zmq.PULL)
    if receiver == 0 :
      print"Failed to create socket"
    else :
      print"0MQ socket is created successfully!!"

    # bind can't do dns need either * or specific IP
    #https://stackoverflow.com/questions/6024003/why-doesnt-zeromq-work-on-localhost
    receiver.bind("tcp://*:5558")

    # Process tasks forever
    while True:
        receiver.recv()
        rx_counter = rx_counter + 1
        # Simple progress indicator for the viewer
        #sys.stdout.write('.')
        #sys.stdout.flush()

if __name__ == '__main__':
  display_stats()
  emulate_0mq_server()
