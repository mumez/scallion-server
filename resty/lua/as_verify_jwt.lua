local cjson = require "cjson"
local jwt = require "resty.jwt"

local common = require "as_common"

local pub = require "as_pub_keys"
local pub_keys = pub.get_pub_keys()

-- ngx.say('pub_keys: ', cjson.encode(pub_keys))

if not pub_keys then
    pub_keys = {} -- Empty table - auth will fail
end

local claim_spec = {
    iss = function(val)
        for _, value in pairs({common.iss()}) do
            if value == val then return true end
        end
        return false
    end,
    exp = function(val)
        return not (common.is_past_utc_seconds(val))
    end,
    iat = function(val)
        return (common.is_past_utc_seconds(val))
    end,
    auth_time = function(val)
        return (common.is_past_utc_seconds(val))
    end,
    sub = function(val)
        return not (val == nil or s == '')
    end,
    __jwt = function(val, claim, jwt_json)
        if val.header.alg ~= common.alg() then
            error("Need to specify 'alg':" .. common.alg())
        end
    end
}

local jwt_token = common.read_jwt_from_header()

local jwt_obj = jwt:load_jwt(jwt_token)
local header = jwt_obj.header

if not header then
    print("NO JWT")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

local payload = jwt_obj.payload
local pub_key = pub_keys[header.kid]

-- print("pub_key: ", pub_key)
if not pub_key then
    print("NO PUB_KEY")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

jwt_obj = jwt:verify_jwt_obj(pub_key , jwt_obj, claim_spec)

if not jwt_obj.verified then
    print("UNAUTHORIZED reason:" .. jwt_obj.reason)
    return ngx.exit(ngx.HTTP_UNAUTHORIZED) 
end

ngx.say(cjson.encode(jwt_obj))
