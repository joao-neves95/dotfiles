require('helpers')
require('plugins_setup.lsp_attach')

function LspSetup(use)

 use {
    -- https://github.com/hrsh7th/nvim-cmp
    "hrsh7th/cmp-nvim-lsp",
    config = function()
    end,
  }

  use {
    -- https://github.com/
    "hrsh7th/cmp-buffer",
    config = function()
    end,
  }

  use {
    -- https://github.com/
    "hrsh7th/cmp-path",
    config = function()
    end,
  }

  use {
    -- https://github.com/
    "hrsh7th/cmp-cmdline",
    config = function()
    end,
  }

  use {
    -- https://github.com/
    "saadparwaiz1/cmp_luasnip",
    config = function()
    end,
  }

  use {
    -- https://github.com/j-hui/fidget.nvim
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  }

  use {
    -- https://github.com/SmiteshP/nvim-navic
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  }

  use {
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("null-ls").setup()
    end,
  }

  use {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
        local wk = require("which-key")
        wk.register({ ["<leader>"] = {
          l = {
            name = "LSP",
          },
        } })

        Keymap('n', '<leader>lI', ':Mason<CR>', DefaultKeymapOpts('Mason Info'))
    end,
  }

  use {
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    config = function ()
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        Keymap('n', 'K', vim.lsp.buf.hover, DefaultKeymapOpts('Symbol Info'))
        Keymap('n', '<leader>lK', vim.lsp.buf.hover, DefaultKeymapOpts('Symbol Info'))
        Keymap('n', 'gD', vim.lsp.buf.declaration, DefaultKeymapOpts('Goto Symbol Declaration'))
        Keymap('n', '<leader>lD', vim.lsp.buf.declaration, DefaultKeymapOpts('Goto Symbol Declaration'))
        Keymap('n', 'gd', vim.lsp.buf.definition, DefaultKeymapOpts('Goto Symbol Definition'))
        Keymap('n', '<leader>ld', vim.lsp.buf.definition, DefaultKeymapOpts('Goto Symbol Definition'))
        Keymap('n', 'gi', vim.lsp.buf.implementation, DefaultKeymapOpts('Goto Symbol Implementation'))
        Keymap('n', '<leader>li', vim.lsp.buf.implementation, DefaultKeymapOpts('Goto Symbol Implementation'))
        Keymap('n', '<leader>lr', vim.lsp.buf.references, DefaultKeymapOpts('Symbol References'))
        Keymap('n', '<leader>lR', vim.lsp.buf.rename, DefaultKeymapOpts('Rename Symbol'))
        Keymap('n', '<leader>lf', vim.lsp.buf.format, DefaultKeymapOpts('Format'))

        -- Keymap('n', '<leader>lf', vim.lsp.buf.formatting, DefaultKeymapOpts('Format'))
        -- vim.keymap.set('n', '<leader>lD', vim.lsp.buf.type_definition, bufopts)
        -- vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, bufopts)

        -- vim.keymap.set('n', '<S-k>', vim.lsp.buf.signature_help, bufopts)
        --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    end
  }

  use {
    "williamboman/mason-lspconfig.nvim",
    -- event = "BufReadPre",
    after = 'nvim-lspconfig',
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
            on_attach = function (client, bufnr)
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
  }

  use {
    -- https://github.com/hrsh7th/nvim-cmp
    "hrsh7th/nvim-cmp",
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
  }

  use {
    -- https://github.com/RRethy/vim-illuminate
    'RRethy/vim-illuminate',
    config = function()
    end,
  }

  use {
    -- https://github.com/weilbith/nvim-code-action-menu
    'weilbith/nvim-code-action-menu',
    config = function()
      Keymap('n', '<leader>la', ':CodeActionMenu<CR>', DefaultKeymapOpts('Code action'))
    end,
  }

  use {
    -- https://github.com/kosayoda/nvim-lightbulb
    'kosayoda/nvim-lightbulb',
    event = "BufReadPre",
    requires = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('nvim-lightbulb').setup({
        autocmd = {
          enabled = true
        }
      })
    end,
  }

   use {
      'folke/trouble.nvim',
      config = function()
        local trouble = require("trouble")
        trouble.setup()

        Keymap('n', '<leader>llt', '<cmd>Trouble diagnostics toggle<cr>', DefaultKeymapOpts('Diagnostics'))
        Keymap('n', '<leader>llb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', DefaultKeymapOpts('Buffer Diagnostics'))
        Keymap('n', '<leader>lls', '<cmd>Trouble symbols toggle focus=false<cr>', DefaultKeymapOpts('Toggle Symbols'))
        Keymap('n', '<leader>llL', '<cmd>Trouble loclist toggle<cr>', DefaultKeymapOpts('Location List'))
        Keymap('n', '<leader>llq', '<cmd>Trouble qflist toggle<cr>', DefaultKeymapOpts('Quickfix List'))
        Keymap(
          'n',
          '<leader>lll',
          '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
          DefaultKeymapOpts('Toggle LSP Definitions / references / ...'))
      end,
    }

end
