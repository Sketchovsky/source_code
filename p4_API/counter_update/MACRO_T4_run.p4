/************************ RUN UPDATE ************************/


#define T4_RUN_KEY_1(D, KEY1) \
    update_##D##_1.apply(KEY1, ig_md.d_##D##_level); \


#define T4_RUN_KEY_2(D, KEY1, KEY2) \
    update_##D##_1.apply(KEY1, KEY2, ig_md.d_##D##_level); \


#define T4_RUN_KEY_3(D, KEY1, KEY2, KEY3) \
    update_##D##_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_level); \


#define T4_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    update_##D##_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_level); \


#define T4_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    update_##D##_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_level); \


#define T4_RUN_1_KEY_1(D, KEY1) \
    d_##D##_hash_call.apply(KEY1, ig_md.d_##D##_sampling_hash_32); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_32, ig_md.d_##D##_level); \
    T4_RUN_KEY_1(D, KEY1) \


#define T4_RUN_1_KEY_2(D, KEY1, KEY2) \
    d_##D##_hash_call.apply(KEY1, KEY2, ig_md.d_##D##_sampling_hash_32); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_32, ig_md.d_##D##_level); \
    T4_RUN_KEY_2(D, KEY1, KEY2) \


#define T4_RUN_1_KEY_3(D, KEY1, KEY2, KEY3) \
    d_##D##_hash_call.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_sampling_hash_32); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_32, ig_md.d_##D##_level); \
    T4_RUN_KEY_3(D, KEY1, KEY2, KEY3) \


#define T4_RUN_1_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    d_##D##_hash_call.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_sampling_hash_32); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_32, ig_md.d_##D##_level); \
    T4_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \


#define T4_RUN_1_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    d_##D##_hash_call.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_sampling_hash_32); \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_32, ig_md.d_##D##_level); \
    T4_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \

