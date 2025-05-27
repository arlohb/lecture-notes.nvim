local M = {}

---@alias ResultCallback fun(outpath: string?)

---@alias Select fun(url: string): boolean
---  Whether this downloader can handle this url

---@alias Download fun(url: string, folder: string, callback: ResultCallback)
---  Download the given url, to the given folder, then call the callback

---@class (exact) Downloader
---@field select Select     Whether this downloader can handle this url
---@field download Download Download the url

return M

