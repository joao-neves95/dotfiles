RunNVimCmd = vim.api.nvim_command
RunVimCmd = vim.cmd
Keymap = vim.keymap.set

function DefaultKeymapOpts(description)
    local opts = { noremap = true, silent = true }

    if description ~= nil then
        opts['desc'] = description
    end

    return opts
end

function RegisterWhichKeyGroup(group_key, group_name)
    local group_config = {}
    group_config[group_key] = {
        name = group_name,
    }

    require("which-key").register({
        ["<leader>"] = group_config
    })
end

---
--- Extend a table to be able to use overleaded operators.
--- Add: `Extend(my_table) + another_table + yet_another_table`
---
---@param _table table
---@return table
function ExtendTable(_table)
    -- Docs: https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f
    return setmetatable(
        _table,
        {
            __add = function(original, new)
                for i = 1, #new do
                    TableAdd(original, new[i])
                end

                return original
            end
        }
    )
end

function TableAdd(_table, item)
    table.insert(_table, item)
end

function TableAddRet(_table, item)
    TableAdd(_table, item)

    return _table
end
