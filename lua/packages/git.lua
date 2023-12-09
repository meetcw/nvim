local use = require('straight').use
local keys = require('keys')

use {
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('gitsigns').setup(
      {
        current_line_blame = true,
        numhl = false,
        linehl = false,
        signs = {
          add = {hl = 'GitSignsAdd', text = '█', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn'},
          change = {
            hl = 'GitSignsChange',
            text = '█',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
          },
          delete = {
            hl = 'GitSignsDelete',
            text = '█',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
          },
          topdelete = {
            hl = 'GitSignsDelete',
            text = '█',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
          },
          changedelete = {
            hl = 'GitSignsChange',
            text = '▒',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
          }
        }
      }
    )
  end
}

use(
  {
    'TimUntersberger/neogit',
    dependencies = {'nvim-lua/plenary.nvim'},
    setup = function()
      keys.set_leader_key(
        {
          p = {
            name = '+Project',
            s = {[[<cmd>Neogit<cr>]], 'Git'}
          }
        },
        {noremap = true, silent = true}
      )
    end,
    config = function()
      local neogit = require('neogit')
      neogit.setup({})
    end
  }
)