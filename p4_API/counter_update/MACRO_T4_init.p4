#define T4_INIT(D, KEY, WIDTH) \
    T4_KEY_UPDATE_##KEY##_##WIDTH##(32w0x30243f0b) update_##D##_1; \


#define T4_INIT_1(D, KEY, WIDTH) \
    COMPUTE_HASH_##KEY##_32_32(32w0x30244f0b) d_##D##_hash_call; \
    TCAM_LPM_HLLPCSA() d_##D##_tcam_lpm; \
    T4_INIT(D, KEY, WIDTH) \


/************ WITH POLY ************/

#define T4_INIT_WITH_POLY(D, KEY, WIDTH, POLY) \
    T4_KEY_UPDATE_##KEY##_##WIDTH##(POLY) update_##D##_1; \


#define T4_INIT_1_WITH_POLY(D, KEY, WIDTH, SPOLY, POLY1) \
    COMPUTE_HASH_##KEY##_32_32(SPOLY) d_##D##_hash_call; \
    TCAM_LPM_HLLPCSA() d_##D##_tcam_lpm; \
    T4_INIT_WITH_POLY(D, KEY, WIDTH, POLY1) \

