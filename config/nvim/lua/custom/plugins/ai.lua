local plugins = {
  -- ================================================================
  -- AI
  -- ================================================================
  -- windsuf.vim (AI 코드 자동완성) :Codeium Auth (API Key 등록)
  {
    "Exafunction/windsurf.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },

    config = function()
      require("codeium").setup {
        enable_cmp_source = false,

        virtual_text = {
          enabled = true,
          map_keys = true,
          accept_fallback = "\t",
          key_bindings = {
            accept = "<Tab>",
            accept_word = "<C-f>",
            next = "<C-n>",
            prev = "<C-p>",
          },
        },
      }

      vim.api.nvim_set_hl(0, "CodeiumSuggestion", {
        fg = "#6b7280",
        italic = true,
      })

      -- 토글 함수 설정
      local codeium_enabled = true
      _G.ToggleAIAutoComplete = function()
        codeium_enabled = not codeium_enabled
        vim.cmd "silent Codeium Toggle"

        if codeium_enabled then
          print "󰚩 Codeium enabled"
        else
          print "󱚧 Codeium disabled"
        end
      end
    end,
  },
}

return plugins
