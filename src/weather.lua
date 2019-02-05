-- =========================================
-- VmkachBot, a Lua Telegram bot for chats
-- Copyright (c) 2019 Evgeny Shulgin, MIT License
-- =========================================

-- Library includies
local requests = require("requests")
local inspect = require("inspect")
local json = require("cjson")
local stringy = require("stringy")

-- Project module includies
local emoji = require("emoji")

-- Local variables
local owner = os.getenv("OWNER")
local token = os.getenv("WEATHER_TOKEN")

local template = "http://api.openweathermap.org/data/2.5/"
local query_time_table = {}
local query_results = {}
local EXPIRATION_TIME = 1200 -- cache time for queries in seconds

local args = {
    ["id"] = 524901, -- city id of Moscow, Russia
    ["lang"] = "ru",
    ["APPID"] = token,
    ["units"] = "metric",
    ["cnt"] = 8
}

-- Dict to return
local weather = {}

--------------------------------------------
-- Builds a query to Open Weather API
-- @param mode Either "forecast" (future weather)
--      or "weather" (current weather)
--------------------------------------------
local function build_query(mode)
    res = template .. mode .. "?"
    for key, value in pairs(args) do
        res = res .. key .. "=" .. value .. "&"
    end
    res = res:sub(1, #res - 1)
    return res
end

--------------------------------------------
-- Gets a query using caching
-- @param query Query to complete
--------------------------------------------
local function get_query_results(query)
    cur_time = os.time()
    if not query_time_table[query]
        or cur_time > query_time_table[query] + EXPIRATION_TIME then
        query_time_table[query] = cur_time
        query_results[query] = requests.get(query)
    end
    return query_results[query]
end

--------------------------------------------
-- Returns emoji name based on the weather code
-- @param code Open Weather API code
--------------------------------------------
local function get_emoji_name_by_weather(code)
    local sw = stringy.startswith
    code = tostring(code)

    -- codes below taken from https://openweathermap.org/weather-conditions
    if sw(code, "2") then -- 2xx - thunderstorm
        return "cloud_with_lightning_and_rain"
    elseif sw(code, "3") then -- 3xx - drizzle
        return "umbrella_with_rain_drops"
    elseif sw(code, "5") then -- 5xx - rain
        return "cloud_with_rain"
    elseif sw(code, "6") then -- 6xx - snow
        return "snowflake"
    elseif sw(code, "701") or sw(code, "711") or sw(code, "721")
        or sw(code, "741") then -- 7xx - atmosphere
        return "fog"
    elseif sw(code, "762") then
        return "volcano"
    elseif sw(code, "771") then
        return "dashing_away"
    elseif sw(code, "781") then
        return "tornado"
    elseif sw(code, "731") or sw(code, "751") or sw(code, "761") then
        return "comet"
    elseif sw(code, "800") then -- 800 - clear
        return "sun"
    elseif sw(code, "80") then -- 80x - clouds
        return "cloud"
    end
end

--------------------------------------------
-- Generates a string with info about current weather
-- @param api Telegram API object
--------------------------------------------
function weather.get_current_weather()
    query = build_query("weather")
    results = get_query_results(query)

    res = ""
    if results.status_code == 200 then
        t = json.decode(results.text)
        datetime = os.date("!*t", t["dt"])

        -- Time of the last dump
        res = res .. string.format("Информация о погоде на %.2d:%.2d\n",
            datetime.hour, datetime.min)

        -- Temperature info
        res = res .. string.format("Температура %.1f градусов\n", t["main"]["temp"])

        -- Weather description info
        weather_object = t["weather"][1]
        res = res .. "Сейчас " .. weather_object["description"]
        res = res .. " " .. emoji.emoji_unicode[get_emoji_name_by_weather(weather_object["id"])]
    else
        -- Failed to get weather info
        res = "Не удалось получить информацию о погоде"
    end

    return res
end

return weather
