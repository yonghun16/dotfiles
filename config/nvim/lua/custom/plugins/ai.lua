local plugins = {
  -- ================================================================
  -- AI
  -- ================================================================
  -- windsuf.vim (AI 코드 자동완성)
  -- :Codeium Auth (API Key 등록)
  {
    "Exafunction/windsurf.nvim",
    -- 지연 로딩 조건을 InsertEnter로 제한하여 완벽히 초기화된 후 작동하도록 유도
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp", -- 공식 문서에 나온 의존성 추가
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
            accept_word = "<C-l>",
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

  -- avante.nvim
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",

    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",

      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },

    opts = {
      provider = "gemini",
      mode = "agentic",

      providers = {
        gemini = {
          model = "gemini-3.5-flash",
          temperature = 0,
          max_tokens = 8192,
        },
      },

      behaviour = {
        auto_suggestions = false,

        -- 클립보드 붙여넣기 지원
        support_paste_from_clipboard = true,

        -- 자동 적용 X
        -- diff 확인 후 직접 적용
        auto_apply_diff_after_generation = false,

        -- agent가 파일 수정 workflow 사용
        enable_fastapply = true,
      },

      mappings = {
        sidebar = {
          toggle = "<leader>aa",
        },

        diff = {
          ours = "co", -- diff 적용
          theirs = "ct", -- AI 변경 유지
          all_theirs = "ca", -- 전체 적용
          close = "q", -- 종료
        },
      },

      windows = {
        sidebar = {
          width = 35,
        },
      },
    },
  },
}

return plugins
