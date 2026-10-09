local plugins = {
  -- ================================================================
  -- Debugging
  -- ================================================================
  -- nvim-dap (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapContinue", "DapToggleBreakpoint" },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dapui = require "dapui"
          dapui.setup()

          local dap = require "dap"
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      },
    },
    config = function()
      local dap = require "dap"

      -- Python Config
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          name = "Launch file",
          type = "python",
          request = "launch",
          program = "${file}",
          pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
              return venv
            end
            return "python"
          end,
        },
      }

      -- JS / TS Config
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      local js_ts_config = {
        {
          name = "Launch file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
        },
        {
          name = "Attach to process",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      dap.configurations.javascript = js_ts_config
      dap.configurations.typescript = js_ts_config
      dap.configurations.javascriptreact = js_ts_config
      dap.configurations.typescriptreact = js_ts_config
    end,
  },
}
return plugins
