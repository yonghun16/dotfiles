package.loaded["snip_utils.header"] = nil
local h = require "snip_utils.header"

return {
  h.oj_header {
    tag = "Python",
    comment = "hash",
    body = [[

import os
import sys

if os.path.exists("./input_test.txt"):
    sys.stdin = open("./input_test.txt", "r", encoding="utf-8")  # noqa: SIM115

input = sys.stdin.readline
sys.setrecursionlimit(10**6)


# 📥 Input
def get_input_data() ->> tuple:
    # n = int(input())
    # arr = list(map(int, input().split()))
    return ()


# ⚙️ Logic
def solution(data: tuple) ->> None:
    pass
    <>

# 🚀 Run Program
if __name__ == "__main__":
    solution(get_input_data())
]],
  },
  h.file_header { comment = "hash" },
}
