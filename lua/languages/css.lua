local common = require('languages.common')

return {
  setup = function()
    common.set_tab_width('css', 2)
    common.set_tab_width('less', 2)
    common.set_tab_width('sass', 2)
  end,
}
