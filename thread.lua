local https = require "https"
local url, options, channel  = ...

local code, body, headers = https.request(url, options)

channel:push({
	code = code,
	body = body,
	headers = headers,
	ok = (code >= 200 and code < 300)
})