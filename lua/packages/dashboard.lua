local use = require('straight').use
local keys = require('keys')
use {
  'glepnir/dashboard-nvim',
  setup = function()
    keys.set_leader_key(
      {
        b = {
          name = '+Buffer',
          ['<space>'] = {
            [[<cmd>Dashboard<cr>]],
            'Dashboard'
          }
        }
      },
      {mode = 'n', noremap = true, silent = true}
    )
  end,
  config = function()
    local dashboard = require('dashboard')
    dashboard.setup(
      {
        theme = 'doom',
        config = {
          header = {
            '                                                                               ',
            '                                                                               ',
            '                     .         .                    *                         .',
            '   .        .                                         .           *            ',
            '                             *            *                              *     ',
            '               *        *         .                        *                   ',
            '                           .         *         *                               ',
            '            *     .                       .          *               .         ',
            '                               ┌┐┌┌─┐┌─┐┬  ┬┬┌┬┐               *               ',
            '            .    .         *   │││├┤ │ │└┐┌┘││││                 .             ',
            '                               ┘└┘└─┘└─┘ └┘ ┴┴ ┴     *     .                   ',
            '        .            .                                                        .',
            '                                                                               ',
            '                                                                               '
          },
          center = {
            {
              icon = '  ',
              desc = 'Find file                           SPC f f',
              action = 'Telescope find_files'
            },
            {
              icon = '  ',
              desc = 'Recently opened files               SPC f r',
              action = 'Telescope oldfiles'
            },
            {
              icon = '  ',
              desc = 'Open last session                   SPC s s',
              action = 'SessionLoad'
            },
            {
              icon = '  ',
              desc = 'Settings                                   ',
              action = ':e ' .. vim.fn.stdpath('config') .. '/init.lua'
            }
          },
          footer = {'wxxxcxx'}
        }
      }
    )
  end
}
