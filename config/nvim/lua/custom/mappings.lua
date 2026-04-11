require "nvchad.mappings"

-- ================================================================
-- Environment
-- ================================================================
local map = vim.keymap.set
local api = require "nvim-tree.api"
local dap = require "dap"
local dapui = require "dapui"
local del = vim.api.nvim_del_keymap

-- ================================================================
-- Remove NvChad Default Keymaps
-- ================================================================
del("n", "<A-i>")
del("n", "<A-h>")
del("n", "<A-v>")
del("t", "<A-i>")
del("t", "<A-h>")
del("t", "<A-v>")
del("n", "<leader>e") -- nvimtree focus window
del("n", "<leader>n") -- toogle number line
del("n", "<leader>v") -- terminal new vertical term

-- ================================================================
-- Escape, Save & Quit
-- ================================================================
map({ "n", "i", "v", "c" }, "<C-c>", "<ESC>")
map("t", "<ESC>", "<C-\\><C-n>")
map("n", "<leader>q", SafeQuitAll, { desc = "Safe Quit All", noremap = true, silent = true })
map("n", "<leader>X", "<cmd>confirm bd | close<CR>", { desc = "Close Buffer & Split", noremap = true, silent = true })

-- ================================================================
-- Editor Mappings
-- ================================================================
-- Create Code Annotation (Neogen)
map("n", "<leader>ca", ":Neogen<CR>", { desc = "Create code Annotation", silent = true })

-- Change root directory
map("n", "<leader>.", function()
  local path = vim.fn.expand "%:p:h"
  api.tree.change_root(path)
  vim.notify("NvimTree root changed to: " .. path, vim.log.levels.INFO)
end, { desc = "change root to current file dir" })

-- Diffsplit Vertical
map("n", "<leader>dv", ":vert diffsplit ", { desc = "Diffsplit (compare files)" })

-- Highlight Current Word
map("n", "<C-_>", "*N")

-- Mapping Overview (which-key)
map("n", "<leader>m", function()
  vim.cmd "WhichKey <leader>"
end, { desc = "mapping overview (which-key)" })

-- Reload File
map("n", "<leader>rf", ReloadAndLSPRestart, { desc = "Reload File and LSP" })

-- Run Code (All, Single)
map("n", "<leader>a", Compile, { desc = "Run Code" })
map("n", "<leader>rs", CompileSingle, { desc = "Run Single Code" })

-- Show Diagnostics message
map("n", "sd", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "See Diagnostics message" })

-- Show Signature help
map("n", "ss", vim.lsp.buf.signature_help)

-- Toggle FoldColumn
map("n", "<leader>tf", ToggleFoldColumn, { desc = "toggle FoldColumn" })

-- Toggle Transparency
map(
  "n",
  "<leader>tt",
  ":lua require('base46').toggle_transparency()<CR>",
  { noremap = true, silent = true, desc = "toggle Transparency" }
)

-- ================================================================
-- Apply Terminal Keybindings in INSERT Mode
-- ================================================================
map("i", "<C-h>", "<BS>")
map("i", "<C-f>", "<Right>")
map("i", "<C-b>", "<Left>")
map("i", "<C-a>", "<C-\\><C-o>^")
map("i", "<C-e>", "<C-\\><C-o>$")
map("i", "<C-d>", "<Del>")
map("i", "<C-u>", "<C-\\><C-o>d^")
map("i", "<C-w>", "<C-\\><C-o>dB")
map("i", "<C-k>", "<C-\\><C-o>d$")
map("i", "<C-CR>", "<Esc>o")
map("i", "<C-j>", "<CR>")
map("i", "<C-s>", "<Esc><C-s>")

-- ================================================================
-- Moving (Cursor, Screen, Block, Tab, Splits)
-- ================================================================
-- Cursor move, jump
map({ "n", "v" }, "<C-h>", "^")
map({ "n", "v" }, "<C-j>", "5j")
map({ "n", "v" }, "<C-k>", "5k")
map({ "n", "v" }, "<C-l>", "$")
map({ "n", "v" }, "<C-;>", "%")
map("n", "n", "<cmd>lua SmartNextJump()<CR>", { desc = "Smart Next (Search or Illuminate)" })
map("n", "N", "<cmd>lua SmartPrevJump()<CR>", { desc = "Smart Prev (Search or Illuminate)" })

-- Screen move
map({ "n", "v" }, "<C-n>", "5<C-e>")
map({ "n", "v" }, "<C-p>", "5<C-y>")
map({ "n", "v" }, "<C-.>", "6zl")
map({ "n", "v" }, "<C-,>", "6zh")

-- Visual Block move
map("v", "<S-k>", ":m '<-2<CR>gv=gv")
map("v", "<S-j>", ":m '>+1<CR>gv=gv")
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Tab move
map("n", "te", function() -- new tab
  vim.cmd "tabedit"
end)
map("n", "tt", function() -- new tab to terminal
  vim.cmd "tabedit"
  vim.cmd "terminal"
  vim.api.nvim_feedkeys("i", "n", false)
end)
map("n", "tx", function() -- tab close
  vim.cmd "tabclose"
end)
map("n", "tn", function() -- tab next
  vim.cmd "tabnext"
end)
map("n", "tp", function() -- tab previous
  vim.cmd "tabprevious"
end)

-- Splits move
map("t", "<C-w>h", "<C-\\><C-n><C-w>h")
map("t", "<C-w>j", "<C-\\><C-n><C-w>j")
map("t", "<C-w>k", "<C-\\><C-n><C-w>k")
map("t", "<C-w>l", "<C-\\><C-n><C-w>l")

-- ================================================================
-- Sidebars (h, j, k, l)
-- ================================================================
-- h : Nvimtree (left side)
map("n", "<leader>h", function()
  vim.cmd "NvimTreeToggle"
end, { desc = "toggle Explorer (NvimTree)" })

-- H : Nvimtree current path (left side)
map("n", "<leader>H", function()
  api.tree.find_file { open = true, focus = true }
end, { desc = "find current path (NvimTree)" })

-- j : Terminal (bottom side)
map({ "n", "t" }, "<leader>j", function()
  vim.cmd "ToggleTerm size=10 direction=horizontal"
end, { desc = "Terminal (bottom)" })

-- k : Outline (left side)
map("n", "<leader>k", function()
  vim.cmd "Outline"
end, { desc = "toggle Outline" })

-- l : Gemini (right side)
map("n", "<leader>l", "<cmd>lua ToggleGeminiCli()<CR>", { desc = "toggle Gemini CLI" })
map("n", "<leader>gn", "<cmd>lua NewGeminiSession()<CR>", { desc = "new Gemini CLI session" })
map("n", "<leader>gs", "<cmd>lua SelectGeminiSession()<CR>", { desc = "select Gemini CLI session" })

-- Floating Terminal
map({ "n", "t" }, "<leader><leader>", function()
  vim.cmd "ToggleTerm direction=float"
end, { desc = "Terminal (floating)" })

-- ================================================================
-- Finder (fzf-lua)
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
-- AI Auto Completion (Codeium)
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
-- Debugging (nvim-dap)
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
