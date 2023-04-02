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
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_200(65536, 16, 20480)

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
        COMPUTE_HASH_200_16_16(32w0x30244f0b) d_5_auto_sampling_hash_call;

        COMPUTE_HASH_200_16_16(32w0x30244f0b) d_17_auto_sampling_hash_call;

        COMPUTE_HASH_200_16_16(32w0x30244f0b) d_18_auto_sampling_hash_call;

    //


    // apply O2
        T1_KEY_UPDATE_200_524288(32w0x30243f0b) update_1_1;
        T1_KEY_UPDATE_200_524288(32w0x30243f0b) update_1_2;
    // 

    T1_INIT_4( 2, 200, 131072)
    T1_INIT_3( 3, 200, 524288)
    MRB_INIT_1( 5, 200, 262144, 14, 16)
    T2_INIT_HH_1(12, 200, 4096)

    // apply O2
        T2_KEY_UPDATE_200_16384(32w0x30243f0b) update_6_1;
        T2_KEY_UPDATE_200_16384(32w0x30243f0b) update_6_2;
        T2_KEY_UPDATE_200_16384(32w0x30243f0b) update_6_3;
        ABOVE_THRESHOLD_CONSTANT_3(100) d_6_above_threshold;
    // 

    T2_INIT_HH_1(13, 200, 8192)

    // apply O2
        T2_KEY_UPDATE_200_16384(32w0x30243f0b) update_7_1;
        T2_KEY_UPDATE_200_4096(32w0x30243f0b) update_7_2;
        T2_KEY_UPDATE_200_4096(32w0x30243f0b) update_7_3;
        ABOVE_THRESHOLD_CONSTANT_3(100) d_7_above_threshold;
    // 

    T3_INIT_HH_2( 8, 200, 8192)
    T2_INIT_HH_3(10, 200, 16384)
    MRAC_INIT_1(14, 200, 16384, 11,  8)
    MRAC_INIT_1(15, 200, 32768, 11, 16)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(17, 200)
        ABOVE_THRESHOLD_4() d_17_above_threshold;
        COMPUTE_HASH_200_16_11(32w0x30244f0b) d_17_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_17_1;
        COMPUTE_HASH_200_16_11(32w0x30244f0b) d_17_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_17_2;
        COMPUTE_HASH_200_16_11(32w0x30244f0b) d_17_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_17_3;
        COMPUTE_HASH_200_16_11(32w0x30244f0b) d_17_index_hash_call_4;
        T3_INDEX_UPDATE_32768() update_17_4;
    // 

    UM_INIT_5(18, 200, 11, 32768)

    HEAVY_FLOWKEY_STORAGE_CONFIG_200(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_5_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_5_sampling_hash_16);

            d_17_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_17_sampling_hash_16);

            d_18_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_18_sampling_hash_16);

        //


        // apply O2
        T1_RUN_2_KEY_2(1, SRCIP, DSTIP) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0) { /* process_new_flow() */ }
        // 

        T1_RUN_4_KEY_2( 2, SRCIP, DSTIP) if (ig_md.d_2_est1_1 == 0 || ig_md.d_2_est1_2 == 0 || ig_md.d_2_est1_3 == 0 || ig_md.d_2_est1_4 == 0) { /* process_new_flow() */ }
        T1_RUN_3_KEY_2( 3, SRCIP, DSTIP) if (ig_md.d_3_est1_1 == 0 || ig_md.d_3_est1_2 == 0 || ig_md.d_3_est1_3 == 0) { /* process_new_flow() */ }
        // MRB for inst 5
            d_5_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_5_base_32);
            d_5_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_5_index1_16);
            update_5_1.apply(ig_md.d_5_base_32, ig_md.d_5_index1_16);
        //

        T2_RUN_AFTER_1_KEY_2(12, SRCIP, DSTIP, SIZE)

        // apply O2
        T2_RUN_AFTER_3_KEY_2(6, SRCIP, DSTIP, 1)
        // 

        T2_RUN_AFTER_1_KEY_2(13, SRCIP, DSTIP, SIZE)

        // apply O2
        T2_RUN_AFTER_3_KEY_2(7, SRCIP, DSTIP, 1)
        // 

        T3_RUN_AFTER_2_KEY_2( 8, SRCIP, DSTIP, 1)
        T2_RUN_AFTER_3_KEY_2(10, SRCIP, DSTIP, 1)
        // MRAC for inst 14
            d_14_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_14_base_16);
            d_14_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_14_index1_16);
            update_14_1.apply(ig_md.d_14_base_16, ig_md.d_14_index1_16);
        //

        // MRAC for inst 15
            d_15_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_15_base_16);
            d_15_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_15_index1_16);
            update_15_1.apply(ig_md.d_15_base_16, ig_md.d_15_index1_16);
        //


        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_17_res_hash_call.apply(SRCIP, DSTIP, ig_md.d_17_res_hash);
        d_17_tcam_lpm_2.apply(ig_md.d_17_sampling_hash_16, ig_md.d_17_base_16_1024, ig_md.d_17_base_16_2048, ig_md.d_17_threshold);
        d_17_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_17_index1_16);
        update_17_1.apply(ig_md.d_17_base_16_2048, ig_md.d_17_index1_16, ig_md.d_17_res_hash[0:0], 1, ig_md.d_17_est_1);
        d_17_index_hash_call_2.apply(SRCIP, DSTIP, ig_md.d_17_index2_16);
        update_17_2.apply(ig_md.d_17_base_16_2048, ig_md.d_17_index2_16, ig_md.d_17_res_hash[1:1], 1, ig_md.d_17_est_2);
        d_17_index_hash_call_3.apply(SRCIP, DSTIP, ig_md.d_17_index3_16);
        update_17_3.apply(ig_md.d_17_base_16_2048, ig_md.d_17_index3_16, ig_md.d_17_res_hash[2:2], 1, ig_md.d_17_est_3);
        d_17_index_hash_call_4.apply(SRCIP, DSTIP, ig_md.d_17_index4_16);
        update_17_4.apply(ig_md.d_17_base_16_2048, ig_md.d_17_index4_16, ig_md.d_17_res_hash[3:3], 1, ig_md.d_17_est_4);
        RUN_HEAVY_FLOWKEY_NOIF_4(17)
        // 

        // UnivMon for inst 18
            d_18_res_hash_call.apply(SRCIP, DSTIP, ig_md.d_18_res_hash); 
            d_18_tcam_lpm.apply(ig_md.d_18_sampling_hash_16, ig_md.d_18_base_16, ig_md.d_18_threshold); 
            d_18_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_18_index1_16); 
            d_18_index_hash_call_2.apply(SRCIP, DSTIP, ig_md.d_18_index2_16); 
            d_18_index_hash_call_3.apply(SRCIP, DSTIP, ig_md.d_18_index3_16); 
            d_18_index_hash_call_4.apply(SRCIP, DSTIP, ig_md.d_18_index4_16); 
            d_18_index_hash_call_5.apply(SRCIP, DSTIP, ig_md.d_18_index5_16); 
            UM_RUN_END_5(18, ig_md.d_18_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_5(18) 
        //

        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            heavy_flowkey_storage.apply(ig_dprsr_md,ig_md.hf_srcip, ig_md.hf_dstip); 
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