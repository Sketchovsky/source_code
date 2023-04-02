/************************ SETUP ************************/


#define UM_RUN_KEY(D, BASE, INDEX, RES, PSIZE, I) \
    update_##D##_##I##.apply(BASE, INDEX, RES, PSIZE, ig_md.d_##D##_est_##I##); \


#define UM_RUN_COMMON_SETUP(D) \
    d_##D##_tcam_lpm.apply(ig_md.d_##D##_sampling_hash_16, ig_md.d_##D##_base_16, ig_md.d_##D##_threshold); \


#define UM_RUN_SETUP_1(D, KEY1) \
    d_##D##_sampling_hash_call.apply(KEY1, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_res_hash_call.apply(KEY1, ig_md.d_##D##_res_hash); \


#define UM_RUN_SETUP_2(D, KEY1, KEY2) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_res_hash_call.apply(KEY1, KEY2, ig_md.d_##D##_res_hash); \


#define UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_res_hash_call.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_res_hash); \


#define UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_res_hash_call.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_res_hash); \


#define UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    d_##D##_sampling_hash_call.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_sampling_hash_16); \
    d_##D##_res_hash_call.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_res_hash); \



#define UM_RUN_END_1(D, RES, PSIZE) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index1_16, RES[0:0], PSIZE, 1) \


#define UM_RUN_END_2(D, RES, PSIZE) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index1_16, RES[0:0], PSIZE, 1) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index2_16, RES[1:1], PSIZE, 2) \


#define UM_RUN_END_3(D, RES, PSIZE) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index1_16, RES[0:0], PSIZE, 1) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index2_16, RES[1:1], PSIZE, 2) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index3_16, RES[2:2], PSIZE, 3) \


#define UM_RUN_END_4(D, RES, PSIZE) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index1_16, RES[0:0], PSIZE, 1) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index2_16, RES[1:1], PSIZE, 2) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index3_16, RES[2:2], PSIZE, 3) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index4_16, RES[3:3], PSIZE, 4) \


#define UM_RUN_END_5(D, RES, PSIZE) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index1_16, RES[0:0], PSIZE, 1) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index2_16, RES[1:1], PSIZE, 2) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index3_16, RES[2:2], PSIZE, 3) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index4_16, RES[3:3], PSIZE, 4) \
    UM_RUN_KEY(D, ig_md.d_##D##_base_16, ig_md.d_##D##_index5_16, RES[4:4], PSIZE, 5) \

/************************************************ UM for HH ************************************************/


/************************ KEY_1 ************************/


#define UM_RUN_1_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_1(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1); } \


#define UM_RUN_2_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_2(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1); } \


#define UM_RUN_3_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_3(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1); } \


#define UM_RUN_4_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_4(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1); } \


#define UM_RUN_5_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_5(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1); } \


/************************ KEY_2 ************************/


#define UM_RUN_1_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_1(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2); } \


#define UM_RUN_2_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_2(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2); } \


#define UM_RUN_3_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_3(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2); } \


#define UM_RUN_4_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_4(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2); } \


#define UM_RUN_5_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_5(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2); } \




/************************ KEY_3 ************************/

#define UM_RUN_1_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_1(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3); } \


#define UM_RUN_2_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_2(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3); } \


#define UM_RUN_3_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_3(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3); } \


#define UM_RUN_4_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_4(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3); } \


#define UM_RUN_5_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_5(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3); } \




/************************ KEY_4 ************************/

#define UM_RUN_1_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_1(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4); } \


#define UM_RUN_2_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_2(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4); } \


#define UM_RUN_3_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_3(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4); } \


#define UM_RUN_4_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_4(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4); } \


#define UM_RUN_5_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_5(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4); } \




/************************ KEY_5 ************************/

#define UM_RUN_1_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_1(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4, KEY5); } \


#define UM_RUN_2_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_2(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4, KEY5); } \


#define UM_RUN_3_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_3(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4, KEY5); } \


#define UM_RUN_4_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_4(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4, KEY5); } \


#define UM_RUN_5_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_5(D) \
    heavy_flowkey_storage_##D##.apply(hdr, ig_dprsr_md, ig_tm_md, KEY1, KEY2, KEY3, KEY4, KEY5); } \





/************************************************ UM for HALF ************************************************/


/************************ KEY_1 ************************/


#define UM_RUN_AFTER_1_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_1(D) \


#define UM_RUN_AFTER_2_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_2(D) \


#define UM_RUN_AFTER_3_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_3(D) \


#define UM_RUN_AFTER_4_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_4(D) \


#define UM_RUN_AFTER_5_KEY_1(D, KEY1, PSIZE) \
    UM_RUN_SETUP_1(D, KEY1) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_5(D) \


/************************ KEY_2 ************************/


#define UM_RUN_AFTER_1_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_1(D) \


#define UM_RUN_AFTER_2_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_2(D) \


#define UM_RUN_AFTER_3_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_3(D) \


#define UM_RUN_AFTER_4_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_4(D) \


#define UM_RUN_AFTER_5_KEY_2(D, KEY1, KEY2, PSIZE) \
    UM_RUN_SETUP_2(D, KEY1, KEY2) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_5(D) \




/************************ KEY_3 ************************/

#define UM_RUN_AFTER_1_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_1(D) \


#define UM_RUN_AFTER_2_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_2(D) \


#define UM_RUN_AFTER_3_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_3(D) \


#define UM_RUN_AFTER_4_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_4(D) \


#define UM_RUN_AFTER_5_KEY_3(D, KEY1, KEY2, KEY3, PSIZE) \
    UM_RUN_SETUP_3(D, KEY1, KEY2, KEY3) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_5(D) \




/************************ KEY_4 ************************/

#define UM_RUN_AFTER_1_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_1(D) \


#define UM_RUN_AFTER_2_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_2(D) \


#define UM_RUN_AFTER_3_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_3(D) \


#define UM_RUN_AFTER_4_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_4(D) \


#define UM_RUN_AFTER_5_KEY_4(D, KEY1, KEY2, KEY3, KEY4, PSIZE) \
    UM_RUN_SETUP_4(D, KEY1, KEY2, KEY3, KEY4) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_5(D) \




/************************ KEY_5 ************************/

#define UM_RUN_AFTER_1_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    UM_RUN_END_1(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_1(D) \


#define UM_RUN_AFTER_2_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    UM_RUN_END_2(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_2(D) \


#define UM_RUN_AFTER_3_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index3_16); \
    UM_RUN_END_3(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_3(D) \


#define UM_RUN_AFTER_4_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index4_16); \
    UM_RUN_END_4(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_4(D) \


#define UM_RUN_AFTER_5_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, PSIZE) \
    UM_RUN_SETUP_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    UM_RUN_COMMON_SETUP(D) \
    d_##D##_index_hash_call_1.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index1_16); \
    d_##D##_index_hash_call_2.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index2_16); \
    d_##D##_index_hash_call_3.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index3_16); \
    d_##D##_index_hash_call_4.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index4_16); \
    d_##D##_index_hash_call_5.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_index5_16); \
    UM_RUN_END_5(D, ig_md.d_##D##_res_hash, PSIZE) \
    RUN_HEAVY_FLOWKEY_NOIF_5(D) \


