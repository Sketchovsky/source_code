/************************ SETUP ************************/

#define MRAC_RUN_END(D) \
    update_##D##_1.apply(ig_md.d_##D##_base_16, ig_md.d_##D##_index1_16); \


#define MRAC_RUN_1_KEY_1(D, KEY1) \
    d_##D##_sampling_hash_call.apply(KEY1, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_16, ig_md.d_##D##_base_16); \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    MRAC_RUN_END(D) \


#define MRAC_RUN_1_KEY_2(D, KEY1, KEY2) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_16, ig_md.d_##D##_base_16); \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    MRAC_RUN_END(D) \


#define MRAC_RUN_1_KEY_3(D, KEY1, KEY2, KEY3) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_16, ig_md.d_##D##_base_16); \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    MRAC_RUN_END(D) \


#define MRAC_RUN_1_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_16, ig_md.d_##D##_base_16); \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    MRAC_RUN_END(D) \


#define MRAC_RUN_1_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_16, ig_md.d_##D##_base_16); \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    MRAC_RUN_END(D) \


