local M = {}

local weekdays = {
    sunday = 1,
    monday = 2,
    tuesday = 3,
    wednesday = 4,
    thursday = 5,
    friday = 6,
    saturday = 7,
}

local function at_noon(year, month, day)
    return os.time({ year = year, month = month, day = day, hour = 12, min = 0, sec = 0 })
end

local function normalize(timestamp)
    return os.date("%Y-%m-%d", timestamp)
end

local function days_in_month(year, month)
    return tonumber(os.date("%d", at_noon(year, month + 1, 0)))
end

---@param expression string
---@param now? integer
---@return string?, string?
function M.parse(expression, now)
    expression = vim.trim(expression or ""):lower():gsub("%s+", " ")
    if expression == "" then
        return nil, "Invalid date expression"
    end

    local current = os.date("*t", now or os.time())
    local year, month, day = expression:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    if year then
        year, month, day = tonumber(year), tonumber(month), tonumber(day)
        local timestamp = at_noon(year, month, day)
        local parsed = os.date("*t", timestamp)
        if parsed.year ~= year or parsed.month ~= month or parsed.day ~= day then
            return nil, "Invalid date expression: " .. expression
        end
        return normalize(timestamp)
    end

    if expression == "today" then
        return normalize(at_noon(current.year, current.month, current.day))
    end
    if expression == "yesterday" then
        return normalize(at_noon(current.year, current.month, current.day - 1))
    end

    local count, unit = expression:match("^(%d+) (day)s? ago$")
    if not count then
        count, unit = expression:match("^(%d+) (week)s? ago$")
    end
    if count then
        local days = tonumber(count) * (unit == "week" and 7 or 1)
        return normalize(at_noon(current.year, current.month, current.day - days))
    end

    count = expression:match("^(%d+) months? ago$")
    if count then
        local zero_based = current.year * 12 + current.month - 1 - tonumber(count)
        local target_year = math.floor(zero_based / 12)
        local target_month = zero_based % 12 + 1
        local target_day = math.min(current.day, days_in_month(target_year, target_month))
        return normalize(at_noon(target_year, target_month, target_day))
    end

    local weekday = expression:match("^last (%a+)$")
    local target_weekday = weekday and weekdays[weekday]
    if target_weekday then
        local delta = (current.wday - target_weekday) % 7
        if delta == 0 then
            delta = 7
        end
        return normalize(at_noon(current.year, current.month, current.day - delta))
    end

    return nil, "Invalid date expression: " .. expression
end

local function tokenize(arguments)
    local tokens = {}
    local current = {}
    local quote
    local escaped = false

    for index = 1, #arguments do
        local char = arguments:sub(index, index)
        if escaped then
            current[#current + 1] = char
            escaped = false
        elseif char == "\\" then
            escaped = true
        elseif quote then
            if char == quote then
                quote = nil
            else
                current[#current + 1] = char
            end
        elseif char == '"' or char == "'" then
            quote = char
        elseif char:match("%s") then
            if #current > 0 then
                tokens[#tokens + 1] = table.concat(current)
                current = {}
            end
        else
            current[#current + 1] = char
        end
    end

    if quote then
        return nil, "Unterminated quote"
    end
    if escaped then
        current[#current + 1] = "\\"
    end
    if #current > 0 then
        tokens[#tokens + 1] = table.concat(current)
    end

    return tokens
end

---@param arguments string
---@param now? integer
---@return table?, string?
function M.parse_arguments(arguments, now)
    local tokens, token_error = tokenize(arguments or "")
    if not tokens then
        return nil, token_error
    end

    local result = { query = "" }
    local query = {}
    local index = 1

    while index <= #tokens do
        local token = tokens[index]
        local name, value = token:match("^%-%-(since)=(.+)$")
        if not name then
            name, value = token:match("^%-%-(until)=(.+)$")
        end
        if not name and (token == "--since" or token == "--until") then
            name = token:sub(3)
            index = index + 1
            value = tokens[index]
            if not value then
                return nil, "Missing value for --" .. name
            end
        end

        if name then
            local parsed, parse_error = M.parse(value, now)
            if not parsed then
                return nil, parse_error
            end
            result[name] = parsed
        elseif token:match("^%-%-") then
            return nil, "Unknown option: " .. token
        else
            query[#query + 1] = token
        end

        index = index + 1
    end

    result.query = table.concat(query, " ")
    if result.since and result["until"] and result.since > result["until"] then
        return nil, "--since must not be after --until"
    end

    return result
end

return M
