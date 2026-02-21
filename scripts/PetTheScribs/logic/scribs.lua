local world = require("openmw.world")
local core = require("openmw.core")
local storage = require("openmw.storage")
local calendar = require("openmw_aux.calendar")

local settings = storage.globalSection("SettingsPetTheScribs_settings")
local l10n = core.l10n("PetTheScribs")
local petMessage = l10n("pet_message", {})

local function doTheScribby(actor, scrib)
    -- TODO do the animation animation
    actor:sendEvent("ShowMessage", { message = petMessage })
end

local function normalScrib(actor, scrib, options)
    local jellyCooldown = settings:get("jellyCooldown") * 60 * 60 -- in hours
    local lastJellyTime = options.lastJellyTimeList[scrib.id] or 0
    -- TODO add cooldown check using lastJellyTime

    local jellyChance = settings:get("jellyChance")
    if math.random() > jellyChance then return end

    -- TODO update lastjellyTimeList
    local minJelly = settings:get("minJelly")
    local maxJelly = settings:get("maxJelly")
    local jellyCount = math.random(minJelly, maxJelly)

    local jelly = world.createObject("ingred_scrib_jelly_01", jellyCount)
    local inv = actor.type.inventory(actor)
    ---@diagnostic disable-next-line: discard-returns
    jelly:moveInto(inv)

    doTheScribby(actor, scrib)

    return { jellyReceived = true }
end

local function diseasedScrib(actor, scrib, options)
    local diseaseChance = settings:get("diseaseChance")
    if math.random() > diseaseChance then return end

    actor.type.activeSpells(actor):add({
        id = "droops",
        effects = { 0 },
    })

    doTheScribby(actor, scrib)
end

local function blightedScrib(actor, scrib, options)
    local blightChance = settings:get("blightChance")
    if math.random() > blightChance then return end

    actor.type.activeSpells(actor):add({
        id = "ash-chancre",
        effects = { 0 },
    })

    doTheScribby(actor, scrib)
end

Scribs = {
    ["scrib"]           = normalScrib,
    ["scrib diseased"]  = diseasedScrib,
    ["scrib_vaba-amus"] = normalScrib,
    ["scrib blighted"]  = blightedScrib,
    -- TODO add more scrib types from readme
}
