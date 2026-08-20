local repo = 'https://raw.githubusercontent.com/deividcomsono/Obsidian/main/'

local function safeStart()
	local success, err = pcall(function()

		local Players = game:GetService("Players")
		local player = Players.LocalPlayer

		local function startMain()
			print("✅ 开始加载 UI 框架...")
			local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
			local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
			local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

			Library.ShowToggleFrameInKeybinds = true 
			Library.ShowCustomCursor = true
			Library.NotifySide = "Right"

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
			print("✅ UI 窗口创建成功")

			local tabSettings   = Window:AddTab('设置', 'settings-2')
			local tabGlobal     = Window:AddTab('全局', 'globe-2')
			local tabGen        = Window:AddTab('发电机', 'cpu')
			local tabKiller     = Window:AddTab('杀手', 'sword')
			local tabVisual     = Window:AddTab('视觉', 'eye')
			local tabMusic      = Window:AddTab('音乐', 'music')
			local tabSurSen     = Window:AddTab('哨兵', 'shield')
			local tabJaneDoe    = Window:AddTab('Jane Doe', 'gem')
			local tabVeeronica  = Window:AddTab('Veeronica', 'zap')
			local tabAutoBlock  = Window:AddTab('自动格挡', 'shield')
			local tabUI         = Window:AddTab('界面', 'layout-dashboard')


			local svc = {
				Players      = game:GetService("Players"),
				Run          = game:GetService("RunService"),
				Input        = game:GetService("UserInputService"),
				RS           = game:GetService("ReplicatedStorage"),
				WS           = game:GetService("Workspace"),
				TweenService = game:GetService("TweenService"),
				TextChat     = game:GetService("TextChatService"),
				Http         = game:GetService("HttpService"),
				Stats        = game:GetService("Stats"),
			}

			local lp  = svc.Players.LocalPlayer
			local gui = lp:WaitForChild("PlayerGui", 10)

			local fs = {
				hasFolder = isfolder      or function() return false end,
				makeFolder= makefolder    or function() end,
				write     = writefile     or function() end,
				hasFile   = isfile        or function() return false end,
				read      = readfile      or function() return "" end,
				asset     = getcustomasset or function(p) return p end,
			}

			local cfg = {}
			do
				local DIR  = "v1prware"
				local FILE = DIR .. "/config.json"
				local saveThread = nil

				local function prep()
					if not fs.hasFolder(DIR) then fs.makeFolder(DIR) end
				end

				function cfg.load()
					prep()
					if not fs.hasFile(FILE) then return end
					local ok, t = pcall(svc.Http.JSONDecode, svc.Http, fs.read(FILE))
					if ok and type(t) == "table" then cfg._data = t end
				end

				function cfg.save()
					if saveThread then task.cancel(saveThread) end
					saveThread = task.delay(0.5, function()
						saveThread = nil
						prep()
						local ok, s = pcall(svc.Http.JSONEncode, svc.Http, cfg._data)
						if ok then fs.write(FILE, s) end
					end)
				end

				function cfg.get(k, default)
					local v = cfg._data[k]
					return v ~= nil and v or default
				end

				function cfg.set(k, v)
					cfg._data[k] = v
					cfg.save()
				end

				cfg._data = {}
				cfg.load()
			end

			-- ====== 新增：聊天强制相关变量 ======
			local chatForceEnabled = cfg.get("chatForceEnabled", false)
			local chatForceConns = {}
			local function enforceChatOn()
				-- 可根据需要实现强制显示聊天
			end

			-- ====== 新增：自动格挡音效ID表（暂为空） ======
			local autoBlockTriggerSounds = {}

			-- 辅助函数
			local function getTeamFolder(name)
				local root = svc.WS:FindFirstChild("Players")
				return root and root:FindFirstChild(name)
			end
			local function getIngame()
				local m = svc.WS:FindFirstChild("Map")
				return m and m:FindFirstChild("Ingame")
			end
			local function getMapContent()
				local ig = getIngame()
				return ig and ig:FindFirstChild("Map")
			end

			local _networkModule = nil
			local function getNetwork()
				if _networkModule then return _networkModule end
				local ok, m = pcall(function()
					return require(svc.RS.Modules.Network.Network)
				end)
				if ok and m then _networkModule = m end
				return _networkModule
			end

			-- ==================== 设置选项卡 ====================
			local secSettings = tabSettings:AddLeftGroupbox("常规设置")
			secSettings:AddToggle("showChatLogs", {
				Text = "显示聊天记录",
				Default = chatForceEnabled,
				Callback = function(on)
					chatForceEnabled = on
					cfg.set("chatForceEnabled", on)
					for _, c in ipairs(chatForceConns) do
						if c.Connected then c:Disconnect() end
					end
					chatForceConns = {}
					if on then
						enforceChatOn()
						for _, key in ipairs({ "ChatWindowConfiguration", "ChatInputBarConfiguration" }) do
							local obj = svc.TextChat:FindFirstChild(key)
							if obj then
								table.insert(chatForceConns, obj:GetPropertyChangedSignal("Enabled"):Connect(enforceChatOn))
							end
						end
					end
				end
			})

			local timerSide = cfg.get("timerSide", "Middle")
			local function applyTimerPos()
				local rt = lp.PlayerGui:FindFirstChild("RoundTimer")
				local m  = rt and rt:FindFirstChild("Main")
				if m then
					m.Position = UDim2.new(timerSide == "Middle" and 0.5 or 0.9, 0, m.Position.Y.Scale, m.Position.Y.Offset)
				end
			end
			applyTimerPos()
			
			-- ==================== 全局选项卡（耐力 + 状态） ====================
			local secStamina = tabGlobal:AddLeftGroupbox("耐力")
			local stam = {
				on      = cfg.get("stamOn",      false),
				loss    = cfg.get("stamLoss",    10),
				gain    = cfg.get("stamGain",    20),
				max     = cfg.get("stamMax",     100),
				current = cfg.get("stamCurrent", 100),
				noLoss  = cfg.get("stamNoLoss",  false),
				thread  = nil,
			}
			local function stamModule()
				local ok, m = pcall(function() return require(svc.RS.Systems.Character.Game.Sprinting) end)
				return ok and m or nil
			end
			local function stamIsKiller()
				local ch = lp.Character; if not ch then return false end
				local kf = getTeamFolder("Killers")
				return kf and ch:IsDescendantOf(kf)
			end
			local function stamApply()
				local m = stamModule(); if not m then return end
				if not m.DefaultsSet then pcall(function() m.Init() end) end
				local forceNoLoss = stam.noLoss or stamIsKiller()
				m.StaminaLoss = stam.loss; m.StaminaGain = stam.gain
				local abilityCapActive = type(m.StaminaCap) == "number" and m.StaminaCap < (m.MaxStamina or math.huge)
				if not abilityCapActive then
					m.MaxStamina = stam.max
					if type(m.StaminaCap) == "number" then m.StaminaCap = stam.max end
				end
				m.StaminaLossDisabled = forceNoLoss
				if m.Stamina and m.Stamina > stam.max then m.Stamina = stam.current end
				pcall(function() if m.__staminaChangedEvent then m.__staminaChangedEvent:Fire() end end)
			end
			local function stamStart()
				if stam.thread then return end
				stam.thread = task.spawn(function()
					while stam.on do
						if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then stamApply() end
						task.wait(0.5)
					end; stam.thread = nil
				end)
			end
			local function stamStop()
				stam.on = false
				if stam.thread then task.cancel(stam.thread); stam.thread = nil end
			end
			secStamina:AddToggle("stamOn", {
				Text = "自定义耐力",
				Default = stam.on,
				Callback = function(on) stam.on = on; cfg.set("stamOn", on); if on then stamStart() else stamStop() end end
			})
			secStamina:AddSlider("stamLoss", {
				Text = "消耗速率",
				Default = stam.loss, Min = 0, Max = 50, Rounding = 0,
				Callback = function(v) stam.loss = v; cfg.set("stamLoss", v) end
			})
			secStamina:AddSlider("stamGain", {
				Text = "恢复速率",
				Default = stam.gain, Min = 0, Max = 50, Rounding = 0,
				Callback = function(v) stam.gain = v; cfg.set("stamGain", v) end
			})
			secStamina:AddSlider("stamMax", {
				Text = "最大耐力池",
				Default = stam.max, Min = 50, Max = 500, Rounding = 0,
				Callback = function(v) stam.max = v; cfg.set("stamMax", v) end
			})
			secStamina:AddSlider("stamCurrent", {
				Text = "当前耐力值",
				Default = stam.current, Min = 0, Max = 500, Rounding = 0,
				Callback = function(v) stam.current = v; cfg.set("stamCurrent", v) end
			})
			secStamina:AddToggle("stamNoLoss", {
				Text = "无限耐力",
				Default = stam.noLoss,
				Callback = function(on)
					stam.noLoss = on; cfg.set("stamNoLoss", on); stamApply()
					if on and not stam.on then stam.on = true; stamStart() end
				end
			})
			if stam.on then stamStart() end
			lp.CharacterAdded:Connect(function()
				task.delay(1.5, function()
					if stam.on then stamApply(); if not stam.thread then stamStart() end end
				end)
			end)

			local secStatus = tabGlobal:AddLeftGroupbox("状态")
			local statusGroups = {
				Slowness      = { on = false, paths = { "Modules.Schematics.StatusEffects.Slowness" } },
				Hallucination = { on = false, paths = { "Modules.Schematics.StatusEffects.KillerExclusive.Hallucination" } },
				Visual        = { on = false, paths = {
					"Modules.Schematics.StatusEffects.Blindness",
					"Modules.Schematics.StatusEffects.SurvivorExclusive.Subspaced",
					"Modules.Schematics.StatusEffects.KillerExclusive.Glitched",
				}},
			}
			local statusBackup = {}
			local function statusResolve(path)
				local node = svc.RS
				for seg in path:gmatch("[^%.]+") do node = node:FindFirstChild(seg); if not node then return nil end end
				return node
			end
			local function statusBlock(path)
				if statusBackup[path] then return end
				local mod = statusResolve(path)
				if not mod then return end
				if mod:IsA("Folder") then
					statusBackup[path] = { clone = mod:Clone(), isFolder = true, parentPath = path:match("^(.-)%.?[^%.]+$") }
					mod:Destroy()
				elseif mod:IsA("ModuleScript") or mod:IsA("LocalScript") then
					statusBackup[path] = { clone = mod:Clone(), src = mod.Source, isFolder = false }
					mod:Destroy()
				end
			end
			local function statusRestore(path)
				local saved = statusBackup[path]; if not saved then return end
				local existing = statusResolve(path); if existing then existing:Destroy() end
				local parentPath = saved.parentPath or path:match("^(.-)%.?[^%.]+$")
				local parent = statusResolve(parentPath)
				if parent then
					if not saved.isFolder then saved.clone.Source = saved.src end
					saved.clone.Parent = parent
				end
				statusBackup[path] = nil
			end
			local statusLoopThread = nil
			local function statusTick()
				if statusLoopThread then return end
				statusLoopThread = task.spawn(function()
					while true do
						local any = false
						for _, g in pairs(statusGroups) do
							if g.on then any = true; for _, p in ipairs(g.paths) do local m = statusResolve(p); if m then m:Destroy() end end end
						end
						if not any then break end; task.wait(0.8)
					end; statusLoopThread = nil
				end)
			end
			local function statusToggle(name)
				local g = statusGroups[name]; if not g then return end; g.on = not g.on
				for _, p in ipairs(g.paths) do if g.on then statusBlock(p) else statusRestore(p) end end
				local any = false; for _, sg in pairs(statusGroups) do if sg.on then any = true; break end end
				if any then statusTick() elseif statusLoopThread then task.cancel(statusLoopThread); statusLoopThread = nil end
			end
			secStatus:AddButton({ Text = "切换: 减速", Func = function() statusToggle("Slowness") end })
			secStatus:AddButton({ Text = "切换: 幻觉", Func = function() statusToggle("Hallucination") end })
			secStatus:AddButton({ Text = "切换: 视觉特效", Func = function() statusToggle("Visual") end })
			lp.CharacterAdded:Connect(function()
				statusBackup = {}; for _, g in pairs(statusGroups) do g.on = false end
				if statusLoopThread then task.cancel(statusLoopThread); statusLoopThread = nil end
			end)

			-- ==================== 发电机选项卡（自动解谜） ====================
			local secGenAuto = tabGen:AddLeftGroupbox("自动解谜")
			local flow = { on = cfg.get("flowOn", false), nodeDelay = cfg.get("flowNodeDelay", 0.04), lineDelay = cfg.get("flowLineDelay", 0.60) }
			local function flowKey(n) return n.row.."-"..n.col end
			local function flowNeighbour(r1,c1,r2,c2)
				if r2==r1-1 and c2==c1 then return"up" end; if r2==r1+1 and c2==c1 then return"down" end
				if r2==r1 and c2==c1-1 then return"left" end; if r2==r1 and c2==c1+1 then return"right" end; return false
			end
			local function flowOrder(path, endpoints)
				if not path or #path == 0 then return path end
				local lookup = {}
				for _, n in ipairs(path) do lookup[flowKey(n)] = n end
				local start
				for _, ep in ipairs(endpoints or {}) do
					for _, n in ipairs(path) do
						if n.row == ep.row and n.col == ep.col then start = { row = ep.row, col = ep.col }; break end
					end
					if start then break end
				end
				if not start then
					for _, n in ipairs(path) do
						local nb = 0
						for _, d in ipairs({{-1,0},{1,0},{0,-1},{0,1}}) do
							if lookup[(n.row+d[1]).."-"..(n.col+d[2])] then nb += 1 end
						end
						if nb == 1 then start = { row = n.row, col = n.col }; break end
					end
				end
				if not start then start = { row = path[1].row, col = path[1].col } end
				local pool, ordered = {}, {}
				for _, n in ipairs(path) do pool[flowKey(n)] = { row = n.row, col = n.col } end
				local cur = start
				table.insert(ordered, { row = cur.row, col = cur.col }); pool[flowKey(cur)] = nil
				while next(pool) do
					local moved = false
					for k, node in pairs(pool) do
						if flowNeighbour(cur.row, cur.col, node.row, node.col) then
							table.insert(ordered, { row = node.row, col = node.col })
							pool[k] = nil; cur = node; moved = true; break
						end
					end
					if not moved then break end
				end
				return ordered
			end
			local function flowSolve(puzzle)
				if not puzzle or not puzzle.Solution then return end
				local indices = {}
				for i = 1, #puzzle.Solution do indices[i] = i end
				for i = #indices, 2, -1 do local j = math.random(1, i); indices[i], indices[j] = indices[j], indices[i] end
				for _, ci in ipairs(indices) do
					local solution = puzzle.Solution[ci]; if not solution then continue end
					local ordered = flowOrder(solution, puzzle.targetPairs[ci])
					if not ordered or #ordered == 0 then continue end
					puzzle.paths[ci] = {}
					for _, node in ipairs(ordered) do
						table.insert(puzzle.paths[ci], { row = node.row, col = node.col })
						puzzle:updateGui(); task.wait(flow.nodeDelay)
					end
					task.wait(flow.lineDelay); puzzle:checkForWin()
				end
			end

			do
				local modFolder  = svc.RS:FindFirstChild("Modules")
				local miniFolder = modFolder and modFolder:FindFirstChild("Minigames")
				local fgFolder   = miniFolder and miniFolder:FindFirstChild("FlowGameManager")
				local fgModule   = fgFolder and fgFolder:FindFirstChild("FlowGame")
				if fgModule then
					local ok, FG = pcall(require, fgModule)
					if ok and FG and FG.new then
						local orig = FG.new
						FG.new = function(...)
							local p = orig(...)
							if flow.on then task.spawn(function() task.wait(0.3); flowSolve(p) end) end
							return p
						end
					end
				end
			end

			secGenAuto:AddToggle("flowOn", {
				Text = "自动解谜",
				Default = flow.on,
				Callback = function(on) flow.on = on; cfg.set("flowOn", on) end
			})
			secGenAuto:AddSlider("flowNodeDelay", {
				Text = "节点速度",
				Default = flow.nodeDelay, Min = 0.01, Max = 0.50, Rounding = 2,
				Callback = function(v) flow.nodeDelay = v; cfg.set("flowNodeDelay", v) end
			})
			secGenAuto:AddSlider("flowLineDelay", {
				Text = "线路暂停",
				Default = flow.lineDelay, Min = 0.00, Max = 1.00, Rounding = 2,
				Callback = function(v) flow.lineDelay = v; cfg.set("flowLineDelay", v) end
			})

			-- ==================== 杀手选项卡 ====================
			local secAimbot = tabKiller:AddLeftGroupbox("自瞄")
			local aim = {
				on=cfg.get("aimOn",false), cooldown=cfg.get("aimCooldown",0.3), lockTime=cfg.get("aimLockTime",0.4),
				maxDist=cfg.get("aimMaxDist",30), smooth=cfg.get("aimSmooth",0.35),
				targeting=false, target=nil, deathConn=nil, autoRotate=nil, lastFired=0,
				hum=nil, hrp=nil, cache={}, cacheTime=0, cacheLife=0.5,
			}
			local function aimAmIKiller() local ch=lp.Character; if not ch then return false end; local kf=getTeamFolder("Killers"); return kf and ch:IsDescendantOf(kf) end
			local function aimRefreshChar(ch) aim.hum=ch:FindFirstChildOfClass("Humanoid"); aim.hrp=ch:FindFirstChild("HumanoidRootPart") end
			local function aimRefreshTargets()
				local now=tick(); if now-aim.cacheTime<aim.cacheLife then return end; aim.cacheTime=now; aim.cache={}
				local sf=getTeamFolder("Survivors"); if not sf then return end
				for _,model in ipairs(sf:GetChildren()) do if model~=lp.Character and model:IsA("Model") then local h=model:FindFirstChildOfClass("Humanoid"); local r=model:FindFirstChild("HumanoidRootPart"); if h and r and h.Health>0 then table.insert(aim.cache,r) end end end
			end
			local function aimNearest()
				aimRefreshTargets(); if not aim.hrp or #aim.cache==0 then return nil end
				local best,bd=nil,math.huge; for _,r in ipairs(aim.cache) do local d=(r.Position-aim.hrp.Position).Magnitude; if d<bd and d<=aim.maxDist then bd=d; best=r end end; return best
			end
			local function aimUnlock()
				if not aim.targeting then return end
				if aim.deathConn then aim.deathConn:Disconnect(); aim.deathConn=nil end
				if aim.autoRotate~=nil and aim.hum then aim.hum.AutoRotate=aim.autoRotate end
				aim.targeting=false; aim.target=nil
			end
			local function aimLock(r)
				if not r or not r.Parent or not aim.hum or not aim.hrp then return end
				if aim.targeting and aim.target==r then return end
				aimUnlock(); aim.target=r; aim.targeting=true; aim.autoRotate=aim.hum.AutoRotate; aim.hum.AutoRotate=false
				local th=r.Parent:FindFirstChildOfClass("Humanoid"); if th then aim.deathConn=th.Died:Connect(aimUnlock) end
				task.delay(aim.lockTime, function() if aim.target==r then aimUnlock() end end)
			end
			svc.Run.RenderStepped:Connect(function()
				if not aim.on or not aim.targeting or not aim.hrp or not aim.target then return end
				if not aim.target.Parent then aimUnlock(); return end
				local th=aim.target.Parent:FindFirstChildOfClass("Humanoid"); if not th or th.Health<=0 then aimUnlock(); return end
				local dx=aim.target.Position.X-aim.hrp.Position.X
				local dz=aim.target.Position.Z-aim.hrp.Position.Z
				local mag=math.sqrt(dx*dx+dz*dz)
				if mag>0 then
					local flat=Vector3.new(dx/mag,0,dz/mag)
					aim.hrp.CFrame=aim.hrp.CFrame:Lerp(CFrame.new(aim.hrp.Position,aim.hrp.Position+flat),aim.smooth)
				end
			end)

			local _hbRemote = nil
			local function hbGetRemote()
				if _hbRemote and _hbRemote.Parent then return _hbRemote end
				local ok, re = pcall(function()
					return svc.RS.Modules.Network.Network:FindFirstChild("RemoteEvent")
				end)
				if ok and re then _hbRemote = re; return re end
				return nil
			end
			task.spawn(function()
				local remote = hbGetRemote()
				if remote then
					remote.OnClientEvent:Connect(function(...)
						if not aim.on then return end
						local a={...}; if typeof(a[1])~="string" then return end; local n=a[1]
						if not (n:match("Ability") or n:match("[QER]") or n=="Slash" or n=="Dagger" or n=="Charge") then return end
						if tick()-aim.lastFired<aim.cooldown then return end; aim.lastFired=tick()
						if aimAmIKiller() then local t=aimNearest(); if t then aimLock(t) end end
					end)
				end
			end)

			lp.CharacterAdded:Connect(function(ch) task.wait(0.5); aimRefreshChar(ch) end)
			if lp.Character then aimRefreshChar(lp.Character) end

			secAimbot:AddToggle("aimOn", { Text="启用自瞄", Default=aim.on, Callback=function(on) aim.on=on; cfg.set("aimOn",on); if not on then aimUnlock() end end })
			secAimbot:AddSlider("aimCooldown", { Text="冷却 (秒)", Default=aim.cooldown, Min=0.1, Max=2.0, Rounding=2, Callback=function(v) aim.cooldown=v; cfg.set("aimCooldown",v) end })
			secAimbot:AddSlider("aimLockTime", { Text="锁定时间 (秒)", Default=aim.lockTime, Min=0.1, Max=3.0, Rounding=1, Callback=function(v) aim.lockTime=v; cfg.set("aimLockTime",v) end })
			secAimbot:AddSlider("aimMaxDist", { Text="最大距离", Default=aim.maxDist, Min=5, Max=100, Rounding=0, Callback=function(v) aim.maxDist=v; cfg.set("aimMaxDist",v) end })
			secAimbot:AddSlider("aimSmooth", { Text="旋转平滑度", Default=aim.smooth, Min=0.05, Max=1.0, Rounding=2, Callback=function(v) aim.smooth=v; cfg.set("aimSmooth",v) end })

			local secABS = tabKiller:AddLeftGroupbox("反背刺")
			local abs = { on=cfg.get("absOn",false), range=cfg.get("absRange",40), duration=cfg.get("absDur",1.5), locked=false, soundConn=nil, scanThread=nil, rings={} }
			local absTriggerSounds = { ["86710781315432"]=true, ["99820161736138"]=true }
			local absScreenGui = nil
			local function absGui()
				if absScreenGui and absScreenGui.Parent then return absScreenGui end
				local pg=lp:FindFirstChild("PlayerGui"); if not pg then return nil end
				absScreenGui=Instance.new("ScreenGui"); absScreenGui.Name="AbsGui"; absScreenGui.ResetOnSpawn=false; absScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; absScreenGui.Parent=pg; return absScreenGui
			end
			local function absShowLabel(show)
				local g=absGui(); if not g then return end; local lbl=g:FindFirstChild("AbsTaunt")
				if not lbl then lbl=Instance.new("TextLabel"); lbl.Name="AbsTaunt"; lbl.Size=UDim2.new(0,500,0,50); lbl.Position=UDim2.new(0.5,-250,0.38,0); lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.new(1,1,1); lbl.TextStrokeTransparency=0.4; lbl.TextStrokeColor3=Color3.new(0,0,0); lbl.Text="刺不中你气不气😂"; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=36; lbl.TextTransparency=1; lbl.Parent=g end
				pcall(function() svc.TweenService:Create(lbl,TweenInfo.new(show and 0.15 or 0.5),{TextTransparency=show and 0 or 1}):Play() end)
			end
			local function absAddRing(model)
				local hrp=model:FindFirstChild("HumanoidRootPart"); if not hrp or abs.rings[model] then return end
				pcall(function()
					local ring=Instance.new("Part"); ring.Name="AbsRing"; ring.Shape=Enum.PartType.Cylinder; ring.Size=Vector3.new(0.1,abs.range*2,abs.range*2); ring.Color=Color3.fromRGB(220,50,50); ring.Material=Enum.Material.ForceField; ring.Transparency=0.5; ring.CanCollide=false; ring.CanTouch=false; ring.CFrame=hrp.CFrame*CFrame.Angles(0,0,math.rad(90)); ring.Parent=hrp
					local w=Instance.new("WeldConstraint"); w.Part0=hrp; w.Part1=ring; w.Parent=ring; abs.rings[model]=ring
				end)
			end
			local function absRemoveRing(model) local r=abs.rings[model]; if r then pcall(function()r:Destroy()end); abs.rings[model]=nil end end
			local function absResizeRings() for _,r in pairs(abs.rings) do if r and r.Parent then r.Size=Vector3.new(0.1,abs.range*2,abs.range*2) end end end
			local function absCleanRings() for m in pairs(abs.rings) do absRemoveRing(m) end end
			local function absFindTwoTime() local players=svc.WS:FindFirstChild("Players"); if not players then return nil end; for _,folder in ipairs(players:GetChildren()) do local tt=folder:FindFirstChild("TwoTime"); if tt then return tt end end; return nil end
			local function absTrigger()
				if abs.locked then return end; local ch=lp.Character; local myRoot=ch and ch:FindFirstChild("HumanoidRootPart"); if not myRoot then return end
				local ttModel=absFindTwoTime(); if not ttModel then return end; local ttRoot=ttModel:FindFirstChild("HumanoidRootPart"); if not ttRoot then return end
				if (myRoot.Position-ttRoot.Position).Magnitude>abs.range then return end
				abs.locked=true; absShowLabel(true)
				task.spawn(function()
					local deadline=tick()+abs.duration
					while tick()<deadline do if not abs.on then break end; local ch2=lp.Character; local r2=ch2 and ch2:FindFirstChild("HumanoidRootPart"); if not r2 or not ttRoot.Parent then break end; r2.CFrame=CFrame.lookAt(r2.Position,Vector3.new(ttRoot.Position.X,r2.Position.Y,ttRoot.Position.Z)); svc.Run.RenderStepped:Wait() end
					abs.locked=false; absShowLabel(false)
				end)
			end
			local function absHookSounds()
				if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn=nil end
				abs.soundConn=svc.WS.DescendantAdded:Connect(function(obj)
					if not abs.on or not obj:IsA("Sound") then return end
					local id=obj.SoundId:match("%d+")
					if id and absTriggerSounds[id] then absTrigger() end
				end)
			end
			local function absStartScan()
				if abs.scanThread then return end
				abs.scanThread=task.spawn(function()
					while abs.on do
						local players=svc.WS:FindFirstChild("Players")
						if players then for _,folder in ipairs(players:GetChildren()) do for _,model in ipairs(folder:GetChildren()) do if model.Name=="TwoTime" then absAddRing(model) end end end end
						for m in pairs(abs.rings) do if not m.Parent then absRemoveRing(m) end end; task.wait(1)
					end; abs.scanThread=nil
				end)
			end
			local function absStart() absHookSounds(); absStartScan() end
			local function absStop() abs.on=false; if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn=nil end; if abs.scanThread then task.cancel(abs.scanThread); abs.scanThread=nil end; absCleanRings(); abs.locked=false; absShowLabel(false) end
			lp.CharacterAdded:Connect(function() abs.locked=false; if abs.on then absStart() end end)
			secABS:AddToggle("absOn", { Text="启用反背刺", Default=abs.on, Callback=function(on) abs.on=on; cfg.set("absOn",on); if on then absStart() else absStop() end end })
			secABS:AddSlider("absRange", { Text="检测范围", Default=abs.range, Min=10, Max=120, Rounding=0, Callback=function(v) abs.range=v; cfg.set("absRange",v); absResizeRings() end })
			secABS:AddSlider("absDur", { Text="转向持续时间 (秒)", Default=abs.duration, Min=0.3, Max=5.0, Rounding=1, Callback=function(v) abs.duration=v; cfg.set("absDur",v) end })

			-- 杀手技能
			local sixerStrafeOn = cfg.get("sixerStrafeOn", false)
			local SIXER_BIND = "V1PRWareSixerStrafe"
			svc.Run:BindToRenderStep(SIXER_BIND, Enum.RenderPriority.Character.Value + 2, function()
				if not sixerStrafeOn then return end
				local char = lp.Character; if not char then return end
				if char:GetAttribute("PursuitState") ~= "Dashing" then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end
				if hum.FloorMaterial ~= Enum.Material.Air then return end
				local cam  = svc.WS.CurrentCamera
				local flat = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
				if flat.Magnitude < 0.01 then return end
				flat = flat.Unit
				local vel   = hrp.AssemblyLinearVelocity
				local hVel  = Vector3.new(vel.X, 0, vel.Z)
				local hSpeed= hVel.Magnitude
				if hSpeed < 0.1 then return end
				local newH = hVel:Lerp(flat * hSpeed, 1)
				hrp.AssemblyLinearVelocity = Vector3.new(newH.X, vel.Y, newH.Z)
			end)

			local coolkidWSOOn = cfg.get("coolkidWSOOn", false)
			local function coolkidGetInputDir()
				local cf = svc.WS.CurrentCamera.CFrame
				local fwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z).Unit
				local right = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z).Unit
				local dir = Vector3.zero
				if svc.Input:IsKeyDown(Enum.KeyCode.W) then dir += fwd  end
				if svc.Input:IsKeyDown(Enum.KeyCode.S) then dir -= fwd  end
				if svc.Input:IsKeyDown(Enum.KeyCode.A) then dir -= right end
				if svc.Input:IsKeyDown(Enum.KeyCode.D) then dir += right end
				return dir.Magnitude > 0 and dir.Unit or nil
			end
			svc.Run:BindToRenderStep("CoolkidWSO", Enum.RenderPriority.Character.Value + 1, function()
				if not coolkidWSOOn then return end
				local char = lp.Character; if not char then return end
				if char:GetAttribute("PursuitState") ~= "Dashing" then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then return end
				local inputDir = coolkidGetInputDir()
				if not inputDir then return end
				local vel = hrp.AssemblyLinearVelocity
				local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
				if speed < 0.1 then return end
				hrp.AssemblyLinearVelocity = Vector3.new(inputDir.X * speed, vel.Y, inputDir.Z * speed)
				hum.WalkSpeed = 60; hum.AutoRotate = false
				local horiz = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)
				if horiz.Magnitude > 0 then hum:Move(horiz.Unit) end
			end)

			local noliVoidRushOn = cfg.get("noliVoidRushOn", false)
			local noliOverrideActive = false
			local noliOrigWalkSpeed = nil
			local noliOrigAutoRotate = nil
			local function noliStart()
				if noliOverrideActive then return end
				noliOverrideActive = true
				local char = lp.Character; if not char then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hrp or not hum then noliOverrideActive = false; return end
				noliOrigWalkSpeed = hum.WalkSpeed
				noliOrigAutoRotate = hum.AutoRotate
				svc.Run:BindToRenderStep("NoliVoidRush", Enum.RenderPriority.Character.Value + 3, function()
					if not noliOverrideActive then svc.Run:UnbindFromRenderStep("NoliVoidRush"); return end
					local ch2 = lp.Character; if not ch2 then return end
					local hrp2 = ch2:FindFirstChild("HumanoidRootPart"); local hum2 = ch2:FindFirstChildOfClass("Humanoid")
					if not hrp2 or not hum2 then return end
					hum2.WalkSpeed = 60; hum2.AutoRotate = false
					local horiz = Vector3.new(hrp2.CFrame.LookVector.X, 0, hrp2.CFrame.LookVector.Z)
					if horiz.Magnitude > 0 then hum2:Move(horiz.Unit) end
				end)
			end
			local function noliStop()
				if not noliOverrideActive then return end
				noliOverrideActive = false
				svc.Run:UnbindFromRenderStep("NoliVoidRush")
				local char = lp.Character; if not char then return end
				local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
				if noliOrigWalkSpeed ~= nil then hum.WalkSpeed = noliOrigWalkSpeed end
				if noliOrigAutoRotate ~= nil then hum.AutoRotate = noliOrigAutoRotate end
				noliOrigWalkSpeed = nil; noliOrigAutoRotate = nil
			end
			svc.Run.RenderStepped:Connect(function()
				if not noliVoidRushOn then if noliOverrideActive then noliStop() end; return end
				local char = lp.Character; if not char then return end
				if char:GetAttribute("VoidRushState") == "Dashing" then noliStart() else noliStop() end
			end)
			lp.CharacterAdded:Connect(function() noliStop(); noliOrigWalkSpeed = nil end)

			local secKillerAbilities = tabKiller:AddLeftGroupbox("杀手技能")
			secKillerAbilities:AddToggle("sixerStrafeOn", { Text="Sixer — 空中转向", Default=sixerStrafeOn, Callback=function(on) sixerStrafeOn=on; cfg.set("sixerStrafeOn",on) end })
			secKillerAbilities:AddToggle("coolkidWSOOn", { Text="c00lkidd — 冲刺转向", Default=coolkidWSOOn, Callback=function(on) coolkidWSOOn=on; cfg.set("coolkidWSOOn",on) end })
			secKillerAbilities:AddToggle("noliVoidRushOn", { Text="Noli — 虚空冲刺控制", Default=noliVoidRushOn, Callback=function(on) noliVoidRushOn=on; cfg.set("noliVoidRushOn",on); if not on then noliStop() end end })

			-- ==================== 视觉 (ESP) - 完整保留原代码 ====================
			local LocalPlayer = lp
			local Camera = svc.WS.CurrentCamera

			local ESPSettings = {
			   killerESP = false,
			   playerESP = false,
			   generatorESP = false,
			   itemESP = false,
			   pizzaEsp = false,
			   pizzaDeliveryEsp = false,
			   zombieEsp = false,
			   killerTracers = false,
			   survivorTracers = false,
			   generatorTracers = false,
			   itemTracers = false,
			   pizzaTracers = false,
			   pizzaDeliveryTracers = false,
			   zombieTracers = false,
			   killerSkinESP = false,
			   survivorSkinESP = false,
			   killerNameESP = true,
			   killerHealthESP = true,
			   survivorNameESP = true,
			   survivorHealthESP = true,
			   killerFillTransparency = 0.7,
			   killerOutlineTransparency = 0.3,
			   survivorFillTransparency = 0.7,
			   survivorOutlineTransparency = 0.3,
			   killerColor = Color3.fromRGB(255, 100, 100),
			   survivorColor = Color3.fromRGB(100, 255, 100),
			   generatorColor = Color3.fromRGB(255, 100, 255),
			   itemColor = Color3.fromRGB(100, 200, 255),
			   pizzaColor = Color3.fromRGB(255, 200, 0),
			   pizzaDeliveryColor = Color3.fromRGB(255, 150, 0),
			   zombieColor = Color3.fromRGB(0, 255, 0),
			}

			local DummyNames = {
			   "PizzaDeliveryRig", "Mafiaso1", "Mafiaso2", "Builderman", "Elliot",
			   "ShedletskyCORRUPT", "ChancecORRUPT", "ChanceCORRUPT", "Mafia1", "Mafia2",
			}

			local PlayerESPData = {}
			local ObjectESPData = {}
			local TracerData = {}

			local function IsRagdoll(model)
			   local ragdolls = svc.WS:FindFirstChild("Ragdolls")
			   if not ragdolls then return false end
			   return model:IsDescendantOf(ragdolls) or (model.Parent == ragdolls)
			end

			local function IsSpectating(player)
			   if not player then return false end
			   local playersFolder = svc.WS:FindFirstChild("Players")
			   if not playersFolder then return false end
			   local spectating = playersFolder:FindFirstChild("Spectating")
			   if not spectating then return false end
			   return spectating:FindFirstChild(player.Name) ~= nil
			end

			local function GetGeneratorPart(model)
			   if not model then return nil end
			   local instances = model:FindFirstChild("Instances")
			   if instances then
				   local generator = instances:FindFirstChild("Generator")
				   if generator then
					   local cube = generator:FindFirstChild("Cube.003")
					   if cube and cube:IsA("BasePart") then return cube end
					   for _, v in ipairs(generator:GetDescendants()) do
						   if v:IsA("BasePart") then return v end
					   end
				   end
			   end
			   for _, v in ipairs(model:GetDescendants()) do
				   if v:IsA("BasePart") then return v end
			   end
			   return nil
			end

			local function UpdatePlayerBillboardText(data)
			   if not data or not data.model or not data.nameLabel then return end
			   local model = data.model
			   local isKiller = data.isKiller
			   local actorText = model:GetAttribute("ActorDisplayName") or (isKiller and "杀手" or "幸存者")
			   local skinText = model:GetAttribute("SkinNameDisplay")
			   if actorText == "Noli" and model:GetAttribute("IsFakeNoli") == true then
				   actorText = actorText .. " (Fake)"
			   end
			   local displayText = actorText
			   local showSkin = (isKiller and ESPSettings.killerSkinESP) or (not isKiller and ESPSettings.survivorSkinESP)
			   if showSkin and skinText and tostring(skinText) ~= "" then
				   displayText = displayText .. " | " .. skinText
			   end
			   local showName = (isKiller and ESPSettings.killerNameESP) or (not isKiller and ESPSettings.survivorNameESP)
			   data.nameLabel.Text = showName and displayText or ""
			   data.nameLabel.Visible = showName
			   if data.hpLabel then
				   local humanoid = model:FindFirstChild("Humanoid")
				   if humanoid then
					   local hp = math.floor(humanoid.Health)
					   local maxhp = math.floor(humanoid.MaxHealth)
					   data.hpLabel.Text = string.format("HP: %d/%d", hp, maxhp)
				   end
				   local showHealth = (isKiller and ESPSettings.killerHealthESP) or (not isKiller and ESPSettings.survivorHealthESP)
				   data.hpLabel.Visible = showHealth
			   end
			   local highlight = model:FindFirstChild("TAOWARE_Highlight")
			   if highlight then
				   if isKiller then
					   highlight.FillTransparency = ESPSettings.killerFillTransparency
					   highlight.OutlineTransparency = ESPSettings.killerOutlineTransparency
				   else
					   highlight.FillTransparency = ESPSettings.survivorFillTransparency
					   highlight.OutlineTransparency = ESPSettings.survivorOutlineTransparency
				   end
			   end
			end

			local function UpdateGeneratorProgress(data)
			   if not data or not data.model or not data.progressLabel then return end
			   local model = data.model
			   local progress = model:FindFirstChild("Progress")
			   if progress then
				   local progressValue = math.floor(progress.Value)
				   data.progressLabel.Text = string.format("Progress: %d%%", progressValue)
			   end
			end

			local function CreateESP(model, color, isGenerator, isItem, isPizza, isPizzaDelivery, isZombie, isKiller)
			   if not model then return end
			   if model:FindFirstChild("TAOWARE_Highlight") then return end
			   if isGenerator and model:FindFirstChild("Progress") and model.Progress.Value == 100 then return end
			   if IsRagdoll(model) then return end
			   local targetPart
			   if isGenerator then
				   targetPart = GetGeneratorPart(model)
			   elseif isItem then
				   targetPart = model:FindFirstChild("ItemRoot")
			   elseif isPizza or isPizzaDelivery or isZombie then
				   targetPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
			   else
				   targetPart = model:FindFirstChild("HumanoidRootPart")
			   end
			   if not targetPart then return end
			   local highlight = Instance.new("Highlight")
			   highlight.Name = "TAOWARE_Highlight"
			   highlight.Adornee = model
			   highlight.FillColor = color
			   highlight.OutlineColor = color
			   if isKiller then
				   highlight.FillTransparency = ESPSettings.killerFillTransparency
				   highlight.OutlineTransparency = ESPSettings.killerOutlineTransparency
			   elseif not isGenerator and not isItem and not isPizza and not isPizzaDelivery and not isZombie then
				   highlight.FillTransparency = ESPSettings.survivorFillTransparency
				   highlight.OutlineTransparency = ESPSettings.survivorOutlineTransparency
			   else
				   highlight.FillTransparency = 0.7
				   highlight.OutlineTransparency = 0.3
			   end
			   highlight.Parent = model
			   local billboard = Instance.new("BillboardGui")
			   billboard.Name = "TAOWARE_Billboard"
			   billboard.Adornee = targetPart
			   billboard.Size = UDim2.new(0, 100, 0, 30)
			   billboard.StudsOffset = Vector3.new(0, 4, 0)
			   billboard.AlwaysOnTop = true
			   billboard.Parent = model
			   if not isGenerator and not isItem and not isPizza and not isPizzaDelivery and not isZombie then
				   local humanoid = model:FindFirstChild("Humanoid")
				   local nameLabel = Instance.new("TextLabel")
				   nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
				   nameLabel.Position = UDim2.new(0, 0, 0, 0)
				   nameLabel.BackgroundTransparency = 1
				   nameLabel.Text = "Loading..."
				   nameLabel.Font = Enum.Font.GothamBlack
				   nameLabel.TextColor3 = color
				   nameLabel.TextSize = 8
				   nameLabel.TextStrokeTransparency = 0.6
				   nameLabel.Parent = billboard
				   local hpLabel = Instance.new("TextLabel")
				   hpLabel.Size = UDim2.new(1, 0, 0.33, 0)
				   hpLabel.Position = UDim2.new(0, 0, 0.3, 0)
				   hpLabel.BackgroundTransparency = 1
				   hpLabel.Text = "HP: " .. (humanoid and string.format("%.0f", humanoid.Health) or "N/A")
				   hpLabel.Font = Enum.Font.GothamBlack
				   hpLabel.TextColor3 = color
				   hpLabel.TextSize = 8
				   hpLabel.TextStrokeTransparency = 0.6
				   hpLabel.Parent = billboard
				   local espData = {
					   model = model,
					   nameLabel = nameLabel,
					   hpLabel = hpLabel,
					   color = color,
					   isKiller = isKiller
				   }
				   table.insert(PlayerESPData, espData)
				   UpdatePlayerBillboardText(espData)
				   model:GetAttributeChangedSignal("ActorDisplayName"):Connect(function()
					   UpdatePlayerBillboardText(espData)
				   end)
				   model:GetAttributeChangedSignal("SkinNameDisplay"):Connect(function()
					   UpdatePlayerBillboardText(espData)
				   end)
				   model:GetAttributeChangedSignal("IsFakeNoli"):Connect(function()
					   UpdatePlayerBillboardText(espData)
				   end)
				   if humanoid then
					   humanoid:GetPropertyChangedSignal("Health"):Connect(function()
						   UpdatePlayerBillboardText(espData)
					   end)
					   humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
						   UpdatePlayerBillboardText(espData)
					   end)
				   end
			   elseif isGenerator then
				   local nameLabel = Instance.new("TextLabel")
				   nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
				   nameLabel.Position = UDim2.new(0, 0, 0, 0)
				   nameLabel.BackgroundTransparency = 1
				   nameLabel.Text = "generator"
				   nameLabel.Font = Enum.Font.GothamBlack
				   nameLabel.TextColor3 = color
				   nameLabel.TextSize = 8
				   nameLabel.TextStrokeTransparency = 0.6
				   nameLabel.Parent = billboard
				   local progressLabel = Instance.new("TextLabel")
				   progressLabel.Size = UDim2.new(1, 0, 0.5, 0)
				   progressLabel.Position = UDim2.new(0, 0, 0.5, 0)
				   progressLabel.BackgroundTransparency = 1
				   progressLabel.Text = "Progress: 0%"
				   progressLabel.Font = Enum.Font.GothamBlack
				   progressLabel.TextColor3 = color
				   progressLabel.TextSize = 8
				   progressLabel.TextStrokeTransparency = 0.6
				   progressLabel.Parent = billboard
				   local espData = {
					   model = model,
					   nameLabel = nameLabel,
					   progressLabel = progressLabel,
					   highlight = highlight,
					   billboard = billboard
				   }
				   table.insert(ObjectESPData, espData)
				   UpdateGeneratorProgress(espData)
				   local progress = model:FindFirstChild("Progress")
				   if progress then
					   progress:GetPropertyChangedSignal("Value"):Connect(function()
						   UpdateGeneratorProgress(espData)
					   end)
				   end
			   else
				   local displayName = model.Name
				   if isPizzaDelivery then displayName = "Pizza Delivery" end
				   if isZombie then displayName = "Zombie" end
				   local textLabel = Instance.new("TextLabel")
				   textLabel.Size = UDim2.new(1, 0, 1, 0)
				   textLabel.BackgroundTransparency = 1
				   textLabel.Text = displayName
				   textLabel.Font = Enum.Font.GothamBlack
				   textLabel.TextColor3 = color
				   textLabel.TextSize = 8
				   textLabel.TextStrokeTransparency = 0.6
				   textLabel.Parent = billboard
				   table.insert(ObjectESPData, {model = model, highlight = highlight, billboard = billboard})
			   end
			end

			local function RemoveESP(model)
			   if not model then return end
			   for i = #PlayerESPData, 1, -1 do
				   if PlayerESPData[i].model == model then
					   table.remove(PlayerESPData, i)
				   end
			   end
			   for i = #ObjectESPData, 1, -1 do
				   if ObjectESPData[i].model == model then
					   table.remove(ObjectESPData, i)
				   end
			   end
			   pcall(function()
				   if model:FindFirstChild("TAOWARE_Highlight") then
					   model.TAOWARE_Highlight:Destroy()
				   end
				   if model:FindFirstChild("TAOWARE_Billboard") then
					   model.TAOWARE_Billboard:Destroy()
				   end
			   end)
			end

			local function CreateTracer(model, part, color)
			   if not model or not part or not part:IsA("BasePart") then return end
			   if TracerData[model] then return end
			   local line = Drawing.new("Line")
			   line.Visible = true
			   line.Color = color or Color3.fromRGB(255, 255, 255)
			   line.Thickness = 2
			   line.Transparency = 1
			   TracerData[model] = {line = line, part = part}
			end

			local function RemoveTracer(model)
			   if TracerData[model] then
				   pcall(function()
					   TracerData[model].line.Visible = false
					   TracerData[model].line:Remove()
				   end)
				   TracerData[model] = nil
			   end
			end

			local function UpdateTracers()
			   for model, data in pairs(TracerData) do
				   local line = data.line
				   local part = data.part
				   if line and part and part.Parent then
					   local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
					   if onScreen then
						   line.Visible = true
						   line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
						   line.To = Vector2.new(pos.X, pos.Y)
					   else
						   line.Visible = false
					   end
				   else
					   RemoveTracer(model)
				   end
			   end
			end

			local noliByUsername = {}
			local function clearFakeTags()
			   local playersFolder = svc.WS:FindFirstChild("Players")
			   if not playersFolder then return end
			   local killers = playersFolder:FindFirstChild("Killers")
			   if not killers then return end
			   for _, killer in ipairs(killers:GetChildren()) do
				   if killer:GetAttribute("ActorDisplayName") == "Noli" then
					   killer:SetAttribute("IsFakeNoli", false)
				   end
			   end
			end

			local function scanNolis()
			   local playersFolder = svc.WS:FindFirstChild("Players")
			   if not playersFolder then return end
			   local killers = playersFolder:FindFirstChild("Killers")
			   if not killers then return end
			   noliByUsername = {}
			   for _, killer in ipairs(killers:GetChildren()) do
				   if killer:GetAttribute("ActorDisplayName") == "Noli" then
					   local username = killer:GetAttribute("Username")
					   if username then
						   if not noliByUsername[username] then
							   noliByUsername[username] = {}
						   end
						   table.insert(noliByUsername[username], killer)
					   end
				   end
			   end
			   for username, models in pairs(noliByUsername) do
				   if #models > 1 then
					   for i = 2, #models do
						   models[i]:SetAttribute("IsFakeNoli", true)
					   end
					   models[1]:SetAttribute("IsFakeNoli", false)
				   else
					   models[1]:SetAttribute("IsFakeNoli", false)
				   end
			   end
			end

			local function updateFakeNolis()
			   clearFakeTags()
			   scanNolis()
			end

			local function UpdateAllPlayerESPText()
			   for _, data in ipairs(PlayerESPData) do
				   UpdatePlayerBillboardText(data)
			   end
			end

			local function UpdateESP()
			   local mapFolder = svc.WS:FindFirstChild("Map")
			   if not mapFolder or not mapFolder:FindFirstChild("Ingame") then
				   for i = #PlayerESPData, 1, -1 do
					   RemoveESP(PlayerESPData[i].model)
				   end
				   for i = #ObjectESPData, 1, -1 do
					   RemoveESP(ObjectESPData[i].model)
				   end
				   for model in pairs(TracerData) do
					   RemoveTracer(model)
				   end
				   return
			   end
			   local ingame = mapFolder.Ingame
			   local playersFolder = svc.WS:FindFirstChild("Players")
			   if playersFolder then
				   local killers = playersFolder:FindFirstChild("Killers")
				   if killers then
					   for _, killer in ipairs(killers:GetChildren()) do
						   if killer == lp.Character then continue end
						   if IsRagdoll(killer) then
							   RemoveESP(killer)
							   RemoveTracer(killer)
							   continue
						   end
						   local player = svc.Players:GetPlayerFromCharacter(killer)
						   if not player or IsSpectating(player) then
							   RemoveESP(killer)
							   RemoveTracer(killer)
							   continue
						   end
						   if ESPSettings.killerESP and not killer:FindFirstChild("TAOWARE_Highlight") and killer:FindFirstChild("HumanoidRootPart") then
							   CreateESP(killer, ESPSettings.killerColor, false, false, false, false, false, true)
						   elseif not ESPSettings.killerESP then
							   RemoveESP(killer)
						   end
						   if ESPSettings.killerTracers and killer:FindFirstChild("HumanoidRootPart") then
							   CreateTracer(killer, killer.HumanoidRootPart, ESPSettings.killerColor)
						   else
							   RemoveTracer(killer)
						   end
					   end
				   end
				   local survivors = playersFolder:FindFirstChild("Survivors")
				   if survivors then
					   for _, survivor in ipairs(survivors:GetChildren()) do
						   if survivor == lp.Character then continue end
						   if IsRagdoll(survivor) then
							   RemoveESP(survivor)
							   RemoveTracer(survivor)
							   continue
						   end
						   local player = svc.Players:GetPlayerFromCharacter(survivor)
						   if not player or IsSpectating(player) then
							   RemoveESP(survivor)
							   RemoveTracer(survivor)
							   continue
						   end
						   if ESPSettings.playerESP and not survivor:FindFirstChild("TAOWARE_Highlight") and survivor:FindFirstChild("HumanoidRootPart") then
							   CreateESP(survivor, ESPSettings.survivorColor, false, false, false, false, false, false)
						   elseif not ESPSettings.playerESP then
							   RemoveESP(survivor)
						   end
						   if ESPSettings.survivorTracers and survivor:FindFirstChild("HumanoidRootPart") then
							   CreateTracer(survivor, survivor.HumanoidRootPart, ESPSettings.survivorColor)
						   else
							   RemoveTracer(survivor)
						   end
					   end
				   end
			   end
			   if ingame:FindFirstChild("Map") then
				   for _, gen in ipairs(ingame.Map:GetChildren()) do
					   if gen:IsA("Model") and gen.Name:lower():find("generator") and gen.Name ~= "FakeGenerator" then
						   if IsRagdoll(gen) then
							   RemoveESP(gen)
							   RemoveTracer(gen)
							   continue
						   end
						   local progress = gen:FindFirstChild("Progress")
						   if ESPSettings.generatorESP and progress and progress.Value < 100 and not gen:FindFirstChild("TAOWARE_Highlight") then
							   CreateESP(gen, ESPSettings.generatorColor, true, false, false, false, false, false)
						   elseif (not ESPSettings.generatorESP or (progress and progress.Value >= 100)) then
							   RemoveESP(gen)
						   end
						   if ESPSettings.generatorTracers and progress and progress.Value < 100 then
							   local part = GetGeneratorPart(gen)
							   if part then
								   CreateTracer(gen, part, ESPSettings.generatorColor)
							   end
						   else
							   RemoveTracer(gen)
						   end
					   end
				   end
				   for _, item in ipairs(ingame.Map:GetDescendants()) do
					   if item.Name == "ItemRoot" and item.Parent and item.Parent:IsA("Model") then
						   local itemModel = item.Parent
						   if ESPSettings.itemESP and not itemModel:FindFirstChild("TAOWARE_Highlight") then
							   CreateESP(itemModel, ESPSettings.itemColor, false, true, false, false, false, false)
						   elseif not ESPSettings.itemESP then
							   RemoveESP(itemModel)
						   end
						   if ESPSettings.itemTracers and item:IsA("BasePart") then
							   CreateTracer(itemModel, item, ESPSettings.itemColor)
						   else
							   RemoveTracer(itemModel)
						   end
					   end
				   end
			   end
			   for _, pizza in ipairs(ingame:GetChildren()) do
				   if pizza.Name == "Pizza" and pizza:IsA("BasePart") then
					   if ESPSettings.pizzaEsp and not pizza:FindFirstChild("TAOWARE_Highlight") then
						   CreateESP(pizza, ESPSettings.pizzaColor, false, false, true, false, false, false)
					   elseif not ESPSettings.pizzaEsp then
						   RemoveESP(pizza)
					   end
					   if ESPSettings.pizzaTracers then
						   CreateTracer(pizza, pizza, ESPSettings.pizzaColor)
					   else
						   RemoveTracer(pizza)
					   end
				   end
			   end
			   for _, delivery in ipairs(ingame:GetChildren()) do
				   if delivery:IsA("Model") and table.find(DummyNames, delivery.Name) then
					   if ESPSettings.pizzaDeliveryEsp and not delivery:FindFirstChild("TAOWARE_Highlight") then
						   local hrp = delivery:FindFirstChild("HumanoidRootPart")
						   if hrp then
							   CreateESP(delivery, ESPSettings.pizzaDeliveryColor, false, false, false, true, false, false)
						   end
					   elseif not ESPSettings.pizzaDeliveryEsp then
						   RemoveESP(delivery)
					   end
					   if ESPSettings.pizzaDeliveryTracers then
						   local hrp = delivery:FindFirstChild("HumanoidRootPart")
						   if hrp then
							   CreateTracer(delivery, hrp, ESPSettings.pizzaDeliveryColor)
						   end
					   else
						   RemoveTracer(delivery)
					   end
				   end
			   end
			   for _, zombie in ipairs(ingame:GetChildren()) do
				   if zombie.Name == "Zombie" and zombie:IsA("Model") then
					   if ESPSettings.zombieEsp and not zombie:FindFirstChild("TAOWARE_Highlight") then
						   local hrp = zombie:FindFirstChild("HumanoidRootPart")
						   if hrp then
							   CreateESP(zombie, ESPSettings.zombieColor, false, false, false, false, true, false)
						   end
					   elseif not ESPSettings.zombieEsp then
						   RemoveESP(zombie)
					   end
					   if ESPSettings.zombieTracers then
						   local hrp = zombie:FindFirstChild("HumanoidRootPart")
						   if hrp then
							   CreateTracer(zombie, hrp, ESPSettings.zombieColor)
						   end
					   else
						   RemoveTracer(zombie)
					   end
				   end
			   end
			end

			task.spawn(function()
			   while true do
				   UpdateESP()
				   updateFakeNolis()
				   task.wait(0.5)
			   end
			end)

			svc.Run.RenderStepped:Connect(function()
			   UpdateTracers()
			end)

			-- ==================== 视觉选项卡 UI ====================
			local secESP = tabVisual:AddLeftGroupbox("实体 ESP")
			secESP:AddToggle("killerESP", {
				Text = "杀手",
				Default = ESPSettings.killerESP,
				Callback = function(v) ESPSettings.killerESP = v; cfg.set("espKiller", v) end
			})
			secESP:AddToggle("playerESP", {
				Text = "幸存者",
				Default = ESPSettings.playerESP,
				Callback = function(v) ESPSettings.playerESP = v; cfg.set("espSurvivor", v) end
			})
			secESP:AddToggle("generatorESP", {
				Text = "发电机",
				Default = ESPSettings.generatorESP,
				Callback = function(v) ESPSettings.generatorESP = v; cfg.set("espGenerator", v) end
			})
			secESP:AddToggle("itemESP", {
				Text = "物品",
				Default = ESPSettings.itemESP,
				Callback = function(v) ESPSettings.itemESP = v; cfg.set("espItem", v) end
			})
			secESP:AddToggle("pizzaEsp", {
				Text = "披萨",
				Default = ESPSettings.pizzaEsp,
				Callback = function(v) ESPSettings.pizzaEsp = v; cfg.set("espPizza", v) end
			})
			secESP:AddToggle("pizzaDeliveryEsp", {
				Text = "披萨配送员",
				Default = ESPSettings.pizzaDeliveryEsp,
				Callback = function(v) ESPSettings.pizzaDeliveryEsp = v; cfg.set("espPizzaDelivery", v) end
			})
			secESP:AddToggle("zombieEsp", {
				Text = "僵尸",
				Default = ESPSettings.zombieEsp,
				Callback = function(v) ESPSettings.zombieEsp = v; cfg.set("espZombie", v) end
			})

			local secTracers = tabVisual:AddLeftGroupbox("追踪线")
			secTracers:AddToggle("killerTracers", {
				Text = "杀手",
				Default = ESPSettings.killerTracers,
				Callback = function(v) ESPSettings.killerTracers = v; cfg.set("tracerKiller", v) end
			})
			secTracers:AddToggle("survivorTracers", {
				Text = "幸存者",
				Default = ESPSettings.survivorTracers,
				Callback = function(v) ESPSettings.survivorTracers = v; cfg.set("tracerSurvivor", v) end
			})
			secTracers:AddToggle("generatorTracers", {
				Text = "发电机",
				Default = ESPSettings.generatorTracers,
				Callback = function(v) ESPSettings.generatorTracers = v; cfg.set("tracerGenerator", v) end
			})
			secTracers:AddToggle("itemTracers", {
				Text = "物品",
				Default = ESPSettings.itemTracers,
				Callback = function(v) ESPSettings.itemTracers = v; cfg.set("tracerItem", v) end
			})
			secTracers:AddToggle("pizzaTracers", {
				Text = "披萨",
				Default = ESPSettings.pizzaTracers,
				Callback = function(v) ESPSettings.pizzaTracers = v; cfg.set("tracerPizza", v) end
			})
			secTracers:AddToggle("pizzaDeliveryTracers", {
				Text = "披萨配送员",
				Default = ESPSettings.pizzaDeliveryTracers,
				Callback = function(v) ESPSettings.pizzaDeliveryTracers = v; cfg.set("tracerPizzaDelivery", v) end
			})
			secTracers:AddToggle("zombieTracers", {
				Text = "僵尸",
				Default = ESPSettings.zombieTracers,
				Callback = function(v) ESPSettings.zombieTracers = v; cfg.set("tracerZombie", v) end
			})

			local secAppearanceESP = tabVisual:AddLeftGroupbox("外观设置")
			secAppearanceESP:AddToggle("killerNameESP", {
				Text = "杀手名称",
				Default = ESPSettings.killerNameESP,
				Callback = function(v) ESPSettings.killerNameESP = v; cfg.set("killerNameESP", v); UpdateAllPlayerESPText() end
			})
			secAppearanceESP:AddToggle("killerHealthESP", {
				Text = "杀手血量",
				Default = ESPSettings.killerHealthESP,
				Callback = function(v) ESPSettings.killerHealthESP = v; cfg.set("killerHealthESP", v); UpdateAllPlayerESPText() end
			})
			secAppearanceESP:AddToggle("killerSkinESP", {
				Text = "杀手皮肤",
				Default = ESPSettings.killerSkinESP,
				Callback = function(v) ESPSettings.killerSkinESP = v; cfg.set("killerSkinESP", v); UpdateAllPlayerESPText() end
			})
			secAppearanceESP:AddToggle("survivorNameESP", {
				Text = "幸存者名称",
				Default = ESPSettings.survivorNameESP,
				Callback = function(v) ESPSettings.survivorNameESP = v; cfg.set("survivorNameESP", v); UpdateAllPlayerESPText() end
			})
			secAppearanceESP:AddToggle("survivorHealthESP", {
				Text = "幸存者血量",
				Default = ESPSettings.survivorHealthESP,
				Callback = function(v) ESPSettings.survivorHealthESP = v; cfg.set("survivorHealthESP", v); UpdateAllPlayerESPText() end
			})
			secAppearanceESP:AddToggle("survivorSkinESP", {
				Text = "幸存者皮肤",
				Default = ESPSettings.survivorSkinESP,
				Callback = function(v) ESPSettings.survivorSkinESP = v; cfg.set("survivorSkinESP", v); UpdateAllPlayerESPText() end
			})
			secAppearanceESP:AddSlider("killerFillTransparency", {
				Text = "杀手填充透明度",
				Default = ESPSettings.killerFillTransparency, Min = 0, Max = 1, Rounding = 2,
				Callback = function(v) ESPSettings.killerFillTransparency = v; cfg.set("killerFillTrans", v) end
			})
			secAppearanceESP:AddSlider("killerOutlineTransparency", {
				Text = "杀手边框透明度",
				Default = ESPSettings.killerOutlineTransparency, Min = 0, Max = 1, Rounding = 2,
				Callback = function(v) ESPSettings.killerOutlineTransparency = v; cfg.set("killerOutlineTrans", v) end
			})
			secAppearanceESP:AddSlider("survivorFillTransparency", {
				Text = "幸存者填充透明度",
				Default = ESPSettings.survivorFillTransparency, Min = 0, Max = 1, Rounding = 2,
				Callback = function(v) ESPSettings.survivorFillTransparency = v; cfg.set("survivorFillTrans", v) end
			})
			secAppearanceESP:AddSlider("survivorOutlineTransparency", {
				Text = "幸存者边框透明度",
				Default = ESPSettings.survivorOutlineTransparency, Min = 0, Max = 1, Rounding = 2,
				Callback = function(v) ESPSettings.survivorOutlineTransparency = v; cfg.set("survivorOutlineTrans", v) end
			})

			-- ==================== 音乐选项卡（LMS） ====================
			local secLMS = tabMusic:AddLeftGroupbox("LMS 音乐")
			local music = { on=cfg.get("musicOn",false), selected=cfg.get("musicSel","CondemnedLMS"), cached={}, origId=nil, thread=nil }
			local musicDir = "v1prware/LMS_Songs"
			if not fs.hasFolder("v1prware") then fs.makeFolder("v1prware") end
			if not fs.hasFolder(musicDir) then fs.makeFolder(musicDir) end
			local musicTracks = {
				["AbberantLMS"] = "https://files.catbox.moe/4bb0g9.mp3",
				["OvertimeLMS"] = "https://files.catbox.moe/puf7xu.mp3",
				["PhotoshopLMS"] = "https://files.catbox.moe/yui8km.mp3",
				["JX1DX1LMS"] = "https://files.catbox.moe/52p5yh.mp3",
				["CondemnedLMS"] = "https://files.catbox.moe/l470am.mp3",
				["GeometryLMS"] = "https://files.catbox.moe/bqzc7u.mp3",
				["Milestone4LMS"] = "https://files.catbox.moe/z68ns9.mp3",
				["BluududLMS"] = "https://files.catbox.moe/gemz4k.mp3",
				["JohnDoeLMS"] = "https://files.catbox.moe/p72236.mp3",
				["ShedVS1xLMS"] = "https://files.catbox.moe/0q5v9p.mp3",
				["EternalIShallEndure"] = "https://files.catbox.moe/c3ohcm.mp3",
				["ChanceVSMafiosoLMS"] = "https://files.catbox.moe/0hlm8m.mp3",
				["JohnVsJaneLMS"] = "https://files.catbox.moe/inonzr.mp3",
				["SceneSlasherLMS"] = "https://files.catbox.moe/ap3x4x.mp3",
				["SynonymsForEternity"] = "https://files.catbox.moe/uj45ih.mp3",
				["EternityEpicfied"] = "https://files.catbox.moe/yrmpvx.mp3",
				["EternalHopeEternalFight"] = "https://files.catbox.moe/xdm5q8.mp3",
			}
			local musicList = {}; for k in pairs(musicTracks) do table.insert(musicList, k) end; table.sort(musicList)
			local function musicFetch(name)
				if music.cached[name] then return music.cached[name] end
				local url=musicTracks[name]; if not url then return nil end
				local path=musicDir.."/"..name:gsub("[^%w]","_")..".mp3"
				if not fs.hasFile(path) then local ok,data=pcall(function() return game:HttpGet(url) end); if not ok or not data or #data==0 then return nil end; fs.write(path,data) end
				music.cached[name]=fs.asset(path); return music.cached[name]
			end
			local function musicGetSound()
				local t = svc.WS:FindFirstChild("Themes")
				if not t then return nil end
				return t:FindFirstChild("LastSurvivor") or t:FindFirstChild("LastSurvivor", true)
			end
			local function musicPlay(name)
				local snd=musicGetSound(); if not snd then return false end
				if not music.origId then music.origId=snd.SoundId end
				local asset=musicFetch(name); if not asset then return false end
				snd.SoundId=asset; snd:Stop(); task.wait(); snd:Play(); return true
			end
			local function musicReset() local snd=musicGetSound(); if snd and music.origId then snd.SoundId=music.origId; snd:Stop(); task.wait(); snd:Play() end end
			local function musicIsLMS()
				local sf=getTeamFolder("Survivors")
				if sf then local alive=0; for _,s in ipairs(sf:GetChildren()) do local h=s:FindFirstChildOfClass("Humanoid"); if h and h.Health>0 then alive+=1 end end; if alive==1 then return true end end
				local snd=musicGetSound(); return snd and snd.IsPlaying and (not music.origId or snd.SoundId~=music.origId)
			end
			local function musicMonitor()
				local i=0
				while music.on and i<2000 do
					i+=1
					if musicIsLMS() then
						local snd=musicGetSound()
						if not snd or not snd.IsPlaying or snd.SoundId~=(music.cached[music.selected] or "") then musicPlay(music.selected) end
						task.wait(3)
					else task.wait(1) end
				end
			end
			secLMS:AddToggle("musicOn", { Text="LMS 自动播放", Default=music.on, Callback=function(on) music.on=on; cfg.set("musicOn",on); if on then music.thread=task.spawn(musicMonitor) else if music.thread then task.cancel(music.thread); music.thread=nil end; musicReset() end end })
			secLMS:AddDropdown("musicSel", { Text="曲目", Values=musicList, Default=music.selected, Callback=function(sel) music.selected=type(sel)=="table" and sel[1] or sel; cfg.set("musicSel",music.selected); task.spawn(function()musicFetch(music.selected)end) end })
			secLMS:AddButton({ Text="▶ 播放", Func=function() musicPlay(music.selected) end })
			secLMS:AddButton({ Text="■ 停止", Func=function() musicReset() end })
			secLMS:AddButton({ Text="↓ 预加载 LMS", Func=function() for name in pairs(musicTracks) do task.spawn(function()musicFetch(name)end); task.wait(0.1) end end })
			lp.CharacterAdded:Connect(function() task.wait(3); if music.on then if music.thread then task.cancel(music.thread) end; music.thread=task.spawn(musicMonitor) end end)

			-- ==================== 哨兵选项卡（Elliot, Chance, TwoTime） ====================
			local secSurvivors = tabSurSen:AddLeftGroupbox("幸存者")

			-- Elliot 自瞄
			do
				local elliotSection = tabSurSen:AddLeftGroupbox("Elliot 自瞄")
				local elliotEnabled = false
				local elliotConnection = nil
				local elliotAutoRotBak = nil
				local elliotPredDist = 5
				local elliotVelThresh = 16
				local elliotAimType = "相机 + 角色"
				local elliotThrowDur = 0.5
				local elliotIsThrowing = false
				local elliotThrowTS = 0
				local elliotRequireAnim = true
				local elliotShowArc = false
				local elliotArcFolder = nil
				local elliotArcParts = {}
				local elliotArcSegs = 50
				local elliotThrowForce = 80
				local elliotUpComp = 0.5
				local elliotGravity = 196.2
				local elliotHum, elliotHRP = nil, nil
				local elliotCamera = svc.WS.CurrentCamera

				local function elliotSetupChar(char)
					elliotHum = char:WaitForChild("Humanoid")
					elliotHRP = char:WaitForChild("HumanoidRootPart")
				end
				if lp.Character then elliotSetupChar(lp.Character) end
				lp.CharacterAdded:Connect(function(c) elliotSetupChar(c) end)

				task.spawn(function()
					local ok, re = pcall(function()
						return svc.RS:WaitForChild("Modules",5):WaitForChild("Network",5):WaitForChild("RemoteEvent",5)
					end)
					if ok and re then
						local oldNC
						oldNC = hookmetamethod(game,"__namecall",function(self,...)
							local method = getnamecallmethod()
							local args = {...}
							if method=="FireServer" and self==re then
								if args[1]=="UseActorAbility" and args[2] and args[2][1] then
									local ok2, bs = pcall(function() return buffer.tostring(args[2][1]) end)
									if ok2 and bs and string.find(bs,"ThrowPizza") then
										elliotIsThrowing = true
										elliotThrowTS    = tick()
									end
								end
							end
							return oldNC(self,...)
						end)
					end
				end)

				local function elliotClearArc()
					for _, p in ipairs(elliotArcParts) do if p and p.Parent then p:Destroy() end end
					elliotArcParts = {}
				end
				local function elliotCreateArcFolder()
					if elliotArcFolder then elliotArcFolder:Destroy() end
					elliotArcFolder = Instance.new("Folder"); elliotArcFolder.Name="ElliotArc"; elliotArcFolder.Parent=svc.WS
				end

				local function elliotFindTarget()
					local sf = svc.WS:FindFirstChild("Players") and svc.WS.Players:FindFirstChild("Survivors")
					if not sf then sf = svc.WS:FindFirstChild("Survivors") end
					if not sf or not elliotHRP then return nil end
					local best, bestHP = nil, math.huge
					for _, s in ipairs(sf:GetChildren()) do
						if s ~= lp.Character then
							local h = s:FindFirstChildOfClass("Humanoid")
							local r = s:FindFirstChild("HumanoidRootPart")
							if h and r and h.Health > 0 and h.Health < bestHP then
								best = r; bestHP = h.Health
							end
						end
					end
					return best
				end

				local function elliotAimAt(tgt)
					if not tgt or not tgt.Parent then return end
					local vel = tgt.AssemblyLinearVelocity
					local pos = tgt.Position
					local predPos = pos + (tgt.CFrame.LookVector * 2)
					if vel.Magnitude > elliotVelThresh then predPos = predPos + (vel.Unit * elliotPredDist) end
					if elliotAimType == "HRP 自瞄" or elliotAimType == "相机 + 角色" then
						if elliotHRP then
							if not elliotAutoRotBak then elliotAutoRotBak = elliotHum.AutoRotate end
							elliotHum.AutoRotate = false
							elliotHRP.AssemblyAngularVelocity = Vector3.new(0,0,0)
							local dir = (predPos - elliotHRP.Position)
							local flat = Vector3.new(dir.X,0,dir.Z).Unit
							local tCF = CFrame.new(elliotHRP.Position, elliotHRP.Position + flat)
							local cur = elliotHRP.CFrame
							local nCF = cur:Lerp(tCF, 0.35)
							elliotHRP.CFrame = CFrame.new(cur.Position) * (nCF - nCF.Position)
						end
					end
					if elliotAimType == "相机自瞄" or elliotAimType == "相机 + 角色" then
						elliotCamera.CFrame = CFrame.lookAt(elliotCamera.CFrame.Position, predPos)
					end
				end

				local function elliotArcCalc(startPos, lookVec)
					local dir = (lookVec + Vector3.new(0, elliotUpComp, 0)).Unit
					local iv   = dir * elliotThrowForce
					local maxT = 3
					local pts  = {}
					local step = maxT / elliotArcSegs
					local last = startPos
					local rp   = RaycastParams.new()
					rp.FilterType = Enum.RaycastFilterType.Exclude
					rp.FilterDescendantsInstances = { lp.Character, elliotArcFolder }
					for i = 0, elliotArcSegs do
						local t   = i * step
						local pos = startPos + iv*t + Vector3.new(0,-0.5*elliotGravity*t*t,0)
						if i > 0 then
							local d = pos - last
							local dm = d.Magnitude
							if dm > 0 then
								local res = svc.WS:Raycast(last, d.Unit*dm, rp)
								if res then table.insert(pts, res.Position); break end
							end
						end
						if pos.Y < -100 then break end
						table.insert(pts, pos); last = pos
					end
					return pts
				end

				local _elliotLastArcUpdate = 0
				local function elliotUpdateArc()
					if not elliotShowArc or not elliotHRP then elliotClearArc(); return end
					local now = tick()
					if now - _elliotLastArcUpdate < 0.1 then return end
					_elliotLastArcUpdate = now
					local char = lp.Character
					local lArm = char and (char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand") or char:FindFirstChild("LeftLowerArm"))
					local startPos = lArm and lArm.Position or (elliotHRP.Position + Vector3.new(-1,1,0) + elliotHRP.CFrame.LookVector*2)
					local pts = elliotArcCalc(startPos, elliotHRP.CFrame.LookVector)
					elliotClearArc()
					if not elliotArcFolder then elliotCreateArcFolder() end
					for i, p in ipairs(pts) do
						local part = Instance.new("Part"); part.Name="ArcSeg"..i; part.Size=Vector3.new(0.25,0.25,0.25)
						part.Position=p; part.Anchored=true; part.CanCollide=false; part.Material=Enum.Material.Neon
						part.Shape=Enum.PartType.Ball
						if i == #pts and #pts > 1 then part.Size=Vector3.new(0.5,0.5,0.5); part.Color=Color3.fromRGB(255,255,0); part.Transparency=0
						else part.Color=Color3.fromRGB(255,0,0); part.Transparency=0.15 end
						part.Parent=elliotArcFolder; table.insert(elliotArcParts, part)
					end
				end

				elliotSection:AddSlider("elliotPredDist", { Text="预判距离 (studs)", Default=5, Min=0, Max=50, Callback=function(v) elliotPredDist=v end })
				elliotSection:AddSlider("elliotThrowDur", { Text="瞄准持续时间 (秒)", Default=0.5, Min=0.1, Max=2, Rounding=1, Callback=function(v) elliotThrowDur=v end })
				elliotSection:AddSlider("elliotThrowForce", { Text="披萨投掷力度", Default=80, Min=50, Max=150, Rounding=0, Callback=function(v) elliotThrowForce=v end })
				elliotSection:AddSlider("elliotArcSegs", { Text="弧线段数", Default=50, Min=20, Max=100, Rounding=0, Callback=function(v) elliotArcSegs=v end })
				elliotSection:AddDropdown("elliotAimType", { Text="自瞄类型", Values={"HRP 自瞄","相机自瞄","相机 + 角色"}, Default="相机 + 角色", Callback=function(v) elliotAimType=v end })
				elliotSection:AddToggle("elliotShowArc", { Text="显示披萨弧线", Default=false, Callback=function(v)
					elliotShowArc=v
					if v then elliotCreateArcFolder()
					else elliotClearArc(); if elliotArcFolder then elliotArcFolder:Destroy(); elliotArcFolder=nil end
				end end })
				elliotSection:AddToggle("elliotRequireAnim", { Text="需要投掷动画", Default=true, Callback=function(v) elliotRequireAnim=v end })
				elliotSection:AddToggle("elliotEnabled", { Text="启用 Elliot 自瞄", Default=false, Callback=function(v)
					elliotEnabled = v
					if v then
						elliotConnection = svc.Run.RenderStepped:Connect(function()
							if not elliotEnabled or not elliotHum or not elliotHRP then return end
							if elliotIsThrowing and (tick()-elliotThrowTS)>elliotThrowDur then elliotIsThrowing=false end
							if elliotShowArc then elliotUpdateArc() end
							local shouldAim = elliotRequireAnim and elliotIsThrowing or (not elliotRequireAnim)
							if not shouldAim then
								if elliotAutoRotBak ~= nil then elliotHum.AutoRotate=elliotAutoRotBak; elliotAutoRotBak=nil end
								return
							end
							local tgt = elliotFindTarget()
							if not tgt then
								if elliotAutoRotBak ~= nil then elliotHum.AutoRotate=elliotAutoRotBak; elliotAutoRotBak=nil end
								return
							end
							elliotAimAt(tgt)
						end)
					else
						if elliotConnection then elliotConnection:Disconnect(); elliotConnection=nil end
						if elliotAutoRotBak ~= nil then elliotHum.AutoRotate=elliotAutoRotBak; elliotAutoRotBak=nil end
						elliotClearArc()
					end
				end })
			end

			-- Chance 自瞄
			do
				local chanceSection = tabSurSen:AddLeftGroupbox("Chance 自瞄")
				local chanceAimEnabled = false
				local chancePredMode = "速度"
				local chancePredValue = 0.5
				local chanceAimBehavior = "正常"
				local chanceSpinDur = 0.5
				local chanceMsgOnAim = false
				local chanceMsgText = ""
				local chanceCustomAnim = false
				local chanceCustomAnimID = ""
				local chanceAntiBait = true
				local chanceSmoothSpeed = 14
				local chanceHeightAim = true
				local chanceHoldToAim = true
				local chanceAimKey = Enum.KeyCode.Q
				local chanceHoldingKey = false
				local chanceAiming = false
				local chanceStartTime = 0
				local chanceAimDuration = 1.7

				local chanceKillerSpeeds = {
					Slasher={walk=9,run=28}, c00lkidd={walk=7.75,run=28}, JohnDoe={walk=9,run=27.25},
					["1x1x1x1"]={walk=8.5,run=27}, Noli={walk=7.5,run=27.5}, Guest666={walk=9,run=27},
					Nosferatu={walk=7.25,run=27.5}, Doombringer={walk=8,run=27}, JaneDoe={walk=9,run=27},
					Builderman={walk=8.5,run=27.5}, Dusekkar={walk=8,run=27.5},
				}

				local chanceHum, chanceHRP, chanceBodyGyro, chanceSavedAutoRotate
				local function chanceSetChar(c) chanceHum=c:WaitForChild("Humanoid"); chanceHRP=c:WaitForChild("HumanoidRootPart") end
				if lp.Character then chanceSetChar(lp.Character) end
				lp.CharacterAdded:Connect(chanceSetChar)

				local chanceMotion = {}
				local function chanceGetMotion(hrp)
					local now=tick(); local pos=hrp.Position; local data=chanceMotion[hrp]
					if not data then chanceMotion[hrp]={lastPos=pos,lastTime=now,velocity=Vector3.zero,accel=Vector3.zero}; return Vector3.zero,Vector3.zero end
					local dt=now-data.lastTime; if dt<=0 then return data.velocity,data.accel end
					local vel=(pos-data.lastPos)/dt; local acc=(vel-data.velocity)/dt
					data.lastPos=pos; data.lastTime=now; data.accel=acc; data.velocity=vel
					return vel,acc
				end

				local chancePingSamples={}
				local _chanceLastPingTime=0
				local _chanceLastPingVal=0.1
				local function chanceGetPing()
					local now=tick()
					if now-_chanceLastPingTime<1 then return _chanceLastPingVal end
					_chanceLastPingTime=now
					local ok,stat=pcall(function() return svc.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
					local raw=(ok and stat or 100)/1000
					table.insert(chancePingSamples,raw); if #chancePingSamples>5 then table.remove(chancePingSamples,1) end
					local s=0; for _,v in ipairs(chancePingSamples) do s=s+v end
					_chanceLastPingVal=s/#chancePingSamples
					return _chanceLastPingVal
				end

				local function chanceGetNearest()
					if not chanceHRP then return end
					local folder=svc.WS:FindFirstChild("Players"); folder=folder and folder:FindFirstChild("Killers"); if not folder then return end
					local closest,dist=nil,math.huge
					for _,m in ipairs(folder:GetChildren()) do
						local r=m:FindFirstChild("HumanoidRootPart"); local h=m:FindFirstChildOfClass("Humanoid")
						if r and h and h.Health>0 then local d=(r.Position-chanceHRP.Position).Magnitude; if d<dist then dist=d; closest=r end end
					end
					return closest
				end

				local function chancePredict(hrp)
					local vel,accel=chanceGetMotion(hrp); local pos=hrp.Position; local speed=vel.Magnitude
					if chanceAntiBait then
						local model=hrp.Parent
						if model and chanceKillerSpeeds[model.Name] then
							local maxSpd=chanceKillerSpeeds[model.Name].run+2
							if speed>maxSpd then vel=vel.Unit*maxSpd; speed=maxSpd end
						end
					end
					local ping=chanceGetPing(); local dist=chanceHRP and (hrp.Position-chanceHRP.Position).Magnitude or 0
					local ds=dist*0.003; local lead
					if chancePredMode=="速度" then lead=chancePredValue+ds
					elseif chancePredMode=="延迟" then lead=ping*chancePredValue+ds
					elseif chancePredMode=="视线" then return pos+hrp.CFrame.LookVector*(speed*chancePredValue)
					elseif chancePredMode=="视线+延迟" then return pos+hrp.CFrame.LookVector*(speed*ping)
					else lead=chancePredValue end
					if chanceHRP and speed>1 then
						local toK=(hrp.Position-chanceHRP.Position).Unit
						local straf=math.abs(vel.Unit:Dot(Vector3.new(-toK.Z,0,toK.X)))
						if straf>0.5 then lead=lead+straf*0.06 end
					end
					if speed<0.5 then return pos end
					local ac=accel*lead*lead*0.5
					if ac.Magnitude>speed*0.4 then ac=ac.Unit*(speed*0.4) end
					return pos+vel*lead+ac
				end

				local function chanceHookAnimator(char)
					local hum=char:WaitForChild("Humanoid"); local anim=hum:WaitForChild("Animator")
					local chanceTriggers={["133607163653602"]=true,["133491532453922"]=true,["131189930305001"]=true,["111384272984267"]=true,["103601716322988"]=true,["76649505662612"]=true}
					anim.AnimationPlayed:Connect(function(track)
						if not chanceAimEnabled or chanceHoldToAim then return end
						local id=track.Animation.AnimationId:match("%d+")
						if id and chanceTriggers[id] then
							if chanceHum then chanceSavedAutoRotate = chanceHum.AutoRotate; chanceHum.AutoRotate = false end
							chanceAiming=true; chanceStartTime=tick()
							if chanceMsgOnAim and chanceMsgText~="" then
								local ch=svc.TextChat.TextChannels.RBXGeneral
								if ch then pcall(ch.SendAsync,ch,chanceMsgText) end
							end
							if chanceCustomAnim and tonumber(chanceCustomAnimID) then
								local a=Instance.new("Animation"); a.AnimationId="rbxassetid://"..chanceCustomAnimID
								hum.Animator:LoadAnimation(a):Play()
							end
							track.Ended:Connect(function()
								if chanceHum and chanceSavedAutoRotate ~= nil then chanceHum.AutoRotate = chanceSavedAutoRotate end
								if chanceBodyGyro and chanceBodyGyro.Parent then chanceBodyGyro:Destroy(); chanceBodyGyro = nil end
								chanceAiming = false
							end)
						end
					end)
				end
				if lp.Character then chanceHookAnimator(lp.Character) end
				lp.CharacterAdded:Connect(chanceHookAnimator)

				svc.Input.InputBegan:Connect(function(input,gpe)
					if gpe then return end
					if chanceHoldToAim and input.KeyCode==chanceAimKey then chanceHoldingKey=true; chanceAiming=true; chanceStartTime=tick() end
				end)
				svc.Input.InputEnded:Connect(function(input)
					if chanceHoldToAim and input.KeyCode==chanceAimKey then chanceHoldingKey=false; chanceAiming=false end
				end)

				svc.Run.RenderStepped:Connect(function()
					if not chanceAimEnabled or not chanceHRP then return end
					if chanceHoldToAim then if not chanceHoldingKey then return end
					else if not chanceAiming then return end; if tick()-chanceStartTime>chanceAimDuration then chanceAiming=false; return end end
					local target=chanceGetNearest(); if not target then return end
					local pos=chancePredict(target); if not pos then return end
					local aimPos=chanceHeightAim and pos or Vector3.new(pos.X,chanceHRP.Position.Y,pos.Z)
					if chanceAimBehavior=="360" then
						local prog=(tick()-chanceStartTime)/chanceSpinDur
						if prog<1 then chanceHRP.CFrame=CFrame.new(chanceHRP.Position)*CFrame.Angles(0,math.rad(360*prog),0); return end
					end
					if not chanceBodyGyro or not chanceBodyGyro.Parent then
						chanceBodyGyro = Instance.new("BodyGyro")
						chanceBodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
						chanceBodyGyro.P = 10000; chanceBodyGyro.D = 500
						chanceBodyGyro.Parent = chanceHRP
					end
					chanceBodyGyro.CFrame = CFrame.lookAt(chanceHRP.Position, aimPos)
				end)

				chanceSection:AddToggle("chanceAimEnabled", { Text="启用自瞄", Default=false, Callback=function(v) chanceAimEnabled=v end })
				chanceSection:AddDropdown("chancePredMode", { Text="预测模式", Values={"速度","延迟","视线","视线+延迟"}, Default="速度", Callback=function(v) chancePredMode=v end })
				chanceSection:AddInput("chancePredValue", { Text="预测值", Default="0.5", Callback=function(v) local n=tonumber(v); if n then chancePredValue=n end end })
				chanceSection:AddSlider("chanceSmoothSpeed", { Text="平滑速度", Default=14, Min=1, Max=30, Callback=function(v) chanceSmoothSpeed=v end })
				chanceSection:AddToggle("chanceHeightAim", { Text="高度感知瞄准", Default=true, Callback=function(v) chanceHeightAim=v end })
				chanceSection:AddDropdown("chanceAimBehavior", { Text="瞄准行为", Values={"正常","360"}, Default="正常", Callback=function(v) chanceAimBehavior=v end })
				chanceSection:AddInput("chanceSpinDur", { Text="旋转持续时间", Default="0.5", Callback=function(v) local n=tonumber(v); if n then chanceSpinDur=n end end })
				chanceSection:AddToggle("chanceAntiBait", { Text="反诱饵", Default=true, Callback=function(v) chanceAntiBait=v end })
				chanceSection:AddToggle("chanceHoldToAim", { Text="按住瞄准", Default=true, Callback=function(v) chanceHoldToAim=v end })
				chanceSection:AddDropdown("chanceAimKey", { Text="瞄准键", Values={"Q","E","R","T","F","G","X","C","V"}, Default="Q", Callback=function(v) chanceAimKey=Enum.KeyCode[v] end })
				chanceSection:AddToggle("chanceMsgOnAim", { Text="瞄准时发送消息", Default=false, Callback=function(v) chanceMsgOnAim=v end })
				chanceSection:AddInput("chanceMsgText", { Text="消息文本", Callback=function(v) chanceMsgText=v end })
				chanceSection:AddButton({ Text="延迟瞄准预设", Func=function()
					chanceAimEnabled=true; chancePredMode="延迟"; chancePredValue=1.5
					Library:Notify("预设已应用\n延迟模式，值 1.5", 3)
				end })
				chanceSection:AddButton({ Text="作者推荐设置", Func=function()
					Library:Notify("0.5 最适合 90-120 延迟\n同样延迟 1.5\n如果高延迟用 0.4 速度\n否则 1.3 延迟", 10)
				end })
				chanceSection:AddButton({ Text="测试员推荐设置", Func=function()
					Library:Notify("60 延迟 → 0.1-0.2\n120 延迟 → ~0.5\n200-300 延迟 → 别用", 10)
				end })
				chanceSection:AddToggle("chanceCustomAnim", { Text="自定义射击动画", Default=false, Callback=function(v) chanceCustomAnim=v end })
				chanceSection:AddInput("chanceCustomAnimID", { Text="动画 ID", Callback=function(v) chanceCustomAnimID=v end })
			end

			-- TwoTime 背刺
			do
				local bsSection = tabSurSen:AddLeftGroupbox("TwoTime 背刺")
				local BS_BACKSTAB_THRESHOLD_COS = math.cos(math.rad(70))
				local BS_SERVER_WINDUP = 0.30
				local BS_HITBOX_TIME_UNCROUCHED = 0.25
				local BS_DEFAULT_PROXIMITY = 8
				local BS_DASH_FLIP_DELAY = 0.38
				local BS_LUNGE_HOLD_DURATION = BS_HITBOX_TIME_UNCROUCHED
				local BS_DEPTH_OFFSET = 2.0
				local BS_LERP_SPEED = 0.37 * 1.6
				local BS_AIM_SNAP_DELAY = 0.25
				local BS_CHECK_INTERVAL = 0.05
				local BS_COOLDOWN = 5.0

				local bsRunning = true
				local bsEnabled = false
				local bsDaggerEnabled = false
				local bsMode = "自动背刺"
				local bsBaseProximity = BS_DEFAULT_PROXIMITY
				local bsSuppressCallback = false
				local bsLastTrigger = 0
				local bsAimRefCount = 0

				local BS_SPRINT_THRESHOLD = 26.7
				local BS_RANGE_SPRINT_BONUS = 10
				local bsKillerSpeedCache = {}
				local bsKillerSprintLatch = {}
				local bsLastDisplayedRange = BS_DEFAULT_PROXIMITY
				local bsDetectionRangeSlider = nil

				local function bsGetChar() return lp.Character or lp.CharacterAdded:Wait() end
				local function bsGetDaggerButton()
					local pg = lp:FindFirstChild("PlayerGui"); if not pg then return nil end
					local mainUI = pg:FindFirstChild("MainUI"); if not mainUI then return nil end
					local container = mainUI:FindFirstChild("AbilityContainer"); if not container then return nil end
					return container:FindFirstChild("Dagger")
				end
				local function bsGetDaggerCooldown()
					local btn = bsGetDaggerButton(); if not btn then return nil end
					return btn:FindFirstChild("CooldownTime") or btn:FindFirstChild("Cooldown")
						or btn:FindFirstChildWhichIsA("NumberValue") or btn:FindFirstChildWhichIsA("StringValue")
						or btn:FindFirstChild("CooldownLabel") or btn:FindFirstChild("Timer") or btn:FindFirstChild("CD")
				end
				local function bsReadCooldown(cdObj)
					if not cdObj then return nil end
					if cdObj:IsA("NumberValue") then return cdObj.Value end
					if cdObj:IsA("StringValue") then return tonumber(cdObj.Value) end
					if cdObj:IsA("TextLabel") or cdObj:IsA("TextBox") then return tonumber(cdObj.Text) end
					if type(cdObj.Value)=="number" then return cdObj.Value end
					if type(cdObj.Value)=="string" then return tonumber(cdObj.Value) end
					if cdObj.Text ~= nil then return tonumber(cdObj.Text) end
					return nil
				end
				local function bsGetKillersFolder()
					local pf = svc.WS:FindFirstChild("Players"); if not pf then return nil end
					return pf:FindFirstChild("Killers")
				end
				local function bsIsValidKiller(model)
					if not model then return false end
					local hrp = model:FindFirstChild("HumanoidRootPart"); local hum = model:FindFirstChildWhichIsA("Humanoid")
					return hrp and hum and hum.Health and hum.Health>0
				end
				local function bsTryActivateButton(btn)
					if not btn then return false end
					pcall(function() if btn.Activate then btn:Activate() end end)
					local ok,conns = pcall(function()
						if type(getconnections)=="function" and btn.MouseButton1Click then return getconnections(btn.MouseButton1Click) end
						return nil
					end)
					if ok and conns then
						for _,conn in ipairs(conns) do
							pcall(function()
								if conn.Function then conn.Function()
								elseif conn.func then conn.func()
								elseif conn.Fire then conn.Fire() end
							end)
						end
					end
					pcall(function() if btn.Activated then btn.Activated:Fire() end end)
					return true
				end
				local function bsSetAutoRotate(val)
					local char = lp.Character; if not char then return end
					local hum = char:FindFirstChildWhichIsA("Humanoid")
					if hum then pcall(function() hum.AutoRotate = val end) end
				end
				local function bsGetKillerSpeed(killer)
					local khrp = killer:FindFirstChild("HumanoidRootPart"); if not khrp then return 0 end
					local now = os.clock(); local cache = bsKillerSpeedCache[killer]; local speed = 0
					if cache then
						local dt = now - cache.t
						if dt > 0 then local dp = khrp.Position - cache.pos; speed = Vector3.new(dp.X,0,dp.Z).Magnitude / dt end
					end
					bsKillerSpeedCache[killer] = {pos = khrp.Position, t = now}
					return speed
				end

				local function bsAimAtKiller(killerModel, duration)
					if not killerModel or not bsRunning then return end
					local char = bsGetChar(); local hum = char and char:FindFirstChildWhichIsA("Humanoid")
					local hrp = char and char:FindFirstChild("HumanoidRootPart"); local khrp = killerModel:FindFirstChild("HumanoidRootPart")
					if not hum or not hrp or not khrp then return end
					bsAimRefCount = bsAimRefCount + 1
					if bsAimRefCount == 1 then pcall(function() hum.AutoRotate = false end) end
					local function finish() bsAimRefCount = math.max(0, bsAimRefCount - 1); if bsAimRefCount == 0 then bsSetAutoRotate(true) end end
					local t0 = os.clock(); local conn
					conn = svc.Run.Heartbeat:Connect(function()
						if not bsRunning or os.clock() - t0 >= duration then conn:Disconnect(); finish(); return end
						if khrp and hrp then
							local tgt = Vector3.new(khrp.Position.X, hrp.Position.Y, khrp.Position.Z)
							hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(hrp.Position, tgt), BS_LERP_SPEED)
						end
					end)
				end

				local function bsPerformDashStabTech(killerModel)
					if not killerModel or not bsRunning then return end
					local char = bsGetChar(); local hrp = char and char:FindFirstChild("HumanoidRootPart")
					local khrp = killerModel:FindFirstChild("HumanoidRootPart")
					if not hrp or not khrp then return end
					bsSetAutoRotate(false)
					local aimTarget = Vector3.new(khrp.Position.X, hrp.Position.Y, khrp.Position.Z)
					hrp.CFrame = CFrame.lookAt(hrp.Position, aimTarget, Vector3.new(0,1,0))
					if bsDaggerEnabled then bsTryActivateButton(bsGetDaggerButton()) end
					task.wait(BS_DASH_FLIP_DELAY)
					if not bsRunning then bsSetAutoRotate(true); return end
					local holdStart = os.clock(); local firstFrame = true; local holdConn
					holdConn = svc.Run.Heartbeat:Connect(function()
						if not bsRunning or os.clock() - holdStart >= BS_LUNGE_HOLD_DURATION then
							holdConn:Disconnect(); bsSetAutoRotate(true); return
						end
						local khrp2 = killerModel:FindFirstChild("HumanoidRootPart")
						local char2 = bsGetChar(); local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
						if khrp2 and hrp2 then
							local look = khrp2.CFrame.LookVector
							local nudgedPos = hrp2.Position
							if firstFrame then
								firstFrame = false
								nudgedPos = Vector3.new(hrp2.Position.X + look.X * BS_DEPTH_OFFSET, hrp2.Position.Y, hrp2.Position.Z + look.Z * BS_DEPTH_OFFSET)
							end
							hrp2.CFrame = CFrame.lookAt(nudgedPos, nudgedPos + look, Vector3.new(0,1,0))
						end
					end)
				end

				local bsRadiusParts = {}
				local bsShowRadius = true
				local bsNoclipEnabled = false
				local bsNoclipConn = nil

				local function bsGetOrCreateRadiusPart(killer)
					if bsRadiusParts[killer] then return bsRadiusParts[killer] end
					local part = Instance.new("Part")
					part.Name = "V1PRWARERadius"; part.Anchored = true; part.CanCollide = false
					part.CanQuery = false; part.CanTouch = false; part.CastShadow = false
					part.Shape = Enum.PartType.Cylinder; part.Material = Enum.Material.Neon
					part.Transparency = 0.65; part.Color = Color3.fromRGB(0,200,255)
					part.Size = Vector3.new(0.15,2,2); part.Parent = svc.WS
					bsRadiusParts[killer] = part
					killer.AncestryChanged:Connect(function()
						if not killer:IsDescendantOf(svc.WS) then part:Destroy(); bsRadiusParts[killer] = nil end
					end)
					return part
				end
				local function bsDestroyAllRadiusParts()
					for _,part in pairs(bsRadiusParts) do pcall(function() part:Destroy() end) end
					bsRadiusParts = {}
				end
				local function bsUpdateRadiusPart(killer, khrp, range, inside)
					if not bsShowRadius then
						local existing = bsRadiusParts[killer]
						if existing then existing:Destroy(); bsRadiusParts[killer] = nil end
						return
					end
					local part = bsGetOrCreateRadiusPart(killer)
					local diameter = range * 2
					local footY = khrp.Position.Y - 3
					part.Size = Vector3.new(0.15, diameter, diameter)
					part.CFrame = CFrame.new(khrp.Position.X, footY, khrp.Position.Z) * CFrame.Angles(0,0,math.pi/2)
					if inside then
						local pulse = 0.5 + 0.5 * math.sin(os.clock() * 8)
						part.Color = Color3.fromRGB(255, math.floor(pulse * 80), 0)
						part.Transparency = 0.3 + pulse * 0.2
					else
						part.Color = Color3.fromRGB(0,180,255)
						part.Transparency = 0.65
					end
				end

				local bsOverlapParams = OverlapParams.new()
				bsOverlapParams.FilterType = Enum.RaycastFilterType.Exclude

				local function bsIsPlayerPart(part)
					for _, plr in ipairs(svc.Players:GetPlayers()) do
						if plr.Character and part:IsDescendantOf(plr.Character) then return true end
					end
					return false
				end
				local function bsRevertCanCollide()
					local char = lp.Character; if not char then return end
					for _, part in ipairs(char:GetDescendants()) do
						if part:IsA("BasePart") then part.CanCollide = true end
					end
				end
				local function bsSetNoclip(state)
					bsNoclipEnabled = state
					if bsNoclipConn then bsNoclipConn:Disconnect(); bsNoclipConn = nil end
					if not state then bsRevertCanCollide(); return end
					bsNoclipConn = svc.Run.Stepped:Connect(function()
						local char = lp.Character; if not char then return end
						bsOverlapParams.FilterDescendantsInstances = { char }
						for _, part in ipairs(char:GetDescendants()) do
							if not part:IsA("BasePart") then continue end
							local touching = workspace:GetPartsInPart(part, bsOverlapParams)
							local nearPlayer = false
							for _, hit in ipairs(touching) do
								if bsIsPlayerPart(hit) then nearPlayer = true; break end
							end
							part.CanCollide = not nearPlayer
						end
					end)
				end

				local bsCrouchStabEnabled = false
				local bsCrouchStabConn = nil
				local bsCrouchStabDelay = 0.10

				local function bsGetCrouchButton()
					local pg = lp:FindFirstChild("PlayerGui"); if not pg then return nil end
					local mainUI = pg:FindFirstChild("MainUI"); if not mainUI then return nil end
					local ac = mainUI:FindFirstChild("AbilityContainer"); if not ac then return nil end
					return ac:FindFirstChild("Crouch")
				end
				local function bsStartCrouchStab()
					if bsCrouchStabConn then bsCrouchStabConn:Disconnect() end
					local btn = bsGetCrouchButton()
					if not btn then return end
					bsCrouchStabConn = btn.MouseButton1Down:Connect(function()
						if not bsCrouchStabEnabled then return end
						local cdNum = bsReadCooldown(bsGetDaggerCooldown())
						if cdNum and cdNum > 0.1 then return end
						task.spawn(function() task.wait(bsCrouchStabDelay); bsTryActivateButton(bsGetDaggerButton()) end)
					end)
				end
				local function bsStopCrouchStab()
					if bsCrouchStabConn then bsCrouchStabConn:Disconnect(); bsCrouchStabConn = nil end
				end
				task.spawn(function() task.wait(2); bsStartCrouchStab() end)
				lp.CharacterAdded:Connect(function() task.wait(2); if bsCrouchStabEnabled then bsStartCrouchStab() end end)

				task.spawn(function()
					while bsRunning do
						task.wait(BS_CHECK_INTERVAL)
						if not bsEnabled or not bsRunning then continue end
						local kf = bsGetKillersFolder(); if not kf then continue end
						local char = bsGetChar(); local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
						for _,killer in pairs(kf:GetChildren()) do
							if not bsIsValidKiller(killer) then continue end
							local khrp = killer:FindFirstChild("HumanoidRootPart")
							local dist = (khrp.Position - hrp.Position).Magnitude
							local killerSpeed = bsGetKillerSpeed(killer)
							local nowClock = os.clock()
							if killerSpeed > BS_SPRINT_THRESHOLD then bsKillerSprintLatch[killer] = nowClock end
							local latchAge = bsKillerSprintLatch[killer] and (nowClock - bsKillerSprintLatch[killer]) or math.huge
							local isSprinting = killerSpeed > BS_SPRINT_THRESHOLD or latchAge < 0.06
							local effectiveRange = bsBaseProximity + (isSprinting and BS_RANGE_SPRINT_BONUS or 0)
							if bsDetectionRangeSlider and effectiveRange ~= bsLastDisplayedRange then
								bsLastDisplayedRange = effectiveRange; bsSuppressCallback = true
								pcall(function() bsDetectionRangeSlider:SetValue(effectiveRange) end)
								bsSuppressCallback = false
							end
							local inside = dist <= effectiveRange
							bsUpdateRadiusPart(killer, khrp, effectiveRange, inside)
							if bsMode == "自动背刺" then
								local toKiller = (khrp.Position - hrp.Position).Unit
								local dot = toKiller:Dot(khrp.CFrame.LookVector)
								local shouldTrigger = dot > BS_BACKSTAB_THRESHOLD_COS and dist <= effectiveRange
								if shouldTrigger and os.clock() - bsLastTrigger >= BS_COOLDOWN then
									local cdNum = bsReadCooldown(bsGetDaggerCooldown())
									if not (cdNum and cdNum > 0.1) then
										bsLastTrigger = os.clock()
										task.spawn(function()
											bsAimAtKiller(killer,0.5)
											if bsDaggerEnabled then bsTryActivateButton(bsGetDaggerButton()) end
											if BS_AIM_SNAP_DELAY > 0 then
												task.wait(BS_AIM_SNAP_DELAY)
												if not bsRunning then return end
												local khrp2 = killer:FindFirstChild("HumanoidRootPart")
												local char2 = bsGetChar(); local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
												if khrp2 and hrp2 then
													local tgt = Vector3.new(khrp2.Position.X, hrp2.Position.Y, khrp2.Position.Z)
													hrp2.CFrame = CFrame.lookAt(hrp2.Position, tgt, Vector3.new(0,1,0))
												end
											end
										end)
										break
									end
								end
							elseif bsMode == "冲刺背刺技术" then
								local toPlayer = (hrp.Position - khrp.Position).Unit
								local dot = toPlayer:Dot(khrp.CFrame.LookVector)
								local inFront = dot > BS_BACKSTAB_THRESHOLD_COS and dist <= effectiveRange
								local twoTimeCrouching = false
								local ttChar = bsGetChar()
								if ttChar then twoTimeCrouching = ttChar:GetAttribute("Crouching") == true end
								if inFront and twoTimeCrouching and os.clock() - bsLastTrigger >= BS_COOLDOWN then
									local cdNum = bsReadCooldown(bsGetDaggerCooldown())
									if not (cdNum and cdNum > 0.1) then
										bsLastTrigger = os.clock()
										task.spawn(function() bsPerformDashStabTech(killer) end)
										break
									end
								end
							end
						end
					end
				end)

				bsSection:AddToggle("bsEnabled", { Text="启用", Default=false, Callback=function(v) bsEnabled=v end })
				bsSection:AddToggle("bsDaggerEnabled", { Text="自动使用匕首", Default=false, Callback=function(v) bsDaggerEnabled=v end })
				bsSection:AddToggle("bsCrouchStabEnabled", { Text="蹲下瞬间背刺", Default=false, Callback=function(v) bsCrouchStabEnabled=v; if v then bsStartCrouchStab() else bsStopCrouchStab() end end })
				bsSection:AddSlider("bsCrouchStabDelay", { Text="蹲下背刺延迟 (秒)", Default=0.10, Min=0.00, Max=0.50, Rounding=2, Callback=function(v) bsCrouchStabDelay=v end })
				bsSection:AddDropdown("bsMode", { Text="模式", Values={"自动背刺","冲刺背刺技术"}, Default="自动背刺", Callback=function(v) bsMode=v end })
				bsDetectionRangeSlider = bsSection:AddSlider("bsBaseProximity", { Text="检测范围", Default=BS_DEFAULT_PROXIMITY, Min=1, Max=32, Rounding=0, Callback=function(v) if not bsSuppressCallback then bsBaseProximity=v end end })
				bsSection:AddSlider("BS_AIM_SNAP_DELAY", { Text="瞄准捕捉延迟 (秒)", Default=0.25, Min=0.00, Max=0.40, Rounding=2, Callback=function(v) BS_AIM_SNAP_DELAY=v end })
				bsSection:AddSlider("BS_DASH_FLIP_DELAY", { Text="翻转延迟 (秒)", Default=0.38, Min=0.28, Max=0.65, Rounding=2, Callback=function(v) BS_DASH_FLIP_DELAY=v end })
				bsSection:AddSlider("BS_LUNGE_HOLD_DURATION", { Text="冲刺保持 (秒)", Default=0.25, Min=0.10, Max=0.50, Rounding=3, Callback=function(v) BS_LUNGE_HOLD_DURATION=v end })
				bsSection:AddSlider("BS_DEPTH_OFFSET", { Text="深度偏移 (st)", Default=2.0, Min=0.0, Max=5.0, Rounding=1, Callback=function(v) BS_DEPTH_OFFSET=v end })
				bsSection:AddToggle("bsNoclipEnabled", { Text="无碰撞 (更容易背刺)", Default=false, Callback=function(v) bsSetNoclip(v) end })
				bsSection:AddToggle("bsShowRadius", { Text="显示半径环", Default=true, Callback=function(v) bsShowRadius=v; if not v then bsDestroyAllRadiusParts() end end })
				bsSection:AddButton({ Text="卸载 TwoTime", Func=function()
					bsRunning = false; bsEnabled = false; bsSetNoclip(false); bsDestroyAllRadiusParts()
					Library:Notify("TwoTime 已卸载", 3)
				end })
			end

			-- ==================== Jane Doe 选项卡 ====================
			do
				local jd_Run = svc.Run
				local jd_RS = svc.RS
				local jd_lp = lp
				local jd_Camera = svc.WS.CurrentCamera

				local jd_RemoteEvent = nil
				local jd_NetworkRF = nil
				pcall(function()
					jd_RemoteEvent = jd_RS:WaitForChild("Modules",10):WaitForChild("Network",10):WaitForChild("Network",10):WaitForChild("RemoteEvent",10)
				end)
				pcall(function()
					jd_NetworkRF = jd_RS:WaitForChild("Modules",10):WaitForChild("Network",10):WaitForChild("Network",10):WaitForChild("RemoteFunction",10)
				end)

				local jd_enabled = false
				local jd_aimbotOn = false
				local jd_patched = false
				local jd_crystalCB = nil
				local jd_unloaded = false
				local jd_AIM_OFFSET = -0.3
				local jd_PREDICTION = 0.6
				local jd_HOLD_DURATION = 0.9
				local jd_AXE_DURATION = 1.7
				local jd_axeLockEnabled = false
				local jd_axeLockActive = false
				local jd_axeLockConn = nil
				local jd_axeHookConn = nil
				local jd_killerMotionData = {}

				local function jd_getKillerVelocity(hrp)
					local now=tick(); local pos=hrp.Position; local data=jd_killerMotionData[hrp]
					if not data then jd_killerMotionData[hrp]={lastPos=pos,lastTime=now,velocity=Vector3.zero}; return Vector3.zero end
					local dt=now-data.lastTime; if dt<=0 then return data.velocity end
					local vel=(pos-data.lastPos)/dt; data.lastPos=pos; data.lastTime=now; data.velocity=vel
					return vel
				end

				local function jd_getNearestKiller(fromPos)
					local folder=svc.WS:FindFirstChild("Players"); folder=folder and folder:FindFirstChild("Killers"); if not folder then return nil end
					local nearest,best=nil,math.huge
					for _,model in ipairs(folder:GetChildren()) do
						local hrp=model:FindFirstChild("HumanoidRootPart"); local hum=model:FindFirstChildOfClass("Humanoid")
						if hrp and hum and hum.Health>0 then local d=(hrp.Position-fromPos).Magnitude; if d<best then best=d; nearest=model end end
					end
					return nearest
				end

				local CRYSTAL_LO = 0xe8812534
				local CRYSTAL_HI = 0x1055d474
				local function jd_isCrystalBuf(buf)
					if typeof(buf) ~= "buffer" or buffer.len(buf) < 8 then return false end
					local ok, lo, hi = pcall(function() return buffer.readu32(buf, 0), buffer.readu32(buf, 4) end)
					return ok and lo == CRYSTAL_LO and hi == CRYSTAL_HI
				end
				local function jd_axeMatchesBuf(buf)
					if typeof(buf) ~= "buffer" then return false end
					if buffer.len(buf) ~= 8 then return false end
					return not jd_isCrystalBuf(buf)
				end

				local function jd_axeStopLock()
					jd_axeLockActive = false
					if jd_axeLockConn then jd_axeLockConn:Disconnect(); jd_axeLockConn = nil end
				end
				local function jd_axeStartLock()
					if jd_axeLockActive then return end
					local char=jd_lp.Character; local myHRP=char and char:FindFirstChild("HumanoidRootPart"); local myHum=char and char:FindFirstChildOfClass("Humanoid")
					if not myHRP or not myHum then return end
					local killer=jd_getNearestKiller(myHRP.Position); local killerHRP=killer and killer:FindFirstChild("HumanoidRootPart")
					if not killerHRP then return end
					jd_axeLockActive=true; local savedAutoRotate=myHum.AutoRotate; myHum.AutoRotate=false
					local startTime=tick()
					if jd_axeLockConn then jd_axeLockConn:Disconnect(); jd_axeLockConn=nil end
					jd_axeLockConn=jd_Run.Heartbeat:Connect(function()
						local elapsed=tick()-startTime
						if elapsed>=jd_AXE_DURATION or not jd_axeLockEnabled or not jd_axeLockActive or not myHRP.Parent or not killerHRP.Parent then
							jd_axeLockActive=false; myHum.AutoRotate=savedAutoRotate; jd_axeLockConn:Disconnect(); jd_axeLockConn=nil; return
						end
						local dir=(killerHRP.Position-myHRP.Position); local flat=Vector3.new(dir.X,0,dir.Z)
						if flat.Magnitude>0.01 then myHRP.CFrame=CFrame.lookAt(myHRP.Position,myHRP.Position+flat.Unit) end
					end)
				end
				local function jd_axeStartDetection()
					if jd_axeHookConn then return end
					local originalNC
					originalNC=hookmetamethod(game,"__namecall",function(self,...)
						local method=getnamecallmethod()
						if method=="FireServer" and self==jd_RemoteEvent then
							local args={...}
							if args[1]=="UseActorAbility" and type(args[2])=="table" and jd_axeMatchesBuf(args[2][1]) and jd_axeLockEnabled then
								task.spawn(jd_axeStartLock)
							end
						end
						return originalNC(self,...)
					end)
					jd_axeHookConn=true
				end
				local function jd_axeStopDetection()
					jd_axeStopLock(); jd_axeHookConn=nil
				end

				local function jd_fireCrystal()
					if not jd_RemoteEvent then return end
					local buf=buffer.create(8); buffer.writeu32(buf,0,0xe8812534); buffer.writeu32(buf,4,0x1055d474)
					jd_RemoteEvent:FireServer("UseActorAbility",{buf})
				end

				local jd_snapMouse = false
				local jd_mouseMoveRel = mousemoverel or mouse1move or (syn and syn.mouse_moverel) or nil

				local function jd_doMouseSnap(myHRP, killerHRP)
					if not jd_mouseMoveRel then return end
					local vel = jd_getKillerVelocity(killerHRP)
					local predicted = killerHRP.Position + vel * jd_PREDICTION
					local target = predicted + Vector3.new(0, jd_AIM_OFFSET, 0)
					local screenPos, onScreen = jd_Camera:WorldToScreenPoint(target)
					if not onScreen then return end
					local currentMouse = svc.Input:GetMouseLocation()
					local dx = screenPos.X - currentMouse.X
					local dy = screenPos.Y - currentMouse.Y
					local prevBehavior = svc.Input.MouseBehavior
					pcall(function() svc.Input.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition end)
					pcall(jd_mouseMoveRel, dx, dy)
					local restoreConn
					restoreConn = jd_Run.RenderStepped:Connect(function()
						restoreConn:Disconnect()
						pcall(function() svc.Input.MouseBehavior = prevBehavior end)
					end)
				end

				local function jd_getLocalActor() return jd_lp.Character end

				local function jd_applyPatch(actor)
					if jd_patched or not actor or not jd_NetworkRF then return end
					if type(getcallbackvalue)=="function" then
						pcall(function() jd_crystalCB = getcallbackvalue(jd_NetworkRF,"OnClientInvoke") end)
					end
					jd_NetworkRF.OnClientInvoke = function(reqName,...)
						if reqName=="GetCameraCF" and jd_enabled and jd_aimbotOn then
							local char = jd_lp.Character; local myHRP = char and char:FindFirstChild("HumanoidRootPart")
							if myHRP then
								local killer = jd_getNearestKiller(myHRP.Position)
								local killerHRP = killer and killer:FindFirstChild("HumanoidRootPart")
								if killerHRP then
									local ok,cf = pcall(function() 
										local hum = myHRP.Parent and myHRP.Parent:FindFirstChildOfClass("Humanoid")
										local hipH = hum and hum.HipHeight or 1.35
										local v238 = (hipH + myHRP.Size.Y/2)/2
										local spawnPos = myHRP.CFrame.Position + Vector3.new(0,v238,0)
										local vel = jd_getKillerVelocity(killerHRP)
										local predicted = killerHRP.Position + vel * jd_PREDICTION
										local target = predicted + Vector3.new(0, jd_AIM_OFFSET, 0)
										local delta = target - spawnPos
										local flatV = Vector3.new(delta.X,0,delta.Z)
										local dx = flatV.Magnitude; local dy = delta.Y
										if dx < 0.01 then
											local d = dy>=0 and Vector3.new(0,1,0) or Vector3.new(0,-1,0)
											return CFrame.new(jd_Camera.CFrame.Position, jd_Camera.CFrame.Position + d)
										end
										local flatDir = flatV.Unit
										local v0 = 250
										local g = 40
										local v2 = v0*v0
										local disc = v2*v2 - g*(g*dx*dx + 2*dy*v2)
										local theta = disc<0 and math.atan2(dy,dx) or math.atan2(v2 - math.sqrt(disc), g*dx)
										local T = math.tan(theta)
										local denom = 3 + T
										local alpha = math.abs(denom)<0.0001 and -math.pi/2 or math.atan2(3*T-1, denom)
										local yawCF = CFrame.new(jd_Camera.CFrame.Position, jd_Camera.CFrame.Position + flatDir)
										return yawCF * CFrame.Angles(alpha,0,0)
									end)
									if ok and cf then return cf end
								end
							end
						end
						if jd_crystalCB then return jd_crystalCB(reqName,...) end
					end
					pcall(function() jd_lp:SetAttribute("Device","Mobile") end)
					jd_patched = true
				end
				local function jd_removePatch()
					if not jd_patched then return end
					pcall(function() if jd_NetworkRF then jd_NetworkRF.OnClientInvoke = jd_crystalCB end end)
					pcall(function() jd_lp:SetAttribute("Device",nil) end)
					jd_crystalCB = nil; jd_patched = false
				end

				task.spawn(function()
					while not jd_unloaded do
						task.wait(0.1)
						if not jd_enabled or not jd_patched then continue end
						local char = jd_lp.Character; if not char then continue end
						local myHRP = char:FindFirstChild("HumanoidRootPart"); if not myHRP then continue end
						local killer = jd_getNearestKiller(myHRP.Position)
						local killerHRP = killer and killer:FindFirstChild("HumanoidRootPart")
						if jd_aimbotOn and killerHRP then
							jd_Run.Heartbeat:Wait(); jd_Run.Heartbeat:Wait()
							if jd_snapMouse and killerHRP.Parent then
								jd_doMouseSnap(myHRP, killerHRP)
							end
						end
						jd_fireCrystal()
						task.wait(jd_HOLD_DURATION + 0.2)
					end
				end)

				task.spawn(function()
					local lastActor = nil
					while not jd_unloaded do
						task.wait(0.5)
						local cur = jd_getLocalActor()
						if cur ~= lastActor then
							if lastActor ~= nil then jd_patched = false; jd_crystalCB = nil; jd_killerMotionData = {}; jd_axeStopLock() end
							lastActor = cur
							if cur and jd_enabled then jd_applyPatch(cur) end
						end
					end
				end)

				local jdMain = tabJaneDoe:AddLeftGroupbox("水晶自动发射")
				jdMain:AddToggle("jd_enabled", { Text="启用 Jane Doe 自瞄", Default=false, Callback=function(on) jd_enabled=on; local actor=jd_getLocalActor(); if on and not jd_patched and actor then jd_applyPatch(actor) end end })
				jdMain:AddToggle("jd_aimbotOn", { Text="自瞄 (静默瞄准)", Default=false, Callback=function(on) jd_aimbotOn=on; if not on then jd_killerMotionData={} end; local actor=jd_getLocalActor(); if on and not jd_patched and actor then jd_applyPatch(actor) end end })
				jdMain:AddToggle("jd_snapMouse", { Text="捕捉鼠标到预测 (PC)", Default=false, Callback=function(on) jd_snapMouse = on end })
				jdMain:AddSlider("jd_AIM_OFFSET", { Text="瞄准偏移 (Y)", Default=-0.3, Min=-5.0, Max=5.0, Rounding=1, Callback=function(v) jd_AIM_OFFSET=v end })
				jdMain:AddSlider("jd_PREDICTION", { Text="预判", Default=0.6, Min=0.0, Max=1.0, Rounding=2, Callback=function(v) jd_PREDICTION=v end })
				jdMain:AddSlider("jd_HOLD_DURATION", { Text="保持时间 (秒)", Default=0.9, Min=0.3, Max=2.0, Rounding=1, Callback=function(v) jd_HOLD_DURATION=v end })

				local jdAxe = tabJaneDoe:AddLeftGroupbox("斧头锁定")
				jdAxe:AddToggle("jd_axeLockEnabled", { Text="启用斧头锁定", Default=false, Callback=function(on) jd_axeLockEnabled=on; if on then jd_axeStartDetection() else jd_axeStopDetection() end end })
				jdAxe:AddSlider("jd_AXE_DURATION", { Text="锁定持续时间 (秒)", Default=1.7, Min=0.5, Max=3.0, Rounding=1, Callback=function(v) jd_AXE_DURATION=v end })

				local jdSettings = tabJaneDoe:AddLeftGroupbox("控制")
				jdSettings:AddButton({ Text="卸载 Jane Doe", Func=function()
					if jd_unloaded then return end
					jd_unloaded = true; jd_enabled = false; jd_aimbotOn = false
					pcall(jd_removePatch); pcall(jd_axeStopDetection)
					Library:Notify("Jane Doe 已卸载", 3)
				end })
			end

			-- ==================== Veeronica 选项卡 ====================
			local secAutoTrick = tabVeeronica:AddLeftGroupbox("自动特技")
			do
				local atEnabled = false
				local atActiveMonitors = {}
				local atDescendantAddedConn = nil

				local function atGetBehaviorFolder()
					return svc.RS:WaitForChild("Assets"):WaitForChild("Survivors"):WaitForChild("Veeronica"):WaitForChild("Behavior")
				end
				local function atGetSprintingButton()
					return lp.PlayerGui:WaitForChild("MainUI"):WaitForChild("SprintingButton")
				end

				local atBehaviorFolder = nil
				task.spawn(function()
					local ok, f = pcall(atGetBehaviorFolder)
					if ok and f then atBehaviorFolder = f end
				end)

				local function atSafeConnectPropertyChanged(instance, prop, fn)
					local ok, signal = pcall(function() return instance:GetPropertyChangedSignal(prop) end)
					if ok and signal then return signal:Connect(fn) end
					return nil
				end

				local function atMonitorHighlight(h)
					if not h or atActiveMonitors[h] then return end
					local connections = {}
					local prevState = false
					local function cleanup()
						for _, conn in ipairs(connections) do if conn and conn.Connected then conn:Disconnect() end end
						atActiveMonitors[h] = nil
					end
					local function adorneeIsPlayer(hh)
						if not hh then return false end
						local adornee = hh.Adornee
						local char = lp.Character
						if not adornee or not char then return false end
						return adornee == char or adornee:IsDescendantOf(char)
					end
					local function onChanged()
						if not atEnabled then return end
						if not h or not h.Parent then cleanup(); return end
						local currState = adorneeIsPlayer(h)
						if prevState ~= currState then
							if currState then
								local ok2, btn = pcall(atGetSprintingButton)
								if ok2 and btn then
									for _, v in pairs(getconnections(btn.MouseButton1Down)) do
										pcall(function() v:Fire() end)
										pcall(function() if v.Function then v:Function() end end)
									end
								end
							end
						end
						prevState = currState
					end
					local c = atSafeConnectPropertyChanged(h, "Adornee", onChanged)
					if c then table.insert(connections, c) end
					table.insert(connections, h.AncestryChanged:Connect(function(_, parent)
						if not parent then cleanup() else onChanged() end
					end))
					table.insert(connections, lp.CharacterAdded:Connect(onChanged))
					table.insert(connections, lp.CharacterRemoving:Connect(onChanged))
					atActiveMonitors[h] = cleanup
					task.spawn(onChanged)
				end

				local function atStartManager()
					if atDescendantAddedConn or not atBehaviorFolder then return end
					for _, desc in ipairs(atBehaviorFolder:GetDescendants()) do
						if desc:IsA("Highlight") then atMonitorHighlight(desc) end
					end
					atDescendantAddedConn = atBehaviorFolder.DescendantAdded:Connect(function(child)
						if child:IsA("Highlight") then atMonitorHighlight(child) end
					end)
				end
				local function atStopManager()
					if atDescendantAddedConn and atDescendantAddedConn.Connected then atDescendantAddedConn:Disconnect() end
					atDescendantAddedConn = nil
					local cleans = {}
					for _, cleanup in pairs(atActiveMonitors) do if type(cleanup) == "function" then table.insert(cleans, cleanup) end end
					for _, fn in ipairs(cleans) do pcall(fn) end
					atActiveMonitors = {}
				end

				secAutoTrick:AddToggle("autoTrickOn", { Text="自动特技", Default=false, Callback=function(on)
					atEnabled = on
					if on then
						if not atBehaviorFolder then local ok, f = pcall(atGetBehaviorFolder); if ok and f then atBehaviorFolder = f end end
						atStartManager()
					else
						atStopManager()
					end
				end })
			end

			local secSK8 = tabVeeronica:AddLeftGroupbox("SK8 控制")
			do
				local sk8_camera = workspace.CurrentCamera
				local sk8_shiftlockEnabled = false
				local sk8_shiftConn = nil

				local function sk8_setShiftlock(state)
					sk8_shiftlockEnabled = state
					if sk8_shiftConn then sk8_shiftConn:Disconnect(); sk8_shiftConn = nil end
					if sk8_shiftlockEnabled then
						svc.Input.MouseBehavior = Enum.MouseBehavior.LockCenter
						sk8_shiftConn = svc.Run.RenderStepped:Connect(function()
							local character = lp.Character
							local root = character and character:FindFirstChild("HumanoidRootPart")
							if root then
								local camCF = sk8_camera.CFrame
								root.CFrame = CFrame.new(root.Position, Vector3.new(camCF.LookVector.X+root.Position.X, root.Position.Y, camCF.LookVector.Z+root.Position.Z))
							end
						end)
					else
						svc.Input.MouseBehavior = Enum.MouseBehavior.Default
					end
				end

				local sk8_chargeAnimIds = { "117058860640843" }
				local sk8_DASH_SPEED = 60
				local sk8_controlEnabled = cfg.get("sk8ControlEnabled", true)
				local sk8_controlActive = false
				local sk8_overrideConn = nil
				local sk8_savedHumState = {}

				local function sk8_getHumanoid()
					if not lp or not lp.Character then return nil end
					return lp.Character:FindFirstChildOfClass("Humanoid")
				end
				local function sk8_saveHumState(hum)
					if not hum or sk8_savedHumState[hum] then return end
					local s = {}
					pcall(function()
						s.WalkSpeed = hum.WalkSpeed
						local ok, _ = pcall(function() s.JumpPower = hum.JumpPower end)
						if not ok then pcall(function() s.JumpPower = hum.JumpHeight end) end
						local ok2, ar = pcall(function() return hum.AutoRotate end)
						if ok2 then s.AutoRotate = ar end
						s.PlatformStand = hum.PlatformStand
					end)
					sk8_savedHumState[hum] = s
				end
				local function sk8_restoreHumState(hum)
					if not hum then return end
					local s = sk8_savedHumState[hum]; if not s then return end
					pcall(function()
						if s.WalkSpeed ~= nil then hum.WalkSpeed = s.WalkSpeed end
						if s.JumpPower ~= nil then
							local ok, _ = pcall(function() hum.JumpPower = s.JumpPower end)
							if not ok then pcall(function() hum.JumpHeight = s.JumpPower end) end
						end
						if s.AutoRotate ~= nil then pcall(function() hum.AutoRotate = s.AutoRotate end) end
						if s.PlatformStand ~= nil then hum.PlatformStand = s.PlatformStand end
					end)
					sk8_savedHumState[hum] = nil
				end
				local function sk8_startOverride()
					if sk8_controlActive then return end
					local hum = sk8_getHumanoid(); if not hum then return end
					sk8_controlActive = true; sk8_saveHumState(hum)
					pcall(function() hum.WalkSpeed = sk8_DASH_SPEED; hum.AutoRotate = false end)
					sk8_setShiftlock(true)
					sk8_overrideConn = svc.Run.RenderStepped:Connect(function()
						local humanoid = sk8_getHumanoid()
						local rootPart = humanoid and humanoid.Parent and humanoid.Parent:FindFirstChild("HumanoidRootPart")
						if not humanoid or not rootPart then return end
						pcall(function() humanoid.WalkSpeed = sk8_DASH_SPEED; humanoid.AutoRotate = false end)
						local direction = rootPart.CFrame.LookVector
						local horizontal = Vector3.new(direction.X, 0, direction.Z)
						if horizontal.Magnitude > 0 then humanoid:Move(horizontal.Unit) else humanoid:Move(Vector3.new(0,0,0)) end
					end)
				end
				local function sk8_stopOverride()
					if not sk8_controlActive then return end
					sk8_controlActive = false
					if sk8_overrideConn then pcall(function() sk8_overrideConn:Disconnect() end); sk8_overrideConn = nil end
					sk8_setShiftlock(false)
					local hum = sk8_getHumanoid()
					if hum then pcall(function() sk8_restoreHumState(hum); hum:Move(Vector3.new(0,0,0)) end) end
				end
				local function sk8_detectChargeAnim()
					local hum = sk8_getHumanoid(); if not hum then return false end
					for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
						local ok, animId = pcall(function()
							return tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
						end)
						if ok and animId and animId ~= "" then
							if table.find(sk8_chargeAnimIds, animId) then return true end
						end
					end
					return false
				end

				svc.Run.RenderStepped:Connect(function()
					if not sk8_controlEnabled then if sk8_controlActive then sk8_stopOverride() end; return end
					local hum = sk8_getHumanoid()
					if not hum then if sk8_controlActive then sk8_stopOverride() end; return end
					if sk8_detectChargeAnim() then if not sk8_controlActive then sk8_startOverride() end
					else if sk8_controlActive then sk8_stopOverride() end end
				end)

				lp.CharacterAdded:Connect(function()
					if sk8_shiftConn then sk8_shiftConn:Disconnect(); sk8_shiftConn = nil end
					sk8_savedHumState = {}
				end)

				secSK8:AddToggle("sk8ControlEnabled", { Text="启用 SK8 控制", Default=sk8_controlEnabled, Callback=function(on)
					sk8_controlEnabled = on; cfg.set("sk8ControlEnabled", on)
					if not on and sk8_controlActive then sk8_stopOverride() end
				end })
			end

			-- ==================== 界面选项卡 ====================
			local menuGroup = tabUI:AddLeftGroupbox("界面设置")
			menuGroup:AddToggle("KeybindMenuOpen", { Text="快捷键菜单", Default=Library.KeybindFrame.Visible, Callback=function(v) Library.KeybindFrame.Visible = v end })
			menuGroup:AddToggle("ShowCustomCursor", { Text="自定义光标", Default=true, Callback=function(v) Library.ShowCustomCursor = v end })
			menuGroup:AddDropdown("NotificationSide", { Text="通知位置", Values={"Left","Right"}, Default="Right", Callback=function(v) Library:SetNotifySide(v) end })
			menuGroup:AddDropdown("DPIDropdown", { Text="UI 缩放", Values={"25%","50%","75%","100%","125%","150%","175%","200%"}, Default="100%", Callback=function(v)
				local percent = v:gsub("%%","")
				Library:SetDPIScale(tonumber(percent))
			end })
			menuGroup:AddDivider()
			menuGroup:AddLabel("菜单绑定")
				:AddKeyPicker("MenuKeybind", { Default="RightShift", NoUI=true, Text="菜单快捷键" })
			menuGroup:AddButton("销毁界面", function() Library:Unload() end)

-- ==================== 自动格挡（纯动画检测版） ====================
local AutoBlock = (function()
    -- =============================================
    -- 自动格挡核心模块 (纯动画检测)
    -- =============================================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
    local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

    -- =============================================
    -- 配置表
    -- =============================================
    local AutoBlockConfig = {
        Enabled = false,
        AnimDetectionEnabled = true,
        SenseRange = 18,
        FacingCheck = false,
        ShowRadius = false,
        IgnoreDelay = 0,
        SenseRangeSq = 18 * 18,
        AnimHooks = {},
        AnimBlockedUntil = {},
        AnimStartTime = {},
        DetectionCircles = {},
        PlayerFacingAngle = 90,
        KillerFacingAngle = 90,
        KillerFacingCheckEnabled = true ,
        wallCheckEnabled = true,
        CircleTransparency = 0.7
    }

    -- =============================================
    -- 动画ID列表 (触发格挡的动画)
    -- =============================================
    local AutoBlockAnims = {
        ["123172382755876"] = true,
        ["112366541922769"] = true,
        ["126830014841198"] = true,
        ["105458270463374"] = true,
        ["106538427162796"] = true,
        ["88451353906104"] = true,
        ["122709416391891"] = true,
        ["87989533095285"] = true,
        ["18885909645"] = true,
        ["83829782357897"] = true,
        ["90620531468240"] = true,
        ["99829427721752"] = true,
        ["121293883585738"] = true,
        ["124705663396411"] = true,
        ["129405885079224"] = true,
        ["126171487400618"] = true,
        ["127245564598429"] = true,
        ["70948173568515"] = true,
        ["108196996477620"] = true,
        ["118298475669935"] = true,
        ["109667959938617"] = true,
        ["125403313786645"] = true,
        ["94958041603347"] = true,
        ["114126519127454"] = true,
        ["70371667919898"] = true,
        ["84069821282466"] = true,
        ["109440227637912"] = true,
        ["121858217776572"] = true,
        ["124269076578545"] = true,
        ["93069721274110"] = true,
        ["138938529389204"] = true,
        ["88970503168421"] = true,
        ["121778755277919"] = true,
        ["87347358451124"] = true,
        ["91509234639766"] = true,
        ["77375846492436"] = true,
        ["92567970681901"] = true,
        ["93366464803829"] = true,
        ["70785407091644"] = true,
        ["130958529065375"] = true,
    }

    -- =============================================
    -- 核心功能函数
    -- =============================================

    -- 发送格挡远程事件
    local function FireBlockRemote()
        local args = {"UseActorAbility", {buffer.fromstring("\x03\x05\x00\x00\x00Block")}}
        RemoteEvent:FireServer(unpack(args))
    end

    -- 检查玩家是否面向杀手
    local function IsPlayerFacingKiller(myRoot, killerRoot)
        if not AutoBlockConfig.FacingCheck then return true end
        if not myRoot or not killerRoot then return false end
        local dirToKiller = (killerRoot.Position - myRoot.Position).Unit
        local playerLookDir = myRoot.CFrame.LookVector
        local dotProduct = playerLookDir:Dot(dirToKiller)
        local angleInDegrees = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))
        return angleInDegrees <= AutoBlockConfig.PlayerFacingAngle
    end

    -- 检查杀手是否面向玩家
    local function IsKillerFacingPlayer(myRoot, killerRoot)
        if not AutoBlockConfig.KillerFacingCheckEnabled then return true end
        if not myRoot or not killerRoot then return false end
        local dirToPlayer = (myRoot.Position - killerRoot.Position).Unit
        local killerLookDir = killerRoot.CFrame.LookVector
        local dotProduct = killerLookDir:Dot(dirToPlayer)
        local angleInDegrees = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))
        return angleInDegrees <= AutoBlockConfig.KillerFacingAngle
    end

    -- 视线检测 (墙体检测)
    local function HasLineOfSight(targetRoot)
        if not AutoBlockConfig.wallCheckEnabled then return true end
        local LocalPlayer = Players.LocalPlayer
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return false end
        
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = true
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        
        local origin = myRoot.Position
        local direction = targetRoot.Position - origin
        local result = workspace:Raycast(origin, direction, rayParams)
        return not result or result.Instance:IsDescendantOf(targetRoot.Parent)
    end

    -- 检查所有格挡条件
    local function CheckAllBlockConditions(myRoot, killerRoot)
        if not myRoot or not killerRoot then return false end
        
        local dvec = killerRoot.Position - myRoot.Position
        local distSq = dvec.X^2 + dvec.Y^2 + dvec.Z^2
        if distSq > AutoBlockConfig.SenseRangeSq then return false end
        
        if not HasLineOfSight(killerRoot) then return false end
        if not IsPlayerFacingKiller(myRoot, killerRoot) then return false end
        if not IsKillerFacingPlayer(myRoot, killerRoot) then return false end
        
        return true
    end

    -- 提取动画ID
    local function ExtractAnimId(animTrack)
        if not animTrack or not animTrack.Animation then return nil end
        local aid = tostring(animTrack.Animation.AnimationId)
        return aid:match("%d+")
    end

    -- 从实例获取角色
    local function GetCharacterFromDescendant(inst)
        if not inst then return nil end
        local model = inst:FindFirstAncestorOfClass("Model")
        return model and model:FindFirstChildOfClass("Humanoid") and model or nil
    end

    -- 判断是否可以对指定杀手格挡
    local function CanBlockKiller(killer)
        if not AutoBlockConfig.Enabled then return false end
        local LocalPlayer = Players.LocalPlayer
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return false end
        local hrp = killer:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        return CheckAllBlockConditions(myRoot, hrp)
    end

    -- =============================================
    -- 动画检测处理 (纯动画版)
    -- =============================================
    local function ProcessAnimAutoBlock(animTrack)
        if not AutoBlockConfig.Enabled or not AutoBlockConfig.AnimDetectionEnabled then return end
        if not animTrack or not animTrack.IsPlaying then return end
        
        local id = ExtractAnimId(animTrack)
        if not id or not AutoBlockAnims[id] then return end
        
        local now = tick()
        local LocalPlayer = Players.LocalPlayer
        
        -- 忽略延迟检查
        if AutoBlockConfig.IgnoreDelay > 0 then
            if not AutoBlockConfig.AnimStartTime[animTrack] then
                AutoBlockConfig.AnimStartTime[animTrack] = now
            end
            local elapsed = now - AutoBlockConfig.AnimStartTime[animTrack]
            if elapsed < AutoBlockConfig.IgnoreDelay then return end
        end
        
        -- 冷却检查
        if AutoBlockConfig.AnimBlockedUntil[animTrack] and now < AutoBlockConfig.AnimBlockedUntil[animTrack] then return end
        
        local animator = animTrack.Parent
        if not animator or not animator:IsA("Animator") then return end
        
        local char = GetCharacterFromDescendant(animator)
        if not char then return end
        
        local plr = Players:GetPlayerFromCharacter(char)
        if not plr or plr == LocalPlayer then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not myRoot then return end
        
        if CheckAllBlockConditions(myRoot, hrp) then
            FireBlockRemote()
            AutoBlockConfig.AnimBlockedUntil[animTrack] = now + 1.2
        end
    end

    -- =============================================
    -- Hook 注册函数 (仅动画)
    -- =============================================

    -- Hook 动画器
    local function HookAnimator(animator)
        if not animator or not animator:IsA("Animator") then return end
        if AutoBlockConfig.AnimHooks[animator] then return end
        
        local trackConn = animator.AnimationPlayed:Connect(function(animTrack)
            AutoBlockConfig.AnimStartTime[animTrack] = tick()
            
            local playedConn = animTrack:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if animTrack.IsPlaying then
                    AutoBlockConfig.AnimStartTime[animTrack] = tick()
                    pcall(ProcessAnimAutoBlock, animTrack)
                else
                    AutoBlockConfig.AnimStartTime[animTrack] = nil
                end
            end)
            
            local stoppedConn
            stoppedConn = animTrack.Stopped:Connect(function()
                if playedConn.Connected then playedConn:Disconnect() end
                if stoppedConn.Connected then stoppedConn:Disconnect() end
                AutoBlockConfig.AnimBlockedUntil[animTrack] = nil
                AutoBlockConfig.AnimStartTime[animTrack] = nil
            end)
        end)
        
        local destroyConn
        destroyConn = animator.Destroying:Connect(function()
            if trackConn.Connected then trackConn:Disconnect() end
            if destroyConn.Connected then destroyConn:Disconnect() end
            AutoBlockConfig.AnimHooks[animator] = nil
        end)
        
        AutoBlockConfig.AnimHooks[animator] = {trackConn, destroyConn}
        
        -- 处理已播放的动画
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            AutoBlockConfig.AnimStartTime[track] = tick()
            task.spawn(function() pcall(ProcessAnimAutoBlock, track) end)
        end
    end

    -- =============================================
    -- 初始化所有Hooks (仅动画)
    -- =============================================
    local function InitializeHooks()
        -- 扫描已有动画器
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("Animator") then
                pcall(HookAnimator, desc)
            end
        end
        
        -- 监听新动画器
        game.DescendantAdded:Connect(function(desc)
            if desc:IsA("Animator") then
                pcall(HookAnimator, desc)
            end
        end)
    end

    -- =============================================
    -- 检测圆圈可视化 (可选)
    -- =============================================
    local function CreateDetectionCircle(killer)
        if not killer:FindFirstChild("HumanoidRootPart") then return end
        if AutoBlockConfig.DetectionCircles[killer] then return end

        local hrp = killer.HumanoidRootPart
        local circle = Instance.new("CylinderHandleAdornment")
        circle.Name = "DetectionCircle"
        circle.Adornee = hrp
        circle.Color3 = Color3.fromRGB(255, 0, 0)
        circle.AlwaysOnTop = true
        circle.ZIndex = 0
        circle.Transparency = AutoBlockConfig.CircleTransparency
        circle.Radius = AutoBlockConfig.SenseRange / 1.5
        circle.Height = 0.1
        circle.CFrame = CFrame.new(0, -2, 0) * CFrame.Angles(math.rad(90), 0, 0)
        circle.Parent = hrp

        AutoBlockConfig.DetectionCircles[killer] = circle
    end

    local function RemoveDetectionCircle(killer)
        if AutoBlockConfig.DetectionCircles[killer] then
            AutoBlockConfig.DetectionCircles[killer]:Destroy()
            AutoBlockConfig.DetectionCircles[killer] = nil
        end
    end

    -- =============================================
    -- 更新检测圆圈
    -- =============================================
    local function UpdateDetectionCircles()
        for _, killer in ipairs(KillersFolder:GetChildren()) do
            if AutoBlockConfig.ShowRadius then
                CreateDetectionCircle(killer)
            else
                RemoveDetectionCircle(killer)
            end
        end
    end

    -- 圆圈颜色更新 (在RenderStepped中)
    RunService.RenderStepped:Connect(function()
        for killer, circle in pairs(AutoBlockConfig.DetectionCircles) do
            if circle and circle.Parent then
                circle.Radius = AutoBlockConfig.SenseRange / 1.5
                circle.CFrame = CFrame.new(0, -2, 0) * CFrame.Angles(math.rad(90), 0, 0)
                circle.Color3 = CanBlockKiller(killer) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                circle.Transparency = AutoBlockConfig.CircleTransparency
            end
        end
    end)

    -- 监听杀手添加/移除
    KillersFolder.ChildAdded:Connect(function(killer)
        task.spawn(function()
            local hrp = killer:WaitForChild("HumanoidRootPart", 5)
            if hrp and AutoBlockConfig.ShowRadius then
                CreateDetectionCircle(killer)
            end
        end)
    end)

    KillersFolder.ChildRemoved:Connect(function(killer)
        RemoveDetectionCircle(killer)
    end)

    -- =============================================
    -- 更新范围平方值
    -- =============================================
    local function UpdateSenseRangeSq()
        AutoBlockConfig.SenseRangeSq = AutoBlockConfig.SenseRange * AutoBlockConfig.SenseRange
    end

    -- =============================================
    -- 导出接口
    -- =============================================
    return {
        Config = AutoBlockConfig,
        Enable = function()
            AutoBlockConfig.Enabled = true
            InitializeHooks()
            UpdateDetectionCircles()
        end,
        Disable = function()
            AutoBlockConfig.Enabled = false
            -- 清理所有动画Hook
            for animator, hooks in pairs(AutoBlockConfig.AnimHooks) do
                for _, conn in ipairs(hooks) do
                    if conn and conn.Connected then 
                        pcall(function() conn:Disconnect() end)
                    end
                end
            end
            AutoBlockConfig.AnimHooks = {}
            AutoBlockConfig.AnimBlockedUntil = {}
            AutoBlockConfig.AnimStartTime = {}
            -- 清理圆圈
            for killer, _ in pairs(AutoBlockConfig.DetectionCircles) do
                RemoveDetectionCircle(killer)
            end
        end,
        SetRange = function(range)
            AutoBlockConfig.SenseRange = range
            UpdateSenseRangeSq()
        end,
        SetFacingAngle = function(angle)
            AutoBlockConfig.PlayerFacingAngle = angle
        end,
        SetKillerFacingAngle = function(angle)
            AutoBlockConfig.KillerFacingAngle = angle
        end,
        SetIgnoreDelay = function(delay)
            AutoBlockConfig.IgnoreDelay = delay
        end,
        SetWallCheck = function(enabled)
            AutoBlockConfig.wallCheckEnabled = enabled
        end,
        SetFacingCheck = function(enabled)
            AutoBlockConfig.FacingCheck = enabled
        end,
        SetKillerFacingCheck = function(enabled)
            AutoBlockConfig.KillerFacingCheckEnabled = enabled
        end,
        SetAnimDetection = function(enabled)
            AutoBlockConfig.AnimDetectionEnabled = enabled
        end,
        SetCircleVisibility = function(visible)
            AutoBlockConfig.ShowRadius = visible
            UpdateDetectionCircles()
        end,
        SetCircleTransparency = function(transparency)
            AutoBlockConfig.CircleTransparency = transparency
        end
    }
end)()

-- =============================================
-- 加载配置并绑定UI
-- =============================================
local autoBlockEnabled = cfg.get("autoBlockEnabled", false)
local autoBlockRange   = cfg.get("autoBlockRange", 18)
local autoBlockFacing  = cfg.get("autoBlockFacing", false)
local autoBlockRadius  = cfg.get("autoBlockRadius", false)

AutoBlock.SetRange(autoBlockRange)
AutoBlock.SetKillerFacingCheck(autoBlockFacing)
AutoBlock.SetCircleVisibility(autoBlockRadius)

if autoBlockEnabled then
    AutoBlock.Enable()
end

local BlockGroup = tabAutoBlock:AddLeftGroupbox("自动格挡设置", "shield")

BlockGroup:AddToggle("AutoBlockToggle", {
    Text = "启用自动格挡",
    Default = autoBlockEnabled,
    Callback = function(on)
        cfg.set("autoBlockEnabled", on)
        if on then
            AutoBlock.Enable()
        else
            AutoBlock.Disable()
        end
    end
})

BlockGroup:AddSlider("TriggerDistance", {
    Text = "触发距离",
    Default = autoBlockRange,
    Min = 5,
    Max = 50,
    Rounding = 0,
    Callback = function(v)
        cfg.set("autoBlockRange", v)
        AutoBlock.SetRange(v)
    end
})

BlockGroup:AddToggle("FacingCheck", {
    Text = "杀手面向检测",
    Default = autoBlockFacing,
    Callback = function(on)
        cfg.set("autoBlockFacing", on)
        AutoBlock.SetKillerFacingCheck(on)
    end
})

BlockGroup:AddToggle("ShowRangeVisual", {
    Text = "显示触发范围",
    Default = autoBlockRadius,
    Callback = function(on)
        cfg.set("autoBlockRadius", on)
        AutoBlock.SetCircleVisibility(on)
    end
})

-- 可选：添加额外的高级配置（如果不添加，不影响核心功能）
-- 此处可以继续添加更多控件（例如墙体检测、忽略延迟等），但按题目要求，只替换原有功能。
-- 若需要扩展，可以在

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

			local savedThemeUI = cfg.get("windTheme", "Dark")
			ThemeManager:SetTheme(savedThemeUI)

			print("FENGSAKEN加载成功")
		end

		startMain()
	end)

	if not success then
		warn("❌ 脚本加载失败：", err)
		print("请将以下错误信息反馈给作者：\n", err)
		pcall(function()
			local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
			if Library and Library.Notify then
				Library:Notify({Title="错误", Description="脚本加载失败，请查看控制台 (F9)", Time=5})
			end
		end)
	end
end
safeStart()