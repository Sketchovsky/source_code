import pandas as pd
import math

from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *
from strategy_finder.obj_func import *
SRCIP = 0
DSTIP = 1
SRCPORT = 2
DSTPORT = 3
PROTO = 4

class HFSReuseSketchInstance:
    def __init__(self, _SketchInst):
        self.sketch_inst_list = [_SketchInst]

    def add_inst(self, _SketchInst):
        self.sketch_inst_list.append(_SketchInst)

    def get_flowkey(self):
        union_flowkey = []
        for inst in self.sketch_inst_list:
            union_flowkey = list(set(union_flowkey) | set(inst.flowkey))
        return union_flowkey

    def getHashTableSize(self):
        target_size = 8192 * len(self.sketch_inst_list)
        size = 8192
        while True:
            if size > target_size:
                break
            size = size * 2
        return int(size/2)

    def getMatchTableSize(self):
        return int(2048 * len(self.sketch_inst_list))

    def getSRAM(self):
        SRAM = 0
        for inst in self.sketch_inst_list:
            ht_size = 8192
            sum = 0
            for key in inst.flowkey:
                if key == SRCIP or key == DSTIP:
                    sum += (ht_size/4096)+1
                elif key == SRCPORT or key == DSTPORT:
                    sum += math.ceil((ht_size/2)/4096)+1
                elif key == PROTO:
                    sum += math.ceil((ht_size/4)/4096)+1
                else:
                    print("shouldn't come here hfs_reuse.py, exit")
                    exit(1)
            # 4 is for exact match table
            SRAM += int(sum) + 4
        return SRAM

    def objective_function(self):
        SALU = len(self.get_flowkey())
        hash_call = SALU
        SRAM = self.getSRAM()

        ret = {}
        ret["overall"] = global_objective_function(hash_call, SALU, SRAM, 0)
        ret["hashcall"] = global_objective_function(hash_call, 0, 0, 0)
        ret["salu"] = global_objective_function(0, SALU, 0, 0)
        ret["sram"] = global_objective_function(0, 0, SRAM, 0)
        return pd.Series(ret)

    def objective_function_breakdown(self):
        pass


    def print(self):
        print(" "*10 + "-"*75)
        for inst in self.sketch_inst_list:
            inst.print()
        print(" "*10 + "-"*75)
