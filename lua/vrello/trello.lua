local Path = require("plenary.path")
local Job = require("plenary.job")
local log = require("vrello.dev").log
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

  return vim.fn.json_decode(out)
end

function M.get_cards_by_query()
  if VrelloConfig.board == "" then
    log.debug("get_cards(): No board config found for:", utils.project_path())
    return
  end

  local url = "https://api.trello.com/1/search?idBoards=" .. VrelloConfig.board .. "&query=" .. utils.encodeURIComponent(VrelloConfig.query) .. "&card_fields=name,due,desc,url&key=" .. VrelloConfig.key .. "&token=" .. VrelloConfig.token

  local out, ret, _ = utils.get_os_command_output({
    "curl",
    "--request",
    "GET",
    "--url", 
    url, 
    "--header", 
    "'Accept: application/json'"
  }, vim.loop.cwd())

  return vim.fn.json_decode(out)
end

return M
