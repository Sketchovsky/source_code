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
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_220(32768, 15, 14336)

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
        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_5_auto_sampling_hash_call;

        COMPUTE_HASH_220_32_32(32w0x30244f0b) d_3_auto_sampling_hash_call;

        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_20_auto_sampling_hash_call;

    //


    // apply O2
        T1_KEY_UPDATE_220_524288(32w0x30243f0b) update_1_1;
        T1_KEY_UPDATE_220_524288(32w0x30243f0b) update_1_2;
        T1_KEY_UPDATE_220_524288(32w0x30243f0b) update_1_3;
    // 

    T1_INIT_3( 2, 220, 262144)
    T4_INIT_1( 3, 220, 16384)
    MRB_INIT_1( 5, 220, 262144, 15,  8)
    // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_6_res_hash_call;
        ABOVE_THRESHOLD_CONSTANT_1(100) d_12_above_threshold;
        T3_T2_KEY_UPDATE_220_16384(32w0x30243f0b) update_6_1;
        T2_KEY_UPDATE_220_16384(32w0x30243f0b) update_6_2;
        T2_KEY_UPDATE_220_16384(32w0x30243f0b) update_6_3;
        T2_KEY_UPDATE_220_16384(32w0x30243f0b) update_6_4;
        T2_KEY_UPDATE_220_16384(32w0x30243f0b) update_6_5;
    //

    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
        ABOVE_THRESHOLD_CONSTANT_4(100) d_13_above_threshold;
        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_13_res_hash_call;
        T3_T2_KEY_UPDATE_220_4096(32w0x30243f0b) update_13_1;
        T3_KEY_UPDATE_220_4096(32w0x30243f0b) update_13_2;
        T3_KEY_UPDATE_220_4096(32w0x30243f0b) update_13_3;
        T3_KEY_UPDATE_220_4096(32w0x30243f0b) update_13_4;
    //

    T3_INIT_HH_3(14, 220, 8192)

    // apply O2
        T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_1;
        T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_2;
        T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_3;
        T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_4;
        T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_5;
        ABOVE_THRESHOLD_CONSTANT_5(100) d_8_above_threshold;
    // 

    T2_INIT_HH_5(10, 220, 4096)
    // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
        ABOVE_THRESHOLD_CONSTANT_1(100) d_11_above_threshold;
        T2_T2_KEY_UPDATE_220_16384(32w0x30243f0b) update_9_1;
    //

    MRAC_INIT_1(16, 220, 32768, 11, 16)

    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(20, 220)
        ABOVE_THRESHOLD_5() d_20_above_threshold;
        COMPUTE_HASH_220_16_11(32w0x30244f0b) d_20_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_20_1;
        COMPUTE_HASH_220_16_11(32w0x30244f0b) d_20_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_20_2;
        COMPUTE_HASH_220_16_11(32w0x30244f0b) d_20_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_20_3;
        COMPUTE_HASH_220_16_11(32w0x30244f0b) d_20_index_hash_call_4;
        T3_INDEX_UPDATE_32768() update_20_4;
        COMPUTE_HASH_220_16_11(32w0x30244f0b) d_20_index_hash_call_5;
        T3_INDEX_UPDATE_32768() update_20_5;
    // 

    MRAC_INIT_1(18, 220, 16384, 11,  8)
    MRAC_INIT_1(19, 220, 32768, 11, 16)

    HEAVY_FLOWKEY_STORAGE_CONFIG_220(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_5_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_5_sampling_hash_16);

            d_3_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_3_sampling_hash_32);

            d_20_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_20_sampling_hash_16);

        //


        // apply O2
        T1_RUN_3_KEY_4(1, SRCIP, DSTIP, SRCPORT, DSTPORT) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0 || ig_md.d_1_est1_3 == 0) { /* process_new_flow() */ }
        // 

        T1_RUN_3_KEY_4( 2, SRCIP, DSTIP, SRCPORT, DSTPORT) if (ig_md.d_2_est1_1 == 0 || ig_md.d_2_est1_2 == 0 || ig_md.d_2_est1_3 == 0) { /* process_new_flow() */ }
        // HLL for inst 3
            d_3_tcam_lpm.apply(ig_md.d_3_sampling_hash_32, ig_md.d_3_level);
            update_3_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_3_level);
        //

        // MRB for inst 5
            d_5_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_5_base_32);
            d_5_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_5_index1_16);
            update_5_1.apply(ig_md.d_5_base_32, ig_md.d_5_index1_16);
        //

        // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
            d_6_res_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_6_res_hash);
            update_6_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_6_res_hash[0:0], 1, ig_md.d_6_est_1);
            d_12_above_threshold.apply(ig_md.d_6_est_1, ig_md.d_12_above_threshold);
            update_6_2.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_6_est_2);
            update_6_3.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_6_est_3);
            update_6_4.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_6_est_4);
            update_6_5.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_6_est_5);
        //

        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
            d_13_res_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_13_res_hash);
            update_13_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_13_res_hash[0:0], SIZE, ig_md.d_13_est_1);
            update_13_2.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_13_res_hash[1:1], ig_md.d_13_est_2);
            update_13_3.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_13_res_hash[2:2], ig_md.d_13_est_3);
            update_13_4.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE, ig_md.d_13_res_hash[3:3], ig_md.d_13_est_4);
            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_4(13)
        //

        T3_RUN_AFTER_3_KEY_4(14, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)

        // apply O2
        T2_RUN_AFTER_5_KEY_4(8, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)
        // 

        T2_RUN_AFTER_5_KEY_4(10, SRCIP, DSTIP, SRCPORT, DSTPORT, 1)
        // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
            update_9_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, 1, SIZE, ig_md.d_9_est_1);
            d_11_above_threshold.apply(ig_md.d_9_est_1, ig_md.d_11_above_threshold);
        //

        // MRAC for inst 16
            d_16_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_16_base_16);
            d_16_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_16_index1_16);
            update_16_1.apply(ig_md.d_16_base_16, ig_md.d_16_index1_16);
        //


        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_20_res_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_20_res_hash);
        d_20_tcam_lpm_2.apply(ig_md.d_20_sampling_hash_16, ig_md.d_20_base_16_1024, ig_md.d_20_base_16_2048, ig_md.d_20_threshold);
        d_20_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_20_index1_16);
        update_20_1.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index1_16, ig_md.d_20_res_hash[0:0], 1, ig_md.d_20_est_1);
        d_20_index_hash_call_2.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_20_index2_16);
        update_20_2.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index2_16, ig_md.d_20_res_hash[1:1], 1, ig_md.d_20_est_2);
        d_20_index_hash_call_3.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_20_index3_16);
        update_20_3.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index3_16, ig_md.d_20_res_hash[2:2], 1, ig_md.d_20_est_3);
        d_20_index_hash_call_4.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_20_index4_16);
        update_20_4.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index4_16, ig_md.d_20_res_hash[3:3], 1, ig_md.d_20_est_4);
        d_20_index_hash_call_5.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_20_index5_16);
        update_20_5.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index5_16, ig_md.d_20_res_hash[4:4], 1, ig_md.d_20_est_5);
        RUN_HEAVY_FLOWKEY_NOIF_5(20)
        // 

        // MRAC for inst 18
            d_18_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_18_base_16);
            d_18_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_18_index1_16);
            update_18_1.apply(ig_md.d_18_base_16, ig_md.d_18_index1_16);
        //

        // MRAC for inst 19
            d_19_tcam_lpm.apply(ig_md.d_5_sampling_hash_16, ig_md.d_19_base_16);
            d_19_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_19_index1_16);
            update_19_1.apply(ig_md.d_19_base_16, ig_md.d_19_index1_16);
        //

        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_12_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
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