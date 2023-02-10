-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

_G.package_specifications = {}
local M = {}

function M.use(specification)
  if not specification then
    return
  end
  if not specification.init then
    specification.init = specification.setup
  end
  if not specification.dir then
    specification.dir = specification.directory
  end
  if not specification.cond then
    specification.cond = specification.condition
  end
  if not specification.opts then
    specification.opts = specification.options
  end
  if not specification.ft then
    specification.ft = specification.filetype
  end
  if not specification.cmd then
    specification.cmd = specification.command
  end
  if not specification.cmd then
    specification.cmd = specification.command
  end
  table.insert(_G.package_specifications, specification)
end

function M.apply()
  require('lazy').setup(_G.package_specifications, {
    defaults = {
      lazy = false,
    },
    install = {
      colorscheme = { 'nordfox', 'quiet' },
    },
    ui = {
      -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
      border = 'single',
      wrap = false,
    },
  })
end

return M
