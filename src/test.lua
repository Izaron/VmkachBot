-- =========================================
-- VmkachBot, a Lua Telegram bot for chats
-- Copyright (c) 2019 Evgeny Shulgin, MIT License
-- =========================================

-- Library includies
local requests = require("requests")
local inspect = require("inspect")

-- Project module includies
local emoji = require("emoji")
local wolfram = require("wolfram")

-- Local variables
local owner = os.getenv("OWNER")

local test = {}

--------------------------------------------
-- Tests api.send_message
-- @param api Telegram API object
--------------------------------------------
function test.send_message(api)
    api.send_message(
        owner,
        "Hi, there is a banana " .. emoji.emoji_unicode["banana"]
    )
end

function test.test_all(api)
    print("Run all test")
    test.send_message(api)
end

return test
