function SyntaxSetup(use)

    use {
      -- https://github.com/nvim-treesitter/nvim-treesitter
      'nvim-treesitter/nvim-treesitter',
      run = function()
        require('nvim-treesitter.configs').setup({
          auto_install = true,
          highlight = {
            enable = true,
          },
          ensure_installed = "all",
        })

        local ts_update = require('nvim-treesitter.install').update()
        ts_update()
      end,
    }

  use {
    -- https://github.com/HiPhish/rainbow-delimiters.nvim
    'HiPhish/rainbow-delimiters.nvim',
  }

end
