require "nvchad.mappings"

-- ================================================================
-- Environment
-- ================================================================
local map = vim.keymap.set
local api = require "nvim-tree.api"
local dap = require "dap"
local dapui = require "dapui"
local gemini = require "custom.gemini"

-- ================================================================
-- Sidebars & Editors
-- ================================================================
-- Nvimtree (left side)
map("n", "<leader>h", function()
  vim.cmd "OutlineClose"
  vim.cmd "NvimTreeToggle"
end, { desc = "toggle Explorer (NvimTree)" })

-- Nvimtree current path (left side)
map("n", "<leader>H", function()
  vim.cmd "OutlineClose"
  api.tree.find_file { open = true, focus = true }
end, { desc = "find current path (NvimTree)" })

-- Outline (left side)
map("n", "<leader>k", function()
  vim.cmd "NvimTreeClose"
  vim.cmd "Outline"
end, { desc = "toggle Outline" })

-- CodeDiff (left side)
map("n", "<leader>K", function()
  vim.cmd "CodeDiff"
end, { desc = "toggle CodeDiff" })

-- Terminal (bottom side)
map({ "n", "t" }, "<leader>j", function()
  vim.cmd "ToggleTerm size=10 direction=horizontal"
end, { desc = "Terminal (bottom)" })

-- AI Chat (right side)
map("n", "<leader>l", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "toggle CodeCompanionChat" })
map("v", "<leader>l", "<cmd>CodeCompanionChat Add<CR>", { desc = "CodeCompanion Inline" })
map("n", "<leader>L", function()
  gemini.toggle()
end, { desc = "toggle Gemini CLI" })

-- Terminal (floating)
map({ "n", "t" }, "<leader><leader>", function()
  vim.cmd "ToggleTerm direction=float"
end, { desc = "Terminal (floating)" })

-- NvDash
map("n", "<leader><ESC>", function()
  vim.cmd "Nvdash"
end, { desc = "toggle Nvdash" })

-- Neogen (Create Code Annotation)
map("n", "<leader>ca", ":Neogen<CR>", { desc = "Create code Annotation", silent = true })

-- which-key (Mapping Overview)
map("n", "<leader>m", function()
  vim.cmd "WhichKey <leader>"
end, { desc = "mapping overview (which-key)" })

-- ================================================================
-- fzf-lua (Finder)
-- ================================================================
-- Find Files
map("n", "<leader>ff", function()
  require("fzf-lua").files()
end, { desc = "fzf Find Files" })

-- Find Grep
map("n", "<leader>fg", function()
  require("fzf-lua").grep()
end, { desc = "fzf Find Grep" })

-- Find Current word
map("n", "<leader>fc", function()
  require("fzf-lua").grep_cword()
end, { desc = "fzf Find Current word" })

-- Find Buffers
map("n", "<leader><tab>", function()
  require("fzf-lua").buffers()
end, { desc = "buffer explorer (fzf)" })

-- Find Symbols
map("n", "<leader>fs", function()
  require("fzf-lua").lsp_live_workspace_symbols()
end, { desc = "fzf Find Symbols" })

-- Find Definition
map("n", "<leader>fd", function()
  require("fzf-lua").lsp_definitions()
end, { desc = "fzf Find Definition" })

-- ================================================================
-- Codeium (AI Auto Completion)
-- ================================================================
-- Toggle AI Auto Completion (AI 자동완성 켜기/끄기)
map("n", "<leader>ta", "<cmd>lua ToggleAIAutoComplete()<CR>", { desc = "toggle AI code completion" })

-- Navigate completion menu (자동완성 메뉴 이동)
vim.api.nvim_set_keymap("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { noremap = true, expr = true })

-- Accept Codeium suggestion (Codeium 제안 수락)
map("i", "<Tab>", "codeium#Accept()", { expr = true, silent = true, nowait = true, desc = "Accept Codeium suggestion" })

-- Accept next line (다음 줄만 수락)
map(
  "i",
  "<C-;>",
  "codeium#AcceptNextLine()",
  { expr = true, silent = true, nowait = true, desc = "Accept next line from Codeium" }
)

-- Accept next word (다음 단어만 수락)
map(
  "i",
  "<C-'>",
  "codeium#AcceptNextWord()",
  { expr = true, silent = true, nowait = true, desc = "Accept next word from Codeium" }
)

-- Cycle next suggestion (다음 제안 보기)
map("i", "<C-.>", function()
  vim.cmd "call codeium#CycleCompletions(1)"
end, { silent = true, desc = "Cycle Codeium completions forward" })

-- Cycle previous suggestion (이전 제안 보기)
map("i", "<C-,>", function() -- Cycle completions
  vim.cmd "call codeium#CycleCompletions(-1)"
end, { silent = true, desc = "Cycle Codeium completions backward" })

-- Clear suggestion (제안 지우기)
map("i", "<C-x>", function() -- Clear completions
  vim.cmd "call codeium#Clear()"
end, { silent = true, desc = "Clear Codeium suggestion" })

-- Restore Jump Forward (점프 앞으로 가기 복구)
map("n", "<C-i>", "<C-i>", { noremap = true, silent = true })

-- ================================================================
-- nvim-dap (Debugger)
-- ================================================================
-- debug: toggle breakpoint (중단점 설정/해제)
map("n", "<leader>z", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

-- debug: start or continue debugging (디버깅 시작 또는 계속 진행)
map("n", "<leader><SPACE>", dap.continue, { desc = "Debug: Continue" })

-- Debug: conditional Breakpoint (조건부 중단점 설정 - 조건이 참일 때만 멈춤)
map("n", "<leader>db", function()
  dap.toggle_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Debug: Toggle Conditional Breakpoint" })

-- Debug: step Over (한 줄 실행 - 함수 건너뛰기)
map("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })

-- Debug: step Into (함수 안으로 들어가기)
map("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })

-- Debug: step Out (현재 함수 빠져나가기)
map("n", "<leader>dk", dap.step_out, { desc = "Debug: Step Out" })

-- Debug: Quit (디버깅 세션 종료)
map("n", "<leader>dq", dap.terminate, { desc = "Debug: Quit" })

-- Debug: toggle Ui (디버깅 UI 창 열기/닫기)
map("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

-- ================================================================
-- codediff (코드 비교)
-- ================================================================
-- debug: toggle breakpoint (중단점 설정/해제)
-- g?  도움말
-- q   종료
-- gc  변경점만 보기 ↔ 전체 보기
-- t   좌우 보기 ↔ 인라인 보기
-- ]c  다음 변경
-- [c  이전 변경
-- e   Explorer로 포커스 이동

-- ================================================================
-- LSP
-- ================================================================
-- K   Hover
-- gK  Signature Help
-- gd  Definition
-- gD  Declaration
-- gi  Implementation
-- gr  References
-- gt  Type Definition
-- gl  Line Diagnostics
-- [d  이전 Diagnostic
-- ]d  다음 Diagnostic

-- ================================================================
-- Neogen
-- ================================================================
-- :Neogen func   함수(Function)용 주석 생성
-- :Neogen class  클래스(Class)용 주석 생성
-- :Neogen type   타입(Type)용 주석 생성
-- :Neogen file   파일(File)용 주석 생성

-- ================================================================
-- CodeCompanion
-- ================================================================
-- gh     CodeCompanionHistory
-- gn     new CodeCompanion Chat
-- <C-q>  CodeCompanion Chat Close
-- gd     CodeCompanion Debug
