---
sidebar_position: 3
---

# Hidden
Hidden is a way to create a session that cannot be found as the name suggests. But how can this be useful? Hidden can emulate servers. But First let's see how it works.

## How it works
Let's create 3 different scripts and call the Script A, Script B, Script C. In each script there is going to be the same datastore but a different way to find it.

### 2 news
For now we will do the same for two of the scripts; Script A and Script B.

We will do the same thing in both scripts but just change the print statement.

```lua
local DataStore = require(game.ServerStorage.DataStore)
local dataStore = DataStore.new("Name", "Key")

print("A", dataStore.UniqueId) -- Put the script name here
```
Now if you run the code you should see that the ids are the same from both of the scripts.

### Adding Hidden

Next if add hidden we should see a different id. To show that hidden cannot be found with `find()` we will use it in Script C.

In Script B or where you have the second `.new()` we will change it to `hidden`. Now in script C we do the same thing as in any other script you have but you change it to `.find()` and we also add a `task.wait()` before we do the find constuctor. You script should look like this:
```lua

-- Script A

local DataStore = require(game.ServerStorage.DataStore)
local dataStore = DataStore.new("Name", "Key")

print("A", dataStore.UniqueId)

-- Script B

local DataStore = require(game.ServerStorage.DataStore)
local dataStore = DataStore.hidden("Name", "Key")

print("B", dataStore.UniqueId)

-- Script C

local DataStore = require(game.ServerStorage.DataStore)

task.wait()

local dataStore = DataStore.find("Name", "Key")

print("C", dataStore.UniqueId)

```
Now when you run the code it should print out 2 of the same ones and 1 different id. This is because `.find()` cannot find the hidden but can find the `.new()`

To be continued