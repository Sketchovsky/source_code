import pandas as pd

from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *
from strategy_finder.obj_func import *
from lib.logging import print_msg

class HashMergeSketchInstance:
    def __init__(self, o1a_inst_1, o1a_inst_2, o1a_inst_3):

        A = o1a_inst_1
        B = o1a_inst_2
        C = o1a_inst_3

        if union_equal(A.flowkey, B.flowkey, C.flowkey) == False:
            print(A.flowkey)
            print(B.flowkey)
            print(C.flowkey)
            print_msg("error, HashMergeSketchInstance not union equal", 0, "red")
            exit(1)
        
        if A.level_hash != B.level_hash or A.level_hash != C.level_hash or B.level_hash != C.level_hash:
            print(A.level_hash, B.level_hash, C.level_hash)
            print_msg("error, HashMergeSketchInstance level hash does not match", 0, "red")
            exit(1)

        self.level_hash = A.level_hash

        if A.flowkey == set_union(B.flowkey, C.flowkey):
            self.big_o1a_inst = A
            self.small_o1a_inst_1 = B
            self.small_o1a_inst_2 = C
        if B.flowkey == set_union(A.flowkey, C.flowkey):
            self.big_o1a_inst = B
            self.small_o1a_inst_1 = A
            self.small_o1a_inst_2 = C
        if C.flowkey == set_union(A.flowkey, B.flowkey):
            self.big_o1a_inst = C
            self.small_o1a_inst_1 = A
            self.small_o1a_inst_2 = B

    def sketch_inst_list(self):
        return [self.big_o1a_inst, self.small_o1a_inst_1, self.small_o1a_inst_2]

    def get_all_inst_list(self):
        total_sketch_inst_list = []
        for o1a_inst in [self.big_o1a_inst, self.small_o1a_inst_1, self.small_o1a_inst_2]:
            total_sketch_inst_list += o1a_inst.sketch_inst_list
        return total_sketch_inst_list

    def get_resource_usage(self):
        return 2 * self.big_o1a_inst.level_hash, 0, 0, 0

    def objective_function(self):
        hash_call, SALU, SRAM, epoch = self.get_resource_usage()
        ret = {}
        ret["overall"] = global_objective_function(hash_call, SALU, SRAM, epoch)
        ret["hashcall"] = global_objective_function(hash_call, 0, 0, 0)
        ret["salu"] = global_objective_function(0, SALU, 0, 0)
        ret["sram"] = global_objective_function(0, 0, SRAM, 0)

        return pd.Series(ret)

    def objective_function_breakdown(self):
        before = compute_baseline_hash(self.get_all_inst_list())

        hash_call, SALU, SRAM, epoch = self.get_resource_usage()

        df = self.big_o1a_inst.objective_function_breakdown()
        df += self.small_o1a_inst_1.objective_function_breakdown()
        df += self.small_o1a_inst_2.objective_function_breakdown()

        after = {}
        after["hashcall"] = global_objective_function(hash_call, 0, 0, 0)
        after["salu"] = global_objective_function(0, SALU, 0, 0)
        after["sram"] = global_objective_function(0, 0, SRAM, 0)

        data = {}
        data["before"] = [before["hashcall"], before["salu"], before["sram"]]
        data["after"] = [after["hashcall"], after["salu"], after["sram"]]


        data["hash_reuse"] = [df["hash_reuse"]["hashcall"], 0, 0]
        data["hash_xor"] = [before["hashcall"] - after["hashcall"] - df["hash_reuse"]["hashcall"], 0, 0]
        data["salu_reuse"] = [0, 0, 0]
        data["salu_merge"] = [0, 0, 0]

        df = pd.DataFrame(data, index=["hashcall", "salu", "sram"])
        return df


    def print(self):
        print()
        print(" "*25 + "="*35 + "[O1B. Hash XOR]" + "="*35)
        print("[Big]")
        self.big_o1a_inst.print()
        print("[Small]")
        self.small_o1a_inst_1.print()
        self.small_o1a_inst_2.print()
        print(" "*25 + "="*85)
        print()


    def file_print(self, f):
        f.write("\n")
        f.write(" "*25 + "="*35 + "[O1B. Hash XOR]" + "="*35 + "\n")
        f.write("[Big]\n")
        self.big_o1a_inst.file_print(f)
        f.write("[Small]\n")
        self.small_o1a_inst_1.file_print(f)
        self.small_o1a_inst_2.file_print(f)
        f.write(" "*25 + "="*85 + "\n\n")


def O1B_possible(inst1, inst2, inst3):
    if inst1.__class__.__name__ != "HashReuseSketchInstance":
        return False
    if inst2.__class__.__name__ != "HashReuseSketchInstance":
        return False
    if inst3.__class__.__name__ != "HashReuseSketchInstance":
        return False

    if inst1.other_sketches or inst2.other_sketches or inst3.other_sketches:
        return False

    if len(inst1.sketch_inst_list) + len(inst2.sketch_inst_list) + len(inst3.sketch_inst_list) > 4:
        return False

    if union_equal(inst1.flowkey, inst2.flowkey, inst3.flowkey) and \
        inst1.level_hash == inst2.level_hash and \
        inst2.level_hash == inst3.level_hash:
        return True

    return False
