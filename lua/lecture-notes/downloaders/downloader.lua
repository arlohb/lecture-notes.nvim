local M = {}

---@alias ResultCallback fun(outpath: string?, error: string?)

---@alias Select fun(url: string): boolean
---  Whether this downloader can handle this url

---@alias Download fun(url: string, folder: string, callback: ResultCallback)
---  Download the given url, to the given folder, then call the callback

---@class (exact) Downloader
---@field select Select     Whether this downloader can handle this url
---@field download Download Download the url

---@type [Downloader]
M.downloaders = {
    require("lecture-notes.downloaders.moodle").downloader,
    require("lecture-notes.downloaders.youtube").downloader,
}

---@type Download
function M.download(url, folder, callback)
    for _, downloader in ipairs(M.downloaders) do
        if downloader.select(url) then
            vim.notify("Started download", vim.log.levels.INFO)

            downloader.download(url, folder, function(outpath, error)
                if outpath ~= nil then
                    vim.notify("Download successful", vim.log.levels.INFO)

                    callback(outpath, error)
                else
                    if error ~= nil then
                        vim.notify("Failed : " .. error, vim.log.levels.ERROR)
                    else
                        vim.notify("Failed, no error given", vim.log.levels.ERROR)
                    end

                    callback(outpath, error)
                end
            end)

            return
        end
    end

    callback(nil, "No suitable downloader found")
end

return M

