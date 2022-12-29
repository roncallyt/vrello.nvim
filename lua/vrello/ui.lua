local trello = require("vrello.trello")

local M = {}

function M.set_key()
  vim.ui.input({
    prompt = "Enter the API Key: ",
  }, function(input)
    if input then
      VrelloConfig.key = input
    else
      print "This step is required to connect with Trello API"
    end
  end)
end

function M.set_token()
  vim.ui.input({
    prompt = "Enter the API Token: ",
  }, function(input)
    if input then
      VrelloConfig.token = input
    else
      print "This step is required to connect with Trello API"
    end
  end)
end

function M.set_member()
  vim.ui.input({
    prompt = "Enter your username or ID: ",
  }, function(input)
    if input then
      VrelloConfig.member = input
    else
      print "This step is required to get your boards."
    end
  end)
end

function M.select_board()
  local boards = trello.get_boards()

  vim.ui.select(boards, {
    prompt = "Select a board",
    format_item = function(item)
      return item.name
    end,
  }, function(board)
    if board then
      VrelloConfig.board = board.id
    end
  end)
end

return M
