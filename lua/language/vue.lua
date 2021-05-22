local common = require("language.common")

return {
  setup = function()
    common.set_tab_width("vue", 2)
    common.setup_lsp("vuels")
  end,
}
