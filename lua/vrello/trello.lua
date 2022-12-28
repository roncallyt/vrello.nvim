local Path = require("plenary.path")
local Job = require("plenary.job")
local utils = require("vrello.utils")

local M = {}

function M.get_boards()
  local url = "https://api.trello.com/1/members/" .. VrelloConfig.member .. "/boards?fields=id,name&key=" .. VrelloConfig.key .. "&token=" .. VrelloConfig.token

  local out, ret, _ = utils.get_os_command_output({
    "curl",
    "--request",
    "GET",
    "--url", 
    url, 
    "--header", 
    "'Accept: application/json'"
  }, vim.loop.cwd())

  print(vim.inspect(out))
end

return M
