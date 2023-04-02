#define T3_INIT(D, KEY, WIDTH, I) \
    T3_KEY_UPDATE_##KEY##_##WIDTH##(32w0x30243f0b) update_##D##_##I; \


/******************* T3_INIT_HH *******************/

#define T3_INIT_HH_1(D, KEY, WIDTH) \
    COMPUTE_HASH_##KEY##_16_16(32w0x30244f0b) d_##D##_hash_call; \
    T3_INIT(D, KEY, WIDTH, 1) \
    ABOVE_THRESHOLD_CONSTANT_1(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_2(D, KEY, WIDTH) \
    COMPUTE_HASH_##KEY##_16_16(32w0x30244f0b) d_##D##_hash_call; \
    T3_INIT(D, KEY, WIDTH, 1) \
    T3_INIT(D, KEY, WIDTH, 2) \
    ABOVE_THRESHOLD_CONSTANT_2(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_3(D, KEY, WIDTH) \
    COMPUTE_HASH_##KEY##_16_16(32w0x30244f0b) d_##D##_hash_call; \
    T3_INIT(D, KEY, WIDTH, 1) \
    T3_INIT(D, KEY, WIDTH, 2) \
    T3_INIT(D, KEY, WIDTH, 3) \
    ABOVE_THRESHOLD_CONSTANT_3(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_4(D, KEY, WIDTH) \
    COMPUTE_HASH_##KEY##_16_16(32w0x30244f0b) d_##D##_hash_call; \
    T3_INIT(D, KEY, WIDTH, 1) \
    T3_INIT(D, KEY, WIDTH, 2) \
    T3_INIT(D, KEY, WIDTH, 3) \
    T3_INIT(D, KEY, WIDTH, 4) \
    ABOVE_THRESHOLD_CONSTANT_4(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_5(D, KEY, WIDTH) \
    COMPUTE_HASH_##KEY##_16_16(32w0x30244f0b) d_##D##_hash_call; \
    T3_INIT(D, KEY, WIDTH, 1) \
    T3_INIT(D, KEY, WIDTH, 2) \
    T3_INIT(D, KEY, WIDTH, 3) \
    T3_INIT(D, KEY, WIDTH, 4) \
    T3_INIT(D, KEY, WIDTH, 5) \
    ABOVE_THRESHOLD_CONSTANT_5(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


/******************* (HH) - CS *******************/

#define CS_INIT_1(D, KEY, WIDTH) \
    T3_INIT_HH_1(D, KEY, WIDTH) \


#define CS_INIT_2(D, KEY, WIDTH) \
    T3_INIT_HH_2(D, KEY, WIDTH) \


#define CS_INIT_3(D, KEY, WIDTH) \
    T3_INIT_HH_3(D, KEY, WIDTH) \


#define CS_INIT_4(D, KEY, WIDTH) \
    T3_INIT_HH_4(D, KEY, WIDTH) \


#define CS_INIT_5(D, KEY, WIDTH) \
    T3_INIT_HH_5(D, KEY, WIDTH) \



/******************* WITH_POLY *******************/


#define T3_INIT_WITH_POLY(D, KEY, WIDTH, I, POLY) \
    T3_KEY_UPDATE_##KEY##_##WIDTH##(POLY) update_##D##_##I; \


#define T3_INIT_HH_1_WITH_POLY(D, KEY, WIDTH, RES_POLY, POLY1, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_16(RES_POLY) d_##D##_hash_call; \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    ABOVE_THRESHOLD_1() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_2_WITH_POLY(D, KEY, WIDTH, RES_POLY, POLY1, POLY2, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_16(RES_POLY) d_##D##_hash_call; \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    ABOVE_THRESHOLD_2() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_3_WITH_POLY(D, KEY, WIDTH, RES_POLY, POLY1, POLY2, POLY3, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_16(RES_POLY) d_##D##_hash_call; \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    ABOVE_THRESHOLD_3() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_4_WITH_POLY(D, KEY, WIDTH, RES_POLY, POLY1, POLY2, POLY3, POLY4, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_16(RES_POLY) d_##D##_hash_call; \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 4, POLY4) \
    ABOVE_THRESHOLD_4() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T3_INIT_HH_5_WITH_POLY(D, KEY, WIDTH, RES_POLY, POLY1, POLY2, POLY3, POLY4, POLY5, HFPOLY) \
    COMPUTE_HASH_##KEY##_16_16(RES_POLY) d_##D##_hash_call; \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 4, POLY4) \
    T3_INIT_WITH_POLY(D, KEY, WIDTH, 5, POLY5) \
    ABOVE_THRESHOLD_5() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \

