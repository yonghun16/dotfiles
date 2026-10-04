local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node

return {
  -- Online judge용 주석 Header (Python)
  s(
    "headerComment OJ",
    fmt(
      [[
# -----------------------------------------------------------
# Sub    : [<>] <>
# Link   : <>
# Level  :
# Tag    : Python,
# ------------------------------------------------------------
# Approach
# <>
# ------------------------------------------------------------

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
    <>


# 🚀 Run Program
if __name__ == "__main__":
    solution(get_input_data())
]],
      {
        c(1, { i(nil, "BOJ"), i(nil, "Programmers"), i(nil, "JOL") }),
        i(2, "문제 제목"),
        d(3, function(args)
          local platform = args[1][1] or ""
          local prefix = ""
          if platform == "BOJ" then
            prefix = "https://www.acmicpc.net/problem/"
          elseif platform == "Programmers" then
            prefix = "https://school.programmers.co.kr/learn/courses/30/lessons/"
          elseif platform == "JOL" then
            prefix = "https://jungol.co.kr/problem/"
          end
          return sn(nil, i(1, prefix))
        end, { 1 }),
        i(4, "풀이 접근 방법"),
        i(0),
      },
      { delimiters = "<>" } -- 중괄호 대신 <>를 사용하도록 설정
    )
  ),

  -- 일반 파일용 주석 Header (Python)
  s(
    "headerComment",
    fmt(
      [[
# ------------------------------------------------------------
# File     : <>
# Brief    : <>
# ------------------------------------------------------------
# Abstract
# <>
# ------------------------------------------------------------

]],
      {
        f(function()
          return vim.fn.expand "%:t"
        end, {}), -- 현재 파일명
        i(1, "간단 설명 입력"),
        i(0),
      },
      { delimiters = "<>" } -- 중괄호 대신 <>를 사용하도록 설정
    )
  ),
}
