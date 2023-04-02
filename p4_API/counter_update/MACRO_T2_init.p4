#define T2_INIT(D, KEY, WIDTH, I) \
    T2_KEY_UPDATE_##KEY##_##WIDTH##(32w0x30243f0b) update_##D##_##I; \

#define T2_INIT_WITH_POLY(D, KEY, WIDTH, I, POLY) \
    T2_KEY_UPDATE_##KEY##_##WIDTH##(POLY) update_##D##_##I; \

/******************* T2_INIT_HH *******************/

#define T2_INIT_HH_1(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    ABOVE_THRESHOLD_CONSTANT_1(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_2(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \
    ABOVE_THRESHOLD_CONSTANT_2(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_3(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \
    T2_INIT(D, KEY, WIDTH, 3) \
    ABOVE_THRESHOLD_CONSTANT_3(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_4(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \
    T2_INIT(D, KEY, WIDTH, 3) \
    T2_INIT(D, KEY, WIDTH, 4) \
    ABOVE_THRESHOLD_CONSTANT_4(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_5(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \
    T2_INIT(D, KEY, WIDTH, 3) \
    T2_INIT(D, KEY, WIDTH, 4) \
    T2_INIT(D, KEY, WIDTH, 5) \
    ABOVE_THRESHOLD_CONSTANT_5(100) d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(32w0x30243f0b) heavy_flowkey_storage_##D##; \



/******************* T2_INIT_HH_THRESHOLD *******************/

#define T2_INIT_HH_1_THRESHOLD(D, KEY, WIDTH, POLY1, HFPOLY) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    ABOVE_THRESHOLD_1() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_2_THRESHOLD(D, KEY, WIDTH, POLY1, POLY2, HFPOLY) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    ABOVE_THRESHOLD_2() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_3_THRESHOLD(D, KEY, WIDTH, POLY1, POLY2, POLY3, HFPOLY) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    ABOVE_THRESHOLD_3() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_4_THRESHOLD(D, KEY, WIDTH, POLY1, POLY2, POLY3, POLY4, HFPOLY) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 4, POLY4) \
    ABOVE_THRESHOLD_4() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \


#define T2_INIT_HH_5_THRESHOLD(D, KEY, WIDTH, POLY1, POLY2, POLY3, POLY4, POLY5, HFPOLY) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 4, POLY4) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 5, POLY5) \
    ABOVE_THRESHOLD_5() d_##D##_above_threshold; \
    HEAVY_FLOWKEY_STORAGE_##KEY##(HFPOLY) heavy_flowkey_storage_##D##; \



/******************* T2_INIT without HH *******************/

#define T2_INIT_1(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \


#define T2_INIT_2(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \


#define T2_INIT_3(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \
    T2_INIT(D, KEY, WIDTH, 3) \


#define T2_INIT_4(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \
    T2_INIT(D, KEY, WIDTH, 3) \
    T2_INIT(D, KEY, WIDTH, 4) \


#define T2_INIT_5(D, KEY, WIDTH) \
    T2_INIT(D, KEY, WIDTH, 1) \
    T2_INIT(D, KEY, WIDTH, 2) \
    T2_INIT(D, KEY, WIDTH, 3) \
    T2_INIT(D, KEY, WIDTH, 4) \
    T2_INIT(D, KEY, WIDTH, 5) \


/******************* WITH POLY *******************/


#define T2_INIT_1_WITH_POLY(D, KEY, WIDTH, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \


#define T2_INIT_2_WITH_POLY(D, KEY, WIDTH, POLY1, POLY2) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \


#define T2_INIT_3_WITH_POLY(D, KEY, WIDTH, POLY1, POLY2, POLY3) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \


#define T2_INIT_4_WITH_POLY(D, KEY, WIDTH, POLY1, POLY2, POLY3, POLY4) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 4, POLY4) \


#define T2_INIT_5_WITH_POLY(D, KEY, WIDTH, POLY1, POLY2, POLY3, POLY4, POLY5) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 1, POLY1) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 2, POLY2) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 3, POLY3) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 4, POLY4) \
    T2_INIT_WITH_POLY(D, KEY, WIDTH, 5, POLY5) \

