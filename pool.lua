local path = (...):gsub("pool", "")
local Worker = require(path .. "worker")

local pool = {}
local workers = {}

function pool:get(...)
	local worker = table.remove(workers)
	if not worker then
		worker = Worker.new()
	end
	return worker
end

function pool:put(worker)
	table.insert(workers, worker)
end

function pool:count()
	return #workers
end

return pool