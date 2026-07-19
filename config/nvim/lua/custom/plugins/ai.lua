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

  -- gemini CLI
  {
    "gemini-cli-custom",
    dir = vim.fn.stdpath "config",
    lazy = false,
    init = function()
      require "custom.gemini"
    end,
  },

  -- CodeCompanion
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
    },
    event = "VeryLazy",
    opts = {
      display = {
        chat = {
          window = {
            layout = "vertical",
            relative_width = false,
            width = 60,
          },
        },
      },

      strategies = {
        chat = {
          adapter = "ollama",
          keymaps = {
            close = {
              modes = {
                n = "<C-q>",
                i = "<C-q>",
              },
            },
            stop = {
              modes = {
                n = "<C-x>",
                i = "<C-x>",
              },
            },
          },
        },

        inline = {
          adapter = "ollama",
        },
      },

      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen2.5-coder:14b",
              },
              endpoint = {
                default = "http://localhost:11434/api/chat",
              },
            },
          })
        end,
      },

      extensions = {
        history = {
          enabled = true,
          opts = {
            auto_save = true,
            path = vim.fn.stdpath "data" .. "/codecompanion/history",
          },
        },
      },
    },
  },
}

return plugins
