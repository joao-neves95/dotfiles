function CodeEditSetup(use)
    use {
      'numToStr/Comment.nvim',
      config = function()
        local wk = require("which-key")
        wk.register({ ["<leader>"] = {
          c = {
            name = "Comment",
          },
        } })

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
    }

    use {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup {}
      end,
    }
end
