from multiprocessing import Process, current_process
import os

class ParallelRunHelper:

    def __init__(self, max_pcount):
        self.max_pcount = max_pcount
        self.pcount = 0
        self.procs = []

    def proc_check(self):
        self.pcount += 1
        if self.pcount % self.max_pcount == 0:
            for proc in self.procs:
                proc.join()
            self.procs = []

    def call(self, function, fun_args):
        proc = Process(target=function, args=(*fun_args, ))
        self.procs.append(proc)
        proc.start()

        self.proc_check()

    def join(self):
        for proc in self.procs:
            proc.join()
        self.procs = []

def run_cmd_func(cmd):
	print("[by thread %s] %s" % (current_process().name, cmd))
	os.system(cmd)

def run_cmd_list(cmd_list, max_pcount):
    run_helper = ParallelRunHelper(max_pcount)

    for cmd in cmd_list:
        print(cmd)
        run_helper.call(run_cmd_func, (cmd, ))
