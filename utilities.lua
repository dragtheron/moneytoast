local _, addon = ...
---@cast addon MoneyToastAddon

local getMoneyStringPadded = function(money, separateThousands)
	money = abs(money)
	local goldString, silverString, copperString;
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = mod(money, COPPER_PER_SILVER);

	---@diagnostic disable-next-line: undefined-global
	if ( ENABLE_COLORBLIND_MODE == "1" ) then
		goldString = FormatLargeNumber(gold)..GOLD_AMOUNT_SYMBOL;
		silverString = silver..SILVER_AMOUNT_SYMBOL;
		copperString = copper..COPPER_AMOUNT_SYMBOL;
	else
		goldString = GOLD_AMOUNT_TEXTURE_STRING:format(FormatLargeNumber(gold), 0, 0);
		silverString = SILVER_AMOUNT_TEXTURE:format(silver, 0, 0);
		copperString = COPPER_AMOUNT_TEXTURE:format(copper, 0, 0);
	end

  if gold > 0 and silver < 10 then
    silverString = "0"..silverString;
  end

  if silver > 0 and copper < 10 then
    copperString = "0"..copperString;
  end

	local moneyString = "";
	local separator = "";
	if ( gold > 0 ) then
		moneyString = goldString;
		separator = " ";
	end
	if ( gold > 0 or silver > 0 ) then
		moneyString = moneyString..separator..silverString;
		separator = " ";
	end
	if ( gold > 0 or silver > 0 or copper > 0 or moneyString == "" ) then
		moneyString = moneyString..separator..copperString;
	end

	return moneyString;
end

local shallowCopy = function(objToCopy)
	local originalType = type(objToCopy)
	local copy

	if originalType == "table" then
		copy = {}

		for originalKey, originalValue in pairs(objToCopy) do
			copy[originalKey] = originalValue
		end
	else
		copy = objToCopy
	end

	return copy
end

---@class UtilitiesModule
local utilitiesModule = {
	GetMoneyStringPadded = getMoneyStringPadded,
	ShallowCopy = shallowCopy,
}

addon.Utilities = utilitiesModule
