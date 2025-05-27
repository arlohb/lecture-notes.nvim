local M = {}

local files = require("lecture-notes.files")
local download = require("lecture-notes.downloaders.downloader").download

---Downloads a file.
---Gets the URL from a prompt.
---Uses the current folder for output.
---May prompt for a session token.
function M.download()
    vim.ui.input({ prompt = "URL" }, function(url)
        download(
            url,
            files.current_folder(),
            function(_) end
        )
    end)
end

---Download the currently hovered linked file.
---Put the file in ./Files.
---May prompt for a session token.
---Also changes the link to the new local copy.
function M.download_linked()
    local line = vim.api.nvim_get_current_line()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local buf = vim.api.nvim_get_current_buf()
    local url = line:match("%b()"):sub(2, -2)

    download(url, files.current_folder() .. "/Files", vim.schedule_wrap(function(outfile, _)
        if outfile == nil then
            return
        end

        -- Remove ./ at start
        outfile = outfile:gsub("^%./", "")
        -- Remove newline
        outfile = outfile:gsub("\n", "")
        -- Make absolute path
        if outfile:sub(1, 1) ~= "/" then
            outfile = vim.fn.getcwd() .. "/" .. outfile
        end
        line = line:gsub("%b()", "(file://" .. outfile .. ")")

        vim.api.nvim_buf_set_lines(
            buf,
            line_num - 1, line_num, false,
            { line }
        )
    end))
end

return M

