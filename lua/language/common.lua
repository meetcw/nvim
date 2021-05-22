local core = require('core')
local keys = core.keys
local use = core.straight.use

do -- lsp
  use({
    'neovim/nvim-lspconfig',
    setup = function()
      local signs = { Error = '', Warn = '', Hint = '', Info = '' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = 'None' })
      end
    end,
  })
  use({
    'williamboman/nvim-lsp-installer',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function() end,
  })
  use({
    'nvim-lua/lsp_extensions.nvim',
  })
end

use({
  'RRethy/vim-illuminate',
  dependencies = { 'neovim/nvim-lspconfig' },
  setup = function()
    vim.g.Illuminate_ftblacklist = {
      'NvimTree',
    }
  end,
})

do -- dap
  use({
    'mfussenegger/nvim-dap',
    setup = function()
      keys.set_key({
        g = {
          b = { [[:lua require'dap'.toggle_breakpoint()<cr>]], 'Toggle Break Point' },
        },
        ['<f5>'] = { [[:lua require'dap'.continue()<cr>]], 'Debug' },
        ['<f10>'] = { [[:lua require'dap'.step_over()<cr>]], 'Step over' },
        ['<f11>'] = { [[:lua require'dap'.step_into()<cr>]], 'Step into' },
        ['<f12>'] = { [[:lua require'dap'.repl.open()<cr>]], 'Debug' },
      }, { noremap = true, silent = true })
    end,
    config = function()
      local dap = require('dap')
      dap.adapters.python = {
        type = 'executable',
        command = 'python',
        args = { '-m', 'debugpy.adapter' },
      }

      dap.adapters.rust = {
        type = 'executable',
        attach = {
          pidProperty = 'pid',
          pidSelect = 'ask',
        },
        command = 'lldb-vscode', -- my binary was called 'lldb-vscode-11'
        env = {
          LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = 'YES',
        },
        name = 'lldb',
      }
    end,
  })
end

do -- format
  use({
    'mhartington/formatter.nvim',
  })
  use({
    'PlatyPew/format-installer.nvim',
  })
end

local M = {}

M.on_lsp_attach = function(client, bufnr)
  require('illuminate').on_attach(client)
  keys.set_key({
    g = {
      d = { vim.lsp.buf.definition, 'Goto definition' },
      D = { vim.lsp.buf.declaration, 'Goto declaration' },
      i = { vim.lsp.buf.implementation, 'Goto implementation' },
      r = { vim.lsp.buf.references, 'Find references' },
    },
    ['['] = {
      d = { vim.diagnostic.goto_prev, 'Goto previous diagnostic' },
    },
    [']'] = {
      d = { vim.diagnostic.goto_next, 'Goto next diagnostic' },
    },
  }, { buffer = bufnr, noremap = true, silent = true })

  keys.set_leader_key({
    c = {
      name = '+Content',
      r = { vim.lsp.buf.rename, 'Rename' },
      a = { vim.lsp.buf.code_action, 'Action' },
      f = {
        function()
          if client['resolved_capabilities']['document_formatting'] then
            vim.lsp.buf.formatting()
          else
            vim.cmd([[Format]])
          end
        end,
        'Format',
      },
      h = { vim.lsp.buf.hover, 'Hover' },
      H = { vim.lsp.buf.signature_help, 'Hover' },
    },
  }, { buffer = bufnr, noremap = true, silent = true })
end

M.set_tab_width = function(file_type, width)
  vim.cmd(string.format('autocmd Filetype %s setlocal tabstop=%d shiftwidth=%d', file_type, width, width))
end

M.setup_lsp = function(name)
  -- local lsp_config = require('lspconfig')
  local lsp_installer_servers = require('nvim-lsp-installer')
  local server_available, requested_server = lsp_installer_servers.get_server(name)
  if server_available then
    requested_server:on_ready(function()
      local opts = {
        on_attach = function(client, bufnr)
          M.on_lsp_attach(client, bufnr)
        end,
      }
      requested_server:setup(opts)
    end)
    if not requested_server:is_installed() then
      -- Queue the server to be installed
      requested_server:install()
      -- print('Lsp server is not installed.')
    else
    end
  end
end

return M
