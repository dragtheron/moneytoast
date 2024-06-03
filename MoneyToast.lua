local _, addon = ...

---@cast addon MoneyToastAddon

local defaultConfig = {
  stayVisible = false,
  widgets = {
    currencies = {
      2778, -- Bronze (MoP: Remix)
    },
    gold = true,
  }
}

local loaded = false
local animationGroupIdCounter = 0

local updateVariables = function()
  if not MONEYTOAST_VARIABLES then
    MONEYTOAST_VARIABLES = defaultConfig
    return
  end

  if not MONEYTOAST_VARIABLES.widgets then
    MONEYTOAST_VARIABLES.widgets = defaultConfig.widgets
  end
end

---@param widgetType string
---@param dataId integer | nil
local getWidgetName = function(widgetType, dataId)
  return "MoneyToast_Widget_" .. widgetType .. (dataId or "")
end

---@param widgetType string
---@param dataId integer | nil
local createWidget = function(self, widgetType, dataId)
  local frameName = getWidgetName(widgetType, dataId)
  local frame = CreateFrame("Frame", frameName, _G["MoneyToast"], "MoneyToast_Widget_Template")
  ---@cast frame WidgetFrame

  local iconFileId

  if widgetType == "Gold" then
    iconFileId = "Interface\\Icons\\INV_Misc_Coin_02"
  elseif widgetType == "Currency" and dataId ~= nil then
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(dataId)
    iconFileId = currencyInfo.iconFileID
  end

  ---@diagnostic disable-next-line: undefined-field
  frame.Balance.Icon:SetTexture(iconFileId)
  frame:SetScript("OnUpdate", function(frame, elapsed) addon.Animations:OnUpdate(elapsed) end)
  animationGroupIdCounter = animationGroupIdCounter + 1

  local widgetInfo = {
    type = widgetType,
    dataId = dataId,
    visible = false,
    balance = 0,
    balanceDelta = 0,
    earnedThisSession = 0,
    animationGroupId = animationGroupIdCounter
  }

  self.widgets[frameName] = frame
  self.widgetInfo[frameName] = widgetInfo
end

---@param self CoreModule
local initWidgets = function(self)
  if MONEYTOAST_VARIABLES.widgets.gold then
    self:CreateWidget("Gold")
  end

  for _, currency in ipairs(MONEYTOAST_VARIABLES.widgets.currencies) do
    self:CreateWidget("Currency", currency)
  end

  self:RegisterAnimations();
end

---@param currencyType integer
local isCurrencyTracked = function(currencyType)
  for _, currencyTracked in ipairs(MONEYTOAST_VARIABLES.widgets.currencies) do
    if currencyTracked == currencyType then
      return true
    end
  end

  return false
end

---@param event WowEvent
local onEvent = function(_, event, ...)
  if event == "VARIABLES_LOADED" then
    updateVariables()
    addon.Core:InitWidgets();
    loaded = true;
  elseif event == "PLAYER_ENTERING_WORLD" then
    addon.Core:UpdateWidgetsSilently();
  elseif event == "PLAYER_MONEY" then
    addon.Core:UpdateWithAnimation("Gold");
  elseif event == "CURRENCY_DISPLAY_UPDATE" then
    if not loaded then
      return
    end

    local currencyType = ...

    if not currencyType then
      return
    end

    if isCurrencyTracked(currencyType) then
      addon.Core:UpdateWithAnimation("Currency", currencyType)
    end
  end
end

---@param frame WidgetFrame
local hideOrShowWidget = function(frame)
  if MONEYTOAST_VARIABLES.stayVisible then
    frame:Show()
    frame:SetAlpha(1)
  else
    frame:Hide()
    frame:SetAlpha(0)
  end
end

---@param frame WidgetFrame
local resetWidget = function(frame)
  frame:ClearAllPoints()
  frame:SetPoint("TOP", 0, -32)
end

---@param self CoreModule
local resetWidgets = function(self)
  for _, frame in pairs(self.widgets) do
    resetWidget(frame)
  end
end

---@param self CoreModule
local hideOrShowWidgets = function(self)
  for _, frame in pairs(self.widgets) do
    hideOrShowWidget(frame)
  end
end

---@param self CoreModule
local registerAnimations = function(self)
  for frameName, frame in pairs(self.widgets) do
    local widgetInfo = self.widgetInfo[frameName]

    addon.Animations:RegisterAnimation("Balance", widgetInfo.animationGroupId, {
      frame = frame,
      widgetInfo = widgetInfo,
    })

    addon.Animations:RegisterAnimation("FrameFadeIn", widgetInfo.animationGroupId, {
      frame = frame,
      widgetInfo = widgetInfo,
    })

    addon.Animations:RegisterAnimation("FrameFadeOut", widgetInfo.animationGroupId, {
      frame = frame,
    })
  end
end

---@param self CoreModule
local onLoad = function(self)
  SlashCmdList["MONEYTOAST"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)");
    if cmd == "fade" then
      if args == "on" or args == "true" or args == "1" then
        MONEYTOAST_VARIABLES.stayVisible = true;
      elseif args == "off" or args == "false" or args == "0" then
        MONEYTOAST_VARIABLES.stayVisible = false;
      end
      self:HideOrShowWidgets();
    elseif cmd == "reset" then
      self:ResetWidgets()
    else
      self:CommandHelp()
    end
  end

  SLASH_MONEYTOAST1 = "/moneytoast"
end


-- commands

local commandHelp = function()
  print("MoneyToast Commands:")
  print("/moneytoast fade on - Always show the widgets so they can be moved.")
  print("/moneytoast fade off - Re-enable the fade animations so that they disappear automatically.")
  print("/moneytoast reset - Resets the position of the notification frames.")
end


-- local functions

---@param widgetInfo WidgetInfo
---@param newBalance number
local setCurrentBalance = function(widgetInfo, newBalance)
  if widgetInfo.balance ~= 0 then
    local delta = newBalance - widgetInfo.balance
    widgetInfo.earnedThisSession = widgetInfo.earnedThisSession + delta
  end

  widgetInfo.balance = newBalance;
end

---@param self CoreModule
---@param widgetName string
local setDefaultBalance = function(self, widgetName)
  local frame = self.widgets[widgetName]
  local widgetInfo = self.widgetInfo[widgetName]
  local label;

  if widgetInfo.type == "Gold" then
    label = MT_CURRENT_BALANCE
  elseif widgetInfo.type == "Currency" then
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(widgetInfo.dataId)
    label = currencyInfo.name
  end

  frame.Balance.Label:SetText(label)
end

---@param widgetInfo WidgetInfo
local getBalanceForWidget = function(widgetInfo)
  if widgetInfo.type == "Gold" then
    return GetMoney()
  elseif widgetInfo.type == "Currency" then
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(widgetInfo.dataId)
    return currencyInfo.quantity
  end

  error("No balance found for this widget.")
end

---@param widgetInfo WidgetInfo
local getBalanceLabel = function(widgetInfo)
  if widgetInfo.type == "Gold" then
    return widgetInfo.balanceDelta > 0
      and string.format(MT_MONEY_RECEIVED, addon.Utilities.GetMoneyStringPadded(abs(widgetInfo.balanceDelta), true))
      or string.format(MT_MONEY_SPENT, addon.Utilities.GetMoneyStringPadded(abs(widgetInfo.balanceDelta), true))
  elseif widgetInfo.type == "Currency" then
    return widgetInfo.balanceDelta > 0
      and string.format(MT_MONEY_RECEIVED, FormatLargeNumber(abs(widgetInfo.balanceDelta)))
      or string.format(MT_MONEY_SPENT, FormatLargeNumber(abs(widgetInfo.balanceDelta)))
  end
end

---@param self CoreModule
---@param widgetName string
---@param animated boolean
local update = function(self, widgetName, animated)
  local widgetInfo = self.widgetInfo[widgetName]
  local frame = self.widgets[widgetName]
  hideOrShowWidget(frame)
  self:SetDefaultBalance(widgetName)
  local newBalance = getBalanceForWidget(widgetInfo)
  local delta = widgetInfo.balance > 0 and newBalance - widgetInfo.balance or 0
  setCurrentBalance(widgetInfo, newBalance)

  if not animated then
    addon.Animations:SetAnimationValue("Balance", widgetInfo.animationGroupId, widgetInfo.balance)
    return;
  end

  frame:Show()
  addon.Animations:CancelAnimation("FrameFadeOut", widgetInfo.animationGroupId)

  if not widgetInfo.visible then
    widgetInfo.balanceDelta = abs(delta)
    addon.Animations:PlayAnimation("FrameFadeIn", widgetInfo.animationGroupId)
  else
    widgetInfo.balanceDelta = widgetInfo.balanceDelta + abs(delta)
    addon.Animations:SkipAnimation("FrameFadeIn", widgetInfo.animationGroupId)
  end

  local label = getBalanceLabel(widgetInfo)
  frame.Balance.Label:SetText(label);
end

---@param self CoreModule
local updateWidgets = function(self, withAnimation)
  for widgetName in pairs(self.widgets) do
    self:Update(widgetName, withAnimation)
  end
end

---@param self CoreModule
local updateWidgetsSilently = function(self)
  self:UpdateWidgets(false);
end

---@param self CoreModule
local updateWidgetsWithAnimation = function(self)
  self:UpdateWidgets(true);
end

---@param self CoreModule
local updateWithAnimation = function(self, widgetType, dataId)
  local widgetName = getWidgetName(widgetType, dataId)
  local widget = self.widgets[widgetName]

  if not widget then
    error("Can not find widget of type " .. widgetType)
  end

  local animated = true
  self:Update(widgetName, animated)
end

---@class CoreModule
local coreModule = {
  widgets = {}, ---@type table<string, WidgetFrame>
  widgetInfo = {}, ---@type table<string, WidgetInfo>
  CommandHelp = commandHelp,
  CreateWidget = createWidget,
  HideOrShowWidgets = hideOrShowWidgets,
  InitWidgets = initWidgets,
  OnEvent = onEvent,
  OnLoad = onLoad,
  ResetWidgets = resetWidgets,
  RegisterAnimations = registerAnimations,
  SetDefaultBalance = setDefaultBalance,
  Update = update,
  UpdateWidgets = updateWidgets,
  UpdateWidgetsSilently = updateWidgetsSilently,
  UpdateWidgetsWithAnimation = updateWidgetsWithAnimation,
  UpdateWithAnimation = updateWithAnimation,
}

addon.Core = coreModule
addon.Core:OnLoad()

local mainFrame = CreateFrame("Frame", "MoneyToast")
mainFrame:RegisterEvent("ADDON_LOADED");
mainFrame:RegisterEvent("PLAYER_MONEY");
mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
mainFrame:RegisterEvent("VARIABLES_LOADED");
mainFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
mainFrame:SetScript("OnEvent", addon.Core.OnEvent)
