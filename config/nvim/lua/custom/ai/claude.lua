local M = {}

local claude_sessions = {}
local claude_win = nil

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
      { "󰙅 Claude Root: ", "Identifier" },
      { root, "String" },
    }, true, {})

    return root
  end

  root = vim.fn.getcwd()

  vim.api.nvim_echo({
    { "󰙅 Claude Root: ", "Identifier" },
    { root, "String" },
    { " (cwd)", "Comment" },
  }, true, {})

  return root
end

-----------------------------------------------------------
-- Window
-----------------------------------------------------------

local function OpenClaudeWin(buf)
  if claude_win and vim.api.nvim_win_is_valid(claude_win) then
    vim.api.nvim_win_hide(claude_win)
    claude_win = nil
    return false
  end

  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  vim.cmd "botright vsplit"

  claude_win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_buf(claude_win, buf)
  vim.api.nvim_win_set_width(claude_win, 60)

  vim.wo[claude_win].winfixwidth = true

  return true
end

-----------------------------------------------------------
-- Toggle Claude
-----------------------------------------------------------

function M.toggle()
  local cwd = GetProjectRoot()

  local buf = claude_sessions[cwd]

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)

    claude_sessions[cwd] = buf

    if OpenClaudeWin(buf) then
      vim.cmd("lcd " .. vim.fn.fnameescape(cwd))

      vim.fn.termopen {
        "claude",
        "--continue",
      }

      vim.cmd "startinsert"
    end

    return
  end

  if OpenClaudeWin(buf) then
    vim.cmd "startinsert"
  end
end

-----------------------------------------------------------
-- New Session
-----------------------------------------------------------

function M.new()
  local cwd = GetProjectRoot()

  if claude_win and vim.api.nvim_win_is_valid(claude_win) then
    pcall(vim.api.nvim_win_close, claude_win, true)
    claude_win = nil
  end

  if claude_sessions[cwd] and vim.api.nvim_buf_is_valid(claude_sessions[cwd]) then
    pcall(vim.api.nvim_buf_delete, claude_sessions[cwd], {
      force = true,
    })
  end

  local buf = vim.api.nvim_create_buf(false, true)

  claude_sessions[cwd] = buf

  if OpenClaudeWin(buf) then
    vim.cmd("lcd " .. vim.fn.fnameescape(cwd))

    vim.fn.termopen {
      "claude",
    }

    vim.cmd "startinsert"
  end
end

-----------------------------------------------------------
-- Cleanup
-----------------------------------------------------------

vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    for cwd, buf in pairs(claude_sessions) do
      if buf == args.buf then
        claude_sessions[cwd] = nil

        if claude_win and vim.api.nvim_win_is_valid(claude_win) then
          claude_win = nil
        end

        break
      end
    end
  end,
})

return M
