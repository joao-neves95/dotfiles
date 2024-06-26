require('helpers')

RunNVimCmd("let mapleader = ' '")
RunNVimCmd("let maplocalleader = ' '")
Keymap('i', 'jf', '<Esc>', DefaultKeymapOpts('Exit insert mode'))
Keymap('n', '<C-s>', ':w<CR>', DefaultKeymapOpts('Save'))
Keymap('n', '<leader>w', ':w<CR>', DefaultKeymapOpts('Save'))
Keymap('n', '<leader>q', ':q<CR>', DefaultKeymapOpts('Exit Neovim'))

-- Window movement
Keymap('n', '<C-h>', '<C-w>h', DefaultKeymapOpts())
Keymap('n', '<C-j>', '<C-w>j', DefaultKeymapOpts())
Keymap('n', '<C-k>', '<C-w>k', DefaultKeymapOpts())
Keymap('n', '<C-l>', '<C-w>l', DefaultKeymapOpts())
--

-- Window resizing
Keymap('n', '<C-Up>', ':resize -2<CR>', DefaultKeymapOpts())
Keymap('n', '<C-Down>', ':resize +2<CR>', DefaultKeymapOpts())
Keymap('n', '<C-Left>', ':vertical resize -2<CR>', DefaultKeymapOpts())
Keymap('n', '<C-Right>', ':vertical resize +2<CR>', DefaultKeymapOpts())
--

-- Buffer movement
require("which-key").register({ ["<leader>"] = { b = {
   name = "Buffer",
  },
} })

Keymap('n', '<leader>bc', ':bprevious <bar> :bdelete #<CR>', DefaultKeymapOpts('Close Buffer'))
Keymap('n', '<leader>bp', ':bprevious <bar>', DefaultKeymapOpts('Previous Buffer'))
--

-- Move lines
Keymap('n', '<A-j>', ':m .+1<CR>==', DefaultKeymapOpts('Move line up'))
Keymap('v', '<A-j>', ":m '>+1<CR>gv-gv", DefaultKeymapOpts('Move line up'))
Keymap('n', '<A-k>', ':m .-2<CR>==', DefaultKeymapOpts('Move line down'))
Keymap('v', '<A-k>', ":m '<-2<CR>gv-gv", DefaultKeymapOpts('Move line up'))
--

-- Copy/paste from clipboard
Keymap({'n', 'x'}, '<C-c>', '"+y', DefaultKeymapOpts('Copy from clipboard'))
Keymap({'n', 'x'}, '<C-v>', '"+p', DefaultKeymapOpts('Paste from clipboard'))
--

require("which-key").register({ ["<leader>"] = { n = {
   name = "Neovim",
 },
} })

Keymap('n', '<leader>nh', ':checkhealth<CR>', DefaultKeymapOpts('Check health'))
