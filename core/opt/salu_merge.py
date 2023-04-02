import pandas as pd

from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *
from strategy_finder.obj_func import *

class SALUMergeSketchInstance: # represents O2A+O2B
    def __init__(self, o2a_inst_list):
        if len(o2a_inst_list) == 1:
            print("error, SALUMergeSketchInstance can't receive 1 o2a_inst, exit")
            exit(1)

        max_r = 0
        for o2a_inst in o2a_inst_list:
            if max_r < o2a_inst.get_max_r():
                max_r = o2a_inst.get_max_r()

        self.big_o2a_inst = None
        self.small_o2a_inst_list = []

        for o2a_inst in o2a_inst_list:
            if max_r == o2a_inst.get_max_r() and self.big_o2a_inst == None:
                self.big_o2a_inst = o2a_inst
            else:
                self.small_o2a_inst_list.append(o2a_inst)

        self.small_o2a_inst = self.small_o2a_inst_list[0]

        self.flowkey = self.big_o2a_inst.flowkey

        self.big_flowkey = self.big_o2a_inst.flowkey
        self.big_flowsize = self.big_o2a_inst.flowsize
        self.big_epoch = self.big_o2a_inst.epoch
        self.big_index_type = self.big_o2a_inst.index_type
        self.big_counter_update_type = self.big_o2a_inst.counter_update_type

    def getSRAM(self):
        big_r, big_list = self.big_o2a_inst.get_merged_configurations_epoch() # left_list = [(1024, 1), (1024, 1), (1024, 1)]
        small_list = []
        small_r = 0
        for o2a_inst in self.small_o2a_inst_list:
            _small_r, _small_list = o2a_inst.get_merged_configurations_epoch()
            small_r += _small_r
            small_list += _small_list

        SRAM = 0
        epoch_diff_sum = 0
        for A, B in zip(big_list, small_list):
            (A_max_width, A_max_level, A_epoch) = A
            (B_max_width, B_max_level, B_epoch) = B
            max_width = max(A_max_width, B_max_width)
            max_level = max(A_max_level, B_max_level)
            import math
            SRAM += math.ceil(max_width * max_level * 2/4096)+1 # because of two counter arrays
            epoch_diff_sum += abs(A_epoch - B_epoch)

        for A in big_list[small_r:]:
            (A_max_width, A_max_level, epoch) = A
            SRAM += math.ceil(A_max_width * A_max_level/4096)+1
        return SRAM, epoch_diff_sum

    def get_all_inst_list(self):
        total_sketch_inst_list = []
        total_sketch_inst_list += self.big_o2a_inst.sketch_inst_list
        for o2a_inst in self.small_o2a_inst_list:
            total_sketch_inst_list += o2a_inst.sketch_inst_list
        return total_sketch_inst_list

    def get_resource_usage(self):
        big_r, big_list = self.big_o2a_inst.get_merged_configurations_epoch() # left_list = [(1024, 1), (1024, 1), (1024, 1)]
        if self.big_index_type == INDEX_COMPUTING_TYPE_1:
            hash_call = big_r
        elif self.big_index_type == INDEX_COMPUTING_TYPE_2:
            hash_call = big_r*2

        # max_level_hash = 0
        max_res_hash = 0
        for o2a_inst in [self.big_o2a_inst] + self.small_o2a_inst_list:
            for inst in o2a_inst.sketch_inst_list:
                # if max_level_hash < inst.sketch.level_hash:
                #     max_level_hash = inst.sketch.level_hash
                if max_res_hash < inst.sketch.res_hash:
                    max_res_hash = inst.sketch.res_hash
        hash_call += max_res_hash

        SALU = big_r
        SRAM, epoch = self.getSRAM()
        return hash_call, SALU, SRAM, epoch

    def objective_function(self):
        hash_call, SALU, SRAM, epoch = self.get_resource_usage()
        ret = {}
        ret["overall"] = global_objective_function(hash_call, SALU, SRAM, epoch)
        ret["hashcall"] = global_objective_function(hash_call, 0, 0, 0)
        ret["salu"] = global_objective_function(0, SALU, 0, 0)
        ret["sram"] = global_objective_function(0, 0, SRAM, 0)

        return pd.Series(ret)

    def objective_function_breakdown(self):
        before = compute_baseline(self.get_all_inst_list())

        hash_call, SALU, SRAM, epoch = self.get_resource_usage()

        df = self.big_o2a_inst.objective_function_breakdown()
        for o2a_inst in self.small_o2a_inst_list:
            df += o2a_inst.objective_function_breakdown()

        after = {}
        after["hashcall"] = global_objective_function(hash_call, 0, 0, 0)
        after["salu"] = global_objective_function(0, SALU, 0, 0)
        after["sram"] = global_objective_function(0, 0, SRAM, 0)

        data = {}

        data["before"] = [before["hashcall"], before["salu"], before["sram"]]
        data["after"] = [after["hashcall"], after["salu"], after["sram"]]


        data["hash_reuse"] = [before["hashcall"] - after["hashcall"], 0, 0]
        data["hash_xor"] = [0, 0, 0]
        data["salu_reuse"] = [0, df["salu_reuse"]["salu"], df["salu_reuse"]["sram"]]
        data["salu_merge"] = [0, \
                        before["salu"] - after["salu"] - (df["salu_reuse"]["salu"]), \
                        before["sram"] - after["sram"] - (df["salu_reuse"]["sram"])]

        df = pd.DataFrame(data, index=["hashcall", "salu", "sram"])
        return df


    def print(self):
        print()
        print(" "*25 + "="*34 + "[O2B. SALU Merge]" + "="*34)
        print("[Big]")
        self.big_o2a_inst.print()
        print("[Small]")
        for o2a_inst in self.small_o2a_inst_list:
            o2a_inst.print()
            print()
        print(" "*25 + "="*85)
        print()


    def file_print(self, f):
        f.write("\n")
        f.write(" "*25 + "="*34 + "[O2B. SALU Merge]" + "="*34 + "\n")
        f.write("[Big]\n")
        self.big_o2a_inst.file_print(f)
        f.write("[Small]\n")
        for o2a_inst in self.small_o2a_inst_list:
            o2a_inst.file_print(f)
            f.write("\n")
        f.write(" "*25 + "="*85 + "\n\n")


def merging_sum_check(o2a_inst_list):
    max_max_r = 0
    sum_max_r = 0
    for o2a_inst in o2a_inst_list:
        sum_max_r += o2a_inst.get_max_r()
        if max_max_r < o2a_inst.get_max_r():
            max_max_r = o2a_inst.get_max_r()

    if 2 * max_max_r >= sum_max_r:
        return True
    return False

def SALU_merge_check(o2a_inst_list):
    if len(o2a_inst_list) == 1:
        return False
    if merging_sum_check(o2a_inst_list) == False:
        return False
    if o2a_inst_list[0].counter_update_type == COUNTER_UPDATE_TYPE_BITMAP:
        return False
    max_r = 0
    max_i = -1
    for i, o2a_inst in enumerate(o2a_inst_list):
        if max_r < o2a_inst.get_max_r():
            max_r = o2a_inst.get_max_r()
            max_i = i
    if o2a_inst_list[max_i].get_counter_dp_type() == False:
        return True
    for i, o2a_inst in enumerate(o2a_inst_list):
        if i != max_i:
            if o2a_inst.get_counter_dp_type() == True:
                return False


    # let"s filter out CS+SIZE / PCSA
    if o2a_inst_list[max_i].counter_update_type == COUNTER_UPDATE_TYPE_CS and o2a_inst_list[max_i].flowsize == 2: # FLOW_SIZE_TYPE_BYTE = 2
        for i, o2a_inst in enumerate(o2a_inst_list):
            if i != max_i:
                if o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_PCSA:
                    return False

    if o2a_inst_list[max_i].counter_update_type == COUNTER_UPDATE_TYPE_PCSA:
        for i, o2a_inst in enumerate(o2a_inst_list):
            if i != max_i:
                if o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CS and o2a_inst.flowsize == 2:
                    return False

    return True

def is_in_cluster(clusters, o2a_inst):
    for cluster in clusters:
        if o2a_inst in cluster:
            return True
    return False

def get_O2B_cluster(o2a_merged_list):
    clusters = []
    for o2a_inst in o2a_merged_list:
        if is_in_cluster(clusters, o2a_inst):
            continue
        cluster = []
        for o2a_inst_2 in o2a_merged_list:
            if o2a_inst.flowkey == o2a_inst_2.flowkey and \
               o2a_inst.counter_bit == o2a_inst_2.counter_bit and \
               o2a_inst.index_type == o2a_inst_2.index_type and \
               o2a_inst.epoch == o2a_inst_2.epoch: # LOGGING FOR THE SAME EPOCH CONSTRAINT
               cluster.append(o2a_inst_2)
        clusters.append(cluster)
    return clusters

