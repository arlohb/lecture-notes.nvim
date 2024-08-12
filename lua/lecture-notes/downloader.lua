local M = {}

local files = require("lecture-notes.files")

---Attempts to download a file from the given URL.
---Doesn't prompt for session token, just tries to download once.
---@param url string URL of the Moodle file.
---@param folder string Folder to save to.
---@param callback function (success: boolean, outfile: string)
function M.try_download(url, folder, callback)
    local config = require("lecture-notes.config").config

    vim.system(
        {
            vim.fn.expand(config.moodle_simple_dl_exe),
            "--session",
            config.moodle_simple_dl_session,
            "--url",
            url,
            "--outfolder",
            folder,
        },
        {},
        function(output)
            local success = output.code == 0
            -- Read the downloaded file name from moodle_simple_dl
            local outfile = output.stdout
            callback(success, outfile)
        end
    )
end

---Downloads a file from the given URL.
---If the first try fails, prompt for session token and try again.
---@param url string URL of the Moodle file.
---@param folder string Folder to save to.
---@param callback function (outfile: string)
function M.download_url(url, folder, callback)
    local config = require("lecture-notes.config").config

    M.try_download(url, folder, function(success, outfile)
        if success then
            callback(outfile)
            return
        end

        vim.schedule(function()
            vim.ui.input({ prompt = "Session Token" }, function(session)
                config.moodle_simple_dl_session = session

                M.try_download(url, folder, function(success2, outfile2)
                    if not(success2) then
                        vim.notify("Failed to download file", vim.log.levels.ERROR)
                        return
                    end

                    callback(outfile2)
                end)
            end)
        end)
    end)
end

---Downloads a file.
---Gets the URL from a prompt.
---Uses the current folder for output.
---May prompt for a session token.
function M.download()
    vim.ui.input({ prompt = "URL" }, function(url)
        require("lecture-notes.downloader").download_url(
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
    local url = line:match("%b()"):sub(2, -2)

    M.download_url(url, files.current_folder() .. "/Files", vim.schedule_wrap(function(outfile)
        -- Remove ./ at start
        outfile = outfile:gsub("^%./", "")
        -- Remove newline
        outfile = outfile:gsub("\n", "")
        -- Make absolute path
        if outfile:sub(1, 1) ~= "/" then
            outfile = vim.fn.getcwd() .. "/" .. outfile
        end
        line = line:gsub("%b()", "(file://" .. outfile .. ")")
        -- TODO: If the line has moved while downloading, this is no longer correct
        -- Line should be stored and set with vim.api.nvim_buf_set_lines
        vim.api.nvim_set_current_line(line)
    end))
end

return M

