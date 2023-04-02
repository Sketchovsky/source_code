/************************ CONSTANT ************************/

/************************ RUN FLOWKEY CONSTANT ************************/
#define RUN_HEAVY_FLOWKEY_CONSTANT_1(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_CONSTANT_2(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_CONSTANT_3(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_CONSTANT_4(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_CONSTANT_5(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_est_5, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \



#define RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_1(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_2(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_3(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_4(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_CONSTANT_NOIF_5(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_est_5, ig_md.d_##D##_above_threshold); \



/************************ NOT CONSTANT ************************/

/************************ RUN FLOWKEY ************************/
#define RUN_HEAVY_FLOWKEY_1(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_2(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_3(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_4(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \


#define RUN_HEAVY_FLOWKEY_5(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_est_5, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \
    if (ig_md.d_##D##_above_threshold == 1) { \




#define RUN_HEAVY_FLOWKEY_NOIF_1(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_NOIF_2(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_NOIF_3(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_NOIF_4(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \


#define RUN_HEAVY_FLOWKEY_NOIF_5(D) \
    d_##D##_above_threshold.apply(ig_md.d_##D##_est_1, ig_md.d_##D##_est_2, ig_md.d_##D##_est_3, ig_md.d_##D##_est_4, ig_md.d_##D##_est_5, ig_md.d_##D##_threshold, ig_md.d_##D##_above_threshold); \

