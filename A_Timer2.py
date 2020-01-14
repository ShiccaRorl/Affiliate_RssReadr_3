# -*- coding: utf-8 -*-

from datetime import datetime

class Timer():
    def __init__(self):
        self.time = datetime.now()

    def set_time(self, i):
        self.time2 = i

    def get_flag(self):
        if datetime.now() - self.time <= self.time2:
            return True
        else:
            return False

    def reset(self):
        self.time = datetime.now()
