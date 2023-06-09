#define METADATA_DIM(D) \
    bit<16> d_##D##_sampling_hash_16; \
    bit<32> d_##D##_sampling_hash_32; \
    bit<16> d_##D##_base_16; \
    bit<16> d_##D##_base_16_1024; \
    bit<16> d_##D##_base_16_2048; \
    bit<32> d_##D##_base_32; \
    bit<8> d_##D##_level; \
    bit<32> d_##D##_threshold; \
    bit<32> d_##D##_bitmask; \
    bit<16> d_##D##_res_hash; \
    bit<16> d_##D##_index1_16; \
    bit<16> d_##D##_index2_16; \
    bit<16> d_##D##_index3_16; \
    bit<16> d_##D##_index4_16; \
    bit<16> d_##D##_index5_16; \
    bit<32> d_##D##_est_1; \
    bit<32> d_##D##_est_2; \
    bit<32> d_##D##_est_3; \
    bit<32> d_##D##_est_4; \
    bit<32> d_##D##_est_5; \
    bit<1> d_##D##_est1_1; \
    bit<1> d_##D##_est1_2; \
    bit<1> d_##D##_est1_3; \
    bit<1> d_##D##_est1_4; \
    bit<1> d_##D##_est1_5; \
    bit<1>  d_##D##_above_threshold; \

