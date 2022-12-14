SLASH_MOGHUNTER1 = '/moghunter'
SLASH_MOGHUNTER2 = '/mh'

local function CreateMHScrollFrame(text)
    local f = CreateFrame("Frame", nil, UIParent, "DialogBoxFrame")
    f:SetPoint("CENTER", 0, 0)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:SetSize(400, 600)
    f:SetResizable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        end
    end)
    f:SetScript("OnMouseUp", f.StopMovingOrSizing)

    f.scrollFrame = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    f.scrollFrame:SetPoint("LEFT", 16, 0)
    f.scrollFrame:SetPoint("RIGHT", -32, 0)
    f.scrollFrame:SetPoint("TOP", 0, -16)
    f.scrollFrame:SetPoint("BOTTOM", 0, 90)

    local eb = CreateFrame("EditBox", nil, f.scrollFrame)
    eb:SetSize(f.scrollFrame:GetSize())
    eb:SetMultiLine(true)
    eb:SetAutoFocus(true)
    eb:SetFontObject("ChatFontNormal")
    eb:SetScript("OnEscapePressed", function() f:Hide() end)
    f.scrollFrame:SetScrollChild(eb)

    eb:SetText(text)

    return f
end

local function ExportWardrobe()
    items = {}

    for _, slot in pairs(Enum.TransmogCollectionType) do
        for i, appearance in ipairs(C_TransmogCollection.GetCategoryAppearances(slot)) do
            for i, source in ipairs(C_TransmogCollection.GetAppearanceSources(appearance.visualID)) do
                local _, _, _, _, isCollected, link = C_TransmogCollection.GetAppearanceSourceInfo(source.sourceID)
                local itemID, itemType, itemSubType, itemEquipLoc, _, itemClassId, itemSubClassId = GetItemInfoInstant(link)
                local sourceInfo = C_TransmogCollection.GetSourceInfo(source.sourceID)
                local sourceType = ""
                if sourceInfo.sourceType ~= nil then
                    sourceType = sourceInfo.sourceType
                end
                local itemName = ""
                if sourceInfo.name ~= nil then
                    itemName = sourceInfo.name
                end
                
                item = "  {\n"
                item = item .. '    "itemID": ' .. itemID .. "\n"
                item = item .. "  }"
                
                if isCollected then
                    tinsert(items, item)
                end
            end
        end
    end


    str = "[\n" .. table.concat(items, ', \n') .. "\n]"

    f = CreateMHScrollFrame(str)
    f:Show()
end

local function ExportOutfits()
    outfits = {}

    print('Exporting outfits')
    for outfitID in pairs(C_TransmogCollection.GetOutfits()) do
        print(outfitID)
        name, icon = C_TransmogCollection.GetOutfitInfo(outfitID)
        print('Outfit: ' .. name)
        for items in pairs(C_TransmogCollection.GetOutfitItemTransmogInfoList(outfitID)) do

        end
    end
end

local function MogHunterHandler(arg)
    if arg == 'wardrobe' then
        ExportWardrobe()
    end

    if arg == 'outfit' then
        ExportOutfits()
    end

end

SlashCmdList['MOGHUNTER'] = MogHunterHandler