function SyntaxSetup()
    return {
        {
            -- https://github.com/nvim-treesitter/nvim-treesitter
            'nvim-treesitter/nvim-treesitter',
            lazy = true,
            event = "BufEnter",
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

                vim.opt.foldmethod = "expr"
                vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

                -- Open file unfolded.
                vim.opt.foldlevel = 99
            end,
        },

        {
            -- https://github.com/HiPhish/rainbow-delimiters.nvim
            'HiPhish/rainbow-delimiters.nvim',
            lazy = true,
            event = "BufEnter",
        },

    }
end
