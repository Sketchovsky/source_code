from lib.inst_list import print_inst_list, sort_inst_list
from lib.logging import print_msg

from lib.pkl_saver import PklSaver
from sketch_formats.sketch import *
from sketch_formats.sketch_instance import *
from generator import *
import argparse

argparser = argparse.ArgumentParser(description="data generator")
argparser.add_argument('--folder', type=str)
argparser.add_argument('--filename', type=str)
argparser.add_argument('--data_count', type=int)
args = argparser.parse_args()

DATA_COUNT = args.data_count

candidate_input_spec = []
candidate_input_spec_name = []
num_sketch_list = [i for i in range(1, 26)]

# workload 1. same sketch
if args.filename == "workload_1.pkl":
    for i in num_sketch_list:
        default_input = get_default_spec()
        default_input[F1] = 1
        default_input[F8] = i
        candidate_input_spec.append(default_input)
        candidate_input_spec_name.append(i)

# workload 2. same flowkey
if args.filename == "workload_2.pkl":
    for i in num_sketch_list:
        default_input = get_default_spec()
        default_input[F8] = i
        default_input[F9] = 1
        candidate_input_spec.append(default_input)
        candidate_input_spec_name.append(i)

# workload 3. same flowsize
if args.filename == "workload_3.pkl":
    for i in num_sketch_list:
        default_input = get_default_spec()
        default_input[F8] = i
        default_input[F10] = [1]
        candidate_input_spec.append(default_input)
        candidate_input_spec_name.append(i)

# workload 4. same epoch
if args.filename == "workload_4.pkl":
    for i in num_sketch_list:
        default_input = get_default_spec()
        default_input[F8] = i
        default_input[F12] = 1
        candidate_input_spec.append(default_input)
        candidate_input_spec_name.append(i)

# workload 5. random
if args.filename == "workload_5.pkl":
    for i in num_sketch_list:
        default_input = get_default_spec()
        default_input[F8] = i
        candidate_input_spec.append(default_input)
        candidate_input_spec_name.append(i)


saver = PklSaver(args.folder, args.filename)

workload_dict = {}
for input_spec, name in zip(candidate_input_spec, candidate_input_spec_name):
    print_msg(f"name {name}", 0, "white")

    workload_dict[str(name)] = []
    result_list = workload_dict[str(name)]

    # print(DATA_COUNT)

    for i in range(DATA_COUNT):
        if i % 30 == 0:
            print_msg(f"{name} {i+1}", 1, "white")
        else:
            print_msg(f"{name} {i+1}", 6, "white")
        generator = WorkloadGenerator(input_spec)
        while True:
            if generator.generate():
                break
        data = generator.result_inst_list
        j = 0
        for inst in sort_inst_list(data):
            j += 1
            inst.setid(j)
        result_list.append(data)
    print_msg(f"data count: {i+1}", 0, "white")

saver.save(workload_dict)
