package.loaded["snip_utils.header"] = nil -- 공통 모듈 수정 시 즉시 반영 (선택)
local h = require "snip_utils.header"

return {
  h.oj_header {
    tag = "TypeScript",
    body = [[

declare var require: any;
const fs: any = require("fs");

const filePath: string = fs.existsSync("./input_test.txt")
  ? "./input_test.txt"
  : "/dev/stdin";

const input: string[] = fs.readFileSync(filePath, "utf-8").trim().split(/\n+/);

/* 📥 Input */
const getInputData = () =>> {
  let idx: number = 0;
  return {};
};

/* ⚙️ Logic */
const solution = (data: ReturnType<<typeof getInputData>>) =>> {
  <>
};

/* 🚀 Run Program */
(() =>> {
  solution(getInputData());
})();
]],
  },
  h.file_header(),
}
