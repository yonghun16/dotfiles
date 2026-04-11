require "nvchad.options"

-- ================================================================
-- Plugin options
-- ================================================================
-- fzf
vim.cmd "set rtp+=/opt/homebrew/opt/fzf"

-- Windsurf(Codeium)
function ToggleAIAutoComplete()
  if vim.g.codeium_enabled == nil or vim.g.codeium_enabled == false then
    vim.g.codeium_enabled = true
    vim.cmd "CodeiumEnable"
    print "Codeium enabled"
  else
    vim.g.codeium_enabled = false
    vim.cmd "CodeiumDisable"
    print "Codeium disabled"
  end
end

-- indent-blankline
require("ibl").update {
  vim.api.nvim_set_hl(0, "IndentBlanklineChar", { underline = true }), -- function definitions (height -> underline)
}

-- nvim-Tree
require("nvim-tree").setup {
  hijack_cursor = true,

  on_attach = function(bufnr)
    local api = require "nvim-tree.api"

    api.config.mappings.default_on_attach(bufnr) -- 기본 키맵 적용

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.del("n", "<C-k>", { buffer = bufnr }) -- Ctrl+k 제거
    vim.keymap.set("n", "K", api.node.show_info_popup, opts "Show Info") -- Shift+k 로 파일 정보 보기
    vim.keymap.set("n", "i", api.node.open.vertical, opts "Open: Vertical Split") -- 수직분할로 열기
    vim.keymap.set("n", "s", api.node.open.horizontal, opts "Open: Horizontal Split") -- 수평분할로 열기
    vim.keymap.set("n", "t", api.node.open.tab, opts "Open: New Tab") -- 새 탭으로 열기
  end,
}

-- visual-multi
vim.cmd [[ let g:VM_maps = {} ]]
vim.cmd [[ let g:VM_maps["Find Under"] = 's/' ]]
vim.cmd [[ let g:VM_maps["Find Subword Under"] = 's/' ]]
vim.cmd [[ let g:VM_maps["Add Cursor Down"] = 'sj' ]] -- 현재 커서 위치에서 아래 방향(j)으로 새로운 커서를 추가합니다.
vim.cmd [[ let g:VM_maps["Add Cursor Up"] = 'sk' ]]
vim.cmd [[ let g:VM_maps["Move Right"] = 'sl' ]]
vim.cmd [[ let g:VM_maps["Move Left"] = 'sh' ]]
vim.cmd [[ let g:VM_maps["Mouse Cursor"] = 's<LeftMouse>' ]]
vim.cmd [[ let g:VM_maps["Add Cursor At Pos"] = 's<CR>' ]] -- 현재 커서가 있는 위치에 멀티 커서를 확정적으로 추가(Enter)합니다.
vim.cmd [[ let g:VM_maps["Select Operator"] = 'ss' ]]

-- illuminate
function SmartNextJump()
  if vim.v.hlsearch == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("n", true, false, true), "n", false)
  else
    local status, illuminate = pcall(require, "illuminate")
    if status then
      illuminate.goto_next_reference(false)
    end
  end
end

function SmartPrevJump()
  if vim.v.hlsearch == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("N", true, false, true), "n", false)
  else
    local status, illuminate = pcall(require, "illuminate")
    if status then
      illuminate.goto_prev_reference(false)
    end
  end
end

-- ================================================================
-- Gemini CLI Session Management
-- ================================================================
local gemini_sessions = {}
local gemini_win = nil

-- 프로젝트의 루트 디렉토리를 찾는 함수
local function GetProjectRoot()
  local markers = { ".git", "package.json", "go.mod", "Cargo.toml", "Makefile" }

  -- 현재 버퍼(0)를 기준으로 상위 마커 탐색
  local root = vim.fs.root(0, markers)

  if root then
    -- 루트를 찾았을 때 에코 출력 (초록색 메시지)
    vim.api.nvim_echo({ { "󰙅 Gemini Root: ", "Identifier" }, { root, "String" } }, true, {})
    return root
  end

  -- 못 찾았을 때 (노란색 메시지)
  local cwd = vim.fn.getcwd()
  vim.api.nvim_echo({ { "󰝰 Gemini Root (CWD): ", "DiagnosticWarn" }, { cwd, "String" } }, true, {})

  return cwd
end

-- [Internal] Gemini 전용 윈도우 생성 및 설정
local function OpenGeminiWin(buf)
  -- 이미 유효한 창이 열려 있다면 닫기 (Toggle)
  if gemini_win and vim.api.nvim_win_is_valid(gemini_win) then
    vim.api.nvim_win_hide(gemini_win)
    gemini_win = nil
    return false
  end

  vim.cmd "botright vsplit"
  gemini_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(gemini_win, buf)
  vim.api.nvim_win_set_width(gemini_win, 60)
  vim.wo[gemini_win].winfixwidth = true

  return true
end

-- 1. Toggle & Resume Latest (기존 기능 확장)
function ToggleGeminiCli()
  local cwd = GetProjectRoot()
  local buf = gemini_sessions[cwd]

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
    gemini_sessions[cwd] = buf
    if OpenGeminiWin(buf) then
      vim.cmd("lcd " .. cwd)
      vim.fn.termopen "gemini --resume latest"
      vim.cmd "startinsert"
    end
  else
    if OpenGeminiWin(buf) then
      vim.cmd "startinsert"
    end
  end
end

-- 2. Start New Session (새 대화 시작)
function NewGeminiSession()
  local cwd = GetProjectRoot()

  -- 기존 프로젝트 버퍼가 있다면 강제 삭제
  if gemini_sessions[cwd] and vim.api.nvim_buf_is_valid(gemini_sessions[cwd]) then
    vim.api.nvim_buf_delete(gemini_sessions[cwd], { force = true })
  end

  local buf = vim.api.nvim_create_buf(false, true)
  gemini_sessions[cwd] = buf

  if OpenGeminiWin(buf) then
    vim.fn.termopen "gemini" -- 옵션 없이 실행하여 새 세션 생성
    vim.cmd("lcd " .. cwd)
    vim.cmd "startinsert"
    print "Gemini: 새로운 세션을 시작합니다."
  end
end

-- 3. Select Session (과거 세션 목록 선택)
function SelectGeminiSession()
  local handle = io.popen "gemini --list-sessions 2>/dev/null"
  if not handle then
    print "Gemini: 명령어를 실행할 수 없습니다."
    return
  end

  local result = handle:read "*a"
  handle:close()

  if result == "" or result:find "No sessions found" then
    print "Gemini: 저장된 세션이 없습니다."
    return
  end

  local sessions = {}
  for line in result:gmatch "[^\r\n]+" do
    -- 숫자로 시작하는 실제 세션 라인만 골라냄 (예: "  1. ?")
    if line:match "%d+%." then
      -- gsub의 결과 중 첫 번째(치환된 문자열)만 명시적으로 가져옴
      local cleaned_line = line:gsub("^%s+", "")
      table.insert(sessions, cleaned_line)
    end
  end

  if #sessions == 0 then
    print "Gemini: 유효한 세션 목록이 없습니다."
    return
  end

  vim.ui.select(sessions, {
    prompt = "재개할 세션을 선택하세요:",
  }, function(choice)
    if choice then
      -- 선택한 문장에서 숫자만 추출
      local index = choice:match "(%d+)%."

      if index then
        local cwd = GetProjectRoot()
        if gemini_sessions[cwd] and vim.api.nvim_buf_is_valid(gemini_sessions[cwd]) then
          vim.api.nvim_buf_delete(gemini_sessions[cwd], { force = true })
        end

        local buf = vim.api.nvim_create_buf(false, true)
        gemini_sessions[cwd] = buf

        if OpenGeminiWin(buf) then
          vim.cmd("lcd " .. cwd)
          vim.fn.termopen("gemini --resume " .. index)
          vim.cmd "startinsert"
        end
      else
        print "Gemini: 세션 번호를 파싱할 수 없습니다."
      end
    end
  end)
end
