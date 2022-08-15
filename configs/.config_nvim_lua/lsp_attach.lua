function OnLspAttach(client, bufnr)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  Execute("set omnifunc=v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- local bufopts = { noremap = true, silent = true, buffer = bufnr }
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<S-k>', vim.lsp.buf.signature_help, bufopts)
  --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --vim.keymap.set('n', '<leader>wl', function()
    --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --end, bufopts)
  -- vim.keymap.set('n', '<leader>lD', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end
