function CodeEditSetup()
    return {
        {
            'numToStr/Comment.nvim',
            lazy = true,
            event = "BufEnter",
            config = function()
                require('Comment').setup {
                    toggler = {
                        line = '<leader>cc',
                        block = '<leader>cb',
                    },
                    opleader = {
                        line = '<leader>cc',
                        block = '<leader>cb',
                    }
                }
            end,
        },

        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            lazy = true,
            config = function()
                require("nvim-autopairs").setup {}
            end,
        },

        {
            -- https://github.com/lukas-reineke/indent-blankline.nvim
            'lukas-reineke/indent-blankline.nvim',
            lazy = true,
            event = "BufEnter",
            config = function()
                require('ibl').setup()
            end,
        },

        {
            -- https://github.com/MoaidHathot/dotnet.nvim
            'MoaidHathot/dotnet.nvim',
            lazy = true,
            ft = { 'cs', 'csproj', 'sln' },
            cmd = "DotnetUI",
            opts = {},
            config = function()
                require("dotnet").setup({})

                RegisterWhichKeyGroup('ln', 'Dotnet')
                Keymap('n', '<leader>lnn', ':DotnetUI new_item<cr>', DefaultKeymapOpts('Add new item template'))
                Keymap('n', '<leader>lnf', ':DotnetUI file bootstrap<cr>', DefaultKeymapOpts('Add new cs file'))
                Keymap('n', '<leader>lnp', ':DotnetUI project package add<cr>', DefaultKeymapOpts('Add a Nuget package'))
                Keymap('n', '<leader>lnr', ':DotnetUI project package remove<cr>', DefaultKeymapOpts('Remove a Nuget package'))
                Keymap('n', '<leader>lnP', ':DotnetUI project reference add<cr>', DefaultKeymapOpts('Add project reference'))
                Keymap('n', '<leader>lnR', ':DotnetUI project package remove<cr>', DefaultKeymapOpts('Remove a project reference'))
            end,
        },

    }
end
