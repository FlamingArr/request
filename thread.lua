local https = require "https"
local channel = ...
local id

while true do
	if (not id) or channel:hasRead(id) then
		local request = channel:demand()
		local code, body, headers = https.request(request.url, request.options)
		
		id = channel:push({
			code = code,
			body = body,
			headers = headers,
			ok = code >= 200 and code <= 299
		})
	end
end
