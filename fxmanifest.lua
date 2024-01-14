-- for support https://discord.gg/cfxdev
fx_version 'cerulean'
games {  'gta5', 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
-- Can remove warning if only on fivem and not using redm
lua54 'yes'
author 'Zaps6000'
description 'Vulcan-AC'
version '1.5.8'

client_scripts {
    'client/*',
}

server_scripts {
    'server/functions.lua',
    'server/*',
}

shared_scripts {
  'config.lua',
  'module/*'
}

