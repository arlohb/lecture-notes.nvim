local M = {}

local downloader = require("lecture-notes.downloader")
local navigation = require("lecture-notes.navigation")

M.try_download = downloader.try_download
M.download_url = downloader.download_url
M.download = downloader.download
M.download_linked = downloader.download_linked

M.open_vault = navigation.open_vault
M.prev_lecture = navigation.prev_lecture
M.next_lecture = navigation.next_lecture
M.parent_module = navigation.parent_module

---@param config Config
function M.setup(config)
    require("lecture-notes.config").setup(config)
end

return M

