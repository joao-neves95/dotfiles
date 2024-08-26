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

local plugins_spec = ExtendTable(
        { {
            'folke/which-key.nvim',
            event = "VeryLazy",
            config = function()
                require("which-key").setup()

                SetupLazyKeymaps()
            end,
        } })
    + SetTheme('neon')
    + IdeInterfaceSetup()
    + CodeEditSetup()
    + SyntaxSetup()
    + LspSetup()
    + SnippetsSetup()
    + SearchSetup()
    + DebuggerSetup()
    + TestsSetup()
    + { {
        'eandrju/cellular-automaton.nvim',
        lazy = true,
        event = "VeryLazy",
        config = function()
            SetupCellularAutomaton()
        end,
    } }

-- for _,line in ipairs(plugins_spec) do print(table.concat(line)) end
-- for _,line in ipairs(plugins_spec) do print(line) end

require('lazy').setup({ spec = plugins_spec })
