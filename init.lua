local path = (...)
local slahedPath = path:gsub("%.", "/")
local Response = require(path .. ".response")

do --Make sure lua-https is avaliable
	local ok = pcall(require, "https")
	if not ok then
		error("lua-https is not avaliable. Please see notes in README")
	end
end

local request = {}
local pendingRequests = {}

function request._newRequest(url, options, callback)
	if type(options) == "function" then
		options, callback = callback, options
	end
	
	local thread = love.thread.newThread(slahedPath .. "/thread.lua")
	local channel = love.thread.newChannel()
	
	thread:start(url, options, channel)
	
	local req = {
		thread = thread,
		channel = channel,
		callback = callback
	}
	
	table.insert(pendingRequests, req)
end

function request.update()
	for i = #pendingRequests, 1, -1 do
		local req = pendingRequests[i]
		
		local err = req.thread:getError()
		if err then error(err) end
		
		if req.channel:getCount() > 0 then
			local response = Response.new(req.channel:pop())
			req.callback(response)
			
			req.thread:release()
			req.channel:release()
			
			table.remove(pendingRequests, i)
		end
	end
end

function request.getPendingCount()
	return #pendingRequests
end

return setmetatable(request, {__call = function(_, ...)
	return request._newRequest(...)
end })