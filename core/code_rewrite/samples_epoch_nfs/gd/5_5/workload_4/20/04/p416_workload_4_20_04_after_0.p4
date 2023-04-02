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
        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_4_auto_sampling_hash_call;

        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_8_auto_sampling_hash_call;

        COMPUTE_HASH_200_16_16(32w0x30244f0b) d_12_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_13_auto_sampling_hash_call;

        COMPUTE_HASH_110_32_32(32w0x30244f0b) d_14_auto_sampling_hash_call;

        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_16_auto_sampling_hash_call;

        COMPUTE_HASH_221_16_16(32w0x30244f0b) d_20_auto_sampling_hash_call;

    //


    // apply O2
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_1_1;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_1_2;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_1_3;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_1_4;
        T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_1_5;
        ABOVE_THRESHOLD_CONSTANT_5(100) d_1_above_threshold;
    // 


    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(4, 100)
        ABOVE_THRESHOLD_3() d_4_above_threshold;
        COMPUTE_HASH_100_16_11(32w0x30244f0b) d_4_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_4_1;
        COMPUTE_HASH_100_16_11(32w0x30244f0b) d_4_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_4_2;
        COMPUTE_HASH_100_16_11(32w0x30244f0b) d_4_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_4_3;
    // 

    T1_INIT_1( 5, 100, 262144)

    // apply O2
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_6_1;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_6_2;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_6_3;
        ABOVE_THRESHOLD_CONSTANT_3(100) d_6_above_threshold;
    // 

    MRAC_INIT_1( 8, 100, 16384, 11,  8)
    T2_INIT_HH_2(10, 200, 8192)

    // apply O2
        T2_KEY_UPDATE_200_8192(32w0x30243f0b) update_9_1;
        T2_KEY_UPDATE_200_8192(32w0x30243f0b) update_9_2;
        T2_KEY_UPDATE_200_8192(32w0x30243f0b) update_9_3;
        T2_KEY_UPDATE_200_8192(32w0x30243f0b) update_9_4;
        ABOVE_THRESHOLD_CONSTANT_4(100) d_9_above_threshold;
    // 

    MRAC_INIT_1(12, 200, 16384, 11,  8)
    UM_INIT_3(13, 110, 11, 32768)
    T4_INIT_1(14, 110, 4096)
    T3_INIT_HH_3(15, 220, 8192)
    MRAC_INIT_1(16, 220, 16384, 11,  8)

    // apply O2
        T2_KEY_UPDATE_221_16384(32w0x30243f0b) update_17_1;
        T2_KEY_UPDATE_221_16384(32w0x30243f0b) update_17_2;
        T2_KEY_UPDATE_221_16384(32w0x30243f0b) update_17_3;
        T2_KEY_UPDATE_221_16384(32w0x30243f0b) update_17_4;
        T2_KEY_UPDATE_221_16384(32w0x30243f0b) update_17_5;
        ABOVE_THRESHOLD_CONSTANT_5(100) d_17_above_threshold;
    // 


    // apply SALUMerge; big - UnivMon / small - many MRACs 
        UM_INIT_SETUP(20, 221)
        ABOVE_THRESHOLD_5() d_20_above_threshold;
        COMPUTE_HASH_221_16_11(32w0x30244f0b) d_20_index_hash_call_1;
        T3_T2_INDEX_UPDATE_32768() update_20_1;
        COMPUTE_HASH_221_16_11(32w0x30244f0b) d_20_index_hash_call_2;
        T3_INDEX_UPDATE_32768() update_20_2;
        COMPUTE_HASH_221_16_11(32w0x30244f0b) d_20_index_hash_call_3;
        T3_INDEX_UPDATE_32768() update_20_3;
        COMPUTE_HASH_221_16_11(32w0x30244f0b) d_20_index_hash_call_4;
        T3_INDEX_UPDATE_32768() update_20_4;
        COMPUTE_HASH_221_16_11(32w0x30244f0b) d_20_index_hash_call_5;
        T3_INDEX_UPDATE_32768() update_20_5;
    // 


    HEAVY_FLOWKEY_STORAGE_CONFIG_221(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_4_auto_sampling_hash_call.apply(SRCIP, ig_md.d_4_sampling_hash_16);

            d_8_auto_sampling_hash_call.apply(DSTIP, ig_md.d_8_sampling_hash_16);

            d_12_auto_sampling_hash_call.apply(SRCIP, DSTIP, ig_md.d_12_sampling_hash_16);

            d_13_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_13_sampling_hash_16);

            d_14_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_14_sampling_hash_32);

            d_16_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_16_sampling_hash_16);

            d_20_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_20_sampling_hash_16);

        //


        // apply O2
        T2_RUN_AFTER_5_KEY_1(1, SRCIP, 1)
        // 


        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_4_res_hash_call.apply(SRCIP, ig_md.d_4_res_hash);
        d_4_tcam_lpm_2.apply(ig_md.d_4_sampling_hash_16, ig_md.d_4_base_16_1024, ig_md.d_4_base_16_2048, ig_md.d_4_threshold);
        d_4_index_hash_call_1.apply(SRCIP, ig_md.d_4_index1_16);
        update_4_1.apply(ig_md.d_4_base_16_2048, ig_md.d_4_index1_16, ig_md.d_4_res_hash[0:0], SIZE, ig_md.d_4_est_1);
        d_4_index_hash_call_2.apply(SRCIP, ig_md.d_4_index2_16);
        update_4_2.apply(ig_md.d_4_base_16_2048, ig_md.d_4_index2_16, ig_md.d_4_res_hash[1:1], SIZE, ig_md.d_4_est_2);
        d_4_index_hash_call_3.apply(SRCIP, ig_md.d_4_index3_16);
        update_4_3.apply(ig_md.d_4_base_16_2048, ig_md.d_4_index3_16, ig_md.d_4_res_hash[2:2], SIZE, ig_md.d_4_est_3);
        RUN_HEAVY_FLOWKEY_NOIF_3(4)
        // 

        T1_RUN_1_KEY_1( 5, DSTIP) if (ig_md.d_5_est1_1 == 0) { /* process_new_flow() */ }

        // apply O2
        T2_RUN_AFTER_3_KEY_1(6, DSTIP, SIZE)
        // 

        // MRAC for inst 8
            d_8_tcam_lpm.apply(ig_md.d_8_sampling_hash_16, ig_md.d_8_base_16);
            d_8_index_hash_call_1.apply(DSTIP, ig_md.d_8_index1_16);
            update_8_1.apply(ig_md.d_8_base_16, ig_md.d_8_index1_16);
        //

        T2_RUN_AFTER_2_KEY_2(10, SRCIP, DSTIP, 1)

        // apply O2
        T2_RUN_AFTER_4_KEY_2(9, SRCIP, DSTIP, SIZE)
        // 

        // MRAC for inst 12
            d_12_tcam_lpm.apply(ig_md.d_12_sampling_hash_16, ig_md.d_12_base_16);
            d_12_index_hash_call_1.apply(SRCIP, DSTIP, ig_md.d_12_index1_16);
            update_12_1.apply(ig_md.d_12_base_16, ig_md.d_12_index1_16);
        //

        // UnivMon for inst 13
            d_13_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_13_res_hash); 
            d_13_tcam_lpm.apply(ig_md.d_13_sampling_hash_16, ig_md.d_13_base_16, ig_md.d_13_threshold); 
            d_13_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_13_index1_16); 
            d_13_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_13_index2_16); 
            d_13_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_13_index3_16); 
            UM_RUN_END_3(13, ig_md.d_13_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_3(13) 
        //

        // HLL for inst 14
            d_14_tcam_lpm.apply(ig_md.d_14_sampling_hash_32, ig_md.d_14_level);
            update_14_1.apply(DSTIP, DSTPORT, ig_md.d_14_level);
        //

        T3_RUN_AFTER_3_KEY_4(15, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)
        // MRAC for inst 16
            d_16_tcam_lpm.apply(ig_md.d_16_sampling_hash_16, ig_md.d_16_base_16);
            d_16_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_16_index1_16);
            update_16_1.apply(ig_md.d_16_base_16, ig_md.d_16_index1_16);
        //


        // apply O2
        T2_RUN_AFTER_5_KEY_5(17, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, 1)
        // 


        // apply SALUMerge; big - UnivMon / small - many MRACs 
        d_20_res_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_20_res_hash);
        d_20_tcam_lpm_2.apply(ig_md.d_20_sampling_hash_16, ig_md.d_20_base_16_1024, ig_md.d_20_base_16_2048, ig_md.d_20_threshold);
        d_20_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_20_index1_16);
        update_20_1.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index1_16, ig_md.d_20_res_hash[0:0], SIZE, ig_md.d_20_est_1);
        d_20_index_hash_call_2.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_20_index2_16);
        update_20_2.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index2_16, ig_md.d_20_res_hash[1:1], SIZE, ig_md.d_20_est_2);
        d_20_index_hash_call_3.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_20_index3_16);
        update_20_3.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index3_16, ig_md.d_20_res_hash[2:2], SIZE, ig_md.d_20_est_3);
        d_20_index_hash_call_4.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_20_index4_16);
        update_20_4.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index4_16, ig_md.d_20_res_hash[3:3], SIZE, ig_md.d_20_est_4);
        d_20_index_hash_call_5.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_20_index5_16);
        update_20_5.apply(ig_md.d_20_base_16_2048, ig_md.d_20_index5_16, ig_md.d_20_res_hash[4:4], SIZE, ig_md.d_20_est_5);
        RUN_HEAVY_FLOWKEY_NOIF_5(20)
        // 

        if(
        ig_md.d_1_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_13_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_15_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_17_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
        ) {
            ig_md.hf_proto = PROTO; 
        }
        if(
        ig_md.d_1_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_10_above_threshold == 1
        || ig_md.d_9_above_threshold == 1
        || ig_md.d_13_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_17_above_threshold == 1
        || ig_md.d_20_above_threshold == 1
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