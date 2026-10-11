-- This file was generated at discord.gg/syncrypt

local t1 = {}
do
    local Players = game:GetService("Players")

    game:GetService("UserInputService")
    t1.value1 = game:GetService("RunService")
    t1.value2 = game:GetService("ReplicatedStorage")
    t1.value3 = game:GetService("Workspace")
    t1.value4 = game:GetService("Stats")
    t1.value5 = game:GetService("Debris")
    t1.value6 = game:GetService("TweenService")
    t1.value7 = game:GetService("SoundService")
    t1.value8 = Players.LocalPlayer
end
t1.value9 = t1.value8:WaitForChild("PlayerGui", 10)

do
    local v3 = isfolder or function()
        return false
    end
    local v4 = makefolder or function()
    end
    local v5 = writefile or function()
    end
    local v6 = isfile or function()
        return false
    end
    local v7 = readfile or function()
        return ""
    end

    t1.value10 = {
		hasFolder = v3,
		makeFolder = v4,
		write = v5,
		hasFile = v6,
		read = v7
	}
end
t1.value11 = {}
t1.value12 = "FENGblock"
t1.value13 = t1.value12 .. "/config.json"
t1.value14 = game:GetService("HttpService")

function t1.value15()
    if not t1.value10.hasFolder(t1.value12) then
        t1.value10.makeFolder(t1.value12)
    end
end
function t1.value11.load()
    t1.value15()

    if not t1.value10.hasFile(t1.value13) then
        return
    end

    local v173 = t1.value10.read(t1.value13)

    if not v173 or v173 == "" then
        return
    end

    local ok, result = pcall(t1.value14.JSONDecode, t1.value14, v173)

    if ok then
        ok = type(result) == "table"
    end

    if ok then
        for k, v in pairs(result) do
            t1.value11._data[k] = v
        end
    end
end
function t1.value11.save()
    t1.value15()

    local ok, result = pcall(t1.value14.JSONEncode, t1.value14, t1.value11._data)

    if ok then
        ok = result and result ~= ""
    end

    if ok then
        pcall(t1.value10.write, t1.value13, result)
    end
end
function t1.value11.get(p1, p2)
    local v182 = t1.value11._data[p1]

    if v182 == nil then
        return p2
    end

    return v182
end
function t1.value11.set(p3, p4)
    t1.value11._data[p3] = p4
    t1.value11.save()
end
t1.value11._data = {}
t1.value11.load()
t1.value16 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ginzuss/nullui/refs/heads/main/NullUI.lua"))()
if not t1.value16 then
    error("NullUI加载失败")
end
do
    local value16 = t1.value16
    local color3 = Color3.fromRGB(255, 215, 0)
    local color3_2 = Color3.fromRGB(0, 0, 0)
    local color3_3 = Color3.fromRGB(255, 215, 0)
    local color3_4 = Color3.fromRGB(255, 255, 255)
    local color3_5 = Color3.fromRGB(200, 200, 200)
    local color3_6 = Color3.fromRGB(139, 0, 0)
    local color3_7 = Color3.fromRGB(255, 215, 0)
    local color3_8 = Color3.fromRGB(255, 215, 0)
    local color3_9 = Color3.fromRGB(0, 0, 0)
    local color3_10 = Color3.fromRGB(20, 20, 20)
    local color3_11 = Color3.fromRGB(0, 0, 0)
    local color3_12 = Color3.fromRGB(255, 215, 0)
    local color3_13 = Color3.fromRGB(255, 255, 255)
    local color3_14 = Color3.fromRGB(255, 215, 0)
    local color3_15 = Color3.fromRGB(255, 215, 0)
    local color3_16 = Color3.fromRGB(255, 255, 255)
    local color3_17 = Color3.fromRGB(200, 200, 200)
    local color3_18 = Color3.fromRGB(255, 215, 0)
    local color3_19 = Color3.fromRGB(20, 20, 20)
    local color3_20 = Color3.fromRGB(255, 255, 255)
    local color3_21 = Color3.fromRGB(255, 215, 0)
    local color3_22 = Color3.fromRGB(25, 25, 25)
    local color3_23 = Color3.fromRGB(255, 255, 255)
    local color3_24 = Color3.fromRGB(200, 200, 200)
    local color3_25 = Color3.fromRGB(255, 215, 0)
    local color3_26 = Color3.fromRGB(0, 0, 0)
    local color3_27 = Color3.fromRGB(255, 215, 0)
    local color3_28 = Color3.fromRGB(255, 255, 255)
    local color3_29 = Color3.fromRGB(255, 215, 0)
    local color3_30 = Color3.fromRGB(139, 0, 0)
    local color3_31 = Color3.fromRGB(80, 80, 80)
    local color3_32 = Color3.fromRGB(139, 0, 0)
    local color3_33 = Color3.fromRGB(255, 215, 0)
    local color3_34 = Color3.fromRGB(139, 0, 0)
    local color3_35 = Color3.fromRGB(255, 215, 0)
end

local v131, v132
do
    local v54

    do
        local v55

        do
            local value16 = t1.value16
            local uDim2 = UDim2.fromOffset(420, 550)

            t1.value17 = NullLib:CreateWindow({
				Name = "V1PRBLOCK",
				Title = "V1PRBLOCK",
				Icon = "sparkle",
				Author = "由不用替身维护",
				Folder = "FENGblock",
				Size = uDim2,
				Transparent = false,
				Resizable = true,
				SideBarWidth = 160,
				HideSearchBar = true,
				ScrollBarEnabled = true
			})
                        
            local value17 = t1.value17
            local uDim = UDim.new(0, 16)
            local color3 = Color3.fromHex("000000")
            t1.value18 = t1.value11.get("guestAutoBlockAudioOn", true)
            t1.value19 = t1.value11.get("guestAutoPunchOn", true)
            t1.value20 = t1.value11.get("guestVerifyFacingCheckOn", true)
            t1.value21 = t1.value11.get("guestShowVisionRange", false)
            t1.value22 = t1.value11.get("guestDetectionRange", 20)
            t1.value23 = t1.value22 * t1.value22
            t1.value24 = t1.value11.get("guestVisionRange", 13.5)
            t1.value25 = t1.value11.get("guestVisionAngle", 85)
            t1.value26 = t1.value11.get("guestAimPunchActive", true)
            t1.value27 = t1.value11.get("guestPunchPrediction", 2.3)
            t1.value28 = t1.value11.get("guestAimPunchDuration", 0.5)
            t1.value29 = t1.value11.get("guestBlockCooldown", 0.35)
            t1.value30 = t1.value11.get("guestBlockDelay", 0)
            t1.value31 = t1.value11.get("guestAutoPunchDelay", 0.3)
            t1.value32 = t1.value11.get("guestBetterDetectionEnabled", false)
            t1.value33 = t1.value11.get("guestBetterDetectionX", 3)
            t1.value34 = t1.value11.get("guestBetterDetectionY", 2.5)
            t1.value35 = t1.value11.get("guestBetterDetectionZ", 4)
            t1.value36 = t1.value11.get("guestBetterDetectionMultiplier", 2.4)
            t1.value37 = t1.value11.get("guestBetterDetectionSegments", 14)
            t1.value38 = t1.value11.get("guestBetterStartDist", 2.2)
            t1.value39 = t1.value11.get("guestBetterStepDist", 0.05)
            t1.value40 = t1.value11.get("guestBetterPreDelay", 0.15)
            t1.value41 = t1.value11.get("guestBetterStagger", 0.03)
            t1.value42 = t1.value11.get("guestBetterPredForward", 1.1)
            t1.value43 = t1.value11.get("guestBetterPredTurn", 1.2)
            t1.value44 = t1.value11.get("guestReverseEnabled", false)
            t1.value45 = t1.value11.get("guestLegacyFacingEnabled", false)
            t1.value46 = t1.value11.get("guestLegacyVisionRange", 13.5)
            t1.value47 = t1.value11.get("guestLegacyVisionAngle", 85)
            t1.value48 = t1.value11.get("guestLegacyShowVisionRange", false)
            t1.value49 = t1.value11.get("guestCinematicTextEnabled", false)
            t1.value50 = t1.value11.get("guestCinematicText", "PARRY!")
            t1.value51 = t1.value11.get("guestSmartDelayEnabled", false)
            t1.value52 = t1.value11.get("guestManualDragEnabled", false)
            t1.value53 = t1.value11.get("pingCheckerEnabled", false)
            t1.value54 = t1.value11.get("noHDTCooldown", false)
            t1.value55 = t1.value11.get("hdtCooldownChecker", false)
            t1.value56 = t1.value11.get("noclipEnabled", false)
            t1.value57 = t1.value11.get("noclipOnlyWhenBlockReady", false)
            t1.value58 = t1.value11.get("fpsCounterEnabled", false)
            t1.value59 = t1.value11.get("customPunchSoundId", 0)
            t1.value60 = t1.value11.get("punchMobilityEnabled", false)
            t1.value61 = t1.value11.get("chargeControlEnabled", false)
            t1.value62 = t1.value11.get("lungeBoostEnabled", false)
            t1.value63 = t1.value11.get("lungeMultiplier", 1)
            t1.value64 = t1.value11.get("chargeSpeedCapEnabled", false)
            t1.value65 = t1.value11.get("chargeSpeedLimit", 12)
            t1.value66 = t1.value11.get("guestHitboxDraggingOn", false)
            t1.value67 = t1.value11.get("guestHitboxMode", "Blatant")
            t1.value68 = t1.value11.get("guestHitboxFaceKiller", false)
            t1.value69 = t1.value11.get("guestHitboxVisual", false)
            t1.value70 = t1.value11.get("guestHitboxTargetMode", "Root")
            t1.value71 = t1.value11.get("guestHitboxDragDuration", 1)
            t1.value72 = t1.value11.get("guestHitboxTriggerRadius", 15)
            t1.value73 = t1.value11.get("guestShowHDTRange", false)
            t1.value74 = t1.value11.get("hdtPredictTime", 0.12)
            t1.value75 = t1.value11.get("hdtSwitchDist", 8)
            t1.value76 = t1.value11.get("lineBlockEnabled", false)
            t1.value77 = t1.value11.get("lineBlockLength", 15)
            t1.value78 = t1.value11.get("lineBlockRadius", 1.5)
            t1.value79 = t1.value11.get("lineBlockDelay", 0.05)
            t1.value80 = t1.value11.get("lineBlockFacingDuration", 0.1)
            t1.value81 = t1.value11.get("lineBlockMinDot", 0.5)
            t1.value82 = {}
            t1.value83 = {}
            t1.value84 = {}
            t1.value85 = {}
            t1.value86 = 0
            t1.value87 = {}
            t1.value88 = {
				["102228729296384"] = true,
				["140242176732868"] = true,
				["112809109188560"] = true,
				["136323728355613"] = true,
				["115026634746636"] = true,
				["84116622032112"] = true,
				["108907358619313"] = true,
				["127793641088496"] = true,
				["86174610237192"] = true,
				["95079963655241"] = true,
				["101199185291628"] = true,
				["119942598489800"] = true,
				["84307400688050"] = true,
				["113037804008732"] = true,
				["105200830849301"] = true,
				["75330693422988"] = true,
				["82221759983649"] = true,
				["109348678063422"] = true,
				["81702359653578"] = true,
				["85853080745515"] = true,
				["108610718831698"] = true,
				["112395455254818"] = true,
				["109431876587852"] = true,
				["12222216"] = true,
				["79980897195554"] = true,
				["119583605486352"] = true,
				["71834552297085"] = true,
				["116581754553533"] = true,
				["86833981571073"] = true,
				["110372418055226"] = true,
				["105840448036441"] = true,
				["86494585504534"] = true,
				["80516583309685"] = true,
				["131406927389838"] = true,
				["89004992452376"] = true,
				["117231507259853"] = true,
				["101698569375359"] = true,
				["101553872555606"] = true,
				["140412278320643"] = true,
				["106300477136129"] = true,
				["117173212095661"] = true,
				["104910828105172"] = true,
				["140194172008986"] = true,
				["85544168523099"] = true,
				["114506382930939"] = true,
				["99829427721752"] = true,
				["120059928759346"] = true,
				["104625283622511"] = true,
				["105316545074913"] = true,
				["126131675979001"] = true,
				["82336352305186"] = true,
				["93366464803829"] = true,
				["84069821282466"] = true,
				["128856426573270"] = true,
				["121954639447247"] = true,
				["128195973631079"] = true,
				["124903763333174"] = true,
				["94317217837143"] = true,
				["98111231282218"] = true,
				["119089145505438"] = true,
				["136728245733659"] = true,
				["71310583817000"] = true,
				["107444859834748"] = true,
				["76959687420003"] = true,
				["72425554233832"] = true,
				["96594507550917"] = true,
				["139996647355899"] = true,
				["107345261604889"] = true,
				["127557531826290"] = true,
				["108651070773439"] = true,
				["74842815979546"] = true,
				["124397369810639"] = true,
				["76467993976301"] = true,
				["118493324723683"] = true,
				["78298577002481"] = true,
				["116527305931161"] = true,
				["5148302439"] = true,
				["98675142200448"] = true,
				["128367348686124"] = true,
				["71805956520207"] = true,
				["125213046326879"] = true,
				["84353899757208"] = true,
				["103684883268194"] = true,
				["109246041199659"] = true,
				["80540530406270"] = true,
				["139523195429581"] = true,
				["105204810054381"] = true,
				["114742322778642"] = true,
				["116468089135195"] = true
			}
            t1.value89 = {
				["87259391926321"] = true,
				["140703210927645"] = true,
				["136007065400978"] = true,
				["129843313690921"] = true,
				["86709774283672"] = true,
				["108807732150251"] = true,
				["138040001965654"] = true,
				["86096387000557"] = true,
				["81905101227053"] = true,
				["127777649118195"] = true,
				["99100240941590"] = true,
				["92831180929659"] = true,
				["112081768119093"] = true,
				["117587689359268"] = true,
				["91830732867282"] = true,
				["91730605416216"] = true,
				["100184164753080"] = true
			}
            t1.value90 = {
				"Slasher",
				"c00lkidd",
				"JohnDoe",
				"1x1x1x1",
				"Noli",
				"Sixer",
				"Nosferatu"
			}
            t1.value91 = nil
            t1.value92 = nil
            t1.value93 = false
            t1.value94 = 0
            t1.value95 = nil
            t1.value96 = nil
            t1.value97 = nil
            t1.value98 = nil
            t1.value99 = {}
            t1.value100 = {}
            t1.value101 = 0
            t1.value102 = 0.5
            t1.value103 = {}
            t1.value104 = nil
            t1.value105 = nil
            t1.value106 = nil
            t1.value107 = nil
            t1.value108 = nil
            t1.value109 = nil
            t1.value110 = nil
            t1.value111 = nil
            t1.value112 = nil
            t1.value113 = nil
            t1.value114 = nil
            t1.value115 = nil
            t1.value116 = nil
            t1.value117 = nil
            t1.value118 = 12
            t1.value119 = 40
            t1.value120 = 0.7
            t1.value121 = 0.4
            t1.value122 = false
            t1.value123 = false
            t1.value124 = nil
            t1.value125 = nil
            t1.value126 = false
            t1.value127 = nil
            t1.value128 = {}
            t1.value129 = {}
            t1.value130 = nil
            t1.value131 = nil
            t1.value132 = nil
            t1.value133 = 0.25
            t1.value134 = 0.18
            t1.value135 = 6
            t1.value136 = 4
            t1.value137 = 0.6
            t1.value138 = 0.22
            t1.value139 = 0
            t1.value140 = 0
            t1.value141 = 0
            t1.value142 = t1.value2.Modules.Network.Network:FindFirstChild("RemoteEvent")

            if not t1.value142 then
                t1.value142 = t1.value2.Modules.Network.Network:WaitForChild("RemoteEvent", 10)
            end

            function t1.value143()
                local Character = t1.value8.Character

                return Character and Character:FindFirstChild("HumanoidRootPart")
            end
            function t1.value144()
                local Character = t1.value8.Character

                return Character and Character:FindFirstChild("Humanoid")
            end
            function t1.value145()
                return false
            end

            local function v53()
                if t1.value54 then
                    return true
                end

                local MainUI = t1.value9:FindFirstChild("MainUI")

                if MainUI then
                    local AbilityContainer = MainUI:FindFirstChild("AbilityContainer")

                    if AbilityContainer then
                        local Block = AbilityContainer:FindFirstChild("Block")

                        if Block then
                            local CooldownTime = Block:FindFirstChild("CooldownTime")

                            if CooldownTime and CooldownTime:IsA("TextLabel") then
                                local v234 = CooldownTime.Text:match("[%d%.]+")

                                if v234 then
                                    local num = tonumber(v234)

                                    return not num or num <= 0
                                end

                                return true
                            end
                        end
                    end
                end

                return tick() - t1.value101 >= t1.value29
            end

            function t1.value146(p5)
                if not p5 then
                    return nil
                end

                local str = tostring(p5.SoundId)
                local v197 = str:match("%d+")

                if v197 then
                    return v197
                end

                local v198 = str:match("[&%?]hash=([^&]+)")

                if v198 then
                    return "&hash=" .. v198
                end

                local v199 = str:match("rbxasset://sounds/.+")

                if v199 then
                    return v199
                end

                return nil
            end
            function t1.value147(p6)
                if not p6 then
                    return nil
                end

                if p6.Parent and p6.Parent:IsA("BasePart") then
                    return p6.Parent.Position, p6.Parent
                end

                local p6Parent = p6.Parent

                if p6Parent then
                    p6Parent = p6.Parent:IsA("Attachment") and (p6.Parent.Parent and p6.Parent.Parent:IsA("BasePart"))
                end

                if p6Parent then
                    return p6.Parent.Parent.Position, p6.Parent.Parent
                end

                local v229 = p6.Parent and p6.Parent:FindFirstChildWhichIsA("BasePart", true)

                if v229 then
                    return v229.Position, v229
                end

                return nil, nil
            end
            function t1.value148(p7)
                if not p7 then
                    return nil
                end

                local Model = p7:FindFirstAncestorOfClass("Model")

                if Model and Model:FindFirstChildOfClass("Humanoid") then
                    local v213 = t1.value3:FindFirstChild("Players") and t1.value3.Players:FindFirstChild("Killers")

                    if v213 and Model:IsDescendantOf(v213) then
                        return Model
                    end
                end

                return nil
            end
            function t1.value149(p8, p9)
                local v208 = not p8

                if not v208 then
                    v208 = not p9
                end

                if v208 then
                    return false
                end

                local v209 = p8.CFrame:PointToObjectSpace(p9)
                local v210 = p8.Size * 0.5

                return math.abs(v209.X) <= v210.X + 0.001 and (math.abs(v209.Y) <= v210.Y + 0.001 and math.abs(v209.Z) <= v210.Z + 0.001)
            end
            function t1.value150(p10)
                local Hitboxes = t1.value3:FindFirstChild("Hitboxes")

                if Hitboxes then
                    local n1 = 0
                    local v217
                    for _, child in ipairs(Hitboxes:GetChildren()) do
                        if child:IsA("BasePart") then
                            local v220 = child.Size.X * child.Size.Y * child.Size.Z

                            if n1 < v220 then
                                v217 = child
                                n1 = v220
                            end
                        end
                    end
                    if v217 then
                        return v217
                    end
                end

                local Hitboxes2 = p10:FindFirstChild("Hitboxes")

                if Hitboxes2 then
                    for _, child in ipairs(Hitboxes2:GetChildren()) do
                        if child:IsA("BasePart") then
                            return child
                        end
                    end
                end

                for _, descendant in ipairs(p10:GetDescendants()) do
                    if descendant:IsA("BasePart") and descendant.Name:lower():find("hitbox") then
                        return descendant
                    end
                end

                return nil
            end
            function t1.value151(p11)
                if not p11 then
                    return nil
                end

                local QueryHitbox = p11:FindFirstChild("QueryHitbox")

                if QueryHitbox and QueryHitbox:IsA("BasePart") then
                    return QueryHitbox
                end

                for _, child in ipairs(p11:GetChildren()) do
                    local QueryHitbox2 = child:FindFirstChild("QueryHitbox")

                    if QueryHitbox2 and QueryHitbox2:IsA("BasePart") then
                        return QueryHitbox2
                    end
                end

                return nil
            end
            function t1.value152(p12)
                if not p12 then
                    return nil
                end

                local v241 = t1.value151(p12)

                if v241 then
                    return v241.Position, v241
                end

                local HumanoidRootPart = p12:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    return HumanoidRootPart.Position, HumanoidRootPart
                end

                return nil, nil
            end
            function t1.value153()
                if not t1.value142 then
                    return
                end

                t1.value142:FireServer("UseActorAbility", {
					[1] = buffer.fromstring("\003\005\000\000\000Block")
				})
            end
            function t1.value154()
                if not t1.value142 then
                    return
                end

                if t1.value59 and t1.value59 ~= 0 then
                    pcall(function()
                        local Sound = Instance.new("Sound")

                        Sound.SoundId = "rbxassetid://" .. tostring(t1.value59)
                        Sound.Volume = 1
                        Sound.Parent = t1.value7
                        Sound:Play()
                        t1.value5:AddItem(Sound, 3)
                    end)
                end

                t1.value142:FireServer("UseActorAbility", {
					[1] = buffer.fromstring("\003\005\000\000\000Punch")
				})
            end
            function t1.value155()
                if not t1.value49 then
                    return
                end

                if t1.value104 then
                    t1.value104:Destroy()
                    t1.value104 = nil
                end

                local ScreenGui = Instance.new("ScreenGui")

                ScreenGui.Name = "CinematicText"
                ScreenGui.Parent = t1.value9
                ScreenGui.IgnoreGuiInset = true
                ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                ScreenGui.DisplayOrder = 10000

                local TextLabel = Instance.new("TextLabel")

                TextLabel.Size = UDim2.new(1, 0, 0, 100)
                TextLabel.Position = UDim2.new(0, 0, 0.4, -50)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = t1.value50
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                TextLabel.TextStrokeTransparency = 0.3
                TextLabel.TextSize = 60
                TextLabel.Font = Enum.Font.GothamBold
                TextLabel.TextScaled = true
                TextLabel.RichText = true
                TextLabel.Parent = ScreenGui
                t1.value104 = ScreenGui
                task.delay(1.5, function()
                    if t1.value104 then
                        t1.value104:Destroy()
                    end
                end)
            end

            t1.value156 = nil

            function t1.value156(p13)
                if not t1.value66 or not p13 then
                    return
                end
                if not v53() then
                    task.spawn(function()
                        local n2 = 0

                        while not v53() and n2 < 30 do
                            task.wait(0.1)
                            n2 += 0.1
                        end

                        if v53() and (t1.value66 and p13.Parent) then
                            t1.value156(p13)
                        end
                    end)

                    return
                end
                local value67 = t1.value67
                local value68 = t1.value68
                local value69 = t1.value69
                local value70 = t1.value70
                local value71 = t1.value71
                local u251
                if value67 == "Hitbox" then
                    u251 = t1.value150(p13)

                    if not u251 then
                        value67 = "Blatant"
                    end
                end
                if not u251 then
                    if value70 == "Arms" or value70 == "Random" then
                        local t2 = {}
                        for v255, v256 in ipairs({
							"Right Arm",
							"Left Arm",
							"RightHand",
							"LeftHand",
							"RightUpperArm",
							"LeftUpperArm"
						}) do

                            local v257 = p13:FindFirstChild(v256)

                            if v257 and v257:IsA("BasePart") then
                                table.insert(t2, v257)
                            end
                        end
                        if #t2 > 0 then
                            if value70 == "Arms" then
                                u251 = t2[1]
                            else
                                local v258 = p13:FindFirstChild("HumanoidRootPart") or p13:FindFirstChild("Torso")

                                u251 = math.random() < 0.5 and v258 or t2[math.random(#t2)]
                            end
                        end
                    end

                    if not u251 then
                        u251 = p13:FindFirstChild("HumanoidRootPart") or p13:FindFirstChild("Torso")
                    end

                    if not u251 then
                        for _, descendant in ipairs(p13:GetDescendants()) do
                            if descendant:IsA("BasePart") then
                                u251 = descendant

                                break
                            end
                        end
                    end
                end
                if not u251 then
                    return
                end
                local Character = t1.value8.Character
                local v262 = Character and Character:FindFirstChild("Humanoid")
                local v263 = Character and Character:FindFirstChild("HumanoidRootPart")
                if not v262 or not v263 then
                    return
                end
                if value67 == "Smart" then
                    value67 = not ((u251.Position - v263.Position).Magnitude <= t1.value75) and "Blatant" or "Legit"
                end
                local WalkSpeed = v262.WalkSpeed
                local AutoRotate = v262.AutoRotate
                local u266
                local function v267()
                    if not value69 then
                        return
                    end

                    u266 = Instance.new("Part")
                    u266.Size = Vector3.new(0.3, 0.3, 1)
                    u266.Anchored = true
                    u266.CanCollide = false
                    u266.Material = Enum.Material.Neon
                    u266.Transparency = 0.3
                    u266.Color = Color3.fromRGB(255, 215, 0)
                    u266.Parent = t1.value3
                    t1.value5:AddItem(u266, value71 + 0.15)
                end
                local function v268()
                    if not u266 or not u266.Parent then
                        return
                    end

                    if not v263 or (not v263.Parent or not u251.Parent) then
                        return
                    end

                    local Position = v263.Position
                    local Position2 = u251.Position
                    local v528 = Position2 - Position
                    local v529 = (Position + Position2) * 0.5
                    local Magnitude = v528.Magnitude

                    u266.Size = Vector3.new(0.3, 0.3, Magnitude)
                    u266.CFrame = CFrame.new(v529, Position2)
                end
                local timestamp = tick()
                local u270 = false
                local value101 = t1.value101
                if value67 == "Legit" then
                    local v272 = t1.value11.get("hdtLegitSpeed", 140)
                    v262.AutoRotate = false
                    v262.WalkSpeed = v272
                    v267()
                    local value16_2 = t1.value16
                                        local v275 = "持续时间: " .. value71 .. "秒"
                    t1.value17:Notify({
						Title = "HDT (合法)",
						Content = v275,
						Duration = 2
					})
                    local connection
                    connection = t1.value1.Heartbeat:Connect(function()
                        local v531 = tick() - timestamp
                        if t1.value101 > value101 then
                            u270 = true
                        end
                        if v531 >= 26.5 and not u270 then
                            connection:Disconnect()
                            v262.WalkSpeed = WalkSpeed
                            v262.AutoRotate = AutoRotate
                            t1.value17:Notify({
								Title = "HDT失效",
								Content = "26.5秒内未检测到格挡",
								Duration = 2
							})

                            return
                        end
                        local v532 = v531 >= value71
                        if not v532 then
                            v532 = not t1.value66 or (not u251.Parent or not v262.Parent)
                        end
                        if v532 then
                            connection:Disconnect()
                            v262.WalkSpeed = WalkSpeed
                            v262.AutoRotate = AutoRotate

                            return
                        end
                        local v534 = t1.value103[p13]
                        local v535 = v534 and v534.vel or Vector3.zero
                        local Position = u251.Position
                        local v537 = v263
                        local v538 = Position + v535 * t1.value74
                        local v539 = v538 - v537.Position
                        if v539.Magnitude > 0.1 then
                            local _ = v539.Unit

                            v262:MoveTo(v538)
                        end
                        if value68 then
                            local v541 = u251.Position - v263.Position

                            if v541.Magnitude > 0.1 then
                                v263.CFrame = v263.CFrame:Lerp(CFrame.new(v263.Position, v263.Position + v541.Unit), 0.35)
                            end
                        end
                        v268()
                    end)
                else
                    local v277 = t1.value11.get("hdtBlatantSpeed", 150)
                    v262.WalkSpeed = 0
                    v262.AutoRotate = false
                    v267()
                    local value16_3 = t1.value16
                    local v279 = "持续时间: " .. value71 .. "秒"
                    t1.value17:Notify({
						Title = "HDT (明显)",
						Content = v279,
						Duration = 2
					})
                    local connection
                    connection = t1.value1.Heartbeat:Connect(function()
                        local v542 = tick() - timestamp
                        if t1.value101 > value101 then
                            u270 = true
                        end
                        if v542 >= 26.5 and not u270 then
                            connection:Disconnect()
                            v263.AssemblyLinearVelocity = Vector3.zero
                            v262.WalkSpeed = WalkSpeed
                            v262.AutoRotate = AutoRotate
                            t1.value17:Notify({
								Title = "HDT失效",
								Content = "26.5秒内未检测到格挡",
								Duration = 2
							})

                            return
                        end
                        local v543 = v542 >= value71
                        if not v543 then
                            v543 = not t1.value66

                            if not v543 then
                                v543 = not u251.Parent or (not v262.Parent or not v263.Parent)
                            end
                        end
                        if v543 then
                            connection:Disconnect()
                            v263.AssemblyLinearVelocity = Vector3.zero
                            v262.WalkSpeed = WalkSpeed
                            v262.AutoRotate = AutoRotate

                            return
                        end
                        local v545 = t1.value103[p13]
                        local v546 = v545 and v545.vel or Vector3.zero
                        local v547 = u251.Position + v546 * t1.value74 - v263.Position
                        if v547.Magnitude > 0.1 then
                            local Magnitude = v547.Magnitude
                            local v549 = math.min(v277, Magnitude * 12)
                            local AssemblyLinearVelocity = v263.AssemblyLinearVelocity
                            local v551 = v547.Unit * v549

                            v263.AssemblyLinearVelocity = Vector3.new(v551.X, AssemblyLinearVelocity.Y, v551.Z)
                        else
                            v263.AssemblyLinearVelocity = Vector3.new(0, v263.AssemblyLinearVelocity.Y, 0)
                        end
                        if value68 then
                            local v552 = u251.Position - v263.Position

                            if v552.Magnitude > 0.1 then
                                v263.CFrame = v263.CFrame:Lerp(CFrame.new(v263.Position, v263.Position + v552.Unit), 0.4)
                            end
                        end
                        v268()
                    end)
                end
            end
            function t1.value157(p14)
                if not p14 or not t1.value32 then
                    return
                end

                local HumanoidRootPart = p14:FindFirstChild("HumanoidRootPart")

                if not HumanoidRootPart then
                    return
                end

                local v283 = t1.value103[p14]

                if not v283 then
                    return
                end

                local v284 = Vector3.new(t1.value33, t1.value34, t1.value35) * t1.value36
                local v285 = math.max(1, t1.value37)
                local v286 = t1.value151(p14) or HumanoidRootPart
                local v287 = v283.vel or Vector3.zero
                local v288 = v283.angVel or 0
                local Position = v286.Position
                local CFrame2 = v286.CFrame
                local v291 = v287:Dot(CFrame2.LookVector)
                local v292 = v287:Dot(CFrame2.RightVector)
                local _math = math
                local v294 = v288 * t1.value137 * t1.value43
                local v295 = _math.clamp(v291 * t1.value133 * t1.value42, -t1.value135, t1.value135)
                local v296 = math.clamp((v292 * t1.value134 + v294) * t1.value42, -t1.value136, t1.value136)

                task.spawn(function()
                    if t1.value40 > 0 then
                        task.wait(t1.value40)
                    end

                    for i = 1, v285 do
                        local v554 = i

                        if not v286 or not v286.Parent then
                            return
                        end

                        local v555 = (v554 - 1) / math.max(v285 - 1, 1)
                        local v556 = t1.value38 + (v554 - 1) * t1.value39 + v295
                        local v557 = Position:Lerp(v286.Position, v555 * 0.4)
                        local v558 = v557 + CFrame2.LookVector * v556 + CFrame2.RightVector * v296
                        local Part = Instance.new("Part")

                        Part.Name = "BetterDetection"
                        Part.Size = v284
                        Part.Anchored = true
                        Part.CanCollide = false
                        Part.CanTouch = true
                        Part.Transparency = 0.75
                        Part.Color = Color3.fromRGB(0, 150, 255)
                        Part.Material = Enum.Material.ForceField
                        Part.CFrame = CFrame.lookAt(v558, v557)
                        Part.Parent = t1.value3
                        t1.value5:AddItem(Part, 0.15)

                        if t1.value92 and t1.value149(Part, t1.value92.Position) then
                            t1.value153()
                            t1.value101 = tick()

                            if t1.value19 then
                                task.delay(t1.value31, t1.value154)
                            end

                            t1.value155()

                            return
                        end

                        if v554 < v285 and t1.value41 > 0 then
                            task.wait(t1.value41)
                        end
                    end
                end)
            end
            function t1.value158(p15)
                if not t1.value18 then
                    return
                end

                if not v53() then
                    return
                end

                local Character = t1.value8.Character
                local v299 = Character and Character:FindFirstChild("HumanoidRootPart")

                if not v299 or not p15 then
                    return
                end

                if not p15:FindFirstChild("HumanoidRootPart") then
                    return
                end

                task.delay(t1.value30, function()
                    if not Character:FindFirstChild("HumanoidRootPart") or not p15.Parent then
                        return
                    end

                    if not v53() then
                        return
                    end

                    local v560 = t1.value152(p15)

                    if not v560 then
                        return
                    end

                    local Magnitude = (v560 - v299.Position).Magnitude

                    if Magnitude > t1.value22 then
                        return
                    end

                    if t1.value66 and Magnitude <= t1.value72 then
                        t1.value156(p15)
                    end

                    t1.value153()
                    t1.value101 = tick()

                    if t1.value19 then
                        task.delay(t1.value31, t1.value154)
                    end

                    t1.value155()
                end)
            end
            function t1.value159(p16, p17)
                if not t1.value18 then
                    return
                end

                if not p16 or not p16:IsA("Sound") then
                    return
                end

                local v310 = p17 or t1.value146(p16)

                if not v310 or not t1.value88[v310] then
                    return
                end

                if not v53() then
                    return
                end

                if t1.value100[p16] and tick() < t1.value100[p16] then
                    return
                end

                local Character = t1.value8.Character
                local v312 = Character and Character:FindFirstChild("HumanoidRootPart")

                if not v312 then
                    return
                end

                local _, v314 = t1.value147(p16)

                if not v314 then
                    return
                end

                local v315 = t1.value148(v314)

                if not v315 then
                    return
                end

                t1.value87[v315] = tick()
                task.delay(0.35, function()
                    if t1.value87[v315] and tick() - t1.value87[v315] >= 0.35 then

                        t1.value87[v315] = nil
                    end
                end)

                local HumanoidRootPart = v315:FindFirstChild("HumanoidRootPart")

                if not HumanoidRootPart then
                    return
                end

                local v317 = (t1.value152(v315) or HumanoidRootPart.Position - v312.Position).Magnitude ^ 2
                local v318 = t1.value22 + 0.2 * t1.value22

                if v317 > v318 * v318 then
                    return
                end

                if t1.value20 then
                    local ok, result = pcall(function()
                        local Unit = (v312.Position - HumanoidRootPart.Position).Unit
                        local v564 = HumanoidRootPart.CFrame.LookVector:Dot(Unit)
                        local v565 = math.cos((math.rad(t1.value25 / 2)))

                        return v317 < 25 or v565 <= v564
                    end)
                    local v321 = not ok

                    if not v321 then
                        v321 = not result
                    end

                    if v321 then
                        return
                    end
                end

                if t1.value32 then
                    t1.value101 = tick()
                    t1.value157(v315)
                else
                    t1.value158(v315)
                end

                t1.value100[p16] = tick() + t1.value102
            end

            t1.value160 = nil

            function t1.value160(p18)
                if not p18 or (not p18:IsA("Sound") or t1.value99[p18]) then
                    return
                end
                local v329 = t1.value146(p18)
                if not v329 then
                    return
                end
                local connection = p18.Played:Connect(function()
                    if t1.value18 then
                        task.spawn(t1.value159, p18, v329)
                    end
                end)
                local connection2 = p18:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                    if p18.IsPlaying and t1.value18 then
                        task.spawn(t1.value159, p18, v329)
                    end
                end)
                local connection3
                connection3 = p18.Destroying:Connect(function()
                    pcall(function()
                        connection:Disconnect()
                        connection2:Disconnect()
                        connection3:Disconnect()
                    end)
                    t1.value99[p18] = nil
                    t1.value100[p18] = nil
                end)
                t1.value99[p18] = {
					connection,
					connection2,
					connection3,
					id = v329
				}
                if p18.IsPlaying then
                    task.spawn(t1.value159, p18, v329)
                end
            end
            function t1.value161()
                local v333 = t1.value3:FindFirstChild("Players") and t1.value3.Players:FindFirstChild("Killers")

                if v333 then
                    for _, child in pairs(v333:GetChildren()) do
                        for _, descendant in pairs(child:GetDescendants()) do
                            if descendant:IsA("Sound") then
                                pcall(t1.value160, descendant)
                            end
                        end
                    end
                end
            end
            function t1.value162()
                if not t1.value73 or not t1.value92 then
                    if t1.value105 then
                        t1.value105:Destroy()
                        t1.value105 = nil
                    end

                    return
                end

                if not t1.value105 then
                    t1.value105 = Instance.new("Part")
                    t1.value105.Anchored = true
                    t1.value105.CanCollide = false
                    t1.value105.Shape = Enum.PartType.Ball
                    t1.value105.Transparency = 0.5
                    t1.value105.Color = Color3.fromRGB(255, 255, 0)
                    t1.value105.Material = Enum.Material.ForceField
                    t1.value105.Parent = t1.value3
                end

                local value72 = t1.value72

                t1.value105.Size = Vector3.new(value72 * 2, value72 * 2, value72 * 2)
                t1.value105.CFrame = CFrame.new(t1.value92.Position)
            end
            function t1.value163()
                if not t1.value53 then
                    if t1.value106 then
                        t1.value106.Parent.Parent:Destroy()
                        t1.value106 = nil
                    end

                    return
                end

                if not t1.value106 then
                    local ScreenGui = Instance.new("ScreenGui")

                    ScreenGui.Name = "PingChecker"
                    ScreenGui.Parent = t1.value9
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    ScreenGui.DisplayOrder = 9998

                    local Frame = Instance.new("Frame")

                    Frame.Size = UDim2.new(0, 150, 0, 40)
                    Frame.Position = UDim2.new(0, 10, 1, -50)
                    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    Frame.BackgroundTransparency = 0.5
                    Frame.BorderSizePixel = 0
                    Frame.Parent = ScreenGui
                    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                    local TextLabel = Instance.new("TextLabel")

                    TextLabel.Size = UDim2.new(1, -10, 1, -10)
                    TextLabel.Position = UDim2.new(0, 5, 0, 5)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.Text = "Ping: 0ms"
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 18
                    TextLabel.Parent = Frame
                    t1.value106 = TextLabel
                end

                local Value = t1.value4.Network.ServerStatsItem["Data Ping"]:GetValue()

                t1.value106.Text = "Ping: " .. math.floor(Value) .. "ms"
            end
            function t1.value164()
                if not t1.value55 then
                    if t1.value107 then
                        t1.value107:Destroy()
                        t1.value107 = nil
                    end

                    return
                end

                if not t1.value107 then
                    local ScreenGui = Instance.new("ScreenGui")

                    ScreenGui.Name = "HDTCooldownChecker"
                    ScreenGui.Parent = t1.value9
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    ScreenGui.DisplayOrder = 9998

                    local Frame = Instance.new("Frame")

                    Frame.Size = UDim2.new(0, 150, 0, 40)
                    Frame.Position = UDim2.new(0, 10, 0, 100)
                    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    Frame.BackgroundTransparency = 0.5
                    Frame.BorderSizePixel = 0
                    Frame.Parent = ScreenGui
                    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                    local TextLabel = Instance.new("TextLabel")

                    TextLabel.Size = UDim2.new(1, -10, 1, -10)
                    TextLabel.Position = UDim2.new(0, 5, 0, 5)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.Text = "Block CD: ?"
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 18
                    TextLabel.Parent = Frame
                    t1.value107 = ScreenGui
                    t1.value108 = TextLabel
                end

                local MainUI = t1.value9:FindFirstChild("MainUI")

                if MainUI then
                    local AbilityContainer = MainUI:FindFirstChild("AbilityContainer")

                    if AbilityContainer then
                        local Block = AbilityContainer:FindFirstChild("Block")

                        if Block then
                            local CooldownTime = Block:FindFirstChild("CooldownTime")

                            if CooldownTime and CooldownTime:IsA("TextLabel") then
                                t1.value108.Text = "Block CD: " .. CooldownTime.Text

                                return
                            end
                        end
                    end
                end

                t1.value108.Text = "Block CD: ?"
            end
            function t1.value165()
                if not t1.value58 then
                    if t1.value109 then
                        t1.value109:Destroy()
                        t1.value109 = nil
                        t1.value110 = nil
                    end

                    return
                end

                if not t1.value109 then
                    local ScreenGui = Instance.new("ScreenGui")

                    ScreenGui.Name = "FpsCounter"
                    ScreenGui.Parent = t1.value9
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    ScreenGui.DisplayOrder = 9999

                    local Frame = Instance.new("Frame")

                    Frame.Size = UDim2.new(0, 100, 0, 30)
                    Frame.Position = UDim2.new(0, 10, 0, 150)
                    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    Frame.BackgroundTransparency = 0.5
                    Frame.BorderSizePixel = 0
                    Frame.Parent = ScreenGui
                    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

                    local TextLabel = Instance.new("TextLabel")

                    TextLabel.Size = UDim2.new(1, -10, 1, -10)
                    TextLabel.Position = UDim2.new(0, 5, 0, 5)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.Text = "FPS: 0"
                    TextLabel.Font = Enum.Font.GothamBold
                    TextLabel.TextSize = 16
                    TextLabel.Parent = Frame
                    t1.value109 = ScreenGui
                    t1.value110 = TextLabel
                    t1.value139 = tick()
                    t1.value140 = 0
                    t1.value141 = 0
                end

                t1.value140 = t1.value140 + 1

                if tick() - t1.value139 >= 1 then
                    t1.value141 = t1.value140
                    t1.value110.Text = "FPS: " .. t1.value141
                end
            end
            function t1.value166()
                local Part = Instance.new("Part")

                Part.Size = Vector3.new(1, 1, 1)
                Part.Shape = Enum.PartType.Ball
                Part.Anchored = true
                Part.CanCollide = false
                Part.Transparency = 0.5
                Part.Color = Color3.fromRGB(255, 0, 0)
                Part.Parent = t1.value3

                return Part
            end
            function t1.value167()
                local Part = Instance.new("Part")

                Part.Size = Vector3.new(0.1, 0.1, 1)
                Part.Anchored = true
                Part.CanCollide = false
                Part.Transparency = 0.3
                Part.Color = Color3.fromRGB(255, 0, 0)
                Part.Parent = t1.value3

                return Part
            end
            function t1.value168()
                if t1.value111 then
                    t1.value111:Destroy()
                    t1.value111 = nil
                end

                if t1.value112 then
                    t1.value112:Destroy()
                    t1.value112 = nil
                end

                if t1.value113 then
                    t1.value113:Destroy()
                    t1.value113 = nil
                end

                if t1.value114 then
                    t1.value114:Destroy()
                    t1.value114 = nil
                end

                if t1.value115 then
                    t1.value115:Destroy()
                    t1.value115 = nil
                end

                if t1.value116 then
                    t1.value116:Destroy()
                    t1.value116 = nil
                end

                if t1.value117 then
                    t1.value117:Destroy()
                    t1.value117 = nil
                end
            end
            function t1.value169()
                if not t1.value21 and not t1.value48 then
                    if t1.value111 then
                        t1.value168()
                    end

                    return
                end
                local Character = t1.value8.Character
                local v343 = Character and Character:FindFirstChild("HumanoidRootPart")
                if not v343 then
                    t1.value168()

                    return
                end
                local value44 = t1.value44
                local v345
                if not value44 then
                    value44 = t1.value45
                end
                if value44 then
                    v345 = v343
                else
                    local v346 = t1.value3:FindFirstChild("Players") and t1.value3.Players:FindFirstChild("Killers")

                    if not v346 then
                        t1.value168()

                        return
                    end

                    for _, v in ipairs(t1.value90) do
                        local v2 = v346:FindFirstChild(v)

                        if v2 and v2:FindFirstChild("HumanoidRootPart") then
                            v345 = v2.HumanoidRootPart

                            break
                        end
                    end

                    if not v345 then
                        t1.value168()

                        return
                    end
                end
                local v350 = t1.value48 and t1.value46 or t1.value24
                local v351 = t1.value48 and t1.value47 or t1.value25
                local LookVector = v345.CFrame.LookVector
                local v353 = math.rad(v351 / 2)
                local Unit = Vector3.new(-LookVector.Z, 0, LookVector.X).Unit
                local Unit2 = (LookVector * math.cos(v353) + Unit * math.sin(v353)).Unit
                local Unit3 = (LookVector * math.cos(v353) - Unit * math.sin(v353)).Unit
                local v357 = v345.Position + LookVector * v350
                local v358 = v345.Position + Unit2 * v350
                local v359 = v345.Position + Unit3 * v350
                if not t1.value111 then
                    t1.value111 = t1.value166()
                end
                if not t1.value112 then
                    t1.value112 = t1.value166()
                end
                if not t1.value113 then
                    t1.value113 = t1.value166()
                end
                if not t1.value114 then
                    t1.value114 = t1.value167()
                end
                if not t1.value115 then
                    t1.value115 = t1.value167()
                end
                if not t1.value116 then
                    t1.value116 = t1.value167()
                end
                if not t1.value117 then
                    t1.value117 = t1.value167()
                end
                t1.value111.Position = v357
                t1.value112.Position = v358
                t1.value113.Position = v359
                local function v360(p19, p20, p21)
                    local v577 = p21 - p20
                    local v578 = (p20 + p21) / 2
                    local Magnitude = v577.Magnitude

                    p19.Size = Vector3.new(0.1, 0.1, Magnitude)
                    p19.CFrame = CFrame.new(v578, p21)
                end
                v360(t1.value114, v345.Position, v358)
                v360(t1.value115, v345.Position, v359)
                v360(t1.value116, v358, v357)
                v360(t1.value117, v357, v359)
            end
            function t1.value170(p22)
                local Humanoid = p22:FindFirstChild("Humanoid")
                local FindFirstChild = p22.FindFirstChild

                t1.value91 = Humanoid
                t1.value92 = FindFirstChild(p22, "HumanoidRootPart")

                if t1.value98 then
                    t1.value98:Disconnect()
                end

                local v194 = t1.value91 and t1.value91:FindFirstChildOfClass("Animator")

                if v194 and t1.value26 then
                    v194.AnimationPlayed:Connect(function(animation)
                        local v522 = animation.Animation.AnimationId:match("%d+")

                        if t1.value26 and t1.value89[v522] then
                            t1.value94 = tick()
                            t1.value93 = true
                        end
                    end)
                end
            end
            function t1.value171()
                if not t1.value8.Character then
                    return
                end

                if t1.value125 then
                    t1.value125:Disconnect()
                end

                t1.value125 = t1.value1.Stepped:Connect(function()
                    if not t1.value56 then
                        t1.value125:Disconnect()
                        t1.value125 = nil

                        return
                    end

                    if t1.value57 and not v53() then
                        return
                    end

                    if not t1.value8.Character then
                        return
                    end

                    for _, descendant in ipairs(t1.value8.Character:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            descendant.CanCollide = false
                        end
                    end
                end)
            end
            function t1.value172()
                if t1.value125 then
                    t1.value125:Disconnect()
                    t1.value125 = nil
                end

                local Character = t1.value8.Character

                if Character then
                    for _, descendant in ipairs(Character:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            descendant.CanCollide = true
                        end
                    end
                end
            end
            function t1.value173()
                if t1.value126 then
                    return
                end

                pcall(function()
                    local Network = require(t1.value2.Modules.Network)

                    t1.value127 = Network.FireConnection

                    function Network.FireConnection(p23, p24, ...)
                        local value60 = t1.value60

                        if value60 then
                            value60 = p24 == "DisableSprinting"
                        end

                        if value60 then
                            return
                        end

                        return t1.value127(p23, p24, ...)
                    end
                end)
            end
            function t1.value174()
                if not t1.value126 then
                    return
                end

                pcall(function()
                    local Network = require(t1.value2.Modules.Network)

                    if t1.value127 then
                        Network.FireConnection = t1.value127
                    end
                end)
                t1.value126 = false
                t1.value127 = nil
            end
            function t1.value175(p25)
                if not p25 or not p25:IsA("NumberValue") then
                    return
                end
                if p25.Value > 1.01 then
                    return
                end
                pcall(function()
                    p25.Value = 1
                    t1.value6:Create(p25, TweenInfo.new(0), {
						Value = 1
					}):Play()
                end)
                local connection
                connection = p25:GetPropertyChangedSignal("Value"):Connect(function()
                    if not t1.value60 then
                        pcall(function()
                            connection:Disconnect()
                        end)

                        return
                    end

                    if p25.Value < 1 then
                        pcall(function()
                            p25.Value = 1
                        end)
                    end
                end)
                table.insert(t1.value128, connection)
            end
            function t1.value176()
                pcall(function()
                    t1.value1:UnbindFromRenderStep("PunchMobility")
                end)
                pcall(function()
                    t1.value1:UnbindFromRenderStep("LungeBoost")
                end)
                t1.value123 = false

                for _, v in pairs(t1.value128) do
                    pcall(function()
                        v:Disconnect()
                    end)
                end

                t1.value128 = {}

                if t1.value132 then
                    t1.value132:Disconnect()
                end

                if t1.value124 then
                    task.cancel(t1.value124)
                    t1.value124 = nil
                end
            end

            t1.value177 = nil

            function t1.value177()
                if not t1.value62 then
                    return
                end

                if t1.value123 then
                    return
                end

                local v322 = t1.value143()

                if not v322 then
                    return
                end

                local LookVector = v322.CFrame.LookVector
                local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)

                if vector3.Magnitude == 0 then
                    return
                end

                local Unit = vector3.Unit

                t1.value123 = true

                local v326 = t1.value119 * t1.value63
                local n3 = 0

                pcall(function()
                    t1.value1:UnbindFromRenderStep("LungeBoost")
                end)
                t1.value1:BindToRenderStep("LungeBoost", Enum.RenderPriority.Character.Value + 20, function(p26)
                    n3 += p26

                    local v567 = t1.value143()

                    if not v567 or n3 >= 0.3 then
                        pcall(function()
                            t1.value1:UnbindFromRenderStep("LungeBoost")
                        end)
                        t1.value123 = false

                        return
                    end

                    local v568 = 1 - n3 / 0.3
                    local AssemblyLinearVelocityY = v567.AssemblyLinearVelocity.Y

                    v567.AssemblyLinearVelocity = Unit * (v326 * v568) + Vector3.new(0, AssemblyLinearVelocityY, 0)
                end)
            end
            function t1.value178()
                t1.value176()

                local Character = t1.value8.Character

                if not Character then
                    return
                end

                for _, descendant in ipairs(Character:GetDescendants()) do
                    if descendant:IsA("NumberValue") then
                        t1.value175(descendant)
                    end
                end

                Character.DescendantAdded:Connect(function(descendant)
                    if not t1.value60 then
                        return
                    end

                    if descendant:IsA("NumberValue") then
                        task.defer(function()
                            if descendant.Name == "PunchAbility" and t1.value62 then
                                if t1.value124 then
                                    task.cancel(t1.value124)
                                end

                                local v601 = t1.value145() and t1.value121 or t1.value120

                                t1.value124 = task.delay(v601, function()
                                    t1.value124 = nil
                                    t1.value177()
                                end)
                            end

                            t1.value175(descendant)
                        end)
                    end
                end)
                t1.value1:BindToRenderStep("PunchMobility", Enum.RenderPriority.Character.Value + 10, function()
                    if t1.value123 then
                        return
                    end

                    local v582 = t1.value144()

                    if not v582 then
                        return
                    end

                    if v582.WalkSpeed < t1.value118 then
                        v582.WalkSpeed = t1.value118
                    end
                end)
            end
            function t1.value179(p27)
                if not p27 or not p27:IsA("NumberValue") then
                    return
                end
                if p27.Value <= 1.01 then
                    return
                end
                pcall(function()
                    p27.Value = 1
                    t1.value6:Create(p27, TweenInfo.new(0), {
						Value = 1
					}):Play()
                end)
                local connection
                connection = p27:GetPropertyChangedSignal("Value"):Connect(function()
                    if not t1.value122 or not t1.value64 then
                        pcall(function()
                            connection:Disconnect()
                        end)

                        return
                    end

                    if p27.Value > 1 then
                        pcall(function()
                            p27.Value = 1
                        end)
                    end
                end)
                table.insert(t1.value129, connection)
            end

            t1.value180 = nil

            function t1.value180()
                pcall(function()
                    t1.value1:UnbindFromRenderStep("ChargeCap")
                end)

                if t1.value130 then
                    t1.value130:Disconnect()
                end

                for _, v in pairs(t1.value129) do
                    local v370 = v

                    pcall(function()
                        v370:Disconnect()
                    end)
                end
            end
            function t1.value181()
                t1.value180()

                local Character = t1.value8.Character

                if not Character then
                    return
                end

                for _, descendant in ipairs(Character:GetDescendants()) do
                    t1.value179(descendant)
                end

                Character.DescendantAdded:Connect(function(descendant)
                    if not t1.value122 or not t1.value64 then
                        return
                    end

                    if descendant:IsA("NumberValue") then
                        task.defer(function()
                            t1.value179(descendant)
                        end)
                    end
                end)
                t1.value1:BindToRenderStep("ChargeCap", Enum.RenderPriority.Character.Value + 20, function()
                    if not t1.value122 or not t1.value64 then
                        pcall(function()
                            t1.value1:UnbindFromRenderStep("ChargeCap")
                        end)

                        return
                    end

                    local v584 = t1.value144()

                    if v584 and v584.WalkSpeed > t1.value118 then
                        v584.WalkSpeed = t1.value118
                    end
                end)
            end
            function t1.value182()
                t1.value122 = false
                pcall(function()
                    t1.value1:UnbindFromRenderStep("ChargeLock")
                end)
                pcall(function()
                    t1.value1:UnbindFromRenderStep("ChargeSpeedLimit")
                end)
                t1.value180()
            end

            t1.value183 = nil

            function t1.value183()
                pcall(function()
                    t1.value1:UnbindFromRenderStep("ChargeLock")
                end)
                pcall(function()
                    t1.value1:UnbindFromRenderStep("ChargeSpeedLimit")
                end)
                t1.value122 = true
                t1.value1:BindToRenderStep("ChargeLock", Enum.RenderPriority.Character.Value + 2, function()
                    local v585 = t1.value144()

                    if not v585 then
                        return
                    end

                    local LookVector = t1.value3.CurrentCamera.CFrame.LookVector
                    local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)

                    if vector3.Magnitude > 0 then
                        v585:Move(vector3.Unit)
                    end
                end)
                t1.value1:BindToRenderStep("ChargeSpeedLimit", Enum.RenderPriority.Character.Value + 20, function()
                    if not t1.value122 then
                        pcall(function()
                            t1.value1:UnbindFromRenderStep("ChargeSpeedLimit")
                        end)

                        return
                    end

                    local v588 = t1.value144()

                    if v588 and v588.WalkSpeed ~= t1.value65 then
                        v588.WalkSpeed = t1.value65
                    end
                end)

                if t1.value64 then
                    t1.value181()
                end
            end
            function t1.value184(p28)
                if t1.value131 then
                    t1.value131:Disconnect()
                end

                t1.value182()
                t1.value176()
                p28:GetAttributeChangedSignal("GuestCharging"):Connect(function()
                    if not t1.value61 then
                        return
                    end

                    if p28:GetAttribute("GuestCharging") then
                        t1.value183()

                        return
                    end

                    t1.value182()
                end)
            end

            t1.value1.RenderStepped:Connect(function(dt)
                for k in pairs(t1.value103) do
                    local v377 = k

                    if not v377.Parent then
                        t1.value103[v377] = nil
                    end
                end

                local v378 = t1.value3:FindFirstChild("Players") and t1.value3.Players:FindFirstChild("Killers")

                if not v378 then
                    return
                end

                local GetChildren = v378.GetChildren

                for _, v in ipairs(GetChildren(v378)) do
                    local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart then
                        local v383 = t1.value103[v]

                        if not v383 then
                            local HumanoidRootPartPosition = HumanoidRootPart.Position
                            local LookVector = HumanoidRootPart.CFrame.LookVector
                            local vector3 = Vector3.new()

                            v383 = {
								prevPos = HumanoidRootPartPosition,
								prevLook = LookVector,
								vel = vector3,
								angVel = 0
							}
                        end

                        local v387 = (HumanoidRootPart.Position - v383.prevPos) / math.max(dt, 1E-06)

                        v383.vel = v383.vel:Lerp(v387, t1.value138)

                        local LookVector = HumanoidRootPart.CFrame.LookVector
                        local v389 = math.acos((math.clamp(v383.prevLook:Dot(LookVector), -1, 1)))
                        local v390 = not (v383.prevLook:Cross(LookVector).Y >= 0) and -1 or 1
                        local v391 = v389 / math.max(dt, 1E-06) * v390

                        v383.angVel = v383.angVel * (1 - t1.value138) + v391 * t1.value138
                        v383.prevPos = HumanoidRootPart.Position
                        v383.prevLook = LookVector
                        t1.value103[v] = v383
                    end
                end
            end)
            t1.value1.RenderStepped:Connect(function()
                if t1.value26 and (t1.value91 and (t1.value92 and t1.value93)) then
                    if tick() - t1.value94 > t1.value28 then
                        if t1.value95 then
                            t1.value91.WalkSpeed = t1.value95
                            t1.value91.JumpPower = t1.value96
                            t1.value91.AutoRotate = t1.value97
                            t1.value95 = nil
                        end
                    else
                        if not t1.value95 then
                            local _ = t1.value91.WalkSpeed
                            local _ = t1.value91.JumpPower
                            local _ = t1.value91.AutoRotate
                        end

                        t1.value91.AutoRotate = false
                        t1.value92.AssemblyAngularVelocity = Vector3.zero

                        local v396 = t1.value3:FindFirstChild("Players") and t1.value3.Players:FindFirstChild("Killers")

                        if v396 and t1.value92 then
                            local n4 = 1e999
                            local v398
                            for v401, v402 in ipairs(v396:GetChildren()) do

                                local HumanoidRootPart = v402:FindFirstChild("HumanoidRootPart")

                                if HumanoidRootPart then
                                    local Magnitude = (HumanoidRootPart.Position - t1.value92.Position).Magnitude

                                    if Magnitude < n4 then
                                        n4 = Magnitude
                                        v398 = HumanoidRootPart
                                    end
                                end
                            end
                            if v398 then
                                local value27 = t1.value27
                                local AssemblyLinearVelocity = v398.AssemblyLinearVelocity
                                local v407 = (AssemblyLinearVelocity.Magnitude > 0.5 and v398.Position + AssemblyLinearVelocity * (value27 / 60) or v398.Position - t1.value92.Position) * Vector3.new(1, 0, 1)

                                if v407.Magnitude > 0.01 then
                                    t1.value92.CFrame = CFrame.new(t1.value92.Position, t1.value92.Position + v407.Unit)
                                end
                            end
                        end
                    end
                end

                t1.value162()
                pcall(t1.value169)
                pcall(t1.value163)
                pcall(t1.value164)
                pcall(t1.value165)
            end)

            function t1.value185(p29, p30, p31, p32, p33)
                local v413 = p33 - p29
                local v414 = v413:Dot(p30)

                if v414 < 0 or p31 < v414 then
                    return false
                end

                return p32 >= (v413 - p30 * v414).Magnitude
            end
            function t1.value186(p34)
                if t1.value85[p34] then
                    return
                end

                local Humanoid = p34:FindFirstChildOfClass("Humanoid")

                if not Humanoid then
                    return
                end

                local Animator = Humanoid:FindFirstChildOfClass("Animator")

                if not Animator then
                    return
                end

                t1.value85[p34] = Animator.AnimationPlayed:Connect(function(animation)
                    local v590 = animation.Animation.AnimationId:match("%d+")

                    if v590 and t1.value89[v590] then
                        t1.value84[p34] = true
                        task.delay(0.6, function()
                            t1.value84[p34] = nil
                        end)
                    end
                end)
            end
            function t1.value187(p35)
                if t1.value82[p35] then
                    pcall(function()
                        t1.value82[p35]:Destroy()
                    end)
                    t1.value82[p35] = nil
                end

                t1.value83[p35] = nil
                t1.value84[p35] = nil
                t1.value87[p35] = nil

                if t1.value85[p35] then
                    pcall(function()
                        t1.value85[p35]:Disconnect()
                    end)
                    t1.value85[p35] = nil
                end
            end
            function t1.value188()
                local Character = t1.value8.Character
                local v419 = Character and Character:FindFirstChild("HumanoidRootPart")
                local timestamp = tick()
                for v423 in pairs(t1.value82) do

                    if not v423.Parent then
                        t1.value187(v423)
                    end
                end
                if not t1.value76 then

                    for v426 in pairs(t1.value82) do

                        t1.value187(v426)
                    end
                    for k in pairs(t1.value85) do
                        t1.value187(k)
                    end

                    return
                end
                if not v419 then
                    return
                end
                local v428 = t1.value3:FindFirstChild("Players") and t1.value3.Players:FindFirstChild("Killers")
                if not v428 then
                    return
                end
                for _, child in ipairs(v428:GetChildren()) do
                    local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")

                    if not HumanoidRootPart then
                        t1.value187(child)
                    else
                        t1.value186(child)

                        local v432 = t1.value82[child]

                        if not v432 or not v432.Parent then
                            v432 = Instance.new("Part")
                            v432.Anchored = true
                            v432.CanCollide = false
                            v432.Material = Enum.Material.Neon
                            v432.Transparency = 0.45
                            v432.Parent = t1.value3
                            t1.value82[child] = v432
                        end

                        local v433 = t1.value151(child) or HumanoidRootPart
                        local LookVector = v433.CFrame.LookVector
                        local v435 = t1.value77 / 2
                        local v436 = v433.Position + LookVector * v435
                        local v437 = t1.value78 * 2

                        v432.Size = Vector3.new(v437, v437, t1.value77)
                        v432.CFrame = CFrame.new(v436, v436 + LookVector)

                        local v438 = t1.value185(v433.Position, LookVector, t1.value77, t1.value78, v419.Position)
                        local v439 = v419.Position - v433.Position
                        local v440 = v439.Magnitude > 0.1

                        if v440 then
                            v440 = LookVector:Dot(v439.Unit)
                        end

                        if (v440 or 0) >= t1.value81 then
                            if not t1.value83[child] then
                                t1.value83[child] = timestamp
                            end
                        else
                            t1.value83[child] = nil
                        end

                        local v441 = t1.value83[child] and timestamp - t1.value83[child] or 0
                        local v442 = t1.value87[child] and timestamp - t1.value87[child] <= 0.35

                        if v438 then
                            v432.Color = Color3.fromRGB(255, 40, 40)
                        elseif t1.value84[child] or v442 then
                            v432.Color = Color3.fromRGB(255, 215, 0)
                        else
                            v432.Color = Color3.fromRGB(235, 235, 255)
                        end

                        if v438 then
                            v438 = t1.value84[child] or v442

                            if v438 then
                                v438 = false

                                if v441 >= t1.value80 then
                                    v438 = timestamp - t1.value86 >= t1.value29 and (timestamp - t1.value101 >= t1.value29 and v53())
                                end
                            end
                        end

                        if v438 then
                            t1.value86 = timestamp
                            t1.value101 = timestamp
                            task.delay(t1.value79, function()
                                local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")
                                local HumanoidRootPart3 = child:FindFirstChild("HumanoidRootPart")

                                if not HumanoidRootPart2 or not HumanoidRootPart3 then
                                    return
                                end

                                local v593 = t1.value151(child) or HumanoidRootPart3

                                if t1.value185(v593.Position, v593.CFrame.LookVector, t1.value77, t1.value78, HumanoidRootPart2.Position) then
                                    t1.value153()

                                    if t1.value19 then
                                        task.delay(t1.value31, t1.value154)
                                    end

                                    t1.value155()
                                end
                            end)
                        end
                    end
                end
            end

            t1.value1.RenderStepped:Connect(function()
                pcall(t1.value188)
            end);
            (function()
                task.spawn(function()
                    local v570 = t1.value3:FindFirstChild("Players") or t1.value3:WaitForChild("Players", 30)

                    if not v570 then
                        return
                    end

                    local v571 = v570:FindFirstChild("Killers") or v570:WaitForChild("Killers", 30)

                    if not v571 then
                        return
                    end

                    t1.value161()
                    v571.DescendantAdded:Connect(function(descendant)
                        if descendant:IsA("Sound") then
                            pcall(t1.value160, descendant)
                        end
                    end)
                    v571.ChildAdded:Connect(function(child)
                        task.wait(0.1)

                        for _, descendant in pairs(child:GetDescendants()) do
                            if descendant:IsA("Sound") then
                                pcall(t1.value160, descendant)
                            end
                        end
                    end)
                end)
            end)()
            t1.value8.CharacterAdded:Connect(function(character)
                task.delay(0.5, function()
                    t1.value168()
                    t1.value170(character)
                    t1.value184(character)

                    if t1.value56 then
                        t1.value171()
                    end

                    if t1.value60 then
                        t1.value178()
                    end
                end)
            end)

            if t1.value8.Character then
                t1.value170(t1.value8.Character)
                t1.value184(t1.value8.Character)
            end

            if t1.value56 then
                t1.value171()
            end

            if t1.value60 then
                t1.value173()
                t1.value178()
            end

            v54 = t1.value17:CreateTab({
				Text = "哨兵",
				Icon = "shield"
			})
            v55 = v54:CreateSection({
				Text = "核心格挡",
				Opened = true
			})
            local value18 = t1.value18
            v55:AddToggle({
				Text = "自动格挡",
								Default = value18,
				Callback = function(p36)
                t1.value18 = p36
                t1.value11.set("guestAutoBlockAudioOn", p36)
            end
			})

            

            v55:AddSlider({
				Text = "格挡延迟",
				Increment = 0.05,
				Min = 0, Max = 2, Default = t1.value30
				Callback = function(p37)
                t1.value30 = p37
                t1.value11.set("guestBlockDelay", p37)
            end
			})
        end

        

        v55:AddSlider({
			Text = "自动格挡半径",
			Increment = 1,
			Min = 1, Max = 50, Default = t1.value22
			Callback = function(p38)
            t1.value22 = p38
            t1.value23 = p38 * p38
            t1.value11.set("guestDetectionRange", p38)
        end
		})
        local value20 = t1.value20
            v55:AddToggle({
			Text = "验证朝向检测",
						Default = value20,
			Callback = function(p39)
            t1.value20 = p39
            t1.value11.set("guestVerifyFacingCheckOn", p39)
        end
		})

        

        v55:AddSlider({
			Text = "视野范围",
			Increment = 0.5,
			Min = 1, Max = 20, Default = t1.value24
			Callback = function(p40)
            t1.value24 = p40
            t1.value11.set("guestVisionRange", p40)
        end
		})
        
            v55:AddSlider({
			Text = "视野角度",
			Increment = 1,
			Min = 1, Max = 200, Default = t1.value25
			Callback = function(p41)
            t1.value25 = p41
            t1.value11.set("guestVisionAngle", p41)
        end
		})

        local value21 = t1.value21

        v55:AddToggle({
			Text = "显示视野锥",
						Default = value21,
			Callback = function(p42)
            t1.value21 = p42
            t1.value11.set("guestShowVisionRange", p42)

            if not p42 then
                t1.value168()
            end
        end
		})
        local value54 = t1.value54
            v55:AddToggle({
			Text = "无HDT冷却",
						Default = value54,
			Callback = function(p43)
            t1.value54 = p43
            t1.value11.set("noHDTCooldown", p43)
        end
		})

        local value55 = t1.value55

        v55:AddToggle({
			Text = "格挡冷却检测器",
						Default = value55,
			Callback = function(p44)
            t1.value55 = p44
            t1.value11.set("hdtCooldownChecker", p44)

            if not p44 and t1.value107 then
                t1.value107:Destroy()
            end
        end
		})
        
            v55:AddSlider({
			Text = "格挡冷却时间 (秒)",
			Increment = 0.05,
			Min = 0.05, Max = 2, Default = t1.value29
			Callback = function(p45)
            t1.value29 = p45
            t1.value11.set("guestBlockCooldown", p45)
        end
		})
        
            v55:AddSlider({
			Text = "自动出拳延迟 (秒)",
			Increment = 0.05,
			Min = 0, Max = 2, Default = t1.value31
			Callback = function(p46)
            t1.value31 = p46
            t1.value11.set("guestAutoPunchDelay", p46)
        end
		})

        local v73 = v54:CreateSection({
			Text = "碰撞箱拖拽 (HDT)",
			Opened = false
		})
        local value66 = t1.value66
            v73:AddToggle({
			Text = "启用HDT",
						Default = value66,
			Callback = function(p47)
            t1.value66 = p47
            t1.value11.set("guestHitboxDraggingOn", p47)
        end
		})
        local value67 = t1.value67
            v73:AddDropdown({
			Text = "HDT模式",
			Items = {
				"Blatant",
				"Legit",
				"Hitbox",
				"Smart"
			},
			Default = value67,
			Callback = function(p48)
            t1.value67 = p48
            t1.value11.set("guestHitboxMode", p48)
        end
		})
        v73:AddParagraph({
			Text = "智能模式",
			Content = "根据切换距离在合法(近)和明显(远)之间自动切换。"
		})

        

        v73:AddSlider({
			Text = "切换距离 (智能)",
			Increment = 1,
			Min = 2, Max = 20, Default = t1.value75
			Callback = function(p49)
            t1.value75 = p49
            t1.value11.set("hdtSwitchDist", p49)
        end
		})
        local v80 = t1.value11.get("hdtBlatantSpeed", 150)
        
            v73:AddSlider({
			Text = "明显速度",
			Increment = 1,
			Min = 1, Max = 125, Default = v80
			Callback = function(p50)
            t1.value11.set("hdtBlatantSpeed", p50)
        end
		})

        local get = t1.value11.get
        local v84 = get("hdtLegitSpeed", 140)
        
            v73:AddSlider({
			Text = "合法速度",
			Increment = 1,
			Min = 10, Max = 100, Default = v84
			Callback = function(p51)
            t1.value11.set("hdtLegitSpeed", p51)
        end
		})

        

        v73:AddSlider({
			Text = "预测时间 (秒)",
			Increment = 0.01,
			Min = 0, Max = 0.5, Default = t1.value74
			Callback = function(p52)
            t1.value74 = p52
            t1.value11.set("hdtPredictTime", p52)
        end
		})
        local value68 = t1.value68
            v73:AddToggle({
			Text = "HDT时面向杀手",
						Default = value68,
			Callback = function(p53)
            t1.value68 = p53
            t1.value11.set("guestHitboxFaceKiller", p53)
        end
		})

        local value69 = t1.value69

        v73:AddToggle({
			Text = "HDT视觉效果 (光束)",
						Default = value69,
			Callback = function(p54)
            t1.value69 = p54
            t1.value11.set("guestHitboxVisual", p54)
        end
		})

        

        v73:AddSlider({
			Text = "拖拽持续时间",
			Increment = 0.05,
			Min = 0.05, Max = 2, Default = t1.value71
			Callback = function(p55)
            t1.value71 = p55
            t1.value11.set("guestHitboxDragDuration", p55)
        end
		})
        
            v73:AddSlider({
			Text = "触发半径",
			Increment = 1,
			Min = 0, Max = 30, Default = t1.value72
			Callback = function(p56)
            t1.value72 = p56
            t1.value11.set("guestHitboxTriggerRadius", p56)
        end
		})
        local value70 = t1.value70
            v73:AddDropdown({
			Text = "目标模式",
			Items = {
				"Root",
				"Arms",
				"Random"
			},
			Default = value70,
			Callback = function(p57)
            t1.value70 = p57
            t1.value11.set("guestHitboxTargetMode", p57)
        end
		})

        local value73 = t1.value73

        v73:AddToggle({
			Text = "显示HDT范围",
						Default = value73,
			Callback = function(p58)
            t1.value73 = p58
            t1.value11.set("guestShowHDTRange", p58)
        end
		})
    end

    local v96 = v54:CreateSection({
		Text = "更好检测",
		Opened = false
	})
    local value32 = t1.value32
            v96:AddToggle({
		Text = "启用更好检测",
				Default = value32,
		Callback = function(p59)
        t1.value32 = p59
        t1.value11.set("guestBetterDetectionEnabled", p59)
    end
	})

    local _tostring = tostring
    local v101 = _tostring(t1.value33)
            v96:AddTextbox({
		Text = "碰撞箱X",
		Placeholder = v101,
		Callback = function(p60)
        local num = tonumber(p60)

        if num then
            t1.value11.set("guestBetterDetectionX", num)
        end
    end
	})

    local str = tostring(t1.value34)

    v96:AddTextbox({
		Text = "碰撞箱Y",
		Placeholder = str,
		Callback = function(p61)
        local num = tonumber(p61)

        if num then
            t1.value11.set("guestBetterDetectionY", num)
        end
    end
	})

    local str2 = tostring(t1.value35)

    v96:AddTextbox({
		Text = "碰撞箱Z (前向)",
		Placeholder = str2,
		Callback = function(p62)
        local num = tonumber(p62)

        if num then
            t1.value11.set("guestBetterDetectionZ", num)
        end
    end
	})
    local str3 = tostring(t1.value36)
            v96:AddTextbox({
		Text = "倍率",
		Placeholder = str3,
		Callback = function(p63)
        local num = tonumber(p63)

        if num then
            t1.value11.set("guestBetterDetectionMultiplier", num)
        end
    end
	})
    local str4 = tostring(t1.value37)
            v96:AddTextbox({
		Text = "段数",
		Placeholder = str4,
		Callback = function(p64)
        local num = tonumber(p64)

        if num then
            local v478 = math.max(1, (math.floor(num)))

            t1.value11.set("guestBetterDetectionSegments", v478)
        end
    end
	})

    local str5 = tostring(t1.value38)

    v96:AddTextbox({
		Text = "起始距离",
		Placeholder = str5,
		Callback = function(p65)
        local num = tonumber(p65)

        if num then
            t1.value11.set("guestBetterStartDist", num)
        end
    end
	})

    local str6 = tostring(t1.value39)

    v96:AddTextbox({
		Text = "步长距离",
		Placeholder = str6,
		Callback = function(p66)
        local num = tonumber(p66)

        if num then
            t1.value11.set("guestBetterStepDist", num)
        end
    end
	})

    local _tostring2 = tostring
    local v112 = _tostring2(t1.value40)
            v96:AddTextbox({
		Text = "预延迟 (秒)",
		Placeholder = v112,
		Callback = function(p67)
        local num = tonumber(p67)

        if num then
            t1.value11.set("guestBetterPreDelay", num)
        end
    end
	})
    local str7 = tostring(t1.value41)
            v96:AddTextbox({
		Text = "交错 (秒)",
		Placeholder = str7,
		Callback = function(p68)
        local num = tonumber(p68)

        if num then
            t1.value11.set("guestBetterStagger", num)
        end
    end
	})

    local str8 = tostring(t1.value42)

    v96:AddTextbox({
		Text = "前向预测",
		Placeholder = str8,
		Callback = function(p69)
        local num = tonumber(p69)

        if num then
            t1.value11.set("guestBetterPredForward", num)
        end
    end
	})

    local str9 = tostring(t1.value43)

    v96:AddTextbox({
		Text = "转向预测",
		Placeholder = str9,
		Callback = function(p70)
        local num = tonumber(p70)

        if num then
            t1.value11.set("guestBetterPredTurn", num)
        end
    end
	})

    local v117 = t1.value17:CreateTab({
		Text = "线挡",
		Icon = "minus"
	}):CreateSection({
		Text = "线挡",
		Opened = true
	})
    local value76 = t1.value76
            v117:AddToggle({
		Text = "启用力线挡",
				Default = value76,
		Callback = function(p71)
        t1.value76 = p71
        t1.value11.set("lineBlockEnabled", p71)
    end
	})

    

    v117:AddSlider({
		Text = "线长度",
		Increment = 1,
		Min = 2, Max = 40, Default = t1.value77
		Callback = function(p72)
        t1.value77 = p72
        t1.value11.set("lineBlockLength", p72)
    end
	})

    

    v117:AddSlider({
		Text = "线半径",
		Increment = 0.5,
		Min = 0.5, Max = 10, Default = t1.value78
		Callback = function(p73)
        t1.value78 = p73
        t1.value11.set("lineBlockRadius", p73)
    end
	})

    local v122 = math.floor(t1.value79 / 0.05 + 0.5)
    

    v117:AddSlider({
		Text = "格挡延迟 (x0.05秒)",
		Increment = 1,
		Min = 0, Max = 20, Default = v122
		Callback = function(p74)
        t1.value79 = p74 * 0.05
        t1.value11.set("lineBlockDelay", t1.value79)
    end
	})
    local v125 = math.floor(t1.value80 / 0.01 + 0.5)
    
            v117:AddSlider({
		Text = "反骗保持 (x0.01秒)",
		Increment = 1,
		Min = 0, Max = 50, Default = v125
		Callback = function(p75)
        t1.value80 = p75 * 0.01
        t1.value11.set("lineBlockFacingDuration", t1.value80)
    end
	})

    local _math = math
    local v129 = _math.floor(t1.value81 * 10 + 0.5)
    
            v117:AddSlider({
		Text = "朝向灵敏度",
		Increment = 1,
		Min = 1, Max = 10, Default = v129
		Callback = function(p76)
        t1.value81 = p76 / 10
        t1.value11.set("lineBlockMinDot", t1.value81)
    end
	})
    v117:AddParagraph({
		Text = "颜色指南",
		Content = "白色 = 空闲  |  黄色 = 检测到出拳动画或声音  |  红色 = 你在线上(格挡触发)"
	})
    v131 = t1.value17:CreateTab({
		Text = "出拳",
		Icon = "zap"
	})
    v132 = v131:CreateSection({
		Text = "自动出拳",
		Opened = true
	})

    local value19 = t1.value19

    v132:AddToggle({
		Text = "自动出拳",
				Default = value19,
		Callback = function(p77)
        t1.value19 = p77
        t1.value11.set("guestAutoPunchOn", p77)
    end
	})
end
local value26 = t1.value26
v132:AddToggle({
	Text = "瞄准出拳",
		Default = value26,
	Callback = function(p78)
    t1.value26 = p78
    t1.value11.set("guestAimPunchActive", p78)

    if p78 then
        p78 = t1.value8.Character
    end

    if p78 then
        t1.value170(t1.value8.Character)
    end
end
})

v132:AddSlider({
	Text = "出拳预测",
	Increment = 0.1,
	Min = 0, Max = 10, Default = t1.value27
	Callback = function(p79)
    t1.value27 = p79
    t1.value11.set("guestPunchPrediction", p79)
end
})
local str = tostring(t1.value59)

v132:AddTextbox({
	Text = "自定义出拳音效ID",
	Placeholder = str,
	Callback = function(p80)
    t1.value59 = tonumber(p80) or 0
    t1.value11.set("customPunchSoundId", t1.value59)
end
})
local v137 = v131:CreateSection({
	Text = "出拳机动",
	Opened = false
})
local value60 = t1.value60
            v137:AddToggle({
	Text = "启用出拳机动",
		Default = value60,
	Callback = function(p81)
    t1.value60 = p81
    t1.value11.set("punchMobilityEnabled", p81)

    if p81 then
        t1.value173()
        t1.value178()

        return
    end

    t1.value174()
    t1.value176()
end
})
local value62 = t1.value62
v137:AddToggle({
	Text = "猛冲增强",
		Default = value62,
	Callback = function(p82)
    t1.value62 = p82
    t1.value11.set("lungeBoostEnabled", p82)

    if not p82 then
        if t1.value124 then
            task.cancel(t1.value124)
        end

        pcall(function()
            t1.value1:UnbindFromRenderStep("LungeBoost")
        end)
    end
end
})

v137:AddSlider({
	Text = "猛冲倍率",
	Increment = 0.1,
	Min = 0.5, Max = 5, Default = t1.value63
	Callback = function(p83)
    t1.value63 = p83
    t1.value11.set("lungeMultiplier", p83)
end
})
local value61 = t1.value61
v137:AddToggle({
	Text = "冲刺控制",
		Default = value61,
	Callback = function(p84)
    t1.value61 = p84
    t1.value11.set("chargeControlEnabled", p84)

    if not p84 then
        t1.value182()
    end
end
})

            v137:AddSlider({
	Text = "冲刺速度限制",
	Increment = 1,
	Min = 1, Max = 50, Default = t1.value65
	Callback = function(p85)
    t1.value65 = p85
    t1.value11.set("chargeSpeedLimit", p85)
end
})
local value64 = t1.value64
            v137:AddToggle({
	Text = "冲刺速度上限",
		Default = value64,
	Callback = function(p86)
    t1.value11.set("chargeSpeedCapEnabled", p86)

    if t1.value122 and p86 then
        t1.value181()

        return
    end

    if not p86 then
        t1.value180()
    end
end
})
local v147 = v131:CreateSection({
	Text = "电影文本",
	Opened = false
})
local value49 = t1.value49
v147:AddToggle({
	Text = "启用电影文本",
		Default = value49,
	Callback = function(p87)
    t1.value49 = p87
    t1.value11.set("guestCinematicTextEnabled", p87)
end
})
local value50 = t1.value50
            v147:AddTextbox({
	Text = "文本内容",
	Placeholder = value50,
	Callback = function(p88)
    if p88 ~= "" then
        t1.value11.set("guestCinematicText", p88)
    end
end
})

            v132:AddSlider({
	Text = "瞄准锁定持续时间 (秒)",
	Increment = 0.05,
	Min = 0.1, Max = 2, Default = t1.value28
	Callback = function(p89)
    t1.value28 = p89
    t1.value11.set("guestAimPunchDuration", p89)
end
})
local v153 = t1.value17:CreateTab({
	Text = "反向",
	Icon = "refresh-cw"
}):CreateSection({
	Text = "反向格挡",
	Opened = true
})
local value44 = t1.value44
            v153:AddToggle({
	Text = "启用反向",
		Default = value44,
	Callback = function(p90)
    t1.value44 = p90
    t1.value11.set("guestReverseEnabled", p90)
end
})
v153:AddParagraph({
	Text = "信息",
	Content = "启用后，格挡区域以你为中心而不是杀手。"
})
local v156 = t1.value17:CreateTab({
	Text = "经典",
	Icon = "clock"
}):CreateSection({
	Text = "经典朝向",
	Opened = true
})
local value45 = t1.value45
            v156:AddToggle({
	Text = "启用经典朝向",
		Default = value45,
	Callback = function(p91)
    t1.value45 = p91
    t1.value11.set("guestLegacyFacingEnabled", p91)
end
})

v156:AddSlider({
	Text = "视野范围",
	Increment = 0.5,
	Min = 1, Max = 20, Default = t1.value46
	Callback = function(p92)
    t1.value46 = p92
    t1.value11.set("guestLegacyVisionRange", p92)
end
})

v156:AddSlider({
	Text = "视野角度",
	Increment = 1,
	Min = 1, Max = 200, Default = t1.value47
	Callback = function(p93)
    t1.value47 = p93
    t1.value11.set("guestLegacyVisionAngle", p93)
end
})
local value48 = t1.value48
            v156:AddToggle({
	Text = "显示视野范围",
		Default = value48,
	Callback = function(p94)
    t1.value48 = p94
    t1.value11.set("guestLegacyShowVisionRange", p94)
end
})
local v163 = t1.value17:CreateTab({
	Text = "延迟",
	Icon = "activity"
}):CreateSection({
	Text = "延迟检测器",
	Opened = true
})
local value53 = t1.value53
v163:AddToggle({
	Text = "启用延迟检测器",
		Default = value53,
	Callback = function(p95)
    t1.value53 = p95
    t1.value11.set("pingCheckerEnabled", p95)

    if not p95 and t1.value106 then
        t1.value106.Parent.Parent:Destroy()
    end
end
})
v163:AddParagraph({
	Text = "信息",
	Content = "在屏幕左下角显示一个小延迟计数器。"
})
local v165 = t1.value17:CreateTab({
	Text = "杂项",
	Icon = "settings"
}):CreateSection({
	Text = "杂项",
	Opened = true
})
local value51 = t1.value51
            v165:AddToggle({
	Text = "智能延迟",
		Default = value51,
	Callback = function(p96)
    t1.value51 = p96
    t1.value11.set("guestSmartDelayEnabled", p96)
end
})
local value52 = t1.value52
v165:AddToggle({
	Text = "手动拖拽",
		Default = value52,
	Callback = function(p97)
    t1.value52 = p97
    t1.value11.set("guestManualDragEnabled", p97)
end
})
local value56 = t1.value56
            v165:AddToggle({
	Text = "穿墙",
		Default = value56,
	Callback = function(p98)
    t1.value56 = p98
    t1.value11.set("noclipEnabled", p98)

    if p98 then
        t1.value171()

        return
    end

    t1.value172()
end
})
local value57 = t1.value57
v165:AddToggle({
	Text = "仅在格挡就绪时穿墙",
		Default = value57,
	Callback = function(p99)
    t1.value57 = p99
    t1.value11.set("noclipOnlyWhenBlockReady", p99)
end
})
local value58 = t1.value58
v165:AddToggle({
	Text = "FPS计数器",
		Default = value58,
	Callback = function(p100)
    t1.value58 = p100
    t1.value11.set("fpsCounterEnabled", p100)

    if not p100 and t1.value109 then
        t1.value109:Destroy()
    end
end
})
t1.value17:CreateTab({
	Text = "界面",
	Icon = "scan"
}):AddButton({
	Text = "关闭界面",
		Callback = function()
    if not pcall(function()
        t1.value17:Destroy()
    end) then
        pcall(function()
            t1.value17:Close()
        end)
    end
end
})
print("67")
