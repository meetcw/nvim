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
    local refresh = function()
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
    local resize_dashboard_group = vim.api.nvim_create_augroup('resize_dashboard', {clear = true})
    vim.api.nvim_create_user_command(
      'DashboardRefresh',
      function()
        print('Hello')
        -- refresh()
      end,
      {}
    )
    vim.api.nvim_create_autocmd(
      {'VimResized'},
      {
        pattern = '*',
        group = resize_dashboard,
        command = 'DashboardRefresh'
      }
    )
  end
}
