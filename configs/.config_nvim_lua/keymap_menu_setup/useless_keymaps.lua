function SetupGlobalUselessKeymaps()
    RegisterWhichKeyGroup('x', 'Useless')
end

function SetupCellularAutomaton()
    Keymap('n', '<leader>xr', '<cmd>CellularAutomaton make_it_rain<CR>', DefaultKeymapOpts('CellularAutomaton - Rain'))
    Keymap('n', '<leader>xg', '<cmd>CellularAutomaton game_of_life<CR>',
        DefaultKeymapOpts('CellularAutomaton - Game of Life'))
end
