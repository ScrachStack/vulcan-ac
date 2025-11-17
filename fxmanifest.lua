-- for support https://syncstudio.org/discord 
fx_version 'cerulean'
games {  'gta5', 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'
author 'ScratchStack (Sync Studio)'
description ' '
version '1.5.9'
name 'vulcan-ac'
license 'GNU GENERAL PUBLIC LICENSE'
repository 'https://github.com/ScrachStack/vulcan-ac'

client_scripts {
    'client/*',
}

server_scripts {
    'index.js',
    'server/*',
    
}

shared_scripts {
  'config.lua',
  'module/*'
}

