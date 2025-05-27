
---@type Select
local function select(url)
    return url:find("https://moodle.", 1, true) == 1
end

---Attempts to download a file from the given URL.
---Doesn't prompt for session token, just tries to download once.
---@type Download
local function try_download(url, folder, callback)
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
            if output.code == 0 then
                callback(output.stdout)
            else
                callback(nil)
            end
        end
    )
end

---Downloads a file from the given URL.
---If the first try fails, prompt for session token and try again.
---@type Download
local function download(url, folder, callback)
    local config = require("lecture-notes.config").config

    try_download(url, folder, function(outfile)
        if outfile ~= nil then
            callback(outfile)
            return
        end

        vim.schedule(function()
            vim.ui.input({ prompt = "Session Token" }, function(session)
                config.moodle_simple_dl_session = session

                try_download(url, folder, function(outfile2)
                    if outfile2 == nil then
                        callback(nil, "Moodle : Failed to download file")
                        return
                    end

                    callback(outfile2)
                end)
            end)
        end)
    end)
end

return {
    ---@type Downloader
    downloader = {
        select = select,
        download = download,
    }
}

