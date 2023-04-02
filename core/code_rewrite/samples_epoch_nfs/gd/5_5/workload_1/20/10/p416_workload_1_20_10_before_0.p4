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
    T2_INIT_HH_1( 1, 100, 4096)
    T2_INIT_HH_4( 2, 100, 8192)
    T2_INIT_HH_3( 3, 100, 8192)
    T2_INIT_HH_2( 4, 100, 4096)
    T2_INIT_HH_4( 5, 100, 4096)
    T2_INIT_HH_4( 6, 100, 8192)
    T2_INIT_HH_5( 7, 100, 8192)
    T2_INIT_HH_2( 8, 200, 4096)
    T2_INIT_HH_5( 9, 200, 16384)
    T2_INIT_HH_2(10, 200, 16384)
    T2_INIT_HH_2(11, 110, 4096)
    T2_INIT_HH_4(12, 110, 8192)
    T2_INIT_HH_2(13, 110, 4096)
    T2_INIT_HH_5(14, 110, 4096)
    T2_INIT_HH_1(15, 110, 16384)
    T2_INIT_HH_3(16, 110, 8192)
    T2_INIT_HH_5(17, 220, 16384)
    T2_INIT_HH_5(18, 220, 4096)
    T2_INIT_HH_4(19, 221, 16384)
    T2_INIT_HH_4(20, 221, 16384)
    apply {
        T2_RUN_HH_1_KEY_1( 1, SRCIP, 1)
        T2_RUN_HH_4_KEY_1( 2, SRCIP, 1)
        T2_RUN_HH_3_KEY_1( 3, SRCIP, 1)
        T2_RUN_HH_2_KEY_1( 4, DSTIP, 1)
        T2_RUN_HH_4_KEY_1( 5, DSTIP, SIZE)
        T2_RUN_HH_4_KEY_1( 6, DSTIP, SIZE)
        T2_RUN_HH_5_KEY_1( 7, DSTIP, SIZE)
        T2_RUN_HH_2_KEY_2( 8, SRCIP, DSTIP, 1)
        T2_RUN_HH_5_KEY_2( 9, SRCIP, DSTIP, SIZE)
        T2_RUN_HH_2_KEY_2(10, SRCIP, DSTIP, SIZE)
        T2_RUN_HH_2_KEY_2(11, SRCIP, SRCPORT, 1)
        T2_RUN_HH_4_KEY_2(12, SRCIP, SRCPORT, 1)
        T2_RUN_HH_2_KEY_2(13, SRCIP, SRCPORT, SIZE)
        T2_RUN_HH_5_KEY_2(14, DSTIP, DSTPORT, 1)
        T2_RUN_HH_1_KEY_2(15, DSTIP, DSTPORT, SIZE)
        T2_RUN_HH_3_KEY_2(16, DSTIP, DSTPORT, SIZE)
        T2_RUN_HH_5_KEY_4(17, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)
        T2_RUN_HH_5_KEY_4(18, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)
        T2_RUN_HH_4_KEY_5(19, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, 1)
        T2_RUN_HH_4_KEY_5(20, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, SIZE)
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