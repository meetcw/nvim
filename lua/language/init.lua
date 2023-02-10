local languages = {
  'rust',
  'lua',
  'python',
  'css',
  'html',
  'javascript',
  'vue',
  'csharp',
  'java',
  'json',
}

for _, v in ipairs(languages) do
  require('language.' .. v)
end

return {
  setup = function()
    for _, v in ipairs(languages) do
      local language = require('language.' .. v)
      if type(language) == 'table' and type(language.setup) == 'function' then
        language.setup()
      end
    end
  end,
}
