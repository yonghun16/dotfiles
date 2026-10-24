package.loaded["snip_utils.header"] = nil
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

/* 📥 Input */
fn get_input_data() ->> String {
    read_input()
}

/* ⚙️ Logic */
fn solution(input: String) {
    let mut it = input.split_ascii_whitespace();
    // let n: usize = it.next().unwrap().parse().unwrap();
    // let a: Vec<<i64>> = (0..n).map(|_| it.next().unwrap().parse().unwrap()).collect();
    <>
}

/* 📤 Output */
fn print_result(out: &mut BufWriter<<std::io::StdoutLock>>) {
    // writeln!(out, "{}", ans).unwrap();
}

/* 🚀 Run Program */
fn main() {
    let input = get_input_data();
    let mut out = BufWriter::new(io::stdout().lock());
    
    solution(input);
    print_result(&mut out);
}
]],
  },
  h.file_header(),
}
