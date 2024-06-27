function DebuggerSetup()
    return {
        {
            -- https://github.com/mfussenegger/nvim-dap
            'mfussenegger/nvim-dap',
            lazy = true,
            ft = { 'cs', 'rust', 'js' },
            config = function()
                local dap = require("dap")

                RegisterWhichKeyGroup('d', 'Debugger')

                Keymap('n', '<F5>', function() dap.continue() end, DefaultKeymapOpts('Continue'))
                Keymap('n', '<leader>dc', function() dap.continue() end, DefaultKeymapOpts('Continue'))
                Keymap('n', '<F10>', function() dap.step_over() end, DefaultKeymapOpts('Step Over'))
                Keymap('n', '<leader>do', function() dap.step_over() end, DefaultKeymapOpts('Step Over'))
                Keymap('n', '<F11>', function() dap.step_into() end, DefaultKeymapOpts('Step Into'))
                Keymap('n', '<leader>di', function() dap.step_into() end, DefaultKeymapOpts('Step Into'))
                Keymap('n', '<F12>', function() dap.step_out() end, DefaultKeymapOpts('Step Out'))
                Keymap('n', '<leader>dq', function() dap.step_out() end, DefaultKeymapOpts('Step Out'))

                Keymap('n', '<leader>db', function() dap.toggle_breakpoint() end, DefaultKeymapOpts('Toggle Breakpoint'))
                Keymap('n', '<leader>dB', function() dap.set_breakpoint() end, DefaultKeymapOpts('Set Breakpoint'))

                Keymap('n', '<leader>dr', function() dap.repl.open() end, DefaultKeymapOpts('Open REPL'))
            end
        },

        {
            -- https://github.com/rcarriga/nvim-dap-ui
            'rcarriga/nvim-dap-ui',
            dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio', 'folke/neodev.nvim' },
            lazy = true,
            config = function()
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

                Keymap('n', '<leader>dO', function() dapui.open() end, DefaultKeymapOpts('Open'))
                Keymap('n', '<leader>dC', function() dapui.close() end, DefaultKeymapOpts('Close'))
                Keymap('n', '<leader>dt', function() dapui.toggle() end, DefaultKeymapOpts('Toggle'))
            end
        },

        {
            "jay-babu/mason-nvim-dap.nvim",
            lazy = true,
            config = function()
                require("mason-nvim-dap").setup()
            end
        },

        {
            -- https://github.com/theHamsta/nvim-dap-virtual-text
            'theHamsta/nvim-dap-virtual-text',
            dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
            lazy = true,
            config = function()
                require("nvim-dap-virtual-text").setup()
            end
        }
    }
end
