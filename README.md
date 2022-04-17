# MountTrack
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white) ![Battle.net](https://img.shields.io/badge/battle.net-%2300AEFF.svg?style=for-the-badge&logo=battle.net&logoColor=white)
Personal use World of Warcraft addon to track specific mounts.
https://www.curseforge.com/wow/addons/mount-track

## Dependencies
-   Ace3, LibDBIcon
-   These can both be found within the libs folder.

## Usage
-   Install and unzip into `\World of Warcraft\_retail_\Interface\AddOns`
-   Once in game, list of mounts can be viewed clicking on the minimap tooltip.
-   To search the source of a specific mount, type `/mountT mountname` in chat.

## Editing for own-use
-   In Get_Mounts() the mount table is listed with mount IDs you wish to track.
-   IDs can be found on the mount's SPELL page on wowhead (Ex. https://www.wowhead.com/spell=288503/umber-nightsaber mount ID = 1203)
-   Mounts can also be added by name as seen by `Blue Proto-Drake` in table.
