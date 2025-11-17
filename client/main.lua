local envName = GetGameName()
if envName == 'fxserver' then
  local gameConvar = GetConvar('gamename', 'gta5')
  GAME_NAME = gameConvar == 'gta5' and 'fivem' or 'redm'
else
  GAME_NAME = envName
end
IS_FIVEM = GAME_NAME == 'fivem'
IS_REDM = GAME_NAME == 'redm'

local Vulcan = {
  Commands = {}
  textures = {"mpinventory", "burrito_bus", "thefov", "HydroMenu", "Urubu3", "wave1", "mpentry", "wave1", "__REAPER5__", "32909fjj2kfk2e"}, -- commonmenu, mpmissmarkers256
  Psid = GetPlayerFromServerId(PlayerId()),
  UsevMenu = (GetResourceState("vMenu") == "started"),
  UsesMenu = (GetResourceState("vMenu") == "started"),
  UseESX = (GetResourceState("es_extended") == "started"),
  UseQBCORE = (GetResourceState("qb-core") == "started"),
  UseQBOX = (GetResourceState("qbx-core") == "started"),
  UseNDCORE = (GetResourceState("ND_CORE") == "started"),
  fivem = IS_FIVEM),
  StartedResources = {}

}


