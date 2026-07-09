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

  -- Gemini CLI
  {
    "gemini-cli-custom", -- 임의의 식별자
    dir = vim.fn.stdpath "config", -- 실제 다운로드 대신 현재 설정 폴더 사용
    lazy = false, -- 시작 시 즉시 함수 등록
    init = function()
      local gemini_sessions = {}
      local gemini_win = nil

      -------------------------------------------------------------------------
      -- Project Root
      -------------------------------------------------------------------------

      local function GetProjectRoot()
        local markers = {
          ".git",
          "package.json",
          "go.mod",
          "Cargo.toml",
          "Makefile",
        }

        local root = vim.fs.root(0, markers)
        if root then
          vim.api.nvim_echo({
            { "󰙅 Gemini Root: ", "Identifier" },
            { root, "String" },
          }, true, {})
          return root
        end

        root = vim.fn.getcwd()
        vim.api.nvim_echo({
          { "󰙅 Gemini Root: ", "Identifier" },
          { root, "String" },
          { " (cwd)", "Comment" },
        }, true, {})
        return root
      end

      -------------------------------------------------------------------------
      -- Window
      -------------------------------------------------------------------------
      local function OpenGeminiWin(buf)
        -- 이미 열려있으면 숨기기
        if gemini_win and vim.api.nvim_win_is_valid(gemini_win) then
          vim.api.nvim_win_hide(gemini_win)
          gemini_win = nil
          return false
        end

        if not vim.api.nvim_buf_is_valid(buf) then
          return false
        end

        vim.cmd "botright vsplit"
        gemini_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(gemini_win, buf)
        vim.api.nvim_win_set_width(gemini_win, 60)
        vim.wo[gemini_win].winfixwidth = true
        return true
      end

      -------------------------------------------------------------------------
      -- Toggle Gemini (Resume Latest)
      -------------------------------------------------------------------------
      _G.ToggleGeminiCli = function()
        local cwd = GetProjectRoot()
        local buf = gemini_sessions[cwd]

        if not buf or not vim.api.nvim_buf_is_valid(buf) then
          buf = vim.api.nvim_create_buf(false, true)
          gemini_sessions[cwd] = buf

          if OpenGeminiWin(buf) then
            vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
            vim.fn.termopen "gemini --resume latest"
            vim.cmd "startinsert"
          end
          return
        end

        if OpenGeminiWin(buf) then
          vim.cmd "startinsert"
        end
      end

      -------------------------------------------------------------------------
      -- New Gemini Session
      -------------------------------------------------------------------------
      _G.NewGeminiSession = function()
        local cwd = GetProjectRoot()

        if gemini_win and vim.api.nvim_win_is_valid(gemini_win) then
          pcall(vim.api.nvim_win_close, gemini_win, true)
          gemini_win = nil
        end

        if gemini_sessions[cwd] and vim.api.nvim_buf_is_valid(gemini_sessions[cwd]) then
          pcall(vim.api.nvim_buf_delete, gemini_sessions[cwd], { force = true })
        end

        local buf = vim.api.nvim_create_buf(false, true)
        gemini_sessions[cwd] = buf

        if OpenGeminiWin(buf) then
          vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
          vim.fn.termopen "gemini"
          vim.cmd "startinsert"
        end
      end

      -------------------------------------------------------------------------
      -- Cleanup
      -------------------------------------------------------------------------
      vim.api.nvim_create_autocmd("TermClose", {
        callback = function(args)
          for cwd, buf in pairs(gemini_sessions) do
            if buf == args.buf then
              gemini_sessions[cwd] = nil
              if gemini_win and vim.api.nvim_win_is_valid(gemini_win) then
                pcall(vim.api.nvim_win_close, gemini_win, true)
              end
              gemini_win = nil
              break
            end
          end
        end,
      })
    end,
  },
}

return plugins
