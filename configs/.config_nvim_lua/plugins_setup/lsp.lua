require('helpers')
require('plugins_setup.lsp_attach')

function LspSetup()
    return {
        {
            -- https://github.com/hrsh7th/nvim-cmp
            "hrsh7th/cmp-nvim-lsp",
            lazy = true,
            event = 'BufEnter',
            config = function()
            end,
        },

        {
            -- https://github.com/
            "hrsh7th/cmp-buffer",
            lazy = true,
            event = 'BufEnter',
            config = function()
            end,
        },

        {
            -- https://github.com/
            "hrsh7th/cmp-path",
            lazy = true,
            event = 'BufEnter',
            config = function()
            end,
        },

        {
            -- https://github.com/
            "hrsh7th/cmp-cmdline",
            lazy = true,
            event = 'BufEnter',
            config = function()
            end,
        },

        {
            -- https://github.com/
            "saadparwaiz1/cmp_luasnip",
            lazy = true,
            event = 'BufEnter',
            config = function()
            end,
        },

        {
            -- https://github.com/j-hui/fidget.nvim
            "j-hui/fidget.nvim",
            lazy = true,
            event = 'BufEnter',
            config = function()
                require("fidget").setup({})
            end,
        },

        {
            -- https://github.com/SmiteshP/nvim-navic
            "SmiteshP/nvim-navic",
            lazy = true,
            event = 'BufEnter',
            dependencies = "neovim/nvim-lspconfig"
        },

        {
            -- https://github.com/jose-elias-alvarez/null-ls.nvim
            "jose-elias-alvarez/null-ls.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            lazy = true,
            event = 'BufEnter',
            config = function()
                require("null-ls").setup()
            end,
        },

        {
            -- https://github.com/neovim/nvim-lspconfig
            'neovim/nvim-lspconfig',
            lazy = true,
            event = "BufEnter",
            config = function()
                SetupLspKeymaps();
            end
        },

        {
            -- https://github.com/williamboman/mason.nvim
            "williamboman/mason.nvim",
            lazy = true,
            event = 'VimEnter',
            config = function()
                require("mason").setup()

                SetupMasonKeymaps();
            end,
        },

        {
            "williamboman/mason-lspconfig.nvim",
            after = 'nvim-lspconfig',
            lazy = true,
            event = "BufEnter",
            config = function()
                require("mason-lspconfig").setup()

                local cmp_lsp = require("cmp_nvim_lsp")
                local capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    vim.lsp.protocol.make_client_capabilities(),
                    cmp_lsp.default_capabilities())

                -- TODO: Setup https://github.com/SmiteshP/nvim-navbuddy
                local navic = require("nvim-navic")

                require("mason-lspconfig").setup_handlers {
                    function(server_name)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                if client.server_capabilities.documentSymbolProvider then
                                    navic.attach(client, bufnr)
                                end
                            end
                        }
                    end
                }

                vim.diagnostic.config({
                    -- update_in_insert = true,
                    float = {
                        focusable = false,
                        style = "minimal",
                        border = "rounded",
                        source = "always",
                        header = "",
                        prefix = "",
                    },
                })

                -- Mappings.
                -- See `:help vim.diagnostic.*` for documentation on any of the below functions
                --[[ vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, DefaultKeymapOpts())
                -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, DefaultKeymapOpts()) ]]
                -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, DefaultKeymapOpts())
                -- vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, DefaultKeymapOpts())
            end,
        },

        {
            -- https://github.com/hrsh7th/nvim-cmp
            "hrsh7th/nvim-cmp",
            lazy = true,
            event = 'BufEnter',
            config = function()
                local cmp = require('cmp')
                local cmp_select = { behavior = cmp.SelectBehavior.Select }

                cmp.setup({
                    sources = cmp.config.sources({
                            { name = 'nvim_lsp' },
                            { name = 'luasnip' },
                        },
                        {
                            { name = 'buffer' },
                        }),
                    snippet = {
                        expand = function(args)
                            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['C-j'] = cmp.mapping.select_next_item(cmp_select),
                        ['<tab>'] = cmp.mapping.select_next_item(cmp_select),
                        ['C-k'] = cmp.mapping.select_prev_item(cmp_select),
                        ['<S-tab>'] = cmp.mapping.select_prev_item(cmp_select),
                        ['<CR>'] = cmp.mapping.confirm({ select = true }),
                        ["<C-space>"] = cmp.mapping.complete(),
                    }),
                })
            end,
        },

        {
            -- https://github.com/RRethy/vim-illuminate
            'RRethy/vim-illuminate',
            lazy = true,
            event = "BufEnter",
            config = function()
            end,
        },

        {
            -- https://github.com/weilbith/nvim-code-action-menu
            'weilbith/nvim-code-action-menu',
            lazy = true,
            event = "InsertEnter",
            config = function()
                SetupCodeActionKeymaps();
            end,
        },

        {
            -- https://github.com/kosayoda/nvim-lightbulb
            'kosayoda/nvim-lightbulb',
            dependencies = 'antoinemadec/FixCursorHold.nvim',
            lazy = true,
            event = "BufReadPre",
            config = function()
                require('nvim-lightbulb').setup({
                    autocmd = {
                        enabled = true
                    }
                })
            end,
        },

        {
            'folke/trouble.nvim',
            lazy = true,
            event = "BufEnter",
            config = function()
                local trouble = require("trouble")
                trouble.setup()

                SetupTroubleKeymaps()
            end,
        },
    }
end
