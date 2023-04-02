from strategy_finder.obj_func import *
from lib.inst_list import *
from opt.hash_reuse import *
from opt.hash_xor import *
from opt.salu_reuse import *
from opt.salu_merge import *

from lib.logging import *
from copy import deepcopy

def run_O1_greedy(o1a_list):
    print_msg(f"        [greedy O1A start]", 6, "cyan")
    o1a_list_copy = deepcopy(o1a_list)
    while True:
        size = len(o1a_list_copy)
        new_o1a_list = []
        Flag = False
        for i in range(0, size):
            for j in range(i+1, size):
                o1a_inst_1 = o1a_list_copy[i]
                o1a_inst_2 = o1a_list_copy[j]
                if o1a_inst_1.o1a_inst_can_be_add(o1a_inst_2):
                    Flag = True
                    o1a_inst_1.add_o1a_inst(o1a_inst_2)
                    new_o1a_list.append(o1a_inst_1)
                    for k in range(0, size):
                        if k != i and k != j:
                            new_o1a_list.append(o1a_list_copy[k])
                    o1a_list_copy = new_o1a_list
                    break
            if Flag:
                break

        if Flag == False:
            break
    print_msg(f"        [greedy O1A end]", 6, "cyan")
    print_answer_list_msg(o1a_list_copy, 8)

    o1_list = o1a_list_copy
    while True:
        size = len(o1_list)
        new_o1_list = []
        Flag = False
        for i in range(0, size):
            for j in range(i+1, size):
                for k in range(j+1, size):
                    if O1B_possible(o1_list[i], o1_list[j], o1_list[k]):
                        Flag = True
                        o1b_inst = HashMergeSketchInstance(o1_list[i], o1_list[j], o1_list[k])
                        new_o1_list.append(o1b_inst)
                        for l in range(0, size):
                            if l != i and l != j and l != k:
                                new_o1_list.append(o1_list[l])
                        o1_list = new_o1_list
                        break
                if Flag:
                    break
            if Flag:
                break

        if Flag == False:
            break
    print_answer_list_msg(o1_list, 8)
    return o1_list

def greedy_O1(o1a_list, timeout):
    print_msg(f"    [greedy O1 start]", 6, "cyan")

    o1inst_list = run_O1_greedy(o1a_list)

    print_msg(f"    [greedy O1 end]", 6, "cyan")
    return o1inst_list


def o1_greedy_main(inst_list, timeout_O1, o2_result):
    print_msg("[o1_greedy_main start]", 4, "cyan")

    # print_inst_list_msg(inst_list, 2)
    o1a_list = convert_o2_result_to_o1a_list(o2_result)
    print_answer_list_msg(o1a_list, 8)

    o1inst_list = greedy_O1(o1a_list, timeout_O1)
    return o1inst_list
