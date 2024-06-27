require('helpers')

RunNVimCmd("let mapleader = ' '")
RunNVimCmd("let maplocalleader = ' '")

require('plugins_setup')
require('lua.global_keymaps')

vim.cmd([[
  augroup lazy_user_config
    autocmd!
    autocmd BufWritePost ./plugins_setup/init.lua source <afile> | LazySync
  augroup end
]])

-- Links:
---- https://neovim.io/doc/user/lua-guide.html#:~:text=This%20should%20be%20placed%20in,vim%20and%20Vimscript%20in%20init.
