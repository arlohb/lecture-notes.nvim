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
    require("lecture-notes.downloaders.moodle").downloader
}

---@type Download
function M.download(url, folder, callback)
    for _, downloader in ipairs(M.downloaders) do
        if downloader.select(url) then
            downloader.download(url, folder, callback)
            return
        end
    end

    callback(nil, "No suitable downloader found")
end

return M

