control GET_BITMASK (
    in bit<8> level,
    out bit<32> ret_bitmask)
{
    action tbl_act (bit<32> bitmask) {
        ret_bitmask = bitmask;
    }
    table tbl_select_bitmask {
        key = {
            level : exact;
        }
        actions = {
            tbl_act;
        }
        size = 128;
    }
    apply {
        tbl_select_bitmask.apply();
    }
}



control TCAM_LPM_HLLPCSA (
    in bit<32> sampling_hash,
    out bit<8> ret_level)
{
    action tbl_act (bit<8> level) {
        ret_level = level;
    }
    table tbl_select_level {
        key = {
            sampling_hash : lpm;
        }
        actions = {
            tbl_act;
        }
        size = 128;
    }
    apply {
        tbl_select_level.apply();
    }
}


control LPM_OPT_UM(
    in bit<16> sampling_hash,
    out bit<16> ret_base,
    out bit<32> ret_threshold)
{
    action tbl_act (bit<16> base, bit<32> threshold) {
        ret_base = base;
        ret_threshold = threshold;
    }

    table tbl_select_level {
        key = {
            sampling_hash : lpm;
        }
        actions = {
            tbl_act;
        }
        size = 128;
    }

    apply {
        tbl_select_level.apply();
    }
}

control LPM_OPT_UM_2(
    in bit<16> sampling_hash,
    out bit<16> ret_base_1024,
    out bit<16> ret_base_2048,
    out bit<32> ret_threshold)
{
    action tbl_act (bit<16> base_1024, bit<16> base_2048, bit<32> threshold) {
        ret_base_1024 = base_1024;
        ret_base_2048 = base_2048;
        ret_threshold = threshold;
    }

    table tbl_select_level {
        key = {
            sampling_hash : lpm;
        }
        actions = {
            tbl_act;
        }
        size = 128;
    }

    apply {
        tbl_select_level.apply();
    }
}


control LPM_OPT_MRAC(
    in bit<16> sampling_hash,
    out bit<16> ret_base)
{
    action tbl_act (bit<16> base) {
        ret_base = base;
    }

    table tbl_select_level {
        key = {
            sampling_hash : lpm;
        }
        actions = {
            tbl_act;
        }
        size = 128;
    }

    apply {
        tbl_select_level.apply();
    }
}


control LPM_OPT_MRAC_2(
    in bit<16> sampling_hash,
    out bit<16> ret_base_1024,
    out bit<16> ret_base_2048)
{
    action tbl_act (bit<16> base_1024, bit<16> base_2048) {
        ret_base_1024 = base_1024;
        ret_base_2048 = base_2048;
    }

    table tbl_select_level {
        key = {
            sampling_hash : lpm;
        }
        actions = {
            tbl_act;
        }
        size = 128;
    }

    apply {
        tbl_select_level.apply();
    }
}


control LPM_OPT_MRB(
    in bit<16> sampling_hash,
    out bit<32> ret_base)
{
    action tbl_act (bit<32> base) {
        ret_base = base;
    }

    table tbl_select_level {
        key = {
            sampling_hash : lpm;
        }
        actions = {
            tbl_act;
        }
        size = 128;
    }

    apply {
        tbl_select_level.apply();
    }
}
