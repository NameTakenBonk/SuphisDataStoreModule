---
sidebar_position: 4
---

# Player Data Stores

Now you have learned how to create the data store, you would probably like to implement it to your game. The most common implementation of a data store in roblox is saving the players data. In this tutorial I will show you how you can save the player data. If you just want the full code you can allways check bellow.

## Setting things up

When creating a players data store you will need a template. A template is what will be the defualt value of a players data. This is important as you don't want to have to add the values later on, so by setting them to nil or 0 will be jsut fine. Here I will show you how it's done and talk a bit more about it.
```lua
local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)

local template = {
    Level = 0,
    Coins = 0,
    Inventory = {},
    DeveloperProducts = {},
}
```

As you can see the template is a table containing values inside of it. If you want when the player join the game for the first time to get a certain ammount of coins you can do that with templates. It's also a good way of setting up the player. This is usefull if you want to add more values to every player, so for e.g if you want to add gems but then when you add it you will have to check if the player has then you will have tp decide to add it and all, the template will cover that by jsut adding the gems value into the table.

## State changed setup

We already went through the state changed but with state changed we can also add a retrying ability. If a player's data store fails to open then you can add a retry to open it with state changed.
```lua
local function StateChanged(state, dataStore)
    while dataStore.State == false do -- Keep trying to re-open if the state is closed
        if dataStore:Open(template) ~= "Success" then task.wait(6) end
    end
end
```
The function takes in two parameters the state and the data store. it creates a while loop which loops until the data store opens successfully. Then the if statement opens the datastore and if it's not successfull then it will wait another 6 seconds to retry.

## Player events

Now we will have to actaully make the data store itself for the player. To do that we will connect two functions to two player events to either destroy the data store or to open it. You will not have to manually to save the data as it's built into the module! Anyways let's code in the events.
```lua
game.Players.PlayerAdded:Connect(function(player)
    local dataStore = DataStoreModule.new("Player", player.UserId)
    dataStore.StateChanged:Connect(StateChanged)
    StateChanged(dataStore.State, dataStore)
end)
```
So here we check when a player join and connect a function with it. then we create a new data store with the name of "Player" and put in their user id as their key. After that we connect the data store's event `StateChanged` to the StateChanged function we made earlier, this will open the data store. 

Now we will need to add a way to cleanup the data store once the player leaves so the data stores wont pile up in a server or create a session lock(Only allows one session of the data store per server).
```lua
game.Players.PlayerRemoving:Connect(function(player)
    local dataStore = DataStoreModule.find("Player", player.UserId)
    if dataStore ~= nil then dataStore:Destroy() end -- If the player leaves datastore object is destroyed allowing the retry loop to stop
end)
```

Now you should be done. If you want to edit the values of the player data all you will need to do is get the data store by opening it **not creating a new one with .new()** and using the data store varible to do `Datastore.Value.Coins = x`.

### Full Source code:
```lua
local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)

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

-> If you wnat more player examples then continue on!