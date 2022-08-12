Execute = vim.api.nvim_command
Keymap = vim.api.nvim_set_keymap

function DefaultKeymapOpts(description)
  local opts = { noremap = true, silent = true }

  if description ~= nil then
    opts['desc'] = description
  end

  return opts
end
