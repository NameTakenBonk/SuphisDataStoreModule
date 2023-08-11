# Creating your first data store

To create your first data store we will do something really simple and I will explain what everything does.

## Requiring
First we got to get the module.
```lua
local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)
```

## Creating the data store
To create the data store itself you got to use the `.new` function. **You must use this once per data store!**
```lua
-- Require the ModuleScript
local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)

-- Find or create a datastore object
local dataStore = DataStoreModule.new("Name", "Key")
```
Let's go over the parameters real quick. The `Name` is the the name of the datastore as you can tell. The `key` of the datastore is like the key to your house there is only one pattern to your house key so as they key to your datastore, this can be shared for things like player data stores because you will most of the times will put the player's user id as the key.

## Adding State Events
This is optional but this is great for debugging your code. There are 3 state events:
* "Destroyed" - This happens when the data store gets destroyed.
* "Close" - This happens when the data store closes it session.
* "Open" - This happens when the data store opens it sessions.
To create the state changed code all we have to do is:
```lua
dataStore.StateChanged:Connect(function(state)
    if state == nil then print("Destroyed", dataStore.Id) end
    if state == false then print("Closed   ", dataStore.Id) end
    if state == true then print("Open     ", dataStore.Id) end
end)
```
This will fire every time the data store's state changes, so when the data store get's destroyed it will fire the event for the Destroyed event.

## Openning the data store
We have got the data store so why not open it, so that's what exactly we will do. This is really simple to do which requires two lines of code!
```lua

-- Open the datastore session
local response, responseData = dataStore:Open()

-- If the session fails to open lets print why and return
if response ~= "Success" then print(dataStore.Id, response, responseData) return end
```
Now we have opened the data store we can edit the data inside it. This module gives you direct access to the data by simply doing this:
```lua
-- Set the datastore value
dataStore.Value = "Hello World!"
```
So we have done all the basics to the data store now we can destroy the datastore an be done with the basics.
```lua
-- Save, close and destroy the session
dataStore:Destroy()
```

### Full Source Code:
```lua
-- Require the ModuleScript
local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)

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
dataStore.Value = "Hello World!"

-- Save, close and destroy the session
dataStore:Destroy()
```

-> Next we will connec the module to the player so we can save things like coins or inventory!