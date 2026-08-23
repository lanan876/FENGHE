local repo = 'https://raw.githubusercontent.com/deividcomsono/Obsidian/main/'

local function safeStart()
    local success, err = pcall(function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer

        -- 加载UI库
        local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
        local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
        local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

        Library.ShowToggleFrameInKeybinds = true 
        Library.ShowCustomCursor = true
        Library.NotifySide = "Right"

        -- 创建主窗口
        local Window = Library:CreateWindow({
            Title = 'FENGSAKEN',
            Center = true,
            AutoShow = true,
            Resizable = true,
            ShowCustomCursor = true,
            NotifySide = "Right",
            TabPadding = 8,
            MenuFadeTime = 0
        })

       
        local tabAutoBlock  = Window:AddTab('自动格挡', 'shield')
        local tabUI         = Window:AddTab('界面', 'layout-dashboard')
        
        
        local AutoBlockGroup = tabAutoBlock:AddLeftGroupbox("格挡控制", "shield")

        -- 全局参数
        getgenv().BaseHitboxSize = Vector3.new(4.5, 6, 7.5)
        getgenv().HitboxScale = 1.0
        getgenv().HitboxOffset = -1.4
        getgenv().KillerHitboxData = {}
        getgenv().HitboxColor = Color3.fromRGB(255, 255, 255)
        getgenv().HitboxOutlineColor = Color3.fromRGB(255, 255, 255)
        getgenv().ShowOutline = true
        getgenv().OutlineThickness = 0.05
        getgenv().ShowHitboxVisual = true

        -- 攻击数据表（包含所有杀手的 anim 和 swing）
        local attackData = {
            ["1x1x1x1"] = {
                anim = "rbxassetid://83829782357897",
                swing = "rbxassetid://117173212095661",
            },
            ["John Doe"] = {
                anim = "rbxassetid://105458270463374",
                swing = "rbxassetid://140242176732868",
            },
            ["Noli"] = {
                anim = "rbxassetid://106538427162796",
                swing = "rbxassetid://109348678063422",
            },
            ["Nosferatu"] = {
                anim = "rbxassetid://88451353906104",
                swing = "rbxassetid://104910828105172",
            },
            ["Guest 666"] = {
                anim = "rbxassetid://122709416391891",
                swing = { "rbxassetid://119583605486352", "rbxassetid://79980897195554" },
            },
            ["Slasher"] = {
                anim = "rbxassetid://126830014841198",
                swing = nil,
            },
            ["c00lkidd"] = {
                anim = "rbxassetid://18885909645",
                swing = "rbxassetid://80516583309685",
            },
            ["xX4ceOfSpadesXx"] = {
                anim = "rbxassetid://121293883585738",
                swing = "rbxassetid://115026634746636",
            },
            ["The Pestilence"] = {
                anim = "rbxassetid://124705663396411",
                swing = nil,
            },
            ["Fleskhjerta"] = {
                anim = "rbxassetid://121293883585738",
                swing = "rbxassetid://85853080745515",
            },
            ["Hacklord"] = {
                anim = "rbxassetid://126171487400618",
                swing = "rbxassetid://119942598489800",
            },
            ["Milestone III (1x1x1x1)"] = {
                anim = "rbxassetid://90620531468240",
                swing = nil,
            },
            ["Milestone IV (1x1x1x1)"] = {
                anim = "rbxassetid://90620531468240",
                swing = nil,
            },
            ["Digital Rider"] = {
                anim = "rbxassetid://127245564598429",
                swing = "rbxassetid://74809026448465",
            },
            ["Annihilation"] = {
                anim = "rbxassetid://93069721274110",
                swing = nil,
            },
            ["Aberrant"] = {
                anim = "rbxassetid://81299297965542",
                swing = "rbxassetid://131123355704017",
            },
            ["The Admin"] = {
                anim = "rbxassetid://91509234639766",
                swing = "rbxassetid://131406927389838",
            },
            ["Artful"] = {
                anim = "rbxassetid://77375846492436",
                swing = "rbxassetid://89004992452376",
            },
            ["Narrator"] = {
                anim = "rbxassetid://93366464803829",
                swing = "rbxassetid://128367348686124",
            },
            ["Milestone III (Noli)"] = {
                anim = "rbxassetid://92567970681901",
                swing = nil,
            },
            ["Retro"] = {
                anim = "rbxassetid://118298475669935",
                swing = nil,
            },
            ["White Pumpkin"] = {
                anim = "rbxassetid://94958041603347",
                swing = nil,
            },
            ["Pursuer"] = {
                anim = "rbxassetid://109667959938617",
                swing = "rbxassetid://108907358619313",
            },
            ["Milestone III (Slasher)"] = {
                anim = "rbxassetid://106860049270347",
                swing = nil,
            },
            ["Milestone IV (Slasher)"] = {
                anim = "rbxassetid://130958529065375",
                swing = nil,
            },
            ["Alfred Drevis"] = {
                anim = "rbxassetid://108196996477620",
                swing = nil,
            },
            ["Killer Kyle"] = {
                anim = "rbxassetid://118298475669935",
                swing = "rbxassetid://107444859834748",
            },
            ["Martyr"] = {
                anim = "rbxassetid://114506382930939",
                swing = "rbxassetid://121954639447247",
            },
            ["Celebration"] = {
                anim = "rbxassetid://114126519127454",
                swing = nil,
            },
            ["Mafioso"] = {
                anim = "rbxassetid://70371667919898",
                swing = "rbxassetid://84307400688050",
            },
            ["Milestone III (c00lkidd)"] = {
                anim = "rbxassetid://84069821282466",
                swing = nil,
            },
            ["Milestone IV (c00lkidd)"] = {
                anim = "rbxassetid://84069821282466",
                swing = nil,
            },
            -- ===== 新增 Azure 支持 =====
            ["Azure"] = {
                anim = "rbxassetid://123172382755876",   -- 来自 Animations.Slash
                swing = "rbxassetid://82843272472677",   -- 来自 Sounds.Slash
            },
        }

        -- 构建全局动画ID和音效ID查找表
        local GlobalAttackIDs = {}
        local GlobalAttackSoundIDs = {}

        for _, data in pairs(attackData) do
            if data.anim then
                local id = tostring(data.anim):match("%d+")
                if id then
                    GlobalAttackIDs[id] = true
                end
            end
            if data.swing then
                if type(data.swing) == "table" then
                    for _, s in ipairs(data.swing) do
                        local id = tostring(s):match("%d+")
                        if id then
                            GlobalAttackSoundIDs[id] = true
                        end
                    end
                else
                    local id = tostring(data.swing):match("%d+")
                    if id then
                        GlobalAttackSoundIDs[id] = true
                    end
                end
            end
        end

        -- 辅助函数：获取UI元素
        local function getBlockButton()
            local pg = player:FindFirstChild("PlayerGui")
            if not pg then return nil end
            local main = pg:FindFirstChild("MainUI")
            if not main then return nil end
            local container = main:FindFirstChild("AbilityContainer")
            if not container then return nil end
            return container:FindFirstChild("Block") or container:FindFirstChild("Guard")
        end

        local function pressBlock()
            local btn = getBlockButton()
            if not btn then return false end
            local cd = btn:FindFirstChild("CooldownTime")
            if cd and cd.Text ~= "" then return false end
            pcall(function() btn:Activate() end)
            for _, conn in ipairs(getconnections(btn.MouseButton1Click) or {}) do
                pcall(function() conn:Fire() end)
            end
            return true
        end

        -- 获取场景对象
        local function GetObjects()
            local KillersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
            local SurvivorsFolder = workspace.Players and workspace.Players:FindFirstChild("Survivors")
            local Hitboxes = workspace:FindFirstChild("Hitboxes") or Instance.new("Folder", workspace)
            Hitboxes.Name = "Hitboxes"
            return KillersFolder, SurvivorsFolder, Hitboxes
        end

        local KillersFolder, SurvivorsFolder, Hitboxes = GetObjects()

        -- 命中箱视觉创建与更新
        local function CreateHitboxVisual()
            local part = Instance.new("Part")
            part.Name = "AttackHitboxVisual"
            part.Size = getgenv().BaseHitboxSize * getgenv().HitboxScale
            part.Color = getgenv().HitboxColor
            part.Material = Enum.Material.ForceField
            part.Transparency = getgenv().ShowHitboxVisual and 0.3 or 1
            part.Anchored = true
            part.CanCollide = false
            part.CastShadow = false
            part.Parent = Hitboxes

            local outline = Instance.new("SelectionBox")
            outline.Adornee = part
            outline.Color3 = getgenv().HitboxOutlineColor
            outline.LineThickness = getgenv().OutlineThickness
            outline.Transparency = 0.1
            outline.Visible = getgenv().ShowOutline and getgenv().ShowHitboxVisual
            outline.Parent = part

            return part
        end

        local function UpdateHitboxPosition(part, queryHitbox)
            if part and queryHitbox then
                part.CFrame = queryHitbox.CFrame * CFrame.new(0, 0, getgenv().HitboxOffset)
                part.Size = getgenv().BaseHitboxSize * getgenv().HitboxScale
                part.Color = getgenv().HitboxColor
                part.Transparency = getgenv().ShowHitboxVisual and 0.3 or 1
                local outline = part:FindFirstChildOfClass("SelectionBox")
                if outline then
                    outline.Color3 = getgenv().HitboxOutlineColor
                    outline.LineThickness = getgenv().OutlineThickness
                    outline.Visible = getgenv().ShowOutline and getgenv().ShowHitboxVisual
                end
            end
        end

        local function ClearKillerHitbox(Killer)
            local data = getgenv().KillerHitboxData[Killer]
            if data then
                if data.part then
                    data.part:Destroy()
                end
                if data.connection then
                    data.connection:Disconnect()
                end
                getgenv().KillerHitboxData[Killer] = nil
            end
        end

        local function UpdateAllHitboxVisuals()
            for killer, data in pairs(getgenv().KillerHitboxData) do
                if data.part and data.part.Parent then
                    data.part.Color = getgenv().HitboxColor
                    data.part.Size = getgenv().BaseHitboxSize * getgenv().HitboxScale
                    data.part.Transparency = getgenv().ShowHitboxVisual and 0.3 or 1
                    local outline = data.part:FindFirstChildOfClass("SelectionBox")
                    if outline then
                        outline.Color3 = getgenv().HitboxOutlineColor
                        outline.LineThickness = getgenv().OutlineThickness
                        outline.Visible = getgenv().ShowOutline and getgenv().ShowHitboxVisual
                    end
                end
            end
        end

        -- 核心攻击检测函数
        local OverlapParams = OverlapParams.new()
        OverlapParams.MaxParts = 1
        OverlapParams.FilterType = Enum.RaycastFilterType.Include
        local Debris = game:GetService("Debris")
        local RunService = game:GetService("RunService")
        local LocalPlayer = player

        local function StartAttack(Killer, queryHitbox, Track)
            ClearKillerHitbox(Killer)

            local visualPart = CreateHitboxVisual()
            UpdateHitboxPosition(visualPart, queryHitbox)

            local updateConnection
            updateConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().AutoBlockEnabled then
                    updateConnection:Disconnect()
                    return
                end
                if visualPart and visualPart.Parent and queryHitbox and queryHitbox.Parent then
                    UpdateHitboxPosition(visualPart, queryHitbox)
                else
                    updateConnection:Disconnect()
                end
            end)

            getgenv().KillerHitboxData[Killer] = {
                part = visualPart,
                connection = updateConnection
            }

            if Track then
                Track.Stopped:Once(function()
                    ClearKillerHitbox(Killer)
                end)
                Track.Destroying:Once(function()
                    ClearKillerHitbox(Killer)
                end)
            end

            local LocalChar = LocalPlayer.Character
            if not LocalChar or LocalChar.Parent ~= SurvivorsFolder then
                return
            end

            local LocalQuery = LocalChar:FindFirstChild("QueryHitbox")
            if not LocalQuery then return end

            local isC00lkidd = Killer.Name:lower():find("c00lkidd") or Killer.Name:lower():find("coolkidd")

            local hitboxSize = getgenv().BaseHitboxSize * getgenv().HitboxScale

            if isC00lkidd then
                OverlapParams.FilterDescendantsInstances = {LocalQuery}

                local Part = Instance.new("Part")
                Part.Name = "KillerDetectHitbox"
                Part.Size = hitboxSize
                Part.CFrame = queryHitbox.CFrame * CFrame.new(0, 0, getgenv().HitboxOffset)
                Part.CanCollide = false
                Part.Anchored = true
                Part.CastShadow = false
                Part.Material = Enum.Material.ForceField
                Part.Transparency = 1
                Part.Parent = Hitboxes
                Debris:AddItem(Part, 0.4)

                local hits = workspace:GetPartsInPart(Part, OverlapParams)
                if #hits > 0 then
                    pressBlock()
                end
                return
            end

            for i = 1, 6 do
                if not getgenv().AutoBlockEnabled then break end
                if not LocalChar.Parent or LocalChar.Parent ~= SurvivorsFolder then break end

                OverlapParams.FilterDescendantsInstances = {LocalQuery}

                local Part = Instance.new("Part")
                Part.Name = "KillerDetectHitbox"
                Part.Size = hitboxSize
                Part.CFrame = queryHitbox.CFrame * CFrame.new(0, 0, getgenv().HitboxOffset)
                Part.CanCollide = false
                Part.Anchored = true
                Part.CastShadow = false
                Part.Material = Enum.Material.ForceField
                Part.Transparency = 1
                Part.Parent = Hitboxes
                Debris:AddItem(Part, 0.4)

                local hits = workspace:GetPartsInPart(Part, OverlapParams)
                if #hits > 0 then
                    pressBlock()
                    break
                end
                task.wait(0.015)
            end
        end

        -- 为每个杀手设置监听
        local function HandleKiller(Killer)
            if not Players:GetPlayerFromCharacter(Killer) then return end
            local humanoid = Killer:FindFirstChildOfClass("Humanoid")
            local queryHitbox = Killer:FindFirstChild("QueryHitbox")
            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
            if not (animator and queryHitbox) then return end

            local soundConnections = {}
            local function OnSoundAdded(Sound)
                if not Sound:IsA("Sound") then return end
                local id = tostring(Sound.SoundId):match("%d+")
                if not id or not GlobalAttackSoundIDs[id] then return end

                local playedConn = Sound.Played:Connect(function()
                    if not getgenv().AutoBlockEnabled then return end
                    StartAttack(Killer, queryHitbox, Sound)
                end)

                local stoppedConn = Sound.Stopped:Connect(function()
                    ClearKillerHitbox(Killer)
                end)

                table.insert(soundConnections, playedConn)
                table.insert(soundConnections, stoppedConn)

                if Sound.IsPlaying then
                    task.spawn(function()
                        if getgenv().AutoBlockEnabled then
                            StartAttack(Killer, queryHitbox, Sound)
                        end
                    end)
                end
            end

            for _, sound in ipairs(Killer:GetDescendants()) do
                OnSoundAdded(sound)
            end

            local descendantConn = Killer.DescendantAdded:Connect(OnSoundAdded)
            table.insert(soundConnections, descendantConn)

            local function cleanupSounds()
                for _, conn in ipairs(soundConnections) do
                    conn:Disconnect()
                end
                soundConnections = {}
            end

            local connection = animator.AnimationPlayed:Connect(function(Track)
                if not getgenv().AutoBlockEnabled then
                    connection:Disconnect()
                    return
                end

                local id = tostring(Track.Animation.AnimationId):match("%d+")
                local isMatch = false

                if id and GlobalAttackIDs[id] then
                    isMatch = true
                end

                if not isMatch then return end

                StartAttack(Killer, queryHitbox, Track)
            end)

            local function cleanup()
                cleanupSounds()
                connection:Disconnect()
                ClearKillerHitbox(Killer)
            end

            Killer.AncestryChanged:Connect(function()
                if not Killer.Parent then
                    cleanup()
                end
            end)

            table.insert(getgenv().AutoBlockConnections or {}, {
                Disconnect = cleanup
            })
        end

        -- 启用/禁用自动格挡
        getgenv().AutoBlockEnabled = false
        getgenv().AutoBlockConnections = {}

        local function EnableAutoBlock()
            if getgenv().AutoBlockEnabled then return end
            getgenv().AutoBlockEnabled = true
            if getgenv().AutoBlockConnections then
                for _, con in ipairs(getgenv().AutoBlockConnections) do
                    pcall(con.Disconnect, con)
                end
                getgenv().AutoBlockConnections = {}
            end
            if KillersFolder then
                for _, killer in ipairs(KillersFolder:GetChildren()) do
                    HandleKiller(killer)
                end
                local childCon = KillersFolder.ChildAdded:Connect(HandleKiller)
                table.insert(getgenv().AutoBlockConnections, childCon)
            end
            Library:Notify("自动格挡已启用", 3)
        end

        local function DisableAutoBlock()
            if not getgenv().AutoBlockEnabled then return end
            getgenv().AutoBlockEnabled = false
            if getgenv().AutoBlockConnections then
                for _, con in ipairs(getgenv().AutoBlockConnections) do
                    pcall(con.Disconnect, con)
                end
                getgenv().AutoBlockConnections = {}
            end

            for killer, data in pairs(getgenv().KillerHitboxData) do
                if data.part then
                    data.part:Destroy()
                end
                if data.connection then
                    data.connection:Disconnect()
                end
            end
            getgenv().KillerHitboxData = {}
            Library:Notify("自动格挡已禁用", 3)
        end

        -- ========== 构建 Obsidian UI 控件 ==========
        -- 主开关
        AutoBlockGroup:AddToggle("AutoBlockToggle", {
            Text = "启用自动格挡 (Fixblock + Azure)",
            Default = false,
            Callback = function(state)
                if state then
                    EnableAutoBlock()
                else
                    DisableAutoBlock()
                end
            end
        })

        AutoBlockGroup:AddDivider()

        -- 命中箱参数
        AutoBlockGroup:AddLabel("命中箱尺寸 (宽/高/长)")
        AutoBlockGroup:AddSlider("HitboxWidth", {
            Text = "宽度 (X)",
            Default = 4.5,
            Min = 1,
            Max = 20,
            Rounding = 0.1,
            Callback = function(v)
                getgenv().BaseHitboxSize = Vector3.new(v, getgenv().BaseHitboxSize.Y, getgenv().BaseHitboxSize.Z)
                UpdateAllHitboxVisuals()
            end
        })
        AutoBlockGroup:AddSlider("HitboxHeight", {
            Text = "高度 (Y)",
            Default = 6,
            Min = 1,
            Max = 20,
            Rounding = 0.1,
            Callback = function(v)
                getgenv().BaseHitboxSize = Vector3.new(getgenv().BaseHitboxSize.X, v, getgenv().BaseHitboxSize.Z)
                UpdateAllHitboxVisuals()
            end
        })
        AutoBlockGroup:AddSlider("HitboxLength", {
            Text = "长度 (Z)",
            Default = 7.5,
            Min = 1,
            Max = 20,
            Rounding = 0.1,
            Callback = function(v)
                getgenv().BaseHitboxSize = Vector3.new(getgenv().BaseHitboxSize.X, getgenv().BaseHitboxSize.Y, v)
                UpdateAllHitboxVisuals()
            end
        })
        AutoBlockGroup:AddSlider("HitboxScale", {
            Text = "整体缩放",
            Default = 1.0,
            Min = 0.2,
            Max = 3.0,
            Rounding = 0.05,
            Callback = function(v)
                getgenv().HitboxScale = v
                UpdateAllHitboxVisuals()
            end
        })
        AutoBlockGroup:AddSlider("HitboxOffset", {
            Text = "Z轴偏移 (负值向后)",
            Default = -1.4,
            Min = -10,
            Max = 0,
            Rounding = 0.1,
            Callback = function(v)
                getgenv().HitboxOffset = v
                UpdateAllHitboxVisuals()
            end
        })

        AutoBlockGroup:AddDivider()

        -- 可视化选项
        AutoBlockGroup:AddToggle("ShowHitboxVisual", {
            Text = "显示命中箱",
            Default = true,
            Callback = function(state)
                getgenv().ShowHitboxVisual = state
                UpdateAllHitboxVisuals()
            end
        })
        AutoBlockGroup:AddToggle("ShowOutline", {
            Text = "显示边框",
            Default = true,
            Callback = function(state)
                getgenv().ShowOutline = state
                UpdateAllHitboxVisuals()
            end
        })
        AutoBlockGroup:AddSlider("OutlineThickness", {
            Text = "边框粗细",
            Default = 0.05,
            Min = 0.01,
            Max = 0.5,
            Rounding = 0.01,
            Callback = function(v)
                getgenv().OutlineThickness = v
                UpdateAllHitboxVisuals()
            end
        })

        -- 颜色选择器
        AutoBlockGroup:AddLabel("命中箱颜色")
        AutoBlockGroup:AddColorPicker("HitboxFillColor", {
            Title = "填充颜色",
            Default = getgenv().HitboxColor,
            Callback = function(color)
                getgenv().HitboxColor = color
                UpdateAllHitboxVisuals()
            end
        })
        AutoBlockGroup:AddColorPicker("HitboxOutlineColor", {
            Title = "边框颜色",
            Default = getgenv().HitboxOutlineColor,
            Callback = function(color)
                getgenv().HitboxOutlineColor = color
                UpdateAllHitboxVisuals()
            end
        })

        AutoBlockGroup:AddDivider()
        AutoBlockGroup:AddLabel("说明：基于动画/音效检测攻击，自动格挡。")
        AutoBlockGroup:AddLabel("已支持包括 Azure 在内的所有杀手。")

        -- ==================== 界面选项卡 ====================
        local menuGroup = tabUI:AddLeftGroupbox("界面设置")
        menuGroup:AddToggle("KeybindMenuOpen", {
            Text = "快捷键菜单",
            Default = true,
            Callback = function() end
        })
        menuGroup:AddToggle("ShowCustomCursor", {
            Text = "自定义光标",
            Default = true,
            Callback = function() end
        })
        menuGroup:AddDropdown("NotificationSide", {
            Text = "通知位置",
            Values = {"Left", "Right"},
            Default = "Right",
            Callback = function() end
        })
        menuGroup:AddDropdown("DPIDropdown", {
            Text = "UI 缩放",
            Values = {"25%", "50%", "75%", "100%", "125%", "150%", "175%", "200%"},
            Default = "100%",
            Callback = function() end
        })
        menuGroup:AddDivider()
        menuGroup:AddLabel("菜单绑定")
            :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "菜单快捷键" })
        menuGroup:AddButton("销毁界面", function() Library:Unload() end)

        -- ==================== 主题和保存管理 ====================
        ThemeManager:SetLibrary(Library)
        SaveManager:SetLibrary(Library)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
        ThemeManager:SetFolder("v1prware")
        SaveManager:SetFolder("v1prware/specific-game")
        SaveManager:SetSubFolder("pilgrammed")
        SaveManager:BuildConfigSection(tabUI)
        ThemeManager:ApplyToTab(tabUI)

        ThemeManager:SetTheme("Dark")

        print("✅ Fixblock 自动格挡已集成，新增 Azure 支持")
    end)

    if not success then
        warn("❌ UI 加载失败：", err)
    end
end

safeStart()