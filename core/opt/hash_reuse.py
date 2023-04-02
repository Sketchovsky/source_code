import pandas as pd
from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *
from strategy_finder.obj_func import *
from lib.inst_list import *
from lib.logging import print_msg

class HashReuseSketchInstance:
    def __init__(self, _SketchInstList, _other_sketches):
        self.sketch_inst_list = _SketchInstList
        first_inst = _SketchInstList[0]
        self.flowkey = first_inst.flowkey
        self.level_hash = first_inst.sketch.level_hash
        self.other_sketches = _other_sketches

    def get_id(self):
        return self.sketch_inst_list[0].id

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
        return self.level_hash, 0, 0

    def objective_function_breakdown(self):
        before = compute_baseline_hash(self.sketch_inst_list)

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
        data["salu_reuse"] = [0, 0, 0]
        data["salu_merge"] = [0, 0, 0]
        df = pd.DataFrame(data, index=["hashcall", "salu", "sram"])
        return df

    def o1a_inst_can_be_add(self, o1a_inst):
        if self.other_sketches or o1a_inst.other_sketches:
            return False
        if self.flowkey == o1a_inst.flowkey and \
           self.level_hash == o1a_inst.level_hash and \
           len(self.sketch_inst_list) + len(o1a_inst.sketch_inst_list) <= 4:
           return True
        return False

    def add_o1a_inst(self, _SketchO1AInst):
        self.sketch_inst_list += _SketchO1AInst.sketch_inst_list

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


def O1A_instance_possible(inst):
    if inst.sketch.level_hash > 0:
        return True
    return False

def convert_o2_result_to_o1a_list(o2_result):
    o1a_inst_list = []
    for o2_inst in o2_result:
        inst_list = []
        other_sketches = False
        for inst in o2_inst.get_all_inst_list():
            if O1A_instance_possible(inst):
                inst_list.append(inst)
            if inst.sketch.name == "HLL" or \
                inst.sketch.name == "MRB" or \
                inst.sketch.name == "MRAC" or \
                inst.sketch.name == "PCSA":
                pass
            else:
                other_sketches = True
        if len(inst_list) > 0:
            # I can contain five sketches - UnivMon / HLL / MRB / MRAC / PCSA
            # (PCSA) can be merged
            # (MRAC / UnivMon) can be merged
            # (HLL) can be merged
            o1a_inst = HashReuseSketchInstance(inst_list, other_sketches)
            o1a_inst_list.append(o1a_inst)

    return o1a_inst_list
