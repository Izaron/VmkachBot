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

-- Load the API
local token = os.getenv("TOKEN")
local owner = os.getenv("OWNER")
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
api.send_message(
    owner,
    "Hi, there is a banana " .. emoji.emoji_unicode["banana"]
)

api.run()
