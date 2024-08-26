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

                SetupDotnetKeymaps();
            end,
        },

    }
end
