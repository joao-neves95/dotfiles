function IdeInterfaceSetup()
    return {
        {
            -- https://github.com/nvim-tree/nvim-tree.lua
            'nvim-tree/nvim-tree.lua',
            lazy = false,
            dependencies = {
                'kyazdani42/nvim-web-devicons', -- optional, for file icons
            },
            config = function()
                require("nvim-tree").setup()

                Keymap('n', '<leader>e', ':NvimTreeToggle<CR>', DefaultKeymapOpts('Explorer'))
                Keymap('n', '?', function() require('nvim-tree.api').toggle_help() end, DefaultKeymapOpts('Help'))
            end,
        },

        {
            -- https://github.com/nvim-lualine/lualine.nvim
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
            lazy = true,
            event = 'VimEnter',
            config = function()
                require('lualine').setup {
                    options = {
                        theme = 'nord'
                    },
                }
            end,
        },

        {
            -- (tabs)
            -- https://github.com/akinsho/bufferline.nvim
            'akinsho/bufferline.nvim',
            lazy = true,
            event = 'BufEnter',
            dependencies = 'nvim-tree/nvim-web-devicons',
            config = function()
                vim.opt.termguicolors = true

                require("bufferline").setup({
                    options = {
                        diagnostics = 'nvim_lsp',
                    }
                })

                -- Cycle buffers.
                Keymap('n', '<S-h>', ':BufferLineCyclePrev<CR>', DefaultKeymapOpts())
                Keymap('n', '<S-l>', ':BufferLineCycleNext<CR>', DefaultKeymapOpts())
                -- Move the buffers.
                Keymap('n', '<C-S-h>', ':BufferLineMovePrev<CR>', DefaultKeymapOpts())
                Keymap('n', '<C-S-l>', ':BufferLineMoveNext<CR>', DefaultKeymapOpts())
            end,
        },

        -- {
        --   -- https://github.com/petertriho/nvim-scrollbar
        --   "petertriho/nvim-scrollbar",
        --   requires = { 'kevinhwang91/nvim-hlslens', opt = true },
        --   config = function()
        --     require("scrollbar").setup()
        --     require("scrollbar.handlers.search").setup()
        --   end
        -- }

        {
            -- https://github.com/dstein64/nvim-scrollview
            'dstein64/nvim-scrollview',
            lazy = true,
            event = 'BufEnter',
            config = function()
                require('scrollview').setup()
            end,
        },


        {
            'nvimdev/dashboard-nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            event = 'VimEnter',
            config = function()
                require('dashboard').setup { }
            end,
        },

        {
            -- https://github.com/akinsho/toggleterm.nvim
            'akinsho/toggleterm.nvim',
            lazy = true,
            event = 'VimEnter',
            config = function()
                require("toggleterm").setup()
                local Terminal     = require('toggleterm.terminal').Terminal
                local lazygit_term = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

                RegisterWhichKeyGroup('t', 'Terminal')

                Keymap('n', '<leader>th', ':ToggleTerm size=10 dir=~ direction=horizontal<CR>',
                    DefaultKeymapOpts('Toggle Horizontal'))
                Keymap('n', '<leader>tf', ':ToggleTerm dir=~ direction=float<CR>', DefaultKeymapOpts('Toggle Floating'))
                Keymap('n', '<leader>tv', ':ToggleTerm size=40 dir=~ direction=vertical<CR>',
                    DefaultKeymapOpts('Toggle Vertical'))
                Keymap('n', '<leader>tg', function() lazygit_term:toggle() end, DefaultKeymapOpts('Toggle Lazygit'))
            end
        }
    }
end
