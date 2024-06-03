local _, addon = ...
---@cast addon MoneyToastAddon

local onComplete = function(animation)
    if not MONEYTOAST_VARIABLES.stayVisisble then
        animation.context.frame:Hide()
    end
end

local onUpdate = function(animation, value)
    if not MONEYTOAST_VARIABLES.stayVisisble then
        animation.context.frame:SetAlpha(value)
    end
end



addon.Animations:CreateAnimation("FrameFadeOut", {
    requiredContextKeys = { "frame" },
    startValue = 1,
    currentValue = 1,
    targetValue = 0,
    duration = 0.3,
    OnComplete = onComplete,
    OnUpdate = onUpdate,
})
