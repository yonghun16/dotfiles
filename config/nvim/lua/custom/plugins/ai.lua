local plugins = {
  -- ================================================================
  -- AI
  -- ================================================================
  -- windsuf.vim (AI 코드 자동완성)
  -- :Codeium Auth (API Key 등록)
  {
    "Exafunction/windsurf.vim", -- 혹은 "Exafunction/codeium.vim"
    event = { "InsertEnter", "BufReadPost" },

    init = function()
      -- 1. 초기 상태 설정
      vim.g.codeium_enabled = true

      -- 2. 함수 정의를 init에 넣어 "언제나" 호출 가능하게 만듭니다.
      _G.ToggleAIAutoComplete = function()
        if vim.g.codeium_enabled == true then
          vim.g.codeium_enabled = false
          vim.cmd "CodeiumDisable"
          print "󱚧 Codeium disabled"
        else
          vim.g.codeium_enabled = true
          vim.cmd "CodeiumEnable"
          print "󰚩 Codeium enabled"
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
