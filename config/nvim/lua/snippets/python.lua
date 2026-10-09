package.loaded["snip_utils.header"] = nil -- 공통 모듈 수정 시 즉시 반영 (선택)
local h = require "snip_utils.header"

return {
  h.oj_header {
    tag = "Python",
    comment = "hash",
    body = [[

import os
import sys

if os.path.exists("./input_test.txt"):
    sys.stdin = open("./input_test.txt", "r", encoding="utf-8")

input = sys.stdin.readline
sys.setrecursionlimit(10**6)


# 📥 Input
def get_input_data():
    # n = int(input())
    # arr = list(map(int, input().split()))
    return {}


# ⚙️ Logic
def solution(data):
    pass
    <>


# 🚀 Run Program
if __name__ == "__main__":
    solution(get_input_data())
]],
  },
  h.file_header { comment = "hash" },
}
