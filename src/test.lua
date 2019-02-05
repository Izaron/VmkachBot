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
local weather = require("weather")

-- Local variables
local owner = os.getenv("OWNER")

local test = {}

--------------------------------------------
-- Tests api.send_message - sends a message to "owner"
-- @param api Telegram API object
--------------------------------------------
function test.test_send_message(api)
    api.send_message(
        owner,
        "Hi, there is a banana " .. emoji.emoji_unicode["banana"]
    )
end

--------------------------------------------
-- Tests emoji.lua - sends a bunch of emojis and its names
-- @param api Telegram API object
--------------------------------------------
function test.test_emoji(api)
    local t = emoji.emoji_unicode -- shortened alias
    local keys = {}

    for k in pairs(t) do
        -- the emoji list contains a huge number of similar
        -- emojis with "tone" in name - exclude them
        if not k:find("tone") then
            table.insert(keys, k)
        end
    end

    math.randomseed(130799) -- send fixed set of emojis
    msg = "Test emojis\n\n"
    for i = 1, 20 do
        index = math.random(#keys)
        emoji_name = keys[index]
        msg = msg .. emoji_name .. " - " .. t[emoji_name] .. "\n"
    end

    api.send_message(
        owner,
        msg
    )
end

--------------------------------------------
-- Tests wolfram.lua - sends an image of processed query
-- @param api Telegram API object
--------------------------------------------
function test.test_wolfram(api)
    api.send_document(
        owner,
        wolfram.build_query("Integrate sin(x)")
    )
end

--------------------------------------------
-- Tests weather.lua - sends a message about current weather
-- @param api Telegram API object
--------------------------------------------
function test.test_weather(api)
    api.send_message(
        owner,
        weather.get_current_weather()
    )
end


function test.test_all(api)
    print("Run all test")
    test.test_send_message(api)
    test.test_emoji(api)
    test.test_wolfram(api)
    test.test_weather(api)
    print("Tests done!")
end

return test
