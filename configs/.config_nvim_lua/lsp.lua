require('helpers')
require('lsp_attach')

function LspSetup(use)
  use {
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    -- https://github.com/alpha2phi/neovim-for-beginner/blob/11-lsp/lua/config/lsp/keymaps.lua
  }

  use {
    -- https://github.com/ms-jpq/coq_nvim
    "ms-jpq/coq_nvim",
    requires = { 'ms-jpq/coq.artifacts', 'ms-jpq/coq.thirdparty' },
    run = { 'python3 -m coq deps', ':COQdeps' },
    config = function()
      vim.g.coq_settings = { auto_start = 'shut-up' }
    end,
  }

  use {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()

      Keymap('n', '<leader>lI', ':Mason<CR>', DefaultKeymapOpts('Mason Info'))
    end,
  }

  use {
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
    disable = true,
  }

  use {
    "williamboman/mason-lspconfig.nvim",
    -- event = "BufReadPre",
    after = 'nvim-lspconfig',
    config = function()
      require("mason-lspconfig").setup()

      require("packer").loader("coq_nvim coq.artifacts")
      require('coq').Now()
      local lspconfig = require('lspconfig')

      require("mason-lspconfig").setup_handlers {
        function(server_name)
          lspconfig[server_name].setup(require('coq').lsp_ensure_capabilities({
            on_atach = OnLspAttach,
            flags = {
              debounce_text_changes = 150
            },
          }))
        end
      }

      -- Mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      -- vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, DefaultKeymapOpts())
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, DefaultKeymapOpts())
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, DefaultKeymapOpts())
      -- vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, DefaultKeymapOpts())
    end,
  }

  use {
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("null-ls").setup()
    end,
  }

end
