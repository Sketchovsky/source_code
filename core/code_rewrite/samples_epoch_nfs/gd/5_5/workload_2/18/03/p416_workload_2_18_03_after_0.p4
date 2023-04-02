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
        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_15_auto_sampling_hash_call;

        COMPUTE_HASH_100_32_32(32w0x30244f0b) d_5_auto_sampling_hash_call;

        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_18_auto_sampling_hash_call;

    //

    T1_INIT_1( 1, 100, 524288)
    T1_INIT_5( 2, 100, 262144)

    // apply O2
        T1_KEY_UPDATE_100_262144(32w0x30243f0b) update_3_1;
        T1_KEY_UPDATE_100_262144(32w0x30243f0b) update_3_2;
        T1_KEY_UPDATE_100_262144(32w0x30243f0b) update_3_3;
        T1_KEY_UPDATE_100_262144(32w0x30243f0b) update_3_4;
        T1_KEY_UPDATE_100_262144(32w0x30243f0b) update_3_5;
    // 

    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
        ABOVE_THRESHOLD_CONSTANT_5(100) d_14_above_threshold;
        COMPUTE_HASH_100_32_32(32w0x30244f0b) d_14_hash_call;
        TCAM_LPM_HLLPCSA() d_14_tcam_lpm;
        GET_BITMASK() d_14_get_bitmask;
        T2_T5_KEY_UPDATE_100_8192(32w0x30243f0b) update_14_1;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_14_2;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_14_3;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_14_4;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_14_5;
    //

    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
        ABOVE_THRESHOLD_CONSTANT_5(100) d_6_above_threshold;
        T2_T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_6_1;
        T2_T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_6_2;
        T2_T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_6_3;
        T2_T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_6_4;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_6_5;
    //

    T3_INIT_HH_2(11, 100, 16384)

    // apply O2
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_7_1;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_7_2;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_7_3;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_7_4;
        ABOVE_THRESHOLD_CONSTANT_4(100) d_7_above_threshold;
    // 

    T2_INIT_4( 9, 100, 4096)
    MRAC_INIT_1(15, 100, 32768, 11, 16)
    MRAC_INIT_1(16, 100, 16384, 11,  8)
    MRAC_INIT_1(17, 100, 16384, 11,  8)
    UM_INIT_5(18, 100, 11, 32768)

    HEAVY_FLOWKEY_STORAGE_CONFIG_100(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_15_auto_sampling_hash_call.apply(SRCIP, ig_md.d_15_sampling_hash_16);

            d_5_auto_sampling_hash_call.apply(SRCIP, ig_md.d_5_sampling_hash_32);

            d_18_auto_sampling_hash_call.apply(SRCIP, ig_md.d_18_sampling_hash_16);

        //

        T1_RUN_1_KEY_1( 1, SRCIP) if (ig_md.d_1_est1_1 == 0) { /* process_new_flow() */ }
        T1_RUN_5_KEY_1( 2, SRCIP) if (ig_md.d_2_est1_1 == 0 || ig_md.d_2_est1_2 == 0 || ig_md.d_2_est1_3 == 0 || ig_md.d_2_est1_4 == 0 || ig_md.d_2_est1_5 == 0) { /* process_new_flow() */ }

        // apply O2
        T1_RUN_5_KEY_1(3, SRCIP) if (ig_md.d_3_est1_1 == 0 || ig_md.d_3_est1_2 == 0 || ig_md.d_3_est1_3 == 0 || ig_md.d_3_est1_4 == 0 || ig_md.d_3_est1_5 == 0) { /* process_new_flow() */ }
        // 

        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
            d_14_tcam_lpm.apply(ig_md.d_5_sampling_hash_32, ig_md.d_14_level);
            d_14_get_bitmask.apply(ig_md.d_14_level, ig_md.d_14_bitmask);
            update_14_1.apply(SRCIP, SIZE, ig_md.d_14_bitmask, ig_md.d_14_est_1);
            update_14_2.apply(SRCIP, SIZE, ig_md.d_14_est_2);
            update_14_3.apply(SRCIP, SIZE, ig_md.d_14_est_3);
            update_14_4.apply(SRCIP, SIZE, ig_md.d_14_est_4);
            update_14_5.apply(SRCIP, SIZE, ig_md.d_14_est_5);
            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_5(14)
        //

        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
            update_6_1.apply(SRCIP, 1, SIZE, ig_md.d_6_est_1);
            update_6_2.apply(SRCIP, 1, SIZE, ig_md.d_6_est_2);
            update_6_3.apply(SRCIP, 1, SIZE, ig_md.d_6_est_3);
            update_6_4.apply(SRCIP, 1, SIZE, ig_md.d_6_est_4);
            update_6_5.apply(SRCIP, 1, ig_md.d_6_est_5);
            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_5(6)
        //

        T3_RUN_AFTER_2_KEY_1(11, SRCIP, SIZE)

        // apply O2
        T2_RUN_AFTER_4_KEY_1(7, SRCIP, 1)
        // 

        T2_RUN_4_KEY_1( 9, SRCIP, SIZE)
        // MRAC for inst 15
            d_15_tcam_lpm.apply(ig_md.d_15_sampling_hash_16, ig_md.d_15_base_16);
            d_15_index_hash_call_1.apply(SRCIP, ig_md.d_15_index1_16);
            update_15_1.apply(ig_md.d_15_base_16, ig_md.d_15_index1_16);
        //

        // MRAC for inst 16
            d_16_tcam_lpm.apply(ig_md.d_15_sampling_hash_16, ig_md.d_16_base_16);
            d_16_index_hash_call_1.apply(SRCIP, ig_md.d_16_index1_16);
            update_16_1.apply(ig_md.d_16_base_16, ig_md.d_16_index1_16);
        //

        // MRAC for inst 17
            d_17_tcam_lpm.apply(ig_md.d_15_sampling_hash_16, ig_md.d_17_base_16);
            d_17_index_hash_call_1.apply(SRCIP, ig_md.d_17_index1_16);
            update_17_1.apply(ig_md.d_17_base_16, ig_md.d_17_index1_16);
        //

        // UnivMon for inst 18
            d_18_res_hash_call.apply(SRCIP, ig_md.d_18_res_hash); 
            d_18_tcam_lpm.apply(ig_md.d_18_sampling_hash_16, ig_md.d_18_base_16, ig_md.d_18_threshold); 
            d_18_index_hash_call_1.apply(SRCIP, ig_md.d_18_index1_16); 
            d_18_index_hash_call_2.apply(SRCIP, ig_md.d_18_index2_16); 
            d_18_index_hash_call_3.apply(SRCIP, ig_md.d_18_index3_16); 
            d_18_index_hash_call_4.apply(SRCIP, ig_md.d_18_index4_16); 
            d_18_index_hash_call_5.apply(SRCIP, ig_md.d_18_index5_16); 
            UM_RUN_END_5(18, ig_md.d_18_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_5(18) 
        //

        if(
        ig_md.d_14_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_14_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_18_above_threshold == 1
        ) {
            heavy_flowkey_storage.apply(ig_dprsr_md,ig_md.hf_srcip); 
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