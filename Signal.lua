-- Version: 0.3 (BETA)

local Thread, Call
local privateIndex, signalMetatable, connectionMetatable = {}, {}, {}
local constructor, signal, connection = {}, {}, {}
local threads = {}
local permissions = {["Signal"] = false, ["Disconnect"] = false}


-- Types
export type Constructor = {
	new: () -> Signal,
}

export type Signal = {
	Connect: (self: Signal, func: (...any) -> ()) -> Connection,
	Once: (self: Signal, func: (...any) -> ()) -> Connection,
	Wait: (self: Signal) -> ...any,
	DisconnectAll: (self: Signal) -> (),
	Fire: (self: Signal, ...any) -> (),
}

export type Connection = {
	Signal: Signal?,
	Disconnect: (self: Connection) -> (),
}


-- Metatables
signalMetatable.__metatable = "The metatable is locked"
signalMetatable.__tostring = function(proxy) return "Signal" end
signalMetatable.__iter = function(proxy) return next, {} end
signalMetatable.__newindex = function(proxy, index, value) error("Attempt to modify a readonly table", 2) end
signalMetatable.__index = signal

connectionMetatable.__metatable = "The metatable is locked"
connectionMetatable.__tostring = function(proxy) return "Connection" end
connectionMetatable.__iter = function(proxy) return next, {} end
connectionMetatable.__newindex = function(proxy, index, value) error("Attempt to modify a readonly table", 2) end
connectionMetatable.__index = function(proxy, index)
	if permissions[index] == nil then return end
	return if proxy[privateIndex][index] == nil then connection[index] else proxy[privateIndex][index]
end


-- Constructor
constructor.new = function()
	local signalObject = {}
	return setmetatable({[privateIndex] = signalObject}, signalMetatable)
end


-- Signal
signal.Connect = function(proxy, callback)
	if type(callback) ~= "function" then error("Attempt to connect failed: Passed value is not a function", 2) end
	local signalObject = proxy[privateIndex]
	local connectionObject = {}
	connectionObject.Signal = proxy
	connectionObject.Callback = callback
	connectionObject.Once = false
	if signalObject.First == nil then
		signalObject.First, signalObject.Last = connectionObject, connectionObject
	else
		connectionObject.Previous, signalObject.Last.Next, signalObject.Last = signalObject.Last, connectionObject, connectionObject
	end
	return setmetatable({[privateIndex] = connectionObject}, connectionMetatable)
end

signal.Once = function(proxy, callback)
	if type(callback) ~= "function" then error("Attempt to connect failed: Passed value is not a function", 2) end
	local signalObject = proxy[privateIndex]
	local connectionObject = {}
	connectionObject.Signal = proxy
	connectionObject.Callback = callback
	connectionObject.Once = true
	local signalObject = proxy[privateIndex]
	if signalObject.First == nil then
		signalObject.First, signalObject.Last = connectionObject, connectionObject
	else
		connectionObject.Previous, signalObject.Last.Next, signalObject.Last = signalObject.Last, connectionObject, connectionObject
	end
	return setmetatable({[privateIndex] = connectionObject}, connectionMetatable)
end

signal.Wait = function(proxy)
	local signalObject = proxy[privateIndex]
	local connectionObject = {}
	connectionObject.Signal = proxy
	connectionObject.Callback = coroutine.running()
	connectionObject.Once = true
	if signalObject.First == nil then
		signalObject.First, signalObject.Last = connectionObject, connectionObject
	else
		connectionObject.Previous, signalObject.Last.Next, signalObject.Last = signalObject.Last, connectionObject, connectionObject
	end
	return coroutine.yield()
end

signal.DisconnectAll = function(proxy)
	local signalObject = proxy[privateIndex]
	local connectionObject = signalObject.First
	while connectionObject ~= nil do
		connectionObject.Signal = nil
		if type(connectionObject.Callback) == "thread" then task.cancel(connectionObject.Callback) end
		connectionObject = connectionObject.Next
	end
	signalObject.First, signalObject.Last = nil, nil
end

signal.Fire = function(proxy, ...)
	local signalObject = proxy[privateIndex]
	local connectionObject = signalObject.First
	while connectionObject ~= nil do
		if connectionObject.Once == true then
			connectionObject.Signal = nil
			if signalObject.First == connectionObject then signalObject.First = connectionObject.Next end
			if signalObject.Last == connectionObject then signalObject.Last = connectionObject.Previous end
			if connectionObject.Previous ~= nil then connectionObject.Previous.Next = connectionObject.Next end
			if connectionObject.Next ~= nil then connectionObject.Next.Previous = connectionObject.Previous end
		end
		if type(connectionObject.Callback) == "thread" then
			task.spawn(connectionObject.Callback, ...)
		else
			local thread = table.remove(threads)
			if thread == nil then thread = coroutine.create(Thread) coroutine.resume(thread) end
			task.spawn(thread, thread, connectionObject.Callback, ...)			
		end
		connectionObject = connectionObject.Next
	end
end


-- Connection
connection.Disconnect = function(proxy)
	local connectionObject = proxy[privateIndex]
	local signalObject = connectionObject.Signal[privateIndex]
	if signalObject == nil then return end
	connectionObject.Signal = nil
	if type(connectionObject.Callback) == "thread" then task.cancel(connectionObject.Callback) end
	if signalObject.First == connectionObject then signalObject.First = connectionObject.Next end
	if signalObject.Last == connectionObject then signalObject.Last = connectionObject.Previous end
	if connectionObject.Previous ~= nil then connectionObject.Previous.Next = connectionObject.Next end
	if connectionObject.Next ~= nil then connectionObject.Next.Previous = connectionObject.Previous end
end


-- Functions
Thread = function()
	while true do Call(coroutine.yield()) end
end

Call = function(thread, callback, ...)
	callback(...)
	table.insert(threads, thread)
end


return table.freeze(constructor) :: Constructor
