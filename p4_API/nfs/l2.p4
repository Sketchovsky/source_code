control L2(
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_tm_t  ig_tm_md) {
    action set_egr(bit<9> port){
        ig_tm_md.ucast_egress_port = port;
    }
    
    table l2_forward {
        key = { 
            hdr.ethernet.dst_addr : exact;
        }
        actions = { set_egr; NoAction; }
        const default_action = NoAction();
        size=51200; // 50K, 25SRAM (400K)
        // size=102400; // 100K, 50SRAM (5%)
        // size=153600; // 150K, 75SRAM
    }

    apply {
        l2_forward.apply();
    }
}
