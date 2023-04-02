control Blacklist(
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md)
{
    action drop() {
        ig_dprsr_md.drop_ctl = 1;
    }
    table blacklist {
        key = {
            /* IP 5-tuple */
            hdr.ipv4.src_addr: exact;
            hdr.ipv4.dst_addr: exact;
            hdr.tcp.src_port: exact;
            hdr.tcp.dst_port: exact;
            hdr.ipv4.protocol: exact;
        }
        actions = {
            drop;
        }
        size = 32768; // 32K, 30SRAM
        // size = 102400; // 100K, 100SRAM (10%)
        // size = 153600; // 150K, 150SRAM
        
    }

    apply{
        blacklist.apply();
    }
}
