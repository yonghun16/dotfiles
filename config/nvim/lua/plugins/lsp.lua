local plugins = {
  -- ================================================================
  -- LSP & Formatter & Lintter & Treesitter
  -- ================================================================
  -- nvim-lspconfig (LSP 설정 및 팝업 테두리 추가)
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- 모든 LSP 팝업(Hover, Signature Help 등)의 테두리를 "rounded"로 고정
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

      ---@diagnostic disable-next-line: duplicate-set-field
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded" -- 테두리가 없을 때만 rounded 적용
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- 진단(Diagnostic) 팝업 테두리 설정
      vim.diagnostic.config {
        float = { border = "rounded" },
      }
    end,
    config = function()
      require("nvchad.configs.lspconfig").defaults()
    end,
  },

  -- mason.nvim (LSP, Formatter, Linter 통합 관리)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
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

        -- Formatter (conform.nvim에서 사용하는 것들)
        "stylua",
        "isort",
        "black",
        "prettier",
        "clang-format",
        "google-java-format",
        "shfmt",

        -- Linter (nvim-lint에서 사용하는 것들)
        "flake8",
        "eslint_d",
        "cpplint",
        "checkstyle",
        "htmlhint",
        "stylelint",
        "shellcheck",
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
        formatters = {
          black = {
            prepend_args = { "--line-length", "79" },
          },
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
