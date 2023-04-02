#define ABOVE_THRESHOLD_COMMON_1() \
    action above_threshold_table_act() { \
        is_above_threshold = 1; \
    } \
    table tbl_threshold { \
        key = { \


#define ABOVE_THRESHOLD_COMMON_2() \
        } \
        actions = { \
            above_threshold_table_act; \
        } \
    } \
    apply { \
        subtract_table_act(); \
        tbl_threshold.apply(); \
    } \



control ABOVE_THRESHOLD_CONSTANT_1 (
    in bit<32> est_1,
    inout bit<1> is_above_threshold)
    (bit<32> threshold)
{
    bit<32> diff_1;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
    }
    ABOVE_THRESHOLD_COMMON_1()
        diff_1[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}




control ABOVE_THRESHOLD_CONSTANT_2 (
    in bit<32> est_1,
    in bit<32> est_2,
    inout bit<1> is_above_threshold)
    (bit<32> threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
            diff_1[31:31] : exact;
            diff_2[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}



control ABOVE_THRESHOLD_CONSTANT_3 (
    in bit<32> est_1,
    in bit<32> est_2,
    in bit<32> est_3,
    inout bit<1> is_above_threshold)
    (bit<32> threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;
    bit<32> diff_3;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
        diff_3 = est_3 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
            diff_1[31:31] : exact;
            diff_2[31:31] : exact;
            diff_3[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}


control ABOVE_THRESHOLD_CONSTANT_4 (
    in bit<32> est_1,
    in bit<32> est_2,
    in bit<32> est_3,
    in bit<32> est_4,
    inout bit<1> is_above_threshold)
    (bit<32> threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;
    bit<32> diff_3;
    bit<32> diff_4;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
        diff_3 = est_3 - threshold;
        diff_4 = est_4 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
        diff_1[31:31] : exact;
        diff_2[31:31] : exact;
        diff_3[31:31] : exact;
        diff_4[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}

control ABOVE_THRESHOLD_CONSTANT_5 (
    in bit<32> est_1,
    in bit<32> est_2,
    in bit<32> est_3,
    in bit<32> est_4,
    in bit<32> est_5,
    inout bit<1> is_above_threshold)
    (bit<32> threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;
    bit<32> diff_3;
    bit<32> diff_4;
    bit<32> diff_5;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
        diff_3 = est_3 - threshold;
        diff_4 = est_4 - threshold;
        diff_5 = est_5 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
        diff_1[31:31] : exact;
        diff_2[31:31] : exact;
        diff_3[31:31] : exact;
        diff_4[31:31] : exact;
        diff_5[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}




control ABOVE_THRESHOLD_1 (
    in bit<32> est_1,
    in bit<32> threshold,
    inout bit<1> is_above_threshold)
{
    bit<32> diff_1;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
    }
    ABOVE_THRESHOLD_COMMON_1()
        diff_1[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}


control ABOVE_THRESHOLD_2 (
    in bit<32> est_1,
    in bit<32> est_2,
    in bit<32> threshold,
    inout bit<1> is_above_threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
            diff_1[31:31] : exact;
            diff_2[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}


control ABOVE_THRESHOLD_3 (
    in bit<32> est_1,
    in bit<32> est_2,
    in bit<32> est_3,
    in bit<32> threshold,
    inout bit<1> is_above_threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;
    bit<32> diff_3;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
        diff_3 = est_3 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
            diff_1[31:31] : exact;
            diff_2[31:31] : exact;
            diff_3[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}


control ABOVE_THRESHOLD_4 (
    in bit<32> est_1,
    in bit<32> est_2,
    in bit<32> est_3,
    in bit<32> est_4,
    in bit<32> threshold,
    inout bit<1> is_above_threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;
    bit<32> diff_3;
    bit<32> diff_4;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
        diff_3 = est_3 - threshold;
        diff_4 = est_4 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
        diff_1[31:31] : exact;
        diff_2[31:31] : exact;
        diff_3[31:31] : exact;
        diff_4[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}


control ABOVE_THRESHOLD_5 (
    in bit<32> est_1,
    in bit<32> est_2,
    in bit<32> est_3,
    in bit<32> est_4,
    in bit<32> est_5,
    in bit<32> threshold,
    inout bit<1> is_above_threshold)
{
    bit<32> diff_1;
    bit<32> diff_2;
    bit<32> diff_3;
    bit<32> diff_4;
    bit<32> diff_5;

    action subtract_table_act() {
        diff_1 = est_1 - threshold;
        diff_2 = est_2 - threshold;
        diff_3 = est_3 - threshold;
        diff_4 = est_4 - threshold;
        diff_5 = est_5 - threshold;
    }

    ABOVE_THRESHOLD_COMMON_1()
        diff_1[31:31] : exact;
        diff_2[31:31] : exact;
        diff_3[31:31] : exact;
        diff_4[31:31] : exact;
        diff_5[31:31] : exact;
    ABOVE_THRESHOLD_COMMON_2()
}

