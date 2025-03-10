
AddCSLuaFile()


if engine.ActiveGamemode() == "bloodshed" then
local validUserGroupSM = {
    donator = false,
    bigdonator = false,
    admin = true,
    superadmin = true,
    owner = true,
    servermanager = true,
}

local validUserGroupCM = {
    donator = true,
    bigdonator = true,
    admin = true,
    superadmin = true,
    owner = true,
    servermanager = true,
}


if SERVER then


    local function CanUseSpawnMenu(ply,class)

        if validUserGroupSM[ply:GetUserGroup()] and ply:Team() ~= TEAM_SPECTATOR or GetGlobalBool("AccessSpawn") then return true end

        if not validUserGroupSM[ply:GetUserGroup()] then 
            ply:Kick("You do not have access to these tools.")  
            return false 
        end
    end

    hook.Add("PlayerSpawnVehicle","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"vehicle") end)
    hook.Add("PlayerSpawnRagdoll","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"ragdoll") end)
    hook.Add("PlayerSpawnEffect","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"effect") end)
    hook.Add("PlayerSpawnProp","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"prop") end)
    hook.Add("PlayerSpawnSENT","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"sent") end)
    hook.Add("PlayerSpawnNPC","Cantspawnbullshit",function(ply) return CanUseSpawnMenu(ply,"npc") end)

    hook.Add("PlayerSpawnSWEP","SpawnBlockSWEP",function(ply) return CanUseSpawnMenu(ply,"swep") end)
    hook.Add("PlayerGiveSWEP","SpawnBlockSWEP",function(ply) return CanUseSpawnMenu(ply,"swep") end)





    --hook.Add("PlayerSpawnObject","dontspawn!!!",cant)--salat eblan
else
    --local admin_menu = CreateClientConVar("hg_admin_menu","1",true,false,"enable admin menu",0,1)
    local function CanUseSpawnMenu()
        local ply = LocalPlayer()
        if not validUserGroupSM[ply:GetUserGroup()] and ply:Team() ~= TEAM_SPECTATOR then return false else return true end


        --if not ply:IsAdmin() then return false end
        --if not admin_menu:GetBool() then return false end
    end

    local function CanUseContextMenu()
        local ply = LocalPlayer()
        if not validUserGroupCM[ply:GetUserGroup()] and ply:Team() ~= TEAM_SPECTATOR then return false else return true end
    end

    hook.Add("ContextMenuOpen", "hide_contextmenu",CanUseContextMenu)
    hook.Add("SpawnMenuOpen", "hide_spawnmenu",CanUseSpawnMenu)
end
end