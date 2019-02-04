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
local commands = require("commands")

-- Load the API
local token = os.getenv("TOKEN")
local owner = os.getenv("OWNER")
local api = require("telegram-bot-lua.core").configure(token)

--------------------------------------------
-- Handles new message
-- @param msg New message (table).
--------------------------------------------
function api.on_message(msg)
    -- Debug print
    -- print(inspect(msg))

    -- Do the command or echo the message
    text = msg.text
    if text then
        if text:sub(1, 1) == "/" then
            -- found a command
            a, b = text:find("/%S*")
            com = text:sub(a + 1, b)
            if commands.table[com] then
                commands.table[com](api, msg)
            end
        else
            -- regular message, echo it
            print(msg.chat.username .. " wrote ".. text)
            api.send_message(
                msg.chat.id,
                "Hello. You wrote " .. text
            )
        end
    end
end

--------------------------------------------
-- This function is called before the main loop
--------------------------------------------
function on_start()
    print("The bot is running")
    api.send_message(
        owner,
        "Hi, there is a banana " .. emoji.emoji_unicode["banana"]
    )
end


on_start()
api.run()
