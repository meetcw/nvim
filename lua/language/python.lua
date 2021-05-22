local common = require('language.common')
return {
  setup = function()
    common.set_tab_width('python', 4)
    common.setup_lsp('pyright')
  end,
}
