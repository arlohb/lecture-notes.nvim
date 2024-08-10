local M = {}

local files = require("lecture-notes.files")

---Calls callback with true on success and false on failure
---@param url string
---@param folder string
---@param callback function (status: boolean, outfile: string)
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
            local outfile = output.stdout
            callback(output.code == 0, outfile)
        end
    )
end

---Will try again after prompting for a session token if the first try failed
---@param url string
---@param folder string
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

function M.download()
    vim.ui.input({ prompt = "URL" }, function(url)
        require("lecture-notes.downloader").download_url(
            url,
            files.current_folder(),
            function(_) end
        )
    end)
end

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
        vim.api.nvim_set_current_line(line)
    end))
end

return M

