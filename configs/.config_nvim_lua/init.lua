require('plugins')
require('keymaps')

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync | PackerCompile profile=true
  augroup end
]])

-- Links:
---- https://neovim.io/doc/user/lua-guide.html#:~:text=This%20should%20be%20placed%20in,vim%20and%20Vimscript%20in%20init.
