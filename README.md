![💻Suphi's_Data_Store_Module](https://github.com/NameTakenBonk/SuphisDataStoreModule/assets/83465599/997eb561-56a2-4b68-ae6e-0ce0a646c7cd)

# Suphis DataStore Module 

![carbon (2)](https://github.com/NameTakenBonk/SuphisDataStoreModule/assets/83465599/d8e6a7a2-4134-4134-bcff-7153f840de7e)


Before I start, this is not mine but 5uphi module, I got permission to put this up in github. Here is the discord: https://discord.gg/B3zmjPVBce

![GitHub all releases](https://img.shields.io/github/downloads/NameTakenBonk/SuphisDataStoreModule/total?color=%231fb594) ![GitHub Repo stars](https://img.shields.io/github/stars/NameTakenBonk/SuphisDataStoreModule?color=%23fff200)

# Features 

* Session locking            Prevents multiple servers from opening the same datastore key
* Cross Server Communication Easily use MemoryStoreQueue to send data to the session owner
* Auto save                  Automatically saves cached data to the datastore based on the saveinterval property
* Bind To Close              Automatically saves, closes and destroys all sessions when server starts to close
* Reconcile                  Fills in missing values from the template into the value property
* Compression                Compress data to reduce character count
* Multiple script support    Safe to interact with the same datastore object from multiple scripts
* Task batching              Tasks will be batched togever when possible
* Direct value access        Access the datastore value directly, module will never tamper with your data and will never leave any data in your datastore or memorystore
* Easy to use                Simple and elegant
* Lightweight                No RunService events and no while do loops 100% event based

# Suphi's DataStore Module vs ProfileService

**ProfileService** relies on `os.time()` to lock the session. The problem with this is that each servers `os.time()` may not be 100% in sync. So to combat this problem **ProfileService** has a session timeout of 30 minutes, but if the servers have a `os.time()` delta greater then 30 minutes, then the server will be able to bypass the session lock and you will lose data. Another problem is because sessions are locked for 30 minutes, if roblox servers go down and quickly come back up and the server was not able to unlock the sessions. Then players will not be able to enter your game for 30 minutes until the sessions timeout. but will be able to enter other games that dont use **ProfileService**.

So the way **Suphi's DataStore Module** works is that it uses the `MemoryStore` to save the session lock and because memorystores have a built in expiration time. The memorystore will get automatically removed for all servers at the exact same time and because of this it will be imposible for a server to bypass the session lock. This also allows us to have a very low session timeout of **[interval] + 30 seconds**. Another benefit of using the `MemoryStore` is that instead of using `UpdateAsync` on the `DataStore`. We only use ``UpdateAsync`` for the ``MemoryStore``. Which allows us to not waste any ``Get`` and ``Set`` requests for the ``DataStore``. The ``MemoryStore`` has a request limit of ``1000 + 100 ⨉ [number of player]`` **per minute** while the DataStore only has a request limit of ``60 + 10 ⨉ [number of player]`` **per minute**.

**ProfileService** relays on ``RunService.Heartbeat`` and has a few ``while true do task.wait()`` end. on the other hand **Suphi's DataStore Module** is 100% event driven making it super lightweight

**ProfileService** saves data along side your data and forces you to save your data as a table where **Suphi's DataStore Module** gives you full access to your datastores value and lets you set the datastore value directly with numbers, strings, booleans, tables or nil **Suphi's DataStore Module** will not save any data inside your datastore

# Download

Go to releases and download the version(latest stable version prefered), or copy the code(Both signal and datastoremodule, make signal the child of the main module.) in the repo. Alternatively without downloading you can do:

https://create.roblox.com/marketplace/asset/11671168253/
```lua
local dataStoreModule = require(11671168253)
```
Current version: `1.2`

# Events

```lua
StateChanged(state: boolean?, object: DataStore)  Signal
```
Fires after state property has changed

```lua
Saving(value: Variant, object: DataStore)  Signal
```
Fires just before the value is about to save

```lua
Saved(response: string, responseData: any, dataStore: DataStore)  Signal
```
Fires after a save attempt

```lua
AttemptsChanged(AttemptsRemaining: number, object: DataStore)  Signal
```
Fires when the AttemptsRemaining property has changed

```lua
ProcessQueue(id: string, values: array, dataStore: DataStore)  Signal
```
Fires when state = true and values detected inside the MemoryStoreQueue

# Simple Example

```lua
-- Require the ModuleScript
local DataStoreModule = require(11671168253)

-- Find or create a datastore object
local dataStore = DataStoreModule.new("Name", "Key")

-- Connect a function to the StateChanged event and print to the output when the state changes
dataStore.StateChanged:Connect(function(state)
    if state == nil then print("Destroyed", dataStore.Id) end
    if state == false then print("Closed   ", dataStore.Id) end
    if state == true then print("Open     ", dataStore.Id) end
end)

-- Open the datastore session
local response, responseData = dataStore:Open()

-- If the session fails to open lets print why and return
if response ~= "Success" then print(dataStore.Id, response, responseData) return end

-- Set the datastore value
dataStore.Value = "Hello world!"

-- Save, close and destroy the session
dataStore:Destroy()
```


# Load Example

```lua
local DataStoreModule = require(11671168253)
local dataStore = DataStoreModule.new("Name", "Key")

-- read the value from the datastore
if dataStore:Read() ~= "Success" then return end

-- WARNING this value might be out of date use open instead if you need the latest value
print(dataStore.Value)

-- as we never opened the session it will instantly destroy without saving or closing
dataStore:Destroy()
```

# Setup Player Data Example

```lua
local DataStoreModule = require(11671168253)

local template = {
    Level = 0,
    Coins = 0,
    Inventory = {},
    DeveloperProducts = {},
}

game.Players.PlayerAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    if dataStore:Open(template) ~= "Success" then print(player.Name, "failed to open") end
end)

game.Players.PlayerRemoving:Connect(function(player)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore == nil then return end
    dataStore:Destroy()
end)
```

# Setup Player Data Example

```lua
local dataStore = DataStoreModule.find("Player", player.UserId)
if dataStore == nil then return end
if dataStore.State ~= true then return end -- make sure the session is open or the value will never get saved
dataStore.Value.Level += 1
```

# Developer Products Example

```lua 
local marketplaceService = game:GetService("MarketplaceService")
local DataStoreModule = require(11671168253)

marketplaceService.ProcessReceipt = function(receiptInfo)
    local dataStore = DataStoreModule.find("Player", receiptInfo.PlayerId)
    if dataStore == nil then return Enum.ProductPurchaseDecision.NotProcessedYet end
    if dataStore.State ~= true then return Enum.ProductPurchaseDecision.NotProcessedYet end

    -- convert the ProductId to a string as we are not allowed empty slots for numeric indexes
    local productId = tostring(receiptInfo.ProductId)

    -- Add 1 to to the productId in the DeveloperProducts table
    dataStore.Value.DeveloperProducts[productId] = (dataStore.Value.DeveloperProducts[productId] or 0) + 1

    if dataStore:Save() == "Saved" then
        -- there was no errors lets grant the purchase
        return Enum.ProductPurchaseDecision.PurchaseGranted
    else
        -- the save failed lets make sure to remove the product or it might get saved in the next save interval
        dataStore.Value.DeveloperProducts[productId] -= 1
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
end
```

# Setup Player Data Automatic Retry Example

```lua
local DataStoreModule = require(11671168253)

local template = {
    Level = 0,
    Coins = 0,
    Inventory = {},
    DeveloperProducts = {},
}

local function StateChanged(state, dataStore)
    while dataStore.State == false do -- Keep trying to re-open if the state is closed
        if dataStore:Open(template) ~= "Success" then task.wait(6) end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    dataStore.StateChanged:Connect(StateChanged)
    StateChanged(dataStore.State, dataStore)
end)

game.Players.PlayerRemoving:Connect(function(player)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore ~= nil then dataStore:Destroy() end -- If the player leaves datastore object is destroyed allowing the retry loop to stop
end)
```

# Leaderstats Example
```lua
local DataStoreModule = require(11671168253)

local keys = {"Level", "Coins"}

local function StateChanged(state, dataStore)
    if state ~= true then return end
    for index, name in keys do
        dataStore.Leaderstats[name].Value = dataStore.Value[name]
    end
end

local function Add(player, key, amount)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore == nil then return end
    if dataStore.State ~= true then return end
    dataStore.Value[key] += amount
    dataStore.Leaderstats[key].Value = dataStore.Value[key]
end

game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    for index, name in keys do
        local intValue = Instance.new("IntValue")
        intValue.Name = name
        intValue.Parent = leaderstats
    end

    local dataStore = DataStoreModule.new("Player", player.UserId)
    dataStore.Leaderstats = leaderstats -- save the leaderstats folder into the datastore object
    dataStore.StateChanged:Connect(StateChanged)
end)

-- give somePlayer 10 coins
Add(somePlayer, "Coins", 10)
```

# Compression Example
```lua
local httpService = game:GetService("HttpService")

local DataStoreModule = require(11671168253)
local dataStore = DataStoreModule.new("name", "key")
if dataStore:Open() ~= "Success" then return end

-- Enable compression
dataStore.Metadata.Compress = {["Level"] = 2, ["Decimals"] = 3, ["Safety"] = true}
-- Level can be set to 1 or 2 (1 will allow mixed tables / 2 will not allow mixed tables but will compress arrays better)
-- Decimals will set the maximum number of decimals saved for numbers more decimals will use more data
-- Safety will scan your strings for the delete character [] and replace them with space [ ]
-- Setting to false will save faster but you could break the datastore if you have the delete character in any of your keys/strings
-- Recommended to set safty to true if you save strings sent from the client

dataStore.Value = {
    ["Number"] = 1234567891234.987,
    ["String"] = "Hello World!",
    ["Array"] = {1234567891234567, 2345678912345678, 3456789123456789, 4567891234567891, 5678912345678912}
}

-- save datastore to force the CompressedValue to update
dataStore:Save()

print(dataStore.Value)
-- print the datastore value
print(httpService:JSONEncode(dataStore.Value)) 
-- print the compressed value
print(httpService:JSONEncode(dataStore.CompressedValue))
```

# Queue Example
```lua
local DataStoreModule = require(11671168253)

local template = {
    Level = 0,
    Coins = 0,
    Inventory = {},
    DeveloperProducts = {},
}

local function ProcessQueue(id, values, dataStore)
    -- this function will only get called if the datastore is open
    if dataStore:Remove(id) ~= "Success" then return end
    for index, value in values do dataStore.Value.Coins += value end
    -- if the datastore fails to save after we changed the coins, coins will be lost
end

local function GiveCoins(userId, amount)
    -- try to find a datastore or create a hidden one
    local dataStore = DataStoreModule.find("Player", userId) or DataStoreModule.hidden("Player", userId)
    local response = dataStore:Open(template)
    if response == "Success" then
        dataStore.Value.Coins += amount -- datastore is open set the coins directly
    elseif response == "Locked" then
        -- another server has the datastore open add the amount to the queue so they can process it
        -- it's posible that the other server might miss the amount added to the queue
        -- if so amount will stay in the queue for upto (3888000 seconds / 45 days)
        return dataStore:Queue(amount, 3888000) == "Success"
    else
        return false -- roblox servers are down
    end
    return dataStore.Hidden == false or dataStore:Destroy() == "Saved" -- if this is a hidden datastore destroy it
end

game.Players.PlayerAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    if dataStore:Open(template) ~= "Success" then print(player.Name, "failed to open") return end
    dataStore.ProcessQueue:Connect(ProcessQueue)
end)

game.Players.PlayerRemoving:Connect(function(player)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore ~= nil then dataStore:Destroy() end
end)

-- try to give 5uphi 10 coins after 5 seconds
task.wait(5)
local success = GiveCoins("456056545", 10)
```

 # SAFER PROCESS QUEUE EXAMPLE 1
```lua
local function ProcessQueue(id, values, dataStore)
    -- try to remove values from the queue if not success then return
    if dataStore:Remove(id) ~= "Success" then return end

    -- add coins for each value in the queue
    for index, value in values do dataStore.Value.Coins += value end

    -- try to save the datastore if saved then return
    if dataStore:Save() == "Saved" then return end

    -- try to adding the values back into the queue so we can process them again later
    -- if we succeed in adding the value back into the queue remove the coins so they dont get saved in the next saving intervals
    for index, value in values do
        if dataStore:Queue(value, 3888000) == "Success" then dataStore.Value.Coins -= value end
    end

    -- any values that we could not add back into the queue will stay inside datastore.Value.Coins and hopefully they will get saved in the next saving intervals
    -- if the next saving intervals also fail then the coins will be lost
end
```

```lua
local function ProcessQueue(id, values, dataStore)
    -- add coins for each value in the queue
    for index, value in values do dataStore.Value.Coins += value end

    -- try to save the datastore if not saved then remove coins and return
    if dataStore:Save() ~= "Saved" then
        for index, value in values do dataStore.Value.Coins -= value end
        return
    end

    -- try to remove values from the queue if success then return
    if dataStore:Remove(id) == "Success" then return end

    -- because remove was not success remove coins
    for index, value in values do dataStore.Value.Coins -= value end

    -- try to save the datastore
    dataStore:Save()

    -- if the datastore fails to save hopefully it will get saved in the next saving intervals
    -- if the next saving intervals also fail then when the queue gets processed again and they will get the coins again
end
```

# Responses

```lua
local response, responseData = dataStore:Open()
-- Success, nil
-- Locked, UniqueId
-- State, Destroying/Destroyed
-- Error, ErrorMessage

local response, responseData = dataStore:Read()
-- Success, nil
-- State, Open
-- Error, ErrorMessage

local response, responseData = dataStore:Save()
-- Saved, nil
-- State, Closing/Closed/Destroying/Destroyed
-- Error, ErrorMessage

local response, responseData = dataStore:Close()
-- Success, nil
-- Saved, nil

local response, responseData = dataStore:Destroy()
-- Success, nil
-- Saved, nil

local response, responseData = dataStore:Queue()
-- Success, nil
-- Error, ErrorMessage

local response, responseData = dataStore:Remove()
-- Success, nil
-- Error, ErrorMessage
```

# Update 1.1 + 1.2
* bug fix
* bug fix -- fixed small edge case when calling ds:Close() would return nil instead of "Success"
* Saved response will now return dataStore.Value as responseData instead of nil
* Added Saved event
* improved proxy
* improved task manager
* you can now save custom values inside the object
* under the hood changes


<!-- markdownlint-enable -->
