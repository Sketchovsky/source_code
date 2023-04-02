from lib.pkl_saver import PklSaver
from strategy_finder.obj_func import *
from lib.inst_list import *
from lib.logging import print_msg
import pandas as pd
pd.set_option("display.max_columns", 50)
pd.options.display.width = 0
# pd.reset_option('display.float_format')
pd.options.display.float_format = '{:.2f}'.format

def data_parse_time(data_list):
    time_list = []
    for (data_sample, o1_data, o2_data, o3_data) in data_list:
        time_list.append(o1_data[1] + o2_data[1] + o3_data[1])
    return time_list

# def data_parse_time(data_dict):
#     time_list = []
#     for o1o4, o5 in zip(data_dict['o1o4'], data_dict['o5']):
#         time_list.append(o5[0] + o1o4[0])
#     return time_list
#     # return sum(time_list)/len(time_list)


def data_parse_breakdown(data_list):

    count = 0
    df_list = []
    for (data_sample, o1_data, o2_data, o3_data) in data_list:
        count += 1
        (o1_result, o1_time) = o1_data
        (o2_result, o2_time) = o2_data
        (o3_result, o3_time) = o3_data

        o1_df = empty_df()
        for opt_inst in o1_result:
            o1_df += opt_inst.objective_function_breakdown()
        sanity_check(o1_df)

        o2_df = empty_df()
        for opt_inst in o2_result:
            o2_df += opt_inst.objective_function_breakdown()
        sanity_check(o2_df)

        before = compute_heavy_hitter_baseline(data_sample)
        if o3_result == None:
            after = empty_series()
        else:
            after = o3_result.objective_function()
        o3_df = create_o3_df(before, after)

        df = merge_o1o2_o3(o1_df+o2_df, o3_df)
        df_list.append(df)

    mean_df = df_list[0].copy()
    for i in range(1, len(df_list)):
        mean_df += df_list[i]
    mean_df /= len(df_list)

    return df_list, mean_df

# def data_parse_breakdown(data_dict):

#     count = 0
#     o1o4_list = []
#     for (time, data_sample, result) in data_dict['o1o4']:
#         count += 1
#         # if count == 11:
#         #     break
#         # if count % 100 == 0:
#         #     print(count)
        # df = empty_df()
        # for opt_inst in result:
        #     df += opt_inst.objective_function_breakdown()
        # sanity_check(df)
        # o1o4_list.append(df)
#         #             before      after        O1   O2         O3         O4
#         # hashcall  86.111111  61.111111  5.555556  0.0   9.722222   9.722222
#         # salu      81.250000  58.333333  0.000000  0.0  14.583333   8.333333
#         # sram      30.104167  44.895833  0.000000  0.0  -3.958333 -10.833333

#     count = 0
#     o5_list = []
#     for (time, data_sample, result) in data_dict['o5']:
#         count += 1
#         # if count == 11:
#         #     break
#         # if count % 100 == 0:
#         #     print(count)
#         # print(count)
#         before = compute_heavy_hitter_baseline(data_sample)
#         if result == None:
#             after = empty_series()
#         else:
#             after = result.objective_function()
#         df = create_o3_df(before, after)
#         o5_list.append(df)
#         # print(df)
#         #             before      after        O5 
#         # hashcall  86.111111  61.111111  5.555556
#         # salu      81.250000  58.333333  0.000000
#         # sram      30.104167  44.895833  0.000000

#     df_list = []
#     for o1o4_df, o5_df in zip(o1o4_list, o5_list):
#         df = merge_o1o2_o3(o1o4_df, o5_df)
#         df_list.append(df)
#         # print(df)
#         #               before      after        O1   O2         O3        O4         O5
#         # hashcall  106.944444  73.611111  4.166667  0.0  13.888889  2.777778  12.500000
#         # salu      127.083333  79.166667  0.000000  0.0  20.833333  8.333333  18.750000
#         # sram       23.020833  31.250000  0.000000  0.0  -1.041667 -7.083333  -0.104167
    
#     mean_df = df_list[0].copy()
#     for i in range(1, len(df_list)):
#         mean_df += df_list[i]
#     mean_df /= len(df_list)

#     return df_list, mean_df






# def workload1_pick(data_dict):
#     count = 0
#     o1o4_list = []

#     sketch_count_check = {}
#     instance_index = []

#     for (time, data_sample, result) in data_dict['o1o4']:
#         count += 1
#         if count % 20 == 0:
#             print_msg(count, 10, "white")
        
#         sketch_name = data_sample[0].sketch.name
#         statistic = data_sample[0].sketch.statistic
#         if sketch_name not in sketch_count_check:
#             sketch_count_check[sketch_name] = 0

#         if sketch_count_check[sketch_name] >= 100:
#             continue

#         sketch_count_check[sketch_name]+=1
#         instance_index.append(count)

#         df = empty_df()
#         for opt_inst in result:
#             df += opt_inst.objective_function_breakdown()
#         sanity_check(df)

#         # if statistic == STATISTIC_TYPE_CARDINALITY:
#         #     o1o4_list.append(df/4)
#         # elif statistic == STATISTIC_TYPE_MEMBERSHIP:
#         #     o1o4_list.append(df/2)
#         # elif statistic == STATISTIC_TYPE_HEAVY_HITTER:
#         #     o1o4_list.append(df/2)
#         # else:
#         o1o4_list.append(df)
        
#         # o1o4_list.append(df)
#         # print(df)

#     # for k,v in sketch_count_check.items():
#     #     print(k, v)
#     # print(len(sketch_count_check.keys()))

#     count = 0
#     o5_list = []
#     for (time, data_sample, result) in data_dict['o5']:
#         count += 1
#         if count not in instance_index:
#             continue

#         sketch_name = data_sample[0].sketch.name

#         before = compute_heavy_hitter_baseline(data_sample)
#         if result == None:
#             after = empty_series()
#         else:
#             after = result.objective_function()
#         df = create_o3_df(before, after)
#         # if statistic == STATISTIC_TYPE_CARDINALITY:
#         #     o5_list.append(df/4)
#         # elif statistic == STATISTIC_TYPE_MEMBERSHIP:
#         #     o5_list.append(df/2)
#         # elif statistic == STATISTIC_TYPE_HEAVY_HITTER:
#         #     o5_list.append(df/2)
#         # else:
#         o5_list.append(df)
#         # o5_list.append(df)
#         # print(df)



#     # for k,v in sketch_count_check.items():
#     #     print(k, v)
#     # print(len(sketch_count_check.keys()))
