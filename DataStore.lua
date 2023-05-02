-- Version: 0.15 (BETA)

local signalModule = require(script.Signal)
local dataStoreService = game:GetService("DataStoreService")
local memoryStoreService = game:GetService("MemoryStoreService")
local httpService = game:GetService("HttpService")
local OpenTask, LoadTask, LockTask, SaveTask, CloseTask, DestroyTask, AddTask, RunTasks, Lock, Unlock, Load, Save, StartSaveTimer, StopSaveTimer, SaveTimerEnded, StartLockTimer, StopLockTimer, LockTimerEnded, Clone, Reconcile, Compress, Decompress, Encode, Decode
local dataStoreMetatable, constructor, dataStoreGet, dataStoreSet
local private = {}
local characters = {[0] = "0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","!","$","%","&","'",",",".","/",":",";","=","?","@","[","]","^","_","`","{","}","~"}
local bytes = {} for i = (0), #characters do bytes[string.byte(characters[i])] = i end
local base = #characters + 1
local dataStores = {}
local bindToClose = {}



-- Types
export type Constructor = {
	new: (name: string, scope: string, key: string?) -> DataStore,
	find: (name: string, scope: string, key: string?) -> DataStore?,
}

export type DataStore = {
	Value: any,
	Metadata: {[string]: any},
	UserIds: {[number]: number},
	SaveInterval: number,
	LockInterval: number,
	LockAttempts: number,
	SaveOnClose: boolean,
	Id: string,
	UniqueId: string,
	Key: string,
	State: boolean?,
	AttemptsRemaining: number,
	CreatedTime: number,
	UpdatedTime: number,
	Version: string,
	CompressedValue: string,
	StateChanged: signalModule.Signal,
	Saving: signalModule.Signal,
	AttemptsChanged: signalModule.Signal,
	Open: (self: DataStore, template: any?) -> (string?, string?),
	Load: (self: DataStore, template: any?) -> (string?, string?),
	Save: (self: DataStore) -> (string?, string?),
	Close: (self: DataStore) -> (string?, string?),
	Destroy: (self: DataStore) -> (string?, string?),
	Clone: (self: DataStore) -> any,
	Reconcile: (self: DataStore, template: any) -> (),
	Usage: (self: DataStore) -> (number, number),
}



-- Metatables
dataStoreMetatable = {
	__metatable = "The metatable is locked",
	__tostring = function(proxy) return "DataStore" end,
	__iter = function(proxy) error("Attempt to iterate over a DataStore value", 2) end,
	__index = function(proxy, index) return if dataStoreGet[index] == private then proxy[private][index] else dataStoreGet[index] end,
	__newindex = function(proxy, index, value) if dataStoreSet[index] == nil then error("Attempt to modify a readonly value", 2) end dataStoreSet[index](proxy, value) end,
}



-- Constructor
constructor = {
	new = function(name, scope, key)
		if key == nil then key, scope = scope, "global" end
		local id = name .. "/" .. scope .. "/" .. key
		if dataStores[id] ~= nil then return dataStores[id].Proxy end
		local dataStore = {
			["Value"] = nil,
			["Metadata"] = {},
			["UserIds"] = {},
			["SaveInterval"] = 30,
			["LockInterval"] = 60,
			["LockAttempts"] = 5,
			["SaveOnClose"] = true,
			["Id"] = id,
			["UniqueId"] = httpService:GenerateGUID(false),
			["Key"] = key,
			["State"] = false,
			["AttemptsRemaining"] = 0,
			["CreatedTime"] = 0,
			["UpdatedTime"] = 0,
			["Version"] = "",
			["CompressedValue"] = "",
			["StateChanged"] = signalModule.new(),
			["Saving"] = signalModule.new(),
			["AttemptsChanged"] = signalModule.new(),
			["Tasks"] = {},
			["SaveThread"] = nil,
			["LockThread"] = nil,
			["LockTime"] = -math.huge,
			["SaveTime"] = -math.huge,
			["ActiveLockInterval"] = 0,
			["Running"] = false,
			["DataStore"] = dataStoreService:GetDataStore(name, scope),
			["MemoryStore"] = memoryStoreService:GetSortedMap(id),
			["Options"] = Instance.new("DataStoreSetOptions"),
		}
		dataStores[dataStore.Id] = dataStore
		bindToClose[dataStore.UniqueId] = dataStore
		dataStore.Proxy = setmetatable({[private] = dataStore}, dataStoreMetatable)
		return dataStore.Proxy
	end,
	find = function(name, scope, key)
		if key == nil then key, scope = scope, "global" end
		local id = name .. "/" .. scope .. "/" .. key
		if dataStores[id] ~= nil then return dataStores[id].Proxy end
	end,
}



--Datastore
dataStoreGet = {
	["Value"] = private,
	["Metadata"] = private,
	["UserIds"] = private,
	["SaveInterval"] = private,
	["LockInterval"] = private,
	["LockAttempts"] = private,
	["SaveOnClose"] = private,
	["Id"] = private,
	["UniqueId"] = private,
	["Key"] = private,
	["State"] = private,
	["AttemptsRemaining"] = private,
	["CreatedTime"] = private,
	["UpdatedTime"] = private,
	["Version"] = private,
	["CompressedValue"] = private,
	["StateChanged"] = private,
	["Saving"] = private,
	["AttemptsChanged"] = private,
	["Open"] = function(proxy, template)
		return AddTask(proxy[private], OpenTask, template)
	end,
	["Load"] = function(proxy, template)
		return AddTask(proxy[private], LoadTask, template)
	end,
	["Save"] = function(proxy)
		return AddTask(proxy[private], SaveTask)
	end,
	["Close"] = function(proxy)
		return AddTask(proxy[private], CloseTask)
	end,
	["Destroy"] = function(proxy)
		local dataStore = proxy[private]
		dataStores[dataStore.Id] = nil
		return AddTask(dataStore, DestroyTask)
	end,
	["Clone"] = function(proxy)
		return Clone(proxy[private].Value)
	end,
	["Reconcile"] = function(proxy, template)
		local dataStore = proxy[private]
		if dataStore.Value == nil then
			dataStore.Value = Clone(template)
		elseif type(dataStore.Value) == "table" and type(template) == "table" then
			Reconcile(dataStore.Value, template)
		end
	end,
	["Usage"] = function(proxy)
		local dataStore = proxy[private]
		if type(dataStore.Metadata.Compress) ~= "table" then
			local characters = #httpService:JSONEncode(dataStore.Value)
			return characters, characters / 4194303
		else
			local level = dataStore.Metadata.Compress.Level or 2
			local decimals = 10 ^ (dataStore.Metadata.Compress.Decimals or 3)
			local safety = if dataStore.Metadata.Compress.Safety == nil then true else dataStore.Metadata.Compress.Safety
			dataStore.CompressedValue = Compress(dataStore.Value, level, decimals, safety)
			local characters = #httpService:JSONEncode(dataStore.CompressedValue)
			return characters, characters / 4194303
		end
	end,
}

dataStoreSet = {
	["Value"] = function(proxy, value)
		proxy[private].Value = value
	end,
	["Metadata"] = function(proxy, value)
		if type(value) ~= "table" then error("Attempt to set Metadata failed: Passed value is not a table", 3) end
		proxy[private].Metadata = value
	end,
	["UserIds"] = function(proxy, value)
		if type(value) ~= "table" then error("Attempt to set UserIds failed: Passed value is not a table", 3) end
		proxy[private].UserIds = value
	end,
	["SaveInterval"] = function(proxy, value)
		if type(value) ~= "number" then error("Attempt to set SaveInterval failed: Passed value is not a number", 3) end
		if value < 6 and value ~= 0 then error("Attempt to set SaveInterval failed: Passed value is less then 6 and not 0", 3) end
		local dataStore = proxy[private]
		if value == 0 then StopSaveTimer(dataStore) elseif dataStore.SaveInterval == 0 then StartSaveTimer(dataStore) end
		dataStore.SaveInterval = value
	end,
	["LockInterval"] = function(proxy, value)
		if type(value) ~= "number" then error("Attempt to set LockInterval failed: Passed value is not a number", 3) end
		if value < 6 then error("Attempt to set LockInterval failed: Passed value is less then 6", 3) end
		if value > 5000 then error("Attempt to set LockInterval failed: Passed value is more then 5000", 3) end
		proxy[private].LockInterval = value
	end,
	["LockAttempts"] = function(proxy, value)
		if type(value) ~= "number" then error("Attempt to set LockAttempts failed: Passed value is not a number", 3) end
		if value < 1 then error("Attempt to set LockAttempts failed: Passed value is less then 1", 3) end
		if value > 500 then error("Attempt to set LockAttempts failed: Passed value is more then 500", 3) end
		proxy[private].LockAttempts = value
	end,
	["SaveOnClose"] = function(proxy, value)
		if type(value) ~= "boolean" then error("Attempt to set SaveOnClose failed: Passed value is not a boolean", 3) end
		proxy[private].SaveOnClose = value
	end,
}



-- Functions
OpenTask = function(dataStore, parameters)
	if dataStore.State == true then return end
	if dataStore.State == nil then return "State", "Destroyed" end
	local errorType, errorData = Load(dataStore, 3)
	if errorType ~= nil then return errorType, errorData end
	local errorType, errorData = Lock(dataStore, 3)
	if errorType ~= nil then return errorType, errorData end
	dataStore.State = true
	StartLockTimer(dataStore, dataStore.ActiveLockInterval)
	StartSaveTimer(dataStore)
	for i, parameter in parameters do
		if dataStore.Value == nil then
			dataStore.Value = Clone(parameter[1])
		elseif type(dataStore.Value) == "table" and type(parameter[1]) == "table" then
			Reconcile(dataStore.Value, parameter[1])
		end
	end
	dataStore.StateChanged:Fire(true, dataStore.Proxy)
end

LoadTask = function(dataStore, parameters)
	if dataStore.State == nil then return "State", "Destroyed" end
	if dataStore.State == true then return "State", "Open" end
	local errorType, errorData = Load(dataStore, 3)
	if errorType ~= nil then return errorType, errorData end
	for i, parameter in parameters do
		if dataStore.Value == nil then
			dataStore.Value = Clone(parameter[1])
		elseif type(dataStore.Value) == "table" and type(parameter[1]) == "table" then
			Reconcile(dataStore.Value, parameter[1])
		end
	end
end

LockTask = function(dataStore, parameters)
	if dataStore.State == nil then return "State", "Destroyed" end
	if dataStore.State == false then return "State", "Closed" end
	local attemptsRemaining = dataStore.AttemptsRemaining
	local errorType, errorData = Lock(dataStore, 3)
	if errorType ~= nil then dataStore.AttemptsRemaining -= 1 end
	if dataStore.AttemptsRemaining ~= attemptsRemaining then dataStore.AttemptsChanged:Fire(dataStore.AttemptsRemaining, dataStore.Proxy) end
	if dataStore.AttemptsRemaining > 0 then
		local lockTime = dataStore.LockTime - dataStore.AttemptsRemaining * dataStore.ActiveLockInterval
		StartLockTimer(dataStore, lockTime - time() + dataStore.ActiveLockInterval)
	else
		dataStore.State = false
		StopLockTimer(dataStore)
		StopSaveTimer(dataStore)
		if dataStore.SaveOnClose == true then Save(dataStore, 3) end
		Unlock(dataStore, 3)
		dataStore.StateChanged:Fire(false, dataStore.Proxy)
	end
	return errorType, errorData
end

SaveTask = function(dataStore, parameters)
	if dataStore.State == nil then return "State", "Destroyed" end
	if dataStore.State == false then return "State", "Closed" end
	StopSaveTimer(dataStore)
	local errorType, errorData = Save(dataStore, 3)
	StartSaveTimer(dataStore)
	return errorType, errorData
end

CloseTask = function(dataStore, parameters)
	if dataStore.State == false then return end
	if dataStore.State == nil then return "State", "Destroyed" end
	dataStore.State = false
	StopLockTimer(dataStore)
	StopSaveTimer(dataStore)
	if dataStore.SaveOnClose == true then Save(dataStore, 3) end
	Unlock(dataStore, 3)
	dataStore.StateChanged:Fire(false, dataStore.Proxy)
end

DestroyTask = function(dataStore, parameters)
	if dataStore.State == nil then return end
	if dataStore.State == true then
		dataStore.State = nil
		StopLockTimer(dataStore)
		StopSaveTimer(dataStore)
		if dataStore.SaveOnClose == true then Save(dataStore, 3) end
		Unlock(dataStore, 3)
	end
	dataStore.State = nil
	dataStore.StateChanged:Fire(nil, dataStore.Proxy)
	dataStore.StateChanged:DisconnectAll()
	dataStore.Saving:DisconnectAll()
	bindToClose[dataStore.UniqueId] = nil
end

AddTask = function(dataStore, taskFunction, ...)
	if dataStore.Running == false then dataStore.Running = true task.defer(RunTasks, dataStore) end
	for i, taskData in dataStore.Tasks do
		if taskData.Function ~= taskFunction then continue end
		table.insert(taskData.Parameters, {...})
		table.insert(taskData.Threads, coroutine.running())
		return coroutine.yield()
	end
	table.insert(dataStore.Tasks, {["Function"] = taskFunction, ["Parameters"] = {{...}}, ["Threads"] = {coroutine.running()}})
	return coroutine.yield()
end

RunTasks = function(dataStore)
	while #dataStore.Tasks > 0 do
		local taskData = dataStore.Tasks[1]
		local errorType, errorData = taskData.Function(dataStore, taskData.Parameters)
		table.remove(dataStore.Tasks, 1)
		for i, thread in taskData.Threads do task.spawn(thread, errorType, errorData) end
	end
	dataStore.Running = false
end

Lock = function(dataStore, attempts)
	local success, value, id, lockTime, lockInterval, lockAttempts = nil, nil, nil, nil, dataStore.LockInterval, dataStore.LockAttempts
	for i = 1, attempts do
		if i > 1 then task.wait(1) end
		lockTime = time()
		success, value = pcall(dataStore.MemoryStore.UpdateAsync, dataStore.MemoryStore, "Id", function(value) id = value return if id == nil or id == dataStore.UniqueId then dataStore.UniqueId else nil end, lockInterval * lockAttempts + 30)
		if success == true then break end
	end
	if success == false then warn("MemoryStore(" .. dataStore.Id .. "):", value) return "MemoryStore", value end
	if value == nil then return "Locked", id end
	dataStore.LockTime = lockTime + lockInterval * lockAttempts
	dataStore.ActiveLockInterval = lockInterval
	dataStore.AttemptsRemaining = lockAttempts
end

Unlock = function(dataStore, attempts)
	local success, value, id = nil, nil, nil
	for i = 1, attempts do
		if i > 1 then task.wait(1) end
		success, value = pcall(dataStore.MemoryStore.UpdateAsync, dataStore.MemoryStore, "Id", function(value) id = value return if id == dataStore.UniqueId then dataStore.UniqueId else nil end, 0)
		if success == true then break end
	end
	if success == false then warn("MemoryStore(" .. dataStore.Id .. "):", value) return "MemoryStore", value end
	if value == nil and id ~= nil then return "Locked", id end
end

Load = function(dataStore, attempts)
	local success, value, info = nil, nil, nil
	for i = 1, attempts do
		if i > 1 then task.wait(1) end
		success, value, info = pcall(dataStore.DataStore.GetAsync, dataStore.DataStore, dataStore.Key)
		if success == true then break end
	end
	if success == false then warn("DataStore(" .. dataStore.Id .. "):", value) return "DataStore", value end
	if info == nil then
		dataStore.Metadata, dataStore.UserIds, dataStore.CreatedTime, dataStore.UpdatedTime, dataStore.Version = {}, {}, 0, 0, ""
	else
		dataStore.Metadata, dataStore.UserIds, dataStore.CreatedTime, dataStore.UpdatedTime, dataStore.Version = info:GetMetadata(), info:GetUserIds(), info.CreatedTime, info.UpdatedTime, info.Version
	end
	if type(dataStore.Metadata.Compress) ~= "table" then
		dataStore.Value = value
	else
		dataStore.CompressedValue = value
		local decimals = 10 ^ (dataStore.Metadata.Compress.Decimals or 3)
		dataStore.Value = Decompress(dataStore.CompressedValue, decimals)
	end
end

Save = function(dataStore, attempts)
	local deltaTime = time() - dataStore.SaveTime
	if deltaTime < 6 then task.wait(6 - deltaTime) end
	dataStore.Saving:Fire(dataStore.Value, dataStore.Proxy)
	local success, value, info = nil, nil, nil
	if dataStore.Value == nil then
		for i = 1, attempts do
			if i > 1 then task.wait(1) end
			success, value, info = pcall(dataStore.DataStore.RemoveAsync, dataStore.DataStore, dataStore.Key)
			if success == true then break end
		end
		if success == false then warn("DataStore(" .. dataStore.Id .. "):", value) return "DataStore", value end
		dataStore.Metadata, dataStore.UserIds, dataStore.CreatedTime, dataStore.UpdatedTime, dataStore.Version = {}, {}, 0, 0, ""
	elseif type(dataStore.Metadata.Compress) ~= "table" then
		dataStore.Options:SetMetadata(dataStore.Metadata)
		for i = 1, attempts do
			if i > 1 then task.wait(1) end
			success, value = pcall(dataStore.DataStore.SetAsync, dataStore.DataStore, dataStore.Key, dataStore.Value, dataStore.UserIds, dataStore.Options)
			if success == true then break end
		end	
		if success == false then warn("DataStore(" .. dataStore.Id .. "):", value) return "DataStore", value end
		dataStore.Version = value
	else
		local level = dataStore.Metadata.Compress.Level or 2
		local decimals = 10 ^ (dataStore.Metadata.Compress.Decimals or 3)
		local safety = if dataStore.Metadata.Compress.Safety == nil then true else dataStore.Metadata.Compress.Safety
		dataStore.CompressedValue = Compress(dataStore.Value, level, decimals, safety)
		dataStore.Options:SetMetadata(dataStore.Metadata)
		for i = 1, attempts do
			if i > 1 then task.wait(1) end
			success, value = pcall(dataStore.DataStore.SetAsync, dataStore.DataStore, dataStore.Key, dataStore.CompressedValue, dataStore.UserIds, dataStore.Options)
			if success == true then break end
		end
		if success == false then warn("DataStore(" .. dataStore.Id .. "):", value) return "DataStore", value end
		dataStore.Version = value
	end
	dataStore.SaveTime = time()
end

StartSaveTimer = function(dataStore)
	if dataStore.SaveThread ~= nil then task.cancel(dataStore.SaveThread) end
	if dataStore.SaveInterval == 0 then return end
	dataStore.SaveThread = task.delay(dataStore.SaveInterval, SaveTimerEnded, dataStore)
end

StopSaveTimer = function(dataStore)
	if dataStore.SaveThread == nil then return end
	task.cancel(dataStore.SaveThread)
	dataStore.SaveThread = nil
end

SaveTimerEnded = function(dataStore)
	dataStore.SaveThread = nil
	AddTask(dataStore, SaveTask)
end

StartLockTimer = function(dataStore, duration)
	if dataStore.LockThread ~= nil then task.cancel(dataStore.LockThread) end
	dataStore.LockThread = task.delay(duration, LockTimerEnded, dataStore)
end

StopLockTimer = function(dataStore)
	if dataStore.LockThread == nil then return end
	task.cancel(dataStore.LockThread)
	dataStore.LockThread = nil
end

LockTimerEnded = function(dataStore)
	dataStore.LockThread = nil
	AddTask(dataStore, LockTask)
end

Clone = function(original)
	if type(original) ~= "table" then return original end
	local clone = {}
	for index, value in original do clone[index] = Clone(value) end
	return clone
end

Reconcile = function(target, template)	
	for index, value in template do
		if type(index) == "number" then continue end
		if target[index] == nil then
			target[index] = Clone(value)
		elseif type(target[index]) == "table" and type(value) == "table" then
			Reconcile(target[index], value)
		end
	end
end

Compress = function(value, level, decimals, safety)
	local data = {}
	if type(value) == "boolean" then
		table.insert(data, if value == false then "-" else "+")
	elseif type(value) == "number" then
		if value % 1 == 0 then
			table.insert(data, if value < 0 then "<" .. Encode(-value) else ">" .. Encode(value))
		else
			table.insert(data, if value < 0 then "(" .. Encode(math.round(-value * decimals)) else ")" .. Encode(math.round(value * decimals)))
		end
	elseif type(value) == "string" then
		if safety == true then value = value:gsub("", " ") end
		table.insert(data, "#" .. value .. "")
	elseif type(value) == "table" then
		if #value > 0 and level == 2 then
			table.insert(data, "|")
			for i = 1, #value do table.insert(data, Compress(value[i], level, decimals, safety)) end
			table.insert(data, "")
		else
			table.insert(data, "*")
			for key, tableValue in value do table.insert(data, Compress(key, level, decimals, safety)) table.insert(data, Compress(tableValue, level, decimals, safety)) end
			table.insert(data, "")
		end
	end
	return table.concat(data)
end

Decompress = function(value, decimals, index)	
	local i1, i2, dataType, data = value:find("([-+<>()#|*])", index or 1)
	if dataType == "-" then
		return false, i2
	elseif dataType == "+" then
		return true, i2
	elseif dataType == "<" then
		i1, i2, data = value:find("([^-+<>()#|*]*)", i2 + 1)
		return -Decode(data), i2
	elseif dataType == ">" then
		i1, i2, data = value:find("([^-+<>()#|*]*)", i2 + 1)
		return Decode(data), i2
	elseif dataType == "(" then
		i1, i2, data = value:find("([^-+<>()#|*]*)", i2 + 1)
		return -Decode(data) / decimals, i2
	elseif dataType == ")" then
		i1, i2, data = value:find("([^-+<>()#|*]*)", i2 + 1)
		return Decode(data) / decimals, i2
	elseif dataType == "#" then
		i1, i2, data = value:find("(.-)", i2 + 1)
		return data, i2
	elseif dataType == "|" then
		local array = {}
		while true do
			data, i2 = Decompress(value, decimals, i2 + 1)
			if data == nil then break end
			table.insert(array, data)
		end
		return array, i2
	elseif dataType == "*" then
		local dictionary, key = {}, nil
		while true do
			key, i2 = Decompress(value, decimals, i2 + 1)
			if key == nil then break end
			data, i2 = Decompress(value, decimals, i2 + 1)
			dictionary[key] = data
		end
		return dictionary, i2
	end
	return nil, i2
end

Encode = function(value)
	if value == 0 then return "0" end
	local data = {}
	while value > 0 do
		table.insert(data, characters[value % base])
		value = math.floor(value / base)
	end
	return table.concat(data)
end

Decode = function(value)
	local number, power, data = 0, 1, {string.byte(value, 1, #value)}	
	for i, code in data do
		number += bytes[code] * power
		power *= base
	end
	return number
end



-- Events
game:BindToClose(function()
	for uniqueId, dataStore in bindToClose do task.spawn(AddTask, dataStore, DestroyTask) end
	while next(bindToClose) ~= nil do task.wait() end
end)



return table.freeze(constructor) :: Constructor
