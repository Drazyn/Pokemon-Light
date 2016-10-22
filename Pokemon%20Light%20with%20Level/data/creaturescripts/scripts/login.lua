local config = {
	loginMessage = getConfigValue('loginMessage'),
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

function onLogin(cid)
	if getCreatureStorage(cid, 73421) ~= 1 then
		doPlayerAddItem(cid, 12703, 1, false, 7)
		doPlayerSetSkillLevel(cid, 6, 0)
		doPlayerSetSkillLevel(cid, 3, 0)
		setPlayerStorageValue(cid, 73421, 1)
	end
	doPlayerSetVocation(cid, 1)
	if getPlayerGroupId(cid) < 4 then
		doRegainSpeed(cid)
	end
	local loss = getConfigValue('deathLostPercent')
	if(loss ~= nil and getPlayerStorageValue(cid, "bless") ~= 5) then
		doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, loss * 10)
	end

	if(getPlayerStorageValue(cid, "death_bless") == 1) then
		local t = {PLAYERLOSS_EXPERIENCE, PLAYERLOSS_SKILLS, PLAYERLOSS_ITEMS, PLAYERLOSS_CONTAINERS}
		for i = 1, #t do
			doPlayerSetLossPercent(cid, t[i], 100)
		end
		setPlayerStorageValue(cid, "death_bless", 0)
	end

	local accountManager = getPlayerAccountManager(cid)
	if(accountManager == MANAGER_NONE) then
		local lastLogin, str = getPlayerLastLoginSaved(cid), config.loginMessage
		if(lastLogin > 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
			str = "Your last visit was on " .. os.date("%a %b %d %X %Y", lastLogin) .. "."
		else
			str = str .. " Please choose your outfit."
			doPlayerSendOutfitWindow(cid)
		end

		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
	elseif(accountManager == MANAGER_NAMELOCK) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, it appears that your character has been namelocked, what would you like as your new name?")
	elseif(accountManager == MANAGER_ACCOUNT) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to manage your account and if you want to start over then type 'cancel'.")
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to create an account or type 'recover' to recover an account.")
	end

	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end

	registerCreatureEvent(cid, "GuildMotd")
	registerCreatureEvent(cid, "Idle")
	registerCreatureEvent(cid, "ReportBug")
	registerCreatureEvent(cid, "AdvanceSave")

	if isRiding(cid) then -- Ride
		local item = getPlayerSlotItem(cid, 8)
		if item.uid > 0 then
			local pokename = getItemAttribute(item.uid, "poke")
			local pokes = rides[pokename]
			if pokes then
				doChangeSpeed(cid, pokes.speed + getCreatureSpeed(cid))
				addon = getItemAttribute(item.uid, "addon")
				if addon and PokeAddons[pokename][addon].ride then
					doSetCreatureOutfit(cid, {lookType = PokeAddons[pokename][addon].ride}, -1)
				else
					doSetCreatureOutfit(cid, {lookType = pokes.looktype}, -1)
				end
			else
				setPlayerStorageValue(cid, 13241, -1)
				setPlayerStorageValue(cid, 13242, -1)
			end
		end
	elseif isFlying(cid) then
		local item = getPlayerSlotItem(cid, 8)
		if item.uid > 0 then
			local pokename = getItemAttribute(item.uid, "poke")
			local pokes = flys[pokename]
			if pokes then
				doChangeSpeed(cid, pokes.speed + getCreatureSpeed(cid))
				addon = getItemAttribute(getPlayerSlotItem(cid, 8).uid, "addon")
				if addon and PokeAddons[pokename][addon].fly then
					doSetCreatureOutfit(cid, {lookType = PokeAddons[pokename][addon].fly}, -1)
				else
					doSetCreatureOutfit(cid, {lookType = pokes.looktype}, -1)
				end
				local flypos = getFlyingMarkedPos(cid)
				flypos.stackpos = 0
				if getTileThingByPos(flypos).itemid <= 2 then
					doCombatAreaHealth(cid, FIREDAMAGE, getFlyingMarkedPos(cid), 0, 0, 0, CONST_ME_NONE)
					doCreateItem(460, 1, getFlyingMarkedPos(cid))
				end 
				doTeleportThing(cid, flypos, false)
				markFlyingPos(cid, getTownTemplePosition(getPlayerTown(cid)))
			else
				setPlayerStorageValue(cid, 13241, -1)
				setPlayerStorageValue(cid, 13242, -1)
				doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)			
			end
		end
	end

	registerCreatureEvent(cid, "LookSystem")
	registerCreatureEvent(cid, "targetCreature")
	registerCreatureEvent(cid, "KillTask")
	registerCreatureEvent(cid, "logout delay")
	registerCreatureEvent(cid, "DropStone")
	registerCreatureEvent(cid, "PlayerInformation")
	registerCreatureEvent(cid, "OpenChannelDialog")
	registerCreatureEvent(cid, "HouseTranslation")
	registerCreatureEvent(cid, "T1")
	registerCreatureEvent(cid, "T2")--Container
	registerCreatureEvent(cid, "MoveItem")--Damage1
	registerCreatureEvent(cid, "Damage1")--LootSystem
	registerCreatureEvent(cid, "LootSystem")
	registerCreatureEvent(cid, "AwayFromKeyboard1")
	registerCreatureEvent(cid, "AwayFromKeyboard2")
	registerCreatureEvent(cid, "DeathChannel")
	setPlayerStorageValue(cid, 3123, -1)
	doPlayerSave(cid, true)
	return true
end
