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
}
#include "parser.p4"
#include "all_include.p4"
#define SRCIP hdr.ipv4.src_addr
#define DSTIP hdr.ipv4.dst_addr
#define SRCPORT ig_md.src_port
#define DSTPORT ig_md.dst_port
#define PROTO hdr.ipv4.protocol
#define SIZE hdr.ipv4.total_len
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_110(32768, 15, 10240)

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
        COMPUTE_HASH_110_32_32(32w0x30244f0b) d_4_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_8_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_9_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_10_auto_sampling_hash_call;

    //

    T1_INIT_2( 1, 110, 524288)
    T1_INIT_4( 2, 110, 524288)
    T1_INIT_1( 3, 110, 524288)
    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
        ABOVE_THRESHOLD_CONSTANT_4(100) d_5_above_threshold;
        COMPUTE_HASH_110_32_32(32w0x30244f0b) d_5_hash_call;
        TCAM_LPM_HLLPCSA() d_5_tcam_lpm;
        GET_BITMASK() d_5_get_bitmask;
        T2_T5_KEY_UPDATE_110_16384(32w0x30243f0b) update_5_1;
        T2_KEY_UPDATE_110_4096(32w0x30243f0b) update_5_2;
        T2_KEY_UPDATE_110_4096(32w0x30243f0b) update_5_3;
        T2_KEY_UPDATE_110_4096(32w0x30243f0b) update_5_4;
    //

    T2_INIT_HH_3( 6, 110, 4096)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(8, 110)
        ABOVE_THRESHOLD_5() d_8_above_threshold;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_8_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_8_1;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_8_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_8_2;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_8_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_8_3;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_8_index_hash_call_4;
        T3_INDEX_UPDATE_32768() update_8_4;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_8_index_hash_call_5;
        T3_INDEX_UPDATE_32768() update_8_5;
    // 

    UM_INIT_4( 9, 110, 11, 32768)
    UM_INIT_4(10, 110, 11, 32768)

    HEAVY_FLOWKEY_STORAGE_CONFIG_110(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_4_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_4_sampling_hash_32);

            d_8_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_8_sampling_hash_16);

            d_9_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_9_sampling_hash_16);

            d_10_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_10_sampling_hash_16);

        //

        T1_RUN_2_KEY_2( 1, SRCIP, SRCPORT) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0) { /* process_new_flow() */ }
        T1_RUN_4_KEY_2( 2, SRCIP, SRCPORT) if (ig_md.d_2_est1_1 == 0 || ig_md.d_2_est1_2 == 0 || ig_md.d_2_est1_3 == 0 || ig_md.d_2_est1_4 == 0) { /* process_new_flow() */ }
        T1_RUN_1_KEY_2( 3, SRCIP, SRCPORT) if (ig_md.d_3_est1_1 == 0) { /* process_new_flow() */ }
        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
            d_5_tcam_lpm.apply(ig_md.d_4_sampling_hash_32, ig_md.d_5_level);
            d_5_get_bitmask.apply(ig_md.d_5_level, ig_md.d_5_bitmask);
            update_5_1.apply(SRCIP, SRCPORT, SIZE, ig_md.d_5_bitmask, ig_md.d_5_est_1);
            update_5_2.apply(SRCIP, SRCPORT, SIZE, ig_md.d_5_est_2);
            update_5_3.apply(SRCIP, SRCPORT, SIZE, ig_md.d_5_est_3);
            update_5_4.apply(SRCIP, SRCPORT, SIZE, ig_md.d_5_est_4);
            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_4(5)
        //

        T2_RUN_AFTER_3_KEY_2( 6, SRCIP, SRCPORT, SIZE)

        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_8_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_8_res_hash);
        d_8_tcam_lpm_2.apply(ig_md.d_8_sampling_hash_16, ig_md.d_8_base_16_1024, ig_md.d_8_base_16_2048, ig_md.d_8_threshold);
        d_8_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_8_index1_16);
        update_8_1.apply(ig_md.d_8_base_16_2048, ig_md.d_8_index1_16, ig_md.d_8_res_hash[0:0], 1, ig_md.d_8_est_1);
        d_8_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_8_index2_16);
        update_8_2.apply(ig_md.d_8_base_16_2048, ig_md.d_8_index2_16, ig_md.d_8_res_hash[1:1], 1, ig_md.d_8_est_2);
        d_8_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_8_index3_16);
        update_8_3.apply(ig_md.d_8_base_16_2048, ig_md.d_8_index3_16, ig_md.d_8_res_hash[2:2], 1, ig_md.d_8_est_3);
        d_8_index_hash_call_4.apply(SRCIP, SRCPORT, ig_md.d_8_index4_16);
        update_8_4.apply(ig_md.d_8_base_16_2048, ig_md.d_8_index4_16, ig_md.d_8_res_hash[3:3], 1, ig_md.d_8_est_4);
        d_8_index_hash_call_5.apply(SRCIP, SRCPORT, ig_md.d_8_index5_16);
        update_8_5.apply(ig_md.d_8_base_16_2048, ig_md.d_8_index5_16, ig_md.d_8_res_hash[4:4], 1, ig_md.d_8_est_5);
        RUN_HEAVY_FLOWKEY_NOIF_5(8)
        // 

        // UnivMon for inst 9
            d_9_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_9_res_hash); 
            d_9_tcam_lpm.apply(ig_md.d_9_sampling_hash_16, ig_md.d_9_base_16, ig_md.d_9_threshold); 
            d_9_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_9_index1_16); 
            d_9_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_9_index2_16); 
            d_9_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_9_index3_16); 
            d_9_index_hash_call_4.apply(SRCIP, SRCPORT, ig_md.d_9_index4_16); 
            UM_RUN_END_4(9, ig_md.d_9_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_4(9) 
        //

        // UnivMon for inst 10
            d_10_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_10_res_hash); 
            d_10_tcam_lpm.apply(ig_md.d_10_sampling_hash_16, ig_md.d_10_base_16, ig_md.d_10_threshold); 
            d_10_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_10_index1_16); 
            d_10_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_10_index2_16); 
            d_10_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_10_index3_16); 
            d_10_index_hash_call_4.apply(SRCIP, SRCPORT, ig_md.d_10_index4_16); 
            UM_RUN_END_4(10, ig_md.d_10_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_4(10) 
        //

        if(
        ig_md.d_5_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_5_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_5_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        ) {
            heavy_flowkey_storage.apply(ig_dprsr_md,ig_md.hf_srcip, ig_md.hf_srcport); 
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