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
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_110(65536, 16, 22528)

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
        COMPUTE_HASH_110_32_32(32w0x30244f0b) d_5_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_16_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_18_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_20_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_17_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_19_auto_sampling_hash_call;

    //

    T1_INIT_4( 1, 110, 524288)
    T1_INIT_1( 2, 110, 262144)
    T1_INIT_2( 3, 110, 524288)
    T1_INIT_4( 4, 110, 131072)
    T4_INIT_1( 5, 110, 8192)

    // apply O2
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_6_1;
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_6_2;
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_6_3;
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_6_4;
        ABOVE_THRESHOLD_CONSTANT_4(100) d_6_above_threshold;
    // 

    // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_7_res_hash_call;
        ABOVE_THRESHOLD_CONSTANT_1(100) d_9_above_threshold;
        T3_T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_7_1;
        ABOVE_THRESHOLD_CONSTANT_2(100) d_10_above_threshold;
        T3_T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_7_2;
        T3_T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_7_3;
    //

    T2_INIT_HH_4(11, 110, 4096)
    T2_INIT_HH_5(13, 110, 4096)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(16, 110)
        ABOVE_THRESHOLD_3() d_16_above_threshold;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_16_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_16_1;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_16_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_16_2;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_16_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_16_3;
    // 

    UM_INIT_3(18, 110, 11, 32768)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(20, 110)
        ABOVE_THRESHOLD_3() d_20_above_threshold;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_20_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_20_1;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_20_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_20_2;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_20_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_20_3;
    // 

    UM_INIT_4(17, 110, 11, 32768)
    UM_INIT_3(19, 110, 11, 32768)

    HEAVY_FLOWKEY_STORAGE_CONFIG_110(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_5_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_5_sampling_hash_32);

            d_16_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_16_sampling_hash_16);

            d_18_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_18_sampling_hash_16);

            d_20_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_20_sampling_hash_16);

            d_17_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_17_sampling_hash_16);

            d_19_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_19_sampling_hash_16);

        //

        T1_RUN_4_KEY_2( 1, SRCIP, SRCPORT) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0 || ig_md.d_1_est1_3 == 0 || ig_md.d_1_est1_4 == 0) { /* process_new_flow() */ }
        T1_RUN_1_KEY_2( 2, SRCIP, SRCPORT) if (ig_md.d_2_est1_1 == 0) { /* process_new_flow() */ }
        T1_RUN_2_KEY_2( 3, SRCIP, SRCPORT) if (ig_md.d_3_est1_1 == 0 || ig_md.d_3_est1_2 == 0) { /* process_new_flow() */ }
        T1_RUN_4_KEY_2( 4, SRCIP, SRCPORT) if (ig_md.d_4_est1_1 == 0 || ig_md.d_4_est1_2 == 0 || ig_md.d_4_est1_3 == 0 || ig_md.d_4_est1_4 == 0) { /* process_new_flow() */ }
        // HLL for inst 5
            d_5_tcam_lpm.apply(ig_md.d_5_sampling_hash_32, ig_md.d_5_level);
            update_5_1.apply(SRCIP, SRCPORT, ig_md.d_5_level);
        //


        // apply O2
        T2_RUN_AFTER_4_KEY_2(6, SRCIP, SRCPORT, 1)
        // 

        // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
            d_7_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_7_res_hash);
            update_7_1.apply(SRCIP, SRCPORT, 1, ig_md.d_7_res_hash[0:0], SIZE, ig_md.d_7_est_1);
            d_9_above_threshold.apply(ig_md.d_7_est_1, ig_md.d_9_above_threshold);
            update_7_2.apply(SRCIP, SRCPORT, SIZE, ig_md.d_7_res_hash[1:1], SIZE, ig_md.d_7_est_2);
            update_7_3.apply(SRCIP, SRCPORT, SIZE, ig_md.d_7_res_hash[2:2], SIZE, ig_md.d_7_est_3);
            d_10_above_threshold.apply(ig_md.d_7_est_2, ig_md.d_7_est_3, ig_md.d_10_above_threshold);
        //

        T2_RUN_AFTER_4_KEY_2(11, SRCIP, SRCPORT, 1)
        T2_RUN_AFTER_5_KEY_2(13, SRCIP, SRCPORT, SIZE)

        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_16_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_16_res_hash);
        d_16_tcam_lpm_2.apply(ig_md.d_16_sampling_hash_16, ig_md.d_16_base_16_1024, ig_md.d_16_base_16_2048, ig_md.d_16_threshold);
        d_16_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_16_index1_16);
        update_16_1.apply(ig_md.d_16_base_16_2048, ig_md.d_16_index1_16, ig_md.d_16_res_hash[0:0], 1, ig_md.d_16_est_1);
        d_16_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_16_index2_16);
        update_16_2.apply(ig_md.d_16_base_16_2048, ig_md.d_16_index2_16, ig_md.d_16_res_hash[1:1], 1, ig_md.d_16_est_2);
        d_16_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_16_index3_16);
        update_16_3.apply(ig_md.d_16_base_16_2048, ig_md.d_16_index3_16, ig_md.d_16_res_hash[2:2], 1, ig_md.d_16_est_3);
        RUN_HEAVY_FLOWKEY_NOIF_3(16)
        // 

        // UnivMon for inst 18
            d_18_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_18_res_hash); 
            d_18_tcam_lpm.apply(ig_md.d_18_sampling_hash_16, ig_md.d_18_base_16, ig_md.d_18_threshold); 
            d_18_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_18_index1_16); 
            d_18_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_18_index2_16); 
            d_18_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_18_index3_16); 
            UM_RUN_END_3(18, ig_md.d_18_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_3(18) 
        //


        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_20_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_20_res_hash);
        d_20_tcam_lpm_2.apply(ig_md.d_20_sampling_hash_16, ig_md.d_20_base_16_1024, ig_md.d_20_base_16_2048, ig_md.d_20_threshold);
        d_20_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_20_index1_16);
        update_20_1.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index1_16, ig_md.d_20_res_hash[0:0], SIZE, ig_md.d_20_est_1);
        d_20_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_20_index2_16);
        update_20_2.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index2_16, ig_md.d_20_res_hash[1:1], SIZE, ig_md.d_20_est_2);
        d_20_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_20_index3_16);
        update_20_3.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index3_16, ig_md.d_20_res_hash[2:2], SIZE, ig_md.d_20_est_3);
        RUN_HEAVY_FLOWKEY_NOIF_3(20)
        // 

        // UnivMon for inst 17
            d_17_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_17_res_hash); 
            d_17_tcam_lpm.apply(ig_md.d_17_sampling_hash_16, ig_md.d_17_base_16, ig_md.d_17_threshold); 
            d_17_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_17_index1_16); 
            d_17_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_17_index2_16); 
            d_17_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_17_index3_16); 
            d_17_index_hash_call_4.apply(SRCIP, SRCPORT, ig_md.d_17_index4_16); 
            UM_RUN_END_4(17, ig_md.d_17_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_4(17) 
        //

        // UnivMon for inst 19
            d_19_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_19_res_hash); 
            d_19_tcam_lpm.apply(ig_md.d_19_sampling_hash_16, ig_md.d_19_base_16, ig_md.d_19_threshold); 
            d_19_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_19_index1_16); 
            d_19_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_19_index2_16); 
            d_19_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_19_index3_16); 
            UM_RUN_END_3(19, ig_md.d_19_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_3(19) 
        //

        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_16_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_19_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_16_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_19_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_16_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_19_above_threshold == 1
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