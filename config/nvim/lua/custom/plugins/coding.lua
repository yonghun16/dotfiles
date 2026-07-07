local plugins = {
  -- ================================================================
  -- Coding
  -- ================================================================
  -- LuaSnip (스니펫)
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").load {
        paths = vim.fn.stdpath "config" .. "/lua/custom/snippets",
      }
    end,
  },

  -- neogen (함수/클래스 주석 자동 생성)
  {
    "danymat/neogen",
    config = true,
    cmd = "Neogen",
    -- version = "*"
  },

  -- nvim-cmp (코드 자동완성 및 제안)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opts = function(_, opts)
      if opts.mapping then
        opts.mapping["<Tab>"] = nil
        opts.mapping["<S-Tab>"] = nil
      end
    end,
  },

  -- nvim-ts-autotag (닫는 태그 자동완성)
  {
    "windwp/nvim-ts-autotag",
    -- 반드시 treesitter가 먼저 로드된 후 실행되도록 의존성 명시
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- 인서트 모드에 들어갈 때만 로드되도록 설정 (Lazy Loading)
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          -- 에러 방지를 위해 특정 언어에서만 작동하도록 제한하거나
          -- 기본 설정을 활성화합니다.
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      }
    end,
  },

  -- outline (코드 아웃라인 보기)
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    config = function()
      require("outline").setup {
        outline_window = {
          position = "left",
          width = 11,
        },
        show_numbers = false,
        show_relative_numbers = false,
        show_guides = true,
      }
    end,
  },

  -- codediff (코드 비교)
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff", -- 지연 로딩: :CodeDiff 명령어를 칠 때 플러그인이 로드됩니다.
    opts = {
      -- 1. 하이라이트 설정
      highlights = {
        line_insert = "DiffAdd", -- Neovim 기본 추가 배경색 사용
        line_delete = "DiffDelete", -- Neovim 기본 삭제 배경색 사용
        char_brightness = nil, -- 테마 배경(Dark/Light)을 자동 감지하여 글자 단위 강조 조절
      },

      -- 2. Diff 뷰어 동작 설정
      diff = {
        layout = "side-by-side", -- 기본 좌우 분할 매칭
        disable_inlay_hints = true, -- 가독성을 위해 diff 창 내 인레이 힌트 차단
        max_computation_time_ms = 5000,
        ignore_trim_whitespace = true, -- 무의미한 들여쓰기나 끝 공백 변경점은 무시 (추천)
        hide_merge_artifacts = false,
        original_position = "left", -- 왼쪽: 원본(이전) 코드 / 오른쪽: 현재 코드
        cycle_next_hunk = true, -- ]c / [c 네비게이션 시 처음과 끝 순환
        cycle_next_file = true,
        cycle_hunks_across_files = false,
        jump_to_first_change = true, -- 창이 열리면 첫 번째 변경점으로 자동 스크롤
        highlight_priority = 100,
        compute_moves = true, -- 코드가 다른 위치로 "이사" 간 것을 감지 (추천)
        compact_context_lines = 3,
        compact_sync_folds = true, -- 변경 없는 구간 접기(Fold) 싱크 유지
      },

      -- 3. 파일 목록 탐색기 패널 (좌측)
      explorer = {
        position = "left",
        hidden = false,
        width = 35, -- NvChad 화면 비율을 고려해 35칸으로 슬림화
        auto_refresh = true,
        indent_markers = true,
        initial_focus = "explorer", -- 처음 열렸을 때 커서를 파일 목록에 위치
        view_mode = "tree", -- 프로젝트 구조를 보기 편하게 트리 형태로 표시
        flatten_dirs = true, -- 중첩된 단일 폴더 계층 압축
        focus_on_select = true, -- 파일 선택(엔터) 시 우측 코드 창으로 커서 즉시 이동 (추천)
        auto_open_on_cursor = false,
        status_right_margin = 1,
        visible_groups = {
          staged = true,
          unstaged = true,
          conflicts = true,
        },
      },

      -- 4. 커밋 히스토리 패널 (하단)
      history = {
        position = "bottom",
        width = 40,
        height = 12, -- 코드 창 확보를 위해 12줄로 최적화
        initial_focus = "history",
        view_mode = "tree",
      },

      -- 5. Diff 뷰 내부 단축키 설정
      keymaps = {
        view = {
          quit = "q", -- q 버튼으로 뷰어 종료
          toggle_explorer = "<leader>b",
          focus_explorer = "<leader>e",
          next_hunk = "]c", -- 다음 변경점으로 이동
          prev_hunk = "[c", -- 이전 변경점으로 이동
          next_file = "]f", -- 다음 파일으로 이동
          prev_file = "[f", -- 이전 파일으로 이동
          diff_get = "do",
          diff_put = "dp",
          open_in_prev_tab = "gf",
          close_on_open_in_prev_tab = false,
          toggle_stage = "-", -- - 버튼으로 파일 스테이징/언스테이징 전환
          stage_hunk = "<leader>hs",
          unstage_hunk = "<leader>hu",
          discard_hunk = "<leader>hr",
          hunk_textobject = "ih",
          show_help = "g?",
          align_move = "gm", -- 이동된 코드 블록 일시적 정렬 매칭
          toggle_layout = "t", -- t 버튼으로 좌우 분할 ↔ Inline 뷰 전환
          toggle_compact = "gc", -- gc 버튼으로 변경 없는 무수히 긴 코드 숨기기
        },
        -- explorer, history, conflict 단축키는 공식 디폴트가 훌륭하므로 자동 적용되게 둡니다.
      },
    },
    config = function(_, opts)
      require("codediff").setup(opts)
    end,
  },
}

return plugins
