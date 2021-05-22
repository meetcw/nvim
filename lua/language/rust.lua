local common = require('language.common')

return {
  setup = function()
    common.set_tab_width('rust', 4)
    common.setup_lsp('rust_analyzer')
  end,
}
