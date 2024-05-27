local use = require('straight').use
local keys = require('keys')
local utils = require("utils")

use {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    {'nvim-lua/popup.nvim'},
    {'nvim-lua/plenary.nvim'}
  },
  setup = function()
    keys.set_leader_key(
      {
        f = {
          name = '+File',
          r = {'<cmd>Telescope oldfiles<cr>', 'Recently files'},
          f = {
            function()
              require 'telescope.builtin'.find_files {
              }
            end,
            'Find file'
          }
        },
        b = {
          name = '+Buffer',
          b = {
            function()
              require 'telescope.builtin'.buffers {}
            end,
            'Buffer list'
          }
        },
        ['.'] = {
          name = '+Help',
          o = {'<cmd>Telescope vim_options<cr>', 'Options'},
          k = {'<cmd>Telescope keymaps<cr>', 'Keymaps'},
          f = {'<cmd>Telescope filetypes<cr>', 'Filetypes'},
          r = {'<cmd>Telescope registers<cr>', 'Registers'},
          m = {'<cmd>Telescope marks<cr>', 'Marks'},
          ['<space>'] = {'<cmd>Telescope help_tags<cr>', 'Help'},
          a = {'<cmd>Telescope autocommands<cr>', 'Auto commands'},
          h = {'<cmd>Telescope highlights<cr>', 'Highlights'}
        }
      },
      {noremap = true, silent = true}
    )
  end,
  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup(
      {
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
          },
          prompt_prefix = '> ',
          selection_caret = '> ',
          entry_prefix = '  ',
          initial_mode = 'insert',
          selection_strategy = 'reset',
          sorting_strategy = 'ascending',
          layout_strategy = 'flex',
          layout_config = {
            width = 0.7,
            prompt_position = 'top',
            preview_cutoff = 120,
            horizontal = {
              mirror = false
            },
            vertical = {
              mirror = true
            }
          },
          file_sorter = require('telescope.sorters').get_fuzzy_file,
          file_ignore_patterns = {},
          generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
          path_display = {},
          winblend = 0,
          border = {},
          scroll_strategy = 'cycle',
          borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
          color_devicons = true,
          use_less = false,
          set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
          mappings = {
            n = {
              ['<tab>'] = actions.select_default
            },
            i = {
              ['<tab>'] = actions.select_default
            }
          },
          extensions = {
            arecibo = {
              ['selected_engine'] = 'google',
              ['url_open_command'] = 'xdg-open',
              ['show_http_headers'] = false,
              ['show_domain_icons'] = false
            }
          }
        }
      }
    )
  end
}

use {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = {{'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'}},
  after = {'telescope.nvim'},
  setup = function()
    keys.set_leader_key(
      {
        f = {
          name = '+File',
          b = {
            function()
              require('telescope').extensions.file_browser.file_browser {
                path = utils.current_direactory()
              }
            end,
            'File Browser'
          },
        }
      },
      {noremap = true, silent = true}
    )
  end,
  config = function()
    require('telescope').load_extension('file_browser')
  end
}

use {
  'nvim-telescope/telescope-project.nvim',
  dependencies = {{'nvim-telescope/telescope.nvim'}},
  after = {'telescope.nvim'},
  setup = function()
    keys.set_leader_key(
      {
        p = {
          name = '+Project',
          p = {
            [[:lua require('telescope').extensions.project.project{ display_type = 'full' }<CR>]],
            'Projects'
          }
        }
      },
      {noremap = true, silent = true}
    )
  end,
  config = function()
    require('telescope').load_extension('project')
  end
}
