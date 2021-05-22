local straight = require('core.straight')
local keys = require('core.keys')

keys.set_leader_key({
  ['f'] = {
    name = '+File',
    s = {
      [[<cmd>write<cr>]],
      'Save file',
    },
    S = {
      [[<cmd>wall<cr>]],
      'Save all files',
    },
  },
}, { noremap = true, silent = true })
keys.set_leader_key({

  ['b'] = {
    name = '+Buffer',
    ['<cr>'] = {
      [[<cmd>enew<cr>]],
      'New buffer',
    },
    p = {
      [[<cmd>bprevious<cr>]],
      'Previous buffer',
    },
    n = {
      [[<cmd>bnext<cr>]],
      'Next buffer',
    },
    d = {
      function()
        local buflisted = vim.fn.getbufinfo({ buflisted = 1 })
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
      'Delete buffer',
    },
    c = {
      function()
        local buflisted = vim.fn.getbufinfo({ buflisted = 1 })
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
      'Close buffer',
    },
  },
}, { noremap = true, silent = true })
keys.set_leader_key({
  ['w'] = {
    name = '+Window',
    q = {
      [[<cmd>close<cr>]],
      'Close window',
    },
    d = {
      [[<cmd>close<cr>]],
      'Close window',
    },
    c = {
      [[<cmd>close<cr>]],
      'Close window',
    },
    o = {
      [[<cmd>only<cr>]],
      'Close other window',
    },
    ['-'] = {
      [[<cmd>split<cr>]],
      'Split window horizontally',
    },
    ['|'] = {
      [[<cmd>vsplit<cr>]],
      'Split window vertically.',
    },
  },
}, { noremap = true, silent = true })

keys.set_leader_key({
  ['<space>'] = { [[<cmd>nohlsearch<cr>]], 'Cancel search' },
}, { mode = 'n', noremap = true, silent = true })

keys.set_leader_key({
  ['.'] = {
    name = '+Help',
    m = {
      name = '+Module',
      c = {
        function()
          straight.clear()
        end,
        'Clear',
      },
      u = {
        function()
          straight.upgrade_all()
        end,
        'Upgrade',
      },
    },
    ['<cr>'] = {
      ':e ' .. vim.fn.stdpath('config') .. '/init.lua<cr>',
      'Open settings',
    },
  },
}, { noremap = true, silent = true })

return {
  keys = keys,
  straight = straight,
}
