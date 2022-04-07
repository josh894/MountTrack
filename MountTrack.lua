SLASH_MOUNT1 = "/mounttrack"
SLASH_MOUNT2 = "/mountT"

-- Frame code largely adapted from https://www.wowinterface.com/forums/showpost.php?p=323901&postcount=2
function EditBox_Show(text)
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

function Get_Mounts()
    --list of mount IDs collected from https://www.wowhead.com/
    local mounts = {1332, 1185, 1182, 1203, 1205, 1200, 1486, 1436, 1491, 1497, 899, 971, 527}
    local mountlist = "Total Mounts: " .. C_MountJournal.GetNumDisplayedMounts() .. "\n\n"

    --goes through entire list of mounts
    for index = 1, #mounts do
        local name, __, __, __, __, __, __, __, __, __, isCollected, __ = C_MountJournal.GetMountInfoByID(mounts[index]) 
        local  __,  __, source,  __,  __,  __,  __,  __,  __ = C_MountJournal.GetMountInfoExtraByID(mounts[index])

        --if the mount has been collected, it won't print to the edit box
        --this removes the need to remove IDs from the list
        if isCollected == false then
            mountlist = mountlist .. name
            mountlist = mountlist .. ":     " .. source .. "\n\n"
        end
    end
    EditBox_Show(mountlist)
end

SlashCmdList["MOUNT"] = Get_Mounts