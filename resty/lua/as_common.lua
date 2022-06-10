
local resty_sha256 = require "resty.sha256"
local resty_str = require "resty.string"
local cjson = require "cjson"

--- accessing
local function aud()
  return 'scallion-fefc3'
end

local function iss()
    return 'https://securetoken.google.com/' .. aud()
end

local function alg()
    return 'RS256'
end

--- private functions
local function sha256(str)
    local sha256 = resty_sha256:new()
    sha256:update(str)
    local digest = sha256:final()
    return resty_str.to_hex(digest)
end

local function read_jwt_from_header()
  local headers = ngx.req.get_headers()
  local jwt = headers.authorization:gsub("Bearer%s+", "")
  return jwt
end


local function read_json_body()
  ngx.req.read_body()
  local body_data = ngx.req.get_body_data()
  local json = cjson.decode(body_data)
  return json
end

local function is_past_utc_seconds(secs)
  return os.time() > secs
end

return {
  sha256 = sha256,
  read_json_body = read_json_body,
  read_jwt_from_header = read_jwt_from_header,
  is_past_utc_seconds = is_past_utc_seconds,
  iss = iss,
  alg = alg
}
