local plugins = {
  -- ================================================================
  -- Editor
  -- ================================================================
  -- fzf-lua (빠른 탐색기)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    config = function()
      if vim.fn.executable "/opt/homebrew/opt/fzf" == 1 then
        vim.opt.rtp:append "/opt/homebrew/opt/fzf"
      end

      local actions = require "fzf-lua.actions"
      require("fzf-lua").setup {
        keymap = {
          builtin = {
            ["<C-u>"] = "preview-page-up",
            ["<C-d>"] = "preview-page-down",
          },
        },
        buffers = {
          sort_lastused = true,
          include_current = true,
          actions = {
            ["ctrl-q"] = { fn = actions.buf_del, reload = true },
          },
        },
      }
    end,
  },

  -- nvim-tree (파일 트리)
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
        hijack_cursor = true,

        on_attach = function(bufnr)
          local api = require "nvim-tree.api"

          -- 1. 기본 키맵 먼저 적용
          api.config.mappings.default_on_attach(bufnr)

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- 2. 사용자 커스텀 매핑
          vim.keymap.del("n", "<C-k>", { buffer = bufnr }) -- Ctrl+k 제거
          vim.keymap.set("n", "K", api.node.show_info_popup, opts "Show Info")
          vim.keymap.set("n", "v", api.node.open.vertical, opts "Open: Vertical Split")
          vim.keymap.set("n", "h", api.node.open.horizontal, opts "Open: Horizontal Split")
          vim.keymap.set("n", "t", api.node.open.tab, opts "Open: New Tab")
        end,
      }
    end,
  },

  -- nvim-lastplace (커서 마지막 위치 저장)
  {
    "ethanholz/nvim-lastplace",
    event = "BufReadPost",
    config = function()
      require("nvim-lastplace").setup {}
    end,
  },

  -- vim-illuminate (단어 하이라이트)
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    -- init: 플러그인이 로드되기 전에 함수를 미리 전역으로 등록합니다.
    init = function()
      _G.SmartNextJump = function()
        if vim.v.hlsearch == 1 then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("n", true, false, true), "n", false)
        else
          local status, illuminate = pcall(require, "illuminate")
          if status then
            illuminate.goto_next_reference(false)
          end
        end
      end

      _G.SmartPrevJump = function()
        if vim.v.hlsearch == 1 then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("N", true, false, true), "n", false)
        else
          local status, illuminate = pcall(require, "illuminate")
          if status then
            illuminate.goto_prev_reference(false)
          end
        end
      end
    end,
    -- config: 플러그인 자체의 옵션을 설정합니다.
    config = function()
      require("illuminate").configure {
        providers = {
          "lsp",
          "regex",
        },
      }
    end,
  },

  -- vim-visual-multi (멀티 커서)
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- 플러그인이 로드되기 전에 미리 설정값을 박아넣습니다.
      vim.g.VM_maps = {
        ["Find Under"] = "s/",
        ["Find Subword Under"] = "s/",
        ["Add Cursor Down"] = "sj",
        ["Add Cursor Up"] = "sk",
        ["Move Right"] = "sl",
        ["Move Left"] = "sh",
        ["Mouse Cursor"] = "s<LeftMouse>",
        ["Add Cursor At Pos"] = "s<CR>",
        ["Select Operator"] = "ss",
      }
    end,
  },
}

return plugins
