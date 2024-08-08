local M = {}

---@class Config
---@field vault_location string
---@field moodle_simple_dl_exe string
---@field moodle_simple_dl_session string

---@type Config
local default_config = {
    vault_location = "",
    moodle_simple_dl_exe = "moodle-simple-dl",
    moodle_simple_dl_session = "",
}

M.config = default_config

---@param config Config?
function M.setup(config)
    M.config = vim.tbl_deep_extend("force", default_config, config or {})
end

return M

