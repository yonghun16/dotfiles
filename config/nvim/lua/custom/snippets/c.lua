local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node

return {
  -- Online judge용 주석 Header (C)
  s(
    "headerComment OJ",
    fmt(
      [[
/* ------------------------------------------------------------
 * Sub    : [{}] {}
 * Link   : {}
 * Level  : 
 * Tag    : C, 
 * ------------------------------------------------------------
 * Abstract
 * {}
 * ------------------------------------------------------------ */

#include <stdio.h>

int main() {{

    return 0;
}}
]],
      {
        c(1, { i(nil, "BOJ"), i(nil, "Programmers") }),
        i(2, "문제 제목"),
        d(3, function(args)
          local platform = args[1][1] or ""
          local prefix = ""
          if platform == "BOJ" then
            prefix = "https://www.acmicpc.net/problem/"
          elseif platform == "Programmers" then
            prefix = "https://school.programmers.co.kr/learn/courses/30/lessons/"
          end
          return sn(nil, i(1, prefix))
        end, { 1 }),
        i(0),
      }
    )
  ),

  -- 일반 파일용 주석 Header (C)
  s(
    "headerComment",
    fmt(
      [[
/* ------------------------------------------------------------
 * File     : {}
 * Brief    : {}
 * ------------------------------------------------------------
 * Details
 * {}
 * ------------------------------------------------------------ */

#include <stdio.h>

int main() {{

    return 0;
}}
]],
      {
        f(function()
          return vim.fn.expand "%:t"
        end, {}),
        i(1, "간단 설명 입력"),
        i(0),
      }
    )
  ),
}
