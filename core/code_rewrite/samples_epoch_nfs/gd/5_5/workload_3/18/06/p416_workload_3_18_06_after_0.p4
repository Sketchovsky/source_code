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
}
#include "parser.p4"
#include "all_include.p4"
#define SRCIP hdr.ipv4.src_addr
#define DSTIP hdr.ipv4.dst_addr
#define SRCPORT ig_md.src_port
#define DSTPORT ig_md.dst_port
#define PROTO hdr.ipv4.protocol
#define SIZE hdr.ipv4.total_len
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_220(16384, 14, 6144)

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
        COMPUTE_HASH_220_32_32(32w0x30244f0b) d_15_auto_sampling_hash_call;

        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_4_auto_sampling_hash_call;

        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_6_auto_sampling_hash_call;

        COMPUTE_HASH_200_32_32(32w0x30244f0b) d_7_auto_sampling_hash_call;

        COMPUTE_HASH_200_16_16(32w0x30244f0b) d_8_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_10_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_11_auto_sampling_hash_call;

        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_17_auto_sampling_hash_call;

        COMPUTE_HASH_221_16_16(32w0x30244f0b) d_18_auto_sampling_hash_call;

    //

    T1_INIT_3( 1, 100, 524288)
    T2_INIT_1( 2, 100, 4096)
    T2_INIT_5( 3, 100, 16384)
    MRAC_INIT_1( 4, 100, 32768, 11, 16)
    T1_INIT_3( 5, 100, 524288)
    UM_INIT_5( 6, 100, 11, 32768)
    T4_INIT_1( 7, 200, 8192)
    MRB_INIT_1( 8, 200, 524288, 15, 16)
    T1_INIT_5( 9, 110, 262144)
    MRAC_INIT_1(10, 110, 16384, 11,  8)
    UM_INIT_4(11, 110, 11, 32768)
    T1_INIT_4(12, 110, 131072)
    T1_INIT_5(13, 110, 131072)
    T2_INIT_HH_3(14, 110, 4096)
    T4_INIT_1(15, 220, 4096)
    T4_INIT_1(16, 220, 16384)
    MRAC_INIT_1(17, 220, 32768, 11, 16)
    MRB_INIT_1(18, 221, 262144, 15,  8)

    HEAVY_FLOWKEY_STORAGE_CONFIG_220(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_15_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_15_sampling_hash_32);

            d_4_auto_sampling_hash_call.apply(SRCIP, ig_md.d_4_sampling_hash_16);

            d_6_auto_sampling_hash_call.apply(DSTIP, ig_md.d_6_sampling_hash_16);

            d_7_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_7_sampling_hash_32);

            d_8_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_8_sampling_hash_16);

            d_10_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_10_sampling_hash_16);

            d_11_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_11_sampling_hash_16);

            d_17_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_17_sampling_hash_16);

            d_18_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_18_sampling_hash_16);

        //

        T1_RUN_3_KEY_1( 1, SRCIP) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0 || ig_md.d_1_est1_3 == 0) { /* process_new_flow() */ }
        T2_RUN_1_KEY_1( 2, SRCIP, 1)
        T2_RUN_5_KEY_1( 3, SRCIP, 1)
        // MRAC for inst 4
            d_4_tcam_lpm.apply(ig_md.d_4_sampling_hash_16, ig_md.d_4_base_16);
            d_4_index_hash_call_1.apply(SRCIP, ig_md.d_4_index1_16);
            update_4_1.apply(ig_md.d_4_base_16, ig_md.d_4_index1_16);
        //

        T1_RUN_3_KEY_1( 5, DSTIP) if (ig_md.d_5_est1_1 == 0 || ig_md.d_5_est1_2 == 0 || ig_md.d_5_est1_3 == 0) { /* process_new_flow() */ }
        // UnivMon for inst 6
            d_6_res_hash_call.apply(DSTIP, ig_md.d_6_res_hash); 
            d_6_tcam_lpm.apply(ig_md.d_6_sampling_hash_16, ig_md.d_6_base_16, ig_md.d_6_threshold); 
            d_6_index_hash_call_1.apply(DSTIP, ig_md.d_6_index1_16); 
            d_6_index_hash_call_2.apply(DSTIP, ig_md.d_6_index2_16); 
            d_6_index_hash_call_3.apply(DSTIP, ig_md.d_6_index3_16); 
            d_6_index_hash_call_4.apply(DSTIP, ig_md.d_6_index4_16); 
            d_6_index_hash_call_5.apply(DSTIP, ig_md.d_6_index5_16); 
            UM_RUN_END_5(6, ig_md.d_6_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_5(6) 
        //

        // HLL for inst 7
            d_7_tcam_lpm.apply(ig_md.d_7_sampling_hash_32, ig_md.d_7_level);
            update_7_1.apply(SRCIP, DSTIP, ig_md.d_7_level);
        //

        // MRB for inst 8
            d_8_tcam_lpm.apply(ig_md.d_8_sampling_hash_16, ig_md.d_8_base_32);
            d_8_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_8_index1_16);
            update_8_1.apply(ig_md.d_8_base_32, ig_md.d_8_index1_16);
        //

        T1_RUN_5_KEY_2( 9, SRCIP, SRCPORT) if (ig_md.d_9_est1_1 == 0 || ig_md.d_9_est1_2 == 0 || ig_md.d_9_est1_3 == 0 || ig_md.d_9_est1_4 == 0 || ig_md.d_9_est1_5 == 0) { /* process_new_flow() */ }
        // MRAC for inst 10
            d_10_tcam_lpm.apply(ig_md.d_10_sampling_hash_16, ig_md.d_10_base_16);
            d_10_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_10_index1_16);
            update_10_1.apply(ig_md.d_10_base_16, ig_md.d_10_index1_16);
        //

        // UnivMon for inst 11
            d_11_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_11_res_hash); 
            d_11_tcam_lpm.apply(ig_md.d_11_sampling_hash_16, ig_md.d_11_base_16, ig_md.d_11_threshold); 
            d_11_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_11_index1_16); 
            d_11_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_11_index2_16); 
            d_11_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_11_index3_16); 
            d_11_index_hash_call_4.apply(SRCIP, SRCPORT, ig_md.d_11_index4_16); 
            UM_RUN_END_4(11, ig_md.d_11_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_4(11) 
        //

        T1_RUN_4_KEY_2(12, DSTIP, DSTPORT) if (ig_md.d_12_est1_1 == 0 || ig_md.d_12_est1_2 == 0 || ig_md.d_12_est1_3 == 0 || ig_md.d_12_est1_4 == 0) { /* process_new_flow() */ }
        T1_RUN_5_KEY_2(13, DSTIP, DSTPORT) if (ig_md.d_13_est1_1 == 0 || ig_md.d_13_est1_2 == 0 || ig_md.d_13_est1_3 == 0 || ig_md.d_13_est1_4 == 0 || ig_md.d_13_est1_5 == 0) { /* process_new_flow() */ }
        T2_RUN_AFTER_3_KEY_2(14, DSTIP, DSTPORT, 1)
        // HLL for inst 15
            d_15_tcam_lpm.apply(ig_md.d_15_sampling_hash_32, ig_md.d_15_level);
            update_15_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_15_level);
        //

        // HLL for inst 16
            d_16_tcam_lpm.apply(ig_md.d_15_sampling_hash_32, ig_md.d_16_level);
            update_16_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_16_level);
        //

        // MRAC for inst 17
            d_17_tcam_lpm.apply(ig_md.d_17_sampling_hash_16, ig_md.d_17_base_16);
            d_17_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_17_index1_16);
            update_17_1.apply(ig_md.d_17_base_16, ig_md.d_17_index1_16);
        //

        // MRB for inst 18
            d_18_tcam_lpm.apply(ig_md.d_18_sampling_hash_16, ig_md.d_18_base_32);
            d_18_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_18_index1_16);
            update_18_1.apply(ig_md.d_18_base_32, ig_md.d_18_index1_16);
        //

        if(
        ig_md.d_11_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_11_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_14_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
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