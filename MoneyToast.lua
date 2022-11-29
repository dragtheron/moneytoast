MoneyToastAddOn = { };

MoneyToastAddOnGlobalConfig = {
  animationDuration = 5,
}

MONEYTOAST_VARIABLES = {
  stayVisible = false,
}

local gb = MoneyToastAddOn;

local _currentBalance = 0;
local loaded = false;
local frameVisible = false;
local deltaBalance = 0;
local animations = { };

function gb:OnEvent(event)
  if event == "ADDON_LOADED" and not loaded then
    gb:_Update(false);
    loaded = true;
  end
  if loaded then
    gb:_Update(true);
  end
end

local FrameFadeIn_OnComplete = function()
  if not MONEYTOAST_VARIABLES.stayVisible then
    _G["MoneyToast_Widget"]:SetAlpha(1);
  end
  gb:_SimpleAnimationPlay("BalanceAnimation", _currentBalance);
end

local FrameFadeOut_OnComplete = function()
  if not MONEYTOAST_VARIABLES.stayVisible then
    _G["MoneyToast_Widget"]:Hide();
  end
end

local FrameFadeIn_OnUpdate = function(value)
  frameVisible = true;
  if not MONEYTOAST_VARIABLES.stayVisible then
    _G["MoneyToast_Widget"]:SetAlpha(value);
  end
end

local FrameFadeOut_OnUpdate = function(value)
  if not MONEYTOAST_VARIABLES.stayVisible then
    _G["MoneyToast_Widget"]:SetAlpha(value);
  end
end

local BalanceAnimation_OnComplete = function()
  frameVisible = false;
  if MONEYTOAST_VARIABLES.stayVisible then
    gb:_SetDefaultBalance();
  else
    gb:_SimpleAnimationPlay("FrameFadeOut");
  end
end

local BalanceAnimation_OnUpdate = function(value)
  _G["MoneyToast_Widget_Balance"].Amount:SetText(GetMoneyStringPadded(value, true));
end

function gb:_HideOrShowWidget()
  if MONEYTOAST_VARIABLES.stayVisible then
    MoneyToast_Widget:Show();
    MoneyToast_Widget:SetAlpha(1);
  else
    MoneyToast_Widget:Hide();
    MoneyToast_Widget:SetAlpha(0);
  end
end

function gb:OnLoad()
  SlashCmdList["MONEYTOAST"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)");
    if cmd == "stay" then
      if args == "on" or args == "true" or args == "1" then
        MONEYTOAST_VARIABLES.stayVisible = true
        gb:_HideOrShowWidget();
      elseif args == "off" or args == "false" or args == "0" then
        MONEYTOAST_VARIABLES.stayVisible = false
        gb:_HideOrShowWidget();
      end
    elseif cmd == "reset" then
      MoneyToast_Widget:ClearAllPoints();
      MoneyToast_Widget:SetPoint("TOP", 0, -32);
    else
      gb:_CommandHelp();
    end
  end

  SLASH_MONEYTOAST1 = "/moneytoast";

  gb:_SimpleAnimationCreate("FrameFadeIn", {
    startValue = 0,
    targetValue = 1,
    duration = 0.3,
    onUpdate = FrameFadeIn_OnUpdate,
    onComplete = FrameFadeIn_OnComplete,
    resetOnPlay = false,
    delayComplete = 1
  });

  gb:_SimpleAnimationCreate("FrameFadeOut", {
    startValue = 1,
    targetValue = 0,
    duration = 0.3,
    onUpdate = FrameFadeOut_OnUpdate,
    onComplete = FrameFadeOut_OnComplete
  });

  gb:_SimpleAnimationCreate("BalanceAnimation", {
    duration = 2,
    onUpdate = BalanceAnimation_OnUpdate,
    onComplete = BalanceAnimation_OnComplete,
    delayComplete = 5,
    preserveValue = true
  });
end


-- commands

function gb:_CommandHelp()
  print("MoneyToast v1.0.0 Loaded");
  print("Available Commands:");
  print("/moneytoast stay on - Display the notification window so that it can be moved.");
  print("/moneytoast stay off - Re-enable the fade animations.");
  print("/moneytoast reset - Resets the position of the notification frame.");
end


-- local functions

function gb:_TransitionGold(newBalance)
  gb:_AnimationStart(newBalance);
  gb:_SetCurrentBalance(newBalance);
  gb:_PrintCurrentBalance();
end

function gb:_SimpleAnimationPlay(animationId, targetValue)
  local config = animations[animationId];
  if config.currentValue == nil then
    config.currentValue = 0.0
  end
  config.startValue = config.currentValue;
  if targetValue ~= nil then
    config.targetValue = targetValue;
  end
  config.delta = config.targetValue - config.startValue;
  if config.resetOnPlay or config.complete then
    config.elapsed = 0;
  end
  config.active = true;
  config.complete = false;
end

function gb:_SimpleAnimationCancel(animationId, triggerCompletion)
  local config = animations[animationId];
  if config.active then
    local config = animations[animationId];
    if triggerCompletion then
      config.onComplete();
    end
    config.complete = true;
    config.active = false;
  end
end

function gb:_SimpleAnimationSetCurrentValue(animationId, currentValue)
  animations[animationId].currentValue = currentValue;
  if animations[animationId].onUpdate then
    animations[animationId].onUpdate(currentValue);
  end
end

function gb:_SimpleAnimationCreate(animationId, options)
  if loaded then error("cannot create animation when already loaded.") end
  if options.startValue == nil then
    options.startValue = 0.0
  end
  if options.targetValue == nil then
    options.targetValue = 0.0
  end
  if options.delayComplete == nil then
    options.delayComplete = 0.0
  end
  if options.delayStart == nil then
    options.delayStart = 0.0
  end
  if options.resetOnPlay == nil then
    options.resetOnPlay = true
  end
  local config = {
    active = false,
    complete = true,
    elapsed = 0,
    startValue = options.startValue,
    currentValue = options.startValue,
    targetValue = options.targetValue,
    delayStart = options.delayStart,
    delayComplete = options.delayComplete,
    delta = options.targetValue - options.startValue,
    duration = options.duration,
    onUpdate = options.onUpdate,
    onComplete = options.onComplete,
    resetOnPlay = options.resetOnPlay,
    preserveValue = options.preserveValue
  };
  if animations[animationId] == nil then
    animations[animationId] = config;
  else
    error("Animation Override Not Allowed");
  end
end

function gb:_SimpleAnimationTick(elapsed)
  for animationId, config in pairs(animations) do
    if config.active and not config.complete then
      if config.complete then
        -- wait delayComplete
        if config.elapsed >= config.duration + config.delayStart + config.delayComplete then
          if config.onComplete ~= nil then
            config.onComplete();
            config.active = false;
          end
        end
      else
        if config.elapsed == 0 then
          config.elapsed = 0.01;
        else
          config.elapsed = config.elapsed + elapsed;
        end
        -- trigger complete now?
        if config.elapsed >= config.delayStart then
          if config.elapsed < config.delayStart + config.duration then
            config.currentValue = config.startValue + ((config.elapsed - config.delayStart) / config.duration) * config.delta;
            if config.onUpdate ~= nil then
              config.onUpdate(config.currentValue);
            end
          else
            if not config.preserveValue then
              config.currentValue = config.startValue;
            else
              config.currentValue = config.targetValue;
            end
            config.onUpdate(config.targetValue);
          end
        end
        if config.elapsed >= config.duration + config.delayStart + config.delayComplete then
          if config.onComplete ~= nil then
            config.onComplete();
          end
          config.complete = true;
          return;
        end
      end
    end
  end
end

function gb:_Demo(amount)
  amount = tonumber(amount);
  gb:_TransitionGold(_currentBalance + amount);
end

function gb:_PrintCurrentBalance()
  print(string.format('Current Gold Balance: %i', _currentBalance));
end

function gb:_SetCurrentBalance(newBalance)
  _currentBalance = newBalance;
end

function gb:_SetDefaultBalance()
  _G["MoneyToast_Widget_Balance"].Label:SetText(MT_CURRENT_BALANCE);
end

function gb:_Update(animated)
  gb:_HideOrShowWidget();
  gb:_SetDefaultBalance();
  local newBalance = GetMoney();
  local delta = newBalance - _currentBalance;
  if _currentBalance == 0 then
    _currentBalance = newBalance;
    gb:_SimpleAnimationSetCurrentValue("BalanceAnimation",_currentBalance);
    return;
  end
  if abs(delta) > 0 then
    gb:_SetCurrentBalance(newBalance);
    if animated then
      _G["MoneyToast_Widget"]:Show();
      gb:_SimpleAnimationCancel("FrameFadeOut");
      if not frameVisible then
        deltaBalance = delta;
        gb:_SimpleAnimationPlay("FrameFadeIn");
      else
        deltaBalance = deltaBalance + delta;
        FrameFadeIn_OnComplete();
      end
      if deltaBalance > 0 then
        _G["MoneyToast_Widget_Balance"].Label:SetText(string.format(MT_MONEY_RECEIVED, GetMoneyStringPadded(abs(deltaBalance), true)));
      else
        _G["MoneyToast_Widget_Balance"].Label:SetText(string.format(MT_MONEY_SPENT, GetMoneyStringPadded(abs(deltaBalance), true)));
      end
    else
      gb:_SimpleAnimationSetCurrentValue("BalanceAnimation",_currentBalance);
    end
  end
end
