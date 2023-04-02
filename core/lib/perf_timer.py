import time

# import datetime as DT
# from datetime import date
# import 
from datetime import datetime

class PerfTimer:

    def __init__(self, title=''):
        self.title = title
        self.st = time.time()
        self.t1 = datetime.now()

    def start(self):
        self.st = time.time()
        self.t1 = datetime.now()

    def lap_sec(self):
        print(self.lap_sec_string())

    def lap_sec_string(self):
        self.et = time.time()
        seconds = int(self.et - self.st)
        string = self.title + ' - [%02d:%02d] ' % (int(seconds / 60), seconds % 60)
        return string

    def lap_10_milli(self):
        print(self.lap_10_milli_string())

    def lap_10_milli_string(self):
        self.et = time.time()
        seconds = int(self.et - self.st)
        _10_milli_seconds = ((self.et - self.st)*100) % 100
        string = self.title + ' - [%02d:%02d:%02d]' % (int(seconds / 60), seconds % 60, _10_milli_seconds)
        return string

    def lap_micro(self):
        self.t2 = datetime.now()
        string = self.title + '[' + str(self.t2 - self.t1) + ']'
        print(string)
        return (self.t2 - self.t1).total_seconds()

    def lap_micro_string(self):
        self.t2 = datetime.now()
        string = self.title + ' [' + str((self.t2 - self.t1).total_seconds()) + ']'
        return string

    def end(self):
        self.t2 = datetime.now()
        return (self.t2 - self.t1).total_seconds()
