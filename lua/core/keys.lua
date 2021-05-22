local straight = require('core.straight')

straight.use({
  'folke/which-key.nvim',
  config = function()
    vim.o.timeoutlen = 2000
    require('which-key').setup({
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
          g = true, -- bindings for prefixed with g
        },
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
        ['<Down>'] = '↓',
      },
      icons = {
        breadcrumb = '»',
        separator = ':',
        group = '+',
      },
      window = {
        border = 'single',
        position = 'bottom',
        margin = { 0, 0, 0, 0 },
        padding = { 1, 1, 1, 1 },
      },
      layout = {
        height = { min = 1, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 5,
      },
      hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' },
      show_help = false,
    })
  end,
})

local function set_key(map, options)
  options = options or {}
  local which_key_options = {
    mode = options.mode or nil, -- NORMAL mode
    prefix = options.prefix,
    buffer = options.buffer or nil,
    silent = options.silent or false,
    expr = options.expr or false,
    noremap = options.noremap or false,
    nowait = false,
  }
  local wk = require('which-key')
  wk.register(map, which_key_options)
end
local function set_leader_key(map, options)
  options = options or {}
  options.prefix = '<leader>'
  set_key(map, options)
end

return {
  set_key = set_key,
  set_leader_key = set_leader_key,
}
