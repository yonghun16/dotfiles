local plugins = {
  -- ================================================================
  -- LSP & Formatter & Linter & Treesitter
  -- 위치: ~/.config/nvim/lua/plugins/lsp.lua
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
      -- 서버 목록과 개별 설정은 lua/configs/lspconfig.lua에서 관리
      require "configs.lspconfig"
    end,
  },

  -- mason.nvim (LSP, Formatter, Linter 통합 관리)
  -- 설치 목록은 이 파일 한 곳에서만 관리하세요 (chadrc.lua의 M.mason과 중복 금지)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "bash-language-server",
        "clangd",
        "css-lsp",
        "emmet-language-server",
        "eslint-lsp",
        "html-lsp",
        "jdtls",
        "json-lsp",
        "lua-language-server",
        "pug-lsp",
        "pyright",
        "ruff",
        "rust-analyzer",
        "sqlls",
        "tailwindcss-language-server",
        "typescript-language-server",
        "yaml-language-server",

        -- Formatter (conform.nvim에서 사용)
        "clang-format",
        "google-java-format",
        "prettier",
        "shfmt",
        "stylua",

        -- Linter (nvim-lint에서 사용)
        "checkstyle",
        "cpplint",
        "htmlhint",
        "shellcheck",
        "stylelint",
      },
    },
  },

  -- conform.nvim (포맷팅)
  -- configs/conform.lua는 쓰지 않으므로, 플러그인 설정은 여기 한 곳만 둡니다.
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_organize_imports", "ruff_format" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          java = { "google-java-format" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          sh = { "shfmt" },
          bash = { "shfmt" },
        },
        formatters = {
          -- 기존 black --line-length 79 설정을 ruff로 이관
          ruff_format = {
            append_args = { "--line-length", "79" },
          },
        },
        format_on_save = {
          timeout_ms = 3000,
          lsp_format = "fallback",
        },
      }
    end,
  },

  -- nvim-lint (린팅)
  -- python → ruff LSP, javascript/typescript → eslint LSP, sh → bashls(shellcheck 내장)가
  -- 이미 진단을 제공하므로 여기서는 뺐습니다 (중복 경고 방지).
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        c = { "cpplint" },
        cpp = { "cpplint" },
        java = { "checkstyle" },
        html = { "htmlhint" },
        css = { "stylelint" },
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
          "bash",
          "c",
          "cpp",
          "css",
          "html",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "lua",
          "markdown",
          "pug",
          "python",
          "query",
          "rust",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
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
