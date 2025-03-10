local TOOL = TOOL

TOOL.Base = "base_point"
if CLIENT then
    TOOL.Description = language.GetPhrase("mappatcher.tools.x3m4k_ladder.description")
end

--------------------------------------------------------------------------------

TOOL.TextureColor = Color(0, 238, 255, 150)
TOOL.TextureText = "#mappatcher.tools.x3m4k_ladder.title"
TOOL.TextureSize = {256, 512}
TOOL.DefaultModel = "models/props_c17/metalladder001.mdl"
TOOL.DefaultHeight = 128
TOOL.ModelPresets = {
    "models/props_c17/metalladder001.mdl",
    "models/props_c17/metalladder002.mdl"
}
TOOL.DefaultHopDistance = 17

--------------------------------------------------------------------------------

function TOOL:PreviewPaint(panel, w, h)
    local x, y = panel:LocalToScreen(0, 0)
    cam.Start3D(Vector(-35, -35, 88), Angle(35, 45, 0), 90, x, y, w, h)

    if not IsValid(self.localPreviewEntity) then
        self.localPreviewEntity = ClientsideModel(self.model and self.model or TOOL.DefaultModel)
    end
    local ent = self.localPreviewEntity

    local mmin, mmax = ent:GetModelRenderBounds()
    local height = mmax[3] - mmin[3]
    local scale = 88 / height
    ent:SetModelScale(scale)

    render.Model(
        {
            model = "",
            pos = self.point and self.point or Vector(),
            angle = Angle(0, RealTime() * 40, 0)
        },
        ent
    )

    local mmin1, mmax1 = ent:GetRenderBounds() -- update render bounds

    render.SetColorMaterial()
    render.DrawWireframeBox(Vector(), Angle(0, RealTime() * 40, 0), mmin1, mmax1, Color(255, 255, 255), true)
    cam.End3D()
end

function TOOL:ObjectCreated()
    self.point = nil
    self.ang = Angle()
    self.model = TOOL.DefaultModel
    self.height = TOOL.DefaultHeight
    self.clientModel = nil
    self.modelHeight = TOOL.DefaultHeight
end

function TOOL:LeftClick(pos, ang)
    self.point = pos
    self.ang = (ang.y + 180) % 360
    if SERVER then
        self.entity:SetPos(pos)
    end
end

function TOOL:EditorRender(selected)
    local mins, maxs
    local clientModel = MapPatcher.Editor.LadderEnts[self.ID]
    if self.ID == 0 then
        mins = Vector(-3.305, -12.2175, 0)
        maxs = Vector(3.305, 12.2175, 128.71)
    else
        if not IsValid(clientModel) then
            if not IsValid(self.localEntity) then
                self.localEntity = ClientsideModel(self.model and self.model or TOOL.DefaultModel)
            end
            local entity = self.localEntity
            MapPatcher.Editor.LadderEnts[self.ID] = entity
            self.clientModel = entity
            clientModel = self.clientModel
            entity:SetPos(self.point)
            entity:SetAngles(Angle(0, self.ang, 0))
            local scale = Vector(1, 1, self.height / self.modelHeight)

            local mat = Matrix()
            mat:Scale(scale)
            if self.clientModel ~= nil then
                self.clientModel:EnableMatrix("RenderMultiply", mat)
                mins, maxs = self.clientModel:GetRenderBounds()

                local minsX, minsY, minsZ = mins:Unpack()
                local maxsX, maxsY, maxsZ = maxs:Unpack()

                self.clientModel:SetRenderBounds(
                    Vector(minsX, -24.435 / 2, minsZ),
                    Vector(maxsX, 24.435 / 2, self.modelHeight * scale[3])
                )
            end
        else
            mins, maxs = clientModel:GetRenderBounds()
            local minsX, minsY, minsZ = mins:Unpack()
            local maxsX, maxsY, maxsZ = maxs:Unpack()
            mins = Vector(minsX, -24.435 / 2, minsZ)
            maxs = Vector(maxsX, 24.435 / 2, maxsZ)
        end
    end

    render.SetMaterial(MapPatcher.GetToolMaterial(self.ClassName))
    render.DrawBox(self.point or Vector(), Angle(0, self.ang, 0), mins, maxs, self.TextureColor, true)

    if selected then
        render.DrawWireframeBox(self.point or Vector(), Angle(0, self.ang, 0), mins, maxs, Color(255, 255, 255), false)
    else
        render.DrawWireframeBox(
            self.point or Vector(),
            Angle(0, self.ang, 0),
            mins,
            maxs,
            Color(255, 255, 255, 20),
            false
        )
    end
end

function TOOL:SetupObjectPanel(panel)
    local function OpenBrowser(s)
        local frame = vgui.Create("DFrame")
        frame:SetSizable(true)
        frame:SetSize(800, 600)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("Model Browser")
        local browser = vgui.Create("DFileBrowser", frame)
        browser:Dock(FILL)

        browser:SetPath("GAME")
        browser:SetBaseFolder("models")
        browser:SetName("Props")
        browser:SetFileTypes("*.mdl")
        browser:SetModels(true)
        browser:SetOpen(true)
        browser:SetCurrentFolder("props_c17")

        function browser:OnSelect(path, pnl)
            frame:Close()
            s.model = path
            s:UpdateEntity()
        end
    end

    local DLabel = vgui.Create("DLabel", panel)
    DLabel:SetTextColor(Color(255, 255, 255, 255))
    DLabel:SetPos(10, 10)
    DLabel:SetText("#mappatcher.tools.x3m4k_ladder.settings.model_title")
    DLabel:SizeToContents()

    local ModelSelectComboBox = vgui.Create("DComboBox", panel)

    ModelSelectComboBox:SetPos(10, 10)
    ModelSelectComboBox:SetText("#mappatcher.tools.x3m4k_ladder.settings.ladder_model_presets")
    ModelSelectComboBox:SizeToContents()
    local origModelSelectWide = ModelSelectComboBox:GetWide() + 15
    local origModelSelectTall = ModelSelectComboBox:GetTall() + 15
    ModelSelectComboBox:SetWide(origModelSelectWide)
    ModelSelectComboBox:SetTall(origModelSelectTall)
    ModelSelectComboBox:SetValue("#mappatcher.tools.x3m4k_ladder.settings.ladder_model_presets")
    ModelSelectComboBox:AddChoice(
        language.GetPhrase("#mappatcher.tools.x3m4k_ladder.settings.ladder_preset_base") .. " " .. "#1",
        nil,
        self.model == TOOL.ModelPresets[1]
    )
    ModelSelectComboBox:AddChoice(
        language.GetPhrase("#mappatcher.tools.x3m4k_ladder.settings.ladder_preset_base") .. " " .. "#2",
        nil,
        self.model == TOOL.ModelPresets[2]
    )
    ModelSelectComboBox:AddChoice(
        language.GetPhrase("#mappatcher.tools.x3m4k_ladder.settings.ladder_custom_model"),
        nil,
        self.model ~= TOOL.ModelPresets[2] and self.model ~= TOOL.ModelPresets[1]
    )

    ModelSelectComboBox.OnSelect = function(s, index, value)
        if index <= 2 then
            ModelSelectComboBox:SizeToContents()
            ModelSelectComboBox:SetWide(ModelSelectComboBox:GetWide() + 15)
            ModelSelectComboBox:SetTall(ModelSelectComboBox:GetTall() + 15)
            self.model = TOOL.ModelPresets[index]
            self:UpdateEntity()
        else
            if self.point == nil then
                MapPatcher.Message(
                    language.GetPhrase("#mappatcher.tools.x3m4k_ladder.settings.error_no_object"),
                    nil,
                    "#mappatcher.error"
                )
                return
            end
            OpenBrowser(self)
        end
    end

    local DermaNumSlider = vgui.Create("DNumSlider", panel)
    DermaNumSlider:SetPos(10, ModelSelectComboBox:GetTall() + 15 + 15)
    DermaNumSlider:SetSize(400, 100)
    DermaNumSlider:SetText("#mappatcher.tools.x3m4k_ladder.settings.height")
    DermaNumSlider:SetMin(16)
    DermaNumSlider:SetMax(1024)
    DermaNumSlider:SetDecimals(1)
    DermaNumSlider:SetValue(self.height)

    DermaNumSlider.OnValueChanged = function(slider, value)
        self.height = value
        local scale = Vector(1, 1, self.height / self.modelHeight)

        local mat = Matrix()
        mat:Scale(scale)
        local clientModel = MapPatcher.Editor.LadderEnts[self.ID]
        if clientModel ~= nil then
            clientModel:EnableMatrix("RenderMultiply", mat)
            local mins, maxs = clientModel:GetRenderBounds()

            local maxsX, maxsY, maxsZ = maxs:Unpack()

            clientModel:SetRenderBounds(mins, Vector(maxsX, maxsY, self.modelHeight * scale[3]))
        end
    end

    local HopDistSlider = vgui.Create("DNumSlider", panel)
    HopDistSlider:SetPos(10, DermaNumSlider:GetY() + 60)
    HopDistSlider:SetSize(400, 100)
    HopDistSlider:SetText("#mappatcher.tools.x3m4k_ladder.settings.hopDistance")
    HopDistSlider:SetMin(5)
    HopDistSlider:SetMax(256)
    HopDistSlider:SetDecimals(1)
    HopDistSlider:SetValue(self.hopDistance or TOOL.DefaultHopDistance)

    HopDistSlider.OnValueChanged = function(slider, value)
        self.hopDistance = value
    end
end

function TOOL:GetOrigin()
    return self.point
end

function TOOL:IsValid()
    return self.point ~= nil
end

function TOOL:ToString()
    if getmetatable(self) == self then
        return "[class] " .. self.ClassName
    end

    local usefulModelName = self.model

    if string.find(usefulModelName, "/") then
        local s = string.Split(self.model, "/")
        usefulModelName = s[#s]
    end

    return "[" .. self.ID .. "] " .. self.ClassName .. ' "' .. usefulModelName .. '"'
end

function TOOL:EntRemove()
    if CLIENT then
        local clientModel = MapPatcher.Editor.LadderEnts[self.ID]
        if clientModel ~= nil then
            clientModel:Remove()
        end
        if IsValid(self.localEntity) then
            self.localEntity:Remove()
        end
        if IsValid(self.localPreviewEntity) then
            self.localPreviewEntity:Remove()
        end
    else
        self.entity:Remove()
    end
end

function TOOL:Terminate()
    self:EntRemove()
end

function TOOL:Initialize()
    if (CLIENT) then
        if (self.ID == "0") then
            return
        end

        local clientModel = MapPatcher.Editor.LadderEnts[self.ID]
        if clientModel ~= nil then
            clientModel:Remove()
        end

        if not IsValid(self.localEntity) then
            self.localEntity = ClientsideModel(self.model and self.model or TOOL.DefaultModel)
        end
        local entity = self.localEntity
        clientModel = entity
        MapPatcher.Editor.LadderEnts[self.ID] = entity
        entity:SetPos(self.point)
        entity:SetAngles(Angle(0, self.ang, 0))
        local scale = Vector(1, 1, self.height / self.modelHeight)

        local mat = Matrix()
        mat:Scale(scale)
        if clientModel ~= nil then
            clientModel:EnableMatrix("RenderMultiply", mat)
            local mins, maxs = clientModel:GetRenderBounds()

            local maxsX, maxsY, maxsZ = maxs:Unpack()

            clientModel:SetRenderBounds(mins, Vector(maxsX, maxsY, self.modelHeight * scale[3]))
        end
    end
    self:UpdateEntity()
end

function TOOL:UpdateEntity()
    local entity = self.entity

    if SERVER then
        if IsValid(entity) then
            entity:Remove()
        end
        entity = ents.Create("mappatcher_brush")
        entity:Spawn()
        entity:SetObjectID(self.ID)
        entity:SetObjectClass(self.ClassName)
    elseif CLIENT then
        entity = Entity(self.entity_id or -1)
        if not IsValid(entity) then
            return
        end
        if not entity.MapPatcherObject then
            return
        end
        if entity:GetCreationID2() ~= self.entity_cid then
            return
        end
    end

    self.entity = entity
    entity.object = self

    entity:SetPos(self.point)
    entity:SetModel(self.model)

    mins, maxs = entity:GetModelBounds()

    local maxsX, maxsY, maxsZ = maxs:Unpack()
    local minsX, minsY, minsZ = mins:Unpack()

    entity:PhysicsInit(SOLID_BBOX)
    entity:SetCollisionBounds(mins, Vector(maxsX, maxsY, self.modelHeight * (self.height / self.modelHeight)))
    entity:SetAngles(Angle(0, self.ang, 0))

    local physobj = entity:GetPhysicsObject()

    if IsValid(physobj) then
        physobj:EnableMotion(false)
    else
        ErrorNoHalt("[MapPatcher] Invalid physics object was created for object(" .. self.ID .. ")\n")
        ErrorNoHalt("[MapPatcher] Marking object(" .. self.ID .. ") as invalid.\n")
        self.point = nil
    end

    entity:SetMoveType(MOVETYPE_NONE)
    entity:SetSolid(SOLID_BBOX)

    entity:SetCollisionGroup(COLLISION_GROUP_WORLD)

    entity:CollisionRulesChanged()

    if SERVER then
        local angs = Angle(0, self.ang, 0)

        self.entity:SetAngles(Angle(0, self.ang, 0))
        local fw = self.entity:GetForward()

        local pos = self.point
        local dist = self.hopDistance
        local dismountDist = 40
        local bottom =
            self.entity:LocalToWorld(
            Vector((math.abs(maxsX) - math.abs(minsX)) / 2, (math.abs(maxsY) - math.abs(minsY)) / 2, minsZ)
        )
        local top =
            self.entity:LocalToWorld(
            Vector(
                (math.abs(maxsX) - math.abs(minsX)) / 2,
                (math.abs(maxsY) - math.abs(minsY)) / 2,
                minsZ + self.modelHeight * (self.height / self.modelHeight)
            )
        )

        local idx = self.entity:EntIndex()

        self.ladder = ents.Create("func_useableladder")
        self.ladder:SetPos(pos + fw * dist)
        self.ladder:SetKeyValue("point0", tostring(bottom + fw * dist))
        self.ladder:SetKeyValue("point1", tostring(top + fw * dist))
        self.ladder:SetKeyValue("targetname", "zladder_" .. idx)
        self.ladder:SetParent(self.entity)
        self.ladder:Spawn()

        self.bottomDismount = ents.Create("info_ladder_dismount")
        self.bottomDismount:SetPos(bottom + fw * dismountDist)
        self.bottomDismount:SetKeyValue("laddername", "zladder_" .. idx)
        self.bottomDismount:SetParent(self.entity)
        self.bottomDismount:Spawn()

        self.topDismount = ents.Create("info_ladder_dismount")
        self.topDismount:SetPos(top - fw * dist)
        self.topDismount:SetKeyValue("laddername", "zladder_" .. idx)
        self.topDismount:SetParent(self.entity)
        self.topDismount:Spawn()

        self.ladder:Activate()
    end

    if CLIENT then
        entity:DestroyShadow()
    end
end

--------------------------------------------------------------------------------
function TOOL:WriteToBuffer(buffer)
    buffer:WriteVector(self.point or Vector())
    buffer:WriteFloat(self.ang or 0)
    buffer:WriteString(self.model or TOOL.DefaultModel)
    buffer:WriteUInt16(self.height or TOOL.DefaultHeight)
    buffer:WriteUInt16(self.modelHeight or TOOL.DefaultHeight)
    buffer:WriteUInt16(self.hopDistance or TOOL.DefaultHopDistance)
    buffer:WriteString("")
end

function TOOL:ReadFromBuffer(buffer, len)
    self.point = buffer:ReadVector()
    self.ang = buffer:ReadFloat()
    self.model = buffer:ReadString()
    self.height = buffer:ReadUInt16()
    self.modelHeight = buffer:ReadUInt16()
    self.hopDistance = buffer:ReadUInt16()
    self.notImplemented = buffer:ReadString() -- reserved for future updates
end

--------------------------------------------------------------------------------
