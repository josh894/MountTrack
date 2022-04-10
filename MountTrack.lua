local _, MountTrack = ...

--First WoW addon project!
--Huge help from LibStub and Ace-3.0 Libraries
--Meant for personal use, but feel free to use if you don't mind manually changing the mount table!


--Initializes addon
MountTrack = LibStub("AceAddon-3.0"):NewAddon(MountTrack, "Simulationcraft", "AceConsole-3.0", "AceEvent-3.0")

--Creates a database for minimap tooltip
MountDB = LibStub("LibDataBroker-1.1"):NewDataObject("MountTrack", {
    type = "data source",
    text = "MountTrack",
    label = "MountTrack",
    icon = "Interface\\AddOns\\MountTrack\\icon",
    OnClick = function()
        MountTrack:Get_Mounts()
    end,
    OnTooltipShow = function(tt)
      tt:AddLine("MountTrack")
      tt:AddLine(" ")
      tt:AddLine("Click to show MountTrack window")
    end
  })

LibDBIcon = LibStub("LibDBIcon-1.0")

function MountTrack:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("MountTrackDB", {
        profile = {
          minimap = {
            hide = false,
          },
          frame = {
            point = "CENTER",
            relativeFrame = nil,
            relativePoint = "CENTER",
            ofsx = 0,
            ofsy = 0,
            width = 750,
            height = 400,
          },
        },
      });
    MountTrack:RegisterChatCommand('MountT', 'ChatCommand')
    LibDBIcon:Register("MountTrack", MountDB, self.db.profile.minimap)
    MountTrack:UpdateMinimapButton()
end


function MountTrack:UpdateMinimapButton()
      LibDBIcon:Show("MountTrack")
end

function MountTrack:ChatCommand(text)
    local mounts = C_MountJournal.GetMountIDs()
    for index=1,#mounts do
        local name, __, __, __, __, __, __, __, __, __, __, __ = C_MountJournal.GetMountInfoByID(mounts[index]) 
        --sets both to lowercase to remove case sensitivity
        if name:lower() == text:lower() then
            local  __,  __, source,  __,  __,  __,  __,  __,  __ = C_MountJournal.GetMountInfoExtraByID(mounts[index])
            local info = name .. ":     " .. source
            MountTrack:EditBox_Show(info)
        end
    end
end

-- Editbox frame from https://www.wowinterface.com/forums/showpost.php?p=323901&postcount=2
-- Used instead of default message box since so much cleaner
-- Thanks to simulationcraft for allowing me to realize that this exists

function MountTrack:EditBox_Show(text)
    if not EditBox then
        local f = CreateFrame("Frame", "EditBox", UIParent, "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(600, 500)
        
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 16,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
        
        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)
        
        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "EditBoxScrollFrame", EditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", EditBoxButton, "TOP", 0, 0)
        
        -- EditBox
        local eb = CreateFrame("EditBox", "EditBoxEditBox", EditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        
        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)
        
        local rb = CreateFrame("Button", "EditBoxResizeButton", EditBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)
        
        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        
        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide() -- more noticeable
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
        end)
        f:Show()
    end
    if text then
        EditBoxEditBox:SetText(text)
    end
    EditBox:Show()
end

function MountTrack:Get_Mounts()
    --list of mount IDs collected from https://www.wowhead.com/
    --UPDATED: You can now insert mounts by name as shown in the example below (Not Case-Sensitive)
    --if someone is using this other than me, this is the list you change to display different mounts
    local mounts = {"Blue Proto-Drake", 1332, 1185, 1182, 1203, 1205, 1200, 899, 971, 527}
    local mountlist = "Total Mounts: " .. C_MountJournal.GetNumDisplayedMounts() .. "\n\n"

    --goes through entire list of mounts
    for index = 1, #mounts do
        --if the mount ID is in table
        if type(mounts[index]) == "number" then
            local name, __, __, __, __, __, __, __, __, __, isCollected, __ = C_MountJournal.GetMountInfoByID(mounts[index]) 
            --if the mount has been collected, it won't print to the edit box
            --this removes the need to remove IDs from the list
            if isCollected == false then
                local  __,  __, source,  __,  __,  __,  __,  __,  __ = C_MountJournal.GetMountInfoExtraByID(mounts[index])
                mountlist = mountlist .. name
                mountlist = mountlist .. ":     " .. source .. "\n\n"
            end
        --if the mount name is in table
        elseif type(mounts[index]) == "string" then
            local mountsAll = C_MountJournal.GetMountIDs()
            for indexAll=1,#mountsAll do
                local name, __, __, __, __, __, __, __, __, __, isCollected, __ = C_MountJournal.GetMountInfoByID(mountsAll[indexAll]) 
                --sets both to lowercase to remove case sensitivity
                if name:lower() == mounts[index]:lower() then
                    local  __,  __, source,  __,  __,  __,  __,  __,  __ = C_MountJournal.GetMountInfoExtraByID(mountsAll[indexAll])
                    if isCollected == false then
                        mountlist = mountlist .. name
                        mountlist = mountlist .. ":     " .. source .. "\n\n"
                    end
                end
            end
        end
    end
    MountTrack:EditBox_Show(mountlist)
end