function CodeEditSetup(use)
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup {
          opleader = {
            line = '<leader>/',
            block = '<leader>#',
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
