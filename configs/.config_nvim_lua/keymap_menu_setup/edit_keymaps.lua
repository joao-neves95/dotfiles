function SetupGlobalEditKeymaps()
    RegisterWhichKeyGroup('e', 'Edit')

    Keymap('n', '<C-z>', ':u<CR>', DefaultKeymapOpts('Undo'))
    Keymap('n', '<leader>eu', ':u<CR>', DefaultKeymapOpts('Undo (C-z)'))

    -- Copy/paste from clipboard
    Keymap({ 'n', 'x' }, '<C-c>', '"+y', DefaultKeymapOpts('Copy from clipboard'))
    Keymap({ 'n', 'x' }, '<leader>ec', '"+y', DefaultKeymapOpts('Copy from clipboard (C-c)'))

    Keymap({ 'n', 'x' }, '<C-p>', '"+p', DefaultKeymapOpts('Paste from clipboard'))
    Keymap({ 'n', 'x' }, '<leader>ep', '"+p', DefaultKeymapOpts('Paste from clipboard (C-p)'))
    --

    -- Indentation
    Keymap('v', '<', '<gv', DefaultKeymapOpts('Indent left'))
    Keymap('v', '>', '>gv', DefaultKeymapOpts('Indent right'))
    --

    -- Move lines
    Keymap('n', '<A-k>', ':m .-2<CR>==', DefaultKeymapOpts('Move line up'))
    Keymap('n', '<A-j>', ':m .+1<CR>==', DefaultKeymapOpts('Move line down'))

    Keymap('v', '<A-k>', ":m '<-2<CR>gv-gv", DefaultKeymapOpts('Move line up'))
    Keymap('v', '<A-j>', ":m '>+1<CR>gv-gv", DefaultKeymapOpts('Move line down'))
    --

    RegisterWhichKeyGroup('ef', 'Find')
    RegisterWhichKeyGroup('eb', 'Bookmarks')

    RegisterWhichKeyGroup('c', 'Comment')
end

function SetupTelescopeKeymaps(telescope, telescope_builtin)
    Keymap('n', '<leader>eff', telescope_builtin.find_files, DefaultKeymapOpts('Find file'))
    Keymap('n', 'leader>efg', telescope_builtin.git_files, DefaultKeymapOpts('Find git files'))
    Keymap('n', '<leader>efl', telescope_builtin.live_grep, DefaultKeymapOpts('Live Grep search'))
    Keymap('n', '<C-f>', telescope_builtin.live_grep, DefaultKeymapOpts('Live search'))
    Keymap('n', '<leader>efa', telescope_builtin.buffers, DefaultKeymapOpts('Find opened file'))
    Keymap('n', '<leader>efh', telescope_builtin.help_tags, DefaultKeymapOpts('Helper tags'))

    Keymap('n', '<leader>efp', telescope.extensions.projects.projects,
        DefaultKeymapOpts('In Projects'))

    Keymap('n', '<leader>eU', "<cmd>Telescope undo<cr>", DefaultKeymapOpts('Undo Tree'))
end

function SetupTelescopeBookmarkKeymaps(telescope)
    Keymap('n', '<leader>ebs', telescope.extensions.bookmarks.list,
        DefaultKeymapOpts('Search'))
end

function SetupBookmarkKeymaps(bookmarks)
    Keymap('n', '<leader>ebb', bookmarks.bookmark_toggle,
        DefaultKeymapOpts('Add or remove bookmark at current line'))
    Keymap('n', '<leader>ebi', bookmarks.bookmark_ann,
        DefaultKeymapOpts('Add or edit mark annotation at current line'))
    Keymap('n', '<leader>ebc', bookmarks.bookmark_clean,
        DefaultKeymapOpts('Clean all marks in local buffer'))
    Keymap('n', '<leader>ebn', bookmarks.bookmark_next,
        DefaultKeymapOpts('Jump to next mark in local buffer'))
    Keymap('n', '<leader>ebp', bookmarks.bookmark_prev,
        DefaultKeymapOpts('Jump to previous mark in local buffer'))
    Keymap('n', '<leader>ebl', bookmarks.bookmark_list,
        DefaultKeymapOpts('Show marked file list in quickfix window'))
    Keymap('n', '<leader>ebx', bookmarks.bookmark_clear_all, DefaultKeymapOpts('Removes all bookmarks'))
end
