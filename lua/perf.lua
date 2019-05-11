local math_random = math.random
local table_concat = table.concat

-- uri_charset
local uri_charset = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._~:/@!,;=+*-"
local uri_charset_length = #uri_charset
local uri_random_charset = {}

for i = 1, uri_charset_length do
    uri_random_charset[i] = string.sub(uri_charset, i, i)
end

local _M = {}

local function init()
    local seed = 0

    local frandom, err = io.open("/dev/urandom", "rb")
    if not frandom then
      ngx.log(ngx.WARN, 'failed to open /dev/urandom: ', err)
    else
        local str = frandom:read(4)
        frandom:close()
        if not str then
            ngx.log(ngx.WARN, 'failed to read data from /dev/urandom')
        else
            for i = 1, 4 do
                seed = 256 * seed + str:byte(i)
            end
        end
    end

    if seed == 0 then
        ngx.log(ngx.WARN, 'failed to get seed from urandom')
        seed = ngx.now() * 1000 + ngx.worker.pid()
    end

    math.randomseed(seed)
end

local function gen_uri_comp()
    local value = {}
    local len = math_random(20) -- between 1 and 20

    for i = 1, len do
        value[i] = uri_random_charset[math_random(uri_charset_length)]
    end

    return table_concat(value, "")
end

local function gen_body()
    local body = ''
    local n = math_random(1000)

    for i = 1, n do
        body = body .. gen_uri_comp() .. "=" .. gen_uri_comp()
        if i < n then
            body = body .. "&"
        end
    end
    return body
end


local function run()
    local response = gen_body()
    ngx.say(response)
end

_M.init = init
_M.run = run
return _M
