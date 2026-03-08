local plugins = {
  -- ================================================================
  -- LSP & Formatter & Lintter & Treesitter
  -- ================================================================
  -- mason.nvim (LSP)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "typescript-language-server",
        "tailwindcss-language-server",
        "html-lsp",
        "pug-lsp",
        "css-lsp",
        "clangd",
        "jdtls",
        "sqlls",
        "emmet-language-server",
      },
    },
  },

  -- conform.nvim (포맷팅)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          java = { "google-java-format" },
          html = { "prettier" },
          css = { "prettier" },
          sh = { "shfmt" },
        },
        format_on_save = {
          timeout_ms = 3000,
          lsp_fallback = true,
        },
      }
    end,
  },

  -- nvim-lint (린팅)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        python = { "flake8" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        c = { "cpplint" },
        cpp = { "cpplint" },
        java = { "checkstyle" },
        html = { "htmlhint" },
        css = { "stylelint" },
        sh = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = "*",
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- nvim-treesitter (문법 강조 및 구문 분석)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup {
        ensure_installed = {
          "lua",
          "python",
          "javascript",
          "typescript",
          "c",
          "cpp",
          "java",
          "json",
          "jsdoc",
          "pug",
          "html",
          "css",
          "vim",
          "vimdoc",
          "query",
        },

        auto_install = true,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },
}

return plugins
