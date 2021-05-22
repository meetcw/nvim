local common = require('language.common')

return {
  setup = function()
    common.set_tab_width('typescript', 2)
    common.setup_lsp('tsserver')
  end,
}
