local common = require('language.common')

return {
  setup = function()
    common.set_tab_width('csharp', 4)
    common.setup_lsp('csharpls')
  end,
}
