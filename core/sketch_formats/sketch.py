### Sketch Algorithms

# statistics
STATISTIC_TYPE_MEMBERSHIP = 1
STATISTIC_TYPE_CARDINALITY = 2
STATISTIC_TYPE_ENTROPY = 3
STATISTIC_TYPE_HEAVY_HITTER = 4
STATISTIC_TYPE_HEAVY_CHANGE = 5
STATISTIC_TYPE_FLOWSIZE_DIST = 6
STATISTIC_TYPE_GENERAL = 7
pool_of_statistics = [1, 2, 3, 4, 5, 6, 7]

### Sketch Features

# counter array type
INDEX_COMPUTING_TYPE_1 = 1 # single level (SL)
INDEX_COMPUTING_TYPE_2 = 2 # multi level (ML)

# counter update type
COUNTER_UPDATE_TYPE_CM = 1
COUNTER_UPDATE_TYPE_CS = 2
COUNTER_UPDATE_TYPE_BITMAP = 3
COUNTER_UPDATE_TYPE_HLL = 4
COUNTER_UPDATE_TYPE_PCSA = 5

# whether to use counter value in the data plane or not
COUNTER_DP_Y = True
COUNTER_DP_N = False

# sampling compatible or not (deprecated)
SAMPLING_Y = False
SAMPLING_N = False

class Sketch:
    def __init__(self, _name, _statistic, _counter_bit, _index_type, _counter_update_type, _counter_in_dp_type, _sampling_compatible, _level_hash, _res_hash, _multi, _heavy):
        self.name = _name
        self.statistic = _statistic
        self.counter_bit = _counter_bit
        self.index_type = _index_type
        self.counter_update_type = _counter_update_type
        self.counter_in_dp_type = _counter_in_dp_type
        self.sampling_compatible = _sampling_compatible
        self.level_hash = _level_hash
        self.res_hash = _res_hash
        self.multi_level_sketch = _multi
        self.heavy_flowkey_storage = _heavy

    def print(self):
        print("[-----%s-----]" % self.name)
        print("[index_type:          %d]" % self.index_type)
        print("[counter_update_type: %d]" % self.counter_update_type)
        print("[counter_in_dp_type:  %d]" % self.counter_in_dp_type)
        print("[sampling_compatible: %d]" % self.sampling_compatible)

LinearCounting      = Sketch("LinearCounting"     , STATISTIC_TYPE_CARDINALITY  , 1 , INDEX_COMPUTING_TYPE_1, COUNTER_UPDATE_TYPE_BITMAP, COUNTER_DP_N, SAMPLING_N, 0, 0, False, False) # 1
BloomFilter         = Sketch("BloomFilter"        , STATISTIC_TYPE_MEMBERSHIP   , 1 , INDEX_COMPUTING_TYPE_1, COUNTER_UPDATE_TYPE_BITMAP, COUNTER_DP_Y, SAMPLING_N, 0, 0, False, False) # 2

CountMin            = Sketch("CountMin"           , STATISTIC_TYPE_HEAVY_HITTER , 32, INDEX_COMPUTING_TYPE_1,     COUNTER_UPDATE_TYPE_CM, COUNTER_DP_Y, SAMPLING_Y, 0, 0, False, True ) # 3
Kary                = Sketch("Kary"               , STATISTIC_TYPE_HEAVY_CHANGE , 32, INDEX_COMPUTING_TYPE_1,     COUNTER_UPDATE_TYPE_CM, COUNTER_DP_Y, SAMPLING_Y, 0, 0, False, True ) # 4
CountingBloomFilter = Sketch("CountingBloomFilter", STATISTIC_TYPE_MEMBERSHIP   , 32, INDEX_COMPUTING_TYPE_1,     COUNTER_UPDATE_TYPE_CM, COUNTER_DP_Y, SAMPLING_N, 0, 0, False, False) # 5

Entropy             = Sketch("Entropy"            , STATISTIC_TYPE_ENTROPY      , 32, INDEX_COMPUTING_TYPE_1,     COUNTER_UPDATE_TYPE_CS, COUNTER_DP_N, SAMPLING_Y, 0, 1, False, False) # 6 -> additional 1 hash call for res
CountSketch         = Sketch("CountSketch"        , STATISTIC_TYPE_HEAVY_HITTER , 32, INDEX_COMPUTING_TYPE_1,     COUNTER_UPDATE_TYPE_CS, COUNTER_DP_Y, SAMPLING_Y, 0, 1, False, True ) # 7 -> additional 1 hash call for res

HLL                 = Sketch("HLL"                , STATISTIC_TYPE_CARDINALITY  , 8 , INDEX_COMPUTING_TYPE_1,    COUNTER_UPDATE_TYPE_HLL, COUNTER_DP_N, SAMPLING_N, 2, 0, False, False) # 8 -> additional 2 hash call for level
PCSA                = Sketch("PCSA"               , STATISTIC_TYPE_CARDINALITY  , 32, INDEX_COMPUTING_TYPE_1,   COUNTER_UPDATE_TYPE_PCSA, COUNTER_DP_N, SAMPLING_N, 2, 0, False, False) # 9 -> additional 2 hash call for level

MRB                 = Sketch("MRB"                , STATISTIC_TYPE_CARDINALITY  , 1 , INDEX_COMPUTING_TYPE_2, COUNTER_UPDATE_TYPE_BITMAP, COUNTER_DP_N, SAMPLING_N, 1, 0, True , False) # 10 -> additional 1 hash call for level
UnivMon             = Sketch("UnivMon"            , STATISTIC_TYPE_GENERAL      , 32, INDEX_COMPUTING_TYPE_2,     COUNTER_UPDATE_TYPE_CS, COUNTER_DP_Y, SAMPLING_Y, 1, 1, True , True ) # 11 -> additional 2 hash call for level, res
MRAC                = Sketch("MRAC"               , STATISTIC_TYPE_FLOWSIZE_DIST, 32, INDEX_COMPUTING_TYPE_2,     COUNTER_UPDATE_TYPE_CM, COUNTER_DP_N, SAMPLING_N, 1, 0, True , False) # 12 -> additional 1 hash call for level


pool_of_sketches = [BloomFilter, LinearCounting, HLL, MRB, PCSA, Entropy, CountMin, CountSketch, Kary, MRAC, UnivMon]

sketch_dict = {}
sketch_dict[STATISTIC_TYPE_MEMBERSHIP] = [BloomFilter]
sketch_dict[STATISTIC_TYPE_CARDINALITY] = [LinearCounting, HLL, MRB, PCSA]
sketch_dict[STATISTIC_TYPE_ENTROPY] = [Entropy]
sketch_dict[STATISTIC_TYPE_HEAVY_HITTER] = [CountMin, CountSketch]
sketch_dict[STATISTIC_TYPE_HEAVY_CHANGE] = [Kary]
sketch_dict[STATISTIC_TYPE_FLOWSIZE_DIST] = [MRAC]
sketch_dict[STATISTIC_TYPE_GENERAL] = [UnivMon]