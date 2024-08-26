function SetupGlobalFileKaymaps()
    RegisterWhichKeyGroup('f', 'File')

    local close_window_cmd = ':q<CR>';
    local save_cmd = ':w<CR>';

    Keymap('i', 'jf', '<Esc>', DefaultKeymapOpts('Exit insert mode'))

    Keymap('n', '<leader>q', close_window_cmd, DefaultKeymapOpts('Close window'))
    Keymap('n', '<leader>fq', close_window_cmd, DefaultKeymapOpts('Close window'))

    Keymap('n', '<leader>fc', ':bprevious <bar> :bdelete #<CR>', DefaultKeymapOpts('Close Buffer'))

    Keymap('n', '<C-s>', save_cmd, DefaultKeymapOpts('Save'))
    Keymap('n', '<leader>w', save_cmd, DefaultKeymapOpts('Save'))
    Keymap('n', '<leader>fw', save_cmd, DefaultKeymapOpts('Save (C-s)'))
end
