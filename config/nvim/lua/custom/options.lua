require "nvchad.options"

-- ================================================================
-- Basic options
-- ================================================================
-- tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "html",
    "css",
    "lua",
    "dart",
    "R",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- number line
vim.opt.relativenumber = true
vim.opt.numberwidth = 4

-- scroll
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

-- folding
vim.opt.foldenable = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

-- etc
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 200
vim.opt.wrap = false

-- ================================================================
-- Plugin options
-- ================================================================
-- fzf
vim.cmd "set rtp+=/opt/homebrew/opt/fzf"

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
    vim.keymap.set("n", "i", api.node.open.vertical, opts "Open: Vertical Split")
    vim.keymap.set("n", "s", api.node.open.horizontal, opts "Open: Horizontal Split")
    vim.keymap.set("n", "t", api.node.open.tab, opts "Open: New Tab")
  end,
}

-- visual-multi
vim.cmd [[ let g:VM_maps = {} ]]
vim.cmd [[ let g:VM_maps["Find Under"] = 's/' ]]
vim.cmd [[ let g:VM_maps["Find Subword Under"] = 's/' ]]
vim.cmd [[ let g:VM_maps["Add Cursor Down"] = 'sj' ]]
vim.cmd [[ let g:VM_maps["Add Cursor Up"] = 'sk' ]]
vim.cmd [[ let g:VM_maps["Move Right"] = 'sl' ]]
vim.cmd [[ let g:VM_maps["Move Left"] = 'sh' ]]
vim.cmd [[ let g:VM_maps["Mouse Cursor"] = 's<LeftMouse>' ]]
vim.cmd [[ let g:VM_maps["Add Cursor At Pos"] = 's<CR>' ]]
vim.cmd [[ let g:VM_maps["Select Operator"] = 'ss' ]]

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

------------------------------------------------------------------
-- Functions
-- ================================================================
-- Safe Quit
function SafeQuitAll()
  -- 저장되지 않은 버퍼가 있는지 확인
  local modified_bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].modified then
      table.insert(modified_bufs, buf)
    end
  end

  if #modified_bufs > 0 then
    local choice = vim.fn.confirm("There are unsaved changes. Save before quitting?", "&Yes\n&No\n&Cancel", 3)
    if choice == 1 then
      vim.cmd "wa" -- 모든 버퍼 저장
      vim.cmd "qa" -- 종료
    elseif choice == 2 then
      vim.cmd "qa!" -- 저장하지 않고 종료
    else
      return -- Cancel: 종료 안 함
    end
  else
    vim.cmd "qa" -- 변경사항 없으면 그냥 종료
  end
end

-- Compile and Run
function Compile()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand "%:t:r" -- 파일 이름 (확장자 제외)
  local project_dir = vim.fn.expand "%:p:h" -- 현재 파일이 속한 디렉토리
  local filepath = vim.fn.expand "%:p" -- 전체 경로
  local bin_dir = os.getenv "HOME" .. "/bin"
  vim.fn.mkdir(bin_dir, "p") -- ~/bin 디렉토리 없으면 생성
  local binpath = bin_dir .. "/" .. filename

  vim.cmd "w" -- 항상 저장

  if filetype == "python" then
    -- 1. 현재 작업 경로(Root)나 파일 경로 주변에서 venv/bin/python을 찾음
    local cwd = vim.fn.getcwd()
    local venv_python = cwd .. "/venv/bin/python"
    local dot_venv_python = cwd .. "/.venv/bin/python"
    -- 기본 실행 명령어 (venv가 없으면 그냥 python3)
    local python_cmd = "python3"
    -- 2. venv가 실제로 존재하는지 확인 후 교체
    if vim.fn.filereadable(venv_python) == 1 then
      python_cmd = venv_python
    elseif vim.fn.filereadable(dot_venv_python) == 1 then
      python_cmd = dot_venv_python
    end
    -- 3. 찾은 파이썬 경로로 실행
    vim.cmd(string.format('TermExec cmd="%s %s"', python_cmd, filepath))
  elseif filetype == "javascript" then
    vim.cmd(string.format('TermExec cmd="node %s"', filepath))
  elseif filetype == "typescript" then
    local tsconfig_exists = vim.fn.filereadable "tsconfig.json" == 1
    if not tsconfig_exists then
      local tsconfig_content = {
        "{",
        '  "compilerOptions": {',
        '    "target": "ES2020",',
        '    "module": "ESNext",',
        '    "moduleResolution": "node",',
        '    "lib": ["ESNext", "Dom"],',
        '    "strict": true,',
        '    "skipLibCheck": true,',
        '    "esModuleInterop": true,',
        '    "forceConsistentCasingInFileNames": true',
        "  },",
        '  "include": ["src/**/*"],',
        '  "exclude": ["node_modules"]',
        "}",
      }
      vim.fn.writefile(tsconfig_content, "tsconfig.json")
    end
    -- ts-node로 직접 실행
    vim.cmd(string.format('TermExec cmd="ts-node %s"', filepath))
    -- 만약 ~/bin에 JS 파일로 컴파일 후 실행하고 싶으면 아래 주석 해제
    -- vim.cmd(string.format(":!tsc %s --outDir %s", filepath, bin_dir))
    -- vim.cmd(string.format('TermExec cmd="node %s/%s.js"', bin_dir, filename))
  elseif filetype == "c" then
    vim.cmd(string.format(":!gcc -o %s %s/*.c", binpath, project_dir))
    vim.cmd(string.format('TermExec cmd="%s"', binpath))
  elseif filetype == "cpp" then
    vim.cmd(string.format(":!g++ -o %s %s/*.cpp", binpath, project_dir))
    vim.cmd(string.format('TermExec cmd="%s"', binpath))
  elseif filetype == "java" then
    vim.cmd(string.format(":!javac -encoding utf-8 -d %s %s", bin_dir, filepath))
    vim.cmd(string.format('TermExec cmd="java -cp %s %s"', bin_dir, filename))
  else
    vim.cmd ':echo "This file is not a supported source file."'
  end
end

-- Compile and Run (single file)
function CompileSingle()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand "%:t:r" -- 파일 이름 (확장자 제외)
  local filepath = vim.fn.expand "%:p" -- 전체 경로
  local bin_dir = os.getenv "HOME" .. "/bin"
  vim.fn.mkdir(bin_dir, "p") -- ~/bin 없으면 생성
  local binpath = bin_dir .. "/" .. filename

  vim.cmd "w" -- 항상 저장

  if filetype == "c" then
    -- 현재 파일만 컴파일
    vim.cmd(string.format(":!gcc -o %s %s", binpath, filepath))
    vim.cmd(string.format('TermExec cmd="%s"', binpath))
  elseif filetype == "cpp" then
    vim.cmd(string.format(":!g++ -o %s %s", binpath, filepath))
    vim.cmd(string.format('TermExec cmd="%s"', binpath))
  else
    vim.cmd ':echo "This file is not supported for single file compile."'
  end
end

-- Reload (and LSP Restart)
function ReloadAndLSPRestart()
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
    client:stop(true)
  end
  vim.defer_fn(function()
    vim.cmd "edit" -- 버퍼를 다시 로드하여 LSP 자동 attach 유도
  end, 100)
end

-- Toggle Windsurf(Codeium)
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

-- Toggle Foldcolumn
local MIN_FOLDCOL = 0
local MAX_FOLDCOL = 6
local foldcolumn_visible = false

local function get_max_fold_level()
  local max_level = 0
  for lnum = 1, vim.fn.line "$" do
    local level = vim.fn.foldlevel(lnum)
    if level > max_level then
      max_level = level
    end
  end
  return math.min(max_level, MAX_FOLDCOL)
end

function ToggleFoldColumn()
  if not foldcolumn_visible then
    vim.wo.foldcolumn = tostring(math.max(get_max_fold_level(), 1))
    vim.wo.relativenumber = false
    foldcolumn_visible = true
  else
    vim.wo.foldcolumn = tostring(MIN_FOLDCOL)
    vim.wo.relativenumber = true
    foldcolumn_visible = false
  end
end
