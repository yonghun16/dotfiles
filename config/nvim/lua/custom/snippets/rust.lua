local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local f = ls.function_node

return {
  -- Online judge용 주석 Header (Rust)
  s(
    "headerComment OJ",
    fmt(
      [[
/* -----------------------------------------------------------
 * Sub    : [<>] <>
 * Link   : <>
 * Level  :
 * Tag    : Rust,
 * ------------------------------------------------------------
 * Approach
 * <>
 * ------------------------------------------------------------
 */
#![allow(unused)]

use std::io::{self, BufWriter, Read, Write};

fn read_input() ->> String {
    std::fs::read_to_string("./input_test.txt").unwrap_or_else(|_| {
        let mut s = String::new();
        io::stdin().read_to_string(&mut s).unwrap();
        s
    })
}

fn main() {
    let input = read_input();
    let mut it = input.split_ascii_whitespace();
    let mut out = BufWriter::new(io::stdout().lock());

    /* 📥 Input */
    // let n: usize = it.next().unwrap().parse().unwrap();
    // let a: Vec<<i64>> = (0..n).map(|_| it.next().unwrap().parse().unwrap()).collect();

    /* ⚙️ Logic */
    <>

    /* 🚀 Output */
    // writeln!(out, "{}", ans).unwrap();
}
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

  -- 일반 파일용 주석 Header (Rust)
  s(
    "headerComment",
    fmt(
      [[
/* ------------------------------------------------------------
 * File     : <>
 * Brief    : <>
 * ------------------------------------------------------------
 * Abstract
 * <>
 * ------------------------------------------------------------
 */

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
