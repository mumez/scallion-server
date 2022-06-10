local http = require "resty.http"
local cjson = require "cjson"
local lrucache = require "resty.lrucache"
local target_url = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
local cach_key = "pubkeys"

local cache, cache_err = lrucache.new(1)
if not cache then
    ngx.say("Failed to create the cache: ", cache_err)
    return
end

local function max_age(cache_control)
    local max_age = string.match(cache_control, "max%-age=(%d+)")
    if not max_age then max_age = 0 end
    -- ngx.say("max-age: ", max_age)
    return max_age
end

local function get_pub_keys()

    local httpc = http.new()
    local res, err = httpc:request_uri(target_url, {
        method = "GET",
        ssl_verify = false
    })

    if not res then
        ngx.say("Failed to request: ", err)
        return
    end

    local dict = cache:get(cach_key)
    if not dict then
        -- ngx.say("cache miss!")
        dict = cjson.decode(res.body)
        cache:set(cach_key, dict, max_age(res.headers["cache-control"]))
    end

    ---- For debug
    -- ngx.say("pub keys dict", string.format('%q', dict) );
    -- for k, v in pairs(dict) do
    --     ngx.say("k: ", k)
    --     ngx.say("v: ", v)
    -- end

    return dict
end

return {
    get_pub_keys = get_pub_keys,
}

