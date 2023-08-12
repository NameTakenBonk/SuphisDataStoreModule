---
sidebar_position: 5
---

# More Player Examples

Here I will show you more ways to use this module with the player.

## Setting the players data.
If you still don't understand how to set the data of a player or anything then here is an example
```lua
local dataStore = DataStoreModule.find("Player", player.UserId)
if dataStore == nil then return end
if dataStore.State ~= true then return end -- make sure the session is open or the value will never get saved
dataStore.Value.Level += 1
```

## Developer Products Example
This is a way to save what a player bought.
```lua
local MarketplaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreModule = require(ServerStorage.DataStoreModule)

MarketplaceService.ProcessReceipt = function(receiptInfo)
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