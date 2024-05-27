local use = require('straight').use
local keys = require('keys')
require('packages.theme')
require('packages.dashboard')
require('packages.statusline')
require('packages.telescope')
require('packages.file')
require('packages.motion')
require('packages.git')
require('packages.completion')
require('packages.outline')
require('packages.treesitter')
require('packages.terminal')
do -- 外观
  use {
    'folke/noice.nvim', -- 美化VIM的提示
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify'
    },
    enabled = false,
    config = function()
      require('noice').setup(
        {
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
              ['vim.lsp.util.stylize_markdown'] = true,
              ['cmp.entry.get_documentation'] = true
            }
          },
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false -- add a border to hover docs and signature help
          }
        }
      )
    end
  }

  use {
    'jrudess/vim-foldtext' -- 折叠增强
  }
end

do -- 提示
  use {
    'norcalli/nvim-colorizer.lua', -- 显示颜色代码
    config = function()
      require('colorizer').setup()
    end
  }

  use {
    'RRethy/vim-illuminate', -- 高亮光标所在的词
    setup = function()
      vim.g.Illuminate_ftblacklist = {
        'NvimTree'
      }
    end
  }
end

do -- 编辑
  use {
    'windwp/nvim-ts-autotag', -- HTML和XML自动闭合和重命名标签
    dependencies = {'nvim-treesitter/nvim-treesitter'},
    config = function()
      require('nvim-ts-autotag').setup(
        {
          filetypes = {'html', 'xml'}
        }
      )
    end
  }

  use {
    'p00f/nvim-ts-rainbow', -- 彩虹括号
    dependencies = {'nvim-treesitter/nvim-treesitter'}
  }

  use {
    'JoosepAlviste/nvim-ts-context-commentstring', -- 根据上下文自动设置注释符
    dependencies = {'nvim-treesitter/nvim-treesitter'}
  }

  use {
    'farmergreg/vim-lastplace', -- 记录文件上次光标位置
    setup = function()
      vim.g.lastplace_ignore = 'gitcommit,gitrebase,svn,hgcommit'
      vim.g.lastplace_ignore_buftype = 'quickfix,nofile,help'
    end
  }

  use {
    'windwp/nvim-autopairs', -- 自动括号补全
    config = function()
      require('nvim-autopairs').setup()
    end
  }

  use {
    'b3nj5m1n/kommentary', -- 注释
    setup = function()
      vim.g.kommentary_create_default_mappings = false
      keys.set_leader_key(
        {
          c = {
            name = '+Content',
            c = {[[<Plug>kommentary_line_default]], 'Comment line'}
          }
        },
        {mode = 'n', noremap = true, silent = true}
      )
      keys.set_leader_key(
        {
          c = {
            name = '+Content',
            c = {[[<Plug>kommentary_visual_default]], 'Comment block'}
          }
        },
        {mode = 'v', noremap = true, silent = true}
      )
    end,
    config = function()
      require('kommentary.config').configure_language(
        'default',
        {
          prefer_single_line_comments = true,
          ignore_whitespace = true
        }
      )
    end
  }

  use {
    'kylechui/nvim-surround', -- 编辑成对的符号
    config = function()
      require('nvim-surround').setup({})
    end
  }

  use {
    'bfredl/nvim-miniyank' -- 剪切板
  }
end
