package.loaded["snip_utils.header"] = nil -- 공통 모듈 수정 시 즉시 반영 (선택)
local h = require "snip_utils.header"

return {
  h.oj_header {
    tag = "Rust",
    body = [[

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
  },
  h.file_header(),
}
