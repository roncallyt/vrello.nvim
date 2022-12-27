local Path = require("plenary.path")
local utils = require("vrello.utils")
local Dev = require("vrello.dev")
local log = Dev.log

local config = string.format("%s/vrello-config.json", utils.project_path())

local M = {}

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

local function read_config(config)
    log.trace("_read_config():", config)
    return vim.json.decode(Path:new(config):read())
end

-- 1. saved.  Where do we save?
function M.setup(config)
  print(read_config(config))

  log.debug("setup(): Complete config", VrelloConfig)
  log.trace("setup(): log_key", Dev.get_log_key())
end

-- Sets a default config with no values
M.setup()

return M