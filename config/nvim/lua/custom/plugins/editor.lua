local plugins = {
  -- ================================================================
  -- Editor
  -- ================================================================
  -- fzf-lua (빠른 탐색기)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.nvim" },
    cmd = "FzfLua",
    config = function()
      local actions = require "fzf-lua.actions"
      require("fzf-lua").setup {
        keymap = {
          builtin = {
            ["<C-u>"] = "preview-page-up",
            ["<C-d>"] = "preview-page-down",
          },
        },
        buffers = {
          sort_lastused = true,
          include_current = true,
          actions = {
            ["ctrl-D"] = { fn = actions.buf_del, reload = true },
          },
        },
      }
    end,
  },

  -- nvim-lastplace (커서 마지막 위치 저장)
  {
    "ethanholz/nvim-lastplace",
    event = "BufReadPost",
    config = function()
      require("nvim-lastplace").setup {}
    end,
  },

  -- vim-illuminate (단어 하이라이트)
  {
  "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "regex",
        },
      })
    end,
  },

  -- vim-visual-multi (멀티 커서)
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
  },
}

return plugins
