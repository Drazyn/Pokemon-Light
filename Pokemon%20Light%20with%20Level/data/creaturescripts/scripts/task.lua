local tasksss = {
   [1] = {name = "Blastoise",  sto = 10212, count = 3, time_sto = 5457, time = 1*24*60*60, sto_count = 14129, money = 100, rewardid = 7621, rewardcount = 100, rewardexp = 10000,  text = "Congratulations! You finished this task. In 24h, you will be able to do it again."},
   [2] = {name = "Charizard",  sto = 10213, count = 5, time_sto = 5458, time = 1*24*60*60, sto_count = 14130, money = 100, rewardid = 7621, rewardcount = 100, rewardexp = 10000,  text = "Congratulations! You finished this task. In 24h, you will be able to do it again."},
}

function onKill(cid, target)
        for _, t in ipairs(tasksss) do
            local total_count = t.count
            local m_sto = t.sto
            local count_sto = t.sto_count
            if getPlayerStorageValue(cid, m_sto) ~= -1 then
                if getCreatureName(target) == t.name then
                	if (total_count - getPlayerStorageValue(cid, count_sto)) == 1 then
                		setPlayerStorageValue(cid, count_sto, getPlayerStorageValue(cid, count_sto) + 1)
                    	doPlayerSendTextMessage(cid, 20, "You are killed ".. getPlayerStorageValue(cid, count_sto) .." " .. t.name .. " and finished the task!")
                    	return true
                    elseif (total_count - getPlayerStorageValue(cid, count_sto)) >= 1 then
                        setPlayerStorageValue(cid, count_sto, getPlayerStorageValue(cid, count_sto) + 1)
                        doPlayerSendTextMessage(cid, 20, "You are killed ".. getPlayerStorageValue(cid, count_sto) .." of ".. total_count .." " .. t.name .. " to finish the task!")
                        return true
                    end
                end
            end
        end
    return true
end