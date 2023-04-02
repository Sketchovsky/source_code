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
}
#include "parser.p4"
#include "all_include.p4"
#define SRCIP hdr.ipv4.src_addr
#define DSTIP hdr.ipv4.dst_addr
#define SRCPORT ig_md.src_port
#define DSTPORT ig_md.dst_port
#define PROTO hdr.ipv4.protocol
#define SIZE hdr.ipv4.total_len
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_220(32768, 15, 10240)

control SwitchIngress(
        inout header_t hdr,
        inout metadata_t ig_md,
        in ingress_intrinsic_metadata_t ig_intr_md,
        in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
        inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
        inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {
        L2() l2;
        L3() l3;
        Blacklist() acl;
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

    // O1 hash init
        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_3_auto_sampling_hash_call;

        COMPUTE_HASH_200_16_16(32w0x30244f0b) d_4_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_5_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_6_auto_sampling_hash_call;

        COMPUTE_HASH_221_32_32(32w0x30244f0b) d_11_auto_sampling_hash_call;

    //

    T1_INIT_2( 1, 100, 524288)
    T2_INIT_HH_5( 2, 100, 4096)
    UM_INIT_5( 3, 100, 11, 32768)
    UM_INIT_3( 4, 200, 11, 32768)
    MRAC_INIT_1( 5, 110, 16384, 11,  8)
    UM_INIT_5( 6, 110, 11, 32768)
    T2_INIT_4( 7, 110, 4096)
    T1_INIT_1( 8, 220, 131072)
    T2_INIT_HH_2( 9, 220, 16384)
    T1_INIT_5(10, 221, 262144)
    T4_INIT_1(11, 221, 8192)
    T2_INIT_2(12, 221, 4096)

    HEAVY_FLOWKEY_STORAGE_CONFIG_220(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_3_auto_sampling_hash_call.apply(SRCIP, ig_md.d_3_sampling_hash_16);

            d_4_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_4_sampling_hash_16);

            d_5_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_5_sampling_hash_16);

            d_6_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_6_sampling_hash_16);

            d_11_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_11_sampling_hash_32);

        //

        T1_RUN_2_KEY_1( 1, SRCIP) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0) { /* process_new_flow() */ }
        T2_RUN_AFTER_5_KEY_1( 2, SRCIP, 1)
        // UnivMon for inst 3
            d_3_res_hash_call.apply(SRCIP, ig_md.d_3_res_hash); 
            d_3_tcam_lpm.apply(ig_md.d_3_sampling_hash_16, ig_md.d_3_base_16, ig_md.d_3_threshold); 
            d_3_index_hash_call_1.apply(SRCIP, ig_md.d_3_index1_16); 
            d_3_index_hash_call_2.apply(SRCIP, ig_md.d_3_index2_16); 
            d_3_index_hash_call_3.apply(SRCIP, ig_md.d_3_index3_16); 
            d_3_index_hash_call_4.apply(SRCIP, ig_md.d_3_index4_16); 
            d_3_index_hash_call_5.apply(SRCIP, ig_md.d_3_index5_16); 
            UM_RUN_END_5(3, ig_md.d_3_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_5(3) 
        //

        // UnivMon for inst 4
            d_4_res_hash_call.apply(SRCIP, DSTIP, ig_md.d_4_res_hash); 
            d_4_tcam_lpm.apply(ig_md.d_4_sampling_hash_16, ig_md.d_4_base_16, ig_md.d_4_threshold); 
            d_4_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_4_index1_16); 
            d_4_index_hash_call_2.apply(SRCIP, DSTIP, ig_md.d_4_index2_16); 
            d_4_index_hash_call_3.apply(SRCIP, DSTIP, ig_md.d_4_index3_16); 
            UM_RUN_END_3(4, ig_md.d_4_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_3(4) 
        //

        // MRAC for inst 5
            d_5_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_5_base_16);
            d_5_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_5_index1_16);
            update_5_1.apply(ig_md.d_5_base_16, ig_md.d_5_index1_16);
        //

        // UnivMon for inst 6
            d_6_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_6_res_hash); 
            d_6_tcam_lpm.apply(ig_md.d_6_sampling_hash_16, ig_md.d_6_base_16, ig_md.d_6_threshold); 
            d_6_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_6_index1_16); 
            d_6_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_6_index2_16); 
            d_6_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_6_index3_16); 
            d_6_index_hash_call_4.apply(SRCIP, SRCPORT, ig_md.d_6_index4_16); 
            d_6_index_hash_call_5.apply(SRCIP, SRCPORT, ig_md.d_6_index5_16); 
            UM_RUN_END_5(6, ig_md.d_6_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_5(6) 
        //

        T2_RUN_4_KEY_2( 7, DSTIP, DSTPORT, 1)
        T1_RUN_1_KEY_4( 8, SRCIP, DSTIP, SRCPORT, DSTPORT)
        T2_RUN_AFTER_2_KEY_4( 9, SRCIP, DSTIP, SRCPORT, DSTPORT, 1)
        T1_RUN_5_KEY_5(10, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO) if (ig_md.d_10_est1_1 == 0 || ig_md.d_10_est1_2 == 0 || ig_md.d_10_est1_3 == 0 || ig_md.d_10_est1_4 == 0 || ig_md.d_10_est1_5 == 0) { /* process_new_flow() */ }
        // HLL for inst 11
            d_11_tcam_lpm.apply(ig_md.d_11_sampling_hash_32, ig_md.d_11_level);
            update_11_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_11_level);
        //

        T2_RUN_2_KEY_5(12, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, 1)
        if(
        ig_md.d_2_above_threshold == 1
        || ig_md.d_3_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_4_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_9_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_2_above_threshold == 1
        || ig_md.d_3_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        ) {
            heavy_flowkey_storage.apply(ig_dprsr_md,ig_md.hf_srcip, ig_md.hf_dstip, ig_md.hf_srcport, ig_md.hf_dstport); 
        }

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