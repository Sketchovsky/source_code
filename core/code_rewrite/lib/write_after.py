from code_rewrite.lib.o5_writer import O5_Writer
from code_rewrite.lib.code_parts import *
from code_rewrite.lib.common import *

def find_id_in_o1_result(id, o1_result):
    for o1_inst in o1_result:
        if o1_inst.__class__.__name__ == "HashReuseSketchInstance":
            for inst in o1_inst.get_all_inst_list():
                if inst.id == id:
                    return o1_inst.get_id()
        else:
            inst_1 = o1_inst.big_o1a_inst
            inst_2 = o1_inst.small_o1a_inst_1
            inst_3 = o1_inst.small_o1a_inst_2
            id_1 = inst_1.get_id()
            id_2 = inst_2.get_id()
            id_3 = inst_3.get_id()

            for inst in inst_1.get_all_inst_list():
                if inst.id == id:
                    return id_1

            for inst in inst_2.get_all_inst_list():
                if inst.id == id:
                    return id_2

            for inst in inst_3.get_all_inst_list():
                if inst.id == id:
                    return id_3
    print(id)
    print_msg("shouldn't come here at find_id_in_o1_result, exit", 0, "red")
    import traceback
    traceback.print_stack()
    exit(1)


# *********************** code generation for O2 ***********************

def common_o2(o2_inst):
    flowkey_code = get_flowkey_code(o2_inst.flowkey)
    flowkey_str = get_flowkey_str(o2_inst.flowkey)
    keylen = len(o2_inst.flowkey)
    max_r = o2_inst.get_max_r()
    first_inst = o2_inst.sketch_inst_list[0]

    return flowkey_code, flowkey_str, keylen, max_r, first_inst


# case 1 for T1. (BF) / Linear counting (no same sketch algo)
def after_o2_case_1(f, type, o2_inst, o5_writer):
    flowkey_code, flowkey_str, keylen, max_r, first_inst = common_o2(o2_inst)
    id = first_inst.id

    if type == "init":
        f.write("\n    // apply O2\n")
        for row in range(1, max_r+1):
            width, _ = o2_inst.get_max_width_level(row)
            f.write(f"        T1_KEY_UPDATE_{flowkey_code}_{int(width*32)}(32w0x30243f0b) update_{id}_{row};\n")
        f.write("    // \n\n")
    else: # run
        msg = f"T1_RUN_{max_r}_KEY_{keylen}({id}, {flowkey_str}) "
        msg += bf_msg(id, max_r)
        f.write("\n        // apply O2\n")
        f.write("        " + msg + "\n")
        f.write("        // \n\n")


# case 2 for T2.  (CM) / (Kary) / Ent
def after_o2_case_2(f, type, o2_inst, o5_writer):
    flowkey_code, flowkey_str, keylen, max_r, first_inst = common_o2(o2_inst)
    id = first_inst.id

    if type == "init":
        f.write("\n    // apply O2\n")
        for row in range(1, max_r+1):
            width, _ = o2_inst.get_max_width_level(row)
            f.write(f"        T2_KEY_UPDATE_{flowkey_code}_{int(width)}(32w0x30243f0b) update_{id}_{row};\n")
        f.write(f"        ABOVE_THRESHOLD_CONSTANT_{max_r}(100) d_{id}_above_threshold;\n")
        f.write("    // \n\n")
        o5_writer.add(id, o2_inst.flowkey)
    else: # run

        if o2_inst.flowsize == 1:
            flowsize_str = "1"
        else:
            flowsize_str = "SIZE"
        # o2 -> 3 out of 2, always heavy hitter sketch
        msg = f"T2_RUN_AFTER_{max_r}_KEY_{keylen}({id}, {flowkey_str}, {flowsize_str})"
        f.write("\n        // apply O2\n")
        f.write("        " + msg + "\n")
        f.write("        // \n\n")


# *********************** code generation for O3 ***********************


def common_o3(o2o3_inst):
    flowkey_code = get_flowkey_code(o2o3_inst.flowkey)
    flowkey_str = get_flowkey_str(o2o3_inst.flowkey)
    keylen = len(o2o3_inst.flowkey)
    big_o2a_inst = o2o3_inst.big_o2a_inst
    max_r = big_o2a_inst.get_max_r()
    return flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r


# UnivMon - MRACs
def after_o3_case_1(f, type, o2o3_inst, o5_writer, o1_result):
    flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r = common_o3(o2o3_inst)
    id = big_o2a_inst.sketch_inst_list[0].id
    fid = find_id_in_o1_result(id, o1_result)

    if type == "init":
        f.write("\n    // apply SALUMerge; big - UnivMon / small - many MRACs \n")
        f.write(f"        UM_INIT_SETUP({id}, {flowkey_code})\n")
        f.write(f"        ABOVE_THRESHOLD_{max_r}() d_{id}_above_threshold;\n")
        o5_writer.add(id, o2o3_inst.flowkey)
    else:
        f.write("\n        // apply SALUMerge; big - UnivMon / small - many MRACs \n")
        # f.write(f'        d_{id}_sampling_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_16);\n')
        f.write(f'        d_{id}_res_hash_call.apply({flowkey_str}, ig_md.d_{id}_res_hash);\n')
        f.write(f'        d_{id}_tcam_lpm_2.apply(ig_md.d_{fid}_sampling_hash_16, ig_md.d_{id}_base_16_1024, ig_md.d_{id}_base_16_2048, ig_md.d_{id}_threshold);\n')


    if big_o2a_inst.flowsize == 1:
        flowsize_str = "1"
    else:
        flowsize_str = "SIZE"

    row = 1
    for small_o2inst in o2o3_inst.small_o2a_inst_list:
        for small_row in range(1, small_o2inst.get_max_r()+1):
            big_width, big_level = big_o2a_inst.get_max_width_level(row)
            small_width, small_level = small_o2inst.get_max_width_level(small_row)
            max_width = max(big_width, small_width)
            max_level = max(big_level, small_level)
            width_len = int(math.log2(max_width))
            if type == "init":
                f.write(f'        COMPUTE_HASH_{flowkey_code}_16_{width_len}(32w0x30244f0b) d_{id}_index_hash_call_{row};\n')
                f.write(f'        T3_T2_INDEX_UPDATE_{max_width * max_level}() update_{id}_{row};\n')
            else:
                if max_width == 1024:
                    base = f"ig_md.d_{id}_base_16_1024"
                else:
                    base = f"ig_md.d_{id}_base_16_2048"
                index = f"ig_md.d_{id}_index{row}_16"
                res = f"ig_md.d_{id}_res_hash[{row-1}:{row-1}]"
                f.write(f'        d_{id}_index_hash_call_{row}.apply({flowkey_str}, {index});\n')
                f.write(f'        update_{id}_{row}.apply({base}, {index}, {res}, {flowsize_str}, ig_md.d_{id}_est_{row});\n')
            row += 1

    while row <= max_r:
        big_width, big_level = big_o2a_inst.get_max_width_level(row)
        width_len = int(math.log2(big_width))
        if type == "init":
            f.write(f'        COMPUTE_HASH_{flowkey_code}_16_{width_len}(32w0x30244f0b) d_{id}_index_hash_call_{row};\n')
            f.write(f'        T3_INDEX_UPDATE_{big_width * big_level}() update_{id}_{row};\n')
        else:
            if big_width == 1024:
                base = f"ig_md.d_{id}_base_16_1024"
            else:
                base = f"ig_md.d_{id}_base_16_2048"
            index = f"ig_md.d_{id}_index{row}_16"
            res = f"ig_md.d_{id}_res_hash[{row-1}:{row-1}]"
            f.write(f'        d_{id}_index_hash_call_{row}.apply({flowkey_str}, {index});\n')
            f.write(f'        update_{id}_{row}.apply({base}, {index}, {res}, {flowsize_str}, ig_md.d_{id}_est_{row});\n')
        row += 1

    if type == "init":
        f.write("    // \n\n")
    else:
        f.write(f'        RUN_HEAVY_FLOWKEY_NOIF_{max_r}({id})\n')
        f.write("        // \n\n")

# MRAC - UnivMon or MRAC
def after_o3_case_2(f, type, o2o3_inst, o5_writer, o1_result):
    flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r = common_o3(o2o3_inst)
    if len(o2o3_inst.small_o2a_inst_list) > 1:
        print_msg("error, len(o2o3_inst.small_o2a_inst_list) must be 1, after_o3_case_2", 0, "red")
        exit(1)
    if max_r > 1:
        print_msg("error, max_r must be 1, after_o3_case_2", 0, "red")
        exit(1)

    small_o2inst = o2o3_inst.small_o2a_inst_list[0]
    id = big_o2a_inst.sketch_inst_list[0].id
    fid = find_id_in_o1_result(id, o1_result)

    row = 1
    big_width, big_level = big_o2a_inst.get_max_width_level(row)
    small_width, small_level = small_o2inst.get_max_width_level(row)
    max_width = max(big_width, small_width)
    max_level = max(big_level, small_level)
    width_len = int(math.log2(max_width))

    if small_o2inst.flowsize == 1:
        flowsize_str = "1"
    else:
        flowsize_str = "SIZE"

    if small_o2inst.sketch_inst_list[0].sketch.name == "UnivMon":
        if max_width == 1024:
            base = f"ig_md.d_{id}_base_16_1024"
        else:
            base = f"ig_md.d_{id}_base_16_2048"
        if type == "init":
            f.write("\n    // apply SALUMerge; big - MRAC (1 row) / small - UnivMon (1 row) \n")
            f.write(f"        UM_INIT_SETUP({id}, {flowkey_code})\n")
            f.write(f"        ABOVE_THRESHOLD_{max_r}() d_{id}_above_threshold;\n")
            f.write(f'        COMPUTE_HASH_{flowkey_code}_16_{width_len}(32w0x30244f0b) d_{id}_index_hash_call_{row};\n')
            f.write(f'        T3_T2_INDEX_UPDATE_{max_width * max_level}() update_{id}_{row};\n')
            f.write("    // \n\n")
            o5_writer.add(id, o2o3_inst.flowkey)
        else:
            f.write("\n        // apply SALUMerge; big - MRAC (1 row) / small - UnivMon (1 row)\n")
            # f.write(f'        d_{id}_sampling_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_16);\n')
            f.write(f'        d_{id}_res_hash_call.apply({flowkey_str}, ig_md.d_{id}_res_hash);\n')
            f.write(f'        d_{id}_tcam_lpm_2.apply(ig_md.d_{fid}_sampling_hash_16, ig_md.d_{id}_base_16_1024, ig_md.d_{id}_base_16_2048, ig_md.d_{id}_threshold);\n')
            index = f"ig_md.d_{id}_index{row}_16"
            res = f"ig_md.d_{id}_res_hash[{row-1}:{row-1}]"
            f.write(f'        d_{id}_index_hash_call_{row}.apply({flowkey_str}, {index});\n')
            f.write(f'        update_{id}_{row}.apply({base}, {index}, {res}, {flowsize_str}, ig_md.d_{id}_est_{row});\n')
            f.write(f'        RUN_HEAVY_FLOWKEY_NOIF_{max_r}({id})\n')
            f.write("        // \n\n")
    else:
        if max_width == 1024:
            base = f"ig_md.d_{id}_base_16_1024"
        else:
            base = f"ig_md.d_{id}_base_16_2048"
        if type == "init":
            f.write("\n    // apply SALUMerge; big - MRAC (1 row) / small - MRAC (1 row) \n")
            f.write(f"        COMPUTE_HASH_{flowkey_code}_16_{max_level}(32w0x30244f0b) d_{id}_sampling_hash_call;\n")
            f.write(f"        COMPUTE_HASH_{flowkey_code}_16_{width_len}(32w0x30244f0b) d_{id}_index_hash_call_1;\n")
            f.write(f"        LPM_OPT_MRAC_2() d_{id}_tcam_lpm_2;\n")
            f.write(f"        T2_T2_INDEX_UPDATE_{max_width * max_level}() update_{id};\n")
            f.write("    // \n\n")
        else:
            f.write("\n        // apply SALUMerge; big - MRAC (1 row) / small - MRAC (1 row)\n")
            # f.write(f'        d_{id}_sampling_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_16);\n')
            f.write(f'        d_{id}_tcam_lpm_2.apply(ig_md.d_{fid}_sampling_hash_16, ig_md.d_{id}_base_16_1024, ig_md.d_{id}_base_16_2048);\n')
            f.write(f'        d_{id}_index_hash_call_1.apply({flowkey_str}, ig_md.d_{id}_index1_16);\n')
            
            f.write(f'        update_{id}_1.apply({base}, ig_md.d_{id}_index1_16);\n')
            f.write("        // \n\n")


# # BF/LC - LC
# def after_o3_case_3(f, type, o2o3_inst, o5_writer):
#     flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r = common_o3(o2o3_inst)
#     id = big_o2a_inst.sketch_inst_list[0].id

#     if type == "init":
#         f.write("\n    // apply O3; big - BF/LC / small - many LCs \n")
#     else:
#         f.write("\n        // apply O3; big - BF/LC / small - many LCs \n")


#     row = 1
#     for small_o2inst in o2o3_inst.small_o2a_inst_list:
#         for small_row in range(1, small_o2inst.get_max_r()+1):
#             big_width, _ = big_o2a_inst.get_max_width_level(row)
#             small_width, _ = small_o2inst.get_max_width_level(small_row)
#             max_width = int(max(big_width, small_width))
#             width_len = int(math.log2(max_width))
#             if type == "init":
#                 f.write(f'        T1_T1_KEY_UPDATE_{flowkey_code}_{max_width*32}(32w0x30243f0b) update_{id}_{row};\n')
#             else:
#                 f.write(f'            update_{id}_{row}.apply({flowkey_str}, ig_md.d_{id}_est1_{row});\n')
#             row += 1

#     while row <= max_r:
#         big_width, _ = big_o2a_inst.get_max_width_level(row)
#         width_len = int(math.log2(big_width))
#         if type == "init":
#             f.write(f'        T1_KEY_UPDATE_{flowkey_code}_{int(big_width)*32}(32w0x30243f0b) update_{id}_{row};\n')
#         else:
#             f.write(f'            update_{id}_{row}.apply({flowkey_str}, ig_md.d_{id}_est1_{row});\n')
#         row += 1

#     if type == "init":
#         f.write("    //\n\n")
#     else:
#         msg = bf_msg(id, max_r)
#         f.write(f'            ' + msg + '\n')
#         f.write("        //\n")


# # LC - LC or BF/LC
# def after_o3_case_4(f, type, o2o3_inst, o5_writer):
#     flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r = common_o3(o2o3_inst)
#     id = big_o2a_inst.sketch_inst_list[0].id
#     if len(o2o3_inst.small_o2a_inst_list) > 1:
#         print_msg("error, len(o2o3_inst.small_o2a_inst_list) must be 1, after_o3_case_4", 0, "red")
#         exit(1)
#     if max_r > 1:
#         print_msg("error, max_r must be 1, after_o3_case_4", 0, "red")
#         exit(1)

#     small_o2inst = o2o3_inst.small_o2a_inst_list[0]

#     row = 1
#     big_width, _ = big_o2a_inst.get_max_width_level(row)
#     small_width, _ = small_o2inst.get_max_width_level(row)
#     max_width = int(max(big_width, small_width))
#     width_len = int(math.log2(max_width))

#     if type == "init":
#         f.write("\n    // apply O3; LC (row1) - BF/LC (row1) \n")
#         f.write(f'        T1_T1_KEY_UPDATE_{flowkey_code}_{max_width*32}(32w0x30243f0b) update_{id}_{row};\n')
#     else:
#         f.write("\n        // apply O3; LC (row1) - BF/LC (row1)  \n")
#         f.write(f'            update_{id}_{row}.apply({flowkey_str}, ig_md.d_{id}_est1_{row});\n')

#     if type == "init":
#         f.write("    //\n\n")
#     else:
#         if small_o2inst.get_counter_dp_type():
#             msg = bf_msg(id, max_r)
#             f.write(f'            ' + msg + '\n')
#         f.write("        //\n")


# HLL - HLL
def after_o3_case_5(f, type, o2o3_inst, o5_writer, o1_result):
    flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r = common_o3(o2o3_inst)
    id = big_o2a_inst.sketch_inst_list[0].id
    if len(o2o3_inst.small_o2a_inst_list) > 1:
        print_msg("error, len(o2o3_inst.small_o2a_inst_list) must be 1, after_o3_case_5", 0, "red")
        exit(1)
    if max_r > 1:
        print_msg("error, max_r must be 1, after_o3_case_5", 0, "red")
        exit(1)

    small_o2inst = o2o3_inst.small_o2a_inst_list[0]

    row = 1
    big_width, _ = big_o2a_inst.get_max_width_level(row)
    small_width, _ = small_o2inst.get_max_width_level(row)
    max_width = int(max(big_width, small_width))
    width_len = int(math.log2(max_width))

    if type == "init":
        f.write("    // apply SALUMerge; HLL (row1) - HLL (row1) \n")
        # f.write(f'        COMPUTE_HASH_{flowkey_code}_32_32(32w0x30244f0b) d_{id}_hash_call;\n')
        f.write(f'        TCAM_LPM_HLLPCSA() d_{id}_tcam_lpm;\n')
        f.write(f'        T4_T4_KEY_UPDATE_{flowkey_code}_{max_width*4}(32w0x30243f0b) update_{id}_{row};\n')
    else:
        f.write("        // apply SALUMerge; HLL (row1) - HLL (row1)  \n")
        # f.write(f'            d_{id}_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_32);\n')
        fid = find_id_in_o1_result(id, o1_result)
        f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_32, ig_md.d_{id}_level);\n')
        f.write(f'            update_{id}_{row}.apply({flowkey_str}, ig_md.d_{id}_level);\n')

    if type == "init":
        f.write("    //\n\n")
    else:
        f.write("        //\n\n")



# (CM/KARY/ENT or CS) - (ENT or PCSA)
def after_o3_case_6(f, type, o2o3_inst, o5_writer, o1_result):
    flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r = common_o3(o2o3_inst)
    id = big_o2a_inst.sketch_inst_list[0].id

    if type == "init":
        f.write("    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA \n")
        o5_writer.add(id, o2o3_inst.flowkey)
    else:
        f.write("        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA \n")


    if big_o2a_inst.flowsize == 1:
        flowsize_str_1 = "1"
    else:
        flowsize_str_1 = "SIZE"

    if type == "init":
        f.write(f"        ABOVE_THRESHOLD_CONSTANT_{max_r}(100) d_{id}_above_threshold;\n")

    # Ready for PCSA
    pcsa_flag = False
    for small_o2inst in o2o3_inst.small_o2a_inst_list:
        if small_o2inst.counter_update_type == COUNTER_UPDATE_TYPE_PCSA:
            fid = find_id_in_o1_result(small_o2inst.sketch_inst_list[0].id, o1_result)
            pcsa_flag = True

    if pcsa_flag:
        if type == "init":
            f.write(f'        COMPUTE_HASH_{flowkey_code}_32_32(32w0x30244f0b) d_{id}_hash_call;\n')
            f.write(f'        TCAM_LPM_HLLPCSA() d_{id}_tcam_lpm;\n')
            f.write(f'        GET_BITMASK() d_{id}_get_bitmask;\n')
        else:
            # f.write(f'            d_{id}_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_32);\n')
            f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_32, ig_md.d_{id}_level);\n')
            f.write(f'            d_{id}_get_bitmask.apply(ig_md.d_{id}_level, ig_md.d_{id}_bitmask);\n')

    # Ready for CS
    cs_flag = False
    if big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CS:
        cs_flag = True

    if cs_flag:
        if type == "init":
            f.write(f'        COMPUTE_HASH_{flowkey_code}_16_16(32w0x30244f0b) d_{id}_res_hash_call;\n')
        else:
            f.write(f'            d_{id}_res_hash_call.apply({flowkey_str}, ig_md.d_{id}_res_hash);\n')



    row = 1
    for small_o2inst in o2o3_inst.small_o2a_inst_list:
        for small_row in range(1, small_o2inst.get_max_r()+1):
            big_width, _ = big_o2a_inst.get_max_width_level(row)
            small_width, _ = small_o2inst.get_max_width_level(small_row)
            max_width = int(max(big_width, small_width))
            width_len = int(math.log2(max_width))
            if small_o2inst.flowsize == 1:
                flowsize_str_2 = "1"
            else:
                flowsize_str_2 = "SIZE"

            cu_type = ""
            if big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CM:
                cu_type = "T2"
            elif big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CS:
                cu_type = "T3"
            else:
                print_msg("error, should not come here 1, after_o3_case_6", 0, "red")

            if small_o2inst.counter_update_type == COUNTER_UPDATE_TYPE_CM:
                cu_type += "_T2"
            elif small_o2inst.counter_update_type == COUNTER_UPDATE_TYPE_PCSA:
                cu_type += "_T5"
            else:
                print_msg("error, should not come here 2, after_o3_case_6", 0, "red")

            if type == "init":
                f.write(f'        {cu_type}_KEY_UPDATE_{flowkey_code}_{max_width}(32w0x30243f0b) update_{id}_{row};\n')
            else:
                if cu_type == "T2_T2": 
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, {flowsize_str_2}, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T2_T5":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_bitmask, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T3_T2":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_res_hash[{row-1}:{row-1}], {flowsize_str_2}, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T3_T5":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_res_hash[{row-1}:{row-1}], ig_md.d_{id}_bitmask, ig_md.d_{id}_est_{row});\n')
            row += 1

    while row <= max_r:
        big_width, _ = big_o2a_inst.get_max_width_level(row)
        width_len = int(math.log2(big_width))
        cu_type = ""
        if big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CM:
            cu_type = "T2"
        elif big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CS:
            cu_type = "T3"
        else:
            print_msg("error, should not come here 1, after_o3_case_6", 0, "red")
        if type == "init":
            f.write(f'        {cu_type}_KEY_UPDATE_{flowkey_code}_{int(big_width)}(32w0x30243f0b) update_{id}_{row};\n')
        else:
            if cu_type == "T2":
                f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_est_{row});\n')
            else:
                f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_res_hash[{row-1}:{row-1}], ig_md.d_{id}_est_{row});\n')
        row += 1

    if type == "init":
        f.write("    //\n\n")
    else:
        f.write(f"            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_{max_r}({id})\n")
        f.write("        //\n\n")

# (ENT or PCSA) - (CM/KARY/ENT or CS or PCSA)
def after_o3_case_7(f, type, o2o3_inst, o5_writer, o1_result):
    flowkey_code, flowkey_str, keylen, big_o2a_inst, max_r = common_o3(o2o3_inst)
    id = big_o2a_inst.sketch_inst_list[0].id

    if type == "init":
        f.write("    // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA \n")
    else:
        f.write("        // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA \n")


    if big_o2a_inst.flowsize == 1:
        flowsize_str_2 = "1"
    else:
        flowsize_str_2 = "SIZE"

    # # if type == "init":
    # #     f.write(f"        ABOVE_THRESHOLD_CONSTANT_{max_r}(100) d_{id}_above_threshold;\n")

    # Ready for PCSA
    pcsa_flag = False
    for o2inst in [big_o2a_inst] + o2o3_inst.small_o2a_inst_list:
        if o2inst.counter_update_type == COUNTER_UPDATE_TYPE_PCSA:
            fid = find_id_in_o1_result(o2inst.sketch_inst_list[0].id, o1_result)
            pcsa_flag = True


    if pcsa_flag:
        if type == "init":
            # f.write(f'        COMPUTE_HASH_{flowkey_code}_32_32(32w0x30244f0b) d_{id}_hash_call;\n')
            f.write(f'        TCAM_LPM_HLLPCSA() d_{id}_tcam_lpm;\n')
            f.write(f'        GET_BITMASK() d_{id}_get_bitmask;\n')
        else:
            # f.write(f'            d_{id}_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_32);\n')
            f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_32, ig_md.d_{id}_level);\n')
            f.write(f'            d_{id}_get_bitmask.apply(ig_md.d_{id}_level, ig_md.d_{id}_bitmask);\n')

    # Ready for CS
    cs_flag = False
    for small_o2inst in o2o3_inst.small_o2a_inst_list:
        if small_o2inst.counter_update_type == COUNTER_UPDATE_TYPE_CS:
            cs_flag = True

    if cs_flag:
        if type == "init":
            f.write(f'        COMPUTE_HASH_{flowkey_code}_16_16(32w0x30244f0b) d_{id}_res_hash_call;\n')
        else:
            f.write(f'            d_{id}_res_hash_call.apply({flowkey_str}, ig_md.d_{id}_res_hash);\n')



    row = 1
    for small_o2inst in o2o3_inst.small_o2a_inst_list:
        small_max_r = small_o2inst.get_max_r()
        small_id = small_o2inst.sketch_inst_list[0].id
        start_row = row
        if type == "init":
            if small_o2inst.get_counter_dp_type():
                f.write(f"        ABOVE_THRESHOLD_CONSTANT_{small_max_r}(100) d_{small_id}_above_threshold;\n")
                o5_writer.add(small_id, o2o3_inst.flowkey)

        for small_row in range(1, small_o2inst.get_max_r()+1):
            big_width, _ = big_o2a_inst.get_max_width_level(row)
            small_width, _ = small_o2inst.get_max_width_level(small_row)
            max_width = int(max(big_width, small_width))
            width_len = int(math.log2(max_width))
            if small_o2inst.flowsize == 1:
                flowsize_str_1 = "1"
            else:
                flowsize_str_1 = "SIZE"

            cu_type = ""

            if small_o2inst.counter_update_type == COUNTER_UPDATE_TYPE_CM: # CM/Kary/Ent
                cu_type += "T2"
            elif small_o2inst.counter_update_type == COUNTER_UPDATE_TYPE_CS: # CS
                cu_type += "T3"
            elif small_o2inst.counter_update_type == COUNTER_UPDATE_TYPE_PCSA: # PCSA
                cu_type += "T5"
            else:
                print_msg("error, should not come here 2, after_o3_case_6", 0, "red")

            if big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CM: # ENT
                cu_type += "_T2"
            elif big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_PCSA: # PCSA
                cu_type += "_T5"
            else:
                print_msg("error, should not come here 1, after_o3_case_6", 0, "red")


            if type == "init":
                f.write(f'        {cu_type}_KEY_UPDATE_{flowkey_code}_{max_width}(32w0x30243f0b) update_{id}_{row};\n')
            else:
                if cu_type == "T2_T2": 
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, {flowsize_str_2}, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T2_T5":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_bitmask, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T3_T2":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_res_hash[{row-1}:{row-1}], {flowsize_str_2}, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T3_T5":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_res_hash[{row-1}:{row-1}], ig_md.d_{id}_bitmask, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T5_T2":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_2}, ig_md.d_{id}_bitmask, ig_md.d_{id}_est_{row});\n')
                elif cu_type == "T5_T5":
                    f.write(f'            update_{id}_{row}.apply({flowkey_str}, ig_md.d_{id}_bitmask, ig_md.d_{id}_est_{row});\n')
            row += 1

        if type != "init":
            if small_o2inst.get_counter_dp_type():    
                f.write(f"            d_{small_id}_above_threshold.apply(")
                for small_row in range(start_row, start_row+small_max_r):
                    f.write(f"ig_md.d_{id}_est_{small_row}, ")
                f.write(f"ig_md.d_{small_id}_above_threshold);\n")

    while row <= max_r:
        big_width, _ = big_o2a_inst.get_max_width_level(row)
        width_len = int(math.log2(big_width))
        cu_type = ""
        if big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_CM:
            cu_type = "T2"
        elif big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_PCSA:
            cu_type = "T5"
        else:
            print_msg("error, should not come here 1, after_o3_case_6", 0, "red")
        if type == "init":
            f.write(f'        {cu_type}_KEY_UPDATE_{flowkey_code}_{int(big_width)}(32w0x30243f0b) update_{id}_{row};\n')
        else:
            if cu_type == "T2":
                f.write(f'            update_{id}_{row}.apply({flowkey_str}, {flowsize_str_1}, ig_md.d_{id}_est_{row});\n')
            else:
                f.write(f'            update_{id}_{row}.apply({flowkey_str}, ig_md.d_{id}_bitmask);\n')
        row += 1

    if type == "init":
        f.write("    //\n\n")
    else:
        f.write("        //\n\n")


def write_after_process_hash(f, type, o1_inst, o5_writer):
    if o1_inst.__class__.__name__ == "HashReuseSketchInstance":
        id = o1_inst.get_id()
        flowkey_code = get_flowkey_code(o1_inst.flowkey)
        flowkey_str = get_flowkey_str(o1_inst.flowkey)
        if type == "init":
            if o1_inst.level_hash == 1:
                f.write(f'        COMPUTE_HASH_{flowkey_code}_16_16(32w0x30244f0b) d_{id}_auto_sampling_hash_call;\n\n')
            else:
                f.write(f'        COMPUTE_HASH_{flowkey_code}_32_32(32w0x30244f0b) d_{id}_auto_sampling_hash_call;\n\n')
        else:
            if o1_inst.level_hash == 1:
                f.write(f'            d_{id}_auto_sampling_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_16);\n\n')
            else:
                f.write(f'            d_{id}_auto_sampling_hash_call.apply({flowkey_str}, ig_md.d_{id}_sampling_hash_32);\n\n')
    else:
        inst_1 = o1_inst.big_o1a_inst
        inst_2 = o1_inst.small_o1a_inst_1
        inst_3 = o1_inst.small_o1a_inst_2

        id_1 = inst_1.get_id()
        id_2 = inst_2.get_id()
        id_3 = inst_3.get_id()

        flowkey_code_1 = get_flowkey_code(inst_1.flowkey)
        flowkey_str_1 = get_flowkey_str(inst_1.flowkey)

        flowkey_code_2 = get_flowkey_code(inst_2.flowkey)
        flowkey_str_2 = get_flowkey_str(inst_2.flowkey)

        flowkey_code_3 = get_flowkey_code(inst_3.flowkey)
        flowkey_str_3 = get_flowkey_str(inst_3.flowkey)

        if type == "init":
            if o1_inst.level_hash == 1:
                f.write(f'        COMPUTE_HASH_{flowkey_code_2}_16_16(32w0x30244f0b) d_{id_2}_auto_sampling_hash_call;\n')
                f.write(f'        COMPUTE_HASH_{flowkey_code_3}_16_16(32w0x30244f0b) d_{id_3}_auto_sampling_hash_call;\n')
                f.write(f'        action d_{id_1}_xor_construction() {{ ig_md.d_{id_1}_sampling_hash_16 = ig_md.d_{id_2}_sampling_hash_16 ^ ig_md.d_{id_3}_sampling_hash_16; }}\n\n')
            else:
                f.write(f'        COMPUTE_HASH_{flowkey_code_2}_32_32(32w0x30244f0b) d_{id_2}_auto_sampling_hash_call;\n')
                f.write(f'        COMPUTE_HASH_{flowkey_code_3}_32_32(32w0x30244f0b) d_{id_3}_auto_sampling_hash_call;\n')
                f.write(f'        action d_{id_1}_xor_construction() {{ ig_md.d_{id_1}_sampling_hash_32 = ig_md.d_{id_2}_sampling_hash_32 ^ ig_md.d_{id_3}_sampling_hash_32; }}\n\n')

        else:
            if o1_inst.level_hash == 1:
                f.write(f'            d_{id_2}_auto_sampling_hash_call.apply({flowkey_str_2}, ig_md.d_{id_2}_sampling_hash_16);\n')
                f.write(f'            d_{id_3}_auto_sampling_hash_call.apply({flowkey_str_3}, ig_md.d_{id_3}_sampling_hash_16);\n')
            else:
                f.write(f'            d_{id_2}_auto_sampling_hash_call.apply({flowkey_str_2}, ig_md.d_{id_2}_sampling_hash_32);\n')
                f.write(f'            d_{id_3}_auto_sampling_hash_call.apply({flowkey_str_3}, ig_md.d_{id_3}_sampling_hash_32);\n')
            f.write(f'            d_{id_1}_xor_construction();\n')


def write_after_process(f, type, o2o3_inst, o5_writer, o1_result):
    if o2o3_inst.__class__.__name__ == "SALUReuseSketchInstance":
        o2_inst = o2o3_inst
        first_inst = o2_inst.sketch_inst_list[0]
        if len(o2_inst.sketch_inst_list) == 1:
            if type == "init":
                msg = get_init_msg(first_inst, o5_writer)
                f.write("    " + msg + "\n")
            else: # run
                id = first_inst.id
                flowkey_str = get_flowkey_str(first_inst.flowkey)
                flowkey_code = get_flowkey_code(first_inst.flowkey)
                keylen = len(first_inst.flowkey)
                if first_inst.flowsize == 1:
                    flowsize_str = "1"
                else:
                    flowsize_str = "SIZE"


                if first_inst.sketch.name == "HLL":
                    fid = find_id_in_o1_result(id, o1_result)
                    f.write(f'        // HLL for inst {id}\n')
                    f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_32, ig_md.d_{id}_level);\n')
                    f.write(f'            update_{id}_1.apply({flowkey_str}, ig_md.d_{id}_level);\n')
                    f.write(f'        //\n\n')

                elif first_inst.sketch.name == "PCSA":
                    fid = find_id_in_o1_result(id, o1_result)
                    f.write(f'        // PCSA for inst {id}\n')
                    f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_32, ig_md.d_{id}_level);\n')
                    f.write(f'            d_{id}_get_bitmask.apply(ig_md.d_{id}_level, ig_md.d_{id}_bitmask);\n')
                    f.write(f'            update_{id}_1.apply({flowkey_str}, ig_md.d_{id}_bitmask);\n')
                    f.write(f'        //\n\n')

                elif first_inst.sketch.name == "MRB":
                    fid = find_id_in_o1_result(id, o1_result)
                    f.write(f'        // MRB for inst {id}\n')
                    f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_16, ig_md.d_{id}_base_32);\n')
                    f.write(f'            d_{id}_index_hash_call_1.apply({flowkey_str}, ig_md.d_{id}_index1_16);\n')
                    f.write(f'            update_{id}_1.apply(ig_md.d_{id}_base_32, ig_md.d_{id}_index1_16);\n')
                    f.write(f'        //\n\n')

                elif first_inst.sketch.name == "MRAC":
                    fid = find_id_in_o1_result(id, o1_result)
                    f.write(f'        // MRAC for inst {id}\n')
                    f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_16, ig_md.d_{id}_base_16);\n')
                    f.write(f'            d_{id}_index_hash_call_1.apply({flowkey_str}, ig_md.d_{id}_index1_16);\n')
                    f.write(f'            update_{id}_1.apply(ig_md.d_{id}_base_16, ig_md.d_{id}_index1_16);\n')
                    f.write(f'        //\n\n')

                elif first_inst.sketch.name == "UnivMon":
                    fid = find_id_in_o1_result(id, o1_result)
                    f.write(f'        // UnivMon for inst {id}\n')
                    f.write(f'            d_{id}_res_hash_call.apply({flowkey_str}, ig_md.d_{id}_res_hash); \n')
                    f.write(f'            d_{id}_tcam_lpm.apply(ig_md.d_{fid}_sampling_hash_16, ig_md.d_{id}_base_16, ig_md.d_{id}_threshold); \n')
                    for row in range(1, first_inst.row+1):
                        f.write(f'            d_{id}_index_hash_call_{row}.apply({flowkey_str}, ig_md.d_{id}_index{row}_16); \n')
                    f.write(f'            UM_RUN_END_{first_inst.row}({id}, ig_md.d_{id}_res_hash, {flowsize_str}) \n')
                    f.write(f'            RUN_HEAVY_FLOWKEY_NOIF_{first_inst.row}({id}) \n')
                    f.write(f'        //\n\n')
                else:
                    msg = get_run_msg("after", first_inst)
                    f.write("        " + msg + "\n")

        else: # O2

            if o2_inst.counter_update_type == COUNTER_UPDATE_TYPE_BITMAP:
                after_o2_case_1(f, type, o2_inst, o5_writer)
    
            elif o2_inst.counter_update_type == COUNTER_UPDATE_TYPE_CM:
                after_o2_case_2(f, type, o2_inst, o5_writer)

            else:
                print_msg("error, this shouldn't happen at code generator", 0, "red")
                exit(1)

    else: # O3
        big_o2a_inst = o2o3_inst.big_o2a_inst
        if o2o3_inst.big_index_type == INDEX_COMPUTING_TYPE_2: # multi-level sketches
            if big_o2a_inst.get_counter_dp_type():
                after_o3_case_1(f, type, o2o3_inst, o5_writer, o1_result)
            else:
                after_o3_case_2(f, type, o2o3_inst, o5_writer, o1_result)

        else: # single-level sketches
            if big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_BITMAP:
                print_msg("bitmap type HashMerge shouldn't be happen, exit", 0, "red")
                exit(1)
                # if big_o2a_inst.get_counter_dp_type():
                #     after_o3_case_3(f, type, o2o3_inst, o5_writer)
                # else:
                #     after_o3_case_4(f, type, o2o3_inst, o5_writer)
            elif big_o2a_inst.counter_update_type == COUNTER_UPDATE_TYPE_HLL:
                after_o3_case_5(f, type, o2o3_inst, o5_writer, o1_result)
            else:
                if big_o2a_inst.get_counter_dp_type():
                    after_o3_case_6(f, type, o2o3_inst, o5_writer, o1_result)
                else:
                    after_o3_case_7(f, type, o2o3_inst, o5_writer, o1_result)




def write_after_p4_code(f, picked_sample, o1_result, o2_result, o3_result):

    o5_writer = O5_Writer(o3_result)

    total_len = len(picked_sample)

    # init metadata
    f.write(code_part_1)
    for i in range(1, total_len+1):
        f.write('    METADATA_DIM(%d)\n' % i)

    # include headers
    f.write(code_part_2_1)
    if o5_writer.is_valid():
        import math
        ht_size = o5_writer.o5_inst.getHashTableSize()
        ht_bitlen = int(math.log2(ht_size))
        em_size = o5_writer.o5_inst.getMatchTableSize()
        f.write(f"INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_{o5_writer.flowkey_code}({ht_size}, {ht_bitlen}, {em_size})\n")
    f.write(code_part_2_2)

    # init O1 hashes
    f.write("\n    // O1 hash init\n")
    for o1_inst in o1_result:
        write_after_process_hash(f, "init", o1_inst, o5_writer)
    f.write("    //\n\n")

    # init O2 stuffs
    for o2o3_inst in o2_result:
        write_after_process(f, "init", o2o3_inst, o5_writer, o1_result)

    # init O3 stuffs
    f.write(o5_writer.init_msg() + "\n")

 
    f.write('\n\n\n    apply {\n')


    # run O1 hashes
    f.write("        // O1 hash run\n")
    for o1_inst in o1_result:
        write_after_process_hash(f, "run", o1_inst, o5_writer)
    f.write("        //\n\n")

    # run O2 counter updates
    for o2o3_inst in o2_result:
        write_after_process(f, "run", o2o3_inst, o5_writer, o1_result)

    # run O3 hfs
    f.write(o5_writer.run_msg() + "\n")

    for i in range(1, 10):
        f.write('        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_%d.apply(hdr, ig_tm_md); }\n' % i)
        f.write('        else { l3_%d.apply(hdr, ig_tm_md); }\n' % i)
        f.write('        acl_%d.apply(hdr, ig_dprsr_md);\n' % i)

    f.write(code_part_3)
