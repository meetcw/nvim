local core = require('core')
local use = core.straight.use
local keys = core.keys

do -- 外观
  use({
    'andersevenrud/nordic.nvim',
    dependencies = { 'tjdevries/colorbuddy.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nordic').colorscheme({
        underline_option = 'undercurl',
        italic = true,
        italic_comments = true,
        minimal_mode = false,
        alternate_backgrounds = false,
        custom_colors = function(c, _, _)
          return {
            { 'VertSplit', c.dark_black_alt, c.none },
            {
              {
                'LspReferenceText',
                'LspReferenceWrite',
                'LspReferenceRead',
              },
              c.none,
              c.darkish_black,
            },
            -- lewis6991/gitsigns.nvim'
            { 'GitSignsAdd', c.green, c.none },
            { 'GitSignsChange', c.yellow, c.none },
            { 'GitSignsDelete', c.red, c.none },
            { 'GitSignsDeleteLn', c.red, c.none },
          }
        end,
      })
    end,
  })

  use({
    'glepnir/dashboard-nvim',
    setup = function()
      keys.set_leader_key({
        b = {
          name = '+Buffer',
          ['<space>'] = {
            [[<cmd>Dashboard<cr>]],
            'Dashboard',
          },
        },
      }, { mode = 'n', noremap = true, silent = true })
      vim.g.dashboard_custom_header = {
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
        '                                                                               ',
      }
      vim.g.dashboard_default_executive = 'telescope'
      vim.g.dashboard_custom_section = {
        a = {
          description = { '  Find file                           SPC f f  ' },
          command = 'Telescope find_files',
        },
        b = { description = { '  Recently opened files               SPC f r  ' }, command = 'Telescope oldfiles' },
        c = { description = { '  Open last session                   SPC s s  ' }, command = 'SessionLoad' },
        d = {
          description = { '  Settings                                      ' },
          command = ':e ' .. vim.fn.stdpath('config') .. '/init.lua',
        },
      }
      vim.g.dashboard_custom_footer = { 'meetcw' }
    end,
  })

  use({
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
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
        red = '#ec5f67',
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
        end,
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
            [''] = colors.blue,
          }
          local color = mode_color[vim.fn.mode()]
          if not color then
            color = colors.fg
          end
          vim.api.nvim_command('hi! LualineMode guifg=' .. mode_color[vim.fn.mode()])
          return ''
        end,
        color = 'LualineMode',
        padding = { left = 1, right = 1 },
      }

      local inactive_mode_widget = {
        -- mode component
        function()
          return ''
        end,
        padding = { left = 1, right = 1 },
      }

      local name_widget = {
        'filename',
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' },
      }

      local inactive_name_widget = {
        'filename',
        cond = conditions.buffer_not_empty,
        color = { fg = colors.fg, gui = 'bold' },
      }

      local size_widget = {
        -- filesize component
        'filesize',
        cond = conditions.buffer_not_empty,
      }

      local location_widget = { 'location', cond = conditions.hide_in_width }

      local progress_widget = { 'progress', color = { fg = colors.fg }, cond = conditions.hide_in_width }

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
        color = { fg = colors.fg, gui = 'bold' },
        cond = conditions.hide_in_width,
      }

      local diagnostics_widget = {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        diagnostics_color = {
          color_error = { fg = colors.red },
          color_warn = { fg = colors.yellow },
          color_info = { fg = colors.cyan },
        },
        cond = conditions.hide_in_width,
      }

      local git_widget = {
        'branch',
        icon = '',
        color = { fg = colors.violet, gui = 'bold' },
        cond = conditions.hide_in_width,
      }

      local diff_widget = {
        'diff',
        -- Is it me or the symbol for modified us really weird
        symbols = { added = '+', modified = '~', removed = '-' },
        diff_color = {
          added = { fg = colors.green, gui = 'bold' },
          modified = { fg = colors.orange, gui = 'bold' },
          removed = { fg = colors.red, gui = 'bold' },
        },
        cond = conditions.hide_in_width,
      }

      local encoding_widget = {
        'o:encoding', -- option component same as &encoding in viml
        fmt = string.upper, -- I'm not sure why it's upper case either ;)
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = 'bold' },
      }

      local format_widget = {
        'fileformat',
        fmt = string.upper,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.green, gui = 'bold' },
        cond = conditions.hide_in_width,
      }

      -- Config
      local config = {
        options = {
          component_separators = '',
          section_separators = '',
          theme = {
            normal = {
              a = { fg = colors.fg, bg = colors.bg },
              b = { fg = colors.fg, bg = colors.bg },
              c = { fg = colors.fg, bg = colors.bg },
              x = { fg = colors.fg, bg = colors.bg },
              y = { fg = colors.fg, bg = colors.bg },
              z = { fg = colors.fg, bg = colors.bg },
            },
            inactive = {
              a = { fg = colors.fg, bg = colors.bg },
              b = { fg = colors.fg, bg = colors.bg },
              c = { fg = colors.fg, bg = colors.bg },
              x = { fg = colors.fg, bg = colors.bg },
              y = { fg = colors.fg, bg = colors.bg },
              z = { fg = colors.fg, bg = colors.bg },
            },
          },
        },
        sections = {
          lualine_a = {
            mode_widget,
          },
          lualine_b = {
            name_widget,
            location_widget,
            progress_widget,
          },
          lualine_c = {
            size_widget,
          },
          lualine_x = {
            lsp_widget,
            diagnostics_widget,
          },
          lualine_y = {
            git_widget,
            diff_widget,
          },
          lualine_z = {
            encoding_widget,
            format_widget,
          },
        },
        inactive_sections = {
          lualine_a = {
            inactive_mode_widget,
          },
          lualine_b = {
            inactive_name_widget,
            location_widget,
            progress_widget,
          },
          lualine_c = {
            size_widget,
          },
          lualine_y = {},
          lualine_z = {},
          lualine_x = {},
        },
      }

      lualine.setup(config)
    end,
  })

  use({
    'jrudess/vim-foldtext',
  })
end

do -- 提示
  use({
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  })

  use({
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        numhl = true,
        linehl = false,
        signs = {
          add = { hl = 'GitSignsAdd', text = '█', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
          change = { hl = 'GitSignsChange', text = '█', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          delete = { hl = 'GitSignsDelete', text = '█', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          topdelete = { hl = 'GitSignsDelete', text = '█', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          changedelete = {
            hl = 'GitSignsChange',
            text = '▒',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
          },
        },
        keymaps = {},
      })
    end,
  })
end

do -- 编辑
  use({
    'nvim-treesitter/nvim-treesitter',
    config = function()
      vim.wo.foldmethod = 'expr' -- 代码折叠规则
      vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

      require('nvim-treesitter.configs').setup({
        ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        matchup = {
          enable = true, -- mandatory, false will disable the whole extension
        },
        highlight = {
          enable = true, -- false will disable the whole extension
        },
        context_commentstring = {
          enable = true,
        },
        indent = { enable = true },
        autotag = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end,
  })

  use({
    'andymass/vim-matchup',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    setup = function()
      vim.g.loaded_matchit = 1
    end,
  })
  use({
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup({
        filetypes = { 'html', 'xml' },
      })
    end,
  })

  use({
    'p00f/nvim-ts-rainbow',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  })

  use({ 'JoosepAlviste/nvim-ts-context-commentstring', dependencies = { 'nvim-treesitter/nvim-treesitter' } })

  use({
    'farmergreg/vim-lastplace',
    setup = function()
      vim.g.lastplace_ignore = 'gitcommit,gitrebase,svn,hgcommit'
      vim.g.lastplace_ignore_buftype = 'quickfix,nofile,help'
    end,
  })

  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
  })

  use({
    'b3nj5m1n/kommentary',
    setup = function()
      vim.g.kommentary_create_default_mappings = false
      keys.set_leader_key({
        c = {
          name = '+Content',
          c = { [[<Plug>kommentary_line_default]], 'Comment line' },
        },
      }, { mode = 'n', noremap = true, silent = true })
      keys.set_leader_key({
        c = {
          name = '+Content',
          c = { [[<Plug>kommentary_visual_default]], 'Comment block' },
        },
      }, { mode = 'v', noremap = true, silent = true })
    end,
    config = function()
      require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
        ignore_whitespace = true,
      })
    end,
  })

  use({
    'blackCauldron7/surround.nvim',
    config = function()
      require('surround').setup({ mappings_style = 'sandwich' })
    end,
  })

  do -- 补全
    use({
      'hrsh7th/nvim-cmp',
      dependencies = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        {
          'saadparwaiz1/cmp_luasnip',
          dependencies = {
            {
              'L3MON4D3/LuaSnip',
              dependencies = { 'rafamadriz/friendly-snippets' },
              config = function()
                require('luasnip.loaders.from_vscode').load()
              end,
            },
          },
        },
        {
          'meetcw/cmp-browser-source',
          path = '~/Projects/cmp-browser-source',
          config = function()
            require('cmp-browser-source').start_server()
          end,
        },
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
          TypeParameter = '',
        }
        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
        end
        cmp.setup({
          mapping = {
            ['<c-up>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
            ['<c-down>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
            ['<tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<cr>'] = cmp.mapping.confirm({ select = true }),
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          formatting = {
            format = function(entry, vim_item)
              -- Kind icons
              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
              -- Source
              vim_item.menu = ({
                buffer = '[Buffer]',
                path = '[Path]',
                cmdline = '[CMD]',
                nvim_lsp = '[LSP]',
                vsnip = '[Snippet]',
                nvim_lua = '[Lua]',
                latex_symbols = '[LaTeX]',
                browser = '[Browser]',
              })[entry.source.name]
              return vim_item
            end,
          },
          sources = cmp.config.sources({
            { name = 'browser', priority = 1 },
            { name = 'nvim_lsp', priority = 9 },
            { name = 'buffer', priority = 5 },
            { name = 'luasnip', priority = 2 },
            { name = 'path', priority = 1 },
          }),
        })

        cmp.setup.cmdline('/', {
          sources = {
            { name = 'buffer' },
          },
        })
        cmp.setup.cmdline('?', {
          sources = {
            { name = 'buffer' },
          },
        })
        cmp.setup.cmdline(':', {
          sources = {
            { name = 'path' },
            { name = 'cmdline' },
          },
        })
      end,
    })
  end
end

do -- 交互
  do --telescope
    use({
      'nvim-telescope/telescope.nvim',
      dependencies = {
        { 'nvim-lua/popup.nvim' },
        { 'nvim-lua/plenary.nvim' },
      },
      setup = function()
        keys.set_leader_key({
          f = {
            name = '+File',
            b = { [[:lua require'telescope.builtin'.file_browser({hidden=true})<cr>]], 'Browser files' },
            r = { '<cmd>Telescope oldfiles<cr>', 'Recently files' },
            f = { '<cmd>Telescope find_files<cr>', 'Find file' },
          },
          b = {
            name = '+Buffer',
            b = { '<cmd>Telescope buffers<cr>', 'Buffer list' },
          },
          ['.'] = {
            name = '+Help',
            o = { '<cmd>Telescope vim_options<cr>', 'Options' },
            k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
            f = { '<cmd>Telescope filetypes<cr>', 'Filetypes' },
            r = { '<cmd>Telescope registers<cr>', 'Registers' },
            m = { '<cmd>Telescope marks<cr>', 'Marks' },
            ['<space>'] = { '<cmd>Telescope help_tags<cr>', 'Help' },
            a = { '<cmd>Telescope autocommands<cr>', 'Auto commands' },
            h = { '<cmd>Telescope highlights<cr>', 'Highlights' },
          },
        }, { noremap = true, silent = true })
      end,
      config = function()
        local actions = require('telescope.actions')
        require('telescope').setup({
          defaults = {
            vimgrep_arguments = {
              'rg',
              '--color=never',
              '--no-heading',
              '--with-filename',
              '--line-number',
              '--column',
              '--smart-case',
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
                mirror = false,
              },
              vertical = {
                mirror = true,
              },
            },
            file_sorter = require('telescope.sorters').get_fuzzy_file,
            file_ignore_patterns = {},
            generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
            path_display = {},
            winblend = 0,
            border = {},
            scroll_strategy = 'cycle',
            borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            color_devicons = true,
            use_less = false,
            set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
            mappings = {
              n = {
                ['<tab>'] = actions.select_default,
              },
              i = {
                ['<tab>'] = actions.select_default,
              },
            },
            extensions = {
              arecibo = {
                ['selected_engine'] = 'google',
                ['url_open_command'] = 'xdg-open',
                ['show_http_headers'] = false,
                ['show_domain_icons'] = false,
              },
            },
          },
        })
      end,
    })

    use({
      'nvim-telescope/telescope-project.nvim',
      dependencies = { { 'nvim-telescope/telescope.nvim' } },
      after = { 'telescope.nvim' },
      setup = function()
        keys.set_leader_key({
          p = {
            name = '+Project',
            p = {
              [[:lua require('telescope').extensions.project.project{ display_type = 'full' }<CR>]],
              'Projects',
            },
          },
        }, { noremap = true, silent = true })
      end,
      config = function()
        require('telescope').load_extension('project')
      end,
    })
  end

  use({
    'simrat39/symbols-outline.nvim',
    setup = function()
      keys.set_leader_key({
        w = {
          name = '+Window',
          s = { [[<cmd>SymbolsOutline<cr>]], 'Outline' },
        },
      }, { noremap = true, silent = true })

      vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false, -- experimental
        position = 'right',
        relative_width = false,
        width = 40,
        auto_close = true,
        keymaps = {
          close = 'q',
          goto_location = '<Cr>',
          focus_location = 'o',
          hover_symbol = '<C-space>',
          rename_symbol = 'r',
          code_actions = 'a',
        },
        lsp_blacklist = {},
      }
    end,
  })
  use({
    'akinsho/toggleterm.nvim',
    setup = function()
      keys.set_leader_key({
        w = {
          name = '+Window',
          t = {
            [[<cmd>ToggleTerm<cr>]],
            'Toggle Termianl',
          },
        },
      }, { noremap = true, silent = true })
    end,
    config = function()
      require('toggleterm').setup({
        open_mapping = [[<c-t>]],
        -- hide_numbers = true, -- hide the number column in toggleterm buffers
        -- shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true,
        persist_size = false,
        direction = 'float', -- 'vertical' | 'horizontal' | 'window' | 'float'
        float_opts = {
          border = 'single', --'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
          winblend = 0,
          highlights = {
            border = 'NONE',
            background = 'NONE',
          },
        },
      })
    end,
  })

  use({
    'kyazdani42/nvim-tree.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    setup = function()
      keys.set_leader_key({
        w = {
          name = '+Window',
          f = { [[<cmd>NvimTreeToggle<cr>]], 'Toggle File Tree' },
        },
      }, { noremap = true, silent = true })
      vim.g.nvim_tree_show_icons = {
        git = 0,
        folders = 1,
        files = 1,
        folder_arrows = 1,
      }
      vim.g.nvim_tree_git_hl = 1
      vim.g.nvim_tree_highlight_opened_files = 1
    end,
    config = function()
      require('nvim-tree').setup({
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = false,
        ignore_ft_on_setup = {},
        auto_close = true,
        open_on_tab = true,
        hijack_cursor = false,
        update_cwd = true,
        update_to_buf_dir = {
          enable = true,
          auto_open = true,
        },
        diagnostics = {
          enable = true,
          icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
          },
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
          ignore_list = {},
        },
        system_open = {
          cmd = nil,
          args = {},
        },
        filters = {
          dotfiles = true,
          custom = {},
        },
        git = {
          enable = true,
          ignore = true,
          timeout = 500,
        },
        view = {
          width = 30,
          height = 30,
          hide_root_folder = false,
          side = 'left',
          auto_resize = true,
          mappings = {
            custom_only = false,
            list = {},
          },
          number = false,
          relativenumber = false,
          signcolumn = 'yes',
        },
        trash = {
          cmd = 'trash',
          require_confirm = true,
        },
      })
    end,
  })

  use({
    'TimUntersberger/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    setup = function()
      keys.set_leader_key({
        p = {
          name = '+Project',
          s = { [[<cmd>Neogit<cr>]], 'Git' },
        },
      }, { noremap = true, silent = true })
    end,
    config = function()
      local neogit = require('neogit')
      neogit.setup({})
    end,
  })

  use({
    'airblade/vim-rooter',
    setup = function() end,
  })

  use({
    'lambdalisue/suda.vim',
    setup = function()
      vim.g.suda_smart_edit = 1
    end,
  })

  -- use {
  --     'ptzz/lf.vim',
  --     dependencies = {'voldikss/vim-floaterm'},
  --     setup = function()
  --         vim.g.floaterm_title = ''
  --         vim.g.lf_replace_netrw = 1
  --         vim.g.lf_width = 0.9
  --         vim.g.lf_height = 0.9
  --         vim.g.lf_map_keys = false
  --         key.set_leader_key(
  --             {
  --                 f = {
  --                     name = '+File',
  --                     f = {[[<cmd>Lf<cr>]], 'Find file'}
  --                 }
  --             },
  --             {noremap = true, silent = true}
  --         )
  --     end
  -- }

  -- use({
  --   "jghauser/mkdir.nvim",
  --   config = function()
  --     require("mkdir")
  --   end,
  -- })
end
