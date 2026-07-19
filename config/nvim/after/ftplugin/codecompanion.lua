-- CodeCompanion 전용 설정

-- 번호 표시 제거
vim.opt_local.number = false
vim.opt_local.relativenumber = false

-- 다음 Chat
vim.keymap.set("n", "<Tab>", "}", {
  buffer = true,
  silent = true,
  remap = true,
  desc = "Next CodeCompanion Chat",
})

-- 이전 Chat
vim.keymap.set("n", "<S-Tab>", "{", {
  buffer = true,
  silent = true,
  remap = true,
  desc = "Previous CodeCompanion Chat",
})

-- 새 Chat
vim.keymap.set("n", "gn", "<cmd>CodeCompanionChat<CR>", {
  buffer = true,
  silent = true,
  desc = "New CodeCompanion Chat",
})
