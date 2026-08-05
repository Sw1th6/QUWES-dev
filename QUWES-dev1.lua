-- ============================================
-- QUWES - Advanced Roblox Script
-- Фиолетовая тема | Водяной знак справа | HUD + Наблюдатели
-- ============================================

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/twistedk1d/BloxStrike/refs/heads/main/Source/UI/source.lua"))()

--// Создание окна
local Window = Rayfield:CreateWindow({
    Name = "QUWES",
    Icon = 0,
    LoadingTitle = "Загрузка QUWES (Blox Strike)",
    LoadingSubtitle = "by .Sparky9971",
    ShowText = "QUWES",
    Theme = "Amethyst",
    ToggleUIKeybind = Enum.KeyCode.RightShift,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "QUWES",
        FileName = "QUWES"
    }
})

--// Создание водяного знака (СПРАВА ВНИЗУ)
local function CreateWatermark()
    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QUWES_Watermark"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    local watermark = Instance.new("TextLabel")
    watermark.Name = "Watermark"
    watermark.Text = "QUWES"
    watermark.TextColor3 = Color3.fromRGB(128, 0, 255)
    watermark.TextScaled = true
    watermark.Font = Enum.Font.GothamBold
    watermark.BackgroundTransparency = 1
    watermark.TextTransparency = 0.15
    watermark.Size = UDim2.new(0, 200, 0, 60)
    watermark.Position = UDim2.new(1, -220, 1, -80)
    watermark.Parent = screenGui
    
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 50, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
    })
    glow.Rotation = 45
    glow.Parent = watermark
end

task.spawn(CreateWatermark)

--// ==========================================
--// HUD ФУНКЦИЯ (с наблюдателями)
--// ==========================================
local HUDEnabled = false
local HUDFrame = nil
local HUDLabels = {}

local function CreateHUD()
    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QUWES_HUD"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = false
    
    -- Главный фрейм HUD (слева сверху)
    local frame = Instance.new("Frame")
    frame.Name = "HUD_Frame"
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.15
    frame.BorderColor3 = Color3.fromRGB(128, 0, 255)
    frame.BorderSizePixel = 2
    frame.Size = UDim2.new(0, 300, 0, 260)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.Parent = screenGui
    
    -- Заголовок HUD
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "⚡ QUWES HUD"
    title.TextColor3 = Color3.fromRGB(128, 0, 255)
    title.TextScaled = false
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Parent = frame
    
    -- Разделительная линия
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    line.BackgroundTransparency = 0.5
    line.Size = UDim2.new(0.9, 0, 0, 1)
    line.Position = UDim2.new(0.05, 0, 0, 35)
    line.Parent = frame
    
    -- Информационные строки
    local infoData = {
        {Name = "GameMode", Text = "📌 Режим: Загрузка...", Y = 50},
        {Name = "Distance", Text = "📏 Дистанция: 0m", Y = 75},
        {Name = "Health", Text = "❤️ HP: 0/0", Y = 100},
        {Name = "Weapon", Text = "🔫 Оружие: Нет", Y = 125},
        {Name = "EnemyName", Text = "👤 Игрок: Нет", Y = 150},
        {Name = "Spectators", Text = "👀 Наблюдатели: Нет", Y = 175}
    }
    
    for _, data in ipairs(infoData) do
        local label = Instance.new("TextLabel")
        label.Name = data.Name
        label.Text = data.Text
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.TextScaled = false
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0, 10, 0, data.Y)
        label.Parent = frame
        HUDLabels[data.Name] = label
    end
    
    -- Статус наблюдателей (анимированный)
    local specStatus = Instance.new("TextLabel")
    specStatus.Name = "SpecStatus"
    specStatus.Text = ""
    specStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    specStatus.TextScaled = false
    specStatus.Font = Enum.Font.GothamBold
    specStatus.TextSize = 12
    specStatus.TextXAlignment = Enum.TextXAlignment.Left
    specStatus.BackgroundTransparency = 1
    specStatus.Size = UDim2.new(1, -20, 0, 20)
    specStatus.Position = UDim2.new(0, 10, 0, 200)
    specStatus.Parent = frame
    
    HUDFrame = frame
    return screenGui
end

local HUDGui = CreateHUD()

--// Функция получения наблюдателей
local function GetSpectators()
    local player = game.Players.LocalPlayer
    local spectators = {}
    
    -- Проверяем всех игроков
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            -- Проверяем, смотрит ли игрок на нас
            local character = plr.Character
            if character then
                local hum = character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local cameraSubject = workspace.CurrentCamera.CameraSubject
                    if cameraSubject == plr.Character then
                        table.insert(spectators, plr.Name)
                    end
                end
            end
        end
    end
    
    return spectators
end

--// Функция обновления HUD
local function UpdateHUD()
    if not HUDEnabled then return end
    
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local charactersFolder = workspace:FindFirstChild("Characters", 10)
    
    if not charactersFolder or not player.Character then
        HUDLabels.GameMode.Text = "📌 Режим: Не в игре"
        HUDLabels.Distance.Text = "📏 Дистанция: 0m"
        HUDLabels.Health.Text = "❤️ HP: 0/0"
        HUDLabels.Weapon.Text = "🔫 Оружие: Нет"
        HUDLabels.EnemyName.Text = "👤 Игрок: Нет"
        HUDLabels.Spectators.Text = "👀 Наблюдатели: Нет"
        return
    end
    
    -- Определение режима игры
    local gameMode = "Неизвестно"
    local gameState = workspace:FindFirstChild("GameState")
    if gameState then
        local state = gameState:FindFirstChild("CurrentState")
        if state then
            if state.Value == "Warmup" then gameMode = "Разминка"
            elseif state.Value == "Playing" then gameMode = "Игра"
            elseif state.Value == "GameEnd" then gameMode = "Конец игры"
            else gameMode = tostring(state.Value) end
        end
    end
    
    -- Определение команды игрока
    local myTeam = nil
    local tFolder = charactersFolder:FindFirstChild("Terrorists")
    local ctFolder = charactersFolder:FindFirstChild("Counter-Terrorists")
    
    if tFolder and tFolder:FindFirstChild(player.Name) then myTeam = "T"
    elseif ctFolder and ctFolder:FindFirstChild(player.Name) then myTeam = "CT" end
    
    if myTeam then
        gameMode = gameMode .. " [" .. myTeam .. "]"
    end
    
    -- Поиск ближайшего врага
    local enemyFolder = nil
    if myTeam == "T" then enemyFolder = ctFolder
    elseif myTeam == "CT" then enemyFolder = tFolder end
    
    local closestEnemy = nil
    local closestDistance = math.huge
    local enemyHealth = 0
    local enemyWeapon = "Нет"
    local enemyName = "Нет"
    
    if enemyFolder then
        local myPos = player.Character:FindFirstChild("HumanoidRootPart")
        if myPos then
            for _, enemy in ipairs(enemyFolder:GetChildren()) do
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    local dist = (myPos.Position - root.Position).Magnitude
                    if dist < closestDistance then
                        closestDistance = dist
                        closestEnemy = enemy
                        enemyHealth = hum.Health
                        enemyName = enemy.Name
                    end
                end
            end
        end
    end
    
    -- Получение оружия ближайшего врага
    if closestEnemy then
        local weapon = closestEnemy:FindFirstChildOfClass("Tool")
        if weapon then
            enemyWeapon = weapon.Name
        else
            for _, child in ipairs(closestEnemy:GetChildren()) do
                if child:IsA("Tool") then
                    enemyWeapon = child.Name
                    break
                end
            end
        end
    end
    
    -- Получение наблюдателей
    local spectators = GetSpectators()
    local specText = "👀 Наблюдатели: "
    if #spectators > 0 then
        specText = specText .. table.concat(spectators, ", ")
    else
        specText = specText .. "Нет"
    end
    
    -- Обновление HUD
    HUDLabels.GameMode.Text = "📌 Режим: " .. gameMode
    HUDLabels.Distance.Text = "📏 Дистанция: " .. math.floor(closestDistance) .. "m"
    HUDLabels.Health.Text = "❤️ HP: " .. math.floor(enemyHealth) .. "/100"
    HUDLabels.Weapon.Text = "🔫 Оружие: " .. enemyWeapon
    HUDLabels.EnemyName.Text = "👤 Игрок: " .. enemyName
    HUDLabels.Spectators.Text = specText
    
    -- Цвет HP (красный если мало)
    if enemyHealth < 30 then
        HUDLabels.Health.TextColor3 = Color3.fromRGB(255, 50, 50)
    elseif enemyHealth < 60 then
        HUDLabels.Health.TextColor3 = Color3.fromRGB(255, 200, 50)
    else
        HUDLabels.Health.TextColor3 = Color3.fromRGB(128, 0, 255)
    end
    
    -- Предупреждение о наблюдателях (мигание)
    local specLabel = HUDLabels.Spectators
    if #spectators > 0 then
        specLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        -- Мигающий эффект
        task.spawn(function()
            for i = 1, 3 do
                specLabel.TextTransparency = 0.5
                task.wait(0.2)
                specLabel.TextTransparency = 0
                task.wait(0.2)
            end
        end)
    else
        specLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        specLabel.TextTransparency = 0
    end
end

--// Обновление HUD каждые 0.2 секунды
task.spawn(function()
    while task.wait(0.2) do
        UpdateHUD()
    end
end)

--// ==========================================
--// ДОБАВЛЯЕМ HUD В ВИЗУАЛЫ
--// ==========================================
-- ... (всё остальное остаётся как в предыдущем скрипте)
-- Я показываю только добавленную секцию в Visuals

--// ==========================================
--// VISUALS TAB LOGIC (ESP & WORLD + HUD)
--// ==========================================
local EspEnabled, EspBox, EspName, EspHealth, EspDistance = false, true, true, true, true
local espCache = {}

-- Создание ESP (фиолетовое)
local function createESP()
    local esp = {
        boxOutline = Drawing.new("Square"), box = Drawing.new("Square"),
        name = Drawing.new("Text"), distance = Drawing.new("Text"),
        healthOutline = Drawing.new("Line"), healthBar = Drawing.new("Line")
    }
    esp.boxOutline.Thickness = 3; esp.boxOutline.Filled = false; esp.boxOutline.Color = Color3.new(0, 0, 0)
    esp.box.Thickness = 2; esp.box.Filled = false; esp.box.Color = Color3.fromRGB(128, 0, 255)
    esp.name.Center = true; esp.name.Outline = true; esp.name.Color = Color3.fromRGB(128, 0, 255); esp.name.Size = 16
    esp.distance.Center = true; esp.distance.Outline = true; esp.distance.Color = Color3.fromRGB(128, 0, 255); esp.distance.Size = 13
    esp.healthOutline.Thickness = 3; esp.healthOutline.Color = Color3.new(0, 0, 0)
    esp.healthBar.Thickness = 2; esp.healthBar.Color = Color3.fromRGB(128, 0, 255)
    return esp
end

RunService.RenderStepped:Connect(function()
    if not EspEnabled or not isAlive() then
        for _, e in pairs(espCache) do for _, d in pairs(e) do d.Visible = false end end
        return
    end
    
    local enemyFolder = getEnemyFolder()
    if not enemyFolder then return end

    local currentAlive = {}
    for _, enemy in ipairs(enemyFolder:GetChildren()) do
        local hum, root, head = enemy:FindFirstChildOfClass("Humanoid"), enemy:FindFirstChild("HumanoidRootPart"), enemy:FindFirstChild("Head")

        if hum and hum.Health > 0 and root and head then
            currentAlive[enemy] = true
            if not espCache[enemy] then espCache[enemy] = createESP() end
            
            local esp = espCache[enemy]
            local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
            local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

            if onScreen then
                local boxH, boxW = math.abs(headPos.Y - legPos.Y), math.abs(headPos.Y - legPos.Y) / 2
                local dist = math.floor((camera.CFrame.Position - root.Position).Magnitude)

                if EspBox then
                    esp.boxOutline.Size = Vector2.new(boxW, boxH); esp.boxOutline.Position = Vector2.new(rootPos.X - boxW / 2, headPos.Y); esp.boxOutline.Visible = true
                    esp.box.Size = Vector2.new(boxW, boxH); esp.box.Position = Vector2.new(rootPos.X - boxW / 2, headPos.Y); esp.box.Visible = true
                else esp.boxOutline.Visible, esp.box.Visible = false, false end
                
                if EspHealth then
                    local hpPct, barX = hum.Health / hum.MaxHealth, rootPos.X - boxW / 2 - 6
                    esp.healthOutline.From = Vector2.new(barX, headPos.Y - 1); esp.healthOutline.To = Vector2.new(barX, headPos.Y + boxH + 1); esp.healthOutline.Visible = true
                    esp.healthBar.From = Vector2.new(barX, headPos.Y + boxH); esp.healthBar.To = Vector2.new(barX, headPos.Y + boxH - (boxH * hpPct)); esp.healthBar.Color = Color3.fromRGB(128, 0, 255)
                    esp.healthBar.Visible = true
                else esp.healthOutline.Visible, esp.healthBar.Visible = false, false end
                
                if EspName then esp.name.Text = enemy.Name; esp.name.Position = Vector2.new(rootPos.X, headPos.Y - 20); esp.name.Visible = true 
                else esp.name.Visible = false end

                if EspDistance then esp.distance.Text = "[" .. dist .. "m]"; esp.distance.Position = Vector2.new(rootPos.X, headPos.Y + boxH + 2); esp.distance.Visible = true
                else esp.distance.Visible = false end
            else for _, d in pairs(esp) do d.Visible = false end end
        end
    end
    for cEnemy, e in pairs(espCache) do
        if not currentAlive[cEnemy] then for _, d in pairs(e) do d:Remove() end; espCache[cEnemy] = nil end
    end
end)

--// ==========================================
--// ДОБАВЛЯЕМ HUD В ВИЗУАЛЫ
--// ==========================================
Tab_Visuals:CreateSection("ESP Master Switch")
Tab_Visuals:CreateToggle({Name = "Enable Player ESP", CurrentValue = false, Flag = "ESPToggle", Callback = function(Value) EspEnabled = Value end})

Tab_Visuals:CreateSection("ESP Settings")
Tab_Visuals:CreateToggle({Name = "Show Box", CurrentValue = true, Flag = "EspBoxToggle", Callback = function(Value) EspBox = Value end})
Tab_Visuals:CreateToggle({Name = "Show Health", CurrentValue = true, Flag = "EspHealthToggle", Callback = function(Value) EspHealth = Value end})
Tab_Visuals:CreateToggle({Name = "Show Name", CurrentValue = true, Flag = "EspNameToggle", Callback = function(Value) EspName = Value end})
Tab_Visuals:CreateToggle({Name = "Show Distance", CurrentValue = true, Flag = "EspDistanceToggle", Callback = function(Value) EspDistance = Value end})

-- ==========================================
-- НОВАЯ СЕКЦИЯ: HUD
-- ==========================================
Tab_Visuals:CreateSection("📊 HUD Settings")
Tab_Visuals:CreateToggle({
    Name = "Enable HUD",
    CurrentValue = false,
    Flag = "HUDToggle",
    Callback = function(Value)
        HUDEnabled = Value
        if HUDGui then
            HUDGui.Enabled = Value
            if Value then
                UpdateHUD()
            end
        end
    end
})

Tab_Visuals:CreateSection("🌍 World & Effects")
local AntiFlashEnabled, AntiSmokeEnabled = false, false
Tab_Visuals:CreateToggle({Name = "Anti-Flashbang", CurrentValue = false, Flag = "AntiFlashToggle", Callback = function(Value) AntiFlashEnabled = Value end})
Tab_Visuals:CreateToggle({Name = "Anti-Smoke", CurrentValue = false, Flag = "AntiSmokeToggle", Callback = function(Value) AntiSmokeEnabled = Value end})

task.spawn(function()
    while task.wait(0.2) do
        if AntiFlashEnabled then
            local gui, effect = player.PlayerGui:FindFirstChild("FlashbangEffect"), game:GetService("Lighting"):FindFirstChild("FlashbangColorCorrection")
            if gui then gui:Destroy() end; if effect then effect:Destroy() end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if AntiSmokeEnabled then
            local debris = Workspace:FindFirstChild("Debris")
            if debris then
                for _, folder in ipairs(debris:GetChildren()) do
                    if string.match(folder.Name, "Voxel") then folder:ClearAllChildren(); folder:Destroy() end
                end
            end
        end
    end
end)

print("QUWES успешно загружен! 💜")
