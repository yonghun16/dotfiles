-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "solarized_osaka",
  transparency = true,

  hl_override = {
    CursorLine = { bg = "#002534" },
    StatusLine = { bg = "#00212e" },
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    NormalFloat = { bg = "#001a24" },

    -- NvimTree fixes
    NvimTreeCursorLine = { bg = "#002330" },
    NvimTreeCursorColumn = { bg = "#002330" },
  },
}

M.nvdash = { load_on_startup = true }
M.ui = {
  tabufline = {
    lazyload = false,
  },
}

return M
