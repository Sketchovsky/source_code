from code_rewrite.lib.o5_writer import O5_Writer
from code_rewrite.lib.code_parts import *
from code_rewrite.lib.common import *

def write_before_p4_code(f, picked_sample, o3_result):

    o5_writer = O5_Writer(o3_result)

    total_len = len(picked_sample)
    f.write(code_part_1)
    for i in range(1, total_len+1):
        f.write('    METADATA_DIM(%d)\n' % i)
    f.write(code_part_2)
    
    for inst in picked_sample:
        msg = get_init_msg(inst, o5_writer)
        f.write("    " + msg + "\n")
    f.write('    apply {\n')

    for inst in picked_sample:
        msg = get_run_msg("before", inst)
        f.write("        " + msg + "\n")

    for i in range(1, 10):
        f.write('        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_%d.apply(hdr, ig_tm_md); }\n' % i)
        f.write('        else { l3_%d.apply(hdr, ig_tm_md); }\n' % i)
        f.write('        acl_%d.apply(hdr, ig_dprsr_md);\n' % i)
    f.write(code_part_3)

