local function getDistance(fromPos, toPos)
	local pos = {
	x = fromPos.x - toPos.x,
	y = fromPos.y - toPos.y,
	z = fromPos.z
	}
return pos
end

function onAttack(cid, target)
	if isMonster(cid) then
		if isPlayer(target) then
			if #getCreatureSummons(target) > 0 then
				doMonsterSetTarget(cid, getCreatureSummons(target)[1])
			end
		end
	end
	if isCreature(cid) and isCreature(target) and not isPlayer(cid) then -- Direction System
		local pos = getDistance(getCreaturePosition(cid), getCreaturePosition(target))
		local dir = getDirectionTo(getCreaturePosition(cid), getCreaturePosition(target))
		
		if isInArray({0,1,2,3}, dir) then
			doCreatureSetLookDirection(cid, dir)
		else		
			if pos.y > 0 then 
				doCreatureSetLookDirection(cid, 0)
			else
				doCreatureSetLookDirection(cid, 2)
			end
		end		
	end
	return true
end