local addonName, addon = ...
---@cast addon MoneyToastAddon

local version = C_AddOns.GetAddOnMetadata(addonName, "VERSION");

AddonCompartmentFrame:RegisterAddon({
    text = addonName,
    icon = "Interface/Icons/INV_Misc_Coin_02",
    registerForAnyClick = true,
    notCheckable = true,
    func = function(btn, arg1, arg2, checked, mouseButton)
        if mouseButton == "LeftButton" then
            MONEYTOAST_VARIABLES.stayVisible = not MONEYTOAST_VARIABLES.stayVisible
            addon.Core:HideOrShowWidgets()
        end
    end,
    funcOnEnter = function()
        GameTooltip:SetOwner(AddonCompartmentFrame, "ANCHOR_TOPRIGHT")
        GameTooltip:SetText(format("%s v%s", addonName, version))
        GameTooltip:AddLine("Click to toggle widget fading.", 0, 1, 0)
        GameTooltip:Show()
    end
})
