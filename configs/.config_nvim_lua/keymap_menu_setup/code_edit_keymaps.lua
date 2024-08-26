function SetupGlobalCodeEditKeymaps()
    RegisterWhichKeyGroup('l', 'Code & LSP')
    RegisterWhichKeyGroup('ll', 'Diagnostics')
end

function SetupLspKeymaps()
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    Keymap('n', 'K', vim.lsp.buf.hover, DefaultKeymapOpts('Symbol Info'))
    Keymap('n', '<leader>lK', vim.lsp.buf.hover, DefaultKeymapOpts('Symbol Info'))
    Keymap('n', 'gD', vim.lsp.buf.declaration, DefaultKeymapOpts('Goto Symbol Declaration'))
    Keymap('n', '<leader>lD', vim.lsp.buf.declaration, DefaultKeymapOpts('Goto Symbol Declaration'))
    Keymap('n', 'gd', vim.lsp.buf.definition, DefaultKeymapOpts('Goto Symbol Definition'))
    Keymap('n', '<leader>ld', vim.lsp.buf.definition, DefaultKeymapOpts('Goto Symbol Definition'))
    Keymap('n', 'gi', vim.lsp.buf.implementation, DefaultKeymapOpts('Goto Symbol Implementation'))
    Keymap('n', '<leader>li', vim.lsp.buf.implementation, DefaultKeymapOpts('Goto Symbol Implementation'))
    Keymap('n', '<leader>lr', vim.lsp.buf.references, DefaultKeymapOpts('Symbol References'))
    Keymap('n', '<leader>lR', vim.lsp.buf.rename, DefaultKeymapOpts('Rename Symbol'))
    Keymap('n', '<leader>lf', vim.lsp.buf.format, DefaultKeymapOpts('Format'))

    -- Keymap('n', '<leader>lf', vim.lsp.buf.formatting, DefaultKeymapOpts('Format'))
    -- vim.keymap.set('n', '<leader>lD', vim.lsp.buf.type_definition, bufopts)
    -- vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, bufopts)

    -- vim.keymap.set('n', '<S-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
end

function SetupCodeActionKeymaps()
    Keymap('n', '<leader>la', ':CodeActionMenu<CR>', DefaultKeymapOpts('Code action'))
end

function SetupTroubleKeymaps()
    Keymap('n', '<leader>llt', '<cmd>Trouble diagnostics toggle<cr>', DefaultKeymapOpts('Diagnostics'))
    Keymap('n', '<leader>llb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        DefaultKeymapOpts('Buffer Diagnostics'))
    Keymap('n', '<leader>lls', '<cmd>Trouble symbols toggle focus=false<cr>',
        DefaultKeymapOpts('Toggle Symbols'))
    Keymap('n', '<leader>llL', '<cmd>Trouble loclist toggle<cr>', DefaultKeymapOpts('Location List'))
    Keymap('n', '<leader>llq', '<cmd>Trouble qflist toggle<cr>', DefaultKeymapOpts('Quickfix List'))
    Keymap(
        'n',
        '<leader>lll',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        DefaultKeymapOpts('Toggle LSP Definitions / references / ...'))
end
