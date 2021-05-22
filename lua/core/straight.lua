local pm_directory = vim.fn.stdpath('data') .. '/site/pack/packages/'
local modules = {}

local function log(msg, level)
  -- vim.api.nvim_echo({{msg}}, false, {})
  print(msg)
end

local function get_target_directory(module)
  return pm_directory .. (module.opt and 'opt/' or 'start/') .. module.author .. ':' .. module.name
end

local function exists(module)
  local module_directory = get_target_directory(module)
  return vim.fn.isdirectory(module_directory) ~= 0
end

local function load(module)
  if exists(module) then
    if type(module.setup) == 'function' then
      local status, error = pcall(module.setup)
      if not status then
        log(error)
      end
    end
    if module.opt then
      vim.cmd('packadd ' .. module.author .. ':' .. module.name)
    else
      vim.cmd('packloadall! | helptags ALL')
    end
    if type(module.config) == 'function' then
      local status, error = pcall(module.config)
      if not status then
        log(error)
      end
    end
  end
end

local function install(module)
  log(string.format('Installing %s...', module.name))
  if module.path then
    if vim.fn.isdirectory(module.path) == 0 then
      log(string.format('local module %s is not exist', module.name))
    else
      vim.loop.fs_symlink(module.path, get_target_directory(module), { dir = true })
    end
  else
    local args = { 'git', 'clone', module.url }
    if module.branch then
      vim.list_extend(args, { '-b', module.branch })
    end
    vim.list_extend(args, { get_target_directory(module) })
    local out = vim.fn.system(args)
    if vim.v.shell_error ~= 0 then
      log(out)
    end
  end
end

local function upgrade(module)
  if exists(module) then
    log(string.format('Upgrading %s...', module.name))
    local args = { 'git', '-C', get_target_directory(module), 'pull', '-f' }
    local out = vim.fn.system(args)
    if vim.v.shell_error ~= 0 then
      log(out)
    end
  else
    install(module)
  end
end

local function upgrade_all()
  for _, module in pairs(modules) do
    upgrade(module)
  end
end

local function clear()
  vim.fn.delete(pm_directory, 'rf')
end

local function use(args)
  if type(args) == 'string' then
    args = { args }
  end
  local fullname = args[1]
  local author, name = fullname:match('^([%w-]+)/([%w-_.]+)$')
  if not name then
    return
  end
  if not author then
    return
  end

  local module = {
    name = name,
    author = author,
    fullname = fullname,
    branch = args.branch,
    opt = true,
    dependencies = args.dependencies or {},
    setup = args.setup,
    config = args.config,
    path = args.path and vim.fn.expand(args.path) or nil,
    url = args.url or ('https://github.com/' .. fullname .. '.git'),
  }
  modules[module.fullname] = module
  for _, dependency in ipairs(module.dependencies) do
    use(dependency)
  end

  if not exists(module) then
    install(module)
  end
  load(module)
end

return {
  clear = clear,
  use = use,
  upgrade = upgrade,
  upgrade_all = upgrade_all,
}
