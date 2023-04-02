from lib.logging import print_msg
from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *

F1 = "num_sketch_algo"
F2 = "num_stats"
F3 = "SLML"
F4 = "num_counter_update"
F5 = "num_dp"
F6 = "num_sampling"
F7 = "num_heavy"

F8 = "num_sketch_inst"
F9 = "num_flowkey"
F10 = "num_flowsize"
F11 = "num_sketch_param"
F12 = "num_epoch"

def get_default_spec():
    spec = {}

    total_sketch_num = 0
    for k, v in sketch_dict.items():
        total_sketch_num += len(v)

    spec[F1] = total_sketch_num
    spec[F2] = 8
    spec[F3] = [1, 2]
    spec[F4] = 5
    spec[F5] = [0, 1]
    spec[F6] = [0, 1]
    spec[F7] = [0, 1]

    spec[F8] = 20
    spec[F9] = 7
    spec[F10] = [1, 2]
    spec[F11] = 5
    spec[F12] = 4
    return spec

# F1
def get_name(inst):
    return inst.sketch.name
# F2
def get_stat(inst):
    return inst.sketch.statistic
# F3
def get_index_type(inst):
    return inst.sketch.index_type
# F4
def get_cu_type(inst):
    return inst.sketch.counter_update_type
# F5
def get_dp_type(inst):
    return inst.sketch.counter_in_dp_type
# F6
def get_samping(inst):
    return inst.sketch.sampling_compatible
# F7
def get_heavy(inst):
    return inst.sketch.heavy_flowkey_storage


# F8
def get_num_sketch_inst(inst_list):
    return len(inst_list)
# F9
def get_flowkey(inst):
    return inst.flowkey
# F10
def get_flowsize(inst):
    return inst.flowsize
# F11
def get_row(inst):
    return inst.row
# F12
def get_epoch(inst):
    return inst.epoch

def row_exception_sketches(inst):
    if inst.sketch.name == "LinearCounting" or \
        inst.sketch.name == "HLL" or \
        inst.sketch.name == "MRB" or \
        inst.sketch.name == "MRAC" or \
        inst.sketch.name == "PCSA":
        return True
    return False


class WorkloadGenerator:
    def __init__(self, input_spec):
        self.input_spec = {}
        for key in [F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12]:
            self.input_spec[key] = input_spec[key]

        self.num_instances = self.input_spec[F8]
        self.result_inst_list = []


    def dup_check_pass(self, candidate, statistic):
        flowkey, flowsize, epoch = candidate
        for inst in self.result_inst_list:
            if inst.sketch.statistic == statistic and inst.flowkey == flowkey and inst.epoch == epoch and inst.flowsize == flowsize:
                return False

            if statistic == STATISTIC_TYPE_GENERAL:
                if inst.flowkey == flowkey and inst.epoch == epoch and inst.flowsize == flowsize:
                    if inst.sketch.statistic == STATISTIC_TYPE_ENTROPY or inst.sketch.statistic == STATISTIC_TYPE_HEAVY_HITTER:
                        return False
                if inst.flowkey == flowkey and inst.epoch == epoch:
                    if inst.sketch.statistic == STATISTIC_TYPE_CARDINALITY:
                        return False

            if inst.sketch.statistic == STATISTIC_TYPE_GENERAL:
                if inst.flowkey == flowkey and inst.epoch == epoch and inst.flowsize == flowsize:
                    if statistic == STATISTIC_TYPE_ENTROPY or statistic == STATISTIC_TYPE_HEAVY_HITTER:
                        return False
                if inst.flowkey == flowkey and inst.epoch == epoch:
                    if statistic == STATISTIC_TYPE_CARDINALITY:
                        return False

            if self.input_spec[F9] == 1:
                if inst.flowkey != flowkey:
                    return False
            
            if self.input_spec[F12] == 1:
                if inst.epoch != epoch:
                    return False

        return True

    def get_candidate_list(self, name, statistic):

        candidate_list = []
        # self.input_spec[F10] == [1] -> this is for workload 3
        if statistic == STATISTIC_TYPE_CARDINALITY or name == "BloomFilter" or name == "MRAC" or self.input_spec[F10] == [1]:
            for flowkey in pool_of_flowkeys:
                for epoch in pool_of_epochs:
                    candidate_list.append((flowkey, 1, epoch))
        else:
            for flowkey in pool_of_flowkeys:
                for flowsize in pool_of_flowsize:
                    for epoch in pool_of_epochs:
                        candidate_list.append((flowkey, flowsize, epoch))
        return candidate_list

    def limit_check(self, new_inst, func, limit):
        check_dict = {}
        check_dict[ str( func(new_inst) )  ] = 1
        for inst in self.result_inst_list:
            check_dict[ str( func(inst) ) ] = 1
        if len(check_dict.keys()) > limit:
            return False
        return True


    def generate(self):
        from lib.inst_list import rand_select, rand_select_and_remove

        self.result_inst_list = []

        if self.input_spec[F1] == 1: # workload 1
            statistic = rand_select(pool_of_statistics)
            sketch = rand_select(sketch_dict[statistic])
            candidate_list = self.get_candidate_list(sketch.name, sketch.statistic)
            # print("generate", len(candidate_list))
            # for e in candidate_list:
            #     print(e)

            for i in range(self.num_instances):
                flowkey, flowsize, epoch = rand_select_and_remove(candidate_list)
                inst = SketchInstance()
                inst.workload_init(sketch, flowkey, flowsize, epoch)
                self.result_inst_list.append(inst)
            return True
        else:
            retry = 0
            while True:
                self.result_inst_list = []
                flag = True
                for i in range(self.num_instances):
                    statistic = rand_select(pool_of_statistics)
                    sketch = rand_select(sketch_dict[statistic])
                    # print(sketch.name)
                    statistic = sketch.statistic
                    candidate_list = self.get_candidate_list(sketch.name, statistic)
                    new_candidate_list = []
                    for candidate in candidate_list:
                        if self.dup_check_pass(candidate, statistic):
                            new_candidate_list.append(candidate)
                    if len(new_candidate_list) == 0:
                        print_msg("out of candidate_list, retry", 10, "yellow")
                        # exit(1)
                        flag = False
                        break

                    flowkey, flowsize, epoch = rand_select(new_candidate_list)
                    inst = SketchInstance()
                    inst.workload_init(sketch, flowkey, flowsize, epoch)
                    self.result_inst_list.append(inst)
                    # print(flowkey, flowsize, epoch)
                    # print()
                    # if i == 10:
                    #     exit(1)

                if flag:
                    break
                retry+=1
                if retry % 100 == 0:
                    print_msg(f"retry : {retry}", 3, "red")
        return True


