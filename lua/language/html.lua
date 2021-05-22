local common = require('language.common')

return {
  setup = function()
    common.set_tab_width('html', 2)
    common.setup_lsp('html')
  end,
}
