function SearchSetup(use)

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      require('telescope').load_extension('undo')
      require('telescope').load_extension('projects')

      Keymap('n', '<leader>u', "<cmd>Telescope undo<cr>", DefaultKeymapOpts('Undo Tree'))

      local builtin = require('telescope.builtin')

      local wk = require("which-key")
        wk.register({ ["<leader>"] = {
        f = {
          name = "Find",
        },
      } })

      Keymap('n', '<leader>ff', builtin.find_files, DefaultKeymapOpts('Find in all files'))
      Keymap('n', 'leader>fg', builtin.git_files, DefaultKeymapOpts('Find in git files'))
      Keymap('n', '<leader>fl', builtin.live_grep, DefaultKeymapOpts('Live search'))
      Keymap('n', '<C-f>', builtin.live_grep, DefaultKeymapOpts('Live search'))
      Keymap('n', '<leader>fb', builtin.buffers, DefaultKeymapOpts('Find in buffers'))
      Keymap('n', '<leader>fh', builtin.help_tags, DefaultKeymapOpts('Helper tags'))

      Keymap('n', '<leader>fp', builtin.help_tags, DefaultKeymapOpts('Projects'))
    end,
  }

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- Manual mode doesn't automatically change your root directory, so you have
        -- the option to manually do so using `:ProjectRoot` command.
        manual_mode = false,

        -- All the patterns used to detect root dir, when **"pattern"** is in
        -- detection_methods
        patterns = { ".git", "README.md", "Makefile", "package.json", "*.sln", "Cargo.toml" },

        -- Show hidden files in telescope
        show_hidden = true,

        -- What scope to change the directory, valid options are
        -- * global (default)
        -- * tab
        -- * win
        scope_chdir = 'global',
      }
   end
  }

end
