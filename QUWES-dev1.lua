-- ============================================
-- QUWES - Полный скрипт с анимациями
-- Фиолетовая тема | Водяной знак справа | Анимированный HUD
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

--// ==========================================
--// АНИМАЦИИ ДЛЯ HUD И GUI
--// ==========================================
local TweenService = game:GetService("TweenService")

--// Функция анимации появления HUD (выезжает справа)
local function AnimateHUDIn(guiElements)
    for _, element in ipairs(guiElements) do
        if element and element.Parent then
            local targetPos = element.Position
            local startPos = UDim2.new(
                targetPos.X.Scale + 0.3,
                targetPos.X.Offset + 300,
                targetPos.Y.Scale,
                targetPos.Y.Offset
            )
            element.Position = startPos
            element.Visible = true
            
            local tweenInfo = TweenInfo.new(
                0.4,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )
            local tween = TweenService:Create(element, tweenInfo, {
                Position = targetPos
            })
            tween:Play()
        end
    end
end

--// Функция анимации исчезновения HUD (уезжает влево)
local function AnimateHUDOut(guiElements, callback)
    local tweens = {}
    local completed = 0
    
    for _, element in ipairs(guiElements) do
        if element and element.Parent then
            local targetPos = element.Position
            local endPos = UDim2.new(
                targetPos.X.Scale - 0.3,
                targetPos.X.Offset - 300,
                targetPos.Y.Scale,
                targetPos.Y.Offset
            )
            
            local tweenInfo = TweenInfo.new(
                0.3,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.In
            )
            local tween = TweenService:Create(element, tweenInfo, {
                Position = endPos
            })
            
            tween:OnComplete(function()
                completed = completed + 1
                if completed >= #guiElements then
                    for _, el in ipairs(guiElements) do
                        if el then el.Visible = false end
                    end
                    if callback then callback() end
                end
            end)
            
            tween:Play()
            table.insert(tweens, tween)
        end
    end
    
    if #guiElements == 0 and callback then callback() end
end

--// Функция анимации GUI меню (появляется слева)
local function AnimateGUIIn()
    local gui = Window.Gui
    if not gui then return end
    
    local targetPos = gui.Position
    local startPos = UDim2.new(
        targetPos.X.Scale - 0.3,
        targetPos.X.Offset - 300,
        targetPos.Y.Scale,
        targetPos.Y.Offset
    )
    gui.Position = startPos
    gui.Visible = true
    
    local tweenInfo = TweenInfo.new(
        0.4,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(gui, tweenInfo, {
        Position = targetPos
    })
    tween:Play()
end

--// Функция анимации GUI меню (исчезает вправо)
local function AnimateGUIOut(callback)
    local gui = Window.Gui
    if not gui then 
        if callback then callback() end
        return 
    end
    
    local targetPos = gui.Position
    local endPos = UDim2.new(
        targetPos.X.Scale + 0.3,
        targetPos.X.Offset + 300,
        targetPos.Y.Scale,
        targetPos.Y.Offset
    )
    
    local tweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )
    local tween = TweenService:Create(gui, tweenInfo, {
        Position = endPos
    })
    
    tween:OnComplete(function()
        gui.Visible = false
        if callback then callback() end
    end)
    
    tween:Play()
end

--// Переопределяем методы Rayfield для анимаций
local originalToggleUI = Window.ToggleUI
Window.ToggleUI = function()
    local gui = Window.Gui
    if gui.Visible then
        AnimateGUIOut()
    else
        AnimateGUIIn()
    end
end

--// ==========================================
--// Services & Globals
--// ==========================================
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local CharactersFolder = workspace:WaitForChild("Characters", 10)

--// ==========================================
--// Создание водяного знака (СПРАВА ВНИЗУ)
--// ==========================================
local function CreateWatermark()
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
--// HUD НАСТРОЙКИ И ПЕРЕТАСКИВАНИЕ
--// ==========================================
local HUDEnabled = false
local HUDObjects = {}
local HUDGui = nil
local ActiveFunctionsGui = nil
local FarmHUDGui = nil
local AllHUDElements = {}

local HUDSettings = {
    MainBlock = {X = 0.02, Y = 0.02},
    GameMode = {X = 0.02, Y = 0.15},
    Spectators = {X = 0.02, Y = 0.22},
    ActiveFunctions = {X = 0.02, Y = 0.30},
    FarmHUD = {X = 0.75, Y = 0.02},
}

local function MakeDraggable(frame, settingsKey)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if settingsKey then
                HUDSettings[settingsKey] = {
                    X = frame.Position.X.Scale,
                    Y = frame.Position.Y.Scale
                }
            end
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newX = startPos.X.Scale + (delta.X / game:GetService("GuiService"):GetScreenSize().X)
            local newY = startPos.Y.Scale + (delta.Y / game:GetService("GuiService"):GetScreenSize().Y)
            frame.Position = UDim2.new(
                math.clamp(newX, 0, 0.9),
                0,
                math.clamp(newY, 0, 0.9),
                0
            )
        end
    end)
end

--// ==========================================
--// СОЗДАНИЕ ОСНОВНОГО HUD
--// ==========================================
local function CreateHUD()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QUWES_HUD"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = true
    screenGui.Visible = false
    
    -- БЛОК 1: Игрок + Дистанция + Оружие + HP
    local mainBlock = Instance.new("Frame")
    mainBlock.Name = "MainBlock"
    mainBlock.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainBlock.BackgroundTransparency = 0.2
    mainBlock.BorderColor3 = Color3.fromRGB(128, 0, 255)
    mainBlock.BorderSizePixel = 2
    mainBlock.Size = UDim2.new(0, 250, 0, 90)
    mainBlock.Position = UDim2.new(HUDSettings.MainBlock.X, 0, HUDSettings.MainBlock.Y, 0)
    mainBlock.Parent = screenGui
    mainBlock.Visible = false
    HUDObjects.MainBlock = mainBlock
    table.insert(AllHUDElements, mainBlock)
    
    local blockTitle = Instance.new("TextLabel")
    blockTitle.Name = "BlockTitle"
    blockTitle.Text = "🎯 ЦЕЛЬ"
    blockTitle.TextColor3 = Color3.fromRGB(128, 0, 255)
    blockTitle.TextScaled = false
    blockTitle.Font = Enum.Font.GothamBold
    blockTitle.TextSize = 12
    blockTitle.BackgroundTransparency = 1
    blockTitle.Size = UDim2.new(1, 0, 0, 20)
    blockTitle.Position = UDim2.new(0, 0, 0, 2)
    blockTitle.Parent = mainBlock
    
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    avatar.BorderColor3 = Color3.fromRGB(128, 0, 255)
    avatar.BorderSizePixel = 1
    avatar.Size = UDim2.new(0, 45, 0, 45)
    avatar.Position = UDim2.new(0, 5, 0, 22)
    avatar.Parent = mainBlock
    avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
    
    local playerName = Instance.new("TextLabel")
    playerName.Name = "PlayerName"
    playerName.Text = "Игрок: " .. player.Name
    playerName.TextColor3 = Color3.fromRGB(200, 200, 255)
    playerName.TextScaled = false
    playerName.Font = Enum.Font.GothamBold
    playerName.TextSize = 13
    playerName.BackgroundTransparency = 1
    playerName.Size = UDim2.new(1, -55, 0, 20)
    playerName.Position = UDim2.new(0, 55, 0, 22)
    playerName.TextXAlignment = Enum.TextXAlignment.Left
    playerName.Parent = mainBlock
    HUDObjects.PlayerName = playerName
    
    local distance = Instance.new("TextLabel")
    distance.Name = "Distance"
    distance.Text = "📏 0m"
    distance.TextColor3 = Color3.fromRGB(200, 200, 255)
    distance.TextScaled = false
    distance.Font = Enum.Font.Gotham
    distance.TextSize = 12
    distance.BackgroundTransparency = 1
    distance.Size = UDim2.new(1, -55, 0, 18)
    distance.Position = UDim2.new(0, 55, 0, 42)
    distance.TextXAlignment = Enum.TextXAlignment.Left
    distance.Parent = mainBlock
    HUDObjects.Distance = distance
    
    local health = Instance.new("TextLabel")
    health.Name = "Health"
    health.Text = "❤️ 0/100"
    health.TextColor3 = Color3.fromRGB(200, 200, 255)
    health.TextScaled = false
    health.Font = Enum.Font.Gotham
    health.TextSize = 12
    health.BackgroundTransparency = 1
    health.Size = UDim2.new(1, -55, 0, 18)
    health.Position = UDim2.new(0, 55, 0, 60)
    health.TextXAlignment = Enum.TextXAlignment.Left
    health.Parent = mainBlock
    HUDObjects.Health = health
    
    local weapon = Instance.new("TextLabel")
    weapon.Name = "Weapon"
    weapon.Text = "🔫 Нет"
    weapon.TextColor3 = Color3.fromRGB(200, 200, 255)
    weapon.TextScaled = false
    weapon.Font = Enum.Font.Gotham
    weapon.TextSize = 12
    weapon.BackgroundTransparency = 1
    weapon.Size = UDim2.new(1, -55, 0, 18)
    weapon.Position = UDim2.new(0, 55, 0, 78)
    weapon.TextXAlignment = Enum.TextXAlignment.Left
    weapon.Parent = mainBlock
    HUDObjects.Weapon = weapon
    
    local hpBarBg = Instance.new("Frame")
    hpBarBg.Name = "HPBarBg"
    hpBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    hpBarBg.BorderSizePixel = 0
    hpBarBg.Size = UDim2.new(0.6, 0, 0, 4)
    hpBarBg.Position = UDim2.new(0.35, 0, 0, 76)
    hpBarBg.Parent = mainBlock
    
    local hpBar = Instance.new("Frame")
    hpBar.Name = "HPBar"
    hpBar.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    hpBar.BorderSizePixel = 0
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.Position = UDim2.new(0, 0, 0, 0)
    hpBar.Parent = hpBarBg
    HUDObjects.HPBar = hpBar
    
    MakeDraggable(mainBlock, "MainBlock")
    
    -- БЛОК 2: Режим игры
    local gameModeBlock = Instance.new("Frame")
    gameModeBlock.Name = "GameModeBlock"
    gameModeBlock.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    gameModeBlock.BackgroundTransparency = 0.2
    gameModeBlock.BorderColor3 = Color3.fromRGB(128, 0, 255)
    gameModeBlock.BorderSizePixel = 2
    gameModeBlock.Size = UDim2.new(0, 200, 0, 35)
    gameModeBlock.Position = UDim2.new(HUDSettings.GameMode.X, 0, HUDSettings.GameMode.Y, 0)
    gameModeBlock.Parent = screenGui
    gameModeBlock.Visible = false
    HUDObjects.GameModeBlock = gameModeBlock
    table.insert(AllHUDElements, gameModeBlock)
    
    local gmLabel = Instance.new("TextLabel")
    gmLabel.Name = "GameMode"
    gmLabel.Text = "📌 Режим: Загрузка..."
    gmLabel.TextColor3 = Color3.fromRGB(128, 0, 255)
    gmLabel.TextScaled = false
    gmLabel.Font = Enum.Font.GothamBold
    gmLabel.TextSize = 14
    gmLabel.BackgroundTransparency = 1
    gmLabel.Size = UDim2.new(1, 0, 1, 0)
    gmLabel.Position = UDim2.new(0, 0, 0, 0)
    gmLabel.Parent = gameModeBlock
    HUDObjects.GameMode = gmLabel
    
    MakeDraggable(gameModeBlock, "GameMode")
    
    -- БЛОК 3: Наблюдатели
    local specBlock = Instance.new("Frame")
    specBlock.Name = "SpecBlock"
    specBlock.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    specBlock.BackgroundTransparency = 0.2
    specBlock.BorderColor3 = Color3.fromRGB(128, 0, 255)
    specBlock.BorderSizePixel = 2
    specBlock.Size = UDim2.new(0, 220, 0, 35)
    specBlock.Position = UDim2.new(HUDSettings.Spectators.X, 0, HUDSettings.Spectators.Y, 0)
    specBlock.Parent = screenGui
    specBlock.Visible = false
    HUDObjects.SpecBlock = specBlock
    table.insert(AllHUDElements, specBlock)
    
    local specLabel = Instance.new("TextLabel")
    specLabel.Name = "Spectators"
    specLabel.Text = "👀 Наблюдатели: Нет"
    specLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    specLabel.TextScaled = false
    specLabel.Font = Enum.Font.Gotham
    specLabel.TextSize = 13
    specLabel.BackgroundTransparency = 1
    specLabel.Size = UDim2.new(1, 0, 1, 0)
    specLabel.Position = UDim2.new(0, 0, 0, 0)
    specLabel.Parent = specBlock
    HUDObjects.Spectators = specLabel
    
    MakeDraggable(specBlock, "Spectators")
    
    return screenGui
end

HUDGui = CreateHUD()

--// ==========================================
--// ACTIVE FUNCTIONS HUD
--// ==========================================
local function CreateActiveFunctionsHUD()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QUWES_ActiveFunctions"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = true
    screenGui.Visible = false
    
    local frame = Instance.new("Frame")
    frame.Name = "ActiveFunctionsFrame"
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.15
    frame.BorderColor3 = Color3.fromRGB(128, 0, 255)
    frame.BorderSizePixel = 2
    frame.Size = UDim2.new(0, 200, 0, 130)
    frame.Position = UDim2.new(HUDSettings.ActiveFunctions.X, 0, HUDSettings.ActiveFunctions.Y, 0)
    frame.Parent = screenGui
    frame.Visible = false
    HUDObjects.ActiveFunctionsFrame = frame
    table.insert(AllHUDElements, frame)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "⚡ ACTIVE FUNCTIONS"
    title.TextColor3 = Color3.fromRGB(128, 0, 255)
    title.TextScaled = false
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 2)
    title.Parent = frame
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    line.BackgroundTransparency = 0.5
    line.Size = UDim2.new(0.9, 0, 0, 1)
    line.Position = UDim2.new(0.05, 0, 0, 27)
    line.Parent = frame
    
    local functions = {
        {Name = "Aimbot", Text = "🎯 Aimbot: OFF", Y = 35},
        {Name = "TriggerBot", Text = "🔫 TriggerBot: OFF", Y = 55},
        {Name = "ESP", Text = "👁 ESP: OFF", Y = 75},
        {Name = "Farm", Text = "🌾 Farm: OFF", Y = 95},
    }
    
    for _, data in ipairs(functions) do
        local label = Instance.new("TextLabel")
        label.Name = data.Name
        label.Text = data.Text
        label.TextColor3 = Color3.fromRGB(255, 50, 50)
        label.TextScaled = false
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -10, 0, 20)
        label.Position = UDim2.new(0, 10, 0, data.Y)
        label.Parent = frame
        HUDObjects[data.Name .. "Status"] = label
    end
    
    MakeDraggable(frame, "ActiveFunctions")
    return screenGui
end

ActiveFunctionsGui = CreateActiveFunctionsHUD()

--// ==========================================
--// SHARED LOGIC (TEAM CHECK)
--// ==========================================
local function getTFolder() return CharactersFolder:FindFirstChild("Terrorists") end
local function getCTFolder() return CharactersFolder:FindFirstChild("Counter-Terrorists") end

local function isAlive()
    local t, ct = getTFolder(), getCTFolder()
    return (t and t:FindFirstChild(player.Name)) or (ct and ct:FindFirstChild(player.Name))
end

local function getEnemyFolder()
    if not isAlive() then return nil end
    local t, ct = getTFolder(), getCTFolder()
    if t and t:FindFirstChild(player.Name) then return ct end
    if ct and ct:FindFirstChild(player.Name) then return t end
    return nil
end

local function GetCurrentWeapon()
    local character = player.Character
    if not character then return "Unknown" end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then return tool.Name end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then return child.Name end
    end
    return "Unknown"
end

--// ==========================================
--// TABS
--// ==========================================
local Tab_Combat  = Window:CreateTab("Combat", "crosshair")
local Tab_Skins   = Window:CreateTab("Skins", "swords")
local Tab_Visuals = Window:CreateTab("Visuals", "eye")

Tab_Skins:CreateLabel("QUWES Skin System by twistedk1d", "code", Color3.fromRGB(128, 0, 255), false)

--// ==========================================
--// AIMBOT LOGIC (РЕЗКИЙ + ПЛАВНЫЙ)
--// ==========================================
local AimbotEnabled = false
local ShowFOV = false
local FOV_Radius = 100
local Smoothing = 3
local AimMode = "Sharp"
local AimKey = Enum.UserInputType.MouseButton2
local isAiming = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
FOVCircle.Radius = FOV_Radius
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(128, 0, 255)
FOVCircle.Visible = false
FOVCircle.Thickness = 2

local function getClosestEnemyToMouse()
    local closestEnemy = nil
    local shortestDistance = FOV_Radius
    local enemyFolder = getEnemyFolder()
    
    if not enemyFolder or not AimbotEnabled then return nil end
    
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, enemy in ipairs(enemyFolder:GetChildren()) do
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local head = enemy:FindFirstChild("Head")
        
        if hum and hum.Health > 0 and head then
            local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local distance = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestEnemy = head
                end
            end
        end
    end
    return closestEnemy
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AimKey then isAiming = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AimKey then isAiming = false end
end)

RunService.RenderStepped:Connect(function()
    if ShowFOV then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = FOV_Radius
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    if not isAiming or not isAlive() or not AimbotEnabled then return end
    
    local targetHead = getClosestEnemyToMouse()
    if targetHead then
        local headPos = camera:WorldToViewportPoint(targetHead.Position)
        local mousePos = UserInputService:GetMouseLocation()
        
        if AimMode == "Sharp" then
            local moveX = headPos.X - mousePos.X
            local moveY = headPos.Y - mousePos.Y
            if mousemoverel then mousemoverel(moveX, moveY) end
        else
            local moveX = (headPos.X - mousePos.X) / Smoothing
            local moveY = (headPos.Y - mousePos.Y) / Smoothing
            if mousemoverel then mousemoverel(moveX, moveY) end
        end
    end
end)

Tab_Combat:CreateSection("Aimbot Settings")
Tab_Combat:CreateToggle({
    Name = "Enable Aimbot (Hold Right Click)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value) AimbotEnabled = Value end
})

Tab_Combat:CreateDropdown({
    Name = "Aim Mode",
    Options = {"Sharp (Мгновенный)", "Smooth (Плавный)"},
    CurrentOption = {"Sharp (Мгновенный)"},
    Flag = "AimModeDropdown",
    Callback = function(Options)
        AimMode = Options[1] == "Sharp (Мгновенный)" and "Sharp" or "Smooth"
    end
})

Tab_Combat:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(Value) ShowFOV = Value end
})

Tab_Combat:CreateSlider({
    Name = "FOV Radius",
    Range = {10, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 100,
    Flag = "FOVSlider",
    Callback = function(Value) FOV_Radius = Value end
})

Tab_Combat:CreateSlider({
    Name = "Aimbot Smoothing",
    Range = {1, 10},
    Increment = 1,
    Suffix = " (Lower is faster)",
    CurrentValue = 3,
    Flag = "AimbotSmoothing",
    Callback = function(Value) Smoothing = Value end
})

--// ==========================================
--// TRIGGERBOT LOGIC (С ПРЕСЕТАМИ)
--// ==========================================
local TriggerBotEnabled = false
local TriggerBotDelay = 50
local TriggerBotMode = "Auto"
local TriggerBotKey = Enum.UserInputType.MouseButton1
local lastShotTime = 0
local triggerBotActive = false
local AutoDetectWeapon = true
local CurrentWeaponDetected = "Unknown"
local SelectedPreset = "Auto (Автоматический)"

local WeaponPresets = {
    ["Auto (Автоматический)"] = {Mode = "Auto", Delay = 50, Description = "Для автоматов (AK-47, M4A1-S, AUG)"},
    ["Sniper (AWP/SSG)"] = {Mode = "Single", Delay = 0, Description = "Для снайперских винтовок (1 выстрел)"},
    ["Deagle (Desert Eagle)"] = {Mode = "Single", Delay = 200, Description = "Для мощных пистолетов"},
    ["Pistol (Glock/USP)"] = {Mode = "Auto", Delay = 120, Description = "Для стандартных пистолетов"},
    ["Shotgun (Nova/XM1014)"] = {Mode = "Single", Delay = 500, Description = "Для дробовиков"},
    ["SMG (P90/MP9)"] = {Mode = "Auto", Delay = 30, Description = "Для пистолет-пулемётов"},
    ["Heavy (Negev)"] = {Mode = "Auto", Delay = 10, Description = "Для пулемётов"},
    ["Custom"] = {Mode = "Auto", Delay = 50, Description = "Ручная настройка"}
}

local WeaponToPreset = {
    ["AK-47"] = "Auto (Автоматический)", ["M4A1-S"] = "Auto (Автоматический)",
    ["M4A4"] = "Auto (Автоматический)", ["AUG"] = "Auto (Автоматический)",
    ["FAMAS"] = "Auto (Автоматический)", ["SG 553"] = "Auto (Автоматический)",
    ["Galil AR"] = "Auto (Автоматический)",
    ["AWP"] = "Sniper (AWP/SSG)", ["SSG 08"] = "Sniper (AWP/SSG)",
    ["SCAR-20"] = "Sniper (AWP/SSG)", ["G3SG1"] = "Sniper (AWP/SSG)",
    ["Desert Eagle"] = "Deagle (Desert Eagle)", ["R8 Revolver"] = "Deagle (Desert Eagle)",
    ["Glock-18"] = "Pistol (Glock/USP)", ["USP-S"] = "Pistol (Glock/USP)",
    ["P250"] = "Pistol (Glock/USP)", ["Five-SeveN"] = "Pistol (Glock/USP)",
    ["CZ75-Auto"] = "Pistol (Glock/USP)", ["Dual Berettas"] = "Pistol (Glock/USP)",
    ["Tec-9"] = "Pistol (Glock/USP)",
    ["Nova"] = "Shotgun (Nova/XM1014)", ["XM1014"] = "Shotgun (Nova/XM1014)",
    ["MAG-7"] = "Shotgun (Nova/XM1014)", ["Sawed-Off"] = "Shotgun (Nova/XM1014)",
    ["P90"] = "SMG (P90/MP9)", ["MP9"] = "SMG (P90/MP9)",
    ["MP7"] = "SMG (P90/MP9)", ["MP5-SD"] = "SMG (P90/MP9)",
    ["UMP-45"] = "SMG (P90/MP9)", ["PP-Bizon"] = "SMG (P90/MP9)",
    ["MAC-10"] = "SMG (P90/MP9)",
    ["Negev"] = "Heavy (Negev)", ["M249"] = "Heavy (Negev)"
}

local function ApplyPreset(presetName)
    local preset = WeaponPresets[presetName]
    if not preset then return end
    SelectedPreset = presetName
    TriggerBotMode = preset.Mode
    TriggerBotDelay = preset.Delay
end

local function ApplyPresetByWeapon(weaponName)
    if not AutoDetectWeapon or weaponName == "Unknown" then return end
    local presetName = WeaponToPreset[weaponName] or "Auto (Автоматический)"
    CurrentWeaponDetected = weaponName
    ApplyPreset(presetName)
end

task.spawn(function()
    while task.wait(0.5) do
        if not TriggerBotEnabled or not AutoDetectWeapon then continue end
        local weapon = GetCurrentWeapon()
        if weapon ~= CurrentWeaponDetected and weapon ~= "Unknown" then
            ApplyPresetByWeapon(weapon)
        end
    end
end)

local function IsEnemyValid(model)
    if not model then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function GetEnemyInCrosshair()
    if not isAlive() then return nil end
    local viewportSize = camera.ViewportSize
    local ray = camera:ViewportPointToRay(viewportSize.X / 2, viewportSize.Y / 2)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = {camera}
    if player.Character then table.insert(ignoreList, player.Character) end
    raycastParams.FilterDescendantsInstances = ignoreList
    
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 5000, raycastParams)
    if result and result.Instance then
        local model = result.Instance:FindFirstAncestorOfClass("Model")
        if model then
            local enemyFolder = getEnemyFolder()
            if enemyFolder and model.Parent == enemyFolder and IsEnemyValid(model) then
                return model            end
        end
    end
    return nil
end

local function Shoot()
    if not TriggerBotEnabled or not isAlive() then return end
    local enemy = GetEnemyInCrosshair()
    if not enemy then triggerBotActive = false; return end
    
    local currentTime = os.clock() * 1000
    if currentTime - lastShotTime < TriggerBotDelay then return end
    
    if TriggerBotMode == "Single" then
        if triggerBotActive then return end
        triggerBotActive = true
        if mouse1click then mouse1click() end
        lastShotTime = currentTime
        task.spawn(function() task.wait(0.3); triggerBotActive = false end)
    else
        if mouse1click then mouse1click() end
        lastShotTime = currentTime
    end
end

task.spawn(function()
    while task.wait(0.01) do
        if not TriggerBotEnabled or not isAlive() then triggerBotActive = false; continue end
        if TriggerBotMode == "Auto" and GetEnemyInCrosshair() then Shoot() end
    end
end)

Tab_Combat:CreateSection("TriggerBot Settings")
Tab_Combat:CreateToggle({
    Name = "Enable TriggerBot",
    CurrentValue = false,
    Flag = "TriggerBotToggle",
    Callback = function(Value)
        TriggerBotEnabled = Value
        if Value and AutoDetectWeapon then
            ApplyPresetByWeapon(GetCurrentWeapon())
        end
    end
})

Tab_Combat:CreateToggle({
    Name = "🔍 Auto Detect Weapon",
    CurrentValue = true,
    Flag = "AutoDetectToggle",
    Callback = function(Value)
        AutoDetectWeapon = Value
        if Value and TriggerBotEnabled then
            ApplyPresetByWeapon(GetCurrentWeapon())
        end
    end
})

local WeaponInfoLabel = Tab_Combat:CreateLabel("🔍 Автоопределение: ВКЛЮЧЕНО", "info", Color3.fromRGB(0, 255, 0), false)

local presetDropdown = Tab_Combat:CreateDropdown({
    Name = "🎯 Manual Preset",
    Options = {"Auto (Автоматический)", "Sniper (AWP/SSG)", "Deagle (Desert Eagle)",
               "Pistol (Glock/USP)", "Shotgun (Nova/XM1014)", "SMG (P90/MP9)",
               "Heavy (Negev)", "Custom"},
    CurrentOption = {"Auto (Автоматический)"},
    Flag = "WeaponPreset",
    Callback = function(Options)
        if AutoDetectWeapon then return end
        local presetName = Options[1]
        if presetName ~= "Custom" then ApplyPreset(presetName) end
    end
})

local PresetInfoLabel = Tab_Combat:CreateLabel("📋 Для автоматов", "info", Color3.fromRGB(128, 0, 255), false)

local modeDropdown = Tab_Combat:CreateDropdown({
    Name = "Shot Mode",
    Options = {"Auto (Автоматический)", "Single (Одиночный)"},
    CurrentOption = {"Auto (Автоматический)"},
    Flag = "TriggerMode",
    Callback = function(Options)
        if AutoDetectWeapon then return end
        TriggerBotMode = Options[1] == "Auto (Автоматический)" and "Auto" or "Single"
    end
})

local delaySlider = Tab_Combat:CreateSlider({
    Name = "Shot Delay",
    Range = {0, 500},
    Increment = 10,
    Suffix = "ms",
    CurrentValue = 50,
    Flag = "TriggerBotDelay",
    Callback = function(Value)
        if AutoDetectWeapon then return end
        TriggerBotDelay = Value
    end
})

Tab_Combat:CreateLabel("💡 Auto - стреляет пока враг в прицеле", "info", Color3.fromRGB(200, 200, 255), false)
Tab_Combat:CreateLabel("💡 Single - стреляет 1 раз при наведении", "info", Color3.fromRGB(200, 200, 255), false)

--// ==========================================
--// HITBOX LOGIC
--// ==========================================
local HitboxEnabled = false
local HitboxSize = 3
local originalHeadSizes = {}

Tab_Combat:CreateSection("Simple Hitbox")
Tab_Combat:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(Value) HitboxEnabled = Value end
})

Tab_Combat:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 3},
    Increment = 0.1,
    Suffix = " Studs",
    CurrentValue = 3,
    Flag = "HitboxSize",
    Callback = function(Value) HitboxSize = Value end
})

task.spawn(function()
    while task.wait(0.5) do
        local enemyFolder = getEnemyFolder()
        if enemyFolder then
            for _, enemy in ipairs(enemyFolder:GetChildren()) do
                local head = enemy:FindFirstChild("Head")
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    if not originalHeadSizes[head] then originalHeadSizes[head] = head.Size end
                    if HitboxEnabled then
                        head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        head.CanCollide = false
                        head.Transparency = 0.5
                        head.Color = Color3.fromRGB(128, 0, 255)
                    else
                        if originalHeadSizes[head] then
                            head.Size = originalHeadSizes[head]
                            head.Transparency = 0
                        end
                    end
                end
            end
        end
    end
end)

--// ==========================================
--// BHOP LOGIC
--// ==========================================
local BhopEnabled = false

Tab_Combat:CreateSection("Movement Settings")
Tab_Combat:CreateToggle({
    Name = "Enable Bunny Hop (Hold Space)",
    CurrentValue = false,
    Flag = "BhopToggle",
    Callback = function(Value) BhopEnabled = Value end
})

RunService.RenderStepped:Connect(function()
    if BhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) and isAlive() then
        local character = player.Character
        if character then
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                hum.Jump = true
            end
        end
    end
end)

--// ==========================================
--// FARM MODE
--// ==========================================
local FarmModeEnabled = false
local FarmModeActive = false
local FarmTarget = nil
local FarmState = "Idle"
local FarmWinChance = 0
local FarmHealthThreshold = 30
local FarmAttackRange = 30
local FarmBombPlanted = false
local FarmHUDEnabled = false
local FarmHUDObjects = {}

local FarmWeaponPriority = {
    "AWP", "AK-47", "M4A1-S", "Desert Eagle", "SSG 08",
    "P90", "MP9", "FAMAS", "AUG", "Galil AR", "SG 553",
    "M4A4", "USP-S", "Glock-18", "P250", "Five-SeveN", "Nova", "XM1014"
}

local function GetAllEnemies()
    local enemies = {}
    local enemyFolder = getEnemyFolder()
    if not enemyFolder then return enemies end
    for _, enemy in ipairs(enemyFolder:GetChildren()) do
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and root then
            table.insert(enemies, {Model = enemy, Humanoid = hum, Root = root, Health = hum.Health, Position = root.Position})
        end
    end
    return enemies
end

local function GetNearestEnemy()
    local character = player.Character
    if not character then return nil, math.huge end
    local myPos = character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil, math.huge end
    local enemies = GetAllEnemies()
    local nearest, nearestDist = nil, math.huge
    for _, enemy in ipairs(enemies) do
        local dist = (myPos.Position - enemy.Position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearest = enemy
        end
    end
    return nearest, nearestDist
end

local function FindWeaponOnGround()
    local character = player.Character
    if not character then return nil end
    local myPos = character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return nil end
    local currentWeapon = GetCurrentWeapon()
    local bestWeapon, bestScore = nil, -1
    
    for _, weapon in ipairs(debris:GetChildren()) do
        if weapon:IsA("Model") and weapon:FindFirstChild("Handle") then
            local weaponName = weapon.Name
            local dist = (myPos.Position - weapon.Handle.Position).Magnitude
            local score = 0
            for i, name in ipairs(FarmWeaponPriority) do
                if weaponName == name then
                    score = #FarmWeaponPriority - i + 1
                    break
                end
            end
            if score > 0 and dist < 50 then
                local currentScore = 0
                for i, name in ipairs(FarmWeaponPriority) do
                    if currentWeapon == name then
                        currentScore = #FarmWeaponPriority - i + 1
                        break
                    end
                end
                if score > currentScore and score > bestScore then
                    bestScore = score
                    bestWeapon = weapon
                end
            end
        end
    end
    return bestWeapon
end

local function PickupWeapon(weapon)
    if not weapon then return false end
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local weaponHandle = weapon:FindFirstChild("Handle")
    if not weaponHandle then return false end
    
    local distance = (root.Position - weaponHandle.Position).Magnitude
    if distance > 5 then
        humanoid:MoveTo(weaponHandle.Position)
        task.wait(0.5)
    end
    if distance < 10 then
        if fireclickdetector then
            local clickDetector = weapon:FindFirstChildOfClass("ClickDetector")
            if clickDetector then fireclickdetector(clickDetector); return true end
        end
        weapon.Parent = character
        return true
    end
    return false
end

local function FindAndPlantBomb()
    local character = player.Character
    if not character then return false end
    local hasBomb = false
    for _, item in ipairs(character:GetChildren()) do
        if item.Name == "C4" or item.Name == "Bomb" then hasBomb = true; break end
    end
    if not hasBomb then
        local debris = workspace:FindFirstChild("Debris")
        if debris then
            for _, item in ipairs(debris:GetChildren()) do
                if item.Name == "C4" or item.Name == "Bomb" then
                    PickupWeapon(item)
                    return false
                end
            end
        end
        return false
    end
    local bombSites = workspace:FindFirstChild("BombSites")
    if not bombSites then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local nearestSite, nearestDist = nil, math.huge
    for _, site in ipairs(bombSites:GetChildren()) do
        local dist = (root.Position - site.Position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearestSite = site
        end
    end
    if nearestSite then
        humanoid:MoveTo(nearestSite.Position)
        task.wait(1)
        if nearestDist < 10 then
            if keypress then
                keypress(Enum.KeyCode.G)
                task.wait(0.1)
                keyrelease(Enum.KeyCode.G)
                return true
            end
        end
    end
    return false
end

local function ShouldRetreat()
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health < FarmHealthThreshold
end

local function CalculateWinChance()
    local character = player.Character
    if not character then return 0 end
    local myHealth = character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").Health or 0
    local enemies = GetAllEnemies()
    if #enemies == 0 then return 100 end
    local totalEnemyHealth = 0
    for _, enemy in ipairs(enemies) do totalEnemyHealth = totalEnemyHealth + enemy.Health end
    local avgEnemyHealth = totalEnemyHealth / #enemies
    local healthFactor = myHealth / 100
    local enemyFactor = 1 - (avgEnemyHealth / 100)
    local countFactor = 1 / (#enemies + 1)
    local chance = (healthFactor * 0.4 + enemyFactor * 0.3 + countFactor * 0.3) * 100
    local weapon = GetCurrentWeapon()
    local weaponBonus = 0
    for i, name in ipairs(FarmWeaponPriority) do
        if weapon == name then
            weaponBonus = (#FarmWeaponPriority - i) / #FarmWeaponPriority * 20
            break
        end
    end
    return math.min(math.floor(chance + weaponBonus), 100)
end

--// FARM HUD
local function CreateFarmHUD()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QUWES_FarmHUD"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = true
    screenGui.Visible = false
    
    local frame = Instance.new("Frame")
    frame.Name = "FarmHUDFrame"
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.15
    frame.BorderColor3 = Color3.fromRGB(128, 0, 255)
    frame.BorderSizePixel = 2
    frame.Size = UDim2.new(0, 220, 0, 150)
    frame.Position = UDim2.new(HUDSettings.FarmHUD.X, 0, HUDSettings.FarmHUD.Y, 0)
    frame.Parent = screenGui
    frame.Visible = false
    HUDObjects.FarmHUDFrame = frame
    table.insert(AllHUDElements, frame)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "🌾 FARM MODE"
    title.TextColor3 = Color3.fromRGB(128, 0, 255)
    title.TextScaled = false
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 2)
    title.Parent = frame
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    line.BackgroundTransparency = 0.5
    line.Size = UDim2.new(0.9, 0, 0, 1)
    line.Position = UDim2.new(0.05, 0, 0, 32)
    line.Parent = frame
    
    local farmData = {
        {Name = "Status", Text = "Статус: Idle", Y = 40},
        {Name = "WinChance", Text = "🏆 Шанс победы: 0%", Y = 65},
        {Name = "Enemies", Text = "👥 Врагов: 0", Y = 90},
        {Name = "Weapon", Text = "🔫 Оружие: Нет", Y = 115},
    }
    
    for _, data in ipairs(farmData) do
        local label = Instance.new("TextLabel")
        label.Name = data.Name
        label.Text = data.Text
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.TextScaled = false
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -10, 0, 25)
        label.Position = UDim2.new(0, 10, 0, data.Y)
        label.Parent = frame
        FarmHUDObjects[data.Name] = label
    end
    
    local chanceBarBg = Instance.new("Frame")
    chanceBarBg.Name = "ChanceBarBg"
    chanceBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    chanceBarBg.BorderSizePixel = 0
    chanceBarBg.Size = UDim2.new(0.8, 0, 0, 6)
    chanceBarBg.Position = UDim2.new(0.1, 0, 0, 90)
    chanceBarBg.Parent = frame
    
    local chanceBar = Instance.new("Frame")
    chanceBar.Name = "ChanceBar"
    chanceBar.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    chanceBar.BorderSizePixel = 0
    chanceBar.Size = UDim2.new(0, 0, 1, 0)
    chanceBar.Position = UDim2.new(0, 0, 0, 0)
    chanceBar.Parent = chanceBarBg
    FarmHUDObjects.ChanceBar = chanceBar
    
    MakeDraggable(frame, "FarmHUD")
    return screenGui
end

FarmHUDGui = CreateFarmHUD()

--// Основной цикл Farm Mode
task.spawn(function()
    while task.wait(0.1) do
        if not FarmModeEnabled or not isAlive() then FarmModeActive = false; continue end
        FarmModeActive = true
        local character = player.Character
        if not character then continue end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then continue end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        FarmWinChance = CalculateWinChance()
        
        if ShouldRetreat() then
            FarmState = "Retreat"
            local spawnLocation = workspace:FindFirstChild("SpawnLocation")
            if spawnLocation then humanoid:MoveTo(spawnLocation.Position) end
            task.wait(2)
            FarmState = "Idle"
            continue
        end
        
        local myTeam = nil
        if getTFolder() and getTFolder():FindFirstChild(player.Name) then myTeam = "T" end
        if getCTFolder() and getCTFolder():FindFirstChild(player.Name) then myTeam = "CT" end
        
        if myTeam == "T" and not FarmBombPlanted then
            local hasBomb = false
            for _, item in ipairs(character:GetChildren()) do
                if item.Name == "C4" or item.Name == "Bomb" then hasBomb = true; break end
            end
            if hasBomb then
                FarmState = "PlantBomb"
                if FindAndPlantBomb() then FarmBombPlanted = true end
                continue
            end
        end
        
        local currentWeapon = GetCurrentWeapon()
        local currentScore = 0
        for i, name in ipairs(FarmWeaponPriority) do
            if currentWeapon == name then currentScore = #FarmWeaponPriority - i + 1; break end
        end
        
        if currentScore < 3 and FarmState ~= "SearchWeapon" then
            FarmState = "SearchWeapon"
            local weapon = FindWeaponOnGround()
            if weapon then PickupWeapon(weapon) end
            task.wait(0.5)
            FarmState = "Idle"
            continue
        end
        
        local nearest, dist = GetNearestEnemy()
        if nearest and dist < FarmAttackRange then
            FarmState = "Attack"
            FarmTarget = nearest
            local head = nearest.Model:FindFirstChild("Head")
            if head then
                local headPos = camera:WorldToViewportPoint(head.Position)
                if headPos then
                    local mousePos = UserInputService:GetMouseLocation()
                    if mousemoverel then
                        mousemoverel(headPos.X - mousePos.X, headPos.Y - mousePos.Y)
                    end
                end
            end
            if mouse1click then mouse1click() end
            if nearest.Health <= 0 then FarmTarget = nil; FarmState = "Idle" end
        elseif nearest then
            FarmState = "MoveToEnemy"
            humanoid:MoveTo(nearest.Position)
        else
            FarmState = "Idle"
            humanoid:MoveTo(Vector3.new(0, 0, 0))
        end
    end
end)

--// Обновление Farm HUD
local function UpdateFarmHUD()
    if not FarmHUDEnabled then return end
    local enemies = GetAllEnemies()
    local weapon = GetCurrentWeapon()
    
    if FarmHUDObjects.Status then
        FarmHUDObjects.Status.Text = "Статус: " .. FarmState
        FarmHUDObjects.Status.TextColor3 = FarmModeActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    end
    
    if FarmHUDObjects.WinChance then
        FarmHUDObjects.WinChance.Text = "🏆 Шанс победы: " .. FarmWinChance .. "%"
        if FarmWinChance > 70 then
            FarmHUDObjects.WinChance.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif FarmWinChance > 40 then
            FarmHUDObjects.WinChance.TextColor3 = Color3.fromRGB(255, 200, 50)
        else
            FarmHUDObjects.WinChance.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
    
    if FarmHUDObjects.Enemies then
        FarmHUDObjects.Enemies.Text = "👥 Врагов: " .. #enemies
    end
    
    if FarmHUDObjects.Weapon then
        FarmHUDObjects.Weapon.Text = "🔫 Оружие: " .. (weapon ~= "Unknown" and weapon or "Нет")
    end
    
    if FarmHUDObjects.ChanceBar then
        local percent = FarmWinChance / 100
        FarmHUDObjects.ChanceBar.Size = UDim2.new(percent, 0, 1, 0)
        if FarmWinChance > 70 then
            FarmHUDObjects.ChanceBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif FarmWinChance > 40 then
            FarmHUDObjects.ChanceBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        else
            FarmHUDObjects.ChanceBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end

task.spawn(function()
    while task.wait(0.2) do UpdateFarmHUD() end
end)

--// Добавляем Farm Mode в Combat Tab
Tab_Combat:CreateSection("🌾 Farm Mode Settings")
Tab_Combat:CreateToggle({
    Name = "Enable Farm Mode (Auto Play)",
    CurrentValue = false,
    Flag = "FarmModeToggle",
    Callback = function(Value)
        FarmModeEnabled = Value
        if not Value then FarmModeActive = false; FarmState = "Idle" end
        if FarmHUDGui then
            FarmHUDGui.Visible = Value
            FarmHUDEnabled = Value
            if Value then
                AnimateHUDIn({FarmHUDGui.FarmHUDFrame})
            else
                AnimateHUDOut({FarmHUDGui.FarmHUDFrame})
            end
        end
    end
})

Tab_Combat:CreateSlider({
    Name = "Health Retreat Threshold",
    Range = {10, 80},
    Increment = 5,
    Suffix = "% HP",
    CurrentValue = 30,
    Flag = "FarmHealthThreshold",
    Callback = function(Value) FarmHealthThreshold = Value end
})

Tab_Combat:CreateSlider({
    Name = "Attack Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = " Studs",
    CurrentValue = 30,
    Flag = "FarmAttackRange",
    Callback = function(Value) FarmAttackRange = Value end
})

Tab_Combat:CreateLabel("💡 Farm Mode автоматически:", "info", Color3.fromRGB(128, 0, 255), false)
Tab_Combat:CreateLabel("• Ищет лучшее оружие", "info", Color3.fromRGB(200, 200, 255), false)
Tab_Combat:CreateLabel("• Идёт к врагам и убивает их", "info", Color3.fromRGB(200, 200, 255), false)
Tab_Combat:CreateLabel("• Следит за своим HP", "info", Color3.fromRGB(200, 200, 255), false)
Tab_Combat:CreateLabel("• Ставит бомбу (если Террорист)", "info", Color3.fromRGB(200, 200, 255), false)

--// ==========================================
--// SKINS TAB (Упрощённый)
--// ==========================================
local scriptRunning = false
local selectedKnife = "Butterfly Knife"
local spawned = false
local inspecting = false
local swinging = false
local lastAttackTime = 0
local ACTION_INSPECT = "QUWES_InspectKnife"
local ACTION_ATTACK = "QUWES_AttackKnife"

local knives = {
    ["Karambit"] = {Offset = CFrame.new(0, -1.5, 1.5)},
    ["Butterfly Knife"] = {Offset = CFrame.new(0, -1.5, 1.5)},
    ["M9 Bayonet"] = {Offset = CFrame.new(0, -1.5, 1)},
    ["Flip Knife"] = {Offset = CFrame.new(0, -1.5, 1.25)},
    ["Gut Knife"] = {Offset = CFrame.new(0, -1.5, 0.5)},
}

local vm, animator
local equipAnim, idleAnim, inspectAnim, HeavySwingAnim, Swing1Anim, Swing2Anim

local function getKnifeInCamera() return camera:FindFirstChild("T Knife") or camera:FindFirstChild("CT Knife") end

local function cleanPart(part)
    if not part:IsA("BasePart") then return end
    part.CanCollide, part.Anchored, part.CastShadow, part.CanTouch, part.CanQuery = false, false, false, false, false
end

local function disableCollisions(model)
    for _, part in model:GetDescendants() do cleanPart(part) end
end

local function hideOriginalKnife(knife)
    for _, part in knife:GetDescendants() do
        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Texture") then part.Transparency = 1 end
    end
end

local function playSound(folder, name)
    local weaponSounds = RS.Sounds:FindFirstChild(selectedKnife)
    if not weaponSounds then return end
    local sound = weaponSounds:WaitForChild(folder):WaitForChild(name):Clone()
    sound.Parent = camera
    sound:Play()
    sound.Ended:Once(function() sound:Destroy() end)
    return sound
end

local function attachAsset(folder, armPartName, assetModelName, finalName, offset)
    local targetArm = vm:FindFirstChild(armPartName)
    if not targetArm then return end
    local assetMesh = folder:WaitForChild(assetModelName):Clone()
    cleanPart(assetMesh)
    assetMesh.Name = finalName
    assetMesh.Parent = targetArm
    local motor = Instance.new("Motor6D")
    motor.Part0, motor.Part1, motor.C0, motor.Parent = targetArm, assetMesh, offset, targetArm
end

local function handleAction(actionName, inputState)
    if inputState ~= Enum.UserInputState.Begin or not spawned or not animator or not isAlive() then return end
    if actionName == ACTION_INSPECT then
        if (equipAnim and equipAnim.IsPlaying) or inspecting or swinging then return end
        inspecting = true
        if idleAnim then idleAnim:Stop() end
        inspectAnim:Play()
        inspectAnim.Stopped:Once(function() inspecting = false end)
    elseif actionName == ACTION_ATTACK then
        local currentTime = os.clock()
        if (equipAnim and equipAnim.IsPlaying) or (currentTime - lastAttackTime < 1) then return end
        lastAttackTime = currentTime
        if inspecting then inspecting = false; if inspectAnim then inspectAnim:Stop() end end
        swinging = true
        if idleAnim then idleAnim:Stop() end
        local anims = {HeavySwingAnim, Swing1Anim, Swing2Anim}
        local chosenAnim = anims[math.random(1, #anims)]
        chosenAnim:Play()
        chosenAnim.Stopped:Once(function() swinging = false end)
    end
end

local function removeViewmodel()
    spawned = false
    CAS:UnbindAction(ACTION_INSPECT)
    CAS:UnbindAction(ACTION_ATTACK)
    if vm then vm:Destroy(); vm = nil end
    animator, inspecting, swinging = nil, false, false
end

local function spawnViewmodel(knife)
    if spawned or not scriptRunning then return end
    local myModel = isAlive()
    if not myModel then return end
    spawned = true
    
    local knifeTemplate = RS.Assets.Weapons:WaitForChild(selectedKnife)
    local knifeOffset = knives[selectedKnife].Offset
    vm = knifeTemplate:WaitForChild("Camera"):Clone()
    vm.Name, vm.Parent = selectedKnife, camera
    disableCollisions(vm)
    hideOriginalKnife(knife)
    
    if myModel.Parent.Name == "Terrorists" then
        local tGloves = RS.Assets.Weapons:WaitForChild("T Glove")
        attachAsset(tGloves, "Left Arm", "Left Arm", "Glove", CFrame.new(0, 0, -1.5))
        attachAsset(tGloves, "Right Arm", "Right Arm", "Glove", CFrame.new(0, 0, -1.5))
    else
        local sleeves = RS.Assets.Sleeves:WaitForChild("IDF")
        local ctGloves = RS.Assets.Weapons:WaitForChild("CT Glove")
        attachAsset(sleeves, "Left Arm", "Left Arm", "Sleeve", CFrame.new(0, 0, 0.5))
        attachAsset(ctGloves, "Left Arm", "Left Arm", "Glove", CFrame.new(0, 0, -1.5))
        attachAsset(sleeves, "Right Arm", "Right Arm", "Sleeve", CFrame.new(0, 0, 0.5))
        attachAsset(ctGloves, "Right Arm", "Right Arm", "Glove", CFrame.new(0, 0, -1.5))
    end
    
    local animController = vm:FindFirstChildOfClass("AnimationController") or vm:FindFirstChildOfClass("Animator")
    animator = animController:FindFirstChildWhichIsA("Animator") or animController
    local animFolder = RS.Assets.WeaponAnimations:WaitForChild(selectedKnife):WaitForChild("CameraAnimations")
    
    equipAnim = animator:LoadAnimation(animFolder:WaitForChild("Equip"))
    idleAnim = animator:LoadAnimation(animFolder:WaitForChild("Idle"))
    inspectAnim = animator:LoadAnimation(animFolder:WaitForChild("Inspect"))
    HeavySwingAnim = animator:LoadAnimation(animFolder:WaitForChild("Heavy Swing"))
    Swing1Anim = animator:LoadAnimation(animFolder:WaitForChild("Swing1"))
    Swing2Anim = animator:LoadAnimation(animFolder:WaitForChild("Swing2"))
    
    vm:SetPrimaryPartCFrame(camera.CFrame * CFrame.new(0, -1.5, 5))
    TweenService:Create(vm.PrimaryPart, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = camera.CFrame * knifeOffset
    }):Play()
    
    equipAnim:Play()
    playSound("Equip", "1")
    CAS:BindAction(ACTION_INSPECT, handleAction, false, Enum.KeyCode.F)
    CAS:BindAction(ACTION_ATTACK, handleAction, false, Enum.UserInputType.MouseButton1)
end

RunService.RenderStepped:Connect(function()
    if not scriptRunning or not vm or not vm.PrimaryPart then return end
    vm.PrimaryPart.CFrame = camera.CFrame * knives[selectedKnife].Offset
    if not (equipAnim and equipAnim.IsPlaying) and not inspecting and not swinging then
        if idleAnim and not idleAnim.IsPlaying then idleAnim:Play() end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        local living = isAlive()
        local currentKnife = getKnifeInCamera()
        if scriptRunning and living and currentKnife and not spawned then
            spawnViewmodel(currentKnife)
        elseif (not scriptRunning or not currentKnife or not living) and spawned then
            removeViewmodel()
        end
    end
end)

Tab_Skins:CreateToggle({
    Name = "Enable Custom Knife",
    CurrentValue = false,
    Flag = "KnifeToggle",
    Callback = function(Value)
        scriptRunning = Value
        if not Value then removeViewmodel() end
    end
})

Tab_Skins:CreateDropdown({
    Name = "Selected Custom Knife",
    Options = {"Butterfly Knife", "Karambit", "M9 Bayonet", "Flip Knife", "Gut Knife"},
    CurrentOption = {"Butterfly Knife"},
    Flag = "KnifeDropdown",
    Callback = function(Options)
        selectedKnife = Options[1]
        if spawned then removeViewmodel() end
    end
})

--// ==========================================
--// VISUALS TAB (ESP)
--// ==========================================
local EspEnabled, EspBox, EspName, EspHealth, EspDistance = false, true, true, true, true
local espCache = {}

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

Tab_Visuals:CreateSection("ESP Master Switch")
Tab_Visuals:CreateToggle({Name = "Enable Player ESP", CurrentValue = false, Flag = "ESPToggle", Callback = function(Value) EspEnabled = Value end})

Tab_Visuals:CreateSection("ESP Settings")
Tab_Visuals:CreateToggle({Name = "Show Box", CurrentValue = true, Flag = "EspBoxToggle", Callback = function(Value) EspBox = Value end})
Tab_Visuals:CreateToggle({Name = "Show Health", CurrentValue = true, Flag = "EspHealthToggle", Callback = function(Value) EspHealth = Value end})
Tab_Visuals:CreateToggle({Name = "Show Name", CurrentValue = true, Flag = "EspNameToggle", Callback = function(Value) EspName = Value end})
Tab_Visuals:CreateToggle({Name = "Show Distance", CurrentValue = true, Flag = "EspDistanceToggle", Callback = function(Value) EspDistance = Value end})

--// ==========================================
--// HUD НАСТРОЙКИ В VISUALS (С АНИМАЦИЯМИ)
--// ==========================================
Tab_Visuals:CreateSection("📊 HUD Settings")

-- Функция для показа HUD с анимацией
local function ShowHUD()
    if not HUDEnabled then return end
    
    for _, element in ipairs(AllHUDElements) do
        element.Visible = true
    end
    
    AnimateHUDIn(AllHUDElements)
    
    if ActiveFunctionsGui then
        ActiveFunctionsGui.Visible = true
        AnimateHUDIn({ActiveFunctionsGui.ActiveFunctionsFrame})
    end
end

-- Функция для скрытия HUD с анимацией
local function HideHUD()
    if not HUDEnabled then return end
    
    AnimateHUDOut(AllHUDElements, function()
        for _, element in ipairs(AllHUDElements) do
            element.Visible = false
        end
    end)
    
    if ActiveFunctionsGui then
        AnimateHUDOut({ActiveFunctionsGui.ActiveFunctionsFrame}, function()
            ActiveFunctionsGui.Visible = false
        end)
    end
end

Tab_Visuals:CreateToggle({
    Name = "Enable HUD",
    CurrentValue = false,
    Flag = "HUDToggle",
    Callback = function(Value)
        HUDEnabled = Value
        if Value then
            ShowHUD()
            -- Запускаем обновление
            task.spawn(function()
                while HUDEnabled do
                    UpdateHUDInfo()
                    task.wait(0.5)
                end
            end)
        else
            HideHUD()
        end
    end
})

--// Функция обновления HUD
function UpdateHUDInfo()
    if not HUDEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    -- Обновляем режим игры
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
    
    local myTeam = nil
    if getTFolder() and getTFolder():FindFirstChild(player.Name) then myTeam = "T" end
    if getCTFolder() and getCTFolder():FindFirstChild(player.Name) then myTeam = "CT" end
    if myTeam then gameMode = gameMode .. " [" .. myTeam .. "]" end
    
    if HUDObjects.GameMode then HUDObjects.GameMode.Text = "📌 Режим: " .. gameMode end
    
    -- Обновляем наблюдателей
    local spectators = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local camSubject = workspace.CurrentCamera.CameraSubject
                    if camSubject == plr.Character then
                        table.insert(spectators, plr.Name)
                    end
                end
            end
        end
    end
    
    if HUDObjects.Spectators then
        local specText = "👀 Наблюдатели: "
        if #spectators > 0 then
            specText = specText .. table.concat(spectators, ", ")
            HUDObjects.Spectators.TextColor3 = Color3.fromRGB(255, 0, 0)
        else
            specText = specText .. "Нет"
            HUDObjects.Spectators.TextColor3 = Color3.fromRGB(200, 200, 255)
        end
        HUDObjects.Spectators.Text = specText
    end
    
    -- Обновляем информацию о враге
    local enemyFolder = getEnemyFolder()
    if enemyFolder then
        local myPos = character:FindFirstChild("HumanoidRootPart")
        if myPos then
            local closestEnemy = nil
            local closestDist = math.huge
            local enemyHealth = 0
            local enemyName = "Нет"
            
            for _, enemy in ipairs(enemyFolder:GetChildren()) do
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    local dist = (myPos.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestEnemy = enemy
                        enemyHealth = hum.Health
                        enemyName = enemy.Name
                    end
                end
            end
            
            if closestEnemy then
                if HUDObjects.Distance then HUDObjects.Distance.Text = "📏 " .. math.floor(closestDist) .. "m" end
                if HUDObjects.Health then 
                    HUDObjects.Health.Text = "❤️ " .. math.floor(enemyHealth) .. "/100"
                    if enemyHealth < 30 then
                        HUDObjects.Health.TextColor3 = Color3.fromRGB(255, 50, 50)
                    elseif enemyHealth < 60 then
                        HUDObjects.Health.TextColor3 = Color3.fromRGB(255, 200, 50)
                    else
                        HUDObjects.Health.TextColor3 = Color3.fromRGB(128, 0, 255)
                    end
                end
                if HUDObjects.PlayerName then HUDObjects.PlayerName.Text = "👤 " .. enemyName end
                if HUDObjects.Weapon then 
                    local weapon = GetCurrentWeapon()
                    HUDObjects.Weapon.Text = "🔫 " .. (weapon ~= "Unknown" and weapon or "Нет")
                end
                if HUDObjects.HPBar then
                    local hpPercent = enemyHealth / 100
                    HUDObjects.HPBar.Size = UDim2.new(hpPercent, 0, 1, 0)
                    if enemyHealth < 30 then
                        HUDObjects.HPBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    elseif enemyHealth < 60 then
                        HUDObjects.HPBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                    else
                        HUDObjects.HPBar.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
                    end
                end
            end
        end
    end
    
    -- Обновляем активные функции
    if HUDObjects.AimbotStatus then
        HUDObjects.AimbotStatus.Text = "🎯 Aimbot: " .. (AimbotEnabled and "ON [" .. AimMode .. "]" or "OFF")
        HUDObjects.AimbotStatus.TextColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    end
    if HUDObjects.TriggerBotStatus then
        HUDObjects.TriggerBotStatus.Text = "🔫 TriggerBot: " .. (TriggerBotEnabled and "ON [" .. TriggerBotMode .. "]" or "OFF")
        HUDObjects.TriggerBotStatus.TextColor3 = TriggerBotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    end
    if HUDObjects.ESPStatus then
        HUDObjects.ESPStatus.Text = "👁 ESP: " .. (EspEnabled and "ON" or "OFF")
        HUDObjects.ESPStatus.TextColor3 = EspEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    end
    if HUDObjects.FarmStatus then
        HUDObjects.FarmStatus.Text = "🌾 Farm: " .. (FarmModeEnabled and "ON" or "OFF")
        HUDObjects.FarmStatus.TextColor3 = FarmModeEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    end
end

Tab_Visuals:CreateLabel("💡 Перетащите блоки мышкой для настройки позиции", "info", Color3.fromRGB(128, 0, 255), false)

Tab_Visuals:CreateButton({
    Name = "🔄 Сбросить позиции HUD",
    Callback = function()
        HUDSettings.MainBlock = {X = 0.02, Y = 0.02}
        HUDSettings.GameMode = {X = 0.02, Y = 0.15}
        HUDSettings.Spectators = {X = 0.02, Y = 0.22}
        HUDSettings.ActiveFunctions = {X = 0.02, Y = 0.30}
        HUDSettings.FarmHUD = {X = 0.75, Y = 0.02}
        
        if HUDObjects.MainBlock then HUDObjects.MainBlock.Position = UDim2.new(0.02, 0, 0.02, 0) end
        if HUDObjects.GameModeBlock then HUDObjects.GameModeBlock.Position = UDim2.new(0.02, 0, 0.15, 0) end
        if HUDObjects.SpecBlock then HUDObjects.SpecBlock.Position = UDim2.new(0.02, 0, 0.22, 0) end
        if HUDObjects.ActiveFunctionsFrame then HUDObjects.ActiveFunctionsFrame.Position = UDim2.new(0.02, 0, 0.30, 0) end
        if HUDObjects.FarmHUDFrame then HUDObjects.FarmHUDFrame.Position = UDim2.new(0.75, 0, 0.02, 0) end
    end
})

--// ==========================================
--// WORLD & EFFECTS
--// ==========================================
Tab_Visuals:CreateSection("🌍 World & Effects")
local AntiFlashEnabled, AntiSmokeEnabled = false, false
Tab_Visuals:CreateToggle({Name = "Anti-Flashbang", CurrentValue = false, Flag = "AntiFlashToggle", Callback = function(Value) AntiFlashEnabled = Value end})
Tab_Visuals:CreateToggle({Name = "Anti-Smoke", CurrentValue = false, Flag = "AntiSmokeToggle", Callback = function(Value) AntiSmokeEnabled = Value end})

task.spawn(function()
    while task.wait(0.2) do
        if AntiFlashEnabled then
            local gui = player.PlayerGui:FindFirstChild("FlashbangEffect")
            local effect = game:GetService("Lighting"):FindFirstChild("FlashbangColorCorrection")
            if gui then gui:Destroy() end
            if effect then effect:Destroy() end
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
