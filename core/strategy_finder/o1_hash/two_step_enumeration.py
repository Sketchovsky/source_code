from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *
from lib.inst_list import *
from opt.hash_reuse import *
from opt.hash_xor import *
from opt.salu_reuse import *
from opt.salu_merge import *

from lib.logging import *
from copy import deepcopy

def o1a_filter(o1a_inst_list):
    sum = 0
    for o1a_inst in o1a_inst_list:
        sum += len(o1a_inst.sketch_inst_list)
    if sum > 4:
        return False
    first_inst = o1a_inst_list[0]
    for o1a_inst in o1a_inst_list:
        if first_inst.flowkey != o1a_inst.flowkey:
            return False
        if first_inst.level_hash != o1a_inst.level_hash:
            return False
        
    return True



def tse_partition_o1a(inst_list, number_list):
    if len(number_list) == 1:
        yield [ number_list ]
        return

    first = number_list[0]

    for smaller in tse_partition_o1a(inst_list, number_list[1:]):
        for n, subset in enumerate(smaller):
            new_subset = [ first ] + subset
            new_inst_list = get_list_using_number_list(inst_list, new_subset)
            if o1a_filter(new_inst_list):
                yield smaller[:n] + [[ first ] + subset]  + smaller[n+1:]

        yield [[first]] + smaller

def create_o1a_inst(o1a_list, index_list):
    o1a_list_copy = deepcopy(o1a_list)

    added_inst = None
    for i in index_list:
        o1a_inst = o1a_list_copy[i]
        if added_inst == None:
            added_inst = o1a_inst
        else:
            if added_inst.o1a_inst_can_be_add(o1a_inst):
                added_inst.add_o1a_inst(o1a_inst)
            else:
                return None
    return added_inst

def tse_partition_o1b(o1a_list, partition, number_list):
    if len(number_list) == 1:
        yield [ number_list ]
        return

    first = number_list[0]

    for smaller in tse_partition_o1b(o1a_list, partition, number_list[1:]):
        for n, subset in enumerate(smaller):
            new_subset = [ first ] + subset
            if len(new_subset) <= 3:
                yield smaller[:n] + [[ first ] + subset]  + smaller[n+1:]

        yield [[first]] + smaller


def o1_tse_main(inst_list, o2_result):
    tse_obj_func_cache = {}
    min = float('inf')
    answer_partition = []
    answer_list = []

    print_msg("[o1_tse_main start]", 4, "cyan")

    o1a_list = convert_o2_result_to_o1a_list(o2_result)
    if len(o1a_list) == 0:
        return []
    print_answer_list_msg(o1a_list, 5) # only includes hash-related sketches

    number_list_o1a = list(range(len(o1a_list)))
    for ia, pa in enumerate(tse_partition_o1a(o1a_list, number_list_o1a), 1):
        o1a_partition = sorted(pa)
        # o1a_partition = [[0, 3], [1, 2], [4], [5], [6], [7]]
        msg = f"[o1a_tse_main] {ia} {o1a_partition}"
        print_msg(msg, 10, "cyan")
        # print(msg)
        number_list_o1b = list(range(len(o1a_partition)))
        for ib, pb in enumerate(tse_partition_o1b(o1a_list, o1a_partition, number_list_o1b), 1):
            o1b_partition = sorted(pb)
            msg = f"    [o1b_tse_main] {ib} {o1b_partition}"
            print_msg(msg, 10, "cyan")

            o1inst_list = []
            sum = 0
            for subset in o1b_partition:
                if len(subset) == 1: # no o1b applied
                    o1inst = create_o1a_inst(o1a_list, o1a_partition[subset[0]])
                    if o1inst == None:
                        sum = float('inf')
                        break
                elif len(subset) == 3: # o1b applied
                    inst_list = []
                    for t in [0, 1, 2]:
                        o1a_inst = create_o1a_inst(o1a_list, o1a_partition[subset[t]])
                        if o1a_inst == None:
                            break
                        inst_list.append(o1a_inst)
                    if len(inst_list) != 3:
                        sum = float('inf')
                        break
                    if O1B_possible(inst_list[0], inst_list[1], inst_list[2]):
                        o1inst = HashMergeSketchInstance(inst_list[0], inst_list[1], inst_list[2])
                    else:
                        sum = float('inf')
                        break
                else:
                    sum = float('inf')
                    break
                sum += o1inst.objective_function()['overall']
                o1inst_list.append(o1inst)
            if min > sum:
                min = sum
                answer_list = o1inst_list
                msg = f"    [o1b_tse_main] {ia} {o1a_partition} {ib} {o1b_partition}" + " [min val] %.4f" % min
                print_msg(msg, 5, "yellow")

    print_answer_list_msg(answer_list, 5)

    return answer_list

