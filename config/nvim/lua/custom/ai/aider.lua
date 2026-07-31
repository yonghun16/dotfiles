local M = {}

local aider_sessions = {}
local aider_win = nil

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
      { "󰚩 Aider Root: ", "Identifier" },
      { root, "String" },
    }, true, {})

    return root
  end

  root = vim.fn.getcwd()

  vim.api.nvim_echo({
    { "󰚩 Aider Root: ", "Identifier" },
    { root, "String" },
    { " (cwd)", "Comment" },
  }, true, {})

  return root
end

-----------------------------------------------------------
-- Window
-----------------------------------------------------------

local function OpenAiderWin(buf)
  if aider_win and vim.api.nvim_win_is_valid(aider_win) then
    vim.api.nvim_win_hide(aider_win)
    aider_win = nil
    return false
  end

  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  vim.cmd "botright vsplit"

  aider_win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_buf(aider_win, buf)
  vim.api.nvim_win_set_width(aider_win, 60)

  vim.wo[aider_win].winfixwidth = true

  return true
end

-----------------------------------------------------------
-- Toggle Aider
-----------------------------------------------------------

function M.toggle()
  local cwd = GetProjectRoot()

  local buf = aider_sessions[cwd]

  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)

    aider_sessions[cwd] = buf

    if OpenAiderWin(buf) then
      vim.cmd("lcd " .. vim.fn.fnameescape(cwd))

      vim.fn.termopen {
        "aider",
        "--model",
        "ollama/qwen3-coder:30b",
      }

      vim.cmd "startinsert"
    end

    return
  end

  if OpenAiderWin(buf) then
    vim.cmd "startinsert"
  end
end

-----------------------------------------------------------
-- Cleanup
-----------------------------------------------------------

vim.api.nvim_create_autocmd("TermClose", {
  callback = function(args)
    for cwd, buf in pairs(aider_sessions) do
      if buf == args.buf then
        aider_sessions[cwd] = nil

        if aider_win and vim.api.nvim_win_is_valid(aider_win) then
          aider_win = nil
        end

        vim.fn.jobstart {
          "ollama",
          "stop",
          "qwen3-coder:30b",
        }

        break
      end
    end
  end,
})

return M
