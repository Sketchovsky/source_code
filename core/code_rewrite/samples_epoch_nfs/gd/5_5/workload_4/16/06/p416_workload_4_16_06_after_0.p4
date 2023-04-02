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
}
#include "parser.p4"
#include "all_include.p4"
#define SRCIP hdr.ipv4.src_addr
#define DSTIP hdr.ipv4.dst_addr
#define SRCPORT ig_md.src_port
#define DSTPORT ig_md.dst_port
#define PROTO hdr.ipv4.protocol
#define SIZE hdr.ipv4.total_len
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_221(65536, 16, 16384)

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
        COMPUTE_HASH_221_16_16(32w0x30244f0b) d_13_auto_sampling_hash_call;

        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_2_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_7_auto_sampling_hash_call;

        COMPUTE_HASH_110_32_32(32w0x30244f0b) d_9_auto_sampling_hash_call;

    //

    T1_INIT_2( 1, 100, 262144)
    UM_INIT_4( 2, 100, 11, 32768)
    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
        ABOVE_THRESHOLD_CONSTANT_2(100) d_4_above_threshold;
        T2_T2_KEY_UPDATE_100_16384(32w0x30243f0b) update_4_1;
        T2_KEY_UPDATE_100_8192(32w0x30243f0b) update_4_2;
    //

    T2_INIT_HH_2( 5, 200, 8192)
    T3_INIT_HH_3( 6, 110, 4096)
    UM_INIT_3( 7, 110, 11, 32768)
    T1_INIT_5( 8, 110, 262144)
    T4_INIT_1( 9, 110, 16384)
    T1_INIT_2(10, 220, 262144)
    T2_INIT_HH_3(11, 220, 8192)
    T1_INIT_5(12, 221, 131072)
    MRB_INIT_1(13, 221, 262144, 15,  8)
    T2_INIT_HH_1(15, 221, 16384)
    T2_INIT_HH_3(14, 221, 4096)
    MRAC_INIT_1(16, 221, 32768, 11, 16)

    HEAVY_FLOWKEY_STORAGE_CONFIG_221(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_13_auto_sampling_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_13_sampling_hash_16);

            d_2_auto_sampling_hash_call.apply(SRCIP, ig_md.d_2_sampling_hash_16);

            d_7_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_7_sampling_hash_16);

            d_9_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_9_sampling_hash_32);

        //

        T1_RUN_2_KEY_1( 1, SRCIP) if (ig_md.d_1_est1_1 == 0 || ig_md.d_1_est1_2 == 0) { /* process_new_flow() */ }
        // UnivMon for inst 2
            d_2_res_hash_call.apply(SRCIP, ig_md.d_2_res_hash); 
            d_2_tcam_lpm.apply(ig_md.d_2_sampling_hash_16, ig_md.d_2_base_16, ig_md.d_2_threshold); 
            d_2_index_hash_call_1.apply(SRCIP, ig_md.d_2_index1_16); 
            d_2_index_hash_call_2.apply(SRCIP, ig_md.d_2_index2_16); 
            d_2_index_hash_call_3.apply(SRCIP, ig_md.d_2_index3_16); 
            d_2_index_hash_call_4.apply(SRCIP, ig_md.d_2_index4_16); 
            UM_RUN_END_4(2, ig_md.d_2_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_4(2) 
        //

        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
            update_4_1.apply(DSTIP, SIZE, 1, ig_md.d_4_est_1);
            update_4_2.apply(DSTIP, SIZE, ig_md.d_4_est_2);
            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_2(4)
        //

        T2_RUN_AFTER_2_KEY_2( 5, SRCIP, DSTIP, 1)
        T3_RUN_AFTER_3_KEY_2( 6, SRCIP, SRCPORT, SIZE)
        // UnivMon for inst 7
            d_7_res_hash_call.apply(SRCIP, SRCPORT, ig_md.d_7_res_hash); 
            d_7_tcam_lpm.apply(ig_md.d_7_sampling_hash_16, ig_md.d_7_base_16, ig_md.d_7_threshold); 
            d_7_index_hash_call_1.apply(SRCIP, SRCPORT, ig_md.d_7_index1_16); 
            d_7_index_hash_call_2.apply(SRCIP, SRCPORT, ig_md.d_7_index2_16); 
            d_7_index_hash_call_3.apply(SRCIP, SRCPORT, ig_md.d_7_index3_16); 
            UM_RUN_END_3(7, ig_md.d_7_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_3(7) 
        //

        T1_RUN_5_KEY_2( 8, DSTIP, DSTPORT) if (ig_md.d_8_est1_1 == 0 || ig_md.d_8_est1_2 == 0 || ig_md.d_8_est1_3 == 0 || ig_md.d_8_est1_4 == 0 || ig_md.d_8_est1_5 == 0) { /* process_new_flow() */ }
        // HLL for inst 9
            d_9_tcam_lpm.apply(ig_md.d_9_sampling_hash_32, ig_md.d_9_level);
            update_9_1.apply(DSTIP, DSTPORT, ig_md.d_9_level);
        //

        T1_RUN_2_KEY_4(10, SRCIP, DSTIP, SRCPORT, DSTPORT) if (ig_md.d_10_est1_1 == 0 || ig_md.d_10_est1_2 == 0) { /* process_new_flow() */ }
        T2_RUN_AFTER_3_KEY_4(11, SRCIP, DSTIP, SRCPORT, DSTPORT, SIZE)
        T1_RUN_5_KEY_5(12, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO) if (ig_md.d_12_est1_1 == 0 || ig_md.d_12_est1_2 == 0 || ig_md.d_12_est1_3 == 0 || ig_md.d_12_est1_4 == 0 || ig_md.d_12_est1_5 == 0) { /* process_new_flow() */ }
        // MRB for inst 13
            d_13_tcam_lpm.apply(ig_md.d_13_sampling_hash_16, ig_md.d_13_base_32);
            d_13_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_13_index1_16);
            update_13_1.apply(ig_md.d_13_base_32, ig_md.d_13_index1_16);
        //

        T2_RUN_AFTER_1_KEY_5(15, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, SIZE)
        T2_RUN_AFTER_3_KEY_5(14, SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, 1)
        // MRAC for inst 16
            d_16_tcam_lpm.apply(ig_md.d_13_sampling_hash_16, ig_md.d_16_base_16);
            d_16_index_hash_call_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, ig_md.d_16_index1_16);
            update_16_1.apply(ig_md.d_16_base_16, ig_md.d_16_index1_16);
        //

        if(
        ig_md.d_2_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_4_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_11_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_15_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
        ) {
            ig_md.hf_proto = PROTO; 
        }
        if(
        ig_md.d_2_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_5_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_7_above_threshold == 1
        || ig_md.d_11_above_threshold == 1
        || ig_md.d_15_above_threshold == 1
        || ig_md.d_14_above_threshold == 1
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