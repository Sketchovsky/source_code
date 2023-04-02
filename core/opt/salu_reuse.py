import pandas as pd

from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *
from strategy_finder.obj_func import *
from lib.inst_list import *
from lib.logging import print_msg

# for SALU-Reuse, there is only two cases
# LinearCounting/BloomFilter or CM/Kary/Ent

class SALUReuseSketchInstance:
    def __init__(self, _SketchInst):
        self.sketch_inst_list = [_SketchInst]
        self.flowkey = _SketchInst.flowkey
        self.flowsize = _SketchInst.flowsize
        self.epoch = _SketchInst.epoch

        self.index_type = _SketchInst.sketch.index_type
        self.counter_bit = _SketchInst.sketch.counter_bit
        self.counter_update_type = _SketchInst.sketch.counter_update_type
        self.counter_in_dp_type = _SketchInst.sketch.counter_in_dp_type

    def get_all_inst_list(self):
        return self.sketch_inst_list

    def objective_function(self):
        hash_call, SALU, SRAM = self.get_resource_usage()
        ret = {}
        ret["overall"] = global_objective_function(hash_call, SALU, SRAM, 0)
        ret["hashcall"] = global_objective_function(hash_call, 0, 0, 0)
        ret["salu"] = global_objective_function(0, SALU, 0, 0)
        ret["sram"] = global_objective_function(0, 0, SRAM, 0)

        return pd.Series(ret)

    def get_resource_usage(self):
        max_r, width_level_list = self.get_merged_configurations()
        if self.index_type == INDEX_COMPUTING_TYPE_1:
            hash_call = max_r
        elif self.index_type == INDEX_COMPUTING_TYPE_2:
            hash_call = max_r * 2
        else:
            print_msg("should not happen, error at salu_reuse.py 41", 0, "red")
            exit(1)

        for inst in self.sketch_inst_list:
            hash_call += inst.sketch.res_hash

        SALU = max_r
        SRAM = 0
        for (width, level) in width_level_list:
            import math
            SRAM += math.ceil((width * level) / 4096) + 1
        return hash_call, SALU, SRAM

    def get_merged_configurations(self):
        if len(self.sketch_inst_list) == 0:
            return 0, []
        
        max_r = self.get_max_r()

        width_level_list = []
        for r in range(1, max_r+1):
            max_width, max_level = self.get_max_width_level(r)
            width_level_list.append((max_width, max_level))

        return max_r, width_level_list
        
    def get_merged_configurations_epoch(self):
        if len(self.sketch_inst_list) == 0:
            return 0, []
        
        max_r = self.get_max_r()

        width_level_list = []
        for r in range(1, max_r+1):
            max_width, max_level = self.get_max_width_level(r)
            width_level_list.append((max_width, max_level, self.epoch))

        return max_r, width_level_list

    def objective_function_breakdown(self):
        before = compute_baseline(self.sketch_inst_list)

        hash_call, SALU, SRAM = self.get_resource_usage()
        after = {}
        after["hashcall"] = global_objective_function(hash_call, 0, 0, 0)
        after["salu"] = global_objective_function(0, SALU, 0, 0)
        after["sram"] = global_objective_function(0, 0, SRAM, 0)

        data = {}
        data["before"] = [before["hashcall"], before["salu"], before["sram"]]
        data["after"] = [after["hashcall"], after["salu"], after["sram"]]

        data["hash_reuse"] = [before["hashcall"] - after["hashcall"], 0, 0]
        data["hash_xor"] = [0, 0, 0]
        data["salu_reuse"] = [0, before["salu"] - after["salu"], before["sram"] - after["sram"]]
        data["salu_merge"] = [0, 0, 0]

        df = pd.DataFrame(data, index=["hashcall", "salu", "sram"])
        return df

    def get_counter_dp_type(self):
        for inst in self.sketch_inst_list:
            if inst.sketch.counter_in_dp_type == COUNTER_DP_Y:
                return True
        return False

    def get_max_r(self):
        max_r = 0
        for inst in self.sketch_inst_list:
            if max_r < inst.row:
                max_r = inst.row
        return max_r

    def get_max_width_level(self, r):
        max_width = 0
        max_level = 0
        for inst in self.sketch_inst_list:
            if inst.row >= r:
                if max_width < inst.width:
                    max_width = inst.width
                if max_level < inst.level:
                    max_level = inst.level
        return (max_width, max_level)

    def inst_can_be_add(self, _SketchInst, strict=False):
        if strict:
            if self.flowkey == _SketchInst.flowkey and \
            self.flowsize == _SketchInst.flowsize and \
            self.epoch == _SketchInst.epoch and \
            self.counter_bit == _SketchInst.sketch.counter_bit and \
            self.index_type == _SketchInst.sketch.index_type and \
            self.counter_update_type == _SketchInst.sketch.counter_update_type and \
            self.counter_in_dp_type == _SketchInst.sketch.counter_in_dp_type:
                return True

        else:
            if self.flowkey == _SketchInst.flowkey and \
            self.flowsize == _SketchInst.flowsize and \
            self.epoch == _SketchInst.epoch and \
            self.counter_bit == _SketchInst.sketch.counter_bit and \
            self.index_type == _SketchInst.sketch.index_type and \
            self.counter_update_type == _SketchInst.sketch.counter_update_type:
                return True
        return False

    def add_inst(self, _SketchInst):
        self.sketch_inst_list.append(_SketchInst)

    def add_o2a_inst(self, _SketchO2AInst):
        self.sketch_inst_list += _SketchO2AInst.sketch_inst_list

    def print(self):
        print(" "*10 + "-"*108)
        for inst in self.sketch_inst_list:
            inst.print()
        print(" "*10 + "-"*108)

    def file_print(self, f):
        f.write(" "*10 + "-"*108 + "\n")
        for inst in self.sketch_inst_list:
            inst.file_print(f)
        f.write(" "*10 + "-"*108 + "\n")

def apply_salu_reuse_normal(sketch_list, strict):
    o2a_inst_list = []
    for inst in sketch_list:
        Flag = True
        for o2a_inst in o2a_inst_list:
            if o2a_inst.inst_can_be_add(inst, strict):
                Flag = False
                o2a_inst.add_inst(inst)
                break
        if Flag:
            o2a_inst = SALUReuseSketchInstance(inst)
            o2a_inst_list.append(o2a_inst)
    return o2a_inst_list

# input: inst_list
# output: o2a_inst_list, o2a_inst can have 1 sketch
def apply_salu_reuse(inst_list, strict=False):
    o2a_inst_list = apply_salu_reuse_normal(inst_list, strict)
    return o2a_inst_list


