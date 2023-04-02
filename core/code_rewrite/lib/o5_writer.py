from code_rewrite.lib.common import *

class O5_Writer:
    def __init__(self, o5_inst):
        self.id_list = []
        self.flowkey_list = []
        self.o5_inst = o5_inst
        if o5_inst != None:
            self.union_flowkey = o5_inst.get_flowkey()
            self.flowkey_code = get_flowkey_code(self.union_flowkey)

    def is_valid(self):
        if self.o5_inst != None:
            return True
        return False


    def add(self, id, flowkey):
        self.id_list.append(id)
        self.flowkey_list.append(flowkey)

    def init_msg(self):
        msg = ""
        if self.is_valid():
            msg += f"\n    HEAVY_FLOWKEY_STORAGE_CONFIG_{self.flowkey_code}(32w0x30243f0b) heavy_flowkey_storage;"
        return msg

    def run_msg(self):
        msg = ""
        if len(self.id_list) == 1:
            id = self.id_list[0]
            flowkey_str = get_flowkey_str(self.union_flowkey)
            msg += f"        if(ig_md.d_{id}_above_threshold == 1) {{\n"
            msg += f"            heavy_flowkey_storage.apply(ig_dprsr_md, {flowkey_str});\n"
            msg += f"        }}\n"

        if len(self.id_list) > 1:
            for elem in self.union_flowkey:
                msg += "        if(\n"
                flag = False
                for id, flowkey in zip(self.id_list, self.flowkey_list):
                    if elem in flowkey:
                        if flag:
                            msg += f"        || ig_md.d_{id}_above_threshold == 1\n"
                        else:
                            msg += f"        ig_md.d_{id}_above_threshold == 1\n"
                            flag = True
                msg += "        ) {\n"
                if elem == 0:
                    msg += "            ig_md.hf_srcip = SRCIP; \n"
                if elem == 1:
                    msg += "            ig_md.hf_dstip = DSTIP; \n"
                if elem == 2:
                    msg += "            ig_md.hf_srcport = SRCPORT; \n"
                if elem == 3:
                    msg += "            ig_md.hf_dstport = DSTPORT; \n"
                if elem == 4:
                    msg += "            ig_md.hf_proto = PROTO; \n"
                msg += "        }\n"
            msg += "        if(\n"
            flag = False
            for id, flowkey in zip(self.id_list, self.flowkey_list):
                if flag:
                    msg += f"        || ig_md.d_{id}_above_threshold == 1\n"
                else:
                    msg += f"        ig_md.d_{id}_above_threshold == 1\n"
                    flag = True
            msg += "        ) {\n"
            msg += "            heavy_flowkey_storage.apply(ig_dprsr_md,"
            flag = False
            for elem in self.union_flowkey:
                if flag:
                    msg += ", "
                if elem == 0:
                    msg += "ig_md.hf_srcip"
                    flag = True
                if elem == 1:
                    msg += "ig_md.hf_dstip"
                    flag = True
                if elem == 2:
                    msg += "ig_md.hf_srcport"
                    flag = True
                if elem == 3:
                    msg += "ig_md.hf_dstport"
                    flag = True
                if elem == 4:
                    msg += "ig_md.hf_proto"
                    flag = True

            msg += "); \n"
            msg += "        }\n"
            
        return msg


        # if(ig_md.d_1_above_threshold == 1 ||
        #    ig_md.d_2_above_threshold == 1 ||
        #    ig_md.d_3_above_threshold == 1 ||
        #    ig_md.d_4_above_threshold == 1 ||
        #    ig_md.d_5_above_threshold == 1 ||
        #    ig_md.d_6_above_threshold == 1 ||
        #    ig_md.d_9_above_threshold == 1 ||
        #    ig_md.d_10_above_threshold == 1 ||
        #    ig_md.d_11_above_threshold == 1 ||
        #    ig_md.d_12_above_threshold == 1 ||
        #    ig_md.d_13_above_threshold == 1 ||
        #    ig_md.d_14_above_threshold == 1) {
        #     ig_md.hf_srcip = SRCIP;
        # }

        # if(ig_md.d_7_above_threshold == 1 ||
        #    ig_md.d_8_above_threshold == 1 ||
        #    ig_md.d_9_above_threshold == 1 ||
        #    ig_md.d_10_above_threshold == 1 ||
        #    ig_md.d_13_above_threshold == 1 ||
        #    ig_md.d_14_above_threshold == 1) {
        #     ig_md.hf_dstip = DSTIP;
        # }

        # if(ig_md.d_11_above_threshold == 1 ||
        #    ig_md.d_12_above_threshold == 1 ||
        #    ig_md.d_13_above_threshold == 1 ||
        #    ig_md.d_14_above_threshold == 1) {
        #     ig_md.hf_srcport = SRCPORT;
        # }

        # if(ig_md.d_13_above_threshold == 1 ||
        #    ig_md.d_14_above_threshold == 1) {
        #     ig_md.hf_dstport = DSTPORT;
        # }

        # if(ig_md.d_1_above_threshold == 1 ||
        #    ig_md.d_2_above_threshold == 1 ||
        #    ig_md.d_3_above_threshold == 1 ||
        #    ig_md.d_4_above_threshold == 1 ||
        #    ig_md.d_5_above_threshold == 1 ||
        #    ig_md.d_6_above_threshold == 1 ||
        #    ig_md.d_7_above_threshold == 1 ||
        #    ig_md.d_8_above_threshold == 1 ||
        #    ig_md.d_9_above_threshold == 1 ||
        #    ig_md.d_10_above_threshold == 1 ||
        #    ig_md.d_11_above_threshold == 1 ||
        #    ig_md.d_12_above_threshold == 1 ||
        #    ig_md.d_13_above_threshold == 1 ||
        #    ig_md.d_14_above_threshold == 1) {
        #     heavy_flowkey_storage.apply(ig_dprsr_md, ig_md.hf_srcip, ig_md.hf_dstip, ig_md.hf_srcport, ig_md.hf_dstport);
        # }
