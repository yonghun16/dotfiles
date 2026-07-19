local M = {}

local gemini_sessions = {}
local gemini_win = nil

-----------------------------------------------------------
-- Project Root
-----------------------------------------------------------

local function GetProjectRoot()
  local markers = {
    ".git",
    "package.json",
    "go.mod",
    "Cargo.toml",
    "Makefile",
  }

  local root = vim.fs.root(0, markers)

  if root then
    vim.api.nvim_echo({
      { "󰙅 Gemini Root: ", "Identifier" },
      { root, "String" },
    }, true, {})
    return root
  end

  root = vim.fn.getcwd()

  vim.api.nvim_echo({
    { "󰙅 Gemini Root: ", "Identifier" },
    { root, "String" },
    { " (cwd)", "Comment" },
  }, true, {})

  return root
end

-----------------------------------------------------------
-- Window
-----------------------------------------------------------

local function OpenGeminiWin(buf)
  if gemini_win and vim.api.nvim_win_is_valid(gemini_win) then
    vim.api.nvim_win_hide(gemini_win)
    gemini_win = nil
    return false
  end

  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  vim.cmd "botright vsplit"

  gemini_win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_buf(gemini_win, buf)
  vim.api.nvim_win_set_width(gemini_win, 60)

  vim.wo[gemini_win].winfixwidth = true

  return true
end

-----------------------------------------------------------
-- Toggle Gemini
-----------------------------------------------------------

function M.toggle()
  local cwd = GetProjectRoot()
  local buf = gemini_sessions[cwd]

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
    gemini_sessions[cwd] = buf

    if OpenGeminiWin(buf) then
      vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
      vim.fn.termopen "gemini --resume latest"
      vim.cmd "startinsert"
    end

    return
  end

  if OpenGeminiWin(buf) then
    vim.cmd "startinsert"
  end
end

-----------------------------------------------------------
-- New Session
-----------------------------------------------------------

function M.new()
  local cwd = GetProjectRoot()

  if gemini_win and vim.api.nvim_win_is_valid(gemini_win) then
    pcall(vim.api.nvim_win_close, gemini_win, true)
    gemini_win = nil
  end

  if gemini_sessions[cwd] and vim.api.nvim_buf_is_valid(gemini_sessions[cwd]) then
    pcall(vim.api.nvim_buf_delete, gemini_sessions[cwd], {
      force = true,
    })
  end

  local buf = vim.api.nvim_create_buf(false, true)

  gemini_sessions[cwd] = buf

  if OpenGeminiWin(buf) then
    vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
    vim.fn.termopen "gemini"
    vim.cmd "startinsert"
  end
end

-----------------------------------------------------------
-- Cleanup
-----------------------------------------------------------

vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    for cwd, buf in pairs(gemini_sessions) do
      if buf == args.buf then
        gemini_sessions[cwd] = nil
        break
      end
    end
  end,
})

return M
