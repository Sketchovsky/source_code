/************************ RUN UPDATE ************************/


#define T1_RUN_KEY_1(D, KEY1, I) \
    update_##D##_##I##.apply(KEY1, ig_md.d_##D##_est1_##I##); \


#define T1_RUN_KEY_2(D, KEY1, KEY2, I) \
    update_##D##_##I##.apply(KEY1, KEY2, ig_md.d_##D##_est1_##I##); \


#define T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, I) \
    update_##D##_##I##.apply(KEY1, KEY2, KEY3, ig_md.d_##D##_est1_##I##); \


#define T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, I) \
    update_##D##_##I##.apply(KEY1, KEY2, KEY3, KEY4, ig_md.d_##D##_est1_##I##); \


#define T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, I) \
    update_##D##_##I##.apply(KEY1, KEY2, KEY3, KEY4, KEY5, ig_md.d_##D##_est1_##I##); \


#define T1_RUN_1_KEY_1(D, KEY1) \
    T1_RUN_KEY_1(D, KEY1, 1) \


#define T1_RUN_2_KEY_1(D, KEY1) \
    T1_RUN_KEY_1(D, KEY1, 1) \
    T1_RUN_KEY_1(D, KEY1, 2) \


#define T1_RUN_3_KEY_1(D, KEY1) \
    T1_RUN_KEY_1(D, KEY1, 1) \
    T1_RUN_KEY_1(D, KEY1, 2) \
    T1_RUN_KEY_1(D, KEY1, 3) \


#define T1_RUN_4_KEY_1(D, KEY1) \
    T1_RUN_KEY_1(D, KEY1, 1) \
    T1_RUN_KEY_1(D, KEY1, 2) \
    T1_RUN_KEY_1(D, KEY1, 3) \
    T1_RUN_KEY_1(D, KEY1, 4) \


#define T1_RUN_5_KEY_1(D, KEY1) \
    T1_RUN_KEY_1(D, KEY1, 1) \
    T1_RUN_KEY_1(D, KEY1, 2) \
    T1_RUN_KEY_1(D, KEY1, 3) \
    T1_RUN_KEY_1(D, KEY1, 4) \
    T1_RUN_KEY_1(D, KEY1, 5) \


#define T1_RUN_1_KEY_2(D, KEY1, KEY2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 1) \


#define T1_RUN_2_KEY_2(D, KEY1, KEY2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 1) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 2) \


#define T1_RUN_3_KEY_2(D, KEY1, KEY2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 1) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 3) \


#define T1_RUN_4_KEY_2(D, KEY1, KEY2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 1) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 3) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 4) \


#define T1_RUN_5_KEY_2(D, KEY1, KEY2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 1) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 2) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 3) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 4) \
    T1_RUN_KEY_2(D, KEY1, KEY2, 5) \



#define T1_RUN_1_KEY_3(D, KEY1, KEY2, KEY3) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 1) \


#define T1_RUN_2_KEY_3(D, KEY1, KEY2, KEY3) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 1) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 2) \


#define T1_RUN_3_KEY_3(D, KEY1, KEY2, KEY3) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 1) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 2) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 3) \


#define T1_RUN_4_KEY_3(D, KEY1, KEY2, KEY3) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 1) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 2) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 3) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 4) \


#define T1_RUN_5_KEY_3(D, KEY1, KEY2, KEY3) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 1) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 2) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 3) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 4) \
    T1_RUN_KEY_3(D, KEY1, KEY2, KEY3, 5) \



#define T1_RUN_1_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 1) \


#define T1_RUN_2_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 1) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 2) \


#define T1_RUN_3_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 1) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 2) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 3) \


#define T1_RUN_4_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 1) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 2) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 3) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 4) \


#define T1_RUN_5_KEY_4(D, KEY1, KEY2, KEY3, KEY4) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 1) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 2) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 3) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 4) \
    T1_RUN_KEY_4(D, KEY1, KEY2, KEY3, KEY4, 5) \


#define T1_RUN_1_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 1) \


#define T1_RUN_2_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 1) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 2) \


#define T1_RUN_3_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 1) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 2) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 3) \


#define T1_RUN_4_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 1) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 2) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 3) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 4) \


#define T1_RUN_5_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 1) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 2) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 3) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 4) \
    T1_RUN_KEY_5(D, KEY1, KEY2, KEY3, KEY4, KEY5, 5) \

