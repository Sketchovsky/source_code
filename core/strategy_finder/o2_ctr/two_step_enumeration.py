from strategy_finder.obj_func import *
from lib.inst_list import *
from opt.salu_reuse import *
from opt.salu_merge import *
from copy import deepcopy

from lib.logging import *

########### partition traversal filter ###########

def salu_reuse_filter(inst_list):
    o2a_inst_list = apply_salu_reuse(inst_list)
    if len(o2a_inst_list) == 1:
        return True
    return False

def salu_merge_filter(inst_list):

    o2a_inst_list = apply_salu_reuse(inst_list)

    o2a_inst = o2a_inst_list[0]
    flowkey = o2a_inst.flowkey
    index_type = o2a_inst.index_type
    counter_bit = o2a_inst.counter_bit
    epoch = o2a_inst.epoch
    for o2a_inst in o2a_inst_list:
        if o2a_inst.flowkey != flowkey:
            return False
        if o2a_inst.index_type != index_type:
            return False
        if o2a_inst.counter_bit != counter_bit:
            return False
        if o2a_inst.epoch != epoch: # LOGGING FOR THE SAME EPOCH CONSTRAINT
            return False

    # do the sum check (e.g., 2 * max_r < sum)
    return merging_sum_check(o2a_inst_list)

########### actual finding ###########

##### find best O2B #####

def two_mergeable_o2a_insts(strict_o2a_inst_list):
    if len(strict_o2a_inst_list) != 2:
        return False
    strict_o2a_inst_1 = strict_o2a_inst_list[0]
    strict_o2a_inst_2 = strict_o2a_inst_list[1]

    if strict_o2a_inst_1.flowkey == strict_o2a_inst_2.flowkey and\
        strict_o2a_inst_1.flowsize == strict_o2a_inst_2.flowsize and\
        strict_o2a_inst_1.epoch == strict_o2a_inst_2.epoch and\
        strict_o2a_inst_1.counter_bit == strict_o2a_inst_2.counter_bit and\
        strict_o2a_inst_1.index_type == strict_o2a_inst_2.index_type and\
        strict_o2a_inst_1.counter_update_type == strict_o2a_inst_2.counter_update_type:
        return True
    
    return False

def merge_strict_o2a(strict_o2a_inst_list, partition):
    o2a_inst_list = []
    for subset in partition:
        if len(subset) == 1:
            o2a_inst_list.append(deepcopy(strict_o2a_inst_list[subset[0]]))
        elif len(subset) == 2:
            o2a_inst1 = deepcopy(strict_o2a_inst_list[subset[0]])
            o2a_inst2 = deepcopy(strict_o2a_inst_list[subset[1]])
            if o2a_inst1.counter_update_type == o2a_inst2.counter_update_type: 
                o2a_inst1.add_o2a_inst(o2a_inst2)
                o2a_inst_list.append(o2a_inst1)
            else: # to handle the case of bitmap merging
                print_msg("should not happen at tse.py, exit", 0, "red")
                exit(1)
        else:
            print_msg("should not happen at tse.py, exit", 0, "red")
            exit(1)
    return o2a_inst_list

def best_O2B_partition(strict_o2a_inst_list, number_list):
    if len(number_list) == 1:
        yield [ number_list ]
        return

    first = number_list[0]

    for smaller in best_O2B_partition(strict_o2a_inst_list, number_list[1:]):
        for n, subset in enumerate(smaller):
            new_subset = [ first ] + subset
            new_strict_o2a_inst_list = get_list_using_number_list(strict_o2a_inst_list, new_subset)
            if two_mergeable_o2a_insts(new_strict_o2a_inst_list):
                yield smaller[:n] + [[ first ] + subset]  + smaller[n+1:]

        yield [[first]] + smaller

def find_best_O2B(inst_list):
    debug_level = 30

    strict_o2a_inst_list = apply_salu_reuse(inst_list, strict=True)
    min = float('inf')
    min_o2b_inst = None
    answer_partition = []

    print_msg("    [tse find best O2B start]", debug_level, "cyan")

    new_number_list = list(range(len(strict_o2a_inst_list)))
    i=0
    for p in best_O2B_partition(strict_o2a_inst_list, new_number_list):
        partition_candidate = sorted(p)

        i+=1
        print_msg(f"    [tse find best O2B] {i} {partition_candidate}", debug_level, "cyan")
        o2a_inst_list = merge_strict_o2a(strict_o2a_inst_list, partition_candidate)

        if SALU_merge_check(o2a_inst_list) == False: # thorough checking before creating o2b_inst
            val, o2b_inst = float('inf'), None
        else:
            o2b_inst = SALUMergeSketchInstance(o2a_inst_list)
            val= o2b_inst.objective_function()['overall']

        if min > val:
            min = val
            min_o2b_inst = o2b_inst
            answer_partition = partition_candidate
            msg = f"    [tse find best O2B] {i} {partition_candidate}" + " [min val] %.4f" % val + f" [answer partition] {answer_partition}"
            print_msg(msg, debug_level, "yellow")

    print_msg("    [tse find best O2B end]", debug_level, "cyan")
    return min, min_o2b_inst



def tse_compute_obj_func(inst_list):

    # if all sketch instances are combined with O2A, we should do it
    if salu_reuse_filter(inst_list): 
        o2a_inst_list = apply_salu_reuse(inst_list)
        return o2a_inst_list[0].objective_function()['overall'], o2a_inst_list[0]

    # O2A + O2B is possible, apply them
    if salu_merge_filter(inst_list):
        val, o2b_inst = find_best_O2B(inst_list)
        if val != float('inf'):
            return val, o2b_inst

    if len(inst_list) == 1:
        return inst_list[0].objective_function()['overall'], inst_list[0]

    return float('inf'), None

########### partition traversal ###########

def tse_partition(inst_list, number_list):
    if len(number_list) == 1:
        yield [ number_list ]
        return

    first = number_list[0]

    for smaller in tse_partition(inst_list, number_list[1:]):
        for n, subset in enumerate(smaller):
            new_subset = [ first ] + subset
            new_inst_list = get_list_using_number_list(inst_list, new_subset)
            if salu_reuse_filter(new_inst_list) or \
               salu_merge_filter(new_inst_list):
                yield smaller[:n] + [[ first ] + subset]  + smaller[n+1:]

        yield [[first]] + smaller



def o2_tse_main(inst_list):
    print_msg("[o2_tse_main start]", 4, "cyan")

    tse_obj_func_cache = {}

    # we must sort sketch by ascending order due to max_sum constraint
    # this sorting is vital
    inst_list = sort_inst_by_r(inst_list)

    print_inst_list_msg(inst_list, 6)

    min = float('inf')
    answer_partition = []
    answer_list = []

    number_list = list(range(len(inst_list)))
    for i, p in enumerate(tse_partition(inst_list, number_list), 1):
        partition_candidate = sorted(p)
        msg = f"[o2_tse_main] {i} {partition_candidate}"
        if i % 100000 == 0:
            print_msg(msg, 10, "cyan")
        elif i % 10000 == 0:
            print_msg(msg, 11, "cyan")
        elif i % 1000 == 0:
            print_msg(msg, 12, "cyan")
        elif i % 100 == 0:
            print_msg(msg, 13, "cyan")
        else:
            print_msg(msg, 14, "cyan")

        o2inst_list = []
        sum = 0
        for subset in partition_candidate:

            key = tuple(subset)
            if key in tse_obj_func_cache:
                val, o2inst =  tse_obj_func_cache[key]
            else:
                print_msg(f"[cache miss] compute {subset}", 17, "cyan")
                new_inst_list = get_list_using_number_list(inst_list, subset)
                val, o2inst = tse_compute_obj_func(new_inst_list)
                tse_obj_func_cache[key] = (val, o2inst)

            sum += val
            o2inst_list.append(o2inst)

        if min > sum:
            min = sum
            answer_partition = partition_candidate
            answer_list = o2inst_list
            msg = f"[o2_tse_main] {i} {partition_candidate}" + " [min val] %.4f" % val + f" [answer partition] {answer_partition}"
            print_msg(msg, 5, "yellow")

    print_answer_list_msg(answer_list, 4)
    print_msg("[o2_tse_main end]", 4, "cyan")

    return answer_list
