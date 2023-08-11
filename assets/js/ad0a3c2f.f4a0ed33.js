"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[861],{3905:(e,t,a)=>{a.d(t,{Zo:()=>u,kt:()=>y});var n=a(67294);function o(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function r(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function l(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?r(Object(a),!0).forEach((function(t){o(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):r(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function s(e,t){if(null==e)return{};var a,n,o=function(e,t){if(null==e)return{};var a,n,o={},r=Object.keys(e);for(n=0;n<r.length;n++)a=r[n],t.indexOf(a)>=0||(o[a]=e[a]);return o}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(n=0;n<r.length;n++)a=r[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(o[a]=e[a])}return o}var i=n.createContext({}),d=function(e){var t=n.useContext(i),a=t;return e&&(a="function"==typeof e?e(t):l(l({},t),e)),a},u=function(e){var t=d(e.components);return n.createElement(i.Provider,{value:t},e.children)},c="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},h=n.forwardRef((function(e,t){var a=e.components,o=e.mdxType,r=e.originalType,i=e.parentName,u=s(e,["components","mdxType","originalType","parentName"]),c=d(a),h=o,y=c["".concat(i,".").concat(h)]||c[h]||p[h]||r;return a?n.createElement(y,l(l({ref:t},u),{},{components:a})):n.createElement(y,l({ref:t},u))}));function y(e,t){var a=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var r=a.length,l=new Array(r);l[0]=h;var s={};for(var i in t)hasOwnProperty.call(t,i)&&(s[i]=t[i]);s.originalType=e,s[c]="string"==typeof e?e:o,l[1]=s;for(var d=2;d<r;d++)l[d]=a[d];return n.createElement.apply(null,l)}return n.createElement.apply(null,a)}h.displayName="MDXCreateElement"},32698:(e,t,a)=>{a.r(t),a.d(t,{assets:()=>i,contentTitle:()=>l,default:()=>p,frontMatter:()=>r,metadata:()=>s,toc:()=>d});var n=a(87462),o=(a(67294),a(3905));const r={},l="Conecting the data store to the player.",s={unversionedId:"u",id:"u",title:"Conecting the data store to the player.",description:"Now you have learned how to create the data store, you would probably like to implement it to your game. The most common implementation of a data store in roblox is saving the players data. In this tutorial I will show you how you can save the player data. If you just want the full code you can allways check bellow.",source:"@site/docs/u.md",sourceDirName:".",slug:"/u",permalink:"/SuphisDataStoreModule/docs/u",draft:!1,editUrl:"https://github.com/NameTakenBonk/SuphisDataStoreModule/edit/master/docs/u.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar",previous:{title:"Creating your first data store",permalink:"/SuphisDataStoreModule/docs/t"},next:{title:"v",permalink:"/SuphisDataStoreModule/docs/v"}},i={},d=[{value:"Setting things up",id:"setting-things-up",level:2},{value:"State changed setup",id:"state-changed-setup",level:2},{value:"Player events",id:"player-events",level:2},{value:"Full Source code:",id:"full-source-code",level:2}],u={toc:d},c="wrapper";function p(e){let{components:t,...a}=e;return(0,o.kt)(c,(0,n.Z)({},u,a,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"conecting-the-data-store-to-the-player"},"Conecting the data store to the player."),(0,o.kt)("p",null,"Now you have learned how to create the data store, you would probably like to implement it to your game. The most common implementation of a data store in roblox is saving the players data. In this tutorial I will show you how you can save the player data. If you just want the full code you can allways check bellow."),(0,o.kt)("h2",{id:"setting-things-up"},"Setting things up"),(0,o.kt)("p",null,"When creating a players data store you will need a template. A template is what will be the defualt value of a players data. This is important as you don't want to have to add the values later on, so by setting them to nil or 0 will be jsut fine. Here I will show you how it's done and talk a bit more about it."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},"local DataStoreModule = require(11671168253)\n\nlocal template = {\n    Level = 0,\n    Coins = 0,\n    Inventory = {},\n    DeveloperProducts = {},\n}\n")),(0,o.kt)("p",null,"As you can see the template is a table containing values inside of it. If you want when the player join the game for the first time to get a certain ammount of coins you can do that with templates. It's also a good way of setting up the player. This is usefull if you want to add more values to every player, so for e.g if you want to add gems but then when you add it you will have to check if the player has then you will have tp decide to add it and all, the template will cover that by jsut adding the gems value into the table."),(0,o.kt)("h2",{id:"state-changed-setup"},"State changed setup"),(0,o.kt)("p",null,"We already went through the state changed but with state changed we can also add a retrying ability. If a player's data store fails to open then you can add a retry to open it with state changed."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local function StateChanged(state, dataStore)\n    while dataStore.State == false do -- Keep trying to re-open if the state is closed\n        if dataStore:Open(template) ~= "Success" then task.wait(6) end\n    end\nend\n')),(0,o.kt)("p",null,"The function takes in two parameters the state and the data store. it creates a while loop which loops until the data store opens successfully. Then the if statement opens the datastore and if it's not successfull then it will wait another 6 seconds to retry."),(0,o.kt)("h2",{id:"player-events"},"Player events"),(0,o.kt)("p",null,"Now we will have to actaully make the data store itself for the player. To do that we will connect two functions to two player events to either destroy the data store or to open it. You will not have to manually to save the data as it's built into the module! Anyways let's code in the events."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'game.Players.PlayerAdded:Connect(function(player)\n    local dataStore = DataStoreModule.new("Player", player.UserId)\n    dataStore.StateChanged:Connect(StateChanged)\n    StateChanged(dataStore.State, dataStore)\nend)\n')),(0,o.kt)("p",null,'So here we check when a player join and connect a function with it. then we create a new data store with the name of "Player" and put in their user id as their key. After that we connect the data store\'s event ',(0,o.kt)("inlineCode",{parentName:"p"},"StateChanged")," to the StateChanged function we made earlier, this will open the data store. "),(0,o.kt)("p",null,"Now we will need to add a way to cleanup the data store once the player leaves so the data stores wont pile up in a server or create a session lock(Only allows one session of the data store per server)."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'game.Players.PlayerRemoving:Connect(function(player)\n    local dataStore = DataStoreModule.find("Player", player.UserId)\n    if dataStore ~= nil then dataStore:Destroy() end -- If the player leaves datastore object is destroyed allowing the retry loop to stop\nend)\n')),(0,o.kt)("p",null,"Now you should be done. If you want to edit the values of the player data all you will need to do is get the data store by opening it ",(0,o.kt)("strong",{parentName:"p"},"not creating a new one with .new()")," and using the data store varible to do ",(0,o.kt)("inlineCode",{parentName:"p"},"Datastore.Value.Coins = x"),"."),(0,o.kt)("h2",{id:"full-source-code"},"Full Source code:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'local DataStoreModule = require(11671168253)\n\nlocal template = {\n    Level = 0,\n    Coins = 0,\n    Inventory = {},\n    DeveloperProducts = {},\n}\n\nlocal function StateChanged(state, dataStore)\n    while dataStore.State == false do -- Keep trying to re-open if the state is closed\n        if dataStore:Open(template) ~= "Success" then task.wait(6) end\n    end\nend\n\ngame.Players.PlayerAdded:Connect(function(player)\n    local dataStore = DataStoreModule.new("Player", player.UserId)\n    dataStore.StateChanged:Connect(StateChanged)\n    StateChanged(dataStore.State, dataStore)\nend)\n\ngame.Players.PlayerRemoving:Connect(function(player)\n    local dataStore = DataStoreModule.find("Player", player.UserId)\n    if dataStore ~= nil then dataStore:Destroy() end -- If the player leaves datastore object is destroyed allowing the retry loop to stop\nend)\n')))}p.isMDXComponent=!0}}]);