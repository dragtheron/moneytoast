
---@class MoneyToastAddon
---@field Core CoreModule
---@field Animations AnimationsModule
---@field Utilities UtilitiesModule

---@class WidgetInfo
---@field type string
---@field dataId number | nil
---@field visible boolean
---@field balance number
---@field balanceDelta number
---@field earnedThisSession number
---@field animationGroupId number | string

---@class WidgetFrame: Frame
---@field Balance WidgetFrameBalance

---@class WidgetFrameBalance: Frame
---@field Icon Texture
---@field Label FontString
---@field Amount FontString

---@class Animation
---@field name string
---@field id string
---@field animationGroup number | string
---@field context table
---@field requiredContextKeys string[]
---@field active boolean
---@field complete boolean
---@field elapsed number
---@field startValue number
---@field currentValue number
---@field targetValue number
---@field delayStart number
---@field delayComplete number
---@field delta number
---@field duration number
---@field resetOnPlay boolean
---@field preserveValue boolean
---@field OnStart function
---@field OnUpdate function
---@field OnComplete function
