import os
import sys
import argparse
import numpy as np

from lib.pkl_saver import PklSaver
from lib.run_parallel_helper import ParallelRunHelper
from lib.logging import print_msg
from lib.inst_list import *

helper = ParallelRunHelper(70)

argparser = argparse.ArgumentParser(description="data generator")
argparser.add_argument('--output', type=str)
argparser.add_argument('--result', type=str)
args = argparser.parse_args()

print(args)


def data_read(out, filename):
    print(f"[load output] {out} {filename}")
    out_saver = PklSaver(out, filename)
    if out_saver.file_exist():
        output_dict = out_saver.load()
        # for k, v in output_dict.items():
        #     print(k, len(v))
        print("[success]")
    else:
        print("No output file, exit")
        exit(1)
    return output_dict

# # print out
# # 1) resource usage, picked sample, sample resource usage, strategy -> sample.txt
# # 2) p4 code -> p4code.p4
# def pick_data_sample(data_dict, df, df_list, sample_folder):
#     i = -1
#     min = 9999999999
#     index = 0
#     for new_df in df_list:
#         i += 1
#         diff = df - new_df
#         sum = np.square(diff).sum().sum()
#         if "workload_1" in sample_folder:
#             # print(data_dict['o1o4'][i][1][0].sketch.name)
#             if data_dict['o1o4'][i][1][0].sketch.name != "CountMin" and data_dict['o1o4'][i][1][0].sketch.name != "Kary":
#                 continue
#         if min > abs(sum):
#             min = abs(sum)
#             index = i
#             picked_df = new_df

#     picked_sample = data_dict['o1o4'][index][1]
#     picked_answer = data_dict['o1o4'][index][2]
#     picked_o5 = data_dict['o5'][index][2]

#     ret = {}
#     ret["min"] = min
#     ret["picked_df"] = picked_df
#     ret["picked_sample"] = picked_sample
#     ret["picked_answer"] = picked_answer
#     ret["picked_o5"] = picked_o5

#     return ret

# def run_data_sample(output_folder, result_folder, sample_folder, pkl_name, p4_code_name):
#     # num_sketch_insts = int(pkl_name.split(".pkl")[0])
#     # sample_folder_path = os.path.join(sample_folder, "%02d" % num_sketch_insts)

#     num_sketch_insts = pkl_name.split(".pkl")[0]
#     sample_folder_path = os.path.join(sample_folder, num_sketch_insts)

#     print(sample_folder_path)
#     os.makedirs(sample_folder_path, exist_ok=True)
#     data_dict = data_read(output_folder, pkl_name)
#     result_data = data_read(result_folder, pkl_name)
#     df = result_data["mean_df"]
#     df_list = result_data["df_list"]
    
#     # for sample_number in range(1, 11):
#     #     sample_folder_path_full = os.path.join(sample_folder_path, "%02d" % sample_number)
#     f = open(os.path.join(sample_folder_path, "sample.txt"), "w")

#     msg_level = 10

#     print_msg("[mean_df]", msg_level, "white")
#     f.write("[mean_df]\n")

#     print_msg("\n" + df.to_string() + "\n", msg_level, "white")
#     # print(df.to_string())
#     f.write(df.to_string() + "\n\n")

#     print_msg("[ratio]", msg_level, "white")
#     f.write("[ratio]\n")
#     ratio = (df["before"] - df["after"]) / df["before"] * 100
#     print_msg("\n" + ratio.to_string() + "\n", msg_level, "white")
#     f.write(ratio.to_string() + "\n\n")

#     ret = pick_data_sample(data_dict, df, df_list, sample_folder)
#     picked_df = ret["picked_df"]
#     picked_sample = ret["picked_sample"]
#     picked_answer = ret["picked_answer"]
#     picked_o5 = ret["picked_o5"]
    
#     print_msg("[picked sample]", msg_level, "white")
#     f.write("[picked sample]\n")

#     msg = "min diff : %d" % ret["min"]
#     print_msg(msg, msg_level, "white")
#     f.write(msg + "\n\n")

#     print_msg("\n" + picked_df.to_string(), msg_level, "white")
#     f.write(picked_df.to_string() + "\n\n")

#     ratio = ((picked_df["before"] - picked_df["after"]) / picked_df["before"] * 100)
#     print_msg("\n" + ratio.to_string(), msg_level, "white")
#     f.write(ratio.to_string() + "\n")

#     from lib.logging import print_inst_list_msg, print_answer_list_msg
#     print_inst_list_msg(picked_sample, msg_level)
#     print_answer_list_msg(picked_answer, msg_level)
    
#     file_print_inst_list(f, picked_sample)
#     file_print_answer_list(f, picked_answer)

#     f.close()

#     f = open(os.path.join(sample_folder_path, "resource.txt"), "w")
#     f.write(picked_df.to_string() + "\n\n")

#     f.write("hashcall (total 72 = 6 x 12)\n")
#     hashcall_count = picked_df.loc["hashcall"] * 72 / 100
#     f.write(hashcall_count.to_string() + "\n\n")

#     f.write("salu (total 48 = 4 x 12)\n")
#     salu_count = picked_df.loc["salu"] * 48 / 100
#     f.write(salu_count.to_string() + "\n\n")

#     f.write("sram (total 960 = 80 x 12)\n")
#     sram_count = picked_df.loc["sram"] * 960 / 100
#     f.write(sram_count.to_string() +  "\n\n")
#     f.close()


#     import math, json
#     print(sample_folder_path)
#     workload_name = os.path.basename(os.path.dirname(sample_folder_path))
#     sketch_num_str = os.path.basename(sample_folder_path)
#     # print(workload_name)
#     # print(sketch_num_str)
#     for bf in ["before", "after"]:
#         folder_name = f"p416_{workload_name}_{sketch_num_str}_{bf}_0_tofino1"
#         resource_json_path = os.path.join("/home/hnamkung/barefoot/bf-sde-9.5.1/build/p4-build/", folder_name, "tofino", folder_name, "pipe/logs/resources.json")
#         if os.path.exists(resource_json_path):
#             print("file exist")
#             print(resource_json_path)
#             f = open(resource_json_path)
#             data = json.load(f)
#             hash_calls = 0
#             salus = 0
#             if len(data["resources"]["mau"]["mau_stages"]) > 1:
#                 for mau in data["resources"]["mau"]["mau_stages"]:
#                     hash_calls += len(mau["hash_distribution_units"]["units"])
#                     salus += len(mau["meter_alus"]["meters"])
#                 flag = True
#                 if hash_calls != round(hashcall_count[bf]):
#                     flag = False
#                     print_msg("error! hash call count does not match", 0, "red")
#                     print_msg("%d != %d" % (round(hashcall_count[bf]), hash_calls), 0, "red")
#                     print_msg(resource_json_path, 0, "red")
#                 if salus != round(salu_count[bf]):
#                     print_msg("error! hash call count does not match", 0, "red")
#                     print_msg("%d != %d" % (round(salu_count[bf]), salus), 0, "red")
#                     print_msg(resource_json_path, 0, "red")
#                     flag = False
#                 if flag:
#                     print_msg("sanity check pass %s" % folder_name, 0, "green")


#     # before_code_name = p4_code_name + "_%s_before_0.p4" % num_sketch_insts
#     before_code_name = p4_code_name + "_%02d_before_0.p4" % num_sketch_insts
#     f = open(os.path.join(sample_folder_path, before_code_name), "w")
#     write_before_p4_code(f, picked_sample, picked_o5)
#     f.close()

#     # after_code_name = p4_code_name + "_%s_after_0.p4" % num_sketch_insts
#     after_code_name = p4_code_name + "_%02d_after_0.p4" % num_sketch_insts
#     f = open(os.path.join(sample_folder_path, after_code_name), "w")
#     write_after_p4_code(f, picked_sample, picked_answer, picked_o5)
#     f.close()

#     # exit(1)

# print out
# 1) resource usage, picked sample, sample resource usage, strategy -> sample.txt
# 2) p4 code -> p4code.p4
def pick_data_sample(data_list, df_list, sample_folder, sample_number):
    index = -1
    count = 0
    for new_df in df_list:
        index += 1
        if "workload_1" in sample_folder:
            if data_list[index][0][0].sketch.name != "CountMin" and data_list[index][0][0].sketch.name != "Kary":
                continue
        count += 1
        if count == sample_number:
            return index

    print_msg("shouldn't come here pick_data_sample.py", 0, "red")
    exit(1)


def run_data_sample(output_folder, result_folder, sample_folder, pkl_name, p4_code_name):
    from sketchmd_strategy.lib.logging import SELECT_MODE, NORMAL_MODE, TESTCASE_MODE

    if SELECT_MODE == NORMAL_MODE:
        num_sketch_insts = int(pkl_name.split(".pkl")[0])
        sample_folder_path = os.path.join(sample_folder, "%02d" % num_sketch_insts)
    else:
        num_sketch_insts = pkl_name.split(".pkl")[0]
        sample_folder_path = os.path.join(sample_folder, num_sketch_insts)

    # print(sample_folder_path)
    data_list = data_read(output_folder, pkl_name)
    result_data = data_read(result_folder, pkl_name)
    df = result_data["mean_df"]
    df_list = result_data["df_list"]

    for sample_number in range(1, min(len(df_list), 10)+1):
        # print("come?")
        sample_folder_path_full = os.path.join(sample_folder_path, "%02d" % sample_number)
        os.makedirs(sample_folder_path_full, exist_ok=True)
        f = open(os.path.join(sample_folder_path_full, "sample.txt"), "w")

        msg_level = 10

        # print_msg("[mean df]", msg_level, "white")
        # print_msg("\n" + df.to_string() + "\n", msg_level, "white")
        f.write("[mean df]\n")
        f.write(df.to_string() + "\n\n")

        ratio = (df["before"] - df["after"]) / df["before"] * 100
        # print_msg("[mean ratio]", msg_level, "white")
        # print_msg("\n" + ratio.to_string() + "\n", msg_level, "white")
        f.write("[mean ratio]\n")
        f.write(ratio.to_string() + "\n\n")

        picked_index = pick_data_sample(data_list, df_list, sample_folder, sample_number)

        picked_df = df_list[picked_index]

        (picked_sample, o1_data, o2_data, o3_data) = data_list[picked_index]
        (o1_result, o1_time) = o1_data
        (o2_result, o2_time) = o2_data
        (o3_result, o3_time) = o3_data

        # print_msg("[picked sample]", msg_level, "white")
        # print_msg("\n" + picked_df.to_string(), msg_level, "white")
        f.write("[picked sample]\n")
        f.write(picked_df.to_string() + "\n\n")

        ratio = ((picked_df["before"] - picked_df["after"]) / picked_df["before"] * 100)
        # print_msg("[picked ratio]", msg_level, "white")
        # print_msg("\n" + ratio.to_string(), msg_level, "white")
        f.write("[picked ratio]\n")
        f.write(ratio.to_string() + "\n")

        from lib.logging import print_inst_list_msg
        from lib.logging import print_answer_list_msg
        # print_inst_list_msg(picked_sample, msg_level)
        # print_answer_list_msg(o2_result, msg_level)
        
        file_print_inst_list(f, picked_sample)
        f.write("+"* 120 + "\n")
        file_print_answer_list(f, o2_result)
        f.write("+"* 120 + "\n")
        file_print_answer_list(f, o1_result)

        f.close()

        f = open(os.path.join(sample_folder_path_full, "resource.txt"), "w")
        f.write(picked_df.to_string() + "\n\n")

        f.write("hashcall (total 72 = 6 x 12)\n")
        hashcall_count = picked_df.loc["hashcall"] * 72 / 100
        f.write(hashcall_count.to_string() + "\n\n")

        f.write("salu (total 48 = 4 x 12)\n")
        salu_count = picked_df.loc["salu"] * 48 / 100
        f.write(salu_count.to_string() + "\n\n")

        f.write("sram (total 960 = 80 x 12)\n")
        sram_count = picked_df.loc["sram"] * 960 / 100
        f.write(sram_count.to_string() +  "\n\n")
        f.close()


        import math, json
        # print(sample_folder_path)
        workload_name = os.path.basename(os.path.dirname(sample_folder_path))
        sketch_num_str = os.path.basename(sample_folder_path)
        # print(workload_name)
        # print(sketch_num_str)



        # for bf in ["before", "after"]:
        #     folder_name = f"p416_{workload_name}_{sketch_num_str}_" + "%02d" % sample_number + f"_{bf}_0_tofino1"
        #     resource_json_path = os.path.join("/home/hnamkung/barefoot/bf-sde-9.5.1/build/p4-build/", folder_name, "tofino", folder_name, "pipe/logs/resources.json")
        #     # print(resource_json_path)
        #     if os.path.exists(resource_json_path):
        #         # print("file exist")
        #         # print(resource_json_path)
        #         f = open(resource_json_path)
        #         data = json.load(f)
        #         hash_calls = 0
        #         salus = 0
        #         if len(data["resources"]["mau"]["mau_stages"]) > 1:
        #             for mau in data["resources"]["mau"]["mau_stages"]:
        #                 hash_calls += len(mau["hash_distribution_units"]["units"])
        #                 salus += len(mau["meter_alus"]["meters"])
        #             flag = True
        #             if hash_calls != round(hashcall_count[bf]):
        #                 flag = False
        #                 print_msg("error! hash call count does not match", 0, "red")
        #                 print_msg("%d != %d" % (round(hashcall_count[bf]), hash_calls), 0, "red")
        #                 print_msg(resource_json_path, 0, "red")
        #             if salus != round(salu_count[bf]):
        #                 print_msg("error! hash call count does not match", 0, "red")
        #                 print_msg("%d != %d" % (round(salu_count[bf]), salus), 0, "red")
        #                 print_msg(resource_json_path, 0, "red")
        #                 flag = False
        #             if flag:
        #                 print_msg("sanity check pass %s" % folder_name, 0, "green")
        #     else:
        #         print("file not exist")



        # exit(1)



        from code_rewrite.lib.write_before import write_before_p4_code
        from code_rewrite.lib.write_after import write_after_p4_code
    
        if SELECT_MODE == NORMAL_MODE:
            before_code_name = p4_code_name + "_%02d_%02d_before_0.p4" % (num_sketch_insts, sample_number)
        else:
            before_code_name = p4_code_name + "_%s_%02d_before_0.p4" % (num_sketch_insts, sample_number)
        filepath = os.path.join(sample_folder_path_full, before_code_name)
        f = open(filepath, "w")
        print(filepath)

        write_before_p4_code(f, picked_sample, o3_result)
        f.close()

        if SELECT_MODE == NORMAL_MODE:
            after_code_name = p4_code_name + "_%02d_%02d_after_0.p4" % (num_sketch_insts, sample_number)
        else:
            after_code_name = p4_code_name + "_%s_%02d_after_0.p4" % (num_sketch_insts, sample_number)
        filepath = os.path.join(sample_folder_path_full, after_code_name)
        f = open(filepath, "w")
        print(filepath)
        write_after_p4_code(f, picked_sample, o1_result, o2_result, o3_result)
        f.close()

        # exit(1)



def run_data_sample_folder(output_folder, result_folder, sample_folder, p4_code_name):
    print(output_folder)
    print(result_folder)
    print(sample_folder)

    global helper
    from sketchmd_strategy.lib.logging import SELECT_MODE, NORMAL_MODE, TESTCASE_MODE
    for pkl_name in sorted(os.listdir(result_folder)):
        if ".pkl" in pkl_name:

            # if pkl_name == "o3_case1.pkl":
            # run_data_sample(output_folder, result_folder, sample_folder, pkl_name, p4_code_name)
            if SELECT_MODE == NORMAL_MODE:
                int_key = int(pkl_name.split(".pkl")[0])
                if 1 <= int_key and int_key <= 20 and int_key%2 == 0:
                    print(pkl_name.split(".pkl")[0])
                    run_data_sample(output_folder, result_folder, sample_folder, pkl_name, p4_code_name)
            else:
                run_data_sample(output_folder, result_folder, sample_folder, pkl_name, p4_code_name)

    # exit(1)
                # helper.call(run_data_sample, (output_folder, result_folder, sample_folder, pkl_name, p4_code_name, ))
        # if ".pkl" in pkl_name and pkl_name == "o2_case2.pkl":
        #     run_data_sample(output_folder, result_folder, sample_folder, pkl_name, p4_code_name)
        # if ".pkl" in pkl_name and pkl_name == "24.pkl" and "workload_2" in output_folder:
        #     run_data_sample(output_folder, result_folder, sample_folder, pkl_name, p4_code_name)



# for workload_name in sorted(os.listdir(args.output)):
#     print(workload_name)
# exit(1)
for workload_name in sorted(os.listdir(args.output)):
    if "workload_" in workload_name:
        for run_name in ["gd"]:
        # for run_name in ["bf", "gd"]:
            if run_name == "gd":
                output_folder = os.path.join(args.output, workload_name, run_name)
                for timeout_name in sorted(os.listdir(output_folder)):
                    if "_" in timeout_name and timeout_name == "5_5":
                        output_folder = os.path.join(args.output, workload_name, run_name, timeout_name)
                        result_folder = os.path.join(args.result, workload_name, run_name, timeout_name)
                        # sample_folder = os.path.join("samples_epoch", workload_name, run_name, timeout_name)
                        p4_code_name = f"p416_{workload_name}"
                        sample_folder = os.path.join("code_rewrite", "samples_epoch_nfs", run_name, timeout_name, workload_name)
                        run_data_sample_folder(output_folder, result_folder, sample_folder, p4_code_name)
                        # exit(1)
            else:
                output_folder = os.path.join(args.output, workload_name, run_name)
                result_folder = os.path.join(args.result, workload_name, run_name)
                # sample_folder = os.path.join("samples_epoch", workload_name, run_name)
                p4_code_name = f"p416_{workload_name}"
                sample_folder = os.path.join("code_rewrite", "samples_epoch_nfs", run_name, workload_name)
                run_data_sample_folder(output_folder, result_folder, sample_folder, p4_code_name)
    
