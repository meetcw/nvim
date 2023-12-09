local use = require('straight').use
local keys = require('keys')
use {
  'akinsho/toggleterm.nvim',
  setup = function()
    keys.set_leader_key(
      {
        w = {
          name = '+Window',
          t = {
            [[<cmd>ToggleTerm<cr>]],
            'Toggle Termianl'
          }
        }
      },
      {noremap = true, silent = true}
    )
  end,
  config = function()
    require('toggleterm').setup(
      {
        open_mapping = [[<c-t>]],
        -- hide_numbers = true, -- hide the number column in toggleterm buffers
        -- shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true,
        persist_size = false,
        direction = 'float', -- 'vertical' | 'horizontal' | 'window' | 'float'
        float_opts = {
          border = 'single', --'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
          winblend = 0,
          highlights = {
            border = 'NONE',
            background = 'NONE'
          }
        }
      }
    )
  end
}
