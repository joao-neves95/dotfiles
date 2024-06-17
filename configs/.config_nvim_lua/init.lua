require('plugins_setup')
require('global_keymaps')

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins_setup/init.lua source <afile> | PackerSync | PackerCompile
  augroup end
]])

-- Links:
---- https://neovim.io/doc/user/lua-guide.html#:~:text=This%20should%20be%20placed%20in,vim%20and%20Vimscript%20in%20init.
