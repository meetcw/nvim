local common = require('languages.common')

return {
  setup = function()
    common.set_tab_width('rust', 4)
  end,
}
