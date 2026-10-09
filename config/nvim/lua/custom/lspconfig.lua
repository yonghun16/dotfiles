-- ================================================================
-- LSP Config (Neovim 0.11+ 내장 API: vim.lsp.config / vim.lsp.enable)
-- 위치: ~/.config/nvim/lua/configs/lspconfig.lua
-- 실행 파일이 설치된 서버만 켜므로, 맥과 Termux에서 같은 파일을 써도 에러가 나지 않는다.
-- ================================================================

local nvlsp = require "nvchad.configs.lspconfig"

-- 모든 서버 공통 설정
vim.lsp.config("*", {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
})

-- ───────────── 서버 목록: lspconfig 이름 = 실행 파일 ─────────────
local servers = {
  pyright = "pyright-langserver",
  ts_ls = "typescript-language-server",
  html = "vscode-html-language-server",
  cssls = "vscode-css-language-server",
  bashls = "bash-language-server",
  rust_analyzer = "rust-analyzer",
  clangd = "clangd",
  lua_ls = "lua-language-server",
  emmet_language_server = "emmet-language-server",
  tailwindcss = "tailwindcss-language-server",
  sqlls = "sql-language-server",
  eslint = "vscode-eslint-language-server",
}

-- ───────────── 서버별 개별 설정 ─────────────
-- Emmet
vim.lsp.config("emmet_language_server", {
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
})

-- clangd: homebrew g++ 경로는 맥에서만 적용
if vim.fn.has "mac" == 1 then
  vim.lsp.config("clangd", {
    cmd = { "clangd", "--query-driver=/opt/homebrew/bin/g++-*" },
  })
end

-- Lua: nvim 설정 파일에서 `vim` 전역 변수 경고 제거
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

-- ───────────── 활성화: 실행 파일이 있는 서버만 ─────────────
for name, bin in pairs(servers) do
  if vim.fn.executable(bin) == 1 then
    vim.lsp.enable(name)
  end
end
