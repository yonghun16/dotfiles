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

  -- Gemini CLI
  {
    "gemini-cli-custom", -- 임의의 식별자
    dir = vim.fn.stdpath "config", -- 실제 다운로드 대신 현재 설정 폴더 사용
    lazy = false, -- 시작 시 즉시 함수 등록
    init = function()
      local gemini_sessions = {}
      local gemini_win = nil

      -- [Internal] 프로젝트 루트 탐색
      local function GetProjectRoot()
        local markers = { ".git", "package.json", "go.mod", "Cargo.toml", "Makefile" }
        local root = vim.fs.root(0, markers)
        if root then
          vim.api.nvim_echo({ { "󰙅 Gemini Root: ", "Identifier" }, { root, "String" } }, true, {})
          return root
        end
        return vim.fn.getcwd()
      end

      -- [Internal] 윈도우 관리
      local function OpenGeminiWin(buf)
        if gemini_win and vim.api.nvim_win_is_valid(gemini_win) then
          vim.api.nvim_win_hide(gemini_win)
          gemini_win = nil
          return false
        end
        vim.cmd "botright vsplit"
        gemini_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(gemini_win, buf)
        vim.api.nvim_win_set_width(gemini_win, 60)
        vim.wo[gemini_win].winfixwidth = true
        return true
      end

      -- 1. Toggle & Resume Latest
      _G.ToggleGeminiCli = function()
        local cwd = GetProjectRoot()
        local buf = gemini_sessions[cwd]
        if not buf or not vim.api.nvim_buf_is_valid(buf) then
          buf = vim.api.nvim_create_buf(false, true)
          gemini_sessions[cwd] = buf
          if OpenGeminiWin(buf) then
            vim.cmd("lcd " .. cwd)
            vim.fn.termopen "gemini --resume latest"
            vim.cmd "startinsert"
          end
        else
          if OpenGeminiWin(buf) then
            vim.cmd "startinsert"
          end
        end
      end

      -- 2. New Session
      _G.NewGeminiSession = function()
        local cwd = GetProjectRoot()
        if gemini_sessions[cwd] and vim.api.nvim_buf_is_valid(gemini_sessions[cwd]) then
          vim.api.nvim_buf_delete(gemini_sessions[cwd], { force = true })
        end
        local buf = vim.api.nvim_create_buf(false, true)
        gemini_sessions[cwd] = buf
        if OpenGeminiWin(buf) then
          vim.fn.termopen "gemini"
          vim.cmd("lcd " .. cwd)
          vim.cmd "startinsert"
          print "Gemini: 새로운 세션을 시작합니다."
        end
      end

      -- 3. Select Session
      _G.SelectGeminiSession = function()
        local handle = io.popen "gemini --list-sessions 2>/dev/null"
        if not handle then
          return
        end
        local result = handle:read "*a"
        handle:close()
        if result == "" or result:find "No sessions found" then
          print "Gemini: 저장된 세션이 없습니다."
          return
        end
        local sessions = {}
        for line in result:gmatch "[^\r\n]+" do
          if line:match "%d+%." then
            table.insert(sessions, line:gsub("^%s+", ""))
          end
        end
        vim.ui.select(sessions, { prompt = "재개할 세션을 선택하세요:" }, function(choice)
          if choice then
            local index = choice:match "(%d+)%."
            if index then
              local cwd = GetProjectRoot()
              local buf = vim.api.nvim_create_buf(false, true)
              gemini_sessions[cwd] = buf
              if OpenGeminiWin(buf) then
                vim.cmd("lcd " .. cwd)
                vim.fn.termopen("gemini --resume " .. index)
                vim.cmd "startinsert"
              end
            end
          end
        end)
      end
    end,
  },
}

return plugins
