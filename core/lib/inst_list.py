from functools import cmp_to_key
import random
from datetime import datetime

# from opt.salu_reuse import *
# from opt.salu_merge import *
# from opt.hfs_reuse import *

random.seed(datetime.now())
# random.seed(1)

########### etc ###########
def rand_select(candidate_list):
    length = len(candidate_list)
    return candidate_list[random.randint(0, length-1)]

def rand_select_and_remove(candidate_list):
    length = len(candidate_list)
    return candidate_list.pop(random.randint(0, length-1))


def get_list_using_number_list(entry_list, number_list):
    result = []
    for index in number_list:
        result.append(entry_list[index])
    return result

########### sorting related ###########
# flowkey_order = {}
# flowkey_order['[0]'] = 1             # 100
# flowkey_order['[1]'] = 2             # 100
# flowkey_order['[0, 1]'] = 3          # 200
# flowkey_order['[0, 2]'] = 4          # 110
# flowkey_order['[1, 3]'] = 5          # 110
# flowkey_order['[3]'] = 6             # 010
# flowkey_order['[0, 1, 2, 3]'] = 7    # 220
# flowkey_order['[0, 1, 2, 3, 4]'] = 8 # 221

flowkey_order = {}
flowkey_order['[0]'] = 1             # 100
flowkey_order['[1]'] = 2             # 100
flowkey_order['[2]'] = 3
flowkey_order['[3]'] = 4             # 010

flowkey_order['[0, 1]'] = 5          # 200
flowkey_order['[0, 2]'] = 6          # 110
flowkey_order['[0, 3]'] = 7
flowkey_order['[1, 2]'] = 8
flowkey_order['[1, 3]'] = 9          # 110
flowkey_order['[0, 1, 2, 3]'] = 10    # 220
flowkey_order['[0, 1, 2, 3, 4]'] = 11 # 221


def generator_cmp(inst1, inst2):
    if flowkey_order[str(inst1.flowkey)] < flowkey_order[str(inst2.flowkey)]:
        return -1
    elif flowkey_order[str(inst1.flowkey)] > flowkey_order[str(inst2.flowkey)]:
        return 1
    else:
        if inst1.epoch < inst2.epoch:
            return -1
        elif inst1.epoch > inst2.epoch:
            return 1
        else:

            if inst1.flowsize < inst2.flowsize:
                return -1
            elif inst1.flowsize > inst2.flowsize:
                return 1
            else:

                if inst1.sketch.statistic < inst2.sketch.statistic:
                    return -1
                elif inst1.sketch.statistic > inst2.sketch.statistic:
                    return 1
                else:

                    if inst1.sketch.name < inst2.sketch.name:
                        return -1
                    elif inst1.sketch.name > inst2.sketch.name:
                        return 1

    return 0

def r_cmp(inst1, inst2):
    if str(inst1.row) < str(inst2.row):
        return -1
    elif str(inst1.row) > str(inst2.row):
        return 1
    return 0

def maxr_compare(o2a_inst1, o2a_inst2):
    return o2a_inst1.get_max_r() - o2a_inst2.get_max_r()

def maxr_compare2(o2a_inst1, o2a_inst2):
    return o2a_inst2.get_max_r() - o2a_inst1.get_max_r()

def flowkey_compare(o2a_inst1, o2a_inst2):
    if flowkey_order[str(o2a_inst1.flowkey)] < flowkey_order[str(o2a_inst2.flowkey)]:
        return -1
    elif flowkey_order[str(o2a_inst1.flowkey)] > flowkey_order[str(o2a_inst2.flowkey)]:
        return 1
    return 0

def sort_inst_list(inst_list):
    inst_list.sort(key=cmp_to_key(generator_cmp))
    return inst_list

def sort_inst_by_r(inst_list):
    inst_list.sort(key=cmp_to_key(r_cmp))
    return inst_list


def sort_o2a_inst_by_r(o2a_inst_list, ascending=True):
    if ascending==True:
        return sorted(o2a_inst_list, key=cmp_to_key(maxr_compare))
    else:
        return sorted(o2a_inst_list, key=cmp_to_key(maxr_compare2))

def sort_o2a_inst_list_by_flowkey(o2a_inst_list):
    return sorted(o2a_inst_list, key=cmp_to_key(flowkey_compare))


########### print related ###########
msg = "[%3s] %20s | %4s %4s %6s %6s %6s | %5s %8s %5s %6s %4s %6s %6s %9s" % ("id", "NAME", "sip", "dip", "sport", "dport", "proto", "stat", "counter", "size", "epoch", "row", "width", "level", "SM_BLOCK")

def SketchInstance_label():
    print(msg)
    print("-"*118)

def print_inst_list(inst_list):
    print()
    print("-"*118)
    SketchInstance_label()
    total = 0
    for inst in inst_list:
        inst.print()
        total += 1
    print(total)
    print("-"*118)
    print()

def print_answer_list(answer_list):
    for inst in answer_list:
        inst.print()

def file_SketchInstance_label(f):
    f.write(msg + "\n")
    f.write("-"*118 + "\n")

def file_print_inst_list(f, inst_list):
    f.write("\n")
    f.write("-"*118 + "\n")
    file_SketchInstance_label(f)
    total = 0
    for inst in inst_list:
        inst.file_print(f)
        total += 1
    f.write(str(total) + "\n")
    f.write("-"*118 + "\n")
    f.write("\n")

def file_print_answer_list(f, answer_list):
    for inst in answer_list:
        inst.file_print(f)
