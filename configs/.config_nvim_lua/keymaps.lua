require('helpers')

Execute("let mapleader = ' '")
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

-- Move lines
Keymap('n', '<A-j>', ':m .+1<CR>==', DefaultKeymapOpts('Move line up'))
Keymap('v', '<A-j>', ":m '>+1<CR>gv-gv", DefaultKeymapOpts('Move line up'))
Keymap('n', '<A-k>', ':m .-2<CR>==', DefaultKeymapOpts('Move line down'))
Keymap('v', '<A-k>', ":m '<-2<CR>gv-gv", DefaultKeymapOpts('Move line up'))
--

Keymap('n', '<leader>nh', ':checkhealth<CR>', DefaultKeymapOpts('Check health'))
