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
    version = false, -- 최신 기능 반영을 위해 메인 브랜치 유지
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "gemini",
      mode = "legacy",

      providers = {
        gemini = {
          model = "gemini-3.5-flash", -- 초고속 3.5 플래시 모델
          temperature = 0,
          max_tokens = 4096,
        },
      },
      behaviour = {
        auto_suggestions = false,
        support_paste_from_clipboard = true,
      },
      mappings = {
        sidebar = {
          toggle = "<leader>aa", -- <leader> + a + a 로 사이드바 토글
        },
      },
    },
  },
}

return plugins
