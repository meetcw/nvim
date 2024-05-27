local use = require('straight').use
local keys = require('keys')
use {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      {
        'saadparwaiz1/cmp_luasnip',
        dependencies = {
          {
            'L3MON4D3/LuaSnip',
            dependencies = {'rafamadriz/friendly-snippets'},
            config = function()
              require('luasnip.loaders.from_vscode').load()
            end
          }
        }
      },
      -- {
      --   'wxxxcxx/cmp-browser-source',
      --   -- path = '~/Projects/cmp-browser-source',
      --   config = function()
      --     require('cmp-browser-source').start_server()
      --   end
      -- }
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local kind_icons = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = 'ﴯ',
        Interface = '',
        Module = '',
        Property = 'ﰠ',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = ''
      }
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end
      cmp.setup(
        {
          mapping = {
            ['<c-up>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), {'i', 'c'}),
            ['<c-down>'] = cmp.mapping(cmp.mapping.scroll_docs(1), {'i', 'c'}),
            ['<tab>'] = cmp.mapping(
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end,
              {'i', 's'}
            ),
            ['<S-Tab>'] = cmp.mapping(
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end,
              {'i', 's'}
            ),
            ['<c-n>'] = cmp.mapping(
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end,
              {'i', 's'}
            ),
            ['<c-p>'] = cmp.mapping(
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end,
              {'i', 's'}
            ),
            ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<cr>'] = cmp.mapping.confirm({select = true})
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end
          },
          formatting = {
            format = function(entry, vim_item)
              -- Kind icons
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
              -- Source
              vim_item.menu =
                ({
                buffer = '[Buffer]',
                path = '[Path]',
                cmdline = '[CMD]',
                nvim_lsp = '[LSP]',
                vsnip = '[Snippet]',
                nvim_lua = '[Lua]',
                latex_symbols = '[LaTeX]',
                browser = '[Browser]'
              })[entry.source.name]
              return vim_item
            end
          },
          sources = cmp.config.sources(
            {
              {name = 'browser', priority = 1},
              {name = 'nvim_lsp', priority = 9},
              {name = 'buffer', priority = 5},
              {name = 'luasnip', priority = 2},
              {name = 'path', priority = 1}
            }
          )
        }
      )
    end
  }
