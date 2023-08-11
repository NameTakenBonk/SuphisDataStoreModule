# Queing
Queing is usefull because you can save data without opening the data store iteself.

## Setup
Let's just get the basic things we need setup like we always do.
```lua
local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)

local template = {
    Level = 0,
    Coins = 0,
    Inventory = {},
    DeveloperProducts = {},
}

game.Players.ChildAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    if dataStore:Open(template) ~= "Success" then print(player.Name, "failed to open") return end
    dataStore.ProcessQueue:Connect(ProcessQueue)
end)

game.Players.ChildRemoved:Connect(function(player)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore ~= nil then dataStore:Destroy() end
end)

task.wait(5)
local success = GiveCoins("your user id", 10)
```

## Creating the Proccess Queue function

Although there is a queue function built we will need to do a bit more
```lua
local function ProcessQueue(id, values, dataStore)
    if dataStore:Remove(id) ~= "Success" then return end
    for index, value in values do dataStore.Value.Coins += value end
end
```
This function will only get called if the data store is open and needs to fufill the queue.

## Giving Coins

Now we will have to give the coins themself

```lua
local function GiveCoins(userId, amount)
    local dataStore = DataStoreModule.find("Player", userId) or DataStoreModule.hidden("Player", userId)
    local response = dataStore:Open(template)

    elseif response == "Locked" then
        return dataStore:Queue(amount, 3888000) == "Success"
    else
        return false 
    end
    return dataStore.Hidden == false or dataStore:Destroy() == "Saved" -- if this is a hidden datastore destroy it
end
```
We are going to find a data store or try to create a hidden one( More information on hidden on the next chapter )
```lua
    if response == "Success" then
        dataStore.Value.Coins += amount 
```
Here we add the coins directly if the datastore is already open. But what if it's locked then we will need to queue the coins to do so we created an if statement to check if it is locked then queue the value. It will queue for 3888000 seconds or as it's equal to 45 days. 
```lua
    elseif response == "Locked" then
        return dataStore:Queue(amount, 3888000) == "Success"
```
If none of these work then the roblox servers are down.
```lua
    else
        return false -- roblox servers are down
    end
```
Finally if this was hidden datastore then we destroy it.
```lua
    return dataStore.Hidden == false or dataStore:Destroy() == "Saved" 
```

### Full Source Code:

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

game.Players.ChildAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    if dataStore:Open(template) ~= "Success" then print(player.Name, "failed to open") return end
    dataStore.ProcessQueue:Connect(ProcessQueue)
end)

game.Players.ChildRemoved:Connect(function(player)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore ~= nil then dataStore:Destroy() end
end)

-- try to give 5uphi 10 coins after 5 seconds
task.wait(5)
local success = GiveCoins("456056545", 10)
```

Now this is good and all but we can make it even safer. There is actually two ways infact let me show:

## Example 1
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

## Example 2
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