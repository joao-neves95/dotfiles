require('helpers')

function SetTheme(use, name)
  if name == 'neon' then
    use {
      -- https://github.com/rafamadriz/neon
      "rafamadriz/neon",
      config = function()
        Execute('colorscheme neon')
      end
    }

  elseif name == 'iceberg' then
    use {
      'cocopon/iceberg.vim',
      config = function()
        Execute('colorscheme neon')
      end
    }
  end
end

--- Others to check:
-- https://github.com/olimorris/onedarkpro.nvim
-- https://github.com/catppuccin/nvim
-- https://github.com/marko-cerovac/material.nvim
-- https://github.com/rmehri01/onenord.nvim
-- https://github.com/NTBBloodbath/doom-one.nvim
-- https://github.com/Mofiqul/dracula.nvim
