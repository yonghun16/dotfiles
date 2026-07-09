require "nvchad.mappings"

-- ================================================================
-- Environment
-- ================================================================
local map = vim.keymap.set
local api = require "nvim-tree.api"
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

-- ================================================================
-- Editor Mappings
-- ================================================================
-- Escape, Quit
map({ "n", "i", "v", "c" }, "<C-c>", "<ESC>")
map("t", "<ESC>", "<C-\\><C-n>")
map("n", "<leader>q", SafeQuitAll, { desc = "Safe Quit All", noremap = true, silent = true })

-- Change root directory
map("n", "<leader>.", function()
  local path = vim.fn.expand "%:p:h"
  api.tree.change_root(path)
  vim.notify("NvimTree root changed to: " .. path, vim.log.levels.INFO)
end, { desc = "change root to current file dir" })

-- Run Code (All, Single)
map("n", "<leader>;", Compile, { desc = "Run Code" })
map("n", "<leader>:", CompileSingle, { desc = "Run Single Code" })

-- Highlight Current Word
map("n", "<C-_>", "*N")

-- Reload File
map("n", "<leader>rf", ReloadAndLSPRestart, { desc = "Reload File and LSP" })

-- Line Diagnostics
map("n", "gl", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "See Diagnostics message" })

-- Signature
map("n", "gK", vim.lsp.buf.signature_help)

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
-- Cursor control
map({ "n", "v" }, "<C-h>", "^") --
map({ "n", "v" }, "<C-j>", "5j")
map({ "n", "v" }, "<C-k>", "5k")
map({ "n", "v" }, "<C-l>", "$")
map({ "n", "v" }, "<C-;>", "%")
map("n", "n", "<cmd>lua SmartNextJump()<CR>", { desc = "Smart Next (Search or Illuminate)" })
map("n", "N", "<cmd>lua SmartPrevJump()<CR>", { desc = "Smart Prev (Search or Illuminate)" })

-- Screen control
map({ "n", "v" }, "<C-n>", "5<C-e>")
map({ "n", "v" }, "<C-p>", "5<C-y>")
map({ "n", "v" }, "<C-.>", "6zl")
map({ "n", "v" }, "<C-,>", "6zh")

-- Visual Block control
map("v", "<S-k>", ":m '<-2<CR>gv=gv")
map("v", "<S-j>", ":m '>+1<CR>gv=gv")
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Tab control
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New Tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close Tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Only Tab" })
map("n", "<leader>tl", "<cmd>tabnext<CR>", { desc = "Next Tab" })
map("n", "<leader>th", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })
map("n", "<leader>tm", "<cmd>tabmove<CR>", { desc = "Move Tab" })

-- Splits control
map("t", "<C-w>h", "<C-\\><C-n><C-w>h")
map("t", "<C-w>j", "<C-\\><C-n><C-w>j")
map("t", "<C-w>k", "<C-\\><C-n><C-w>k")
map("t", "<C-w>l", "<C-\\><C-n><C-w>l")
