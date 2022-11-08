-- Version: 0.1 (BETA)
local module = {}
module.__index = module

local dataStoreService = game:GetService("DataStoreService")
local memoryStoreService = game:GetService("MemoryStoreService")
local states = {["Destroyed"] = false, ["Loading"] = false, ["Closed"] = false, ["Closing"] = false, ["Opening"] = false, ["Open"] = true, ["Saving"] = true}
local dataStores = {}

local function State(self, state)
	self.State = state
	if self.Active ~= states[state] then
		self.Active = states[state]
		self.StateBindableEvent:Fire(state)
		self.ActiveBindableEvent:Fire(self.Active)
	else
		self.StateBindableEvent:Fire(state)
	end
	task.defer(self.PrivateBindableEvent.Fire, self.PrivateBindableEvent)
end

local function Throttle(self)
	local throttle = 6 - (os.clock() - self.SavedTime)
	if throttle <= 0 then return end
	task.wait(throttle)
end

local function StartTimer(self)
	local id = (self.TimerId + 1) % 2147483647
	self.TimerId = id
	task.delay(self.Interval, function()
		if id ~= self.TimerId then return end
		self:Save()
	end)
end

local function StopTimer(self)
	self.TimerId = (self.TimerId + 1) % 2147483647
end

local function Lock(self)
	local success, value = pcall(self.MemoryStore.UpdateAsync, self.MemoryStore, "JobId", function(value) return if value == nil or value == game.JobId then game.JobId else nil end, self.Interval + 30)
	if success == false then return "MemoryStore" end
	if value == nil then return "Locked" end
end

local function Unlock(self)
	local success, value = pcall(self.MemoryStore.UpdateAsync, self.MemoryStore, "JobId", function(value) return if value == game.JobId then game.JobId else nil end, 0)
	if success == false then return "MemoryStore" end
	if value == nil then return "Locked" end
end

local function Load(self, default)
	local success, value, info = pcall(self.DataStore.GetAsync, self.DataStore, self.Key)
	if success == false then return "DataStore" end
	self.Value = value or default
	self.CreatedTime = info.CreatedTime
	self.UpdatedTime = info.UpdatedTime
	self.Version = info.Version
	self.Metadata = info:GetMetadata()
	self.UserIds = info:GetUserIds()
end

local function Save(self)
	self.SavingBindableEvent:Fire()
	self.Options:SetMetadata(self.Metadata)
	local success = pcall(self.DataStore.SetAsync, self.DataStore, self.Key, self.Value, self.UserIds, self.Options)
	if success == false then return "DataStore" end
	self.SavedTime = os.clock()
end

game:BindToClose(function()
	for i, dataStore in dataStores do dataStore:Destroy() end
end)

module.new = function(name, scope, key)
	if key == nil then key, scope = scope, nil end
	local id = name .. "/" .. (scope or "global") .. "/" .. key
	if dataStores[id] ~= nil then return dataStores[id] end
	local self = setmetatable({}, module)
	self.Interval = 60
	self.UserIds = {}
	self.Metadata = {}
	self.Id = id
	self.Key = tostring(key)
	self.State = "Closed"
	self.Active = false
	self.CreatedTime = 0
	self.UpdatedTime = 0
	self.SavedTime = os.clock()
	self.Version = ""
	self.TimerId = 0
	self.DataStore = dataStoreService:GetDataStore(name, scope)
	self.MemoryStore = memoryStoreService:GetSortedMap(id)
	self.Options = Instance.new("DataStoreSetOptions")
	self.StateBindableEvent = Instance.new("BindableEvent")
	self.ActiveBindableEvent = Instance.new("BindableEvent")
	self.SavingBindableEvent = Instance.new("BindableEvent")
	self.PrivateBindableEvent = Instance.new("BindableEvent")
	self.StateChanged = self.StateBindableEvent.Event
	self.ActiveChanged = self.ActiveBindableEvent.Event
	self.SavingEvent = self.SavingBindableEvent.Event
	self.PrivateEvent = self.PrivateBindableEvent.Event
	dataStores[id] = self
	return self
end

module.find = function(name, scope, key)
	if key == nil then key, scope = scope, nil end
	local id = name .. "/" .. (scope or "global") .. "/" .. key
	return dataStores[id]
end

module.Open = function(self, default)
	if self.State == "Closed" then
		State(self, "Opening")
		local memoryStoreError = Lock(self)
		if memoryStoreError ~= nil then State(self, "Closed") return memoryStoreError end
		StartTimer(self)
		local dataStoreError = Load(self, default)
		if dataStoreError ~= nil then StopTimer(self) Unlock(self) State(self, "Closed") return dataStoreError end
		State(self, "Open")
		return
	end
	if self.State == "Open" or self.State == "Saving" then return end
	if self.State == "Destroyed" then return "State" end
	self.PrivateEvent:Wait()
	return self:Open(default)
end

module.Load = function(self, default)
	if self.State == "Closed" then
		State(self, "Loading")
		local dataStoreError = Load(self, default)
		State(self, "Closed")
		return dataStoreError
	end
	if self.State == "Destroyed" or self.State == "Opening" or self.State == "Open" or self.State == "Saving" then return "State" end
	self.PrivateEvent:Wait()
	return self:Load(default)
end

module.Save = function(self)
	if self.State == "Open" then
		State(self, "Saving")
		Throttle(self)
		if Lock(self) == nil then
			StartTimer(self)
			local dataStoreError = Save(self)
			State(self, "Open")
			return dataStoreError
		else
			State(self, "Closing")
			StopTimer(self)
			local dataStoreError = Save(self)
			Unlock(self)
			State(self, "Closed")
			return dataStoreError
		end
	end
	if self.State == "Destroyed" or self.State == "Loading" or self.State == "Closed" or self.State == "Closing" then return "State" end
	self.PrivateEvent:Wait()
	return self:Save()
end

module.Close = function(self, save)
	if self.State == "Open" then
		State(self, "Closing")
		StopTimer(self)
		if save ~= false then
			Throttle(self)
			Save(self)
		end
		Unlock(self)
		State(self, "Closed")
		return
	end
	if self.State == "Closed" then return end
	if self.State == "Destroyed" then return "State" end
	self.PrivateEvent:Wait()
	return self:Close(save)
end

module.Destroy = function(self, save)
	if self.State == "Closed" then
		dataStores[self.Id] = nil
		State(self, "Destroyed")
		self.StateBindableEvent:Destroy()
		self.ActiveBindableEvent:Destroy()
		self.SavingBindableEvent:Destroy()
		task.defer(self.PrivateBindableEvent.Destroy, self.PrivateBindableEvent)
		return
	end
	if self.State == "Open" then self:Close(save) return self:Destroy(save) end
	if self.State == "Destroyed" then return end
	self.PrivateEvent:Wait()
	return self:Destroy(save)
end

return module
