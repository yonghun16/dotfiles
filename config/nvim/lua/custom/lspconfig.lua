-- ================================================================
-- Warning Message 무시
-- ================================================================
-- 1.vim.deprecate 무시 (0.11 버전의 주된 경고 경로)
if vim.deprecate then
  local original_deprecate = vim.deprecate
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.deprecate = function(msg, ...)
    if msg and (msg:find "lspconfig" or msg:find "deprecated") then
      return -- lspconfig 관련 경고면 아무것도 안 하고 종료
    end
    return original_deprecate(msg, ...)
  end
end

-- 2. vim.notify 무시 (구버전 호환 및 기타 알림 경로)
local original_notify = vim.notify
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and (msg:find "require%('lspconfig'%)" or msg:find "deprecated") then
    return
  end
  original_notify(msg, level, opts)
end

-- ================================================================
-- LSP Config
-- ================================================================
-- LSP Servers Setup
local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"

local servers = {
  "pyright",
  "ts_ls",
  "tailwindcss",
  "html",
  "pug",
  "cssls",
  "jdtls",
  "sqlls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Emmet-language-server 설정
lspconfig.emmet_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "css",
    "sass",
    "scss",
    "less",
    "pug",
  },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
      },
    },
  },
}

-- Clangd
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--query-driver=/opt/homebrew/bin/g++-*",
  },
}
