-- =========================================
-- VmkachBot, a Lua Telegram bot for chats
-- Copyright (c) 2019 Evgeny Shulgin, MIT License
-- =========================================

--[[
local utf8 = require("lua-utf8")
local u = utf8.escape
local stringy = require("stringy")
]]--
local inspect = require("inspect")

-- Load the API
local token = os.getenv("TOKEN")
local api = require("telegram-bot-lua.core").configure(token)

function api.on_message(msg)
    -- Debug print
    print(inspect(msg))

    -- Echo the message
    text = msg.text
    if text then
        print(msg.chat.username .. " wrote ".. text)

        api.send_message(
            msg.chat.id,
            "Hello. You wrote " .. text
        )
    else
        return
    end
end

print("The bot is running")
api.run()
