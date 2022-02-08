local path = (...)
local pool = require(path .. ".pool")

do --Make sure requirements are met
	local ok = pcall(require, "https")
	if not ok then
		error("lua-https is not avaliable. Please see notes in README")
	end
	
	if not love.thread then
		error("love.thread is disabled. Please see notes in README")
	end
end

local request = {}
local busyWorkers = {}

function request._new(url, options, callback)
	if type(options) == "function" then
		options, callback = callback, options
	end
	
	local worker = pool:get()
	worker:request(url, options, callback)
	
	table.insert(busyWorkers, worker)
end

function request.update()
	for i = #busyWorkers, 1, -1 do
		local worker = busyWorkers[i]
		
		if worker:process() then
			table.remove(busyWorkers, i)
			pool:put(worker)
		end
	end
end

function request.getPendingCount()
	return #busyWorkers
end

function request._debugStats()
	return {
		busy = #busyWorkers,
		idle = pool:count()
	}
end

return setmetatable(request, {__call = function(_, ...)
	return request._new(...)
end })