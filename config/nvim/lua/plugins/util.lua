local plugins = {
  -- ================================================================
  -- Util
  -- ================================================================
  -- toggleterm.nvim (터미널)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup {
        shade_terminals = true,
        start_in_insert = true,
        direction = "float",
      }
    end,
  },

  -- which-key.nvim (키맵 도움말)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      triggers = { { "<leader>", mode = { "n", "v" } } },
    },
    keys = {
      {
        "<leader>",
        function() end,
      },
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}

return plugins
