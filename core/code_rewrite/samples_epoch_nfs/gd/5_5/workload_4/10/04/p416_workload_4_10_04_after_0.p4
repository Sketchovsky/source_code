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
INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_220(32768, 15, 8192)

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
        COMPUTE_HASH_100_16_16(32w0x30244f0b) d_1_auto_sampling_hash_call;

        COMPUTE_HASH_110_32_32(32w0x30244f0b) d_3_auto_sampling_hash_call;

        COMPUTE_HASH_110_16_16(32w0x30244f0b) d_6_auto_sampling_hash_call;

    //

    UM_INIT_4( 1, 100, 11, 32768)
    T2_INIT_3( 2, 100, 4096)
    T4_INIT_1( 3, 110, 8192)

    // apply O2
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_4_1;
        T2_KEY_UPDATE_110_16384(32w0x30243f0b) update_4_2;
        T2_KEY_UPDATE_110_4096(32w0x30243f0b) update_4_3;
        T2_KEY_UPDATE_110_4096(32w0x30243f0b) update_4_4;
        T2_KEY_UPDATE_110_4096(32w0x30243f0b) update_4_5;
        ABOVE_THRESHOLD_CONSTANT_5(100) d_4_above_threshold;
    // 

    UM_INIT_3( 6, 110, 11, 32768)
    // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
        ABOVE_THRESHOLD_CONSTANT_5(100) d_8_above_threshold;
        COMPUTE_HASH_220_16_16(32w0x30244f0b) d_8_res_hash_call;
        T3_T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_1;
        T3_T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_2;
        T3_T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_3;
        T3_T2_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_4;
        T3_KEY_UPDATE_220_8192(32w0x30243f0b) update_8_5;
    //

    // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
        T2_T2_KEY_UPDATE_221_16384(32w0x30243f0b) update_9_1;
    //


    HEAVY_FLOWKEY_STORAGE_CONFIG_220(32w0x30243f0b) heavy_flowkey_storage;



    apply {
        // O1 hash run
            d_1_auto_sampling_hash_call.apply(SRCIP, ig_md.d_1_sampling_hash_16);

            d_3_auto_sampling_hash_call.apply(SRCIP, SRCPORT, ig_md.d_3_sampling_hash_32);

            d_6_auto_sampling_hash_call.apply(DSTIP, DSTPORT, ig_md.d_6_sampling_hash_16);

        //

        // UnivMon for inst 1
            d_1_res_hash_call.apply(SRCIP, ig_md.d_1_res_hash); 
            d_1_tcam_lpm.apply(ig_md.d_1_sampling_hash_16, ig_md.d_1_base_16, ig_md.d_1_threshold); 
            d_1_index_hash_call_1.apply(SRCIP, ig_md.d_1_index1_16); 
            d_1_index_hash_call_2.apply(SRCIP, ig_md.d_1_index2_16); 
            d_1_index_hash_call_3.apply(SRCIP, ig_md.d_1_index3_16); 
            d_1_index_hash_call_4.apply(SRCIP, ig_md.d_1_index4_16); 
            UM_RUN_END_4(1, ig_md.d_1_res_hash, 1) 
            RUN_HEAVY_FLOWKEY_NOIF_4(1) 
        //

        T2_RUN_3_KEY_1( 2, DSTIP, SIZE)
        // HLL for inst 3
            d_3_tcam_lpm.apply(ig_md.d_3_sampling_hash_32, ig_md.d_3_level);
            update_3_1.apply(SRCIP, SRCPORT, ig_md.d_3_level);
        //


        // apply O2
        T2_RUN_AFTER_5_KEY_2(4, SRCIP, SRCPORT, 1)
        // 

        // UnivMon for inst 6
            d_6_res_hash_call.apply(DSTIP, DSTPORT, ig_md.d_6_res_hash); 
            d_6_tcam_lpm.apply(ig_md.d_6_sampling_hash_16, ig_md.d_6_base_16, ig_md.d_6_threshold); 
            d_6_index_hash_call_1.apply(DSTIP, DSTPORT, ig_md.d_6_index1_16); 
            d_6_index_hash_call_2.apply(DSTIP, DSTPORT, ig_md.d_6_index2_16); 
            d_6_index_hash_call_3.apply(DSTIP, DSTPORT, ig_md.d_6_index3_16); 
            UM_RUN_END_3(6, ig_md.d_6_res_hash, SIZE) 
            RUN_HEAVY_FLOWKEY_NOIF_3(6) 
        //

        // apply SALUMerge; big - CM/Kary/CS / small - Ent/PCSA 
            d_8_res_hash_call.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, ig_md.d_8_res_hash);
            update_8_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, 1, ig_md.d_8_res_hash[0:0], SIZE, ig_md.d_8_est_1);
            update_8_2.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, 1, ig_md.d_8_res_hash[1:1], SIZE, ig_md.d_8_est_2);
            update_8_3.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, 1, ig_md.d_8_res_hash[2:2], SIZE, ig_md.d_8_est_3);
            update_8_4.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, 1, ig_md.d_8_res_hash[3:3], SIZE, ig_md.d_8_est_4);
            update_8_5.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, 1, ig_md.d_8_res_hash[4:4], ig_md.d_8_est_5);
            RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_5(8)
        //

        // apply SALUMerge; big - PCSA or ENT / small - ENT/CM/Kary, CS, PCSA 
            update_9_1.apply(SRCIP, DSTIP, SRCPORT, DSTPORT, PROTO, SIZE, 1, ig_md.d_9_est_1);
        //

        if(
        ig_md.d_1_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        ) {
            ig_md.hf_srcip = SRCIP; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        ) {
            ig_md.hf_dstip = DSTIP; 
        }
        if(
        ig_md.d_4_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        ) {
            ig_md.hf_srcport = SRCPORT; 
        }
        if(
        ig_md.d_6_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
        ) {
            ig_md.hf_dstport = DSTPORT; 
        }
        if(
        ig_md.d_1_above_threshold == 1
        || ig_md.d_4_above_threshold == 1
        || ig_md.d_6_above_threshold == 1
        || ig_md.d_8_above_threshold == 1
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