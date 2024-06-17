function SearchSetup(use)

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      require('telescope').load_extension('undo')

      Keymap('n', '<leader>u', "<cmd>Telescope undo<cr>", DefaultKeymapOpts('Undo Tree'))

      local builtin = require('telescope.builtin')

      local wk = require("which-key")
        wk.register({ ["<leader>"] = {
        f = {
          name = "Find",
        },
      } })

      Keymap('n', '<leader>ff', builtin.find_files, DefaultKeymapOpts('Find in all files'))
      Keymap('n', '<C-f>', builtin.git_files, DefaultKeymapOpts('Find in git files'))
      Keymap('n', 'leader>fg', builtin.git_files, DefaultKeymapOpts('Find in git files'))
      Keymap('n', '<leader>fl', builtin.git_files, DefaultKeymapOpts('Find in git files'))
      Keymap('n', '<leader>fl', builtin.live_grep, DefaultKeymapOpts('Live search'))
      Keymap('n', '<leader>fb', builtin.buffers, DefaultKeymapOpts('Find in buffers'))
      Keymap('n', '<leader>fh', builtin.help_tags, DefaultKeymapOpts('Helper tags'))
    end,
  }

end
