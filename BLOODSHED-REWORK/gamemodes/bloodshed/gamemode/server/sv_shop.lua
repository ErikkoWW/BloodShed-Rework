local meta = FindMetaTable("Player")
util.AddNetworkString("MuR.UseShop")

net.Receive("MuR.UseShop", function(len, ply)
	local str = net.ReadString()
	local id = net.ReadFloat()
	ply:BuyItem(str, id)
end)

function meta:BuyItem(cat, id)
	-- if self:GetNWFloat("Guilt") >= 50 then
	-- 	MuR:GiveAnnounce("money_cancel", self)
	-- 	return
	-- end
	
	local tab = MuR.Shop[cat]
	if cat == "Soldier" and not MuR.War and self:GetNWString("Class") != "Soldier" or cat == "Killer" and not self:IsKiller() then return end
	if not istable(tab) or not tab[id] then return end

	local item = tab[id]
	if self:GetNWFloat("Money") < item.price then return end

	self:SetNWFloat("Money", self:GetNWFloat("Money") - item.price)
	item.func(self)
end