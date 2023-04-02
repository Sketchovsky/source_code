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
}
#include "parser.p4"
#include "all_include.p4"
#define SRCIP hdr.ipv4.src_addr
#define DSTIP hdr.ipv4.dst_addr
#define SRCPORT ig_md.src_port
#define DSTPORT ig_md.dst_port
#define PROTO hdr.ipv4.protocol
#define SIZE hdr.ipv4.total_len
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_110(65536, 16, 16384)

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
        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_2_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_14_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_12_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_13_auto_sampling_hash_call;

    //

    T1_INIT_2( 1, 110, 262144)
    MRB_INIT_1( 2, 110, 131072, 14,  8)
    // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
        ABOVE_THRESHOLD_CONSTANT_2(100) d_7_above_threshold;
        T2_T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_3_1;
        T2_T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_3_2;
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_3_3;
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_3_4;
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_3_5;
    //

    T2_INIT_HH_1( 4, 110, 4096)
    T2_INIT_HH_2( 6, 110, 16384)
    T3_INIT_HH_1( 5, 110, 16384)
    T2_INIT_HH_4( 8, 110, 4096)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(14, 110)
        ABOVE_THRESHOLD_3() d_14_above_threshold;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_14_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_14_1;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_14_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_14_2;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_14_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_14_3;
    // 

    UM_INIT_4(12, 110, 11, 32768)
    MRAC_INIT_1(10, 110, 16384, 11,  8)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(13, 110)
        ABOVE_THRESHOLD_3() d_13_above_threshold;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_13_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_13_1;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_13_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_13_2;
        COMPUTE_HASH_110_16_11(32w0x30244f0b) d_13_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_13_3;
    // 


    HEAVY_FLOWKEY_STORAGE_CONFIG_110(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_2_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_2_sampling_hash_16);

            d_14_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_14_sampling_hash_16);

            d_12_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_12_sampling_hash_16);

            d_13_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_13_sampling_hash_16);

        //

        T1_RUN_2_KEY_2( 1, DSTIP, DSTPORT) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0) { /* process_new_flow() */ }
        // MRB for inst 2
            d_2_tcam_lpm.apply(ig_md.d_2_sampling_hash_16, ig_md.d_2_base_32);
            d_2_index_hash_call_1.apply(DSTIP, DSTPORT, ig_md.d_2_index1_16);
            update_2_1.apply(ig_md.d_2_base_32, ig_md.d_2_index1_16);
        //

        // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
            update_3_1.apply(DSTIP, DSTPORT, SIZE, 1, ig_md.d_3_est_1);
            update_3_2.apply(DSTIP, DSTPORT, SIZE, 1, ig_md.d_3_est_2);
            d_7_above_threshold.apply(ig_md.d_3_est_1, ig_md.d_3_est_2, ig_md.d_7_above_threshold);
            update_3_3.apply(DSTIP, DSTPORT, SIZE, ig_md.d_3_est_3);
            update_3_4.apply(DSTIP, DSTPORT, SIZE, ig_md.d_3_est_4);
            update_3_5.apply(DSTIP, DSTPORT, SIZE, ig_md.d_3_est_5);
        //

        T2_RUN_AFTER_1_KEY_2( 4, DSTIP, DSTPORT, SIZE)
        T2_RUN_AFTER_2_KEY_2( 6, DSTIP, DSTPORT, 1)
        T3_RUN_AFTER_1_KEY_2( 5, DSTIP, DSTPORT, SIZE)
        T2_RUN_AFTER_4_KEY_2( 8, DSTIP, DSTPORT, SIZE)

        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_14_res_hash_call.apply(DSTIP, DSTPORT, ig_md.d_14_res_hash);
        d_14_tcam_lpm_2.apply(ig_md.d_14_sampling_hash_16, ig_md.d_14_base_16_1024, ig_md.d_14_base_16_2048, ig_md.d_14_threshold);
        d_14_index_hash_call_1.apply(DSTIP, DSTPORT, ig_md.d_14_index1_16);
        update_14_1.apply(ig_md.d_14_base_16_2048, ig_md.d_14_index1_16, ig_md.d_14_res_hash[0:0], SIZE, ig_md.d_14_est_1);
        d_14_index_hash_call_2.apply(DSTIP, DSTPORT, ig_md.d_14_index2_16);
        update_14_2.apply(ig_md.d_14_base_16_2048, ig_md.d_14_index2_16, ig_md.d_14_res_hash[1:1], SIZE, ig_md.d_14_est_2);
        d_14_index_hash_call_3.apply(DSTIP, DSTPORT, ig_md.d_14_index3_16);
        update_14_3.apply(ig_md.d_14_base_16_2048, ig_md.d_14_index3_16, ig_md.d_14_res_hash[2:2], SIZE, ig_md.d_14_est_3);
        RUN_HEAVY_FLOWKEY_NOIF_3(14)
        // 

        // UnivMon for inst 12
            d_12_res_hash_call.apply(DSTIP, DSTPORT, ig_md.d_12_res_hash); 
            d_12_tcam_lpm.apply(ig_md.d_12_sampling_hash_16, ig_md.d_12_base_16, ig_md.d_12_threshold); 
            d_12_index_hash_call_1.apply(DSTIP, DSTPORT, ig_md.d_12_index1_16); 
            d_12_index_hash_call_2.apply(DSTIP, DSTPORT, ig_md.d_12_index2_16); 
            d_12_index_hash_call_3.apply(DSTIP, DSTPORT, ig_md.d_12_index3_16); 
            d_12_index_hash_call_4.apply(DSTIP, DSTPORT, ig_md.d_12_index4_16); 
            UM_RUN_END_4(12, ig_md.d_12_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_4(12) 
        //

        // MRAC for inst 10
            d_10_tcam_lpm.apply(ig_md.d_2_sampling_hash_16, ig_md.d_10_base_16);
            d_10_index_hash_call_1.apply(DSTIP, DSTPORT, ig_md.d_10_index1_16);
            update_10_1.apply(ig_md.d_10_base_16, ig_md.d_10_index1_16);
        //


        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_13_res_hash_call.apply(DSTIP, DSTPORT, ig_md.d_13_res_hash);
        d_13_tcam_lpm_2.apply(ig_md.d_13_sampling_hash_16, ig_md.d_13_base_16_1024, ig_md.d_13_base_16_2048, ig_md.d_13_threshold);
        d_13_index_hash_call_1.apply(DSTIP, DSTPORT, ig_md.d_13_index1_16);
        update_13_1.apply(ig_md.d_13_base_16_2048, ig_md.d_13_index1_16, ig_md.d_13_res_hash[0:0], 1, ig_md.d_13_est_1);
        d_13_index_hash_call_2.apply(DSTIP, DSTPORT, ig_md.d_13_index2_16);
        update_13_2.apply(ig_md.d_13_base_16_2048, ig_md.d_13_index2_16, ig_md.d_13_res_hash[1:1], 1, ig_md.d_13_est_2);
        d_13_index_hash_call_3.apply(DSTIP, DSTPORT, ig_md.d_13_index3_16);
        update_13_3.apply(ig_md.d_13_base_16_2048, ig_md.d_13_index3_16, ig_md.d_13_res_hash[2:2], 1, ig_md.d_13_est_3);
        RUN_HEAVY_FLOWKEY_NOIF_3(13)
        // 

        if(
        ig_md.d_7_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_7_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_7_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        ) {
            heavy_flowkey_storage.apply(ig_dprsr_md,ig_md.hf_dstip, ig_md.hf_dstport); 
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