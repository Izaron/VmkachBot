-- =========================================
-- VmkachBot, a Lua Telegram bot for chats
-- Copyright (c) 2019 Evgeny Shulgin, MIT License
-- =========================================
--
-- Project module includies
local emoji = require("emoji")
local wolfram = require("wolfram")

local commands = {}
local seed_set = false

--------------------------------------------
-- Returns random number in [1..100]
-- @param api Telegram API.
-- @param msg New message (table).
--------------------------------------------
function commands.random(api, msg)
    if not seed_set then
        seed_set = true
        math.randomseed(os.time())
    end

    api.send_message(
        msg.chat.id,
        math.random(100)
    )
end

--------------------------------------------
-- Sends a query to the Wolfram API and returns
-- an image of the result.
-- @param api Telegram API.
-- @param msg New message (table).
--------------------------------------------
function commands.wolfram(api, msg)
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
-- @param api Telegram API.
-- @param msg New message (table).
--------------------------------------------
commands.wf = commands.wolfram

return { table = commands }
