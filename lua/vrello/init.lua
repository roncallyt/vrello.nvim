local Path = require("plenary.path")
local utils = require("vrello.utils")
local Dev = require("vrello.dev")
local log = Dev.log

local config_path = vim.fn.stdpath("config")
local config = string.format("%s/vrello.json", utils.project_path())

local M = {}

function M.get_config_path()
  print(config)
end

local vrello_augroup = vim.api.nvim_create_augroup("VRELLO_AUGROUP", {
  clear = true
})

vim.api.nvim_create_autocmd({ "BufLeave, VimLeave" }, {
  callback = function(ev)
    print(string.format('event fired: s', vim.inspect(ev)))
  end,
  group = vrello_augroup,
})

VrelloConfig = VrelloConfig or {}

-- tbl_deep_extend does not work the way you would think
local function merge_table_impl(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k]) == "table" then
                merge_table_impl(t1[k], v)
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
end

local function merge_tables(...)
    log.trace("_merge_tables()")
    
    local out = {}
    
    for i = 1, select("#", ...) do
        merge_table_impl(out, select(i, ...))
    end

    return out
end

-- 1. saved.  Where do we save?
function M.setup(config)
    log.debug("setup(): Complete config", HarpoonConfig)
    log.trace("setup(): log_key", Dev.get_log_key())
end

-- Sets a default config with no values
M.setup()

return M
