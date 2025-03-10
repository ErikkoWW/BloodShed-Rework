local meta = FindMetaTable("Player")

net.Receive("MuR.ShowLogScreen", function(len, ply)
	if !MuR.VoteAllowed then return end
	MuR.VoteLog = MuR.VoteLog + 1
end)

hook.Add("PlayerDeath", "MuR.LogWrite", function(ply)
	timer.Simple(5, function()
		if !IsValid(ply) or ply:Alive() then return end

		if ply:IsRolePolice() then
			table.insert(MuR.LogTable.dead_cops, {
				name = ply:Nick(),
				reason = ply:GetReasonLog(),
			})
		else
			table.insert(MuR.LogTable.dead, {
				name = ply:Nick(),
				model = ply:GetModel(),
				reason = ply:GetReasonLog(),
				isdanger = ply:IsKiller(),
			})
		end
	end)
end)

function MuR:ShowLogScreen()
	local allow, tab, time = MuR:GetLogTable()
	if !allow then return end

	net.Start("MuR.ShowLogScreen")
	net.WriteTable(tab)
	net.WriteFloat(time)
	net.Broadcast()

	MuR.TimeBeforeStart = CurTime() + time + 4
end

function MuR:GetLogTable()
	local hitab = {}
	local itab = {}
	for _, ply in ipairs(player.GetAll()) do
		if ply:Alive() then
			if ply:Health() < 30 then
				table.insert(hitab, {
					name = ply:Nick(),
					model = ply:GetModel(),
					reason = ply:GetReasonLog(),
					isdanger = ply:IsKiller(),
				})
			elseif ply:Health() < 80 then
				table.insert(itab, {
					name = ply:Nick(),
					model = ply:GetModel(),
					reason = ply:GetReasonLog(),
					isdanger = ply:IsKiller(),
				})
			end
		end
	end
	MuR.LogTable.injured = itab
	MuR.LogTable.heavy_injured = hitab
	for i=1, MuR.VoteLogDeadPolice do
		table.insert(MuR.LogTable.dead_cops, {
			name = table.Random(MuR.MaleNames),
			reason = "unknown",
		})
	end

	local tab = MuR.LogTable
	local allow_log = false 
	if #tab.dead+#tab.dead_cops+#tab.heavy_injured > 2 then
		allow_log = true
	end

	local time = 20
	time = time + #tab.dead * 4 + #tab.dead_cops * 4 + #tab.injured * 4 + #tab.heavy_injured * 4

	return allow_log, tab, time
end

function meta:GetReasonLog()
	local tab = self.LastDamageInfo
	if !istable(tab) then return "unknown" end

	local reason = "unknown"
	if tab[1] == DMG_BLAST or tab[3] then
		reason = "explosion"
	elseif tab[1] == DMG_BULLET or tab[1] == DMG_BUCKSHOT or tab[5] then
		reason = "bullet"
	elseif tab[1] == DMG_SLASH then
		reason = "slash"
	elseif tab[1] == DMG_CLUB then
		reason = "club"
	elseif tab[1] == DMG_NERVEGAS or tab[1] == DMG_POISON then
		reason = "toxic"
	elseif tab[1] == DMG_CRUSH or tab[6] then
		reason = "fall"
	end

	return reason
end