local path = (...):gsub("response", "")
local JSON = require(path .. "json.json")

local Response = {}
Response.__index = Response

function Response.new(rawResponse)
	return setmetatable(rawResponse, Response)
end

function Response:assert()
	assert(self.ok, self.body)
	return self
end

function Response:table()
	return JSON.decode(self.body)
end

return Response