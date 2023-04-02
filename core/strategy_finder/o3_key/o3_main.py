from lib.inst_list import *
from opt.salu_merge import *
from opt.hfs_reuse import *

################ main ################

def o3_main(inst_list):

    o3inst = None
    for inst in inst_list:
        if inst.sketch.heavy_flowkey_storage == True:
            if o3inst == None:
                o3inst = HFSReuseSketchInstance(inst)
            else:
                o3inst.add_inst(inst)

    if o3inst == None:
        return None

    return o3inst
