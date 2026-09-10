-- ============================================================
-- GR_COOLKID hub Private v1.5 - Rayfield版（FOV円表示なし + KeySystem）
-- ============================================================

-- チャット送信機能（起動メッセージ用）
local TCS = game:GetService("TextChatService")

local function send(m)
    pcall(function()
        if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = TCS:FindFirstChild("TextChannels")
            if channel then
                local general = channel:FindFirstChild("RBXGeneral")
                if general then
                    general:SendAsync(m)
                    return
                end
            end
        end
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(m, "All")
    end)
end

-- ============================================================
-- Rayfield ロード（script_key付き）
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    print("❌ Rayfield読み込み失敗")
    return
end

print("✅ Rayfield読み込み成功")

-- ============================================================
-- ハブ設定（KeySystem有効）
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "GR_COOLKID hub Private v1.5",
    LoadingTitle = "GR_COOLKID hub",
    LoadingSubtitle = "by GR_COOLKID",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GRCOOLKID",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = true, -- KeySystemを有効化
    KeySettings = {
        Title = "GR_COOLKID hub | Key System",
        Subtitle = "キーを入力してください",
        Note = "キー: ZWExOarKtFvomRQjoTqtyyEkzopHEwtb",
        FileName = "GRCOOLKID_Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"ZWExOarKtFvomRQjoTqtyyEkzopHEwtb"}
    }
})

task.wait(0.5)

-- ============================================================
-- タブ作成
-- ============================================================
local MainTab = Window:CreateTab("メイン", 4483345998)
local PlotTab = Window:CreateTab("家破壊", 4483345998)
local TeleportTab = Window:CreateTab("テレポート", 4483345998)
local SilentTab = Window:CreateTab("Silent Aim", 4483362458)
local PlayerTab = Window:CreateTab("プレイヤー", 4483345998)
local GrabTab = Window:CreateTab("Grabkick", 4483345998)

-- ============================================================
-- 共通変数
-- ============================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if not LP then 
    warn("LocalPlayer not found")
    return 
end

local isBreaking = false
local plotTarget = 1
local autoBreak = false
local selectedTeleportPlayer = nil

-- ============================================================
-- メインタブ
-- ============================================================
local MainSection = MainTab:CreateSection("情報")
MainTab:CreateLabel("GR_COOLKID hub Private v1.5")
MainTab:CreateLabel("【完全版】全機能搭載")
MainTab:CreateLabel("🏠 家破壊 (Plot Breaker)")
MainTab:CreateLabel("📍 テレポート")
MainTab:CreateLabel("🎯 Silent Aim")
MainTab:CreateLabel("👤 プレイヤー機能")
MainTab:CreateLabel("💥 Grabkick")
MainTab:CreateLabel("🔑 Key: ZWExOarKtFvomRQjoTqtyyEkzopHEwtb")
MainTab:CreateLabel("✅ 起動メッセージをチャットに送信済み")

-- ============================================================
-- 家破壊（Plot Breaker）
-- ============================================================
local function getHRP()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        return LP.Character.HumanoidRootPart
    end
    return nil
end

local PlotSection = PlotTab:CreateSection("Plot Breaker")

PlotTab:CreateButton({
    Name = "Break All Plots (1-5)",
    Callback = function()
        if isBreaking then return end
        isBreaking = true
        
        task.spawn(function()
            local inv = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
            if not inv then
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "インベントリが見つかりません",
                    Duration = 3,
                    Image = 4483345998
                })
                isBreaking = false
                return
            end

            local currentHRP = getHRP()
            if not currentHRP then
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "HRPが見つかりません",
                    Duration = 3,
                    Image = 4483345998
                })
                isBreaking = false
                return
            end

            for i = 1, 5 do
                local shur = nil
                local conn = inv.ChildAdded:Connect(function(child)
                    if child.Name == "NinjaShuriken" then
                        shur = child
                        conn:Disconnect()
                    end
                end)

                local spawnToy = ReplicatedStorage:FindFirstChild("MenuToys")
                if spawnToy then
                    local spawnFunc = spawnToy:FindFirstChild("SpawnToyRemoteFunction")
                    if spawnFunc then
                        spawnFunc:InvokeServer("NinjaShuriken", currentHRP.CFrame * CFrame.new(5, 8, 20), Vector3.new(0, 0, 0))
                    end
                end

                local startTime = tick()
                repeat
                    if shur and shur:FindFirstChild("StickyPart") and shur:FindFirstChild("SoundPart") then
                        break
                    end
                    task.wait(0.01)
                until tick() - startTime > 0.5
                shur = shur or inv:FindFirstChild("NinjaShuriken")

                if shur then
                    local soundPart = shur:FindFirstChild("SoundPart")
                    local stickyPart = shur:FindFirstChild("StickyPart")
                    if soundPart and stickyPart then
                        local grabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
                        if grabEvents then
                            local setOwner = grabEvents:FindFirstChild("SetNetworkOwner")
                            if setOwner then
                                for j = 1, 15 do
                                    setOwner:FireServer(soundPart, soundPart.CFrame)
                                    if soundPart:FindFirstChild("PartOwner") and soundPart.PartOwner.Value == LP.Name then
                                        break
                                    end
                                end
                            end
                        end

                        for _, obj in pairs(shur:GetChildren()) do
                            if obj:IsA("BasePart") then
                                obj.CanTouch = false
                                obj.CanCollide = false
                                obj.Transparency = 1
                            end
                        end
                        shur.Name = "Noclipped"

                        local plot = Workspace:FindFirstChild("Plots")
                        if plot then
                            plot = plot:FindFirstChild("Plot" .. i)
                            if plot then
                                local plotArea = plot:FindFirstChild("PlotArea")
                                if plotArea then
                                    local playerEvents = ReplicatedStorage:FindFirstChild("PlayerEvents")
                                    if playerEvents then
                                        local stickyEvent = playerEvents:FindFirstChild("StickyPartEvent")
                                        if stickyEvent then
                                            stickyEvent:FireServer(stickyPart, plotArea, CFrame.new(1e12, 1e12, 1e12))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
            
            Rayfield:Notify({
                Title = "完了",
                Content = "全てのPlotを破壊しました",
                Duration = 3,
                Image = 4483345998
            })
            isBreaking = false
        end)
    end
})

PlotTab:CreateSlider({
    Name = "破壊するPlot番号",
    Range = {1, 5},
    Increment = 1,
    Suffix = "Plot",
    CurrentValue = 1,
    Callback = function(Value)
        plotTarget = Value
    end
})

PlotTab:CreateButton({
    Name = "選択したPlotを破壊",
    Callback = function()
        if isBreaking then return end
        isBreaking = true
        
        task.spawn(function()
            local inv = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
            if not inv then
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "インベントリが見つかりません",
                    Duration = 3,
                    Image = 4483345998
                })
                isBreaking = false
                return
            end

            local currentHRP = getHRP()
            if not currentHRP then
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "HRPが見つかりません",
                    Duration = 3,
                    Image = 4483345998
                })
                isBreaking = false
                return
            end

            local i = plotTarget
            local shur = nil
            local conn = inv.ChildAdded:Connect(function(child)
                if child.Name == "NinjaShuriken" then
                    shur = child
                    conn:Disconnect()
                end
            end)

            local spawnToy = ReplicatedStorage:FindFirstChild("MenuToys")
            if spawnToy then
                local spawnFunc = spawnToy:FindFirstChild("SpawnToyRemoteFunction")
                if spawnFunc then
                    spawnFunc:InvokeServer("NinjaShuriken", currentHRP.CFrame * CFrame.new(5, 8, 20), Vector3.new(0, 0, 0))
                end
            end

            local startTime = tick()
            repeat
                if shur and shur:FindFirstChild("StickyPart") and shur:FindFirstChild("SoundPart") then
                    break
                end
                task.wait(0.01)
            until tick() - startTime > 0.5
            shur = shur or inv:FindFirstChild("NinjaShuriken")

            if shur then
                local soundPart = shur:FindFirstChild("SoundPart")
                local stickyPart = shur:FindFirstChild("StickyPart")
                if soundPart and stickyPart then
                    local grabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
                    if grabEvents then
                        local setOwner = grabEvents:FindFirstChild("SetNetworkOwner")
                        if setOwner then
                            for j = 1, 15 do
                                setOwner:FireServer(soundPart, soundPart.CFrame)
                                if soundPart:FindFirstChild("PartOwner") and soundPart.PartOwner.Value == LP.Name then
                                    break
                                end
                            end
                        end
                    end

                    for _, obj in pairs(shur:GetChildren()) do
                        if obj:IsA("BasePart") then
                            obj.CanTouch = false
                            obj.CanCollide = false
                            obj.Transparency = 1
                        end
                    end
                    shur.Name = "Noclipped"

                    local plot = Workspace:FindFirstChild("Plots")
                    if plot then
                        plot = plot:FindFirstChild("Plot" .. i)
                        if plot then
                            local plotArea = plot:FindFirstChild("PlotArea")
                            if plotArea then
                                local playerEvents = ReplicatedStorage:FindFirstChild("PlayerEvents")
                                if playerEvents then
                                    local stickyEvent = playerEvents:FindFirstChild("StickyPartEvent")
                                    if stickyEvent then
                                        stickyEvent:FireServer(stickyPart, plotArea, CFrame.new(1e12, 1e12, 1e12))
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            Rayfield:Notify({
                Title = "完了",
                Content = "Plot" .. i .. " を破壊しました",
                Duration = 3,
                Image = 4483345998
            })
            isBreaking = false
        end)
    end
})

PlotTab:CreateToggle({
    Name = "自動連続破壊 (全Plotループ)",
    CurrentValue = false,
    Flag = "AutoBreak",
    Callback = function(Value)
        autoBreak = Value
        if autoBreak then
            task.spawn(function()
                while autoBreak do
                    if not isBreaking then
                        local inv = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
                        if inv then
                            local currentHRP = getHRP()
                            if currentHRP then
                                for i = 1, 5 do
                                    local shur = nil
                                    local conn = inv.ChildAdded:Connect(function(child)
                                        if child.Name == "NinjaShuriken" then
                                            shur = child
                                            conn:Disconnect()
                                        end
                                    end)

                                    local spawnToy = ReplicatedStorage:FindFirstChild("MenuToys")
                                    if spawnToy then
                                        local spawnFunc = spawnToy:FindFirstChild("SpawnToyRemoteFunction")
                                        if spawnFunc then
                                            spawnFunc:InvokeServer("NinjaShuriken", currentHRP.CFrame * CFrame.new(5, 8, 20), Vector3.new(0, 0, 0))
                                        end
                                    end

                                    local startTime = tick()
                                    repeat
                                        if shur and shur:FindFirstChild("StickyPart") and shur:FindFirstChild("SoundPart") then
                                            break
                                        end
                                        task.wait(0.01)
                                    until tick() - startTime > 0.5
                                    shur = shur or inv:FindFirstChild("NinjaShuriken")

                                    if shur then
                                        local soundPart = shur:FindFirstChild("SoundPart")
                                        local stickyPart = shur:FindFirstChild("StickyPart")
                                        if soundPart and stickyPart then
                                            local grabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
                                            if grabEvents then
                                                local setOwner = grabEvents:FindFirstChild("SetNetworkOwner")
                                                if setOwner then
                                                    for j = 1, 15 do
                                                        setOwner:FireServer(soundPart, soundPart.CFrame)
                                                        if soundPart:FindFirstChild("PartOwner") and soundPart.PartOwner.Value == LP.Name then
                                                            break
                                                        end
                                                    end
                                                end
                                            end

                                            for _, obj in pairs(shur:GetChildren()) do
                                                if obj:IsA("BasePart") then
                                                    obj.CanTouch = false
                                                    obj.CanCollide = false
                                                    obj.Transparency = 1
                                                end
                                            end
                                            shur.Name = "Noclipped"

                                            local plot = Workspace:FindFirstChild("Plots")
                                            if plot then
                                                plot = plot:FindFirstChild("Plot" .. i)
                                                if plot then
                                                    local plotArea = plot:FindFirstChild("PlotArea")
                                                    if plotArea then
                                                        local playerEvents = ReplicatedStorage:FindFirstChild("PlayerEvents")
                                                        if playerEvents then
                                                            local stickyEvent = playerEvents:FindFirstChild("StickyPartEvent")
                                                            if stickyEvent then
                                                                stickyEvent:FireServer(stickyPart, plotArea, CFrame.new(1e12, 1e12, 1e12))
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

-- バリア破壊
local function EBB()
    local W = Workspace
    local R = ReplicatedStorage
    
    local pi = W:FindFirstChild("PlotItems")
    if pi then
        local pip = pi:FindFirstChild("PlayersInPlots")
        if pip and pip:FindFirstChild(LP.Name) then
            Rayfield:Notify({
                Title = "エラー",
                Content = "家の外で実行してください",
                Duration = 3,
                Image = 4483345998
            })
            return false
        end
    end
    
    local s, r = pcall(function()
        if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "エラー",
                Content = "キャラクターが見つかりません",
                Duration = 3,
                Image = 4483345998
            })
            return false
        end
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if not h then
            Rayfield:Notify({
                Title = "エラー",
                Content = "Humanoidが見つかりません",
                Duration = 3,
                Image = 4483345998
            })
            return false
        end
        
        local ws, op = h.WalkSpeed, LP.Character.HumanoidRootPart.CFrame
        h.WalkSpeed = 0
        
        local menuToys = R:FindFirstChild("MenuToys")
        if not menuToys then
            h.WalkSpeed = ws
            Rayfield:Notify({
                Title = "エラー",
                Content = "MenuToysが見つかりません",
                Duration = 3,
                Image = 4483345998
            })
            return false
        end
        
        local spawnFunc = menuToys:FindFirstChild("SpawnToyRemoteFunction")
        if spawnFunc then
            spawnFunc:InvokeServer("InstrumentWoodwindOcarina", 
                CFrame.new(184.148834,-5.54824972,498.136749), 
                Vector3.new(0,34,0))
        end
        task.wait(0.2)
        
        local tf = W:FindFirstChild(LP.Name.."SpawnedInToys")
        if not tf or not tf:FindFirstChild("InstrumentWoodwindOcarina") then
            h.WalkSpeed = ws
            Rayfield:Notify({
                Title = "エラー",
                Content = "オカリナが見つかりません",
                Duration = 3,
                Image = 4483345998
            })
            return false
        end
        
        local oc = tf:FindFirstChild("InstrumentWoodwindOcarina")
        if oc and oc:FindFirstChild("HoldPart") then
            local holdFunc = oc.HoldPart:FindFirstChild("HoldItemRemoteFunction")
            if holdFunc then
                holdFunc:InvokeServer(oc, W[LP.Name])
            end
        end
        
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(304.06,25.77,488.54)
        end
        task.wait(0.1)
        
        local destroyFunc = menuToys:FindFirstChild("DestroyToy")
        if destroyFunc and tf and tf:FindFirstChild("InstrumentWoodwindOcarina") then
            destroyFunc:FireServer(tf.InstrumentWoodwindOcarina)
        end
        
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = op
        end
        task.wait(0.3)
        
        if spawnFunc then
            spawnFunc:InvokeServer("Campfire", 
                CFrame.new(257.638672,-5.57392979,450.103638), 
                Vector3.new(0,161.9720001220703,0))
        end
        task.wait(0.3)
        
        local cp = Vector3.new(257.638672,-5.57392979,450.103638)
        local tf2 = W:FindFirstChild(LP.Name.."SpawnedInToys")
        if tf2 and tf2:FindFirstChild("Campfire") then
            local cf = tf2:FindFirstChild("Campfire")
            local pp = cf.PrimaryPart or cf:FindFirstChildWhichIsA("BasePart")
            if pp and (pp.Position - cp).Magnitude < 10 then
                task.wait(0.5)
                h.WalkSpeed = ws
                Rayfield:Notify({
                    Title = "成功",
                    Content = "バリア破壊に成功！",
                    Duration = 3,
                    Image = 4483345998
                })
                return true
            end
        end
        
        h.WalkSpeed = ws
        Rayfield:Notify({
            Title = "失敗",
            Content = "キャンプファイア配置失敗",
            Duration = 3,
            Image = 4483345998
        })
        return false
    end)
    
    if not s then
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = 16 end
        end
        Rayfield:Notify({
            Title = "エラー",
            Content = "実行エラー: "..tostring(r),
            Duration = 3,
            Image = 4483345998
        })
        return false
    end
    return r
end

local function continuousBarrierBreak()
    task.spawn(function()
        for i = 1, 5 do
            EBB()
            task.wait(1)
        end
    end)
end

PlotTab:CreateButton({
    Name = "🧱 Break Barrier (1回実行)",
    Callback = function() 
        task.spawn(EBB) 
    end
})

PlotTab:CreateButton({
    Name = "🧱 Break Barrier (連続実行)",
    Callback = function() 
        task.spawn(continuousBarrierBreak) 
    end
})

-- ============================================================
-- テレポート機能
-- ============================================================
local function UpdateTeleportPlayerLists()
    local options = {}
    for _, p in Players:GetPlayers() do
        if p ~= LP then table.insert(options, p.Name) end
    end
    return options
end

local function teleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if not target then 
        Rayfield:Notify({
            Title = "エラー",
            Content = "プレイヤーが見つかりません",
            Duration = 3,
            Image = 4483345998
        })
        return 
    end
    local targetChar = target.Character
    if not targetChar then 
        Rayfield:Notify({
            Title = "エラー",
            Content = "プレイヤーのキャラクターが見つかりません",
            Duration = 3,
            Image = 4483345998
        })
        return 
    end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then 
        Rayfield:Notify({
            Title = "エラー",
            Content = "プレイヤーのHumanoidRootPartが見つかりません",
            Duration = 3,
            Image = 4483345998
        })
        return 
    end
    local myChar = LP.Character
    if not myChar then 
        Rayfield:Notify({
            Title = "エラー",
            Content = "自分のキャラクターが見つかりません",
            Duration = 3,
            Image = 4483345998
        })
        return 
    end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then 
        Rayfield:Notify({
            Title = "エラー",
            Content = "自分のHumanoidRootPartが見つかりません",
            Duration = 3,
            Image = 4483345998
        })
        return 
    end
    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 3, 2)
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    Rayfield:Notify({
        Title = "テレポート完了",
        Content = target.Name .. " の近くにテレポートしました",
        Duration = 3,
        Image = 4483345998
    })
end

local TeleportSection = TeleportTab:CreateSection("テレポート")

local TeleportDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Default = "",
    Options = UpdateTeleportPlayerLists(),
    Callback = function(v) 
        selectedTeleportPlayer = v 
        print("📍 テレポート先: " .. v)
    end
})

TeleportTab:CreateButton({
    Name = "🔄 Refresh Players",
    Callback = function()
        TeleportDropdown:Refresh(UpdateTeleportPlayerLists())
        print("🔄 更新完了")
    end
})

TeleportTab:CreateButton({
    Name = "📍 選択したプレイヤーにテレポート",
    Callback = function()
        if selectedTeleportPlayer then
            task.spawn(function()
                teleportToPlayer(selectedTeleportPlayer)
            end)
        else
            Rayfield:Notify({
                Title = "エラー",
                Content = "プレイヤーを選択してください",
                Duration = 3,
                Image = 4483345998
            })
        end
    end
})

TeleportTab:CreateButton({
    Name = "📍 スポーン地点にテレポート",
    Callback = function()
        task.spawn(function()
            local spawn = Workspace:FindFirstChild("SpawnLocation")
            if not spawn then
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "スポーン地点が見つかりません",
                    Duration = 3,
                    Image = 4483345998
                })
                return
            end
            local myChar = LP.Character
            if not myChar then 
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "自分のキャラクターが見つかりません",
                    Duration = 3,
                    Image = 4483345998
                })
                return 
            end
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then 
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "自分のHumanoidRootPartが見つかりません",
                    Duration = 3,
                    Image = 4483345998
                })
                return 
            end
            myHRP.CFrame = spawn.CFrame * CFrame.new(0, 3, 0)
            myHRP.AssemblyLinearVelocity = Vector3.zero
            myHRP.AssemblyAngularVelocity = Vector3.zero
            Rayfield:Notify({
                Title = "テレポート完了",
                Content = "スポーン地点にテレポートしました",
                Duration = 3,
                Image = 4483345998
            })
        end)
    end
})

TeleportTab:CreateButton({
    Name = "☁️ 上空100mにテレポート",
    Callback = function()
        local myChar = LP.Character
        if not myChar then 
            Rayfield:Notify({
                Title = "エラー",
                Content = "自分のキャラクターが見つかりません",
                Duration = 3,
                Image = 4483345998
            })
            return 
        end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then 
            Rayfield:Notify({
                Title = "エラー",
                Content = "自分のHumanoidRootPartが見つかりません",
                Duration = 3,
                Image = 4483345998
            })
            return 
        end
        myHRP.CFrame = CFrame.new(myHRP.Position.X, myHRP.Position.Y + 100, myHRP.Position.Z)
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
        Rayfield:Notify({
            Title = "テレポート完了",
            Content = "上空100mにテレポートしました",
            Duration = 3,
            Image = 4483345998
        })
    end
})

-- ============================================================
-- Silent Aim（FOV円表示なし版）
-- ============================================================
local Vars = {
    Camera = Workspace.CurrentCamera,
    _G_SilentEnabled = false,
    _G_ReachOverride = 50,
    _G_FOVOverride = 200,
    TargetHRP = nil
}

local SilentSection = SilentTab:CreateSection("PC Silent Aim")

SilentTab:CreateToggle({
    Name = "Silent Aim Enabled",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(v) 
        Vars._G_SilentEnabled = v 
        print("🎯 Silent Aim: " .. (v and "ON" or "OFF"))
    end 
})

SilentTab:CreateSlider({
    Name = "Reach Distance",
    Range = {10, 2000},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Callback = function(v) 
        Vars._G_ReachOverride = v 
        print("📏 Reach: " .. v)
    end 
})

SilentTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 1000},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 200,
    Callback = function(v) 
        Vars._G_FOVOverride = v 
        print("📏 FOV: " .. v)
    end 
})

-- ============================================================
-- Silent Aim 実行部分
-- ============================================================
local function GetTargetInFOV()
    if not Vars._G_SilentEnabled then return nil end
    
    local camera = Workspace.CurrentCamera
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    local nearestTarget = nil
    local nearestDistance = Vars._G_FOVOverride
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and hrp then
                local screenPos, onScreen = camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local screen2D = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (screen2D - center).Magnitude
                    
                    if dist < nearestDistance then
                        nearestDistance = dist
                        nearestTarget = hrp
                    end
                end
            end
        end
    end
    
    return nearestTarget
end

local function GetTargetInReach()
    if not Vars._G_SilentEnabled then return nil end
    
    local camera = Workspace.CurrentCamera
    local rayOrigin = camera.CFrame.Position
    local rayDirection = camera.CFrame.LookVector
    
    local nearestTarget = nil
    local nearestDistance = Vars._G_ReachOverride
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and hrp then
                local toTarget = (hrp.Position - rayOrigin)
                local distance = toTarget.Magnitude
                
                if distance < nearestDistance then
                    local dot = rayDirection:Dot(toTarget.Unit)
                    if dot > 0.5 then
                        nearestDistance = distance
                        nearestTarget = hrp
                    end
                end
            end
        end
    end
    
    return nearestTarget
end

-- Silent Aim メインループ
task.spawn(function()
    while task.wait() do
        if Vars._G_SilentEnabled then
            local camera = Workspace.CurrentCamera
            local target = GetTargetInFOV() or GetTargetInReach()
            
            if target then
                Vars.TargetHRP = target
                
                local lookPos = target.Position
                local newCFrame = CFrame.new(camera.CFrame.Position, lookPos)
                
                camera.CFrame = newCFrame
                
                print("🎯 ターゲット: ", target.Parent.Name, "距離: ", (target.Position - camera.CFrame.Position).Magnitude)
            else
                Vars.TargetHRP = nil
            end
        end
    end
end)

-- ============================================================
-- プレイヤー機能
-- ============================================================

local PlayerSection = PlayerTab:CreateSection("移動設定")

local sprintEnabled = false
local walkSpeedValue = 16

PlayerTab:CreateToggle({
    Name = "歩行速度 有効/無効",
    CurrentValue = false,
    Flag = "Sprint",
    Callback = function(v)
        sprintEnabled = v
    end
})

PlayerTab:CreateSlider({
    Name = "歩行速度",
    Range = {0, 500},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Callback = function(v)
        walkSpeedValue = v
    end
})

RunService.RenderStepped:Connect(function()
    if not sprintEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass('Humanoid')
    local root = char:FindFirstChild('HumanoidRootPart')
    if not hum or not root then return end
    local dir = hum.MoveDirection
    if dir.Magnitude > 0 then
        root.AssemblyLinearVelocity = Vector3.new(dir.Unit.X * walkSpeedValue, root.AssemblyLinearVelocity.Y, dir.Unit.Z * walkSpeedValue)
    end
end)

local infJumpEnabled = false

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LP.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerTab:CreateToggle({
    Name = "無限ジャンプ",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(v)
        infJumpEnabled = v
    end
})

local noclipConnection = nil

local function ToggleNoClip(state)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LP.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

PlayerTab:CreateToggle({
    Name = "ノークリップ",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(v)
        ToggleNoClip(v)
    end
})

-- ============================================================
-- Grabkick機能
-- ============================================================
local aa1 = game:GetService("Players")
local aa2 = game:GetService("ReplicatedStorage")
local aa3 = game:GetService("RunService")
local aa82 = game:GetService("Workspace")

local aa4 = aa1.LocalPlayer
local aa5 = aa2:WaitForChild("GrabEvents")

local aa6 = false
local aa7 = {nil, nil, nil, nil, nil}
local aa8 = 15
local aa9 = 25

local aa10 = aa2:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
local aa11 = aa5:WaitForChild("SetNetworkOwner")

local aa12 = {
    aa13 = false
}
local aa14 = {
    aa15 = {nil, nil, nil, nil, nil},
}
local aa16 = {}
local aa17 = false

local running = false
local ragServer = false
local targetLag = false
local selectedPlayerName = nil

local createLineRemote = aa5:FindFirstChild("CreateGrabLine")
local lagMultiplier = 2

local aa72List = {nil, nil, nil, nil, nil}

local function aa18()
    local aa19 = {}
    for _, aa20 in ipairs(aa1:GetPlayers()) do
        if aa20 ~= aa4 then
            table.insert(aa19, aa20.DisplayName .. " (@" .. aa20.Name .. ")")
        end
    end
    return aa19
end

local function aa21(aa22)
    for _, aa23 in ipairs(aa1:GetPlayers()) do
        local aa24 = aa23.DisplayName .. " (@" .. aa23.Name .. ")"
        if aa24 == aa22 then return aa23 end
    end
    return nil
end

local function aa25(aa26, aa27)
    if not aa26.Character then return end
    local aa28 = aa26.Character:FindFirstChild("HumanoidRootPart")
    if not aa28 or not aa27 then return end

    local aa29 = aa27.CFrame
    aa27.CFrame = aa28.CFrame * CFrame.new(0, 0, 2)

    for aa30 = 1, 15 do
        aa11:FireServer(aa28, aa28.CFrame)
        task.wait()
    end

    aa27.CFrame = aa29
end

local function aa31(aa32, aa33, aa34)
    return aa32:FindFirstChild(aa33) or aa32:WaitForChild(aa33, aa34 or 5)
end

local function aa35(aa36)
    if aa36 and aa36:IsA("BasePart") then
        aa11:FireServer(aa36, aa36.CFrame)
        task.wait()
    end
end

local function aa37(aa38, aa39)
    return aa38:FindFirstChild(aa39) ~= nil
end

local function aa40(aa41, offsetIndex)
    local aa42 = aa4.Character or aa4.CharacterAdded:Wait()
    local aa43 = aa42:WaitForChild("HumanoidRootPart")

    local waitCount = 0
    while (aa4.InPlot.Value and not aa4.InOwnedPlot.Value) and waitCount < 50 do
        task.wait(0.1)
        waitCount = waitCount + 1
    end
    waitCount = 0
    while not aa4.CanSpawnToy.Value and waitCount < 50 do
        task.wait(0.1)
        waitCount = waitCount + 1
    end

    local offset = Vector3.new((offsetIndex or 0) * 5, 0, 0)
    local aa44 = aa43.CFrame * CFrame.new(0, 14, 20) + offset

    local aa45 = workspace:FindFirstChild(aa4.Name.."SpawnedInToys")
    if not aa45 then
        aa45 = workspace:FindFirstChild("PlotItems")
        if aa45 then
            aa45 = aa45:FindFirstChild("Plot1")
        end
    end
    if not aa45 then
        aa45 = workspace
    end

    local aa46 = nil
    local aa47 = aa45.ChildAdded:Connect(function(aa48)
        if aa48.Name == aa41 then
            aa46 = aa48
        end
    end)

    task.spawn(function()
        pcall(function()
            aa10:InvokeServer(aa41, aa44, Vector3.zero)
        end)
    end)

    local aa49 = tick()
    repeat task.wait(0.05) until aa46 or (tick() - aa49) > 5
    aa47:Disconnect()
    return aa46
end

local function aa50(offsetIndex)
    if aa17 then return nil end
    aa17 = true

    local aa51 = aa40("PalletLightBrown", offsetIndex)
    if not aa51 then
        aa17 = false
        return nil
    end

    local aa52 = aa31(aa51, "SoundPart", 3)
    if not aa52 then
        aa51:Destroy()
        aa17 = false
        return nil
    end

    local retryCount = 0
    while retryCount < 10 do
        if not aa12.aa13 then
            aa51:Destroy()
            aa17 = false
            return nil
        end
        aa35(aa52)
        task.wait()
        if aa37(aa52, "PartOwner") then
            break
        end
        retryCount = retryCount + 1
    end

    if not aa37(aa52, "PartOwner") then
        aa51:Destroy()
        aa17 = false
        return nil
    end

    for _, aa54 in pairs(aa51:GetDescendants()) do
        if aa54:IsA("BasePart") then
            aa54.CanCollide = false
            aa54.Transparency = 0.8
        end
    end
    aa51.Name = "RagdollPalete"

    local aa55 = Instance.new("BodyVelocity")
    aa55.MaxForce = Vector3.new(0, math.huge, 0)
    aa55.Velocity = Vector3.new(0, 900, 0)
    aa55.Parent = aa52

    aa17 = false
    return aa51
end

local function startLagSpam()
    if running then return end
    if not createLineRemote then return end
    running = true

    task.spawn(function()
        while running do
            local spawnLocation = aa82:FindFirstChild("SpawnLocation")
                or aa82:FindFirstChild("Spawn")
                or (aa4.Character and aa4.Character:FindFirstChild("HumanoidRootPart"))

            if spawnLocation then
                for _ = 1, lagMultiplier do
                    createLineRemote:FireServer(spawnLocation, CFrame.new(math.random(-2010000000, 2000000001), 0, math.random(-2008100000, 2000200000)))
                end
            end
            task.wait()
        end
    end)
end

local function stopLagSpam()
    if not running then return end
    running = false
end

local GrabSection = GrabTab:CreateSection("Grabkick")

local dropdowns = {}
for i = 1, 5 do
    local dropdown = GrabTab:CreateDropdown({
        Name = "Target " .. i,
        Default = "",
        Options = aa18(),
        Callback = function(aa59)
            aa7[i] = aa59
            local aa60 = aa21(aa59)
            if aa60 then
                aa14.aa15[i] = aa60.Name
            else
                aa14.aa15[i] = nil
            end
        end
    })
    dropdowns[i] = dropdown
end

GrabTab:CreateSlider({
    Name = "Lag Power (Multiplier)",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 2,
    Callback = function(value)
        lagMultiplier = value
        if running then
            stopLagSpam()
            task.wait(0.1)
            startLagSpam()
        end
    end
})

GrabTab:CreateToggle({
    Name = "Grab kick (BETA)",
    CurrentValue = false,
    Flag = "GrabKick",
    Callback = function(aa61)
        aa6 = aa61
        aa12.aa13 = aa61

        if aa61 then
            startLagSpam()
        else
            stopLagSpam()
        end

        if aa6 then
            task.spawn(function()
                while aa6 do
                    for idx = 1, 5 do
                        local targetDisplay = aa7[idx]
                        if targetDisplay and targetDisplay ~= "" then
                            local aa62 = aa21(targetDisplay)
                            local aa63 = aa4.Character
                            local aa64 = aa63 and aa63:FindFirstChild("HumanoidRootPart")

                            if aa62 and aa64 then
                                local aa65 = aa62.Character
                                local aa66 = aa65 and aa65:FindFirstChild("HumanoidRootPart")

                                if aa66 then
                                    local aa67 = (aa64.Position - aa66.Position).Magnitude
                                    if aa67 > aa9 then
                                        aa25(aa62, aa64)
                                    end

                                    aa11:FireServer(aa66, aa66.CFrame)
                                    if aa5:FindFirstChild("DestroyGrabLine") then
                                        aa5.DestroyGrabLine:FireServer(aa66)
                                    end

                                    aa66.AssemblyLinearVelocity = Vector3.zero
                                    aa66.AssemblyAngularVelocity = Vector3.zero

                                    local aa68 = aa66:FindFirstChild("ControlBP")
                                    if not aa68 then
                                        aa68 = Instance.new("BodyPosition")
                                        aa68.Name = "ControlBP"
                                        aa68.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        aa68.P = 800000
                                        aa68.Parent = aa66
                                    end
                                    local angle = (idx - 1) * 2 * math.pi / 5
                                    local radius = 10
                                    local height = 5
                                    local offset = Vector3.new(
                                        radius * math.cos(angle),
                                        height,
                                        radius * math.sin(angle)
                                    )
                                    aa68.Position = aa64.Position + offset
                                end
                            end
                        end
                    end
                    task.wait()
                end

                for idx = 1, 5 do
                    local targetDisplay = aa7[idx]
                    if targetDisplay and targetDisplay ~= "" then
                        local aa69 = aa21(targetDisplay)
                        if aa69 and aa69.Character then
                            local aa70 = aa69.Character:FindFirstChild("HumanoidRootPart")
                            if aa70 and aa70:FindFirstChild("ControlBP") then
                                aa70.ControlBP:Destroy()
                            end
                        end
                    end
                end
            end)
        end

        if aa61 then
            local aa71 = workspace:FindFirstChild(aa4.Name.."SpawnedInToys")
            aa16["aa73"] = aa3.RenderStepped:Connect(function()
                if not aa12.aa13 then return end

                for idx = 1, 5 do
                    local targetName = aa14.aa15[idx]
                    if not targetName then
                        if aa72List[idx] and aa72List[idx]:IsDescendantOf(workspace) then
                            aa72List[idx]:Destroy()
                            aa72List[idx] = nil
                        end
                        continue
                    end

                    local aa74 = aa1:FindFirstChild(targetName)
                    if not aa74 or not aa74.Character then
                        if aa72List[idx] and aa72List[idx]:IsDescendantOf(workspace) then
                            aa72List[idx]:Destroy()
                            aa72List[idx] = nil
                        end
                        continue
                    end

                    local aa75 = aa74.Character:FindFirstChild("HumanoidRootPart")
                    local aa76 = aa74.Character:FindFirstChild("Humanoid")
                    if not aa75 or not aa76 then continue end

                    local pallet = aa72List[idx]
                    if pallet and pallet:IsDescendantOf(workspace) then
                        local soundPart = pallet:FindFirstChild("SoundPart")
                        if soundPart then
                            if not aa37(soundPart, "PartOwner") then
                                pallet:Destroy()
                                aa72List[idx] = nil
                            end
                        else
                            pallet:Destroy()
                            aa72List[idx] = nil
                        end
                    end

                    if not aa17 and (not aa72List[idx] or not aa72List[idx]:IsDescendantOf(workspace)) then
                        aa72List[idx] = aa50(idx)
                    end

                    if aa72List[idx] and aa72List[idx]:IsDescendantOf(workspace) then
                        local soundPart = aa72List[idx]:FindFirstChild("SoundPart")
                        if soundPart then
                            local ragdolled = aa76:FindFirstChild("Ragdolled")
                            if ragdolled and not ragdolled.Value then
                                soundPart.Position = aa75.Position
                            end
                        end
                    end
                end
            end)
        else
            if aa16["aa73"] then
                aa16["aa73"]:Disconnect()
                aa16["aa73"] = nil
            end
            for idx = 1, 5 do
                if aa72List[idx] and aa72List[idx]:IsDescendantOf(workspace) then
                    aa72List[idx]:Destroy()
                    aa72List[idx] = nil
                end
            end
        end
    end
})

-- プレイヤー追加/削除時に全ドロップダウンを更新
local function aa79(aa80)
    if aa80 then
        for i = 1, 5 do
            if aa14.aa15[i] == aa80.Name then
                aa14.aa15[i] = nil
                aa7[i] = nil
            end
        end
    end
    for i = 1, 5 do
        dropdowns[i]:Refresh(aa18())
    end
end

aa1.PlayerAdded:Connect(function()
    task.wait(0.5)
    aa79()
end)
aa1.PlayerRemoving:Connect(aa79)

-- ============================================================
-- プレイヤー追加/削除で更新
-- ============================================================
Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    TeleportDropdown:Refresh(UpdateTeleportPlayerLists())
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    TeleportDropdown:Refresh(UpdateTeleportPlayerLists())
end)

-- ============================================================
-- 初期化
-- ============================================================
send("GR_COOLKID hub Private v1.5起動中...")
task.wait(0.3)
send("byGR_COOLKID")

print("========================================")
print("GR_COOLKID hub Private v1.5 - Rayfield版")
print("家破壊 / テレポート / Silent Aim / プレイヤー / Grabkick")
print("🔑 Key: ZWExOarKtFvomRQjoTqtyyEkzopHEwtb")
print("全機能ロード完了")
print("========================================")
