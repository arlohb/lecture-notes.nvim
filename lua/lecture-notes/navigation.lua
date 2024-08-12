local M = {}

local files = require("lecture-notes.files")

---Open the vault as declared in `Config.vault_location`.
function M.open_vault()
    vim.cmd("e ~/Nextcloud/Vault/Scratch.md")
    require("telescope.builtin").find_files({
        find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}
    )
end

---Open the previous lecture.
---Assumes the lecture number is the 2nd 'word' in the filename.
function M.prev_lecture()
    -- Get the current file
    local path = files.current_file()
    -- Find the position of the last slash
    local last_slash = path:find("/[^/]*$")
    -- Get the pos of first space in file name
    local first_space = last_slash + path:sub(last_slash + 1):find(' ')
    -- Get the lecture number and add 1
    local lecture_number = tonumber(path:sub(first_space + 1, first_space + 2)) - 1
    -- Add the new lecture number to the path
    path = path:sub(0, first_space) .. string.format("%02d", lecture_number)

    files.open(path .. "*")
end

---Open the next lecture.
---Assumes the lecture number is the 2nd 'word' in the filename.
function M.next_lecture()
    -- Get the current file
    local path = files.current_file()
    -- Find the position of the last slash
    local last_slash = path:find("/[^/]*$")
    -- Get the pos of first space in file name
    local first_space = last_slash + path:sub(last_slash + 1):find(' ')
    -- Get the lecture number and add 1
    local lecture_number = tonumber(path:sub(first_space + 1, first_space + 2)) + 1
    -- Add the new lecture number to the path
    path = path:sub(0, first_space) .. string.format("%02d", lecture_number)

    files.open(path .. "*")
end

---Open the parent module of a lecture.
---Assumes the module code is the 1st 'word' in the filename.
---And that the module page is 'xxxx 00.md'.
function M.parent_module()
    -- Get the current file
    local path = files.current_file()
    -- Find the position of the last slash
    local last_slash = path:find("/[^/]*$")
    -- Add the lecture number "00" to the path
    path = path:sub(0, last_slash + 5) .. "00.md"

    files.open(path)
end

return M

