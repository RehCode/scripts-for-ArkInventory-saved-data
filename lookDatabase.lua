-- A module to work the data of ArkInventory

-- Update the search path of lua to look for the database of ArkInventory
local module_folder = "E:\\World of Warcraft\\WTF\\Account\\63974431#1\\SavedVariables\\"
package.path = module_folder .. "?.lua;" .. package.path

-- Load the module (database)
require("ArkInventory")

local lookDatabase = {}
-- ARKINVDB.global.player.data["Link - Magtheridon"].location[1].bag[1].slot[1].h
-- for k in pairs(ARKINVDB.global.player.data["Link - Magtheridon"].location[1].bag) do print(k) end

function lookDatabase.searchWord(keyProfile, keyWord)
    listFound = {}
    for keyLocation, location in pairs(ARKINVDB.global.player.data[keyProfile].location) do
        for keyBag, bag in pairs(location.bag) do
            if bag.slot then
                for keySlot, slot in pairs(bag.slot) do
                    if slot.h then
                        encontrado = slot.h:match(keyWord)
                        if encontrado then
                            itemsFound = {h = slot.h, count = slot.count}
                            listFound[#listFound + 1] = itemsFound
                        end
                    end
                end
            end
        end
    end
    return listFound
end


function lookDatabase.getKeyProfiles()
    keyProfiles = {}
    for keyProfile, profile in pairs(ARKINVDB.profileKeys) do
        keyProfiles[#keyProfiles+1] = keyProfile
    end
    return keyProfiles
end


function lookDatabase.lines_from_file(file_name)
    lines = {}
    for line in io.lines(file_name) do 
        lines[#lines + 1] = line
    end
    return lines
end

function lookDatabase.find_all(words)
    local keyProfiles = lookDatabase.getKeyProfiles()
    local dataFound = {}
    for index, keyProfile in pairs(keyProfiles) do
        local profile_name = keyProfile:match("^[%a]+")
        dataFound[#dataFound+1] = {name = profile_name, items = {}}
        for index, keyWord in pairs(words) do
            listFound = lookDatabase.searchWord(keyProfile, keyWord)
            total = 0
            for keyFound, found in pairs(listFound) do
                total = total + found.count
            end
            dataFound[#dataFound].items[keyWord] = total
        end
    end
    return dataFound
end

return lookDatabase
