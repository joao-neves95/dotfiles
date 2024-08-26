require('helpers')

require('keymap_menu_setup.file_keymaps')
require('keymap_menu_setup.edit_keymaps')
require('keymap_menu_setup.code_edit_keymaps')
require('keymap_menu_setup.tools_keymaps')
require('keymap_menu_setup.neovim_keymaps')
require('keymap_menu_setup.go_keymaps')
require('keymap_menu_setup.useless_keymaps')

RunNVimCmd("let mapleader = ' '")
RunNVimCmd("let maplocalleader = ' '")

SetupGlobalFileKaymaps();
SetupGlobalGoKeymaps();
SetupGlobalEditKeymaps();
SetupGlobalCodeEditKeymaps()
SetupGlobalToolsKeymaps();
SetupGlobalNvimKeymaps();
SetupGlobalUselessKeymaps();
