-- utilities

function GetMoneyStringPadded(money, separateThousands)
	local goldString, silverString, copperString;
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = mod(money, COPPER_PER_SILVER);

	if ( ENABLE_COLORBLIND_MODE == "1" ) then
		if (separateThousands) then
			goldString = FormatLargeNumber(gold)..GOLD_AMOUNT_SYMBOL;
		else
			goldString = gold..GOLD_AMOUNT_SYMBOL;
		end
		silverString = silver..SILVER_AMOUNT_SYMBOL;
		copperString = copper..COPPER_AMOUNT_SYMBOL;
	else
		if (separateThousands) then
			goldString = GOLD_AMOUNT_TEXTURE_STRING:format(FormatLargeNumber(gold), 0, 0);
		else
			goldString = GOLD_AMOUNT_TEXTURE:format(gold, 0, 0);
		end
		silverString = SILVER_AMOUNT_TEXTURE:format(silver, 0, 0);
		copperString = COPPER_AMOUNT_TEXTURE:format(copper, 0, 0);
	end

  if silver < 10 then
    silverString = "0"..silverString;
  end

  if copper < 10 then
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
