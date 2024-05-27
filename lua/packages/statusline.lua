local use = require('straight').use
local keys = require('keys')
use {
  'nvim-lualine/lualine.nvim',
  dependencies = {'kyazdani42/nvim-web-devicons'},
  config = function()
    local lualine = require('lualine')
    local colors = {
      bg = 'NONE',
      fg = '#bbc2cf',
      yellow = '#ECBE7B',
      cyan = '#008080',
      darkblue = '#081633',
      green = '#98be65',
      orange = '#FF8800',
      violet = '#a9a1e1',
      magenta = '#c678dd',
      blue = '#51afef',
      red = '#ec5f67'
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end
    }

    local mode_widget = {
      -- mode component
      function()
        -- auto change color according to neovims mode
        local mode_color = {
          n = colors.red, -- Normal
          i = colors.green, -- Insert
          v = colors.orange, -- Visual
          V = colors.orange, -- Visual line
          [''] = colors.orange, -- Visual block
          c = colors.magenta, -- Command
          no = colors.red, -- N Operator pending
          s = colors.blue, -- Select
          S = colors.blue, -- Select line
          [''] = colors.blue, -- Select block
          ic = colors.yellow,
          R = colors.violet, -- Replace
          Rv = colors.violet, -- Visual Replace
          cv = colors.red, -- Vim ex
          ce = colors.red, -- ex
          r = colors.cyan, -- Prommpt
          rm = colors.cyan, -- More
          ['r?'] = colors.cyan, -- Confirm
          ['!'] = colors.red, -- Shell
          t = colors.red,
          [''] = colors.blue
        }
        local color = mode_color[vim.fn.mode()]
        if not color then
          color = colors.fg
        end
        vim.api.nvim_command('hi! LualineMode guifg=' .. mode_color[vim.fn.mode()])
        return ''
      end,
      color = 'LualineMode',
      padding = {left = 1, right = 1}
    }

    local inactive_mode_widget = {
      -- mode component
      function()
        return ''
      end,
      padding = {left = 1, right = 1}
    }

    local command_widget = {
      -- command component
      function()
        return ''
      end,
      padding = {left = 1, right = 1}
    }

    local name_widget = {
      'filename',
      cond = conditions.buffer_not_empty,
      color = {fg = colors.magenta, gui = 'bold'}
    }

    local inactive_name_widget = {
      'filename',
      cond = conditions.buffer_not_empty,
      color = {fg = colors.fg, gui = 'bold'}
    }

    local size_widget = {
      -- filesize component
      'filesize',
      cond = conditions.buffer_not_empty
    }

    local location_widget = {'location', cond = conditions.hide_in_width}

    local progress_widget = {'progress', color = {fg = colors.fg}, cond = conditions.hide_in_width}

    local lsp_widget = {
      -- Lsp server name .
      function()
        local msg = 'none'
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        return msg
      end,
      icon = '',
      color = {fg = colors.fg, gui = 'bold'},
      cond = conditions.hide_in_width
    }

    local diagnostics_widget = {
      'diagnostics',
      sources = {'nvim_diagnostic'},
      symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
      diagnostics_color = {
        color_error = {fg = colors.red},
        color_warn = {fg = colors.yellow},
        color_info = {fg = colors.cyan}
      },
      cond = conditions.hide_in_width
    }

    local git_widget = {
      'branch',
      icon = '',
      color = {fg = colors.violet, gui = 'bold'},
      cond = conditions.hide_in_width
    }

    local diff_widget = {
      'diff',
      -- Is it me or the symbol for modified us really weird
      symbols = {added = '+', modified = '~', removed = '-'},
      diff_color = {
        added = {fg = colors.green, gui = 'bold'},
        modified = {fg = colors.orange, gui = 'bold'},
        removed = {fg = colors.red, gui = 'bold'}
      },
      cond = conditions.hide_in_width
    }

    local encoding_widget = {
      'o:encoding', -- option component same as &encoding in viml
      fmt = string.upper, -- I'm not sure why it's upper case either ;)
      cond = conditions.buffer_not_empty,
      color = {fg = colors.green, gui = 'bold'}
    }

    local format_widget = {
      'fileformat',
      fmt = string.upper,
      icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
      color = {fg = colors.green, gui = 'bold'},
      cond = conditions.buffer_not_empty
    }

    -- Config
    local config = {
      options = {
        component_separators = '',
        section_separators = '',
        theme = {
          normal = {
            a = {fg = colors.fg, bg = colors.bg},
            b = {fg = colors.fg, bg = colors.bg},
            c = {fg = colors.fg, bg = colors.bg},
            x = {fg = colors.fg, bg = colors.bg},
            y = {fg = colors.fg, bg = colors.bg},
            z = {fg = colors.fg, bg = colors.bg}
          },
          inactive = {
            a = {fg = colors.fg, bg = colors.bg},
            b = {fg = colors.fg, bg = colors.bg},
            c = {fg = colors.fg, bg = colors.bg},
            x = {fg = colors.fg, bg = colors.bg},
            y = {fg = colors.fg, bg = colors.bg},
            z = {fg = colors.fg, bg = colors.bg}
          }
        }
      },
      sections = {
        lualine_a = {
          mode_widget
        },
        lualine_b = {
          name_widget,
          location_widget,
          progress_widget
        },
        lualine_c = {
          size_widget
        },
        lualine_x = {
          lsp_widget,
          diagnostics_widget
        },
        lualine_y = {
          git_widget,
          diff_widget
        },
        lualine_z = {
          encoding_widget,
          format_widget,
          command_widget
        }
      },
      inactive_sections = {
        lualine_a = {
          inactive_mode_widget
        },
        lualine_b = {
          inactive_name_widget,
          location_widget,
          progress_widget
        },
        lualine_c = {
          size_widget
        },
        lualine_y = {},
        lualine_z = {},
        lualine_x = {}
      }
    }

    lualine.setup(config)
  end
}
