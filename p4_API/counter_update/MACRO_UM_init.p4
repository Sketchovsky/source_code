#define UM_INIT(D, WIDTH, I) \
    T3_INDEX_UPDATE_##WIDTH##() update_##D##_##I; \


#define UM_INIT_SETUP(D, KEY) \
    COMPUTE_HASH_##KEY##_16_16(32w0x30244f0b) d_##D##_sampling_hash_call; \
    COMPUTE_HASH_##KEY##_16_16(32w0x30244f0b) d_##D##_res_hash_call; \
    LPM_OPT_UM() d_##D##_tcam_lpm; \
    LPM_OPT_UM_2() d_##D##_tcam_lpm_2; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define UM_INIT_1(D, KEY, WIDTH_BITLEN, WIDTH) \
    UM_INIT_SETUP(D, KEY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_1; \
    UM_INIT(D, WIDTH, 1) \
    ABOVE_THRESHOLD_1() d_##D##_above_threshold; \


#define UM_INIT_2(D, KEY, WIDTH_BITLEN, WIDTH) \
    UM_INIT_SETUP(D, KEY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_2; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    ABOVE_THRESHOLD_2() d_##D##_above_threshold; \


#define UM_INIT_3(D, KEY, WIDTH_BITLEN, WIDTH) \
    UM_INIT_SETUP(D, KEY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_2; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_3; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    UM_INIT(D, WIDTH, 3) \
    ABOVE_THRESHOLD_3() d_##D##_above_threshold; \


#define UM_INIT_4(D, KEY, WIDTH_BITLEN, WIDTH) \
    UM_INIT_SETUP(D, KEY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_2; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_3; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_4; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    UM_INIT(D, WIDTH, 3) \
    UM_INIT(D, WIDTH, 4) \
    ABOVE_THRESHOLD_4() d_##D##_above_threshold; \


#define UM_INIT_5(D, KEY, WIDTH_BITLEN, WIDTH) \
    UM_INIT_SETUP(D, KEY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_2; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_3; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_4; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_5; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    UM_INIT(D, WIDTH, 3) \
    UM_INIT(D, WIDTH, 4) \
    UM_INIT(D, WIDTH, 5) \
    ABOVE_THRESHOLD_5() d_##D##_above_threshold; \


/************ WITH POLY ************/

#define UM_INIT_SETUP_WITH_POLY(D, KEY, SPOLY, RPOLY, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_16(SPOLY) d_##D##_sampling_hash_call; \
    COMPUTE_HASH_##KEY##_16_16(RPOLY) d_##D##_res_hash_call; \
    LPM_OPT_UM() d_##D##_tcam_lpm; \
    LPM_OPT_UM_2() d_##D##_tcam_lpm_2; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \




#define UM_INIT_1_WITH_POLY(D, KEY, WIDTH_BITLEN, WIDTH, SPOLY, RPOLY, POLY1, HFPOLY) \
    UM_INIT_SETUP_WITH_POLY(D, KEY, SPOLY, RPOLY, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY1) d_##D##_index_hash_call_1; \
    UM_INIT(D, WIDTH, 1) \
    ABOVE_THRESHOLD_1() d_##D##_above_threshold; \


#define UM_INIT_2_WITH_POLY(D, KEY, WIDTH_BITLEN, WIDTH, SPOLY, RPOLY, POLY1, POLY2, HFPOLY) \
    UM_INIT_SETUP_WITH_POLY(D, KEY, SPOLY, RPOLY, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY1) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY2) d_##D##_index_hash_call_2; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    ABOVE_THRESHOLD_2() d_##D##_above_threshold; \


#define UM_INIT_3_WITH_POLY(D, KEY, WIDTH_BITLEN, WIDTH, SPOLY, RPOLY, POLY1, POLY2, POLY3, HFPOLY) \
    UM_INIT_SETUP_WITH_POLY(D, KEY, SPOLY, RPOLY, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY1) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY2) d_##D##_index_hash_call_2; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY3) d_##D##_index_hash_call_3; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    UM_INIT(D, WIDTH, 3) \
    ABOVE_THRESHOLD_3() d_##D##_above_threshold; \


#define UM_INIT_4_WITH_POLY(D, KEY, WIDTH_BITLEN, WIDTH, SPOLY, RPOLY, POLY1, POLY2, POLY3, POLY4, HFPOLY) \
    UM_INIT_SETUP_WITH_POLY(D, KEY, SPOLY, RPOLY, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY1) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY2) d_##D##_index_hash_call_2; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY3) d_##D##_index_hash_call_3; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY4) d_##D##_index_hash_call_4; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    UM_INIT(D, WIDTH, 3) \
    UM_INIT(D, WIDTH, 4) \
    ABOVE_THRESHOLD_4() d_##D##_above_threshold; \


#define UM_INIT_5_WITH_POLY(D, KEY, WIDTH_BITLEN, WIDTH, SPOLY, RPOLY, POLY1, POLY2, POLY3, POLY4, POLY5, HFPOLY) \
    UM_INIT_SETUP_WITH_POLY(D, KEY, SPOLY, RPOLY, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY1) d_##D##_index_hash_call_1; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY2) d_##D##_index_hash_call_2; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY3) d_##D##_index_hash_call_3; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY4) d_##D##_index_hash_call_4; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY5) d_##D##_index_hash_call_5; \
    UM_INIT(D, WIDTH, 1) \
    UM_INIT(D, WIDTH, 2) \
    UM_INIT(D, WIDTH, 3) \
    UM_INIT(D, WIDTH, 4) \
    UM_INIT(D, WIDTH, 5) \
    ABOVE_THRESHOLD_5() d_##D##_above_threshold; \


