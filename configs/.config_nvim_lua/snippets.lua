function SnippetsSetup(use)
  use {
      'L3MON4D3/LuaSnip',
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
      end,
    }
end
