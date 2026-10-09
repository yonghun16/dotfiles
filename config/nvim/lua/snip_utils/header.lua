local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

local PLATFORMS = { "BOJ", "Programmers", "JOL" }
local LINK_PREFIX = {
  BOJ = "https://www.acmicpc.net/problem/",
  Programmers = "https://school.programmers.co.kr/learn/courses/30/lessons/",
  JOL = "https://jungol.co.kr/problem/",
}

local DASH = string.rep("-", 60)
local DATE_FORMAT = "%Y-%m-%d"

-- 주석 스타일: 새 언어 계열이 필요하면 여기에 추가
local STYLES = {
  c = { -- C, C++, Rust, Java, JS, Go ...
    open = "/* " .. DASH,
    prefix = " * ",
    rule = " * " .. DASH,
    close = " */",
  },
  hash = { -- Python, Ruby, Shell ...
    open = "# " .. DASH,
    prefix = "# ",
    rule = "# " .. DASH,
    close = nil,
  },
}

-- 본문 줄 목록을 스타일에 맞춰 주석 블록으로 감싸기
-- "---" 줄은 구분선으로 치환
local function build_comment(style_name, lines)
  local st = STYLES[style_name or "c"]
  assert(st, "unknown comment style: " .. tostring(style_name))

  local out = { st.open }
  for _, line in ipairs(lines) do
    if line == "---" then
      table.insert(out, st.rule)
    else
      table.insert(out, st.prefix .. line)
    end
  end
  table.insert(out, st.rule)
  if st.close then
    table.insert(out, st.close)
  end
  return table.concat(out, "\n") .. "\n"
end

-- 스니펫을 펼치는 시점의 오늘 날짜
local function date_node()
  return f(function()
    return os.date(DATE_FORMAT)
  end, {})
end

local function platform_choice(pos)
  local choices = {}
  for _, p in ipairs(PLATFORMS) do
    table.insert(choices, i(nil, p))
  end
  return c(pos, choices)
end

local function link_node(pos, platform_pos)
  return d(pos, function(args)
    local prefix = LINK_PREFIX[args[1][1] or ""] or ""
    return sn(nil, i(1, prefix))
  end, { platform_pos })
end

--- opts.tag     : Tag에 들어갈 언어 이름
--- opts.body    : 본문 템플릿 (Logic 위치에 <> 1개, 실제 < >는 << >>)
--- opts.comment : "c"(기본) | "hash"
--- opts.trig    : 트리거 (기본 "headerComment OJ")
function M.oj_header(opts)
  local header = build_comment(opts.comment, {
    "Sub    : [<>] <>",
    "Date   : <>",
    "Link   : <>",
    "Level  :",
    "Tag    : " .. opts.tag .. ",",
    "---",
    "Approach",
    "<>",
  })

  return s(
    opts.trig or "headerComment OJ",
    fmt(header .. opts.body, {
      platform_choice(1),
      i(2, "문제 제목"),
      date_node(),
      link_node(3, 1),
      i(4, "풀이 접근 방법"),
      i(0),
    }, { delimiters = "<>" })
  )
end

--- opts.comment : "c"(기본) | "hash"
--- opts.trig    : 트리거 (기본 "headerComment")
--- opts.owner   : Owner 기본값 (기본 "")
function M.file_header(opts)
  opts = opts or {}
  local header = build_comment(opts.comment, {
    "File     : <>",
    "Date     : <>",
    "Owner    : <>",
    "Brief    : <>",
    "---",
    "Abstract",
    "<>",
  })

  return s(
    opts.trig or "headerComment",
    fmt(header .. "\n", {
      f(function()
        return vim.fn.expand "%:t"
      end, {}),
      date_node(),
      i(1, opts.owner or ""),
      i(2, "간단 설명 입력"),
      i(0),
    }, { delimiters = "<>" })
  )
end

return M
