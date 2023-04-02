#define T5_INIT(D, KEY, WIDTH) \
    T5_KEY_UPDATE_##KEY##_##WIDTH##(32w0x30243f0b) update_##D##_1; \


#define T5_INIT_1(D, KEY, WIDTH) \
    COMPUTE_HASH_##KEY##_32_32(32w0x30244f0b) d_##D##_hash_call; \
    TCAM_LPM_HLLPCSA() d_##D##_tcam_lpm; \
    GET_BITMASK() d_##D##_get_bitmask; \
    T5_INIT(D, KEY, WIDTH) \


#define PCSA_INIT_1(D, KEY, WIDTH) \
    T5_INIT_1(D, KEY, WIDTH) \



/************ WITH POLY ************/


#define T5_INIT_WITH_POLY(D, KEY, WIDTH, POLY) \
    T5_KEY_UPDATE_##KEY##_##WIDTH##(POLY) update_##D##_1; \


#define T5_INIT_1_WITH_POLY(D, KEY, WIDTH, SPOLY, POLY1) \
    COMPUTE_HASH_##KEY##_32_32(SPOLY) d_##D##_hash_call; \
    TCAM_LPM_HLLPCSA() d_##D##_tcam_lpm; \
    GET_BITMASK() d_##D##_get_bitmask; \
    T5_INIT_WITH_POLY(D, KEY, WIDTH, POLY1) \

