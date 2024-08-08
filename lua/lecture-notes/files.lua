local M = {}

function M.open(path)
    -- Expand the wildcard
    path = vim.fn.expand(path)
    -- Sub the ' ' for '\ '
    path = path:gsub(" ", "\\ ")
    vim.cmd("e " .. path)
end

function M.current_file()
    return vim.fn.expand("%")
end

---This isn't the working directory,
---It's the folder containing the open file.
function M.current_folder()
    -- Get the current file
    local path = M.current_file()
    -- Find the position of the last slash
    local last_slash = path:find("/[^/]*$")
    -- If no slash is found, can use cwd
    if last_slash == nil then
        return "."
    else
        -- Return everything before that
        return path:sub(0, last_slash - 1)
    end
end

return M

