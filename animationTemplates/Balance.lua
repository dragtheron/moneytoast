local _, addon = ...
---@cast addon MoneyToastAddon

---@param animation Animation
local onComplete = function(animation)
    local widgetInfo = animation.context.widgetInfo
    widgetInfo.visible = false;

    if MONEYTOAST_VARIABLES.stayVisible then
        addon.Core:SetDefaultBalance(animation.context.frame)
    else
        addon.Animations:PlayAnimation("FrameFadeOut", animation.animationGroup)
    end

    if widgetInfo.type == "Gold" then
        local moneyString = addon.Utilities.GetMoneyStringPadded(widgetInfo.earnedThisSession)
        print(format("Gold earned this session: %s", moneyString))
    elseif widgetInfo.type == "Currency" then
        local link = C_CurrencyInfo.GetCurrencyLink(animation.context.widgetInfo.dataId)
        local balance = FormatLargeNumber(widgetInfo.earnedThisSession)
        print(format("%s earned this session: %s", link, balance))
    end
end

---@param animation Animation
---@param value number
local onUpdate = function(animation, value)
    local label
    local widgetInfo = animation.context.widgetInfo

    if widgetInfo.type == "Gold" then
        label = addon.Utilities.GetMoneyStringPadded(value)
    elseif widgetInfo.type == "Currency" then
        label = FormatLargeNumber(floor(value))
    end

    animation.context.frame.Balance.Amount:SetText(label)
end

---@param animation Animation
local onStart = function(animation)
    animation.targetValue = animation.context.widgetInfo.balance
end

addon.Animations:CreateAnimation("Balance", {
    requiredContextKeys = { "frame", "widgetInfo" },
    duration = 2,
    delayComplete = 5,
    preserveValue = true,
    OnComplete = onComplete,
    OnUpdate = onUpdate,
    OnStart = onStart,
})
