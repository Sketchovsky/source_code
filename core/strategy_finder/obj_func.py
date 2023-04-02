import pandas as pd

def empty_series():
    return pd.Series([0, 0, 0, 0], index=["overall", "salu", "hashcall", "sram"])

def empty_df():
    data = {}
    data["before"] = [0, 0, 0]
    data["after"] = [0, 0, 0]
    data["hash_reuse"] = [0, 0, 0]
    data["hash_xor"] = [0, 0, 0]
    data["salu_reuse"] = [0, 0, 0]
    data["salu_merge"] = [0, 0, 0]
    df = pd.DataFrame(data, index=["hashcall", "salu", "sram"])
    return df

def create_o3_df(before, after):
    data = {}
    data["before"] = [before["hashcall"], before["salu"], before["sram"]]
    data["after"] = [after["hashcall"], after["salu"], after["sram"]]
    data["hfs_reuse"] = [before["hashcall"] - after["hashcall"], \
                  before["salu"] - after["salu"], \
                  before["sram"] - after["sram"]]
    df = pd.DataFrame(data, index=["hashcall", "salu", "sram"])
    return df

def merge_o1o2_o3(greedy_df, o3_df):
    new_df = greedy_df.copy()
    new_df["before"] = greedy_df["before"] + o3_df["before"]
    new_df["after"] = greedy_df["after"] + o3_df["after"]
    new_df["hfs_reuse"] = o3_df["hfs_reuse"]
    return new_df

def sanity_check(df):
    # print(df)
    sum = df["after"] + df["hash_reuse"] + df["hash_xor"] + df["salu_reuse"] + df["salu_merge"]
    if df["before"]["hashcall"] - sum["hashcall"] < 0.0001 and \
       df["before"]["salu"] - sum["salu"] < 0.0001 and \
       df["before"]["sram"] - sum["sram"] < 0.0001:
        # print("pass")
        pass
    else:
        print(df)
        print(sum)
        print("sanity check fail, exit!")
        exit(1)
    # print()

def compute_baseline(inst_list):
    from opt.salu_reuse import SALUReuseSketchInstance
    sum = empty_series()
    for inst in inst_list:
        o2a_inst = SALUReuseSketchInstance(inst)
        sum += o2a_inst.objective_function()
    return sum

def compute_baseline_hash(inst_list):
    from opt.hash_reuse import HashReuseSketchInstance
    sum = empty_series()
    for inst in inst_list:
        o1a_inst = HashReuseSketchInstance([inst], False)
        sum += o1a_inst.objective_function()
    return sum

def compute_heavy_hitter_baseline(inst_list):
    from opt.hfs_reuse import HFSReuseSketchInstance
    sum = empty_series()
    for inst in inst_list:
        if inst.sketch.heavy_flowkey_storage == True:
            o3inst = HFSReuseSketchInstance(inst)
            sum += o3inst.objective_function()
    return sum

def compute_objective_function(opt_inst_list):
    sum = empty_series()
    for opt_inst in opt_inst_list:
        sum += opt_inst.objective_function()
    return sum


def get_unique_flowkeys(o2a_inst_list):
    unique_flowkey_dict = {}
    for o2a_inst in o2a_inst_list:
        unique_flowkey_dict[str(o2a_inst.flowkey)] = o2a_inst.flowkey

    ret_list = []
    for k, v in unique_flowkey_dict.items():
        ret_list.append(v)

    return ret_list



def get_relevant_flowkeys(base_flowkey, unique_flowkeys):
    relevant_flowkeys = []
    for flowkey in unique_flowkeys:
        if is_subset(base_flowkey, flowkey) or is_subset(flowkey, base_flowkey):
            relevant_flowkeys.append(flowkey)
    return relevant_flowkeys


def get_two_relevant_flowkeys(base_flowkey, unique_flowkeys):
    two_relevant_flowkeys = []
    length = len(unique_flowkeys)
    for i in range(0, length):
        for j in range(0, length):
            if j <= i:
                continue
            if unique_flowkeys[i] == base_flowkey or unique_flowkeys[j] == base_flowkey:
                continue
            if union_equal(base_flowkey, unique_flowkeys[i], unique_flowkeys[j]):
                two_relevant_flowkeys.append((unique_flowkeys[i], unique_flowkeys[j]))
    return two_relevant_flowkeys


def global_objective_function(hash_call, SALU, SRAM, epoch):
    import math
    hash_call_p = (hash_call / 72) * 100
    SALU_p = (SALU / 48) * 100
    SRAM_p = (SRAM/960) * 100

    c_hash = 1
    c_SALU = 1
    c_SRAM = 1
    c_epoch = 1/10000000
    result = c_hash*hash_call_p + c_SALU*SALU_p + c_SRAM*SRAM_p + c_epoch*epoch
    # print("-"*10 + "obj function" + "-"*10)
    # print("[hashcall %d (%.2f/%.2f)] + [SALU %d (%.2f/%.2f)] + [SRAM %d (%.2f/%.2f)] + [epoch %d (%.2f)] = %.2f" \
    #         % (hash_call, hash_call_p, c_hash*hash_call_p, \
    #           SALU, SALU_p, c_SALU*SALU_p, \
    #           SRAM, SRAM_p, c_SRAM*SRAM_p, \
    #           epoch, c_epoch*epoch, \
    #           result))
    # print("-"*30)
    return result

# meaning flowkey is subset of base_flowkey
def is_subset(base_flowkey, flowkey):
    if base_flowkey == flowkey:
        return False
    for key in flowkey:
        if key not in base_flowkey:
            return False
    return True

def set_union(A, B):
    return list(set(A) | set(B))

def union_equal(A, B, C):
    if A == set_union(B,C) or B == set_union(A,C) or C == set_union(A,B):
        return True
    return False

