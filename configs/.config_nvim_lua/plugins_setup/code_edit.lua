function CodeEditSetup()
    return {
        {
            'numToStr/Comment.nvim',
            lazy = true,
            event = "BufEnter",
            config = function()
                RegisterWhichKeyGroup('c', 'Comment')

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
        }
    }
end
