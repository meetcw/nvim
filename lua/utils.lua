local M = {}


M.current_filepath = function ()
    local file = vim.fn.expand('%:p')
    if(file == '') then
        return nil
    end
end

M.current_direactory = function ()
    local file = vim.fn.expand('%:p')
    if(file == '') then
        return vim.fn.expand('~')
    end
end


return M
