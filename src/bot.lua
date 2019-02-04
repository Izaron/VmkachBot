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

-- define the commands
local commands = {}

--------------------------------------------
-- Returns random number in [1..100]
-- @param msg New message (table).
--------------------------------------------
function commands.random(msg)
    api.send_message(
        msg.chat.id,
        math.random(100)
    )
end

--------------------------------------------
-- Sends a query to the Wolfram API and returns
-- an image of the result.
-- @param msg New message (table).
--------------------------------------------
function commands.wolfram(msg)
    text = msg.text

    -- First symbol is '/'
    -- Then any number of non-whitespaces
    -- Then at least one whitespace
    -- Then one non-whitespace
    a, b = text:find("/%S*%s%s*%S") -- 'b' now points at first
                                    -- non-space letter after '/com'

    if b then
        api.send_document(
            msg.chat.id,
            wolfram.build_query(text:sub(b))
        )
    end
end

--------------------------------------------
-- Sends a query to the Wolfram API and returns
-- an image of the result.
-- @param msg New message (table).
--------------------------------------------
commands.wf = commands.wolfram

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
            if commands[com] then
                commands[com](msg)
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
