local M = {}

local config = require("lecture-notes.config").config
local files = require("lecture-notes.files")

---Calls callback with true on success and false on failure
---@param url string
---@param folder string
---@param callback function
function M.try_download(url, folder, callback)
    vim.system(
        {
            vim.fn.expand(config.moodle_simple_dl_exe),
            "--session",
            config.moodle_simple_dl_session,
            "--url",
            url,
            "--outfolder",
            folder,
            "--preview",
        },
        {},
        function(output)
            vim.notify(output.stdout)
            vim.notify(output.stderr)
            -- If failed, prompt for new session token
            if output.code ~= 0 then
                callback(false)
            else
                callback(true)
            end
        end
    )
end

---Will try again after prompting for a session token if the first try failed
---@param url string
---@param folder string
---@param callback function
function M.download_url(url, folder, callback)
    M.try_download(url, folder, function(success)
        if success then
            callback()
            return
        end

        vim.schedule(function()
            vim.ui.input({ prompt = "Session Token" }, function(session)
                config.moodle_simple_dl_session = session

                M.try_download(url, folder, function(success2)
                    if not(success2) then
                        vim.notify("Failed to download file", vim.log.levels.ERROR)
                    end
                end)
            end)
        end)
    end)
end

function M.download()
    vim.ui.input({ prompt = "URL" }, function(url)
        require("lecture-notes.downloader").download_url(
            url,
            files.current_folder(),
            function() end
        )
    end)
end

function M.download_linked()
end

return M

