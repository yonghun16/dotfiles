package.loaded["custom.snip_utils.header"] = nil -- 공통 모듈 수정 시 즉시 반영 (선택)
local h = require "custom.snip_utils.header"

return {
  h.oj_header {
    tag = "JavaScript",
    body = [[

const fs = require("fs");

const filePath = fs.existsSync("./input_test.txt")
  ? "./input_test.txt"
  : 0;

const input = fs.readFileSync(filePath, "utf-8").trim().split(/\n+/);

/* 📥 Input */
const getInputData = () =>> {
  let idx = 0;
};

/* ⚙️ Logic */
const solution = () =>> {
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
