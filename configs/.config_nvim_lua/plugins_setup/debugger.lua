function DebuggerSetup(use)

  use {
    -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    config = function ()
      local dap = require("dap")

      local wk = require("which-key")
        wk.register({ ["<leader>"] = {
          d = {
            name = "Debugger",
          },
        } })

      Keymap('n', '<F5>', function () dap.continue() end, DefaultKeymapOpts('Continue'))
      Keymap('n', '<leader>dc', function () dap.continue() end, DefaultKeymapOpts('Continue'))
      Keymap('n', '<F10>', function () dap.step_over() end, DefaultKeymapOpts('Step Over'))
      Keymap('n', '<leader>do', function () dap.step_over() end, DefaultKeymapOpts('Step Over'))
      Keymap('n', '<F11>', function () dap.step_into() end, DefaultKeymapOpts('Step Into'))
      Keymap('n', '<leader>di', function () dap.step_into() end, DefaultKeymapOpts('Step Into'))
      Keymap('n', '<F12>', function () dap.step_out() end, DefaultKeymapOpts('Step Out'))
      Keymap('n', '<leader>dq', function () dap.step_out() end, DefaultKeymapOpts('Step Out'))

      Keymap('n', '<leader>db', function () dap.toggle_breakpoint() end, DefaultKeymapOpts('Toggle Breakpoint'))
      Keymap('n', '<leader>dB', function () dap.set_breakpoint() end, DefaultKeymapOpts('Set Breakpoint'))

      Keymap('n', '<leader>dr', function () dap.repl.open() end, DefaultKeymapOpts('Open REPL'))
    end
  }

  use {
    -- https://github.com/rcarriga/nvim-dap-ui
    'rcarriga/nvim-dap-ui',
    requires = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio', 'folke/neodev.nvim'},
    config = function ()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })

      Keymap('n', '<leader>dO', function () dapui.open() end, DefaultKeymapOpts('Open'))
      Keymap('n', '<leader>dC', function () dapui.close() end, DefaultKeymapOpts('Close'))
      Keymap('n', '<leader>dt', function () dapui.toggle() end, DefaultKeymapOpts('Toggle'))
    end
  }

  use {
    "jay-babu/mason-nvim-dap.nvim",
    config = function ()
      local mason_nvim_dap = require('mason-nvim-dap')
      require("mason-nvim-dap").setup({
        handlers = {
          function(config)
            mason_nvim_dap.default_setup(config)
          end
        }
      })
    end
  }

end
