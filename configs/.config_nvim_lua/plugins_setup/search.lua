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
                local telescope = require('telescope');

                telescope.load_extension('undo')
                telescope.load_extension('projects')
                telescope.load_extension('bookmarks')

                SetupTelescopeKeymaps(telescope, require('telescope.builtin'));
                SetupTelescopeBookmarkKeymaps(telescope);
            end,
        },

        {
            -- https://github.com/tomasky/bookmarks.nvim
            'tomasky/bookmarks.nvim',
            -- lazy = true,
            event = 'VimEnter',
            config = function()
                local bookmarks = require('bookmarks')

                bookmarks.setup(
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
                        on_attach = function()
                            SetupBookmarkKeymaps(bookmarks);
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
