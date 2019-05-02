#!/usr/bin/python3

import signal
import keyboard
import time
from datetime import datetime

# CONSTANTS, REPLACE THESE WITH YOUR OWN VARIABLES FOR YOUR OWN KEYBOARD
TIMEOUT_SECS = 0.2
LEFT_CTRL_CODE = 44
RIGHT_CTRL_CODE = 53
LEFT_SHIFT_CODE = 42
RIGHT_SHIFT_CODE = 54
LEFT_CTRL_REPLACE = 29
RIGHT_CTRL_REPLACE = 97
LEFT_SHIFT_REPLACE = 'shift+9'
RIGHT_SHIFT_REPLACE= 'shift+0'

class ReleaseQuickListener(object):
    left_shift_down = False
    right_shift_down = False
    left_ctrl_down = False
    right_ctrl_down = False
    left_shift_time = None
    right_shift_time = None
    left_ctrl_time = None
    right_ctrl_time = None

    def __init__(self):
        self.done = False
        signal.signal(signal.SIGINT, self.cleanup)
        keyboard.hook(self.my_on_key_event)
        while not self.done:
            time.sleep(1)  #  Wait for Ctrl+C

    def cleanup(self, signum, frame):
        self.done = True

    def reset_times(self):
        self.left_shift_time = None
        self.right_shift_time = None
        self.left_ctrl_time = None
        self.right_ctrl_time = None
    
    @staticmethod
    def is_time_valid_and_quick(press_time):
        if (press_time == None):
            #print("it's none")
            return False
        diff = datetime.now() - press_time
        if (diff.total_seconds() > TIMEOUT_SECS):
            #print("time not right " + str(diff.total_seconds()))
            return False
        return True

    def my_on_key_event(self, e):
        #print("Got key release event: " + str(e) + " scancode: " + str(e.scan_code))
        if (e.event_type == "down"):
            if (e.scan_code == LEFT_CTRL_CODE): #Left CTRL
                if (self.left_ctrl_down == False):
                    self.left_ctrl_time = datetime.now()
                    self.left_ctrl_down = True
            elif (e.scan_code == RIGHT_CTRL_CODE): #Right CTRL
                if (self.right_ctrl_down == False):
                    self.right_ctrl_time = datetime.now()
                    self.right_ctrl_down = True
            elif (e.scan_code == LEFT_SHIFT_CODE): #Left Shift
                if (self.left_shift_down == False):
                    self.left_shift_time = datetime.now()
                    self.left_shift_down = True
            elif (e.scan_code == RIGHT_SHIFT_CODE): #Right Shift
                if (self.right_shift_down == False):
                    self.right_shift_time = datetime.now()
                    self.right_shift_down = True
            elif (e.name != "alt"):
                self.reset_times()
        elif (e.event_type == "up"):
            if (e.scan_code == LEFT_CTRL_CODE): #Left CTRL
                self.left_ctrl_down = False
                if (ReleaseQuickListener.is_time_valid_and_quick(self.left_ctrl_time)):
                    keyboard.press_and_release(LEFT_CTRL_REPLACE)
                    self.reset_times()
            elif (e.scan_code == RIGHT_CTRL_CODE): #Right CTRL
                self.right_ctrl_down = False
                if (ReleaseQuickListener.is_time_valid_and_quick(self.right_ctrl_time)):
                    keyboard.press_and_release(RIGHT_CTRL_REPLACE)
                    self.reset_times()
            elif (e.scan_code == LEFT_SHIFT_CODE): #Left Shift
                self.left_shift_down = False
                if (ReleaseQuickListener.is_time_valid_and_quick(self.left_shift_time)):
                    keyboard.press_and_release(LEFT_SHIFT_REPLACE)
                    self.reset_times()
            elif (e.scan_code == RIGHT_SHIFT_CODE): #Right Shift
                self.right_shift_down = False
                if (ReleaseQuickListener.is_time_valid_and_quick(self.right_shift_time)):
                    keyboard.press_and_release(RIGHT_SHIFT_REPLACE)
                    self.reset_times()
            #print(e.scan_code)

a = ReleaseQuickListener()
