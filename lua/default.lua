do
  vim.o.termguicolors = true -- 设置终端颜色
  vim.o.showtabline = 0 -- 设置标签页显示样式
  vim.o.hidden = true -- 自动隐藏 buffer
  vim.o.autochdir = true -- 自动切换工作目录
  vim.o.autoread = true --自动重新加载文件 vim.o.encoding = 'utf-8' -- 默认编码
  vim.o.mouse = '' -- 终端下启用鼠标
  vim.o.mousemodel = 'popup' -- 设置鼠标行为
  vim.o.confirm = true
  vim.wo.conceallevel = 0 -- 文字隐藏样式
end

do -- GUI
  vim.o.guifont = 'Maple Mono,MesloLGM Nerd Font,Consolas,Symbols Nerd Font:h12'
  vim.o.guifontwide = 'Noto Sans Mono CJK SC:h12,Symbols Nerd Font'
  vim.g.lines = 30
  vim.g.columns = 120
  do --Nvui
    if vim.g.nvui then
      vim.cmd([[NvuiOpacity 0.94]])
      vim.cmd([[NvuiPopupMenu 1]])
      vim.cmd([[NvuiAnimationsEnabled 1]])
      -- vim.cmd([[
      --   NvuiCmdPadding 10
      --   NvuiCmdTopPos 0.1
      --   NvuiCmdBigFontScaleFactor 1.5
      -- ]])
      vim.cmd([[
        autocmd InsertEnter * NvuiIMEEnable
        autocmd InsertLeave * NvuiIMEDisable
      ]])
    end
  end
  do --Neovide
    if vim.g.neovide then
      vim.g.neovide_transparency = 0.0 -- 透明度
      vim.g.transparency = 0.8
      vim.g.neovide_background_color = '#0f1117f0'
      vim.g.neovide_floating_blur_amount_x = 5.0
      vim.g.neovide_floating_blur_amount_y = 5.0

      vim.g.neovide_no_idle = false -- 实时渲染
      vim.g.neovide_refresh_rate = 60 -- 刷新率
      vim.g.neovide_refresh_rate_idle = 10 -- 刷新率
      -- vim.g.neovide_remember_window_size = true -- 记住窗口尺寸
      -- vim.g.neovide_fullscreen = true -- 全屏显示
      vim.g.neovide_input_macos_alt_is_meta = true -- 使用Meta键
      vim.g.neovide_hide_mouse_when_typing = true -- 输入时隐藏鼠标
      vim.g.neovide_cursor_vfx_mode = 'railgun' --光标动画类型
      -- vim.g.neovide_cursor_antialiasing = true -- 光标抗锯齿
      -- vim.g.neovide_cursor_vfx_opacity = 100.0 -- 粒子不透明度
      -- vim.g.neovide_cursor_vfx_particle_lifetime = 4.0 -- 粒子寿命
      -- vim.g.neovide_cursor_vfx_particle_density = 7.0 -- 粒子密度
      -- vim.g.neovide_cursor_vfx_particle_speed = 5.0 -- 粒子运动速度
      -- vim.g.neovide_cursor_vfx_particle_phase = 3.3 -- 粒子阶段粒子运动整齐程度
      -- vim.g.neovide_cursor_vfx_particle_curl = 0.5 -- 粒子曲线运动强度
      -- vim.g.neovide_cursor_animation_length = 0.1 -- 光标动画时间
      -- vim.g.neovide_cursor_trail_length = 0.2 -- 光标拖尾长度
    end
  end
end

do -- 按键
  vim.o.timeoutlen = 2000
  -- Set leader
  vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })
  vim.g.mapleader = ' '
end

do -- 补全
  vim.o.completeopt = 'menuone,noinsert,noselect,preview' -- 默认补全提示
  vim.o.wildmenu = true -- 补全
  vim.o.wildmode = 'full'
end

do -- buffer 显示
  vim.o.shortmess = 'filnxtToOFIc' -- 减少消息提示（包括启动屏幕）
  vim.wo.number = true -- 行号
  vim.wo.signcolumn = 'yes' -- 显示 Sign
  vim.wo.relativenumber = true -- 使用相对行号
  vim.wo.cursorline = true -- 高亮当前行
  vim.o.showmatch = true -- 高亮成对的符号
  vim.wo.list = true -- 显示行尾的空白字符
  vim.wo.listchars = 'tab:» ,eol:⤶,nbsp:␣,trail:░,extends:⟩,precedes:⟨' -- 空白字符显示样式
  vim.o.showbreak = '⤷ ' -- 换行标识
  vim.wo.wrap = false -- 自动换行
  vim.bo.wrapmargin = 2 -- 自动换行到窗口的距离
end

do --滚动
  vim.o.scrolloff = 5 --垂直滚动边距
  vim.o.sidescrolloff = 15 -- 水平滚动边距
end

do -- 搜索
  vim.o.hlsearch = true -- 高亮搜索匹配项目
  vim.o.incsearch = true -- 自动跳转到匹配的项目
  vim.o.ignorecase = true -- 忽略大小写
end

do -- 错误提示
  vim.o.errorbells = false -- 关闭错误声音提示
  vim.o.visualbell = true -- 开启错误视觉提示
end

do -- 状态栏
  vim.o.showmode = true -- 显示当前模式
  vim.o.ruler = true -- 状态栏显示光标位置
  vim.o.laststatus = 3 -- 显示最后buffer的状态
end

do -- 命令
  vim.o.cmdheight = 1 -- 命令高度
end

do -- 缩进
  vim.o.smartindent = true
  vim.bo.smartindent = true -- 自动缩进
  -- vim.bo.autoindent = true -- 开启自动缩进
  vim.o.tabstop = 4 -- Tab 字符的显示宽度
  vim.bo.tabstop = 4 --
  vim.o.softtabstop = -1 -- 按键操作的空格数（设置为-1会自动使用shiftwidth的值）
  vim.bo.softtabstop = -1
  vim.o.expandtab = true -- 将 tab 转换为空格
  vim.bo.expandtab = true
  vim.o.shiftwidth = 4 -- 调整缩进时的宽度
  vim.bo.shiftwidth = 4
  vim.cmd([[filetype plugin indent on]]) -- 根据文件类型使用缩进规则
end

do -- 代码折叠
  vim.wo.foldmethod = 'indent' -- 代码折叠规则
  vim.o.foldlevelstart = 99 -- 代码折叠开始层数
end

do -- 备份
  vim.o.backup = false -- 备份文件
  vim.o.writebackup = false -- 写入文件前备份
  vim.o.backupdir = vim.fn.stdpath('cache') .. '/backup//' -- 备份文件位置
end

do -- swap
  vim.o.swapfile = false -- 创建 swap 文件
  vim.o.updatetime = 500 -- 延迟写入 swap 时间
  vim.o.directory = vim.fn.stdpath('cache') .. '/swap//' -- swap 文件位置
end

do -- undo
  vim.o.undofile = true -- undo 文件
  vim.o.undodir = vim.fn.stdpath('cache') .. '/undo//' -- undo 文件位置
end

do -- auto switch to default input method
  function _G.switch_to_default_input_method()
    if vim.fn.has('unix') == 1 then
      -- vim.fn.system([[fcitx-remote -c]])
      vim.fn.system([[rime engine 'xkb:us::eng']])
    end
    ---@diagnostic disable-next-line: empty-block
    if vim.fn.has('mac') == 1 then
      if vim.fn.executable('macism') == 1 then
        vim.fn.system('macism com.apple.keylayout.ABC')
      end
    end
  end

  local auto_switch_input_method_group = vim.api.nvim_create_augroup('AutoSwitchInputMethod', { clear = true })
  vim.api.nvim_create_autocmd(
    { 'InsertLeave', 'VimEnter' },
    { pattern = '*', command = 'lua switch_to_default_input_method()', group = auto_switch_input_method_group }
  )
end

vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
