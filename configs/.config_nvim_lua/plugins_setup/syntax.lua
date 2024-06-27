function SyntaxSetup()
    return {
        {
            -- https://github.com/nvim-treesitter/nvim-treesitter
            'nvim-treesitter/nvim-treesitter',
            lazy = true,
            build = function()
                require('nvim-treesitter.install').update()
            end,
            init = function()
                require('nvim-treesitter.configs').setup({
                    auto_install = true,
                    highlight = {
                        enable = true,
                    },
                    ensure_installed = "all",
                })
            end,
        },

        {
            -- https://github.com/HiPhish/rainbow-delimiters.nvim
            'HiPhish/rainbow-delimiters.nvim',
            lazy = true,
        }

    }
end
