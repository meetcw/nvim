local common = require('language.common')

return {
  setup = function()
    common.set_tab_width('json', 2)
    common.setup_lsp('jsonls')
  end,
}
