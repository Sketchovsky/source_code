control WORKLOAD1_THRESHOLD(
    inout header_t hdr,
    inout metadata_t ig_md)
{
    action tbl_get_threshold_act (bit<32> threshold_1, bit<32> threshold_2, bit<32> threshold_3, bit<32> threshold_4, bit<32> threshold_5, bit<32> threshold_6) {
        ig_md.d_1_threshold = threshold_1;
        ig_md.d_2_threshold = threshold_2;
        ig_md.d_3_threshold = threshold_3;
        ig_md.d_4_threshold = threshold_4;
        ig_md.d_5_threshold = threshold_5;
        ig_md.d_6_threshold = threshold_6;
    }
    table tbl_get_threshold {
        key = {
            hdr.ethernet.ether_type : exact;
        }
        actions = {
            tbl_get_threshold_act;
        }
    }
    apply {
        tbl_get_threshold.apply();
    }
}

control WORKLOAD2_THRESHOLD(
    inout header_t hdr,
    inout metadata_t ig_md)
{
    action tbl_get_threshold_act (bit<32> threshold_6, bit<32> threshold_7, bit<32> threshold_8) {
        ig_md.d_6_threshold = threshold_6;
        ig_md.d_7_threshold = threshold_7;
        ig_md.d_8_threshold = threshold_8;
    }
    table tbl_get_threshold {
        key = {
            hdr.ethernet.ether_type : exact;
        }
        actions = {
            tbl_get_threshold_act;
        }
    }
    apply {
        tbl_get_threshold.apply();
    }
}

