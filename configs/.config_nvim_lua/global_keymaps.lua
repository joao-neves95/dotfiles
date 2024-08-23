require('helpers')

RunNVimCmd("let mapleader = ' '")
RunNVimCmd("let maplocalleader = ' '")

-- TODO: Organize each group by creating functions.

RegisterWhichKeyGroup('f', 'File')
Keymap('i', 'jf', '<Esc>', DefaultKeymapOpts('Exit insert mode'))
Keymap('n', '<leader>q', ':q<CR>', DefaultKeymapOpts('Close window'))
Keymap('n', '<leader>fq', ':q<CR>', DefaultKeymapOpts('Close window'))
Keymap('n', '<C-s>', ':w<CR>', DefaultKeymapOpts('Save'))
Keymap('n', '<leader>w', ':w<CR>', DefaultKeymapOpts('Save'))
Keymap('n', '<leader>fw', ':w<CR>', DefaultKeymapOpts('Save (C-s)'))
Keymap('n', '<leader>fc', ':bprevious <bar> :bdelete #<CR>', DefaultKeymapOpts('Close Buffer'))

RegisterWhichKeyGroup('g', 'Go')

-- Window movement
RegisterWhichKeyGroup('gw', 'Window')
Keymap('n', '<C-h>', '<C-w>h', DefaultKeymapOpts('Jump to left window'))
Keymap('n', '<leader>gwh', '<C-w>h', DefaultKeymapOpts('Left (C-h)'))
Keymap('n', '<C-j>', '<C-w>j', DefaultKeymapOpts('Jump to down window'))
Keymap('n', '<leader>gwj', '<C-w>j', DefaultKeymapOpts('Down (C-j)'))
Keymap('n', '<C-k>', '<C-w>k', DefaultKeymapOpts('Jump to upper window'))
Keymap('n', '<leader>gwk', '<C-w>k', DefaultKeymapOpts('Upper (C-k)'))
Keymap('n', '<C-l>', '<C-w>l', DefaultKeymapOpts('Jump to right window'))
Keymap('n', '<leader>gwl', '<C-w>l', DefaultKeymapOpts('Right (C-l)'))
--

-- Window resizing
Keymap('n', '<C-Up>', ':resize -2<CR>', DefaultKeymapOpts())
Keymap('n', '<C-Down>', ':resize +2<CR>', DefaultKeymapOpts())
Keymap('n', '<C-Left>', ':vertical resize -2<CR>', DefaultKeymapOpts())
Keymap('n', '<C-Right>', ':vertical resize +2<CR>', DefaultKeymapOpts())
--

RegisterWhichKeyGroup('n', 'Neovim')
Keymap('n', '<leader>nh', ':checkhealth<CR>', DefaultKeymapOpts('Check health'))
Keymap('n', '<leader>nm', ':messages<CR>', DefaultKeymapOpts('Messages'))

RegisterWhichKeyGroup('e', 'Edit')
Keymap('n', '<C-z>', ':u<CR>', DefaultKeymapOpts('Undo'))
Keymap('n', '<leader>eu', ':u<CR>', DefaultKeymapOpts('Undo (C-z)'))
-- Copy/paste from clipboard
Keymap({ 'n', 'x' }, '<C-c>', '"+y', DefaultKeymapOpts('Copy from clipboard'))
Keymap({ 'n', 'x' }, '<leader>ec', '"+y', DefaultKeymapOpts('Copy from clipboard (C-c)'))
Keymap({ 'n', 'x' }, '<C-p>', '"+p', DefaultKeymapOpts('Paste from clipboard'))
Keymap({ 'n', 'x' }, '<leader>ep', '"+p', DefaultKeymapOpts('Paste from clipboard (C-p)'))
--
RegisterWhichKeyGroup('ef', 'Find')
RegisterWhichKeyGroup('efb', 'Edit Bookmarks')

-- Move lines
Keymap('n', '<A-j>', ':m .+1<CR>==', DefaultKeymapOpts('Move line up'))
Keymap('v', '<A-j>', ":m '>+1<CR>gv-gv", DefaultKeymapOpts('Move line up'))
Keymap('n', '<A-k>', ':m .-2<CR>==', DefaultKeymapOpts('Move line down'))
Keymap('v', '<A-k>', ":m '<-2<CR>gv-gv", DefaultKeymapOpts('Move line up'))
--

RegisterWhichKeyGroup('c', 'Comment')

RegisterWhichKeyGroup('p', 'Packages')

RegisterWhichKeyGroup('l', 'Code & LSP')

RegisterWhichKeyGroup('ll', 'Diagnostics')

RegisterWhichKeyGroup('t', 'Terminal')
Keymap('n', '<leader>tN', ':terminal<CR>', DefaultKeymapOpts('Neovim'))

RegisterWhichKeyGroup('x', 'Useless')
