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
    T3_INIT_HH_5( 1, 100, 16384)
    MRAC_INIT_1( 2, 100, 16384, 11,  8)
    T2_INIT_4( 3, 100, 16384)
    T2_INIT_2( 4, 200, 4096)
    T2_INIT_HH_2( 5, 200, 4096)
    UM_INIT_5( 6, 200, 11, 32768)
    T2_INIT_HH_4( 7, 110, 8192)
    MRAC_INIT_1( 8, 110, 16384, 11,  8)
    MRAC_INIT_1( 9, 110, 32768, 11, 16)
    UM_INIT_4(10, 110, 11, 32768)
    MRAC_INIT_1(11, 110, 16384, 11,  8)
    MRAC_INIT_1(12, 110, 32768, 11, 16)
    MRB_INIT_1(13, 220, 131072, 14,  8)
    T2_INIT_4(14, 220, 16384)
    T3_INIT_HH_3(15, 220, 4096)
    T2_INIT_HH_4(16, 220, 8192)
    T1_INIT_4(17, 221, 524288)
    T1_INIT_5(18, 221, 262144)
    T1_INIT_2(19, 221, 262144)
    T2_INIT_1(20, 221, 8192)
    apply {
        T3_RUN_HH_5_KEY_1( 1, SRCIP, SIZE)
        MRAC_RUN_1_KEY_1( 2, SRCIP)
        T2_RUN_4_KEY_1( 3, DSTIP, SIZE)
        T2_RUN_2_KEY_2( 4, SRCIP, DSTIP, SIZE)
        T2_RUN_HH_2_KEY_2( 5, SRCIP, DSTIP, 1)
        UM_RUN_5_KEY_2( 6, SRCIP, DSTIP, 1)
        T2_RUN_HH_4_KEY_2( 7, SRCIP, SRCPORT, SIZE)
        MRAC_RUN_1_KEY_2( 8, SRCIP, SRCPORT)
        MRAC_RUN_1_KEY_2( 9, SRCIP, SRCPORT)
        UM_RUN_4_KEY_2(10, SRCIP, SRCPORT, SIZE)
        MRAC_RUN_1_KEY_2(11, DSTIP, DSTPORT)
        MRAC_RUN_1_KEY_2(12, DSTIP, DSTPORT)
        MRB_RUN_1_KEY_4(13, SRCIP, DSTIP, SRCPORT, DSTPORT)
        T2_RUN_4_KEY_4(14, SRCIP, DSTIP, SRCPORT, DSTPORT, 1)
        T3_RUN_HH_3_KEY_4(15, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)
        T2_RUN_HH_4_KEY_4(16, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)
        T1_RUN_4_KEY_5(17, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO) if (ig_md.d_17_est1_1 == 0 || ig_md.d_17_est1_2 == 0 || ig_md.d_17_est1_3 == 0 || ig_md.d_17_est1_4 == 0) { /* process_new_flow() */ }
        T1_RUN_5_KEY_5(18, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO) if (ig_md.d_18_est1_1 == 0 || ig_md.d_18_est1_2 == 0 || ig_md.d_18_est1_3 == 0 || ig_md.d_18_est1_4 == 0 || ig_md.d_18_est1_5 == 0) { /* process_new_flow() */ }
        T1_RUN_2_KEY_5(19, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO) if (ig_md.d_19_est1_1 == 0 || ig_md.d_19_est1_2 == 0) { /* process_new_flow() */ }
        T2_RUN_1_KEY_5(20, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, SIZE)
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