local envName = GetGameName()
if envName == 'fxserver' then
  local gameConvar = GetConvar('gamename', 'gta5')
  GAME_NAME = gameConvar == 'gta5' and 'fivem' or 'redm'
else
  GAME_NAME = envName
end
IS_FIVEM = GAME_NAME == 'fivem'
IS_REDM = GAME_NAME == 'redm'
