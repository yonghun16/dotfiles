-- lua/configs/conform.lua
local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    python = { "ruff_organize_imports", "ruff_format" },

    c = { "clang-format" },
    cpp = { "clang-format" },
    java = { "google-java-format" },
    -- rust = { "rustfmt" }, -- rustfmt는 Mason이 아니라 rustup으로 설치

    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },

    sh = { "shfmt" },
    bash = { "shfmt" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

return options
