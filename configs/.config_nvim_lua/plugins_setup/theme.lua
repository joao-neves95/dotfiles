require('helpers')

function SetTheme(name)
    if name == 'neon' then
        return {{
            -- https://github.com/rafamadriz/neon
            "rafamadriz/neon",
            config = function()
                RunNVimCmd('colorscheme neon')
            end
        }}
    elseif name == 'iceberg' then
        return {{
            'cocopon/iceberg.vim',
            config = function()
                RunNVimCmd('colorscheme neon')
            end
        }}
    end
end
