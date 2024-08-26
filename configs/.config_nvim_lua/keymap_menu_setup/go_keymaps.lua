function SetupGlobalGoKeymaps()
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
end

function SetupGxKeymaps()
    RegisterWhichKeyKeyMap('n', '<leader>gl', ':normal gx<CR>', 'Open link under cursor')
end

function SetupBufferlineKeymaps()
    -- Cycle buffers.
    Keymap('n', '<S-h>', ':BufferLineCyclePrev<CR>', DefaultKeymapOpts())
    Keymap('n', '<S-l>', ':BufferLineCycleNext<CR>', DefaultKeymapOpts())
    --

    -- Move the buffers.
    Keymap('n', '<C-S-h>', ':BufferLineMovePrev<CR>', DefaultKeymapOpts())
    Keymap('n', '<C-S-l>', ':BufferLineMoveNext<CR>', DefaultKeymapOpts())
    --
end
