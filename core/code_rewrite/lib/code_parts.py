
code_part_1 = '\
#include <core.p4>\n\
#if __TARGET_TOFINO__ == 2\n\
#include <t2na.p4>\n\
#else\n\
#include <tna.p4>\n\
#endif\n\
#include "headers.p4"\n\
#include "util.p4"\n\
#include "metadata.p4"\n\
struct metadata_t {\n\
    bit<16> src_port;\n\
    bit<16> dst_port;\n\
    bit<32> hf_srcip;\n\
    bit<32> hf_dstip;\n\
    bit<16> hf_srcport;\n\
    bit<16> hf_dstport;\n\
    bit<8> hf_proto;\n'

code_part_2 = '}\n\
#include "parser.p4"\n\
#include "all_include.p4"\n\
#define SRCIP hdr.ipv4.src_addr\n\
#define DSTIP hdr.ipv4.dst_addr\n\
#define SRCPORT ig_md.src_port\n\
#define DSTPORT ig_md.dst_port\n\
#define PROTO hdr.ipv4.protocol\n\
#define SIZE hdr.ipv4.total_len\n\
control SwitchIngress(\n\
        inout header_t hdr,\n\
        inout metadata_t ig_md,\n\
        in ingress_intrinsic_metadata_t ig_intr_md,\n\
        in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,\n\
        inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,\n\
        inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {\n\
        L2() l2_1;\n\
        L3() l3_1;\n\
        Blacklist() acl_1;\n\
        L2() l2_2;\n\
        L3() l3_2;\n\
        Blacklist() acl_2;\n\
        L2() l2_3;\n\
        L3() l3_3;\n\
        Blacklist() acl_3;\n\
        L2() l2_4;\n\
        L3() l3_4;\n\
        Blacklist() acl_4;\n\
        L2() l2_5;\n\
        L3() l3_5;\n\
        Blacklist() acl_5;\n\
        L2() l2_6;\n\
        L3() l3_6;\n\
        Blacklist() acl_6;\n\
        L2() l2_7;\n\
        L3() l3_7;\n\
        Blacklist() acl_7;\n\
        L2() l2_8;\n\
        L3() l3_8;\n\
        Blacklist() acl_8;\n\
        L2() l2_9;\n\
        L3() l3_9;\n\
        Blacklist() acl_9;\n'

code_part_2_1 = '}\n\
#include "parser.p4"\n\
#include "all_include.p4"\n\
#define SRCIP hdr.ipv4.src_addr\n\
#define DSTIP hdr.ipv4.dst_addr\n\
#define SRCPORT ig_md.src_port\n\
#define DSTPORT ig_md.dst_port\n\
#define PROTO hdr.ipv4.protocol\n\
#define SIZE hdr.ipv4.total_len\n'

code_part_2_2 = '\n\
control SwitchIngress(\n\
        inout header_t hdr,\n\
        inout metadata_t ig_md,\n\
        in ingress_intrinsic_metadata_t ig_intr_md,\n\
        in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,\n\
        inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,\n\
        inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {\n\
        L2() l2;\n\
        L3() l3;\n\
        Blacklist() acl;\n\
        L2() l2_1;\n\
        L3() l3_1;\n\
        Blacklist() acl_1;\n\
        L2() l2_2;\n\
        L3() l3_2;\n\
        Blacklist() acl_2;\n\
        L2() l2_3;\n\
        L3() l3_3;\n\
        Blacklist() acl_3;\n\
        L2() l2_4;\n\
        L3() l3_4;\n\
        Blacklist() acl_4;\n\
        L2() l2_5;\n\
        L3() l3_5;\n\
        Blacklist() acl_5;\n\
        L2() l2_6;\n\
        L3() l3_6;\n\
        Blacklist() acl_6;\n\
        L2() l2_7;\n\
        L3() l3_7;\n\
        Blacklist() acl_7;\n\
        L2() l2_8;\n\
        L3() l3_8;\n\
        Blacklist() acl_8;\n\
        L2() l2_9;\n\
        L3() l3_9;\n\
        Blacklist() acl_9;\n'



code_part_3 = '\
    }\n\
}\n\
struct my_egress_headers_t {}\n\
struct my_egress_metadata_t {}\n\
parser EgressParser(packet_in        pkt,\n\
    out my_egress_headers_t          hdr,\n\
    out my_egress_metadata_t         meta,\n\
    out egress_intrinsic_metadata_t  eg_intr_md)\n\
{\n\
    state start {\n\
        pkt.extract(eg_intr_md);\n\
        transition accept;\n\
    }\n\
}\n\
control EmptyEgress(\n\
        inout my_egress_headers_t hdr,\n\
        inout my_egress_metadata_t eg_md,\n\
        in egress_intrinsic_metadata_t eg_intr_md,\n\
        in egress_intrinsic_metadata_from_parser_t eg_intr_md_from_prsr,\n\
        inout egress_intrinsic_metadata_for_deparser_t ig_intr_dprs_md,\n\
        inout egress_intrinsic_metadata_for_output_port_t eg_intr_oport_md) {\n\
    apply {}\n\
}\n\
control EgressDeparser(packet_out pkt,\n\
    inout my_egress_headers_t                       hdr,\n\
    in    my_egress_metadata_t                      meta,\n\
    in    egress_intrinsic_metadata_for_deparser_t  eg_dprsr_md)\n\
{\n\
    apply {\n\
        pkt.emit(hdr);\n\
    }\n\
}\n\
Pipeline(\n\
    SwitchIngressParser(),\n\
    SwitchIngress(),\n\
    SwitchIngressDeparser(),\n\
    EgressParser(),\n\
    EmptyEgress(),\n\
    EgressDeparser()\n\
) pipe;\n\
Switch(pipe) main;'
