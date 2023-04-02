#define T2_INDEX_UPDATE(SIZE) \
control T2_INDEX_UPDATE_##SIZE##( \
    in bit<16> base, \
    in bit<16> index)() { \
    Register<bit<32>, bit<16>>(SIZE) ca; \
    RegisterAction<bit<32>, bit<16>, bit<32>>(ca) ca_action = { \
        void apply(inout bit<32> register_data, out bit<32> result) { \
            register_data = register_data + 1; \
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


T2_INDEX_UPDATE(8192)
T2_INDEX_UPDATE(16384)
T2_INDEX_UPDATE(32768)


#define T2_UPDATE_CORE(SIZE, BITLEN) \
    in bit<16> psize, \
    out bit<32> est)( \
    bit<32> polynomial) { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF, 32w0xFFFFFFFF) poly1; \
    Hash<bit<##BITLEN##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    Register<bit<32>, bit<##BITLEN##>>(SIZE) ca; \
    RegisterAction<bit<32>, bit<##BITLEN##>, bit<32>>(ca) ca_action = { \
        void apply(inout bit<32> register_data, out bit<32> result) { \
            register_data = register_data + (bit<32>)psize; \
            result = register_data; \
        } \
    }; \
    apply { \


#define T2_KEY_UPDATE(SIZE, BITLEN) \
control T2_KEY_UPDATE_221_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5, \
    T2_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4, key5}));\
    }} \
control T2_KEY_UPDATE_220_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    T2_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2, key3, key4}));\
    }} \
control T2_KEY_UPDATE_200_##SIZE##( \
    in bit<32> key1, \
    in bit<32> key2, \
    T2_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control T2_KEY_UPDATE_110_##SIZE##( \
    in bit<32> key1, \
    in bit<16> key2, \
    T2_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1, key2}));\
    }} \
control T2_KEY_UPDATE_100_##SIZE##( \
    in bit<32> key1, \
    T2_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \
control T2_KEY_UPDATE_010_##SIZE##( \
    in bit<16> key1, \
    T2_UPDATE_CORE(SIZE, BITLEN) \
    est = ca_action.execute(hash.get({key1}));\
    }} \


T2_KEY_UPDATE(4096, 12)
T2_KEY_UPDATE(8192, 13)
T2_KEY_UPDATE(16384, 14)
T2_KEY_UPDATE(32768, 15)
T2_KEY_UPDATE(65536, 16)

