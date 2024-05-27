local straight = require('straight')
straight.use(
  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeoutlen = 2000 -- 等待时间
      require('which-key').setup(
        {
          plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            presets = {
              operators = true, -- adds help for operators like d, y, ...
              motions = true, -- adds help for motions
              text_objects = true, -- help for text objects triggered after entering an operator
              windows = true, -- default bindings on <c-w>
              nav = true, -- misc bindings to work with windows
              z = true, -- bindings for folds, spelling and others prefixed with z
              g = true -- bindings for prefixed with g
            }
          },
          key_labels = {
            ['<space>'] = '⎵',
            ['<CR>'] = '⮒',
            ['<Tab>'] = '⭾',
            ['<BS>'] = 'backspace',
            ['<Del>'] = 'delete',
            ['<Insert>'] = 'insert',
            ['<Home>'] = 'home',
            ['<End>'] = 'end',
            ['<PageUp>'] = 'page up',
            ['<PageDown>'] = 'page down',
            ['<Left>'] = '←',
            ['<Right>'] = '→',
            ['<Up>'] = '↑',
            ['<Down>'] = '↓'
          },
          icons = {
            breadcrumb = '»',
            separator = ':',
            group = '+'
          },
          window = {
            border = 'single',
            position = 'bottom',
            margin = {0, 0, 0, 0},
            padding = {1, 1, 1, 1}
          },
          layout = {
            height = {min = 1, max = 25},
            width = {min = 20, max = 50},
            spacing = 5
          },
          hidden = {'<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '},
          show_help = false
        }
      )
    end
  }
)

local M = {}
M._keys = {}
function M.set_key(map, options)
  options = options or {}
  options = {
    mode = options.mode or nil, -- NORMAL mode
    prefix = options.prefix,
    buffer = options.buffer or nil,
    silent = options.silent or false,
    expr = options.expr or false,
    noremap = options.noremap or false,
    nowait = false
  }
  table.insert(M._keys, {map = map, options = options})
end
function M.set_leader_key(map, options)
  options = options or {}
  options.prefix = '<leader>'
  M.set_key(map, options)
end

function M.apply()
  local status, wk = pcall(require, 'which-key')
  if status then
    for _, key in pairs(M._keys) do
      wk.register(key.map, key.options)
    end
  else
    print('Failed to load which-key.')
  end
end

M.set_leader_key(
  {
    ['f'] = {
      name = '+File',
      s = {
        [[<cmd>write<cr>]],
        'Save file'
      },
      S = {
        [[<cmd>wall<cr>]],
        'Save all files'
      }
    }
  },
  {noremap = true, silent = true}
)
M.set_leader_key(
  {
    ['b'] = {
      name = '+Buffer',
      ['<cr>'] = {
        [[<cmd>enew<cr>]],
        'New buffer'
      },
      p = {
        [[<cmd>bprevious<cr>]],
        'Previous buffer'
      },
      n = {
        [[<cmd>bnext<cr>]],
        'Next buffer'
      },
      d = {
        function()
          local buflisted = vim.fn.getbufinfo({buflisted = 1})
          local cur_winnr, cur_bufnr = vim.fn.winnr(), vim.fn.bufnr()
          if #buflisted < 2 then
            vim.cmd('confirm qall')
            return
          end
          for _, winid in ipairs(vim.fn.getbufinfo(cur_bufnr)[1].windows) do
            vim.cmd(string.format('%d wincmd w', vim.fn.win_id2win(winid)))
            vim.cmd(cur_bufnr == buflisted[#buflisted].bufnr and 'bp' or 'bn')
          end
          vim.cmd(string.format('%d wincmd w', cur_winnr))
          local is_terminal = vim.fn.getbufvar(cur_bufnr, '&buftype') == 'terminal'
          vim.cmd(is_terminal and 'bd! #' or 'silent! confirm bd #')
        end,
        'Delete buffer'
      },
      c = {
        function()
          local buflisted = vim.fn.getbufinfo({buflisted = 1})
          local cur_winnr, cur_bufnr = vim.fn.winnr(), vim.fn.bufnr()
          if #buflisted < 2 then
            vim.cmd('confirm qall')
            return
          end
          for _, winid in ipairs(vim.fn.getbufinfo(cur_bufnr)[1].windows) do
            vim.cmd(string.format('%d wincmd w', vim.fn.win_id2win(winid)))
            vim.cmd(cur_bufnr == buflisted[#buflisted].bufnr and 'bp' or 'bn')
          end
          vim.cmd(string.format('%d wincmd w', cur_winnr))
          local is_terminal = vim.fn.getbufvar(cur_bufnr, '&buftype') == 'terminal'
          vim.cmd(is_terminal and 'bd! #' or 'silent! confirm bd #')
        end,
        'Close buffer'
      }
    }
  },
  {noremap = true, silent = true}
)
M.set_leader_key(
  {
    ['w'] = {
      name = '+Window',
      q = {
        [[<cmd>close<cr>]],
        'Close window'
      },
      d = {
        [[<cmd>close<cr>]],
        'Close window'
      },
      c = {
        [[<cmd>close<cr>]],
        'Close window'
      },
      o = {
        [[<cmd>only<cr>]],
        'Close other window'
      },
      ['-'] = {
        [[<cmd>split<cr>]],
        'Split window horizontally'
      },
      ['|'] = {
        [[<cmd>vsplit<cr>]],
        'Split window vertically.'
      }
    }
  },
  {noremap = true, silent = true}
)

M.set_leader_key(
  {
    ['<space>'] = {[[<cmd>nohlsearch<cr>]], 'Cancel search'}
  },
  {mode = 'n', noremap = true, silent = true}
)

M.set_leader_key(
  {
    ['.'] = {
      name = '+Help',
      m = {
        name = '+Module',
        c = {
          function()
            straight.clear()
          end,
          'Clear'
        },
        u = {
          function()
            straight.upgrade_all()
          end,
          'Upgrade'
        }
      },
      ['<cr>'] = {
        ':e ' .. vim.fn.stdpath('config') .. '/init.lua<cr>',
        'Open settings'
      }
    }
  },
  {noremap = true, silent = true}
)

return M
