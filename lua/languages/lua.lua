local common = require('languages.common')

return {
  setup = function()
    common.set_tab_width('lua', 2)
    -- local format_installer = require('format-installer')
    -- if not format_installer.is_installed('stylua') then
    --   format_installer.install_formatter('stylua')
    -- end
    -- local formaters = format_installer.get_installed_formatters()
    -- for _, formater in ipairs(formaters) do
    --   if formater.name == 'stylua' then
    --     require('formatter').setup({
    --       filetype = {
    --         lua = {
    --           function()
    --             return {
    --               exe = formater.cmd,
    --               args = {
    --                 '--indent-width',
    --                 '2',
    --                 '--indent-type',
    --                 'Spaces',
    --                 '--quote-style',
    --                 'AutoPreferSingle',
    --                 '-',
    --               },
    --               stdin = true,
    --             }
    --           end,
    --         },
    --       },
    --     })
    --     break
    --   end
    -- end
  end,
}
