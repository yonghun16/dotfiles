local plugins = {
  -- ================================================================
  -- UI
  -- ================================================================

  -- neoscroll.nvim (부드러운 스크롤)
  {
    "karb94/neoscroll.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
      hide_cursor = true,
      easing = "quadratic",
    },
  },

  -- render-markdown.nvim (Markdown 렌더링)
  {
    "MeanderingProgrammer/render-markdown.nvim",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },

    ft = {
      "markdown",
      "codecompanion",
    },

    opts = {
      file_types = {
        "markdown",
        "codecompanion",
      },

      heading = {
        enabled = true,
        sign = true,
      },

      code = {
        enabled = true,
        style = "full",
        border = "thin",
      },

      checkbox = {
        enabled = true,
      },

      bullet = {
        enabled = true,
      },
    },
  },
}

return plugins
