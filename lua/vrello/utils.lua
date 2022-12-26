local Path = require("plenary.path")
local Job = require("plenary.job")

local M = {}

function M.project_key()
  -- absolute path to project
  return vim.loop.cwd()
end

function M.project_path()
  -- absolute path to project
  return vim.loop.cwd()
end

function M.normalize_path(item)
    return Path:new(item):make_relative(M.project_key())
end

function M.get_os_command_output(cmd, cwd)
    if type(cmd) ~= "table" then
        print("Vrello: [get_os_command_output]: cmd has to be a table")
        return {}
    end
    local command = table.remove(cmd, 1)
    local stderr = {}
    local stdout, ret = Job:new({
        command = command,
        args = cmd,
        cwd = cwd,
        on_stderr = function(_, data)
            table.insert(stderr, data)
        end,
    }):sync()
    return stdout, ret, stderr
end

function M.split_string(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function M.is_white_space(str)
    return str:gsub("%s", "") == ""
end

return M
