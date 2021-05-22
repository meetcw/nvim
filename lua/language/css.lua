local common = require('language.common')

return {
  setup = function()
    common.set_tab_width('css', 2)
    common.set_tab_width('less', 2)
    common.set_tab_width('sass', 2)
    common.setup_lsp('cssls')
  end,
}
