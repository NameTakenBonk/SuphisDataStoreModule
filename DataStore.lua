-- Version: 0.4 (BETA)

local OpenTask, LoadTask, SaveTask, CloseTask, DestroyTask, AddTask, DoTasks
local Lock, Unlock, Load, Save, StartSaveTimer, StopSaveTimer, SaveTimerEnded, StartLockTimer, StopLockTimer, LockTimerEnded, Clone, Reconcile
local signalModule = require(11670710927)
local dataStoreService = game:GetService("DataStoreService")
local memoryStoreService = game:GetService("MemoryStoreService")
local privateIndex, dataStoreMetatable = {}, {}
local constructor, property, dataStore = {}, {}, {}
local dataStores = {}
local permissions = {
	["Value"] = true, ["Metadata"] = true, ["UserIds"] = true, ["SaveInterval"] = true, ["LockInterval"] = true, ["SaveBeforeClose"] = true,
	["Id"] = false, ["Key"] = false, ["State"] = false, ["CreatedTime"] = false, ["UpdatedTime"] = false, ["Version"] = false,
	["StateChanged"] = false, ["Saving"] = false,
	["Open"] = false, ["Load"] = false, ["Save"] = false, ["Close"] = false, ["Destroy"] = false, ["Clone"] = false, ["Reconcile"] = false,
}


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
	SaveBeforeClose: boolean,
	Id: string,
	Key: string,
	State: boolean?,
	CreatedTime: number,
	UpdatedTime: number,
	Version: string,
	StateChanged: signalModule.Signal,
	Saving: signalModule.Signal,
	Open: (self: DataStore, template: any?) -> (string?, string?),
	Load: (self: DataStore, template: any?) -> (string?, string?),
	Save: (self: DataStore) -> (string?, string?),
	Close: (self: DataStore) -> (string?, string?),
	Destroy: (self: DataStore) -> (string?, string?),
	Clone: (self: DataStore) -> any,
	Reconcile: (self: DataStore, template: any) -> (),
}


-- Metatables
dataStoreMetatable.__metatable = "The metatable is locked"
dataStoreMetatable.__tostring = function(proxy) return "DataStore" end
dataStoreMetatable.__iter = function(proxy) return next, {} end
dataStoreMetatable.__newindex = function(proxy, index, value)
	if permissions[index] ~= true then error("Attempt to modify a readonly value", 2) return end
	if property[index] == nil then proxy[privateIndex][index] = value else property[index](proxy, value) end
end
dataStoreMetatable.__index = function(proxy, index)
	if permissions[index] == nil then return end
	return if proxy[privateIndex][index] == nil then dataStore[index] else proxy[privateIndex][index]
end


-- Constructor
constructor.new = function(name, scope, key)
	if key == nil then key, scope = scope, nil end
	local id = name .. "/" .. (scope or "global") .. "/" .. key
	if dataStores[id] ~= nil then return dataStores[id] end
	local dataStoreObject = {}
	dataStoreObject.Value = nil
	dataStoreObject.Metadata = {}
	dataStoreObject.UserIds = {}
	dataStoreObject.SaveInterval = 30
	dataStoreObject.LockInterval = 30
	dataStoreObject.SaveBeforeClose = true
	dataStoreObject.Id = id
	dataStoreObject.Key = key
	dataStoreObject.State = false
	dataStoreObject.CreatedTime = 0
	dataStoreObject.UpdatedTime = 0
	dataStoreObject.Version = ""
	dataStoreObject.StateChanged = signalModule.new()
	dataStoreObject.Saving = signalModule.new()
	dataStoreObject.Tasks = {}
	dataStoreObject.SaveThread = nil
	dataStoreObject.LockThread = nil
	dataStoreObject.Running = false
	dataStoreObject.DataStore = dataStoreService:GetDataStore(name, scope)
	dataStoreObject.MemoryStore = memoryStoreService:GetSortedMap(id)
	dataStoreObject.Options = Instance.new("DataStoreSetOptions")
	dataStores[id] = setmetatable({[privateIndex] = dataStoreObject}, dataStoreMetatable)
	return dataStores[id]
end

constructor.find = function(name, scope, key)
	if key == nil then key, scope = scope, nil end
	local id = name .. "/" .. (scope or "global") .. "/" .. key
	if dataStores[id] ~= nil then return dataStores[id] end
end


-- Properties
property.Metadata = function(proxy, value)
	if type(value) ~= "table" then error("Attempt to set Metadata failed: Passed value is not a table", 3) end
	proxy[privateIndex].Metadata = value
end

property.UserIds = function(proxy, value)
	if type(value) ~= "table" then error("Attempt to set UserIds failed: Passed value is not a table", 3) end
	proxy[privateIndex].UserIds = value
end

property.SaveInterval = function(proxy, value)
	if type(value) ~= "number" then error("Attempt to set SaveInterval failed: Passed value is not a number", 3) end
	if value < 10 and value ~= 0 then error("Attempt to set SaveInterval failed: Passed value is less then 10 and not 0", 3) end
	local dataStoreObject = proxy[privateIndex]
	if value == 0 then StopSaveTimer(dataStoreObject) elseif dataStoreObject.SaveInterval == 0 then StartSaveTimer(dataStoreObject) end
	dataStoreObject.SaveInterval = value
end

property.LockInterval = function(proxy, value)
	if type(value) ~= "number" then error("Attempt to set LockInterval failed: Passed value is not a number", 3) end
	if value < 10 then error("Attempt to set LockInterval failed: Passed value is less then 10", 3) end
	if value > 3887970 then error("Attempt to set LockInterval failed: Passed value is more then 3887970", 3) end
	proxy[privateIndex].LockInterval = value
end

property.SaveBeforeClose = function(proxy, value)
	if type(value) ~= "boolean" then error("Attempt to set SaveBeforeClose failed: Passed value is not a boolean", 3) end
	proxy[privateIndex].SaveBeforeClose = value
end


-- DataStore
dataStore.Open = function(proxy, template)
	return AddTask(proxy[privateIndex], OpenTask, template)
end

dataStore.Load = function(proxy, template)
	return AddTask(proxy[privateIndex], LoadTask, template)
end

dataStore.Save = function(proxy)
	return AddTask(proxy[privateIndex], SaveTask)
end

dataStore.Close = function(proxy)
	return AddTask(proxy[privateIndex], CloseTask)
end

dataStore.Destroy = function(proxy)
	return AddTask(proxy[privateIndex], DestroyTask)
end

dataStore.Clone = function(proxy)
	return Clone(proxy[privateIndex].Value)
end

dataStore.Reconcile = function(proxy, template)
	local dataStoreObject = proxy[privateIndex]
	if dataStoreObject.Value == nil then
		dataStoreObject.Value = Clone(template)
	elseif type(dataStoreObject.Value) == "table" and type(template) == "table" then
		Reconcile(dataStoreObject.Value, template)
	end
end


-- Functions
OpenTask = function(dataStoreObject, parameters)
	if dataStoreObject.State == true then return end
	if dataStoreObject.State == nil then return "State", "Destroyed" end
	StartLockTimer(dataStoreObject)
	local errorType, errorMessage = Lock(dataStoreObject)
	if errorType ~= nil then StopLockTimer(dataStoreObject) return errorType, errorMessage end
	local errorType, errorMessage = Load(dataStoreObject)
	if errorType ~= nil then StopLockTimer(dataStoreObject) Unlock(dataStoreObject) return errorType, errorMessage end
	dataStoreObject.State = true
	StartSaveTimer(dataStoreObject)
	for i, parameter in parameters do
		if dataStoreObject.Value == nil then
			dataStoreObject.Value = Clone(parameter[1])
		elseif type(dataStoreObject.Value) == "table" and type(parameter[1]) == "table" then
			Reconcile(dataStoreObject.Value, parameter[1])
		end
	end
	dataStoreObject.StateChanged:Fire(true)
end

LoadTask = function(dataStoreObject, parameters)
	if dataStoreObject.State == nil then return "State", "Destroyed" end
	if dataStoreObject.State == true then return "State", "Open" end
	local errorType, errorMessage = Load(dataStoreObject)
	if errorType ~= nil then return errorType, errorMessage end
	for i, parameter in parameters do
		if dataStoreObject.Value == nil then
			dataStoreObject.Value = Clone(parameter[1])
		elseif type(dataStoreObject.Value) == "table" and type(parameter[1]) == "table" then
			Reconcile(dataStoreObject.Value, parameter[1])
		end
	end
end

SaveTask = function(dataStoreObject, parameters)
	if dataStoreObject.State == nil then return "State", "Destroyed" end
	if dataStoreObject.State == false then return "State", "Closed" end
	local errorType, errorMessage = Save(dataStoreObject)
	StartSaveTimer(dataStoreObject)
	return errorType, errorMessage
end

CloseTask = function(dataStoreObject, parameters)
	if dataStoreObject.State == false then return end
	if dataStoreObject.State == nil then return "State", "Destroyed" end
	dataStoreObject.State = false
	StopLockTimer(dataStoreObject)
	StopSaveTimer(dataStoreObject)
	if dataStoreObject.SaveBeforeClose == true then Save(dataStoreObject) end
	Unlock(dataStoreObject)
	dataStoreObject.StateChanged:Fire(false)
end

DestroyTask = function(dataStoreObject, parameters)
	if dataStoreObject.State == nil then return end
	if dataStoreObject.State == true then
		dataStoreObject.State = nil
		StopLockTimer(dataStoreObject)
		StopSaveTimer(dataStoreObject)
		if dataStoreObject.SaveBeforeClose == true then Save(dataStoreObject) end
		Unlock(dataStoreObject)
	end
	dataStoreObject.State = nil
	dataStores[dataStoreObject.Id] = nil
	dataStoreObject.StateChanged:Fire(nil)
	dataStoreObject.StateChanged:DisconnectAll()
	dataStoreObject.Saving:DisconnectAll()
end

AddTask = function(dataStoreObject, taskFunction, ...)
	if dataStoreObject.Running == false then dataStoreObject.Running = true task.defer(DoTasks, dataStoreObject) end
	for i, taskData in dataStoreObject.Tasks do
		if taskData.Function ~= taskFunction then continue end
		table.insert(taskData.Parameters, {...})
		table.insert(taskData.Threads, coroutine.running())
		return coroutine.yield()
	end
	table.insert(dataStoreObject.Tasks, {["Function"] = taskFunction, ["Parameters"] = {{...}}, ["Threads"] = {coroutine.running()}})
	return coroutine.yield()
end

DoTasks = function(dataStoreObject)
	while #dataStoreObject.Tasks > 0 do
		local taskData = dataStoreObject.Tasks[1]
		local errorType, errorMessage = taskData.Function(dataStoreObject, taskData.Parameters)
		table.remove(dataStoreObject.Tasks, 1)
		for i, thread in taskData.Threads do task.spawn(thread, errorType, errorMessage) end
	end
	dataStoreObject.Running = false
end

Lock = function(dataStoreObject)
	local jobId = nil
	local success, value = pcall(dataStoreObject.MemoryStore.UpdateAsync, dataStoreObject.MemoryStore, "JobId", function(value) jobId = value return if jobId == nil or jobId == game.JobId then game.JobId else nil end, dataStoreObject.LockInterval + 30)
	if success == false then warn("MemoryStore(" .. dataStoreObject.Id .. "):", value) return "MemoryStore", value end
	if value == nil then return "Locked", jobId end
end

Unlock = function(dataStoreObject)
	local jobId = nil
	local success, value = pcall(dataStoreObject.MemoryStore.UpdateAsync, dataStoreObject.MemoryStore, "JobId", function(value) jobId = value return if jobId == game.JobId then game.JobId else nil end, 0)
	if success == false then warn("MemoryStore(" .. dataStoreObject.Id .. "):", value) return "MemoryStore", value end
	if value == nil and jobId ~= nil then return "Locked", jobId end
end

Load = function(dataStoreObject)
	local success, value, info = pcall(dataStoreObject.DataStore.GetAsync, dataStoreObject.DataStore, dataStoreObject.Key)
	if success == false then warn("DataStore(" .. dataStoreObject.Id .. "):", value) return "DataStore", value end
	dataStoreObject.Value = value
	if info == nil then
		dataStoreObject.Metadata, dataStoreObject.UserIds, dataStoreObject.CreatedTime, dataStoreObject.UpdatedTime, dataStoreObject.Version = {}, {}, 0, 0, ""
	else
		dataStoreObject.Metadata, dataStoreObject.UserIds, dataStoreObject.CreatedTime, dataStoreObject.UpdatedTime, dataStoreObject.Version = info:GetMetadata(), info:GetUserIds(), info.CreatedTime, info.UpdatedTime, info.Version
	end
end

Save = function(dataStoreObject)
	dataStoreObject.Saving:Fire()
	if dataStoreObject.Value == nil then
		local success, value, info = pcall(dataStoreObject.DataStore.RemoveAsync, dataStoreObject.DataStore, dataStoreObject.Key)
		if success == false then warn("DataStore(" .. dataStoreObject.Id .. "):", value) return "DataStore", value end
		dataStoreObject.Metadata, dataStoreObject.UserIds, dataStoreObject.CreatedTime, dataStoreObject.UpdatedTime, dataStoreObject.Version = {}, {}, 0, 0, ""
	else
		dataStoreObject.Options:SetMetadata(dataStoreObject.Metadata)
		local success, value = pcall(dataStoreObject.DataStore.SetAsync, dataStoreObject.DataStore, dataStoreObject.Key, dataStoreObject.Value, dataStoreObject.UserIds, dataStoreObject.Options)
		if success == false then warn("DataStore(" .. dataStoreObject.Id .. "):", value) return "DataStore", value end
		dataStoreObject.Version = value
	end
end

StartSaveTimer = function(dataStoreObject)
	if dataStoreObject.SaveThread ~= nil then task.cancel(dataStoreObject.SaveThread) end
	if dataStoreObject.SaveInterval == 0 then return end
	dataStoreObject.SaveThread = task.delay(dataStoreObject.SaveInterval, SaveTimerEnded, dataStoreObject)
end

StopSaveTimer = function(dataStoreObject)
	if dataStoreObject.SaveThread == nil then return end
	task.cancel(dataStoreObject.SaveThread)
	dataStoreObject.SaveThread = nil
end

SaveTimerEnded = function(dataStoreObject)
	dataStoreObject.SaveThread = nil
	AddTask(dataStoreObject, SaveTask)
end

StartLockTimer = function(dataStoreObject)
	if dataStoreObject.LockThread ~= nil then task.cancel(dataStoreObject.LockThread) end
	dataStoreObject.LockThread = task.delay(dataStoreObject.LockInterval, LockTimerEnded, dataStoreObject)
end

StopLockTimer = function(dataStoreObject)
	if dataStoreObject.LockThread == nil then return end
	task.cancel(dataStoreObject.LockThread)
	dataStoreObject.LockThread = nil
end

LockTimerEnded = function(dataStoreObject)
	dataStoreObject.LockThread = nil
	StartLockTimer(dataStoreObject)
	if Lock(dataStoreObject) == nil then return end
	AddTask(dataStoreObject, CloseTask)
end

Clone = function(original)
	if type(original) ~= "table" then return original end
	local clone = {}
	for index, value in original do clone[index] = Clone(value) end
	return clone
end

Reconcile = function(target, template)	
	for index, value in template do
		if target[index] == nil then
			target[index] = Clone(value)
		elseif type(target[index]) == "table" and type(value) == "table" then
			Reconcile(target[index], value)
		end
	end
end


-- Events
game:BindToClose(function()
	for id, proxy in dataStores do task.spawn(AddTask, proxy[privateIndex], DestroyTask) end
	while next(dataStores) ~= nil do task.wait() end
end)


return table.freeze(constructor) :: Constructor
