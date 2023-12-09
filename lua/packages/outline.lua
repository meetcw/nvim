local use = require('straight').use
local keys = require('keys')
use {
  'simrat39/symbols-outline.nvim',
  setup = function()
    keys.set_leader_key(
      {
        w = {
          name = '+Window',
          s = {[[<cmd>SymbolsOutline<cr>]], 'Outline'}
        }
      },
      {noremap = true, silent = true}
    )

    vim.g.symbols_outline = {
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = false, -- experimental
      position = 'right',
      relative_width = false,
      width = 40,
      auto_close = true,
      keymaps = {
        close = 'q',
        goto_location = '<Cr>',
        focus_location = 'o',
        hover_symbol = '<C-space>',
        rename_symbol = 'r',
        code_actions = 'a'
      },
      lsp_blacklist = {}
    }
  end
}
