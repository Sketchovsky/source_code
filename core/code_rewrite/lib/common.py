import math
from sketch_formats.sketch import *
from lib.logging import print_msg


def get_flowkey_code(flowkey):
    a = 0
    b = 0
    c = 0
    if 0 in flowkey:
        a+=1
    if 1 in flowkey:
        a+=1
    if 2 in flowkey:
        b+=1
    if 3 in flowkey:
        b+=1
    if 4 in flowkey:
        c+=1
    return "%d%d%d" % (a, b, c)

def get_flowkey_str(flowkey):
    ret_str = ""
    if 0 in flowkey:
        ret_str += ", SRCIP"
    if 1 in flowkey:
        ret_str += ", DSTIP"
    if 2 in flowkey:
        ret_str += ", SRCPORT"
    if 3 in flowkey:
        ret_str += ", DSTPORT"
    if 4 in flowkey:
        ret_str += ", PROTO"
    return ret_str[2:]

def bf_msg(id, max_r):
    msg = ""
    msg += "if ("
    for row in range(1, max_r+1):
        if row > 1:
            msg += " || "
        msg += f"ig_md.d_{id}_est1_{row} == 0"
    msg += ") { /* process_new_flow() */ }"
    return msg


def get_init_msg(inst, o5_writer):
    msg = ""
    flowkey_code = get_flowkey_code(inst.flowkey)
    if inst.sketch.name == "LinearCounting":
        msg = "T1_INIT_%d(%2d, %s, %d)" % (inst.row, inst.id, flowkey_code, inst.width * 32)

    elif inst.sketch.name == "BloomFilter":
        msg = "T1_INIT_%d(%2d, %s, %d)" % (inst.row, inst.id, flowkey_code, inst.width * 32)

    elif inst.sketch.name == "CountMin" or inst.sketch.name == "Kary":
        msg = "T2_INIT_HH_%d(%2d, %s, %d)" % (inst.row, inst.id, flowkey_code, inst.width)
        o5_writer.add(inst.id, inst.flowkey)

    elif inst.sketch.name == "Entropy":
        msg = "T2_INIT_%d(%2d, %s, %d)" % (inst.row, inst.id, flowkey_code, inst.width)

    elif inst.sketch.name == "CountSketch":
        msg = "T3_INIT_HH_%d(%2d, %s, %d)" % (inst.row, inst.id, flowkey_code, inst.width)
        o5_writer.add(inst.id, inst.flowkey)

    elif inst.sketch.name == "HLL":
        msg = "T4_INIT_%d(%2d, %s, %d)" % (inst.row, inst.id, flowkey_code, inst.width*4)

    elif inst.sketch.name == "PCSA":
        msg = "T5_INIT_%d(%2d, %s, %d)" % (inst.row, inst.id, flowkey_code, inst.width)

    elif inst.sketch.name == "MRB":
        width_len = math.log2(inst.width*32)
        msg = "MRB_INIT_%d(%2d, %s, %d, %d, %2d)" % (inst.row, inst.id, flowkey_code, inst.width * 32 * inst.level, width_len, inst.level)

    elif inst.sketch.name == "UnivMon": # done
        width_len = math.log2(inst.width)
        msg = "UM_INIT_%d(%2d, %s, %d, %5d)" % (inst.row, inst.id, flowkey_code, width_len, inst.width * inst.level)
        o5_writer.add(inst.id, inst.flowkey)

    elif inst.sketch.name == "MRAC":
        width_len = math.log2(inst.width)
        msg = "MRAC_INIT_%d(%2d, %s, %d, %d, %2d)" % (inst.row, inst.id, flowkey_code, inst.width * inst.level, width_len, inst.level)

    return msg
    


def get_run_msg(type, inst):
    msg = ""
    flowkey_str = get_flowkey_str(inst.flowkey)
    keylen = len(inst.flowkey)
    if inst.flowsize == 1:
        flowsize_str = "1"
    else:
        flowsize_str = "SIZE"
    
    if inst.sketch.name == "LinearCounting":
        msg = "T1_RUN_%d_KEY_%d(%2d, %s)" % (inst.row, keylen, inst.id, flowkey_str)
    
    elif inst.sketch.name == "BloomFilter":
        msg = "T1_RUN_%d_KEY_%d(%2d, %s) " % (inst.row, keylen, inst.id, flowkey_str)
        msg += bf_msg(inst.id, inst.row)
    
    elif inst.sketch.name == "CountMin" or inst.sketch.name == "Kary":
        if type == "before":
            msg = "T2_RUN_HH_%d_KEY_%d(%2d, %s, %s)" % (inst.row, keylen, inst.id, flowkey_str, flowsize_str)
        else: # after
            msg = "T2_RUN_AFTER_%d_KEY_%d(%2d, %s, %s)" % (inst.row, keylen, inst.id, flowkey_str, flowsize_str)
    
    elif inst.sketch.name == "Entropy":
        msg = "T2_RUN_%d_KEY_%d(%2d, %s, %s)" % (inst.row, keylen, inst.id, flowkey_str, flowsize_str)
    
    elif inst.sketch.name == "CountSketch":
        if type == "before":
            msg = "T3_RUN_HH_%d_KEY_%d(%2d, %s, %s)" % (inst.row, keylen, inst.id, flowkey_str, flowsize_str)
        else:
            msg = "T3_RUN_AFTER_%d_KEY_%d(%2d, %s, %s)" % (inst.row, keylen, inst.id, flowkey_str, flowsize_str)
    
    elif inst.sketch.name == "HLL":
        msg = "T4_RUN_%d_KEY_%d(%2d, %s)" % (inst.row, keylen, inst.id, flowkey_str)
    
    elif inst.sketch.name == "PCSA":
        msg = "T5_RUN_%d_KEY_%d(%2d, %s)" % (inst.row, keylen, inst.id, flowkey_str)
    
    elif inst.sketch.name == "MRB":
        msg = "MRB_RUN_%d_KEY_%d(%2d, %s)" % (inst.row, keylen, inst.id, flowkey_str)

    
    elif inst.sketch.name == "UnivMon": # done
        if type == "before":
            msg = "UM_RUN_%d_KEY_%d(%2d, %s, %s)" % (inst.row, keylen, inst.id, flowkey_str, flowsize_str)
        else:
            msg = "UM_RUN_AFTER_%d_KEY_%d(%2d, %s, %s)" % (inst.row, keylen, inst.id, flowkey_str, flowsize_str)
    
    elif inst.sketch.name == "MRAC":
        msg = "MRAC_RUN_%d_KEY_%d(%2d, %s)" % (inst.row, keylen, inst.id, flowkey_str)
    
    return msg

