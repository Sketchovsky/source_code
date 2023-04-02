struct pair1 {
    bit<1> first;
    bit<1> second;
}

struct pair8 {
    bit<8> first;
    bit<8> second;
}

struct pair32 {
    bit<32> first;
    bit<32> second;
}

/****************************** SINGLE-LEVEL ******************************/

// 1bit - T1 x T1 (bitmaps)


#define T1_T1_UPDATE_CORE(SIZE, BITLEN) \
    out bit<1> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair1, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair1, bit<##BITLEN##>, bit<1>>(ca) ca_action = { \
        void apply(inout pair1 register_data, out bit<1> result) { \
            register_data.first = 1; \
            register_data.second = 1; \
            result = register_data.first; \
        } \
    }; \
    apply { \


#define T1_T1_KEY_UPDATE(SIZE, BITLEN) \
control T1_T1_KEY_UPDATE_221_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5, \
    T1_T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4, key5}));\
    }} \
control T1_T1_KEY_UPDATE_220_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    T1_T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4}));\
    }} \
control T1_T1_KEY_UPDATE_200_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    T1_T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control T1_T1_KEY_UPDATE_110_##SIZE##( \
    in bit<32> key1, \
    in bit<16> key2, \
    T1_T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control T1_T1_KEY_UPDATE_100_##SIZE##( \
    in bit<32> key1, \
    T1_T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \
control T1_T1_KEY_UPDATE_010_##SIZE##( \
    in bit<16> key1, \
    T1_T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \


T1_T1_KEY_UPDATE(131072, 17)
T1_T1_KEY_UPDATE(262144, 18)
T1_T1_KEY_UPDATE(524288, 19)

// 8bit - T4 x T4 (HLL)

#define T4_T4_UPDATE_CORE(SIZE, BITLEN) \
    in bit<8> level)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair8, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair8, bit<##BITLEN##>, bit<8>>(ca) ca_action = { \
        void apply(inout pair8 register_data, out bit<8> result) { \
            if (level > register_data.first) { \
                register_data.first = level; \
            } \
            if (level > register_data.second) { \
                register_data.second = level; \
            } \
        } \
    }; \
    apply { \

#define T4_T4_KEY_UPDATE(SIZE, BITLEN) \
control T4_T4_KEY_UPDATE_221_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5, \
    T4_T4_UPDATE_CORE(SIZE, BITLEN) \
    ca_action.execute(hash.get({key1, key2, key3, key4, key5}));\
    }} \
control T4_T4_KEY_UPDATE_220_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    T4_T4_UPDATE_CORE(SIZE, BITLEN) \
    ca_action.execute(hash.get({key1, key2, key3, key4}));\
    }} \
control T4_T4_KEY_UPDATE_200_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    T4_T4_UPDATE_CORE(SIZE, BITLEN) \
    ca_action.execute(hash.get({key1, key2}));\
    }} \
control T4_T4_KEY_UPDATE_110_##SIZE##( \
    in bit<32> key1, \
    in bit<16> key2, \
    T4_T4_UPDATE_CORE(SIZE, BITLEN) \
    ca_action.execute(hash.get({key1, key2}));\
    }} \
control T4_T4_KEY_UPDATE_100_##SIZE##( \
    in bit<32> key1, \
    T4_T4_UPDATE_CORE(SIZE, BITLEN) \
    ca_action.execute(hash.get({key1}));\
    }} \
control T4_T4_KEY_UPDATE_010_##SIZE##( \
    in bit<16> key1, \
    T4_T4_UPDATE_CORE(SIZE, BITLEN) \
    ca_action.execute(hash.get({key1}));\
    }} \


T4_T4_KEY_UPDATE(16384, 12)
T4_T4_KEY_UPDATE(8192, 13)
T4_T4_KEY_UPDATE(16384, 14)
T4_T4_KEY_UPDATE(32768, 15)
T4_T4_KEY_UPDATE(65536, 16)


// 32bit - (T2, T3, T5) x (T2, T3, T5) (counters)

#define T2_T2_UPDATE_CORE(SIZE, BITLEN) \
    in bit<16> psize1, \
    in bit<16> psize2, \
    out bit<32> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair32, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair32, bit<##BITLEN##>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            register_data.first = register_data.first + (bit<32>)psize1; \
            register_data.second = register_data.second + (bit<32>)psize2; \
            result = register_data.first; \
        } \
    }; \
    apply { \


#define T2_T5_UPDATE_CORE(SIZE, BITLEN) \
    in bit<16> psize, \
    in bit<32> bitmask, \
    out bit<32> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair32, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair32, bit<##BITLEN##>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            register_data.first = register_data.first + (bit<32>)psize; \
            register_data.second = register_data.second | bitmask; \
            result = register_data.first; \
        } \
    }; \
    apply { \


#define T5_T2_UPDATE_CORE(SIZE, BITLEN) \
    in bit<16> psize, \
    in bit<32> bitmask, \
    out bit<32> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair32, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair32, bit<##BITLEN##>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            register_data.first = register_data.first + (bit<32>)psize; \
            register_data.second = register_data.second | bitmask; \
            result = register_data.first; \
        } \
    }; \
    apply { \


#define T3_T2_UPDATE_CORE(SIZE, BITLEN) \
    in bit<16> psize1, \
    in bit<1> res, \
    in bit<16> psize2, \
    out bit<32> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair32, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair32, bit<##BITLEN##>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            if (res == 0) { \
                register_data.first = register_data.first - (bit<32>)psize1; \
            } \
            else { \
                register_data.first = register_data.first + (bit<32>)psize1; \
            } \
            register_data.second = register_data.second + (bit<32>)psize2; \
            result = register_data.first; \
        } \
    }; \
    apply { \


#define T3_T5_UPDATE_CORE(SIZE, BITLEN) \
    in bit<16> psize1, \
    in bit<1> res, \
    in bit<32> bitmask, \
    out bit<32> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair32, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair32, bit<##BITLEN##>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            if (res == 0) { \
                register_data.first = register_data.first - (bit<32>)psize1; \
            } \
            else { \
                register_data.first = register_data.first + (bit<32>)psize1; \
            } \
            register_data.second = register_data.second | bitmask; \
            result = register_data.first; \
        } \
    }; \
    apply { \


#define T5_T5_UPDATE_CORE(SIZE, BITLEN) \
    in bit<32> bitmask, \
    out bit<32> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<pair32, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<pair32, bit<##BITLEN##>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            register_data.first = register_data.first | bitmask; \
            register_data.second = register_data.second | bitmask; \
            result = register_data.first; \
        } \
    }; \
    apply { \


#define T25_KEY_UPDATE(TX, TY, SIZE, BITLEN) \
control TX##_##TY##_KEY_UPDATE_221_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4, key5}));\
    }} \
control TX##_##TY##_KEY_UPDATE_220_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4}));\
    }} \
control TX##_##TY##_KEY_UPDATE_200_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control TX##_##TY##_KEY_UPDATE_110_##SIZE##( \
    in bit<32> key1, \
    in bit<16> key2, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control TX##_##TY##_KEY_UPDATE_100_##SIZE##( \
    in bit<32> key1, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \
control TX##_##TY##_KEY_UPDATE_010_##SIZE##( \
    in bit<16> key1, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \


#define TX_TY_KEY_UPDATE(SIZE, BITLEN) \
    T25_KEY_UPDATE(T2, T2, SIZE, BITLEN) \
    T25_KEY_UPDATE(T2, T5, SIZE, BITLEN) \
    T25_KEY_UPDATE(T5, T2, SIZE, BITLEN) \
    T25_KEY_UPDATE(T5, T5, SIZE, BITLEN) \


TX_TY_KEY_UPDATE(4096, 12)
TX_TY_KEY_UPDATE(8192, 13)
TX_TY_KEY_UPDATE(16384, 14)


/****************************** For T3 ******************************/
#define T3Y_KEY_UPDATE(TX, TY, SIZE, BITLEN) \
control TX##_##TY##_KEY_UPDATE_221_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4, key5}));\
    if (res == 0) { \
        est = -est; \
    } \
    }} \
control TX##_##TY##_KEY_UPDATE_220_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4}));\
    if (res == 0) { \
        est = -est; \
    } \
    }} \
control TX##_##TY##_KEY_UPDATE_200_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    if (res == 0) { \
        est = -est; \
    } \
    }} \
control TX##_##TY##_KEY_UPDATE_110_##SIZE##( \
    in bit<32> key1, \
    in bit<16> key2, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    if (res == 0) { \
        est = -est; \
    } \
    }} \
control TX##_##TY##_KEY_UPDATE_100_##SIZE##( \
    in bit<32> key1, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    if (res == 0) { \
        est = -est; \
    } \
    }} \
control TX##_##TY##_KEY_UPDATE_010_##SIZE##( \
    in bit<16> key1, \
    ##TX##_##TY##_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    if (res == 0) { \
        est = -est; \
    } \
    }} \


#define T3_TY_KEY_UPDATE(SIZE, BITLEN) \
    T3Y_KEY_UPDATE(T3, T2, SIZE, BITLEN) \
    T3Y_KEY_UPDATE(T3, T5, SIZE, BITLEN) \

T3_TY_KEY_UPDATE(4096, 12)
T3_TY_KEY_UPDATE(8192, 13)
T3_TY_KEY_UPDATE(16384, 14)


/****************************** MULTI-LEVEL ******************************/

// 32bit - (T2 x T2) - (MRB x MRB)
#define T2_T2_INDEX_UPDATE(SIZE) \
control T2_T2_INDEX_UPDATE_##SIZE##( \
    in bit<16> base, \
    in bit<16> index)() { \
    Register<pair32, bit<16>>(SIZE) ca; \
    RegisterAction<pair32, bit<16>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            register_data.first = register_data.first + 1; \
            register_data.second = register_data.second + 1; \
        } \
    }; \
    bit<16> added_index; \
    action add() { \
        added_index = base+index; \
    } \
    apply { \
        add(); \
        ca_action.execute(added_index); \
    } \
} \


T2_T2_INDEX_UPDATE(8192)
T2_T2_INDEX_UPDATE(16384)
T2_T2_INDEX_UPDATE(32768)

// 32bit - (T3 x T2) - (UnivMon x MRB)


#define T3_T2_INDEX_UPDATE(SIZE) \
control T3_T2_INDEX_UPDATE_##SIZE##( \
    in bit<16> base, \
    in bit<16> index, \
    in bit<1> res, \
    in bit<16> psize, \
    out bit<32> est)() { \
    Register<pair32, bit<16>>(SIZE) ca; \
    RegisterAction<pair32, bit<16>, bit<32>>(ca) ca_action = { \
        void apply(inout pair32 register_data, out bit<32> result) { \
            if (res == 0) { \
                register_data.first = register_data.first - (bit<32>)psize; \
            } \
            else { \
                register_data.first = register_data.first + (bit<32>)psize; \
            } \
            register_data.second = register_data.second + 1; \
            result = register_data.first; \
        } \
    }; \
    bit<16> added_index; \
    action add() { \
        added_index = base+index; \
    } \
    apply { \
        add(); \
        est = ca_action.execute(added_index); \
        if (res == 0) { \
            est = -est; \
        } \
    } \
} \


T3_T2_INDEX_UPDATE(8192)
T3_T2_INDEX_UPDATE(16384)
T3_T2_INDEX_UPDATE(32768)
