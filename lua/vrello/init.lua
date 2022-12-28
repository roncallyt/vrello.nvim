local Path = require("plenary.path")
local Job = require("plenary.job")
local utils = require("vrello.utils")
local Dev = require("vrello.dev")
local log = Dev.log

local initial_config = {
  board = "",
  key = "",
  member = "",
  query = "",
  token = ""
}

local project_config = string.format("%s/vrello-config.json", utils.project_path())

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

local function ensure_correct_config(config)
    log.trace("_ensure_correct_config()")

    local board = config.board
    if board == nil then
        log.debug("ensure_correct_config(): No board config found for:", utils.project_path())
        config.board = ""
    end

    local key = config.key
    if key == nil then
        log.debug("ensure_correct_config(): No key config found for:", utils.project_path())
        config.key = ""
    end

    local member = config.member
    if member == nil then
        log.debug("ensure_correct_config(): No member config found for:", utils.project_path())
        config.member = ""
    end

    local query = config.query
    if query == nil then
        log.debug("ensure_correct_config(): No query config found for:", utils.project_path())
        config.query = ""
    end

    local token = config.token
    if token == nil then
        log.debug("ensure_correct_config(): No token config found for:", utils.project_path())
        config.token = ""
    end

    return config
end

function M.save_config()
    log.trace("save(): Saving cache config to", config)
    Path:new(config):write(vim.fn.json_encode(VrelloConfig), "w")
end

local function read_config(config)
    log.trace("_read_config():", config)

    return vim.json.decode(Path:new(config):read())
end

function M.setup(config)
    log.trace("setup(): Setting up...")

    if not config then
        config = {}
    end

    local ok, p_config = pcall(read_config, project_config)

    if not ok then
        log.debug("setup(): No project config present at", project_config)

        p_config = initial_config

        Path:new(project_config):write(vim.fn.json_encode(p_config), "w")
    end

    local complete_config = merge_tables(initial_config, p_config, config)

    ensure_correct_config(complete_config)

    VrelloConfig = complete_config

    log.debug("setup(): Complete config", VrelloConfig)
    log.trace("setup(): log_key", Dev.get_log_key())
end

function M.print_config()
    print(vim.inspect(VrelloConfig))
end

function M.test_curl()
  local url = "http://pokeapi.co/api/v2/pokemon/ditto"

  Job:new({
    command = "curl",
    args = { url },
    on_exit = function(j, return_val)
      --print(vim.inspect(return_val))
      print(vim.inspect(j:result()))
    end,
  }):start()
end

-- Sets a default config with no values
M.setup()

return M
