from lib.pkl_saver import PklSaver
from lib.inst_list import *
import argparse

argparser = argparse.ArgumentParser(description="data peek")
argparser.add_argument('--folder', type=str)
argparser.add_argument('--filename', type=str)
args = argparser.parse_args()


print("[load input]")
input_saver = PklSaver(args.folder, args.filename)
if input_saver.file_exist():
    input_workload_dict = input_saver.load()


    print("[success]")
    for key, value in input_workload_dict.items():
        print("-" * 10 + "["+ key + "]" + "-" * 10)
        print(len(value))
        for i, inst_list in enumerate(value, 1):
            print_inst_list(sort_inst_list(inst_list))
            if i == 1:
                break

    for key, value in input_workload_dict.items():
        sketch_dict = {}
        for inst_list in value:
            for inst in inst_list:
                if inst.sketch.name not in sketch_dict.keys():
                    sketch_dict[inst.sketch.name] = 1
                else:
                    sketch_dict[inst.sketch.name] += 1
        print(args.filename, key)
        sketch_list = ['BloomFilter'] + ['LinearCounting', 'MRB', 'PCSA', 'HLL'] + ['CountSketch', 'CountMin'] + ['Kary'] + ['Entropy'] + ['UnivMon'] + ['MRAC']
        sum = 0
        for k in sketch_list:
            if k in sketch_dict:
                sum += sketch_dict[k]
            else:
                sketch_dict[k] = 0
        groups = [['BloomFilter'], ['LinearCounting', 'MRB', 'PCSA', 'HLL'], ['CountSketch', 'CountMin'], ['Kary'], ['Entropy'], ['UnivMon'], ['MRAC']]
        for group in groups:
            # total = 0
            for k in group:
                print("%30s %3.1f %%" % (k, sketch_dict[k]/sum*100))
            print("\n")
                # total += sketch_dict[k]/sum*100
            # print("%30s %3d %% \n\n" % ("group total", total))

        print()
        print()

else:
    print("Workload not exist, exit")
    exit(1)
