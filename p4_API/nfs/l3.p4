control L3(
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_tm_t  ig_tm_md) {
    
    action set_nhop(bit<9> port){
        ig_tm_md.ucast_egress_port = port;
    }
    
    table ipv4_lpm {
        key = {hdr.ipv4.dst_addr : lpm;}
        actions = { set_nhop;}
        // size=512; // 1 TCAM
        size=10240; // 20 TCAM (7%) * 9 63%
        // size=24576; // 48 TCAM (16.6%) 24K
        // size=36864; // 72 TCAM (25%) 36K
    }
    apply {
        ipv4_lpm.apply();
    }
}
