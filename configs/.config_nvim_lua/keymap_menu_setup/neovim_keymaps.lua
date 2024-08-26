function SetupGlobalNvimKeymaps()
    RegisterWhichKeyGroup('n', 'Neovim')

    Keymap('n', '<leader>nh', ':checkhealth<CR>', DefaultKeymapOpts('Check health'))
    Keymap('n', '<leader>nm', ':messages<CR>', DefaultKeymapOpts('Messages'))
end
