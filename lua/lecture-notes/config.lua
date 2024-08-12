local M = {}

---@class (exact) Config
---@field vault_location string The path to the default note in the vault. Has to be in the root directory.
---@field moodle_simple_dl_exe string Path to the moodle_simple_dl executable.
---@field moodle_simple_dl_session string Session token for Moodle. Usually given at runtime.

---@type Config
local default_config = {
    vault_location = "",
    moodle_simple_dl_exe = "moodle-simple-dl",
    moodle_simple_dl_session = "",
}

M.config = default_config

---Set the config by extending the defaults.
---@param config Config?
function M.setup(config)
    M.config = vim.tbl_deep_extend("force", default_config, config or {})
end

return M

