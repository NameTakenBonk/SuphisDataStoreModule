# Introduction

## What is Suphi's datastore module?
Suphi's datastore module is a fast, lightweight datastore module for roblox with easy to use code. The module uses memomory store service to save the data. This module is maintained often and recieves help and updates. The module is beginner/intermediate friendly, by giving you direct access to the values that are saved, arleady having auto saving so all you have to do is just destroy the datastore object to cleanup and has a built in session locking. This modules has so much more features so you can see them here:

## Features

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

## Learning this module
Do you want to learn how to use this module? You can can continnue reading this or you can watch these video tutorials:
* [Basics](https://www.youtube.com/watch?v=UAdE8-AfuMo&t)
* [Advanced](https://www.youtube.com/watch?v=ykWkDov_x-8&t)
* [Extras](https://www.youtube.com/watch?v=4rNva5qXj-c)
