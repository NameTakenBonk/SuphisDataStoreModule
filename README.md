markdown: kramdown
theme: jekyll-theme-basically-basic

# SuphisDataStoreModule **BETA**

Before I start, this is not mine but Suphi#3388 module, I got permission to put this up in github. Here is the discord: https://discord.gg/B3zmjPVBce

# Features 

* Session locking         Prevents multiple servers from opening the same datastore key
* Auto save               Automatically saves cached data to the datastore based on the saveinterval property
* Bind To Close           Automatically saves, closes and destroys all sessions when server starts to close
* Reconcile               Fills in missing values from the template into the value property
* Save throttling         Impossible for save requests dropping
* Multiple script support Safe to interact with the same datastore object from multiple scripts
* Task batching           Tasks will be batched togever when possible
* Direct value access     Access the datastore value directly, module will never tamper with your data
* Easy to use             Simple and elegant
* Lightweight             No RunService events and no while do loops 100% event based

# Suphi's DataStore Module vs ProfileService

**ProfileService** relies on `os.time()` to lock the session. The problem with this is that each servers `os.time()` may not be 100% in sync. So to combat this problem **ProfileService** has a session timeout of 30 minutes, but if the servers have a `os.time()` delta greater then 30 minutes, then the server will be able to bypass the session lock and you will lose data. Another problem is because sessions are locked for 30 minutes, if roblox servers go down and quickly come back up and the server was not able to unlock the sessions. Then players will not be able to enter your game for 30 minutes until the sessions timeout. but will be able to enter other games that dont use **ProfileService**.

So the way **Suphi's DataStore Module** works is that it uses the `MemoryStore` to save the session lock and because memorystores have a built in expiration time. The memorystore will get automatically removed for all servers at the exact same time and because of this it will be imposible for a server to bypass the session lock. This also allows us to have a very low session timeout of **[interval] + 30 seconds**. Another benefit of using the `MemoryStore` is that instead of using `UpdateAsync` on the `DataStore`. We only use ``UpdateAsync`` for the ``MemoryStore``. Which allows us to not waste any ``Get`` and ``Set`` requests for the ``DataStore``. The ``MemoryStore`` has a request limit of ``1000 + 100 ⨉ [number of player]`` **per minute** while the DataStore only has a request limit of ``60 + 10 ⨉ [number of player]`` **per minute**.

**ProfileService** relays on ``RunService.Heartbeat`` and has a few ``while true do task.wait()`` end. on the other hand **Suphi's DataStore Module** is 100% event driven making it super lightweight

**ProfileService** does many DeepTableCopys where it loops your data and copys all values into new tables which can be an exspensive operation for very large tables **Suphi's DataStore Module** was designed in such a way that it never has to DeepTableCopy

**ProfileService** forces you to save your data as a table where **Suphi's DataStore Module** lets you set the datastore value directly where you can save numbers, strings, booleans or tables

# Download

Go to releases and download the version(latest stable version prefered), or copy the code in the repo. Alternatively without downloading you can do:
```lua
local dataStoreModule = require(11671168253)
```
Current version: `0.4 [BETA]`

# Contructors

```lua
new(name: string, scope: string, key: string)
```
Returns previously created session else a new session

```lua
new(name: string, key: string)
```
Returns previously created session else a new session

```lua
find(name: string, scope: string, key: string)
```
Returns previously created session else nil

```lua
find(name: string, key: string)
```
Returns previously created session else nil

# Properties

```lua
Value  Variant  nil
```
Value of datastore

```lua
Metadata  table  {}
```
Metadata associated with the key

```lua
UserIds  table  {}
```
An array of UserIds associated with the key

```lua
SaveInterval  number  30
```
Interval in seconds the datastore will automatically save (set to 0 to disable automatic saving)

```lua
LockInterval  number  30
```
Interval in seconds the memorystore will update the session lock

```lua
SaveBeforeClose  boolean  true
```
Automatically save the data when the session is closed or destroyed

```lua
Id  string  "Name/Scope/Key"  READ ONLY
```
Unique identifying string

```lua
Key  string  "Key"  READ ONLY
```
Key used for the datastore

```lua
State  string  "Closed"  READ ONLY
```
Current state of the session 

```lua
CreatedTime  number  0  READ ONLY
```
Number of milliseconds from epoch to when the datastore was created

```lua
UpdatedTime  number  0  READ ONLY
```
Number of milliseconds from epoch to when the datastore was updated

```lua
SavedTime  number  os.clock()  READ ONLY
```
CPU time of when the datastore was last saved

```lua
Version  string  ""  READ ONLY
```
Unique identifying string of the current datastore save

# Events

```lua
StateChanged(state: string)  RBXScriptSignal
```
Fires after state property has changed

```lua
StateChanged(state: nil/boolean)  Signal
```
Fires after state property has changed

# Methods

```lua
Open(default: Variant)  nil/string
```
Tries to open the session, optional default parameter, returns a string if fails

```lua
Load(default: Variant)  nil/string
```
Loads the datastore value without the need to open the session, returns a string if fails

```lua
Save()  nil/string
```
Force save the current value to the datastore, returns a string if fails

```lua
Close(save: boolean)  nil/string
```
Closes the session, set save parameter to false to prevent saving to the datastore, returns a string if session is destroyed

```lua
Destroy(save: boolean)  nil
```
Closes and destroys the session, set save parameter to false to prevent saving to the datastore, destroyed sessions will be locked

```lua
Reconcile(template: Variant)  nil
```
Fills in missing values from the template into the value property

# Simple Example

```lua
-- Require the ModuleScript
local dataStoreModule = require(11671168253)

-- Find or create a datastore object
local dataStore = dataStoreModule.new("Name", "Key")

-- Connect a function to the StateChanged event and print to the output when the state changes
dataStore.StateChanged:Connect(function(state)
    if state == nil then print("Destroyed", dataStore.Id) end
    if state == false then print("Closed   ", dataStore.Id) end
    if state == true then print("Open     ", dataStore.Id) end
end)

-- Open the datastore session
local errorType, errorMessage = dataStore:Open()

-- If the session fails to open lets print why and return
if errorType ~= nil then print(dataStore.Id, errorType, errorMessage) return end

-- Set the datastore value
dataStore.Value = "Hello world!"

-- Save, close and destroy the session
dataStore:Destroy()
```

# Load Example

```lua
local dataStoreModule = require(11671168253)
local dataStore = dataStoreModule.new("Name", "Key")

-- load the value from the datastore
local errorType, errorMessage = dataStore:Load()
if errorType ~= nil then print(dataStore.Id, errorType, errorMessage) return end

-- WARNING this value might be out of date use open instead if you need the latest value
print(dataStore.Value)

-- as we never opened the session it will instantly destroy without saving or closing
dataStore:Destroy()
```

# Setup Player Data Example

```lua
local dataStoreModule = require(11671168253)

local template = {
    Level = 0,
    Inventory = {},
    DeveloperProducts = {},
}

game.Players.PlayerAdded:Connect(function(player)
    local dataStore = dataStoreModule.new("Player", player.UserId)
    local errorType = dataStore:Open(template) -- reconcile with template
    if errorType ~= nil then print(player.Name, "failed to open") end
end)

game.Players.PlayerRemoving:Connect(function(player)
    local dataStore = dataStoreModule.find("Player", player.UserId)
    if dataStore == nil then return end
    dataStore:Destroy()
end)
```

# Setup Player Data Example

```lua
local dataStore = dataStoreModule.find("Player", player.UserId)
if dataStore == nil then return end
if dataStore.State ~= true then return end -- make sure the session is open or the value will never get saved
dataStore.Value.Level += 1
```

# Developer Products Example

```lua 
local marketplaceService = game:GetService("MarketplaceService")
local dataStoreModule = require(11671168253)

marketplaceService.ProcessReceipt = function(receiptInfo)
    local dataStore = dataStoreModule.find("Player", receiptInfo.PlayerId)
    if dataStore == nil then return Enum.ProductPurchaseDecision.NotProcessedYet end
    if dataStore.State ~= true then return Enum.ProductPurchaseDecision.NotProcessedYet end

    -- convert the ProductId to a string as we are not allowed empty slots for numeric indexes
    local productId = tostring(receiptInfo.ProductId)

    -- Add 1 to to the productId in the DeveloperProducts table
    dataStore.Value.DeveloperProducts[productId] = (dataStore.Value.DeveloperProducts[productId] or 0) + 1

    -- tell the session to save as quick as possible and not wait for the next save interval
    local errorType, errorMessage = dataStore:Save()
    
    -- make sure there was no errors when saving
    if errorType == nil then
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
local dataStoreModule = require(11671168253)

local template = {
    Level = 0,
    Inventory = {},
    DeveloperProducts = {},
}

local function AutomaticRetry(dataStore)
    -- Keep trying to re-open if the state is not destroyed
    while dataStore.State ~= nil do
        if dataStore:Open(template) == nil then break end
        task.wait(5)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    local dataStore = dataStoreModule.new("Player", player.UserId)

    -- Detect if the session closes
    dataStore.StateChanged:Connect(function(state)
        if state ~= false then return end
        AutomaticRetry(dataStore)
    end)

    AutomaticRetry(dataStore)
end)

game.Players.PlayerRemoving:Connect(function(player)
    local dataStore = dataStoreModule.find("Player", player.UserId)
    if dataStore == nil then return end
    -- If the player leaves datastore object is destroyed allowing the retry loop to stop
    dataStore:Destroy()
end)
```

# To do

Add compression
