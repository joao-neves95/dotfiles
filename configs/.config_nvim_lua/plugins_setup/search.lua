function SearchSetup()
    return {
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'debugloop/telescope-undo.nvim',
            },
            lazy = true,
            event = 'VimEnter',
            config = function()
                require('telescope').load_extension('undo')
                require('telescope').load_extension('projects')
                require('telescope').load_extension('bookmarks')

                Keymap('n', '<leader>u', "<cmd>Telescope undo<cr>", DefaultKeymapOpts('Undo Tree'))

                local builtin = require('telescope.builtin')

                Keymap('n', '<leader>ff', builtin.find_files, DefaultKeymapOpts('Find in all files'))
                Keymap('n', 'leader>fg', builtin.git_files, DefaultKeymapOpts('Find in git files'))
                Keymap('n', '<leader>fl', builtin.live_grep, DefaultKeymapOpts('Live search'))
                Keymap('n', '<C-f>', builtin.live_grep, DefaultKeymapOpts('Live search'))
                Keymap('n', '<leader>fa', builtin.buffers, DefaultKeymapOpts('Find in buffers'))
                Keymap('n', '<leader>fh', builtin.help_tags, DefaultKeymapOpts('Helper tags'))

                Keymap('n', '<leader>fp', require('telescope').extensions.projects.projects,
                    DefaultKeymapOpts('In Projects'))
                Keymap('n', '<leader>fB', require('telescope').extensions.bookmarks.list,
                    DefaultKeymapOpts('In Bookmarks'))
            end,
        },

        {
            -- https://github.com/tomasky/bookmarks.nvim
            'tomasky/bookmarks.nvim',
            -- lazy = true,
            event = 'VimEnter',
            config = function()
                require('bookmarks').setup(
                    {
                        -- sign_priority = 8,  --set bookmark sign priority to cover other sign
                        save_file = vim.fn.expand "$HOME/.local/state/.bookmarks", -- bookmarks save file path
                        keywords = {
                            ["@t"] = "✅ ", -- mark annotation startswith @t ,signs this icon as `Todo`
                            ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
                            ["@f"] = "🪛", -- mark annotation startswith @f ,signs this icon as `Fix`
                            ["@n"] = "📝", -- mark annotation startswith @n ,signs this icon as `Note`
                            ["@l"] = "📍", -- mark annotation startswith @n ,signs this icon as `Note`
                        },
                        on_attach = function(bufnr)
                            local bm = require "bookmarks"

                            Keymap('n', '<leader>fbb', bm.bookmark_toggle,
                                DefaultKeymapOpts('Add or remove bookmark at current line'))
                            Keymap('n', '<leader>fbi', bm.bookmark_ann,
                                DefaultKeymapOpts('Add or edit mark annotation at current line'))
                            Keymap('n', '<leader>fbc', bm.bookmark_clean,
                                DefaultKeymapOpts('Clean all marks in local buffer'))
                            Keymap('n', '<leader>fbn', bm.bookmark_next,
                                DefaultKeymapOpts('Jump to next mark in local buffer'))
                            Keymap('n', '<leader>fbp', bm.bookmark_prev,
                                DefaultKeymapOpts('Jump to previous mark in local buffer'))
                            Keymap('n', '<leader>fbl', bm.bookmark_list,
                                DefaultKeymapOpts('Show marked file list in quickfix window'))
                            Keymap('n', '<leader>fbx', bm.bookmark_clear_all, DefaultKeymapOpts('Removes all bookmarks'))
                        end
                    }
                )
            end,
        },

        {
            "ahmedkhalf/project.nvim",
            lazy = true,
            event = 'VimEnter',
            config = function()
                require("project_nvim").setup {
                    -- Manual mode doesn't automatically change your root directory, so you have
                    -- the option to manually do so using `:ProjectRoot` command.
                    manual_mode = false,

                    -- All the patterns used to detect root dir, when **"pattern"** is in
                    -- detection_methods
                    patterns = { ".git", "README.md", "Makefile", "package.json", "*.sln", "Cargo.toml" },

                    -- Show hidden files in telescope
                    show_hidden = true,

                    -- What scope to change the directory, valid options are
                    -- * global (default)
                    -- * tab
                    -- * win
                    scope_chdir = 'global',
                }
            end
        }
    }
end
