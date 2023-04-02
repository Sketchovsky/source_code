#define T1_INDEX_UPDATE(SIZE) \
control T1_INDEX_UPDATE_##SIZE##( \
    in bit<32> base, \
    in bit<16> index) { \
    Register<bit<1>, bit<32>>(SIZE) ca; \
    RegisterAction<bit<1>, bit<32>, bit<1>>(ca) ca_action = { \
        void apply(inout bit<1> register_data, out bit<1> result) { \
            register_data = 1; \
        } \
    }; \
    bit<32> added_index; \
    action add() { \
        added_index = base+(bit<32>)index; \
    } \
    apply { \
        add(); \
        ca_action.execute(added_index); \
    } \
} \


T1_INDEX_UPDATE(131072)
T1_INDEX_UPDATE(262144)
T1_INDEX_UPDATE(524288)


#define T1_UPDATE_CORE(SIZE, BITLEN) \
    out bit<1> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<bit<1>, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<bit<1>, bit<##BITLEN##>, bit<1>>(ca) ca_action = { \
        void apply(inout bit<1> register_data, out bit<1> result) { \
            register_data = 1; \
            result = register_data; \
        } \
    }; \
    apply { \


#define T1_KEY_UPDATE(SIZE, BITLEN) \
control T1_KEY_UPDATE_221_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5, \
    T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4, key5}));\
    }} \
control T1_KEY_UPDATE_220_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4}));\
    }} \
control T1_KEY_UPDATE_200_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control T1_KEY_UPDATE_110_##SIZE##( \
    in bit<32> key1, \
    in bit<16> key2, \
    T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control T1_KEY_UPDATE_100_##SIZE##( \
    in bit<32> key1, \
    T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \
control T1_KEY_UPDATE_010_##SIZE##( \
    in bit<16> key1, \
    T1_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \


T1_KEY_UPDATE(131072, 17)
T1_KEY_UPDATE(262144, 18)
T1_KEY_UPDATE(524288, 19)

