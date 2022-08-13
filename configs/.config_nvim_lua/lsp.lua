require('helpers')
require('lsp_attach')

function LspSetup(use)
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
    -- https://github.com/neovim/nvim-lspconfig
    'neovim/nvim-lspconfig',
    event = "BufReadPre",
    -- https://github.com/alpha2phi/neovim-for-beginner/blob/11-lsp/lua/config/lsp/keymaps.lua
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
    "williamboman/mason-lspconfig.nvim",
    after = 'nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      local coq = require('coq')

      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          lspconfig[server_name].setup(coq.lsp_ensure_capabilities({
            on_atach = OnLspAttach,
            flags = {
              debounce_text_changes = 150
            },
          }))
        end,
      }
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

  use {
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
  }

  use {
    -- https://github.com/kosayoda/nvim-lightbulb
    'kosayoda/nvim-lightbulb',
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
    -- https://github.com/weilbith/nvim-code-action-menu
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    -- TODO: Register keymap.
  }
end
