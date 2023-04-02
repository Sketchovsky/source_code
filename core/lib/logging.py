import sys

msg_color = {"white": "", \
             "red": "\033[1;31m", \
             "green": "\033[32m", \
             "yellow": "\033[33m", \
             "blue": "\033[34m", \
             "purple": "\033[35m", \
             "cyan": "\033[36m", \
             }

DEBUG_LEVEL = 2
# DEBUG_LEVEL = 8
# DEBUG_LEVEL = 100



def print_msg(msg, level=1, color="white"):
    global msg_color
    global DEBUG_LEVEL
    if level <= DEBUG_LEVEL:
        print(f"{msg_color[color]}[l_{level}] {msg}\033[0m")

def print_inst_list_msg(inst_list, level):
    if level <= DEBUG_LEVEL:
        print(f"[l_{level}]")
        from lib.inst_list import print_inst_list
        print_inst_list(inst_list)

def print_answer_list_msg(answer_list, level):
    if level <= DEBUG_LEVEL:
        print(f"[l_{level}]")
        from lib.inst_list import print_answer_list
        print_answer_list(answer_list)
