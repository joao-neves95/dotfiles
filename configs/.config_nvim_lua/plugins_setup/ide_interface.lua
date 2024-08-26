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

                Keymap('n', '<leader>E', ':NvimTreeToggle<CR>', DefaultKeymapOpts('Explorer'))
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

                SetupBufferlineKeymaps();
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
                require('dashboard').setup {}
            end,
        },

        {
            -- https://github.com/akinsho/toggleterm.nvim
            'akinsho/toggleterm.nvim',
            lazy = true,
            event = 'VimEnter',
            config = function()
                require("toggleterm").setup()
                local Terminal = require('toggleterm.terminal').Terminal
                local lazygit_term = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

                SetupToggletermKeymaps(lazygit_term);
            end
        },

        {
            'lewis6991/gitsigns.nvim',
            lazy = true,
            event = "BufEnter",
            config = function()
                require('gitsigns').setup()
            end,
        },

        {
            -- Browser search
            -- https://github.com/chrishrb/gx.nvim
            'chrishrb/gx.nvim',
            dependencies = { "nvim-lua/plenary.nvim" },
            lazy = true,
            event = "BufEnter",
            cmd = { "Browse" },
            init = function()
                vim.g.netrw_nogx = 1 -- disable netrw gx
            end,
            submodules = false,
            keys = {
                { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } },
            },
            config = function()
                require("gx").setup()

                SetupGxKeymaps();
            end,
        },
    }
end
