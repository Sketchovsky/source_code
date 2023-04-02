from random import randint
from sketch_formats.sketch import *

### Configurable Features

# flowkey
SRCIP = 0
DSTIP = 1
SRCPORT = 2
DSTPORT = 3
PROTO = 4
Key1 = [SRCIP]
Key2 = [SRCIP, SRCPORT]
Key3 = [DSTIP, DSTPORT]
Key4 = [DSTIP]
Key5 = [SRCIP, DSTIP]
Key6 = [SRCIP, DSTIP, SRCPORT, DSTPORT]
Key7 = [SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO]
pool_of_flowkeys = [Key1, Key2, Key3, Key4, Key5, Key6, Key7]

# flowsize
FLOW_SIZE_TYPE_PACKET = 1
FLOW_SIZE_TYPE_BYTE = 2
pool_of_flowsize = [1, 2]

# epoch
pool_of_epochs = [10, 20, 30, 40]

class SketchInstance:
    def __init__(self):
        self.id = 0
        pass

    def setid(self, id):
        self.id = id

    def testcase_init(self, _Sketch, _flowkey, _flowsize, _epoch, _row, _width, _level):
        self.sketch = _Sketch
        self.flowkey = _flowkey
        self.flowsize = _flowsize
        self.epoch = _epoch
        self.row = _row
        self.width = _width
        self.level = _level

        # if self.sketch.counter_update_type == COUNTER_UPDATE_TYPE_BITMAP:
        #     self.width = self.width / 32


    def workload_init(self, _Sketch, _flowkey, _flowsize, _epoch):
        from lib.inst_list import rand_select
        self.sketch = _Sketch
        self.flowkey = _flowkey
        self.flowsize = _flowsize
        self.epoch = _epoch
        # one stage : 48 SRAM block

        # 1bit  : 131072 -> 1 block
        # 8bit  : 16384 -> 1 block
        # 32bit : 4096 -> 1 block

        if self.sketch.name == "LinearCounting":
            self.row = rand_select([1])
            self.width = rand_select([131072, 131072*2, 131072*4])
            self.level = rand_select([1])

        if self.sketch.name == "BloomFilter":
            self.row = rand_select([1, 2, 3, 4, 5])
            self.width = rand_select([131072, 131072*2, 131072*4])
            self.level = rand_select([1])

        if self.sketch.name == "CountMin":
            self.row = rand_select([1, 2, 3, 4, 5])
            self.width = rand_select([4096, 4096*2, 4096*4])
            self.level = rand_select([1])
        
        if self.sketch.name == "Kary":
            self.row = rand_select([1, 2, 3, 4, 5])
            self.width = rand_select([4096, 4096*2, 4096*4])
            self.level = rand_select([1])
        
        if self.sketch.name == "Entropy":
            self.row = rand_select([1, 2, 3, 4, 5])
            self.width = rand_select([4096, 4096*2, 4096*4])
            self.level = rand_select([1])
        
        if self.sketch.name == "CountingBloomFilter":
            self.row = rand_select([1, 2, 3, 4, 5])
            self.width = rand_select([4096, 4096*2, 4096*4])
            self.level = rand_select([1])
        
        if self.sketch.name == "HLL":
            self.row = rand_select([1])
            self.width = rand_select([4096, 4096*2, 4096*4])
            self.level = rand_select([1])
        
        if self.sketch.name == "CountSketch":
            self.row = rand_select([1, 2, 3, 4, 5])
            self.width = rand_select([4096, 4096*2, 4096*4])
            self.level = rand_select([1])
        
        if self.sketch.name == "PCSA":
            self.row = rand_select([1])
            self.width = rand_select([4096, 4096*2, 4096*4])
            self.level = rand_select([1])

        if self.sketch.name == "MRB":
            self.row = rand_select([1])
            self.width = rand_select([16384, 16384*2])
            self.level = rand_select([8, 16])
        
        if self.sketch.name == "UnivMon":
            self.row = rand_select([3, 4, 5])
            self.width = rand_select([2048])
            self.level = rand_select([16])
        
        if self.sketch.name == "MRAC":
            self.row = rand_select([1])
            self.width = rand_select([2048])
            self.level = rand_select([8, 16])


        if self.sketch.counter_update_type == COUNTER_UPDATE_TYPE_BITMAP:
            self.width = int(self.width / 32)
        if self.sketch.counter_update_type == COUNTER_UPDATE_TYPE_HLL:
            self.width = int(self.width / 4)


    def get_print_msg(self):
        mark_srcip = ""
        if 0 in self.flowkey:
            mark_srcip = "sip"

        mark_dstip = ""
        if 1 in self.flowkey:
            mark_dstip = "dip"

        mark_srcport = ""
        if 2 in self.flowkey:
            mark_srcport = "sport"

        mark_dstport = ""
        if 3 in self.flowkey:
            mark_dstport = "dport"

        mark_proto = ""
        if 4 in self.flowkey:
            mark_proto = "proto"

        # print(self.sketch.name)
        # print("[%3s] %20s | %6s %6s %8s %8s %6s | %5s %7s %5s %5s %5s %6s %5s" % \
        #     ("id", "NAME", "srcip", "dstip", "srcport", "dstport", "proto", "stat", "counter", "size", "epoch", "row", "width", "level"))
        width = self.width
        import math
        SRAMblock = math.ceil(self.width * self.level / 4096)
        if self.sketch.counter_update_type == COUNTER_UPDATE_TYPE_HLL:
            width *= 4
        if self.sketch.counter_update_type == COUNTER_UPDATE_TYPE_BITMAP:
            width *= 32
        
        stat_str = ""
        if self.sketch.statistic == STATISTIC_TYPE_MEMBERSHIP:
            stat_str = "MEM"
        if self.sketch.statistic == STATISTIC_TYPE_CARDINALITY:
            stat_str = "CARD"
        if self.sketch.statistic == STATISTIC_TYPE_ENTROPY:
            stat_str = "ENT"
        if self.sketch.statistic == STATISTIC_TYPE_HEAVY_HITTER:
            stat_str = "HH"
        if self.sketch.statistic == STATISTIC_TYPE_HEAVY_CHANGE:
            stat_str = "HC"
        if self.sketch.statistic == STATISTIC_TYPE_FLOWSIZE_DIST:
            stat_str = "FSD"
        if self.sketch.statistic == STATISTIC_TYPE_GENERAL:
            stat_str = "GEN"
        
        msg = "[%3s] %20s | %4s %4s %6s %6s %6s | %5s %8s %5s %6s %4s %5sK %6s %9s" % \
            (self.id, self.sketch.name, mark_srcip, mark_dstip, mark_srcport, mark_dstport, mark_proto, stat_str, self.sketch.counter_bit, self.flowsize, self.epoch, self.row, int(width/1024), self.level, SRAMblock)
        return msg


    def file_print(self, f):
        msg = self.get_print_msg()
        f.write(msg + "\n")

    def print(self):
        msg = self.get_print_msg()
        print(msg)

