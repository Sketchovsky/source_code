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
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_221(65536, 16, 20480)

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
        COMPUTE_HASH_200_16_16(32w0x30244f0b) d_7_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_12_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_13_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_14_auto_sampling_hash_call;

        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_15_auto_sampling_hash_call;

        COMPUTE_HASH_221_32_32(32w0x30244f0b) d_16_auto_sampling_hash_call;

    //

    T1_INIT_5( 1, 100, 262144)
    T2_INIT_2( 2, 100, 8192)
    T2_INIT_HH_5( 3, 100, 8192)
    T1_INIT_1( 4, 200, 524288)
    T2_INIT_HH_1( 6, 200, 4096)
    T2_INIT_HH_5( 5, 200, 4096)
    MRAC_INIT_1( 7, 200, 32768, 11, 16)
    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
        ABOVE_THRESHOLD_CONSTANT_5(100) d_9_above_threshold;
        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_9_res_hash_call;
        T3_T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_9_1;
        T3_T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_9_2;
        T3_KEY_UPDATE_110_4096(32w0x30243f0b) update_9_3;
        T3_KEY_UPDATE_110_4096(32w0x30243f0b) update_9_4;
        T3_KEY_UPDATE_110_4096(32w0x30243f0b) update_9_5;
    //

    T3_INIT_HH_4(10, 110, 16384)
    T3_INIT_HH_1(11, 110, 8192)
    MRAC_INIT_1(12, 110, 32768, 11, 16)
    UM_INIT_4(13, 110, 11, 32768)
    UM_INIT_3(14, 110, 11, 32768)
    MRB_INIT_1(15, 220, 262144, 14, 16)
    T5_INIT_1(16, 221, 8192)
    T3_INIT_HH_3(17, 221, 16384)
    T2_INIT_HH_3(18, 221, 16384)

    HEAVY_FLOWKEY_STORAGE_CONFIG_221(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_7_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_7_sampling_hash_16);

            d_12_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_12_sampling_hash_16);

            d_13_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_13_sampling_hash_16);

            d_14_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_14_sampling_hash_16);

            d_15_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_15_sampling_hash_16);

            d_16_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_16_sampling_hash_32);

        //

        T1_RUN_5_KEY_1( 1, DSTIP) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0 || ig_md.d_1_est1_3 == 0 || ig_md.d_1_est1_4 == 0 || ig_md.d_1_est1_5 == 0) { /* process_new_flow() */ }
        T2_RUN_2_KEY_1( 2, DSTIP, SIZE)
        T2_RUN_AFTER_5_KEY_1( 3, DSTIP, SIZE)
        T1_RUN_1_KEY_2( 4, SRCIP, DSTIP)
        T2_RUN_AFTER_1_KEY_2( 6, SRCIP, DSTIP, SIZE)
        T2_RUN_AFTER_5_KEY_2( 5, SRCIP, DSTIP, 1)
        // MRAC for inst 7
            d_7_tcam_lpm.apply(ig_md.d_7_sampling_hash_16, ig_md.d_7_base_16);
            d_7_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_7_index1_16);
            update_7_1.apply(ig_md.d_7_base_16, ig_md.d_7_index1_16);
        //

        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
            d_9_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_9_res_hash);
            update_9_1.apply(SRCIP, SRCPORT, 1, ig_md.d_9_res_hash[0:0], 1, ig_md.d_9_est_1);
            update_9_2.apply(SRCIP, SRCPORT, 1, ig_md.d_9_res_hash[1:1], 1, ig_md.d_9_est_2);
            update_9_3.apply(SRCIP, SRCPORT, 1, ig_md.d_9_res_hash[2:2], ig_md.d_9_est_3);
            update_9_4.apply(SRCIP, SRCPORT, 1, ig_md.d_9_res_hash[3:3], ig_md.d_9_est_4);
            update_9_5.apply(SRCIP, SRCPORT, 1, ig_md.d_9_res_hash[4:4], ig_md.d_9_est_5);
            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_5(9)
        //

        T3_RUN_AFTER_4_KEY_2(10, SRCIP, SRCPORT, SIZE)
        T3_RUN_AFTER_1_KEY_2(11, SRCIP, SRCPORT, SIZE)
        // MRAC for inst 12
            d_12_tcam_lpm.apply(ig_md.d_12_sampling_hash_16, ig_md.d_12_base_16);
            d_12_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_12_index1_16);
            update_12_1.apply(ig_md.d_12_base_16, ig_md.d_12_index1_16);
        //

        // UnivMon for inst 13
            d_13_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_13_res_hash); 
            d_13_tcam_lpm.apply(ig_md.d_13_sampling_hash_16, ig_md.d_13_base_16, ig_md.d_13_threshold); 
            d_13_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_13_index1_16); 
            d_13_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_13_index2_16); 
            d_13_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_13_index3_16); 
            d_13_index_hash_call_4.apply(SRCIP, SRCPORT, ig_md.d_13_index4_16); 
            UM_RUN_END_4(13, ig_md.d_13_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_4(13) 
        //

        // UnivMon for inst 14
            d_14_res_hash_call.apply(DSTIP, DSTPORT, ig_md.d_14_res_hash); 
            d_14_tcam_lpm.apply(ig_md.d_14_sampling_hash_16, ig_md.d_14_base_16, ig_md.d_14_threshold); 
            d_14_index_hash_call_1.apply(DSTIP, DSTPORT, ig_md.d_14_index1_16); 
            d_14_index_hash_call_2.apply(DSTIP, DSTPORT, ig_md.d_14_index2_16); 
            d_14_index_hash_call_3.apply(DSTIP, DSTPORT, ig_md.d_14_index3_16); 
            UM_RUN_END_3(14, ig_md.d_14_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_3(14) 
        //

        // MRB for inst 15
            d_15_tcam_lpm.apply(ig_md.d_15_sampling_hash_16, ig_md.d_15_base_32);
            d_15_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_15_index1_16);
            update_15_1.apply(ig_md.d_15_base_32, ig_md.d_15_index1_16);
        //

        // PCSA for inst 16
            d_16_tcam_lpm.apply(ig_md.d_16_sampling_hash_32, ig_md.d_16_level);
            d_16_get_bitmask.apply(ig_md.d_16_level, ig_md.d_16_bitmask);
            update_16_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_16_bitmask);
        //

        T3_RUN_AFTER_3_KEY_5(17, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, SIZE)
        T2_RUN_AFTER_3_KEY_5(18, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, SIZE)
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_3_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_14_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_proto = PROTO; 
        }
        if(
        ig_md.d_3_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            heavy_flowkey_storage.apply(ig_dprsr_md,ig_md.hf_srcip, ig_md.hf_dstip, ig_md.hf_srcport, ig_md.hf_dstport, ig_md.hf_proto); 
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