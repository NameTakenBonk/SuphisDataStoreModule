-- Version: 0.3 (BETA)
local module = {}
module.__index = module

local dataStoreService = game:GetService("DataStoreService")
local memoryStoreService = game:GetService("MemoryStoreService")
local activeStates = {["Destroyed"] = false, ["Loading"] = false, ["Closed"] = false, ["Closing"] = false, ["Opening"] = false, ["Open"] = true, ["Saving"] = true}
local dataStores = {}

local function Clone(original)
	if type(original) ~= "table" then return original end
	local clone = {}
	for key, value in original do clone[key] = Clone(value) end
	return clone
end

local function Reconcile(target, template)	
	for key, value in template do
		if target[key] == nil then
			target[key] = Clone(value)
		elseif type(target[key]) == "table" and type(value) == "table" then
			Reconcile(target[key], value)
		end
	end
end

local function State(self, state)
	self.State = state
	if self.Active ~= activeStates[state] then
		self.Active = activeStates[state]
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
	local jobId = nil
	local success, value = pcall(self.MemoryStore.UpdateAsync, self.MemoryStore, "JobId", function(value) jobId = value return if jobId == nil or jobId == game.JobId then game.JobId else nil end, self.Interval + 30)
	if success == false then return "MemoryStore", value end
	if value == nil then return "Locked", jobId end
end

local function Unlock(self)
	local jobId = nil
	local success, value = pcall(self.MemoryStore.UpdateAsync, self.MemoryStore, "JobId", function(value) jobId = value return if jobId == game.JobId then game.JobId else nil end, 0)
	if success == false then return "MemoryStore", value end
	if value == nil and jobId ~= nil then return "Locked", jobId end
end

local function Load(self)
	local success, value, info = pcall(self.DataStore.GetAsync, self.DataStore, self.Key)
	if success == false then return "DataStore", value end
	self.Value = value
	if info == nil then
		self.CreatedTime, self.UpdatedTime, self.Version, self.UserIds, self.Metadata = 0, 0, "", {}, {}
	else
		self.CreatedTime, self.UpdatedTime, self.Version, self.UserIds, self.Metadata = info.CreatedTime, info.UpdatedTime, info.Version, info:GetUserIds(), info:GetMetadata()
	end
end

local function Save(self)
	self.SavingBindableEvent:Fire()
	if type(self.value) ~= "table" and self.Value == self.PreviousValue then return end
	self.PreviousValue = self.Value
	if self.Value == nil then
		local success, value, info = pcall(self.DataStore.RemoveAsync, self.DataStore, self.Key)
		if success == false then return "DataStore", value end
		self.CreatedTime, self.UpdatedTime, self.Version, self.UserIds, self.Metadata = 0, 0, "", {}, {}
	else
		self.Options:SetMetadata(self.Metadata)
		local success, value = pcall(self.DataStore.SetAsync, self.DataStore, self.Key, self.Value, self.UserIds, self.Options)
		if success == false then return "DataStore", value end
		self.Version = value
	end
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
	self.Key = key
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

module.Open = function(self, template)
	if self.State == "Closed" then
		State(self, "Opening")
		local errorType, errorMessage = Lock(self)
		if errorType ~= nil then State(self, "Closed") return errorType, errorMessage end
		StartTimer(self)
		local errorType, errorMessage = Load(self)
		if errorType ~= nil then StopTimer(self) Unlock(self) State(self, "Closed") return errorType, errorMessage end
		self:Reconcile(template)
		State(self, "Open")
		return
	end
	if self.State == "Open" or self.State == "Saving" then return end
	if self.State == "Destroyed" then return "State", self.State end
	self.PrivateEvent:Wait()
	return self:Open(template)
end

module.Load = function(self, template)
	if self.State == "Closed" then
		State(self, "Loading")
		local errorType, errorMessage = Load(self)
		self:Reconcile(template)
		State(self, "Closed")
		return errorType, errorMessage
	end
	if self.State == "Destroyed" or self.State == "Opening" or self.State == "Open" or self.State == "Saving" then return "State", self.State end
	self.PrivateEvent:Wait()
	return self:Load(template)
end

module.Save = function(self)
	if self.State == "Open" then
		State(self, "Saving")
		Throttle(self)
		if Lock(self) == nil then
			StartTimer(self)
			local errorType, errorMessage = Save(self)
			State(self, "Open")
			return errorType, errorMessage
		else
			State(self, "Closing")
			StopTimer(self)
			local errorType, errorMessage = Save(self)
			Unlock(self)
			State(self, "Closed")
			return errorType, errorMessage
		end
	end
	if self.State == "Destroyed" or self.State == "Loading" or self.State == "Closed" or self.State == "Closing" then return "State", self.State end
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
	if self.State == "Destroyed" then return "State", self.State end
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

module.Clone = function(self)
	return Clone(self.Value)
end

module.Reconcile = function(self, template)	
	if self.Value == nil then
		self.Value = Clone(template)
	elseif type(self.Value) == "table" and type(template) == "table" then
		Reconcile(self.Value, template)
	end
end

return module