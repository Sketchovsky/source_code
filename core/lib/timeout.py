import multiprocessing
import time

class TimeoutManager:
    def __init__(self, timeout, func_call, _args):
        manager = multiprocessing.Manager()
        self.return_dict = manager.dict()
        self.p = multiprocessing.Process(target=func_call, args=_args+[self.return_dict])
        self.timeout = timeout

    def start(self):
        self.p.start()
        self.p.join(self.timeout)
        if self.p.is_alive():
            print("%d(s) Timeout!" % self.timeout)
            self.p.terminate()
            self.p.join()
            return False
        return True

    def get_return_dict(self):
        return self.return_dict

# ret_dict = {}
# timeout_manager = TimeoutProcessManager(5, bar, ["55"])
# if timeout_manager.start():
#     print("success")
#     print(timeout_manager.get_return_dict())
# else:
#     print("fail")
