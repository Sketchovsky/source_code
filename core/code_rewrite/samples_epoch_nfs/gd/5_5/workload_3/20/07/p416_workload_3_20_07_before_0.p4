#include <core.p4>
#if __TARGET_TOFINO__ == 2
#include <t2na.p4>
#else
#include <tna.p4>
#endif
#include "headers.p4"
#include "util.p4"
#include "metadata.p4"
struct metadata_t {
    bit<16> src_port;
    bit<16> dst_port;
    bit<32> hf_srcip;
    bit<32> hf_dstip;
    bit<16> hf_srcport;
    bit<16> hf_dstport;
    bit<8> hf_proto;
    METADATA_DIM(1)
    METADATA_DIM(2)
    METADATA_DIM(3)
    METADATA_DIM(4)
    METADATA_DIM(5)
    METADATA_DIM(6)
    METADATA_DIM(7)
    METADATA_DIM(8)
    METADATA_DIM(9)
    METADATA_DIM(10)
    METADATA_DIM(11)
    METADATA_DIM(12)
    METADATA_DIM(13)
    METADATA_DIM(14)
    METADATA_DIM(15)
    METADATA_DIM(16)
    METADATA_DIM(17)
    METADATA_DIM(18)
    METADATA_DIM(19)
    METADATA_DIM(20)
}
#include "parser.p4"
#include "all_include.p4"
#define SRCIP hdr.ipv4.src_addr
#define DSTIP hdr.ipv4.dst_addr
#define SRCPORT ig_md.src_port
#define DSTPORT ig_md.dst_port
#define PROTO hdr.ipv4.protocol
#define SIZE hdr.ipv4.total_len
control SwitchIngress(
        inout header_t hdr,
        inout metadata_t ig_md,
        in ingress_intrinsic_metadata_t ig_intr_md,
        in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
        inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
        inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {
        L2() l2_1;
        L3() l3_1;
        Blacklist() acl_1;
        L2() l2_2;
        L3() l3_2;
        Blacklist() acl_2;
        L2() l2_3;
        L3() l3_3;
        Blacklist() acl_3;
        L2() l2_4;
        L3() l3_4;
        Blacklist() acl_4;
        L2() l2_5;
        L3() l3_5;
        Blacklist() acl_5;
        L2() l2_6;
        L3() l3_6;
        Blacklist() acl_6;
        L2() l2_7;
        L3() l3_7;
        Blacklist() acl_7;
        L2() l2_8;
        L3() l3_8;
        Blacklist() acl_8;
        L2() l2_9;
        L3() l3_9;
        Blacklist() acl_9;
    T4_INIT_1( 1, 100, 8192)
    T2_INIT_HH_5( 2, 100, 16384)
    T2_INIT_HH_2( 3, 100, 4096)
    MRAC_INIT_1( 4, 100, 32768, 11, 16)
    T3_INIT_HH_2( 5, 100, 8192)
    T3_INIT_HH_3( 6, 100, 8192)
    T2_INIT_HH_2( 7, 100, 8192)
    T1_INIT_3( 8, 200, 262144)
    MRAC_INIT_1( 9, 200, 16384, 11,  8)
    UM_INIT_4(10, 200, 11, 32768)
    T1_INIT_1(11, 110, 262144)
    UM_INIT_4(12, 110, 11, 32768)
    T1_INIT_2(13, 110, 524288)
    T1_INIT_4(14, 110, 262144)
    MRAC_INIT_1(15, 110, 16384, 11,  8)
    MRAC_INIT_1(16, 220, 16384, 11,  8)
    MRAC_INIT_1(17, 220, 32768, 11, 16)
    UM_INIT_5(18, 220, 11, 32768)
    T1_INIT_5(19, 221, 524288)
    T2_INIT_HH_1(20, 221, 4096)
    apply {
        T4_RUN_1_KEY_1( 1, SRCIP)
        T2_RUN_HH_5_KEY_1( 2, SRCIP, 1)
        T2_RUN_HH_2_KEY_1( 3, SRCIP, 1)
        MRAC_RUN_1_KEY_1( 4, SRCIP)
        T3_RUN_HH_2_KEY_1( 5, DSTIP, 1)
        T3_RUN_HH_3_KEY_1( 6, DSTIP, 1)
        T2_RUN_HH_2_KEY_1( 7, DSTIP, 1)
        T1_RUN_3_KEY_2( 8, SRCIP, DSTIP) if (ig_md.d_8_est1_1 == 0 || ig_md.d_8_est1_2 == 0 || ig_md.d_8_est1_3 == 0) { /* process_new_flow() */ }
        MRAC_RUN_1_KEY_2( 9, SRCIP, DSTIP)
        UM_RUN_4_KEY_2(10, SRCIP, DSTIP, 1)
        T1_RUN_1_KEY_2(11, SRCIP, SRCPORT)
        UM_RUN_4_KEY_2(12, SRCIP, SRCPORT, 1)
        T1_RUN_2_KEY_2(13, DSTIP, DSTPORT) if (ig_md.d_13_est1_1 == 0 || ig_md.d_13_est1_2 == 0) { /* process_new_flow() */ }
        T1_RUN_4_KEY_2(14, DSTIP, DSTPORT) if (ig_md.d_14_est1_1 == 0 || ig_md.d_14_est1_2 == 0 || ig_md.d_14_est1_3 == 0 || ig_md.d_14_est1_4 == 0) { /* process_new_flow() */ }
        MRAC_RUN_1_KEY_2(15, DSTIP, DSTPORT)
        MRAC_RUN_1_KEY_4(16, SRCIP, DSTIP, SRCPORT, DSTPORT)
        MRAC_RUN_1_KEY_4(17, SRCIP, DSTIP, SRCPORT, DSTPORT)
        UM_RUN_5_KEY_4(18, SRCIP, DSTIP, SRCPORT, DSTPORT, 1)
        T1_RUN_5_KEY_5(19, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO) if (ig_md.d_19_est1_1 == 0 || ig_md.d_19_est1_2 == 0 || ig_md.d_19_est1_3 == 0 || ig_md.d_19_est1_4 == 0 || ig_md.d_19_est1_5 == 0) { /* process_new_flow() */ }
        T2_RUN_HH_1_KEY_5(20, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, 1)
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_1.apply(hdr, ig_tm_md); }
        else { l3_1.apply(hdr, ig_tm_md); }
        acl_1.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_2.apply(hdr, ig_tm_md); }
        else { l3_2.apply(hdr, ig_tm_md); }
        acl_2.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_3.apply(hdr, ig_tm_md); }
        else { l3_3.apply(hdr, ig_tm_md); }
        acl_3.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_4.apply(hdr, ig_tm_md); }
        else { l3_4.apply(hdr, ig_tm_md); }
        acl_4.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_5.apply(hdr, ig_tm_md); }
        else { l3_5.apply(hdr, ig_tm_md); }
        acl_5.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_6.apply(hdr, ig_tm_md); }
        else { l3_6.apply(hdr, ig_tm_md); }
        acl_6.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_7.apply(hdr, ig_tm_md); }
        else { l3_7.apply(hdr, ig_tm_md); }
        acl_7.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_8.apply(hdr, ig_tm_md); }
        else { l3_8.apply(hdr, ig_tm_md); }
        acl_8.apply(hdr, ig_dprsr_md);
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4) { l2_9.apply(hdr, ig_tm_md); }
        else { l3_9.apply(hdr, ig_tm_md); }
        acl_9.apply(hdr, ig_dprsr_md);
    }
}
struct my_egress_headers_t {}
struct my_egress_metadata_t {}
parser EgressParser(packet_in        pkt,
    out my_egress_headers_t          hdr,
    out my_egress_metadata_t         meta,
    out egress_intrinsic_metadata_t  eg_intr_md)
{
    state start {
        pkt.extract(eg_intr_md);
        transition accept;
    }
}
control EmptyEgress(
        inout my_egress_headers_t hdr,
        inout my_egress_metadata_t eg_md,
        in egress_intrinsic_metadata_t eg_intr_md,
        in egress_intrinsic_metadata_from_parser_t eg_intr_md_from_prsr,
        inout egress_intrinsic_metadata_for_deparser_t ig_intr_dprs_md,
        inout egress_intrinsic_metadata_for_output_port_t eg_intr_oport_md) {
    apply {}
}
control EgressDeparser(packet_out pkt,
    inout my_egress_headers_t                       hdr,
    in    my_egress_metadata_t                      meta,
    in    egress_intrinsic_metadata_for_deparser_t  eg_dprsr_md)
{
    apply {
        pkt.emit(hdr);
    }
}
Pipeline(
    SwitchIngressParser(),
    SwitchIngress(),
    SwitchIngressDeparser(),
    EgressParser(),
    EmptyEgress(),
    EgressDeparser()
) pipe;
Switch(pipe) main;