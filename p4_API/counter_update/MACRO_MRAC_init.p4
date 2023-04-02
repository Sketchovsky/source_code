#define MRAC_INIT_1(D, KEY, WIDTH, WIDTH_BITLEN, LEVEL_BITLEN) \
    COMPUTE_HASH_##KEY##_16_##LEVEL_BITLEN##(32w0x30244f0b) d_##D##_sampling_hash_call; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(32w0x30244f0b) d_##D##_index_hash_call_1; \
    LPM_OPT_MRAC() d_##D##_tcam_lpm; \
    T2_INDEX_UPDATE_##WIDTH##() update_##D##_1; \


#define MRAC_INIT_1_WITH_POLY(D, KEY, WIDTH, WIDTH_BITLEN, LEVEL_BITLEN, POLY1, POLY2) \
    COMPUTE_HASH_##KEY##_16_##LEVEL_BITLEN##(POLY1) d_##D##_sampling_hash_call; \
    COMPUTE_HASH_##KEY##_16_##WIDTH_BITLEN##(POLY2) d_##D##_index_hash_call_1; \
    LPM_OPT_MRAC() d_##D##_tcam_lpm; \
    T2_INDEX_UPDATE_##WIDTH##() update_##D##_1; \

