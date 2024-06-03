local _, addon = ...
---@cast addon MoneyToastAddon

local onComplete = function(animation)
    if not MONEYTOAST_VARIABLES.stayVisisble then
        animation.context.frame:SetAlpha(1)
    end

    addon.Animations:PlayAnimation("Balance", animation.animationGroup)
end

local onUpdate = function(animation, value)
    animation.context.widgetInfo.visible = true

    if not MONEYTOAST_VARIABLES.stayVisible then
        animation.context.frame:Show()
        animation.context.frame:SetAlpha(value)
    end
end

addon.Animations:CreateAnimation("FrameFadeIn", {
    requiredContextKeys = { "frame", "widgetInfo" },
    startValue = 0,
    targetValue = 1,
    duration = 0.3,
    resetOnPlay = false,
    delayComplete = 1,
    OnComplete = onComplete,
    OnUpdate = onUpdate,
})
