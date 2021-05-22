local common = require('language.common')

return {
  setup = function()
    common.set_tab_width('java', 4)
    common.setup_lsp('jdtls')
  end,
}
