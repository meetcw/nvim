local keys = require('keys')
local use = require('straight').use

local on_lsp_attach = function(client, bufnr)
  -- require('illuminate').on_attach(client)
  keys.set_key(
    {
      g = {
        d = {vim.lsp.buf.definition, 'Goto definition'},
        D = {vim.lsp.buf.declaration, 'Goto declaration'},
        i = {vim.lsp.buf.implementation, 'Goto implementation'},
        r = {vim.lsp.buf.references, 'Find references'}
      },
      ['['] = {
        d = {vim.diagnostic.goto_prev, 'Goto previous diagnostic'}
      },
      [']'] = {
        d = {vim.diagnostic.goto_next, 'Goto next diagnostic'}
      }
    },
    {buffer = bufnr, noremap = true, silent = true}
  )

  keys.set_leader_key(
    {
      c = {
        name = '+Content',
        r = {vim.lsp.buf.rename, 'Rename'},
        a = {vim.lsp.buf.code_action, 'Action'},
        f = {
          function()
            if client['server_capabilities']['document_formatting'] then
              vim.lsp.buf.format({async = true})
            else
              vim.cmd([[Format]])
            end
          end,
          'Format'
        },
        h = {vim.lsp.buf.hover, 'Hover'},
        H = {vim.lsp.buf.signature_help, 'Hover'}
      }
    },
    {buffer = bufnr, noremap = true, silent = true}
  )

  if client['server_capabilities']['document_formatting'] then
    vim.lsp.buf.format({async = true})
  else
    vim.cmd([[Format]])
  end

  keys.apply()
end

do -- lsp
  use(
    {
      'neovim/nvim-lspconfig',
      setup = function()
        local signs = {Error = '', Warn = '', Hint = '', Info = ''}
        for type, icon in pairs(signs) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = 'None'})
        end
      end
    }
  )
  use {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim'
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = {'lua_ls'}
      }
      require('mason-lspconfig').setup_handlers {
        function(server_name)
          print('Setting up ' .. server_name)
          require('lspconfig')[server_name].setup {
            on_attach = on_lsp_attach
          }
        end
      }
    end
  }
end

do -- format
  use(
    {
      'mhartington/formatter.nvim'
    }
  )
  use(
    {
      'PlatyPew/format-installer.nvim'
    }
  )
end

local M = {}

M.set_tab_width = function(file_type, width)
  vim.cmd(string.format('autocmd Filetype %s setlocal tabstop=%d shiftwidth=%d', file_type, width, width))
end

return M
