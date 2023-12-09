local use = require('straight').use
local keys = require('keys')
use {
  'andymass/vim-matchup', -- 增强%跳转
  dependencies = {'nvim-treesitter/nvim-treesitter'},
  setup = function()
    vim.g.loaded_matchit = 1
  end
}

use {
  'ggandor/leap.nvim', -- 跳转
  config = function()
    require('leap').add_default_mappings()
  end
}
