-- Version: 0.5 (BETA)

local Thread, Call, AddConnection, RemoveConnection
local signalMetatable, connectionMetatable, constructor, signalGet, signalSet, connectionGet, connectionSet
local private = {}
local threads = {}



-- Types
export type Constructor = {
	new: () -> Signal,
}

export type Signal = {
	Connect: (self: Signal, func: (...any) -> (), ...any) -> Connection,
	Once: (self: Signal, func: (...any) -> (), ...any) -> Connection,
	Wait: (self: Signal, ...any) -> ...any,
	Fire: (self: Signal, ...any) -> (),
	FastFire: (self: Signal, ...any) -> (),
	DisconnectAll: (self: Signal) -> (),
}

export type Connection = {
	Signal: Signal?,
	Disconnect: (self: Connection) -> (),
}



-- Metatables
signalMetatable = {
	__metatable = "The metatable is locked",
	__tostring = function(proxy) return "Signal" end,
	__iter = function(proxy) error("Attempt to iterate over a Signal value", 2) end,
	__index = function(proxy, index) return if signalGet[index] == private then proxy[private][index] else signalGet[index] end,
	__newindex = function(proxy, index, value) if signalSet[index] == nil then error("Attempt to modify a readonly value", 2) end signalSet[index](proxy, value) end,
}

connectionMetatable = {
	__metatable = "The metatable is locked",
	__tostring = function(proxy) return "Connection" end,
	__iter = function(proxy) error("Attempt to iterate over a Connection value", 2) end,
	__index = function(proxy, index) return if connectionGet[index] == private then proxy[private][index] else connectionGet[index] end,
	__newindex = function(proxy, index, value) if connectionSet[index] == nil then error("Attempt to modify a readonly value", 2) end connectionSet[index](proxy, value) end,
}



-- Constructor
constructor = {
	new = function()
		local signal = {}
		return setmetatable({[private] = signal}, signalMetatable)
	end,
}



-- Signal
signalGet = {
	["Connect"] = function(proxy, callback, ...)
		if type(callback) ~= "function" then error("Attempt to connect failed: Passed value is not a function", 3) end
		local parameters = {...}
		local connection = {
			["Signal"] = proxy,
			["Callback"] = callback,
			["Once"] = false,
			["Parameters"] = if #parameters == 0 then nil else parameters,
		}
		AddConnection(proxy[private], connection)
		return setmetatable({[private] = connection}, connectionMetatable)
	end,
	["Once"] = function(proxy, callback, ...)
		if type(callback) ~= "function" then error("Attempt to connect failed: Passed value is not a function", 3) end
		local parameters = {...}
		local connection = {
			["Signal"] = proxy,
			["Callback"] = callback,
			["Once"] = true,
			["Parameters"] = if #parameters == 0 then nil else parameters,
		}
		AddConnection(proxy[private], connection)
		return setmetatable({[private] = connection}, connectionMetatable)
	end,
	["Wait"] = function(proxy, ...)
		local parameters = {...}
		local connection = {
			["Signal"] = proxy,
			["Callback"] = coroutine.running(),
			["Once"] = true,
			["Parameters"] = if #parameters == 0 then nil else parameters,
		}
		AddConnection(proxy[private], connection)
		return coroutine.yield()
	end,
	["Fire"] = function(proxy, ...)
		local signal = proxy[private]
		local connection = signal.First
		while connection ~= nil do
			if connection.Once == true then RemoveConnection(signal, connection) connection.Signal = nil end
			if type(connection.Callback) == "thread" then
				if connection.Parameters == nil then
					task.spawn(connection.Callback, ...)
				else
					local parameters = {...}
					task.spawn(connection.Callback, table.unpack(table.move(connection.Parameters, 1, #connection.Parameters, #parameters + 1, parameters)))
				end
			else
				local thread = table.remove(threads)
				if thread == nil then thread = coroutine.create(Thread) coroutine.resume(thread) end
				if connection.Parameters == nil then
					task.spawn(thread, thread, connection.Callback, ...)
				else
					local parameters = {...}
					task.spawn(thread, thread, connection.Callback, table.unpack(table.move(connection.Parameters, 1, #connection.Parameters, #parameters + 1, parameters)))
				end
			end
			connection = connection.Next
		end
	end,
	["FastFire"] = function(proxy, ...)
		local signal = proxy[private]
		local connection = signal.First
		while connection ~= nil do
			if connection.Once == true then RemoveConnection(signal, connection) connection.Signal = nil end
			if type(connection.Callback) == "thread" then
				if connection.Parameters == nil then
					task.spawn(connection.Callback, ...)
				else
					local parameters = {...}
					task.spawn(connection.Callback, table.unpack(table.move(connection.Parameters, 1, #connection.Parameters, #parameters + 1, parameters)))
				end
			else
				if connection.Parameters == nil then
					connection.Callback(...)
				else
					local parameters = {...}
					connection.Callback(table.unpack(table.move(connection.Parameters, 1, #connection.Parameters, #parameters + 1, parameters)))
				end
			end
			connection = connection.Next
		end
	end,
	["DisconnectAll"] = function(proxy)
		local signal = proxy[private]
		local connection = signal.First
		while connection ~= nil do
			connection.Signal = nil
			if type(connection.Callback) == "thread" then task.cancel(connection.Callback) end
			connection = connection.Next
		end
		signal.First, signal.Last = nil, nil
	end,
}

signalSet = {
	
}



-- Connection
connectionGet = {
	["Signal"] = private,
	["Disconnect"] = function(proxy)
		local connection = proxy[private]
		if connection.Signal == nil then return end
		if type(connection.Callback) == "thread" then task.cancel(connection.Callback) end
		RemoveConnection(connection.Signal[private], connection)
		connection.Signal = nil
	end
}

connectionSet = {
	
}



-- Functions
Thread = function()
	while true do Call(coroutine.yield()) end
end

Call = function(thread, callback, ...)
	callback(...)
	if #threads >= 16 then return end
	table.insert(threads, thread)
end

AddConnection = function(signal, connection)
	if signal.First == nil then
		signal.First, signal.Last = connection, connection
	else
		connection.Previous, signal.Last.Next, signal.Last = signal.Last, connection, connection
	end
end

RemoveConnection = function(signal, connection)
	if signal.First == connection then signal.First = connection.Next end
	if signal.Last == connection then signal.Last = connection.Previous end
	if connection.Previous ~= nil then connection.Previous.Next = connection.Next end
	if connection.Next ~= nil then connection.Next.Previous = connection.Previous end
end



return table.freeze(constructor) :: Constructor
