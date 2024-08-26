function SetupGlobalToolsKeymaps()
    RegisterWhichKeyGroup('t', 'Tools')

    RegisterWhichKeyGroup('tp', 'Packages')

    RegisterWhichKeyGroup('tt', 'Terminal')
    Keymap('n', '<leader>tN', ':terminal<CR>', DefaultKeymapOpts('Neovim'))
end

function SetupLazyKeymaps()
    Keymap('n', '<leader>tph', '<cmd>:Lazy home<CR>', DefaultKeymapOpts('Lazy - Home'))
    Keymap('n', '<leader>tpp', '<cmd>:Lazy profile<CR>', DefaultKeymapOpts('Lazy - Profiling'))
    Keymap('n', '<leader>tpu', '<cmd>:Lazy update<CR>', DefaultKeymapOpts('Lazy - Update'))
    Keymap('n', '<leader>tps', '<cmd>:Lazy sync<CR>', DefaultKeymapOpts('Lazy - Sync'))
    Keymap('n', '<leader>tpc', '<cmd>:Lazy clean<CR>', DefaultKeymapOpts('Lazy - Clean'))
    Keymap('n', '<leader>tpx', '<cmd>:Lazy clear<CR>', DefaultKeymapOpts('Lazy - Clear Tasks'))
    Keymap('n', '<leader>tpr', '<cmd>:Lazy restore<CR>', DefaultKeymapOpts('Lazy - Restore'))
    Keymap('n', '<leader>tpH', '<cmd>:Lazy health<CR>', DefaultKeymapOpts('Lazy - Health'))
end

function SetupMasonKeymaps()
    Keymap('n', '<leader>tpI', ':Mason<CR>', DefaultKeymapOpts('Mason Info'))
end

function SetupToggletermKeymaps(lazygit_term)
    Keymap('n', '<leader>tth', ':ToggleTerm size=10 dir=~ direction=horizontal<CR>',
        DefaultKeymapOpts('Toggle Horizontal'))
    Keymap('n', '<leader>ttf', ':ToggleTerm dir=~ direction=float<CR>', DefaultKeymapOpts('Toggle Floating'))
    Keymap('n', '<leader>ttv', ':ToggleTerm size=40 dir=~ direction=vertical<CR>',
        DefaultKeymapOpts('Toggle Vertical'))
    Keymap('n', '<leader>ttg', function() lazygit_term:toggle() end, DefaultKeymapOpts('Toggle Lazygit'))
end

function SetupDotnetKeymaps()
    RegisterWhichKeyGroup('ln', 'Dotnet')

    Keymap('n', '<leader>lnn', ':DotnetUI new_item<cr>', DefaultKeymapOpts('Add new item template'))
    Keymap('n', '<leader>lnf', ':DotnetUI file bootstrap<cr>', DefaultKeymapOpts('Add new cs file'))
    Keymap('n', '<leader>lnp', ':DotnetUI project package add<cr>', DefaultKeymapOpts('Add a Nuget package'))
    Keymap('n', '<leader>lnr', ':DotnetUI project package remove<cr>', DefaultKeymapOpts('Remove a Nuget package'))
    Keymap('n', '<leader>lnP', ':DotnetUI project reference add<cr>', DefaultKeymapOpts('Add project reference'))
    Keymap('n', '<leader>lnR', ':DotnetUI project package remove<cr>', DefaultKeymapOpts('Remove a project reference'))
end
