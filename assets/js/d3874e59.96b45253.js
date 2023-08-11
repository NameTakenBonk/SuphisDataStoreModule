"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374],{3905:(e,t,a)=>{a.d(t,{Zo:()=>u,kt:()=>h});var n=a(67294);function r(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function o(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function l(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?o(Object(a),!0).forEach((function(t){r(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):o(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function s(e,t){if(null==e)return{};var a,n,r=function(e,t){if(null==e)return{};var a,n,r={},o=Object.keys(e);for(n=0;n<o.length;n++)a=o[n],t.indexOf(a)>=0||(r[a]=e[a]);return r}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)a=o[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(r[a]=e[a])}return r}var i=n.createContext({}),d=function(e){var t=n.useContext(i),a=t;return e&&(a="function"==typeof e?e(t):l(l({},t),e)),a},u=function(e){var t=d(e.components);return n.createElement(i.Provider,{value:t},e.children)},c="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},m=n.forwardRef((function(e,t){var a=e.components,r=e.mdxType,o=e.originalType,i=e.parentName,u=s(e,["components","mdxType","originalType","parentName"]),c=d(a),m=r,h=c["".concat(i,".").concat(m)]||c[m]||p[m]||o;return a?n.createElement(h,l(l({ref:t},u),{},{components:a})):n.createElement(h,l({ref:t},u))}));function h(e,t){var a=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=a.length,l=new Array(o);l[0]=m;var s={};for(var i in t)hasOwnProperty.call(t,i)&&(s[i]=t[i]);s.originalType=e,s[c]="string"==typeof e?e:r,l[1]=s;for(var d=2;d<o;d++)l[d]=a[d];return n.createElement.apply(null,l)}return n.createElement.apply(null,a)}m.displayName="MDXCreateElement"},4167:(e,t,a)=>{a.r(t),a.d(t,{HomepageFeatures:()=>v,default:()=>g});var n=a(87462),r=a(67294),o=a(3905);const l={toc:[]},s="wrapper";function i(e){let{components:t,...a}=e;return(0,o.kt)(s,(0,n.Z)({},l,a,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("p",null,(0,o.kt)("img",{parentName:"p",src:"https://github.com/NameTakenBonk/SuphisDataStoreModule/assets/83465599/997eb561-56a2-4b68-ae6e-0ce0a646c7cd",alt:"\ud83d\udcbbSuphi's_Data_Store_Module"})),(0,o.kt)("h1",{id:"suphis-datastore-module"},"Suphis DataStore Module"),(0,o.kt)("p",null,(0,o.kt)("img",{parentName:"p",src:"https://github.com/NameTakenBonk/SuphisDataStoreModule/assets/83465599/d8e6a7a2-4134-4134-bcff-7153f840de7e",alt:"carbon (2)"})),(0,o.kt)("p",null,"Before I start, this is not mine but 5uphi module, I got permission to put this up in github. Here is the discord: ",(0,o.kt)("a",{parentName:"p",href:"https://discord.gg/B3zmjPVBce"},"https://discord.gg/B3zmjPVBce")),(0,o.kt)("p",null,(0,o.kt)("img",{parentName:"p",src:"https://img.shields.io/github/downloads/NameTakenBonk/SuphisDataStoreModule/total?color=%231fb594",alt:"GitHub all releases"})," ",(0,o.kt)("img",{parentName:"p",src:"https://img.shields.io/github/stars/NameTakenBonk/SuphisDataStoreModule?color=%23fff200",alt:"GitHub Repo stars"})),(0,o.kt)("h1",{id:"features"},"Features"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"Session locking            Prevents multiple servers from opening the same datastore key"),(0,o.kt)("li",{parentName:"ul"},"Cross Server Communication Easily use MemoryStoreQueue to send data to the session owner"),(0,o.kt)("li",{parentName:"ul"},"Auto save                  Automatically saves cached data to the datastore based on the saveinterval property"),(0,o.kt)("li",{parentName:"ul"},"Bind To Close              Automatically saves, closes and destroys all sessions when server starts to close"),(0,o.kt)("li",{parentName:"ul"},"Reconcile                  Fills in missing values from the template into the value property"),(0,o.kt)("li",{parentName:"ul"},"Compression                Compress data to reduce character count"),(0,o.kt)("li",{parentName:"ul"},"Multiple script support    Safe to interact with the same datastore object from multiple scripts"),(0,o.kt)("li",{parentName:"ul"},"Task batching              Tasks will be batched togever when possible"),(0,o.kt)("li",{parentName:"ul"},"Direct value access        Access the datastore value directly, module will never tamper with your data and will never leave any data in your datastore or memorystore"),(0,o.kt)("li",{parentName:"ul"},"Easy to use                Simple and elegant"),(0,o.kt)("li",{parentName:"ul"},"Lightweight                No RunService events and no while do loops 100% event based")),(0,o.kt)("h1",{id:"suphis-datastore-module-vs-profileservice"},"Suphi's DataStore Module vs ProfileService"),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"ProfileService")," relies on ",(0,o.kt)("inlineCode",{parentName:"p"},"os.time()")," to lock the session. The problem with this is that each servers ",(0,o.kt)("inlineCode",{parentName:"p"},"os.time()")," may not be 100% in sync. So to combat this problem ",(0,o.kt)("strong",{parentName:"p"},"ProfileService")," has a session timeout of 30 minutes, but if the servers have a ",(0,o.kt)("inlineCode",{parentName:"p"},"os.time()")," delta greater then 30 minutes, then the server will be able to bypass the session lock and you will lose data. Another problem is because sessions are locked for 30 minutes, if roblox servers go down and quickly come back up and the server was not able to unlock the sessions. Then players will not be able to enter your game for 30 minutes until the sessions timeout. but will be able to enter other games that dont use ",(0,o.kt)("strong",{parentName:"p"},"ProfileService"),"."),(0,o.kt)("p",null,"So the way ",(0,o.kt)("strong",{parentName:"p"},"Suphi's DataStore Module")," works is that it uses the ",(0,o.kt)("inlineCode",{parentName:"p"},"MemoryStore")," to save the session lock and because memorystores have a built in expiration time. The memorystore will get automatically removed for all servers at the exact same time and because of this it will be imposible for a server to bypass the session lock. This also allows us to have a very low session timeout of ",(0,o.kt)("strong",{parentName:"p"},"[interval]"," + 30 seconds"),". Another benefit of using the ",(0,o.kt)("inlineCode",{parentName:"p"},"MemoryStore")," is that instead of using ",(0,o.kt)("inlineCode",{parentName:"p"},"UpdateAsync")," on the ",(0,o.kt)("inlineCode",{parentName:"p"},"DataStore"),". We only use ",(0,o.kt)("inlineCode",{parentName:"p"},"UpdateAsync")," for the ",(0,o.kt)("inlineCode",{parentName:"p"},"MemoryStore"),". Which allows us to not waste any ",(0,o.kt)("inlineCode",{parentName:"p"},"Get")," and ",(0,o.kt)("inlineCode",{parentName:"p"},"Set")," requests for the ",(0,o.kt)("inlineCode",{parentName:"p"},"DataStore"),". The ",(0,o.kt)("inlineCode",{parentName:"p"},"MemoryStore")," has a request limit of ",(0,o.kt)("inlineCode",{parentName:"p"},"1000 + 100 \u2a09 [number of player]")," ",(0,o.kt)("strong",{parentName:"p"},"per minute")," while the DataStore only has a request limit of ",(0,o.kt)("inlineCode",{parentName:"p"},"60 + 10 \u2a09 [number of player]")," ",(0,o.kt)("strong",{parentName:"p"},"per minute"),"."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"ProfileService")," relays on ",(0,o.kt)("inlineCode",{parentName:"p"},"RunService.Heartbeat")," and has a few ",(0,o.kt)("inlineCode",{parentName:"p"},"while true do task.wait()")," end. on the other hand ",(0,o.kt)("strong",{parentName:"p"},"Suphi's DataStore Module")," is 100% event driven making it super lightweight"),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"ProfileService")," saves data along side your data and forces you to save your data as a table where ",(0,o.kt)("strong",{parentName:"p"},"Suphi's DataStore Module")," gives you full access to your datastores value and lets you set the datastore value directly with numbers, strings, booleans, tables or nil ",(0,o.kt)("strong",{parentName:"p"},"Suphi's DataStore Module")," will not save any data inside your datastore"),(0,o.kt)("h1",{id:"download"},"Download"),(0,o.kt)("p",null,"Go to releases and download the version(latest stable version prefered), or copy the code(Both signal and datastoremodule, make signal the child of the main module.) in the repo. Alternatively without downloading you can do:"),(0,o.kt)("p",null,(0,o.kt)("a",{parentName:"p",href:"https://create.roblox.com/marketplace/asset/11671168253/"},"https://create.roblox.com/marketplace/asset/11671168253/")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"local dataStoreModule = require(11671168253)\n")),(0,o.kt)("p",null,"Current version: ",(0,o.kt)("inlineCode",{parentName:"p"},"1.2")),(0,o.kt)("h1",{id:"docsapi"},"Docs/API"),(0,o.kt)("p",null,"Do you want check the docs or the api you can do so here: ",(0,o.kt)("a",{parentName:"p",href:"https://nametakenbonk.github.io/SuphisDataStoreModule/"},"https://nametakenbonk.github.io/SuphisDataStoreModule/")),(0,o.kt)("h1",{id:"events"},"Events"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"StateChanged(state: boolean?, object: DataStore)  Signal\n")),(0,o.kt)("p",null,"Fires after state property has changed"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"Saving(value: Variant, object: DataStore)  Signal\n")),(0,o.kt)("p",null,"Fires just before the value is about to save"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"Saved(response: string, responseData: any, dataStore: DataStore)  Signal\n")),(0,o.kt)("p",null,"Fires after a save attempt"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"AttemptsChanged(AttemptsRemaining: number, object: DataStore)  Signal\n")),(0,o.kt)("p",null,"Fires when the AttemptsRemaining property has changed"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"ProcessQueue(id: string, values: array, dataStore: DataStore)  Signal\n")),(0,o.kt)("p",null,"Fires when state = true and values detected inside the MemoryStoreQueue"),(0,o.kt)("h1",{id:"simple-example"},"Simple Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'-- Require the ModuleScript\nlocal DataStoreModule = require(11671168253)\n\n-- Find or create a datastore object\nlocal dataStore = DataStoreModule.new("Name", "Key")\n\n-- Connect a function to the StateChanged event and print to the output when the state changes\ndataStore.StateChanged:Connect(function(state)\n    if state == nil then print("Destroyed", dataStore.Id) end\n    if state == false then print("Closed   ", dataStore.Id) end\n    if state == true then print("Open     ", dataStore.Id) end\nend)\n\n-- Open the datastore session\nlocal response, responseData = dataStore:Open()\n\n-- If the session fails to open lets print why and return\nif response ~= "Success" then print(dataStore.Id, response, responseData) return end\n\n-- Set the datastore value\ndataStore.Value = "Hello world!"\n\n-- Save, close and destroy the session\ndataStore:Destroy()\n')),(0,o.kt)("h1",{id:"load-example"},"Load Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local DataStoreModule = require(11671168253)\nlocal dataStore = DataStoreModule.new("Name", "Key")\n\n-- read the value from the datastore\nif dataStore:Read() ~= "Success" then return end\n\n-- WARNING this value might be out of date use open instead if you need the latest value\nprint(dataStore.Value)\n\n-- as we never opened the session it will instantly destroy without saving or closing\ndataStore:Destroy()\n')),(0,o.kt)("h1",{id:"setup-player-data-example"},"Setup Player Data Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local DataStoreModule = require(11671168253)\n\nlocal template = {\n    Level = 0,\n    Coins = 0,\n    Inventory = {},\n    DeveloperProducts = {},\n}\n\ngame.Players.PlayerAdded:Connect(function(player)\n    local dataStore = DataStoreModule.new("Player", player.UserId)\n    if dataStore:Open(template) ~= "Success" then print(player.Name, "failed to open") end\nend)\n\ngame.Players.PlayerRemoving:Connect(function(player)\n    local dataStore = DataStoreModule.find("Player", player.UserId)\n    if dataStore == nil then return end\n    dataStore:Destroy()\nend)\n')),(0,o.kt)("h1",{id:"setup-player-data-example-1"},"Setup Player Data Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local dataStore = DataStoreModule.find("Player", player.UserId)\nif dataStore == nil then return end\nif dataStore.State ~= true then return end -- make sure the session is open or the value will never get saved\ndataStore.Value.Level += 1\n')),(0,o.kt)("h1",{id:"developer-products-example"},"Developer Products Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local marketplaceService = game:GetService("MarketplaceService")\nlocal DataStoreModule = require(11671168253)\n\nmarketplaceService.ProcessReceipt = function(receiptInfo)\n    local dataStore = DataStoreModule.find("Player", receiptInfo.PlayerId)\n    if dataStore == nil then return Enum.ProductPurchaseDecision.NotProcessedYet end\n    if dataStore.State ~= true then return Enum.ProductPurchaseDecision.NotProcessedYet end\n\n    -- convert the ProductId to a string as we are not allowed empty slots for numeric indexes\n    local productId = tostring(receiptInfo.ProductId)\n\n    -- Add 1 to to the productId in the DeveloperProducts table\n    dataStore.Value.DeveloperProducts[productId] = (dataStore.Value.DeveloperProducts[productId] or 0) + 1\n\n    if dataStore:Save() == "Saved" then\n        -- there was no errors lets grant the purchase\n        return Enum.ProductPurchaseDecision.PurchaseGranted\n    else\n        -- the save failed lets make sure to remove the product or it might get saved in the next save interval\n        dataStore.Value.DeveloperProducts[productId] -= 1\n        return Enum.ProductPurchaseDecision.NotProcessedYet\n    end\nend\n')),(0,o.kt)("h1",{id:"setup-player-data-automatic-retry-example"},"Setup Player Data Automatic Retry Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local DataStoreModule = require(11671168253)\n\nlocal template = {\n    Level = 0,\n    Coins = 0,\n    Inventory = {},\n    DeveloperProducts = {},\n}\n\nlocal function StateChanged(state, dataStore)\n    while dataStore.State == false do -- Keep trying to re-open if the state is closed\n        if dataStore:Open(template) ~= "Success" then task.wait(6) end\n    end\nend\n\ngame.Players.PlayerAdded:Connect(function(player)\n    local dataStore = DataStoreModule.new("Player", player.UserId)\n    dataStore.StateChanged:Connect(StateChanged)\n    StateChanged(dataStore.State, dataStore)\nend)\n\ngame.Players.PlayerRemoving:Connect(function(player)\n    local dataStore = DataStoreModule.find("Player", player.UserId)\n    if dataStore ~= nil then dataStore:Destroy() end -- If the player leaves datastore object is destroyed allowing the retry loop to stop\nend)\n')),(0,o.kt)("h1",{id:"leaderstats-example"},"Leaderstats Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local DataStoreModule = require(11671168253)\n\nlocal keys = {"Level", "Coins"}\n\nlocal function StateChanged(state, dataStore)\n    if state ~= true then return end\n    for index, name in keys do\n        dataStore.Leaderstats[name].Value = dataStore.Value[name]\n    end\nend\n\nlocal function Add(player, key, amount)\n    local dataStore = DataStoreModule.find("Player", player.UserId)\n    if dataStore == nil then return end\n    if dataStore.State ~= true then return end\n    dataStore.Value[key] += amount\n    dataStore.Leaderstats[key].Value = dataStore.Value[key]\nend\n\ngame.Players.PlayerAdded:Connect(function(player)\n    local leaderstats = Instance.new("Folder")\n    leaderstats.Name = "leaderstats"\n    leaderstats.Parent = player\n    \n    for index, name in keys do\n        local intValue = Instance.new("IntValue")\n        intValue.Name = name\n        intValue.Parent = leaderstats\n    end\n\n    local dataStore = DataStoreModule.new("Player", player.UserId)\n    dataStore.Leaderstats = leaderstats -- save the leaderstats folder into the datastore object\n    dataStore.StateChanged:Connect(StateChanged)\nend)\n\n-- give somePlayer 10 coins\nAdd(somePlayer, "Coins", 10)\n')),(0,o.kt)("h1",{id:"compression-example"},"Compression Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local httpService = game:GetService("HttpService")\n\nlocal DataStoreModule = require(11671168253)\nlocal dataStore = DataStoreModule.new("name", "key")\nif dataStore:Open() ~= "Success" then return end\n\n-- Enable compression\ndataStore.Metadata.Compress = {["Level"] = 2, ["Decimals"] = 3, ["Safety"] = true}\n-- Level can be set to 1 or 2 (1 will allow mixed tables / 2 will not allow mixed tables but will compress arrays better)\n-- Decimals will set the maximum number of decimals saved for numbers more decimals will use more data\n-- Safety will scan your strings for the delete character [\x7f] and replace them with space [ ]\n-- Setting to false will save faster but you could break the datastore if you have the delete character in any of your keys/strings\n-- Recommended to set safty to true if you save strings sent from the client\n\ndataStore.Value = {\n    ["Number"] = 1234567891234.987,\n    ["String"] = "Hello World!",\n    ["Array"] = {1234567891234567, 2345678912345678, 3456789123456789, 4567891234567891, 5678912345678912}\n}\n\n-- save datastore to force the CompressedValue to update\ndataStore:Save()\n\nprint(dataStore.Value)\n-- print the datastore value\nprint(httpService:JSONEncode(dataStore.Value)) \n-- print the compressed value\nprint(httpService:JSONEncode(dataStore.CompressedValue))\n')),(0,o.kt)("h1",{id:"queue-example"},"Queue Example"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local DataStoreModule = require(11671168253)\n\nlocal template = {\n    Level = 0,\n    Coins = 0,\n    Inventory = {},\n    DeveloperProducts = {},\n}\n\nlocal function ProcessQueue(id, values, dataStore)\n    -- this function will only get called if the datastore is open\n    if dataStore:Remove(id) ~= "Success" then return end\n    for index, value in values do dataStore.Value.Coins += value end\n    -- if the datastore fails to save after we changed the coins, coins will be lost\nend\n\nlocal function GiveCoins(userId, amount)\n    -- try to find a datastore or create a hidden one\n    local dataStore = DataStoreModule.find("Player", userId) or DataStoreModule.hidden("Player", userId)\n    local response = dataStore:Open(template)\n    if response == "Success" then\n        dataStore.Value.Coins += amount -- datastore is open set the coins directly\n    elseif response == "Locked" then\n        -- another server has the datastore open add the amount to the queue so they can process it\n        -- it\'s posible that the other server might miss the amount added to the queue\n        -- if so amount will stay in the queue for upto (3888000 seconds / 45 days)\n        return dataStore:Queue(amount, 3888000) == "Success"\n    else\n        return false -- roblox servers are down\n    end\n    return dataStore.Hidden == false or dataStore:Destroy() == "Saved" -- if this is a hidden datastore destroy it\nend\n\ngame.Players.PlayerAdded:Connect(function(player)\n    local dataStore = DataStoreModule.new("Player", player.UserId)\n    if dataStore:Open(template) ~= "Success" then print(player.Name, "failed to open") return end\n    dataStore.ProcessQueue:Connect(ProcessQueue)\nend)\n\ngame.Players.PlayerRemoving:Connect(function(player)\n    local dataStore = DataStoreModule.find("Player", player.UserId)\n    if dataStore ~= nil then dataStore:Destroy() end\nend)\n\n-- try to give 5uphi 10 coins after 5 seconds\ntask.wait(5)\nlocal success = GiveCoins("456056545", 10)\n')),(0,o.kt)("h1",{id:"safer-process-queue-example-1"},"SAFER PROCESS QUEUE EXAMPLE 1"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local function ProcessQueue(id, values, dataStore)\n    -- try to remove values from the queue if not success then return\n    if dataStore:Remove(id) ~= "Success" then return end\n\n    -- add coins for each value in the queue\n    for index, value in values do dataStore.Value.Coins += value end\n\n    -- try to save the datastore if saved then return\n    if dataStore:Save() == "Saved" then return end\n\n    -- try to adding the values back into the queue so we can process them again later\n    -- if we succeed in adding the value back into the queue remove the coins so they dont get saved in the next saving intervals\n    for index, value in values do\n        if dataStore:Queue(value, 3888000) == "Success" then dataStore.Value.Coins -= value end\n    end\n\n    -- any values that we could not add back into the queue will stay inside datastore.Value.Coins and hopefully they will get saved in the next saving intervals\n    -- if the next saving intervals also fail then the coins will be lost\nend\n')),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local function ProcessQueue(id, values, dataStore)\n    -- add coins for each value in the queue\n    for index, value in values do dataStore.Value.Coins += value end\n\n    -- try to save the datastore if not saved then remove coins and return\n    if dataStore:Save() ~= "Saved" then\n        for index, value in values do dataStore.Value.Coins -= value end\n        return\n    end\n\n    -- try to remove values from the queue if success then return\n    if dataStore:Remove(id) == "Success" then return end\n\n    -- because remove was not success remove coins\n    for index, value in values do dataStore.Value.Coins -= value end\n\n    -- try to save the datastore\n    dataStore:Save()\n\n    -- if the datastore fails to save hopefully it will get saved in the next saving intervals\n    -- if the next saving intervals also fail then when the queue gets processed again and they will get the coins again\nend\n')),(0,o.kt)("h1",{id:"responses"},"Responses"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"local response, responseData = dataStore:Open()\n-- Success, nil\n-- Locked, UniqueId\n-- State, Destroying/Destroyed\n-- Error, ErrorMessage\n\nlocal response, responseData = dataStore:Read()\n-- Success, nil\n-- State, Open\n-- Error, ErrorMessage\n\nlocal response, responseData = dataStore:Save()\n-- Saved, nil\n-- State, Closing/Closed/Destroying/Destroyed\n-- Error, ErrorMessage\n\nlocal response, responseData = dataStore:Close()\n-- Success, nil\n-- Saved, nil\n\nlocal response, responseData = dataStore:Destroy()\n-- Success, nil\n-- Saved, nil\n\nlocal response, responseData = dataStore:Queue()\n-- Success, nil\n-- Error, ErrorMessage\n\nlocal response, responseData = dataStore:Remove()\n-- Success, nil\n-- Error, ErrorMessage\n")),(0,o.kt)("h1",{id:"update-11--12"},"Update 1.1 + 1.2"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},"bug fix"),(0,o.kt)("li",{parentName:"ul"},'bug fix -- fixed small edge case when calling ds:Close() would return nil instead of "Success"'),(0,o.kt)("li",{parentName:"ul"},"Saved response will now return dataStore.Value as responseData instead of nil"),(0,o.kt)("li",{parentName:"ul"},"Added Saved event"),(0,o.kt)("li",{parentName:"ul"},"improved proxy"),(0,o.kt)("li",{parentName:"ul"},"improved task manager"),(0,o.kt)("li",{parentName:"ul"},"you can now save custom values inside the object"),(0,o.kt)("li",{parentName:"ul"},"under the hood changes")))}i.isMDXComponent=!0;var d=a(39960),u=a(52263),c=a(34510),p=a(86010);const m={heroBanner:"heroBanner_e1Bh",buttons:"buttons_VwD3",features:"features_WS6B",featureSvg:"featureSvg_tqLR",titleOnBannerImage:"titleOnBannerImage_r7kd",taglineOnBannerImage:"taglineOnBannerImage_dLPr"},h=[{title:"5uphi",description:"Creator of the module itself.",image:"https://tr.rbxcdn.com/2762a9dfc964102556ed275d837ec3d0/150/150/AvatarHeadshot/Png"},{title:"Alternative",description:"Creator of the documentation and github.",image:"https://tr.rbxcdn.com/d041a23c94e014a8ee46a3a9356ddbe6/150/150/AvatarHeadshot/Png"},{title:"The Discord",description:"Join the discord community! https://discord.gg/suphi-kaner-909926338801061961",image:"https://cdn-icons-png.flaticon.com/512/2111/2111370.png"}];function S(e){let{image:t,title:a,description:n}=e;return r.createElement("div",{className:(0,p.Z)("col col--4")},t&&r.createElement("div",{className:"text--center"},r.createElement("img",{className:m.featureSvg,alt:a,src:t})),r.createElement("div",{className:"text--center padding-horiz--md"},r.createElement("h3",null,a),r.createElement("p",null,n)))}function v(){return h?r.createElement("section",{className:m.features},r.createElement("div",{className:"container"},r.createElement("div",{className:"row"},h.map(((e,t)=>r.createElement(S,(0,n.Z)({key:t},e))))))):null}function f(){const{siteConfig:e}=(0,u.Z)(),t=e.customFields.bannerImage,a=!!t,n=a?{backgroundImage:`url("${t}")`}:null,o=(0,p.Z)("hero__title",{[m.titleOnBannerImage]:a}),l=(0,p.Z)("hero__subtitle",{[m.taglineOnBannerImage]:a});return r.createElement("header",{className:(0,p.Z)("hero",m.heroBanner),style:n},r.createElement("div",{className:"container"},r.createElement("h1",{className:o},e.title),r.createElement("p",{className:l},e.tagline),r.createElement("div",{className:m.buttons},r.createElement(d.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function g(){const{siteConfig:e,tagline:t}=(0,u.Z)();return r.createElement(c.Z,{title:e.title,description:t},r.createElement(f,null),r.createElement("main",null,r.createElement(v,null),r.createElement("div",{className:"container"},r.createElement(i,null))))}}}]);