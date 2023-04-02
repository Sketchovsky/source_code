#define ETHERTYPE_TO_CPU 0xBF01
const PortId_t CPU_PORT = 192; // tofino with pipeline 2
// const PortId_t CPU_PORT = 64; // simulator

// #define HT_SIZE 2
// #define HT_BITLEN 1

// #define HT_SIZE 4
// #define HT_BITLEN 2

// #define HT_SIZE 2048
// #define HT_BITLEN 11

// #define HT_SIZE 4096
// #define HT_BITLEN 12

#define HT_SIZE 8192
#define HT_BITLEN 13

// #define HT_SIZE 16384
// #define HT_BITLEN 14


#define EXACT_MATCH_SIZE 8192

// #define EXACT_MATCH_SIZE 8192

#define HEADER_STORAGE(HDR_BITLEN, HDR) \
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


#define HEADER_STORAGE_STORE_SETUP(HDR_BITLEN, HDR) \
    Hash<bit<HT_BITLEN>>(HashAlgorithm_t.CUSTOM, poly1) hash_##HDR##; \
    bit<##HDR_BITLEN##> entry_##HDR##; \
    action HDR##_ht_table_act() \
    { \


#define HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \
    } \
    table HDR##_ht_table { \
        actions = { \
            HDR##_ht_table_act; \
        } \
        const default_action = HDR##_ht_table_act; \
        size = 16; \
    } \


#define HEADER_STORAGE_STORE_1(HDR_BITLEN, HDR) \
    HEADER_STORAGE_STORE_SETUP(HDR_BITLEN, HDR) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR)  \


#define HEADER_STORAGE_STORE_2(HDR_BITLEN, HDR) \
    HEADER_STORAGE_STORE_SETUP(HDR_BITLEN, HDR) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \


#define HEADER_STORAGE_STORE_3(HDR_BITLEN, HDR) \
    HEADER_STORAGE_STORE_SETUP(HDR_BITLEN, HDR) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2, key3})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \


#define HEADER_STORAGE_STORE_4(HDR_BITLEN, HDR) \
    HEADER_STORAGE_STORE_SETUP(HDR_BITLEN, HDR) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2, key3, key4})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \


#define HEADER_STORAGE_STORE_5(HDR_BITLEN, HDR) \
    HEADER_STORAGE_STORE_SETUP(HDR_BITLEN, HDR) \
    entry_##HDR## = ##HDR##_action.execute(hash_##HDR##.get({key1, key2, key3, key4, key5})); \
    HEADER_STORAGE_STORE_END(HDR_BITLEN, HDR) \



#define FLOWKEY_STORAGE_CORE_1() \
    key1_ht_table.apply(); \
    if (entry_key1 != 0) { \
        if(entry_key1 != key1) { \
            tbl_exact_match.apply(); \
        } \
    } \


#define FLOWKEY_STORAGE_CORE_2() \
    key1_ht_table.apply(); \
    key2_ht_table.apply(); \
    if (entry_key1 != 0 && entry_key2 != 0) { \
        if(entry_key1 != key1) { \
            tbl_exact_match.apply(); \
        } \
        else { \
            if(entry_key2 != key2) { \
                tbl_exact_match.apply(); \
            } \
        } \
    } \


#define FLOWKEY_STORAGE_CORE_3() \
    key1_ht_table.apply(); \
    key2_ht_table.apply(); \
    key3_ht_table.apply(); \
    if (entry_key1 != 0 && entry_key2 != 0 && entry_key3 != 0) { \
        if(entry_key1 != key1) { \
            tbl_exact_match.apply(); \
        } \
        else { \
            if(entry_key2 != key2) { \
                tbl_exact_match.apply(); \
            } \
            else { \
                if(entry_key3 != key3) { \
                    tbl_exact_match.apply(); \
                } \
            } \
        } \
    } \


#define FLOWKEY_STORAGE_CORE_4() \
    key1_ht_table.apply(); \
    key2_ht_table.apply(); \
    key3_ht_table.apply(); \
    key4_ht_table.apply(); \
    if (entry_key1 != 0 && entry_key2 != 0 && entry_key3 != 0 && entry_key4 != 0) { \
        if(entry_key1 != key1) { \
            tbl_exact_match.apply(); \
        } \
        else { \
            if(entry_key2 != key2) { \
                tbl_exact_match.apply(); \
            } \
            else { \
                if(entry_key3 != key3) { \
                    tbl_exact_match.apply(); \
                } \
                else { \
                    if(entry_key4 != key4) { \
                        tbl_exact_match.apply(); \
                    } \
                } \
            } \
        } \
    } \


#define FLOWKEY_STORAGE_CORE_5() \
    key1_ht_table.apply(); \
    key2_ht_table.apply(); \
    key3_ht_table.apply(); \
    key4_ht_table.apply(); \
    key5_ht_table.apply(); \
    if (entry_key1 != 0 && entry_key2 != 0 && entry_key3 != 0 && entry_key4 != 0 && entry_key5 != 0) { \
        if(entry_key1 != key1) { \
            tbl_exact_match.apply(); \
        } \
        else { \
            if(entry_key2 != key2) { \
                tbl_exact_match.apply(); \
            } \
            else { \
                if(entry_key3 != key3) { \
                    tbl_exact_match.apply(); \
                } \
                else { \
                    if(entry_key4 != key4) { \
                        tbl_exact_match.apply(); \
                    } \
                    else { \
                        if(entry_key5 != key5) { \
                            tbl_exact_match.apply(); \
                        } \
                    } \
                } \
            } \
        } \
    } \


#define EXACT_TABLE_SETUP() \
    action tbl_exact_match_miss() { \
        ig_dprsr_md.digest_type = SKETCHMD_HEAVY_FLOWKEY_DIGEST_TYPE; \
    } \
    action tbl_exact_match_hit() { \
    } \
    table tbl_exact_match { \
        key = { \


#define EXACT_TABLE_END() \
        } \
        actions = { \
            tbl_exact_match_miss; \
            tbl_exact_match_hit; \
        } \
        const default_action = tbl_exact_match_miss; \
        size = EXACT_MATCH_SIZE; \
    } \


#define EXACT_TABLE_1() \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    EXACT_TABLE_END() \


#define EXACT_TABLE_2() \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    EXACT_TABLE_END() \


#define EXACT_TABLE_3() \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    key3 : exact; \
    EXACT_TABLE_END() \


#define EXACT_TABLE_4() \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    key3 : exact; \
    key4 : exact; \
    EXACT_TABLE_END() \


#define EXACT_TABLE_5() \
    EXACT_TABLE_SETUP() \
    key1 : exact; \
    key2 : exact; \
    key3 : exact; \
    key4 : exact; \
    key5 : exact; \
    EXACT_TABLE_END() \




control HEAVY_FLOWKEY_STORAGE_221 (
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
    in bit<32> key1,
    in bit<32> key2,
    in bit<16> key3,
    in bit<16> key4,
    in bit<8> key5)
    (bit<32> polynomial)
{
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1;

    HEADER_STORAGE(32, key1)
    HEADER_STORAGE(32, key2)
    HEADER_STORAGE(16, key3)
    HEADER_STORAGE(16, key4)
    HEADER_STORAGE(8, key5)
    HEADER_STORAGE_STORE_5(32, key1)
    HEADER_STORAGE_STORE_5(32, key2)
    HEADER_STORAGE_STORE_5(16, key3)
    HEADER_STORAGE_STORE_5(16, key4)
    HEADER_STORAGE_STORE_5(8, key5)

    EXACT_TABLE_5()

    apply {
        FLOWKEY_STORAGE_CORE_5()
    }
}

control HEAVY_FLOWKEY_STORAGE_220 (
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
    in bit<32> key1,
    in bit<32> key2,
    in bit<16> key3,
    in bit<16> key4)
    (bit<32> polynomial)
{
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1;

    HEADER_STORAGE(32, key1)
    HEADER_STORAGE(32, key2)
    HEADER_STORAGE(16, key3)
    HEADER_STORAGE(16, key4)
    HEADER_STORAGE_STORE_4(32, key1)
    HEADER_STORAGE_STORE_4(32, key2)
    HEADER_STORAGE_STORE_4(16, key3)
    HEADER_STORAGE_STORE_4(16, key4)

    EXACT_TABLE_4()

    apply {
        FLOWKEY_STORAGE_CORE_4()
    }
}


control HEAVY_FLOWKEY_STORAGE_210 (
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
    in bit<32> key1,
    in bit<32> key2,
    in bit<16> key3)
    (bit<32> polynomial)
{
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1;

    HEADER_STORAGE(32, key1)
    HEADER_STORAGE(32, key2)
    HEADER_STORAGE(16, key3)
    HEADER_STORAGE_STORE_3(32, key1)
    HEADER_STORAGE_STORE_3(32, key2)
    HEADER_STORAGE_STORE_3(16, key3)

    EXACT_TABLE_3()

    apply {
        FLOWKEY_STORAGE_CORE_3()
    }
}


control HEAVY_FLOWKEY_STORAGE_200 (
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
    in bit<32> key1,
    in bit<32> key2)
    (bit<32> polynomial)
{
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1;

    HEADER_STORAGE(32, key1)
    HEADER_STORAGE(32, key2)
    HEADER_STORAGE_STORE_2(32, key1)
    HEADER_STORAGE_STORE_2(32, key2)

    EXACT_TABLE_2()

    apply {
        FLOWKEY_STORAGE_CORE_2()
    }
}


control HEAVY_FLOWKEY_STORAGE_110 (
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
    in bit<32> key1,
    in bit<16> key2)
    (bit<32> polynomial)
{
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1;

    HEADER_STORAGE(32, key1)
    HEADER_STORAGE(16, key2)
    HEADER_STORAGE_STORE_2(32, key1)
    HEADER_STORAGE_STORE_2(16, key2)

    EXACT_TABLE_2()

    apply {
        FLOWKEY_STORAGE_CORE_2()
    }
}


control HEAVY_FLOWKEY_STORAGE_100 (
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
    in bit<32> key1)
    (bit<32> polynomial)
{
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1;

    HEADER_STORAGE(32, key1)
    HEADER_STORAGE_STORE_1(32, key1)

    EXACT_TABLE_1()

    apply {
        FLOWKEY_STORAGE_CORE_1()
    }
}


control HEAVY_FLOWKEY_STORAGE_010 (
    inout header_t hdr,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
    in bit<16> key1)
    (bit<32> polynomial)
{
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1;

    HEADER_STORAGE(16, key1)
    HEADER_STORAGE_STORE_1(16, key1)

    EXACT_TABLE_1()

    apply {
        FLOWKEY_STORAGE_CORE_1()
    }
}
