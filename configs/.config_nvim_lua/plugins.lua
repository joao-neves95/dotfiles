-- Links
---- https://dotfyle.com

require('helpers')
require('code_edit')
require('lsp')
require('snippets')
require('theme')

-- Auto-install Packer if needed.
local fn = vim.fn

local packer_bootstrap
local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  Execute 'packadd packer.nvim'
end
---

vim.cmd('packadd packer.nvim')

require('packer').startup({
  function(use)

    use {
      'folke/which-key.nvim',
      config = function()
        -- TODO: Add keymap for .
        require("which-key").setup()
      end,
    }

    --[[ use {
      '',
      config = function()
      end,
    } ]]

    -- https://github.com/wbthomason/packer.nvim
    use {
      'wbthomason/packer.nvim',
      config = function()
        local wk = require("which-key")
        wk.register({ ["<leader>"] = {
          p = {
            name = "Packer",
          },
        } })

        Keymap('n', '<leader>pS', ':PackerStatus<CR>', DefaultKeymapOpts('Status'))
        Keymap('n', '<leader>pp', ':PackerProfile<CR>', DefaultKeymapOpts('Profile'))
        Keymap('n', '<leader>pi', ':PackerInstall<CR>', DefaultKeymapOpts('Install'))
        Keymap('n', '<leader>pu', ':PackerUpdate<CR>', DefaultKeymapOpts('Update'))
        Keymap('n', '<leader>pc', ':PackerCompile<CR>', DefaultKeymapOpts('Compile'))
        Keymap('n', '<leader>ps', ':PackerSync<CR>', DefaultKeymapOpts('Sync'))
      end,
    }

    use {
      -- https://github.com/nvim-tree/nvim-tree.lua
      'nvim-tree/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icons
      },
      config = function()
        require("nvim-tree").setup()

        Keymap('n', '<leader>e', ':NvimTreeToggle<CR>', DefaultKeymapOpts('Explorer'))
      end,
    }

    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} },
      config = function()
        local builtin = require('telescope.builtin')

        local wk = require("which-key")
        wk.register({ ["<leader>"] = {
          f = {
            name = "Find",
          },
        } })

        Keymap('n', '<leader>ff', builtin.find_files, DefaultKeymapOpts('Find in all files'))
        Keymap('n', '<C-f>', builtin.git_files, DefaultKeymapOpts('Find in git files'))
        Keymap('n', '<leader>fl', builtin.git_files, DefaultKeymapOpts('Find in git files'))
        Keymap('n', '<leader>fl', builtin.live_grep, DefaultKeymapOpts('Live search'))
        Keymap('n', '<leader>fb', builtin.buffers, DefaultKeymapOpts('Find in buffers'))
        Keymap('n', '<leader>fh', builtin.help_tags, DefaultKeymapOpts('Helper tags'))
      end,
    }

    use {
      'mbbill/undotree',
      config = function()
        Keymap('n', '<leader>u', vim.cmd.UndotreeToggle, DefaultKeymapOpts('Toggle Undotree'))
      end,
    }

    use {
      -- (tabs)
      -- https://github.com/akinsho/bufferline.nvim
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require("bufferline").setup()

        -- Cycle buffers.
        Keymap('n', '<S-h>', ':BufferLineCyclePrev<CR>', DefaultKeymapOpts())
        Keymap('n', '<S-l>', ':BufferLineCycleNext<CR>', DefaultKeymapOpts())
        -- Move the buffers.
        Keymap('n', '<C-S-h>', ':BufferLineMovePrev<CR>', DefaultKeymapOpts())
        Keymap('n', '<C-S-l>', ':BufferLineMoveNext<CR>', DefaultKeymapOpts())
      end,
    }

    use {
      -- https://github.com/nvim-lualine/lualine.nvim
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require('lualine').setup {
          options = {
            theme = 'nord'
          },
        }
      end,
    }

    -- use {
    --   -- (no mouse support for now)
    --   -- https://github.com/petertriho/nvim-scrollbar
    --   "petertriho/nvim-scrollbar",
    --   requires = { 'kevinhwang91/nvim-hlslens', opt = true },
    --   config = function()
    --     require("scrollbar").setup()
    --     require("scrollbar.handlers.search").setup()
    --   end
    -- }
    use {
      -- https://github.com/dstein64/nvim-scrollview
      'dstein64/nvim-scrollview',
      config = function()
        require('scrollview').setup()
      end,
    }

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
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
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

    CodeEditSetup(use)
    LspSetup(use)
    SnippetsSetup(use)
    SetTheme(use, 'neon')

    use {
      'eandrju/cellular-automaton.nvim',
      config = function()
        local wk = require("which-key")
        wk.register({ ["<leader>"] = {
          x = {
            name = "Useless",
          },
        } })

        Keymap('n', '<leader>xr', '<cmd>CellularAutomaton make_it_rain<CR>', DefaultKeymapOpts('CellularAutomaton - Rain'))
        Keymap('n', '<leader>xg', '<cmd>CellularAutomaton game_of_life<CR>', DefaultKeymapOpts('CellularAutomaton - Game of Life'))
      end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    --display = {
    --open_fn = require('packer.util').float({ border = 'single' }),
    --},
    profile = {
      enable = true,
      threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
    }
  }
})

--[[ Specifying plugins (notes)
use {
  'myusername/example',        -- The plugin location string
  -- The following keys are all optional
  disable = boolean,           -- Mark a plugin as inactive
  as = string,                 -- Specifies an alias under which to install the plugin
  installer = function,        -- Specifies custom installer. See "custom installers" below.
  updater = function,          -- Specifies custom updater. See "custom installers" below.
  after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
  rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
  opt = boolean,               -- Manually marks a plugin as optional.
  branch = string,             -- Specifies a git branch to use
  tag = string,                -- Specifies a git tag to use. Supports '*' for "latest tag"
  commit = string,             -- Specifies a git commit to use
  lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
  run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
  requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
  rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
  config = string or function, -- Specifies code to run after this plugin is loaded.
  -- The setup key implies opt = true
  setup = string or function,  -- Specifies code to run before this plugin is loaded.
  -- The following keys all imply lazy-loading and imply opt = true
  cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
  ft = string or list,         -- Specifies filetypes which load this plugin.
  keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
  event = string or list,      -- Specifies autocommand events which load this plugin.
  fn = string or list          -- Specifies functions which load this plugin.
  cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
  module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
                               -- with one of these module names, the plugin will be loaded.
  module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
  requiring a string which matches one of these patterns, the plugin will be loaded.
}
--]]
