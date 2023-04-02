#define COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    out bit<##PHV_LENGTH##> result)( \
    bit<32> polynomial) \
    { \
    CRCPolynomial<bit<32>>(polynomial,true,false,false,32w0xFFFFFFFF,32w0xFFFFFFFF) poly1; \
    Hash<bit<##HASH_LENGTH##>>(HashAlgorithm_t.CUSTOM, poly1) hash; \
    action action_hash() { \


#define COMPUTE_HASH_END() \
    } \
    apply { \
        action_hash(); \
    } \
} \


#define COMPUTE_HASH(PHV_LENGTH, HASH_LENGTH) \
control COMPUTE_HASH_221_##PHV_LENGTH##_##HASH_LENGTH##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    in bit<8> key5, \
    COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    result = (bit<##PHV_LENGTH##>) hash.get({key1, key2, key3, key4, key5}); \
    COMPUTE_HASH_END() \
control COMPUTE_HASH_220_##PHV_LENGTH##_##HASH_LENGTH##( \
    in bit<32> key1, \
    in bit<32> key2, \
    in bit<16> key3, \
    in bit<16> key4, \
    COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    result = (bit<##PHV_LENGTH##>) hash.get({key1, key2, key3, key4}); \
    COMPUTE_HASH_END() \
control COMPUTE_HASH_200_##PHV_LENGTH##_##HASH_LENGTH##( \
    in bit<32> key1, \
    in bit<32> key2, \
    COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    result = (bit<##PHV_LENGTH##>) hash.get({key1, key2}); \
    COMPUTE_HASH_END() \
control COMPUTE_HASH_120_##PHV_LENGTH##_##HASH_LENGTH##( \
    in bit<32> key1, \
    in bit<16> key2, \
    in bit<16> key3, \
    COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    result = (bit<##PHV_LENGTH##>) hash.get({key1, key2, key3}); \
    COMPUTE_HASH_END() \
control COMPUTE_HASH_110_##PHV_LENGTH##_##HASH_LENGTH##( \
    in bit<32> key1, \
    in bit<16> key2, \
    COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    result = (bit<##PHV_LENGTH##>) hash.get({key1, key2}); \
    COMPUTE_HASH_END() \
control COMPUTE_HASH_100_##PHV_LENGTH##_##HASH_LENGTH##( \
    in bit<32> key1, \
    COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    result = (bit<##PHV_LENGTH##>) hash.get({key1}); \
    COMPUTE_HASH_END() \
control COMPUTE_HASH_010_##PHV_LENGTH##_##HASH_LENGTH##( \
    in bit<16> key1, \
    COMPUTE_HASH_CORE(PHV_LENGTH, HASH_LENGTH) \
    result = (bit<##PHV_LENGTH##>) hash.get({key1}); \
    COMPUTE_HASH_END() \




COMPUTE_HASH(10, 10)
COMPUTE_HASH(13, 13)
COMPUTE_HASH(16, 3)
COMPUTE_HASH(16, 4)
COMPUTE_HASH(16, 8)
COMPUTE_HASH(16, 10)
COMPUTE_HASH(16, 11)
COMPUTE_HASH(16, 12)
COMPUTE_HASH(16, 13)
COMPUTE_HASH(16, 14)
COMPUTE_HASH(16, 15)
COMPUTE_HASH(16, 16)
COMPUTE_HASH(32, 10)
COMPUTE_HASH(32, 11)
COMPUTE_HASH(32, 15)
COMPUTE_HASH(32, 16)
COMPUTE_HASH(32, 32)
