-- =========================================
-- VmkachBot, a Lua Telegram bot for chats
-- Copyright (c) 2019 Evgeny Shulgin, MIT License
-- =========================================

local requests = require("requests")

local wolfram = {}

local template = "http://api.wolframalpha.com/v1/simple"
local args = {
    ["appid"] = os.getenv("WOLFRAM_TOKEN"),
    ["background"] = 193555,
    ["foreground"] = "white",
    ["fontsize"] = 18,
    ["layour"] = "labelbar"
}

--------------------------------------------
-- Sends a query to the Wolfram API and returns
-- an image of the result.
-- @param input Query text.
--------------------------------------------
function wolfram.build_query(input)
    res = template .. "?"
    for key, value in pairs(args) do
        res = res .. key .. "=" .. value .. "&"
    end
    res = res .. "i=" .. input
    return res
end

return wolfram
