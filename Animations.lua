local _, addon = ...
---@cast addon MoneyToastAddon


local defaultAnimation = {
    name = "default",
    id = "unregistered",
    animationGroup = 0,
    context = {},
    requiredContextKeys = {},
    active = false,
    complete = true,
    elapsed = 0.0,
    startValue = 0.0,
    currentValue = 0.0,
    targetValue = 1.0,
    delayStart = 0.0,
    delayComplete = 0.0,
    delta = 1.0,
    duration = 1.0,
    resetOnPlay = true,
    preserveValue = false,

    OnStart = function(self) end,
    OnUpdate = function(self) end,
    OnComplete = function(self) end,
}

---@param self AnimationsModule
---@param name string
---@param options Animation
local createAnimation = function(self, name, options)
    local animation = addon.Utilities.ShallowCopy(defaultAnimation)
    animation.name = name
    animation.context = {}

    for optKey, optValue in pairs(options) do
        if defaultAnimation[optKey] ~= nil then
            animation[optKey] = optValue
        end
    end

    self.animationTemplates[name] = animation
end

---@param self AnimationsModule
---@param animationTemplateName string
---@param animationGroup number | string
---@param context table
local registerAnimation = function(self, animationTemplateName, animationGroup, context)
    local animationTemplate = self:_GetAnimationTemplate(animationTemplateName)
    local animation = addon.Utilities.ShallowCopy(animationTemplate)
    local expectedContextKeys = animation.requiredContextKeys
    animation.context = {}

    for _, contextKey in ipairs(expectedContextKeys) do
        if context[contextKey] == nil then
            error(format("Animation registration failed: Context '%s' missing"))
        end

        animation.context[contextKey] = context[contextKey]
    end

    animation.id = animationTemplate.name .. animationGroup
    animation.animationGroup = animationGroup
    self.registeredAnimations[animation.id] = animation
end

---@param self AnimationsModule
---@param animationName string
---@param animationGroup number | string
local getAnimation = function(self, animationName, animationGroup)
    local animation = self.registeredAnimations[animationName .. animationGroup]

    if animation == nil then
        error(format("Animation not found: %s for animation group %d.", animationName, animationGroup))
    end

    return animation
end

---@param self AnimationsModule
---@param templateName string
---@return Animation
local getAnimationTemplate = function(self, templateName)
    local template = self.animationTemplates[templateName]

    if template == nil then
        error(format("Animation template '%s' not found.", templateName))
    end

    return template
end

---@param self AnimationsModule
---@param animationName string
---@param animationGroup number | string
---@param targetValue number | nil
local playAnimation = function(self, animationName, animationGroup, targetValue)
    local animation = self:_GetAnimation(animationName, animationGroup)
    animation:OnStart()


    if animation.resetOnPlay and animation.complete then
        animation.startValue = animation.currentValue
    end

    if animation.currentValue == nil then
        animation.currentValue = animation.startValue
    end

    if targetValue ~= nil then
        animation.targetValue = targetValue
    end

    animation.delta = animation.targetValue - animation.startValue

    if animation.resetOnPlay or animation.complete then
        animation.elapsed = 0
    end

    animation.active = true
    animation.complete = false
end

---@param self AnimationsModule
---@param animationName string
---@param animationGroup number | string
---@param triggerCompletionCallback boolean | nil
local cancelAnimation = function(self, animationName, animationGroup, triggerCompletionCallback)
    local animation = self:_GetAnimation(animationName, animationGroup)

    if not animation.active then
        return
    end

    animation.complete = true
    animation.active = false

    if triggerCompletionCallback then
        animation:OnComplete()
    end
end

---@param self AnimationsModule
---@param animationName string
---@param animationGroup number | string
---@param value number
local setAnimationValue = function(self, animationName, animationGroup, value)
    local animation = self:_GetAnimation(animationName, animationGroup)
    animation.currentValue = value
    animation:OnUpdate(value)
end

---@param self AnimationsModule
---@param animationName string
---@param animationGroup number | string
local skipAnimation = function(self, animationName, animationGroup)
    local animation = self:_GetAnimation(animationName, animationGroup)
    animation:OnComplete()
end

---@param animation Animation
local updateValue = function(animation)
    local animationProgression = animation.elapsed - animation.delayStart
    local ongoingAnimation = animationProgression < animation.duration

    if ongoingAnimation then
        local valueProgression = (animationProgression / animation.duration) * animation.delta
        animation.currentValue = animation.startValue + valueProgression
        animation:OnUpdate(animation.currentValue)
        return
    end

    animation.currentValue = animation.preserveValue and animation.targetValue or animation.startValue
    animation:OnUpdate(animation.targetValue)
end

---@param animation Animation
local completeAnimation = function(animation)
    animation.complete = true
    animation:OnComplete()
end

---@param self AnimationsModule
---@param animation Animation
---@param elapsed number
local animationTick = function(self, animation, elapsed)
    if not animation.active or animation.complete then
        return
    end

    animation.elapsed = animation.elapsed + elapsed

    if animation.elapsed >= animation.delayStart then
        updateValue(animation)
    end

    local fullAnimationDuration = animation.duration + animation.delayStart + animation.delayComplete

    if animation.elapsed >= fullAnimationDuration then
        completeAnimation(animation)
    end
end

---@param self AnimationsModule
---@param elapsed number
local onUpdate = function(self, elapsed)
    for _, animation in pairs(self.registeredAnimations) do
        self:_AnimationTick(animation, elapsed)
    end
end

---@class AnimationsModule
local animationsModule = {
    animationTemplates = {}, ---@type table<string, Animation>
    registeredAnimations = {}, ---@type table<string, Animation>
    CreateAnimation = createAnimation,
    RegisterAnimation = registerAnimation,
    PlayAnimation = playAnimation,
    CancelAnimation = cancelAnimation,
    SetAnimationValue = setAnimationValue,
    SkipAnimation = skipAnimation,
    _GetAnimation = getAnimation,
    _GetAnimationTemplate = getAnimationTemplate,
    _CompleteAnimation = completeAnimation,
    _AnimationTick = animationTick,
    OnUpdate = onUpdate,
}

addon.Animations = animationsModule
