function TestsSetup()
    return {
        {
            "nvim-neotest/neotest",
            dependencies = {
                "nvim-neotest/nvim-nio",
                "nvim-lua/plenary.nvim",
                "antoinemadec/FixCursorHold.nvim",
                "nvim-treesitter/nvim-treesitter",
                "Issafalcon/neotest-dotnet",
                "rouge8/neotest-rust"
            },
            lazy = true,
            config = function()
                local neotest = require("neotest")

                neotest.setup({
                    adapters = {
                        require("neotest-dotnet")({
                            dap = {
                                -- Extra arguments for nvim-dap configuration
                                -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                                args = { justMyCode = false },
                                -- Enter the name of your dap adapter, the default value is netcoredbg
                                adapter_name = "netcoredbg"
                            },
                            -- Let the test-discovery know about your custom attributes (otherwise tests will not be picked up)
                            -- Note: Only custom attributes for non-parameterized tests should be added here. See the support note about parameterized tests
                            custom_attributes = {
                                xunit = { "MyCustomFactAttribute" },
                                nunit = { "MyCustomTestAttribute" },
                                mstest = { "MyCustomTestMethodAttribute" }
                            },
                            -- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
                            dotnet_additional_args = {
                                "--verbosity detailed"
                            },
                            -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
                            -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
                            --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
                            discovery_root = "project" -- Default
                        }),

                        require("neotest-rust") {
                            args = { "--no-capture" },
                            dap_adapter = "codelldb",
                        }
                    }
                })

                RegisterWhichKeyGroup('T', 'Neotest')
                Keymap('n', '<leader>Tn', function() neotest.run.run() end, DefaultKeymapOpts('Run nearest test'))
                Keymap('n', '<leader>Td', function() neotest.run.run({ strategy = "dap" }) end,
                    DefaultKeymapOpts('Debug nearest test'))
                Keymap('n', '<leader>Tf', function() neotest.run.run(vim.fn.expand("%")) end,
                    DefaultKeymapOpts('Run file'))
            end
        }
    }
end
