local path = (...):gsub("worker", "")
local Response = require(path .. "response")

local slashedPath = path:gsub("%.", "/")

local Worker = {}
Worker.__index = Worker

function Worker.new()
	local channel = love.thread.newChannel()
	local thread = love.thread.newThread(slashedPath .. "thread.lua")
	
	thread:start(channel)
	
	return setmetatable({
		thread = thread,
		channel = channel
	}, Worker)
end

function Worker:request(url, options, callback)
	assert(type(url) == "string", "Bad URL")
	assert(type(options) == "table" or type(options) == "nil", "Bad options")
	assert(type(callback) == "function", "Bad callback")
	
	self.callback = callback
	self.id = self.channel:push({url = url, options = options})
end

function Worker:catchErrors()
	local err = self.thread:getError()
	if err then error(err) end
end

function Worker:isFinished()
	return self.channel:hasRead(self.id) and self.channel:getCount() > 0
end

function Worker:getResponse()
	return Response.new(self.channel:pop())
end

function Worker:process()
	self:catchErrors()
	if self:isFinished() then
		self.callback(self:getResponse())
		return true
	end
end

return Worker