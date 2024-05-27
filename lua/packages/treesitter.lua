local use = require('straight').use
local keys = require('keys')

use {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    vim.wo.foldmethod = 'expr' -- 代码折叠规则
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

    require('nvim-treesitter.configs').setup(
      {
        ensure_installed = 'lua', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        auto_install = true,
        matchup = {
          enable = true -- mandatory, false will disable the whole extension
        },
        highlight = {
          enable = true -- false will disable the whole extension
        },
        indent = {enable = true},
        autotag = {enable = true},
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil
        }
      }
    )
  end
}
