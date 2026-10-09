require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- 상대번호 활성화 여부
local function update_relativenumber()
  local bt = vim.bo.buftype
  local modifiable = vim.bo.modifiable

  -- 일반 파일이 아니면 끔
  if bt ~= "" or not modifiable then
    vim.wo.relativenumber = false
  else
    vim.wo.relativenumber = true
  end
end

-- CursorLine: 포커스 창에서만 활성화
autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.o.cursorlineopt = "both"
    vim.o.cursorline = true
    update_relativenumber()
  end,
})

autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.o.cursorlineopt = "both"
    vim.o.cursorline = false
    vim.wo.relativenumber = false
  end,
})

-- Neovim이 비활성화되면 상대번호 끄기
autocmd("FocusLost", {
  callback = function()
    vim.wo.relativenumber = false
  end,
})

-- Neovim으로 다시 돌아오면 조건에 따라 상대번호 켜기
autocmd("FocusGained", {
  callback = function()
    update_relativenumber()
  end,
})
