require('helpers')
require('plugins_setup.theme')
require('plugins_setup.ide_interface')
require('plugins_setup.code_edit')
require('plugins_setup.syntax')
require('plugins_setup.lsp')
require('plugins_setup.snippets')
require('plugins_setup.search')
require('plugins_setup.debugger')
require('plugins_setup.tests')

-- Auto-install Lazy if needed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)
---

function RegisterLazyKeymaps()
    Keymap('n', '<leader>ph', '<cmd>:Lazy home<CR>', DefaultKeymapOpts('Lazy - Home'))
    Keymap('n', '<leader>pp', '<cmd>:Lazy profile<CR>', DefaultKeymapOpts('Lazy - Profiling'))
    Keymap('n', '<leader>pu', '<cmd>:Lazy update<CR>', DefaultKeymapOpts('Lazy - Update'))
    Keymap('n', '<leader>ps', '<cmd>:Lazy sync<CR>', DefaultKeymapOpts('Lazy - Sync'))
    Keymap('n', '<leader>pc', '<cmd>:Lazy clean<CR>', DefaultKeymapOpts('Lazy - Clean'))
    Keymap('n', '<leader>px', '<cmd>:Lazy clear<CR>', DefaultKeymapOpts('Lazy - Clear Tasks'))
    Keymap('n', '<leader>pr', '<cmd>:Lazy restore<CR>', DefaultKeymapOpts('Lazy - Restore'))
    Keymap('n', '<leader>pH', '<cmd>:Lazy health<CR>', DefaultKeymapOpts('Lazy - Health'))
end

local plugins_spec = ExtendTable(
    {{
        'folke/which-key.nvim',
        event = "VeryLazy",
        config = function()
            require("which-key").setup()

            RegisterLazyKeymaps()
        end,
    }})
    + SetTheme('neon')
    + IdeInterfaceSetup()
    + CodeEditSetup()
    + SyntaxSetup()
    + LspSetup()
    + SnippetsSetup()
    + SearchSetup()
    + DebuggerSetup()
    + TestsSetup()
    + {{
        'eandrju/cellular-automaton.nvim',
        lazy = true,
        event = "VeryLazy",
        config = function()
            Keymap('n', '<leader>xr', '<cmd>CellularAutomaton make_it_rain<CR>', DefaultKeymapOpts('CellularAutomaton - Rain'))
            Keymap('n', '<leader>xg', '<cmd>CellularAutomaton game_of_life<CR>', DefaultKeymapOpts('CellularAutomaton - Game of Life'))
        end,
    }}

-- for _,line in ipairs(plugins_spec) do print(table.concat(line)) end
-- for _,line in ipairs(plugins_spec) do print(line) end

require('lazy').setup( { spec = plugins_spec } )
