#define HEADER_STORAGE_CONFIG(HDR_BITLEN, HDR, HT_SIZE, HT_BITLEN) \
    Register<bit<HDR_BITLEN>, bit<HT_BITLEN>>(HT_SIZE) ##HDR##_hash_table; \
    RegisterAction<bit<HDR_BITLEN>, bit<HT_BITLEN>, bit<HDR_BITLEN>>(##HDR##_hash_table) ##HDR##_action = { \
        void apply(inout bit<HDR_BITLEN> register_data, out bit<HDR_BITLEN> result) { \
            if (register_data == 0) { \
                register_data = ##HDR##; \
                result = 0; \
            } \
            else { \
                result = register_data; \
            } \
        } \
    }; \


#define HEADER_STORAGE_STORE_CONFIG_SETUP(HDR_BITLEN, HDR, HT_BITLEN) \
    Hash<bit<HT_BITLEN>>(HashAlgorithm_t.CUSTOM, poly1) hash_##HDR##; \
    bit<##HDR_BITLEN##> entry_##HDR##; \
    action HDR##_ht_table_act() \
    { \


#define HEADER_STORAGE_STORE_CONFIG_1(HDR_BITLEN, HDR, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_SETUP(HDR_BITLEN, HDR, HT_BITLEN) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR)  \


#define HEADER_STORAGE_STORE_CONFIG_2(HDR_BITLEN, HDR, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_SETUP(HDR_BITLEN, HDR, HT_BITLEN) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \


#define HEADER_STORAGE_STORE_CONFIG_3(HDR_BITLEN, HDR, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_SETUP(HDR_BITLEN, HDR, HT_BITLEN) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2, key3})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \


#define HEADER_STORAGE_STORE_CONFIG_4(HDR_BITLEN, HDR, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_SETUP(HDR_BITLEN, HDR, HT_BITLEN) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2, key3, key4})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \


#define HEADER_STORAGE_STORE_CONFIG_5(HDR_BITLEN, HDR, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_SETUP(HDR_BITLEN, HDR, HT_BITLEN) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2, key3, key4, key5})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \



#define EXACT_TABLE_CONFIG_END(EM_SIZE) \
        } \
        actions = { \
            tbl_exact_match_miss; \
            tbl_exact_match_hit; \
        } \
        const default_action = tbl_exact_match_miss; \
        size = EM_SIZE; \
    } \


#define EXACT_TABLE_CONFIG_1(EM_SIZE) \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    EXACT_TABLE_CONFIG_END(EM_SIZE) \


#define EXACT_TABLE_CONFIG_2(EM_SIZE) \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    EXACT_TABLE_CONFIG_END(EM_SIZE) \


#define EXACT_TABLE_CONFIG_3(EM_SIZE) \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    key3 : exact; \
    EXACT_TABLE_CONFIG_END(EM_SIZE) \


#define EXACT_TABLE_CONFIG_4(EM_SIZE) \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    key3 : exact; \
    key4 : exact; \
    EXACT_TABLE_CONFIG_END(EM_SIZE) \


#define EXACT_TABLE_CONFIG_5(EM_SIZE) \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    key3 : exact; \
    key4 : exact; \
    key5 : exact; \
    EXACT_TABLE_CONFIG_END(EM_SIZE) \




#define INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_221(HT_SIZE, HT_BITLEN, EM_SIZE) \
control HEAVY_FLOWKEY_STORAGE_CONFIG_221 ( \
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5) \
    (bit<32> polynomial) \
{ \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    HEADER_STORAGE_CONFIG(32, key1, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(32, key2, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(16, key3, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(16, key4, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(8, key5, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_5(32, key1, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_5(32, key2, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_5(16, key3, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_5(16, key4, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_5(8, key5, HT_BITLEN) \
    EXACT_TABLE_CONFIG_5(EM_SIZE) \
    apply { \
        FLOWKEY_STORAGE_CORE_5() \
    } \
} \


#define INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_220(HT_SIZE, HT_BITLEN, EM_SIZE) \
control HEAVY_FLOWKEY_STORAGE_CONFIG_220 ( \
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4) \
    (bit<32> polynomial) \
{ \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    HEADER_STORAGE_CONFIG(32, key1, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(32, key2, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(16, key3, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(16, key4, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_4(32, key1, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_4(32, key2, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_4(16, key3, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_4(16, key4, HT_BITLEN) \
    EXACT_TABLE_CONFIG_4(EM_SIZE) \
    apply { \
        FLOWKEY_STORAGE_CORE_4() \
    } \
} \


#define INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_210(HT_SIZE, HT_BITLEN, EM_SIZE) \
control HEAVY_FLOWKEY_STORAGE_CONFIG_210 ( \
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3) \
    (bit<32> polynomial) \
{ \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    HEADER_STORAGE_CONFIG(32, key1, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(32, key2, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(16, key3, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_3(32, key1, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_3(32, key2, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_3(16, key3, HT_BITLEN) \
    EXACT_TABLE_CONFIG_3(EM_SIZE) \
    apply { \
        FLOWKEY_STORAGE_CORE_3() \
    } \
} \


#define INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_200(HT_SIZE, HT_BITLEN, EM_SIZE) \
control HEAVY_FLOWKEY_STORAGE_CONFIG_200 ( \
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, \
    in bit<32> key1, \
    in bit<32> key2) \
    (bit<32> polynomial) \
{ \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    HEADER_STORAGE_CONFIG(32, key1, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(32, key2, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_2(32, key1, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_2(32, key2, HT_BITLEN) \
    EXACT_TABLE_CONFIG_2(EM_SIZE) \
    apply { \
        FLOWKEY_STORAGE_CORE_2() \
    } \
} \


#define INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_110(HT_SIZE, HT_BITLEN, EM_SIZE) \
control HEAVY_FLOWKEY_STORAGE_CONFIG_110 ( \
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, \
    in bit<32> key1, \
    in bit<16> key2) \
    (bit<32> polynomial) \
{ \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    HEADER_STORAGE_CONFIG(32, key1, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_CONFIG(16, key2, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_2(32, key1, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_2(16, key2, HT_BITLEN) \
    EXACT_TABLE_CONFIG_2(EM_SIZE) \
    apply { \
        FLOWKEY_STORAGE_CORE_2() \
    } \
} \


#define INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_100(HT_SIZE, HT_BITLEN, EM_SIZE) \
control HEAVY_FLOWKEY_STORAGE_CONFIG_100 ( \
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, \
    in bit<32> key1) \
    (bit<32> polynomial) \
{ \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    HEADER_STORAGE_CONFIG(32, key1, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_1(32, key1, HT_BITLEN) \
    EXACT_TABLE_CONFIG_1(EM_SIZE) \
    apply { \
        FLOWKEY_STORAGE_CORE_1() \
    } \
} \


#define INIT_HEAVY_FLOWKEY_STORAGE_CONFIG_010(HT_SIZE, HT_BITLEN, EM_SIZE) \
control HEAVY_FLOWKEY_STORAGE_CONFIG_010 ( \
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md, \
    in bit<16> key1) \
    (bit<32> polynomial) \
{ \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    HEADER_STORAGE_CONFIG(16, key1, HT_SIZE, HT_BITLEN) \
    HEADER_STORAGE_STORE_CONFIG_1(16, key1, HT_BITLEN) \
    EXACT_TABLE_CONFIG_1(EM_SIZE) \
    apply { \
        FLOWKEY_STORAGE_CORE_1() \
    } \
} \

