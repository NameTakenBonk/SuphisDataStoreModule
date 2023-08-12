---
sidebar_position: 6
---


# Compression

Compression can be very usefull for saving large ammounts of data. As memory store service is more limited of what it can store you can use compression ro lower the size of the data. Here I will show you a simple compression example.

## Setting things up
For this you need `HTTPService` to json encode the values.

```lua
local httpService = game:GetService("HttpService")

local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)
local dataStore = DataStoreModule.new("name", "key")
if dataStore:Open() ~= "Success" then return end
```
We will also set up the data store itself here.

## Enabling Compression

Now we will need to enable the compression:
```lua
-- Enable compression
dataStore.Metadata.Compress = {["Level"] = 2, ["Decimals"] = 3, ["Safety"] = true}
```
Levels can be set to 1 or 2.
* 1 will allow mixed tables.
* 2 will not allow mixed tables but will compress arrays better

Decimals will set the maximum number of decimals saved for numbers more decimals will use more data.
Safety will scan your strings for the delete character [] and replace them with space [ ].
Setting to false will save faster but you could break the datastore if you have the delete character in any of your keys/strings. Recommended to set safty to true if you save strings sent from the client

## Checking the results
So now we can check the results. Feel free to mess around with the settings to see the results.

```lua
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
Your output should look like this:
```
11:38:40.301   ▼  {
                    ["Array"] =  ▼  {
                       [1] = 1234567891234567,
                       [2] = 2345678912345678,
                       [3] = 3456789123456789,
                       [4] = 4567891234567891,
                       [5] = 5678912345678912
                    },
                    ["Number"] = 1234567891234.987,
                    ["String"] = "Hello World!"
                 }  -  Server - Script:24
  11:38:40.302  {"Number":1234567891234.987,"String":"Hello World!","Array":[1234567891234567,2345678912345678,3456789123456789,4567891234567891,5678912345678912]}  -  Server - Script:26
  11:38:40.303  "*#Number)hLy&yaFJ#String#Hello World!#Array|>cGy&yaFJ>e~i~{QA31>4YzarcwI1>v{GMPQr22>mrCnt=mH2"  -  Server - Script:28
  11:38:40.585  Requiring asset 6738245247.
```

### The full source code:
```lua
local httpService = game:GetService("HttpService")

local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)
local dataStore = DataStoreModule.new("name", "key")
if dataStore:Open() ~= "Success" then return end

-- Enable compression
dataStore.Metadata.Compress = {["Level"] = 2, ["Decimals"] = 3, ["Safety"] = true}

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