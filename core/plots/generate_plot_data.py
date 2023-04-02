import os
import argparse

from lib.pkl_saver import PklSaver

from lib.run_parallel_helper import ParallelRunHelper
helper = ParallelRunHelper(70)

argparser = argparse.ArgumentParser(description="data generator")
argparser.add_argument('--input', type=str)
argparser.add_argument('--output', type=str)
args = argparser.parse_args()

from plots.lib.data_process import *

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

def run_analysis(input_folder, output_folder, pkl_name):
    output_data = data_read(input_folder, pkl_name)

    data = {}
    data["time"] = data_parse_time(output_data)
    df_list, mean_df = data_parse_breakdown(output_data)
    data["df_list"] = df_list
    data["mean_df"] = mean_df
    out_saver = PklSaver(output_folder, pkl_name)
    out_saver.save(data)
    # print(mean_df)


def run_analysis_folder(input_folder, output_folder):
    global helper
    for pkl_name in sorted(os.listdir(input_folder)):
        if ".pkl" in pkl_name:
            print(input_folder, pkl_name)
            # run_analysis(input_folder, output_folder, pkl_name)
            # exit(1)
            # exit(1)
            # if "workload" in input_folder:
                # print(input_folder, pkl_name)
            # run_analysis(input_folder, output_folder, pkl_name)
            helper.call(run_analysis, (input_folder, output_folder, pkl_name, ))


for workload_name in sorted(os.listdir(args.input)):
    print(workload_name)
    # if workload_name.startswith("workload"):
    for run_name in ["gd"]:
    # for run_name in ["tse"]:
    # for run_name in ["tse", "gd"]:
        if run_name == "gd":
            input_folder = os.path.join(args.input, workload_name, run_name)
            for timeout_name in sorted(os.listdir(input_folder)):
                if "_" in timeout_name and timeout_name == "5_5":
                    input_folder = os.path.join(args.input, workload_name, run_name, timeout_name)
                    output_folder = os.path.join(args.output, workload_name, run_name, timeout_name)
                    run_analysis_folder(input_folder, output_folder)
                    # exit(1)
        else:
            input_folder = os.path.join(args.intput, workload_name, run_name)
            output_folder = os.path.join(args.output, workload_name, run_name)
            run_analysis_folder(input_folder, output_folder)
