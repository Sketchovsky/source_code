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
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_100(32768, 15, 12288)

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
        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_16_auto_sampling_hash_call;

        COMPUTE_HASH_100_32_32(32w0x30244f0b) d_5_auto_sampling_hash_call;

        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_20_auto_sampling_hash_call;

    //

    T1_INIT_2( 1, 100, 131072)
    T1_INIT_1( 2, 100, 262144)

    // apply O2
        T1_KEY_UPDATE_100_524288(32w0x30243f0b) update_3_1;
        T1_KEY_UPDATE_100_524288(32w0x30243f0b) update_3_2;
        T1_KEY_UPDATE_100_524288(32w0x30243f0b) update_3_3;
        T1_KEY_UPDATE_100_524288(32w0x30243f0b) update_3_4;
        T1_KEY_UPDATE_100_524288(32w0x30243f0b) update_3_5;
    // 

    T1_INIT_3( 4, 100, 131072)
    T4_INIT_1( 5, 100, 16384)
    // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
        ABOVE_THRESHOLD_CONSTANT_2(100) d_14_above_threshold;
        T2_T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_7_1;
        T2_T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_7_2;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_7_3;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_7_4;
    //


    // apply O2
        T2_KEY_UPDATE_100_4096(32w0x30243f0b) update_8_1;
        T2_KEY_UPDATE_100_4096(32w0x30243f0b) update_8_2;
        T2_KEY_UPDATE_100_4096(32w0x30243f0b) update_8_3;
        T2_KEY_UPDATE_100_4096(32w0x30243f0b) update_8_4;
        T2_KEY_UPDATE_100_4096(32w0x30243f0b) update_8_5;
        ABOVE_THRESHOLD_CONSTANT_5(100) d_8_above_threshold;
    // 

    T2_INIT_1( 9, 100, 16384)
    T3_INIT_HH_1(13, 100, 8192)

    // apply O2
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_10_1;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_10_2;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_10_3;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_10_4;
        T2_KEY_UPDATE_100_4096(32w0x30243f0b) update_10_5;
        ABOVE_THRESHOLD_CONSTANT_5(100) d_10_above_threshold;
    // 

    MRAC_INIT_1(16, 100, 16384, 11,  8)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(20, 100)
        ABOVE_THRESHOLD_3() d_20_above_threshold;
        COMPUTE_HASH_100_16_11(32w0x30244f0b) d_20_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_20_1;
        COMPUTE_HASH_100_16_11(32w0x30244f0b) d_20_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_20_2;
        COMPUTE_HASH_100_16_11(32w0x30244f0b) d_20_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_20_3;
    // 

    MRAC_INIT_1(18, 100, 16384, 11,  8)
    MRAC_INIT_1(19, 100, 32768, 11, 16)

    HEAVY_FLOWKEY_STORAGE_CONFIG_100(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_16_auto_sampling_hash_call.apply(DSTIP, ig_md.d_16_sampling_hash_16);

            d_5_auto_sampling_hash_call.apply(DSTIP, ig_md.d_5_sampling_hash_32);

            d_20_auto_sampling_hash_call.apply(DSTIP, ig_md.d_20_sampling_hash_16);

        //

        T1_RUN_2_KEY_1( 1, DSTIP) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0) { /* process_new_flow() */ }
        T1_RUN_1_KEY_1( 2, DSTIP) if (ig_md.d_2_est1_1 == 0) { /* process_new_flow() */ }

        // apply O2
        T1_RUN_5_KEY_1(3, DSTIP) if (ig_md.d_3_est1_1 == 0 || ig_md.d_3_est1_2 == 0 || ig_md.d_3_est1_3 == 0 || ig_md.d_3_est1_4 == 0 || ig_md.d_3_est1_5 == 0) { /* process_new_flow() */ }
        // 

        T1_RUN_3_KEY_1( 4, DSTIP) if (ig_md.d_4_est1_1 == 0 || ig_md.d_4_est1_2 == 0 || ig_md.d_4_est1_3 == 0) { /* process_new_flow() */ }
        // HLL for inst 5
            d_5_tcam_lpm.apply(ig_md.d_5_sampling_hash_32, ig_md.d_5_level);
            update_5_1.apply(DSTIP, ig_md.d_5_level);
        //

        // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
            update_7_1.apply(DSTIP, SIZE, 1, ig_md.d_7_est_1);
            update_7_2.apply(DSTIP, SIZE, 1, ig_md.d_7_est_2);
            d_14_above_threshold.apply(ig_md.d_7_est_1, ig_md.d_7_est_2, ig_md.d_14_above_threshold);
            update_7_3.apply(DSTIP, SIZE, ig_md.d_7_est_3);
            update_7_4.apply(DSTIP, SIZE, ig_md.d_7_est_4);
        //


        // apply O2
        T2_RUN_AFTER_5_KEY_1(8, DSTIP, SIZE)
        // 

        T2_RUN_1_KEY_1( 9, DSTIP, SIZE)
        T3_RUN_AFTER_1_KEY_1(13, DSTIP, 1)

        // apply O2
        T2_RUN_AFTER_5_KEY_1(10, DSTIP, SIZE)
        // 

        // MRAC for inst 16
            d_16_tcam_lpm.apply(ig_md.d_16_sampling_hash_16, ig_md.d_16_base_16);
            d_16_index_hash_call_1.apply(DSTIP, ig_md.d_16_index1_16);
            update_16_1.apply(ig_md.d_16_base_16, ig_md.d_16_index1_16);
        //


        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_20_res_hash_call.apply(DSTIP, ig_md.d_20_res_hash);
        d_20_tcam_lpm_2.apply(ig_md.d_20_sampling_hash_16, ig_md.d_20_base_16_1024, ig_md.d_20_base_16_2048, ig_md.d_20_threshold);
        d_20_index_hash_call_1.apply(DSTIP, ig_md.d_20_index1_16);
        update_20_1.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index1_16, ig_md.d_20_res_hash[0:0], 1, ig_md.d_20_est_1);
        d_20_index_hash_call_2.apply(DSTIP, ig_md.d_20_index2_16);
        update_20_2.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index2_16, ig_md.d_20_res_hash[1:1], 1, ig_md.d_20_est_2);
        d_20_index_hash_call_3.apply(DSTIP, ig_md.d_20_index3_16);
        update_20_3.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index3_16, ig_md.d_20_res_hash[2:2], 1, ig_md.d_20_est_3);
        RUN_HEAVY_FLOWKEY_NOIF_3(20)
        // 

        // MRAC for inst 18
            d_18_tcam_lpm.apply(ig_md.d_16_sampling_hash_16, ig_md.d_18_base_16);
            d_18_index_hash_call_1.apply(DSTIP, ig_md.d_18_index1_16);
            update_18_1.apply(ig_md.d_18_base_16, ig_md.d_18_index1_16);
        //

        // MRAC for inst 19
            d_19_tcam_lpm.apply(ig_md.d_16_sampling_hash_16, ig_md.d_19_base_16);
            d_19_index_hash_call_1.apply(DSTIP, ig_md.d_19_index1_16);
            update_19_1.apply(ig_md.d_19_base_16, ig_md.d_19_index1_16);
        //

        if(
        ig_md.d_14_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_14_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            heavy_flowkey_storage.apply(ig_dprsr_md,ig_md.hf_dstip); 
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