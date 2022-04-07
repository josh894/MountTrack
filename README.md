# MountTrack
Personal use World of Warcraft addon to track specific mounts.

## Usage
-   Install and unzip into `\World of Warcraft\_retail_\Interface\AddOns`
-   Once in game, list of mounts can be viewed by typing `/mounttrack` OR `/mountT` within the chat bar.

## Editing for own-use
-   In Get_Mounts() the mount table is listed with mount IDs you wish to track.
-   IDs can be found on the mount's SPELL page on wowhead (Ex. https://www.wowhead.com/spell=288503/umber-nightsaber mount ID = 1203)
-   Then matching the index of mount ID (Index starts at 1), create if statement on method of obtainment.
    - Ex. My Umber Nightsaber is at index 4 so within if statements, index 4 will add `Darkshore Rare Spawn (WEEKLY)`
