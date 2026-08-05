-- ============================================
-- QUWES - ПОЛНЫЙ АВТОНОМНЫЙ СКРИПТ
-- БЕЗ RAYFIELD | ВОДЯНОЙ ЗНАК СВЕРХУ СПРАВА
-- НАЖМИ RightShift ДЛЯ ОТКРЫТИЯ МЕНЮ
-- ============================================

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- ============================================
-- НАСТРОЙКИ
-- ============================================

local aimbotSettings = {
    Enabled = false,
    Mode = "FOV",
    Target = "Head",
    FOVRadius = 150,
    Smoothness = 0.3,
    ShowFOV = true
}

local espSettings = {
    Enabled = false,
    Boxes = true,
    Names = true,
    Health = true,
    Weapon = true,
    Ping = true,
    Distance = false
}

-- ============================================
-- ВОДЯНОЙ ЗНАК (СВЕРХУ СПРАВА)
-- ============================================

local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "WatermarkGUI"
watermarkGui.Parent = player:WaitForChild("PlayerGui")
watermarkGui.IgnoreGuiInset = true

local Watermark = Instance.new("TextLabel")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 200, 0, 30)
Watermark.Position = UDim2.new(1, -210, 0, 10) -- СВЕРХУ СПРАВА
Watermark.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Watermark.BackgroundTransparency = 0.2
Watermark.Text = "⚛︎ QUWES v1.0 ⚛︎"
Watermark.TextColor3 = Color3.fromRGB(180, 130, 255)
Watermark.TextSize = 15
Watermark.Font = Enum.Font.GothamBold
Watermark.TextXAlignment = Enum.TextXAlignment.Center
Watermark.Parent = watermarkGui

local WatermarkCorner = Instance.new("UICorner")
WatermarkCorner.CornerRadius = UDim.new(0, 8)
WatermarkCorner.Parent = Watermark

-- ============================================
-- FOV КРУГ
-- ============================================

local fovGui = Instance.new("ScreenGui")
fovGui.Name = "FOVGUI"
fovGui.Parent = player:WaitForChild("PlayerGui")
fovGui.IgnoreGuiInset = true

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.Size = UDim2.new(0, 300, 0, 300)
FOVCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
FOVCircle.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
FOVCircle.BackgroundTransparency = 0.85
FOVCircle.BorderSizePixel = 2
FOVCircle.BorderColor3 = Color3.fromRGB(150, 80, 255)
FOVCircle.Visible = false
FOVCircle.Parent = fovGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

-- ============================================
-- ОСНОВНОЕ МЕНЮ
-- ============================================

local gui = Instance.new("ScreenGui")
gui.Name = "QuwesGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.Enabled = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 560)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Parent = gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local NeonBorder = Instance.new("Frame")
NeonBorder.Name = "NeonBorder"
NeonBorder.Size = UDim2.new(1, 12, 1, 12)
NeonBorder.Position = UDim2.new(0, -6, 0, -6)
NeonBorder.BackgroundColor3 = Color3.fromRGB(130, 60, 230)
NeonBorder.BackgroundTransparency = 0.6
NeonBorder.BorderSizePixel = 0
NeonBorder.Parent = MainFrame

local BorderCorner = Instance.new("UICorner")
BorderCorner.CornerRadius = UDim.new(0, 18)
BorderCorner.Parent = NeonBorder

-- ============================================
-- ХЕДЕР
-- ============================================

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 200, 1, 0)
Logo.Position = UDim2.new(0, 15, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "⚛︎ QUWES"
Logo.TextColor3 = Color3.fromRGB(210, 160, 255)
Logo.TextSize = 22
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Font = Enum.Font.GothamBold
Logo.Parent = Header

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 120, 1, 0)
VersionLabel.Position = UDim2.new(1, -130, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0"
VersionLabel.TextColor3 = Color3.fromRGB(160, 130, 200)
VersionLabel.TextSize = 14
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = Header

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.Position = UDim2.new(0, 205, 0.5, -5)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = Header

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusDot

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 50, 0, 16)
StatusText.Position = UDim2.new(0, 218, 0.5, -8)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Онлайн"
StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusText.TextSize = 12
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -48, 0.5, -18)
CloseButton.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
CloseButton.BackgroundTransparency = 0.5
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(220, 180, 220)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- ============================================
-- ВКЛАДКИ
-- ============================================

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -20, 0, 48)
TabContainer.Position = UDim2.new(0, 10, 0, 65)
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
TabContainer.BackgroundTransparency = 0.3
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabContainer

local tabs = {}
local currentTab = "Combat"

local function CreateTabButton(name, icon, position)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(0.3, 0, 1, 0)
    btn.Position = UDim2.new(position, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
    btn.BackgroundTransparency = 0.6
    btn.Text = icon .. " " .. name:upper()
    btn.TextColor3 = Color3.fromRGB(160, 150, 190)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
            tab.BackgroundTransparency = 0.6
            tab.TextColor3 = Color3.fromRGB(160, 150, 190)
            tab.BorderSizePixel = 0
        end
        btn.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
        btn.BackgroundTransparency = 0.15
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(180, 100, 255)
        currentTab = name
        UpdateContent(name)
    end)
    
    tabs[name] = btn
    return btn
end

CreateTabButton("Combat", "⚔️", 0.01)
CreateTabButton("Visual", "👁️", 0.333)
CreateTabButton("Inventory", "🎒", 0.666)

-- ============================================
-- КОНТЕНТ (СОДЕРЖИМОЕ ВКЛАДОК)
-- ============================================

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -24, 1, -140)
ContentContainer.Position = UDim2.new(0, 12, 0, 125)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local contentObjects = {}

local function ClearContent()
    for _, obj in pairs(contentObjects) do
        obj:Destroy()
    end
    contentObjects = {}
end

local function CreateToggle(text, icon, position, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.45, -5, 0, 42)
    frame.Position = UDim2.new(position, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 22, 42)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(50, 40, 80)
    frame.Parent = ContentContainer
    table.insert(contentObjects, frame)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. text
    label.TextColor3 = Color3.fromRGB(220, 215, 240)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    table.insert(contentObjects, label)
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 52, 0, 26)
    toggle.Position = UDim2.new(0.8, 0, 0.5, -13)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(220, 120, 120)
    toggle.TextSize = 11
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = frame
    table.insert(contentObjects, toggle)
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggle.BackgroundColor3 = Color3.fromRGB(70, 190, 130)
            toggle.Text = "ON"
            toggle.TextColor3 = Color3.fromRGB(150, 255, 200)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.fromRGB(220, 120, 120)
        end
        if callback then callback(state) end
    end)
    
    return toggle
end

local function CreateDropdown(text, icon, position, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.45, -5, 0, 42)
    frame.Position = UDim2.new(position, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 22, 42)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(50, 40, 80)
    frame.Parent = ContentContainer
    table.insert(contentObjects, frame)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. text
    label.TextColor3 = Color3.fromRGB(220, 215, 240)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    table.insert(contentObjects, label)
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0.4, 0, 0, 26)
    dropdown.Position = UDim2.new(0.55, 0, 0.5, -13)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
    dropdown.Text = options[1]
    dropdown.TextColor3 = Color3.fromRGB(200, 190, 220)
    dropdown.TextSize = 12
    dropdown.Font = Enum.Font.GothamBold
    dropdown.Parent = frame
    table.insert(contentObjects, dropdown)
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local currentIndex = 1
    dropdown.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        dropdown.Text = options[currentIndex]
        if callback then callback(options[currentIndex]) end
    end)
    
    return dropdown
end

-- ============================================
-- ⚔️ COMBAT
-- ============================================

local function CombatContent()
    ClearContent()
    
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.Text = "⚔️ COMBAT SETTINGS"
    header.TextColor3 = Color3.fromRGB(210, 160, 255)
    header.TextSize = 17
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = ContentContainer
    table.insert(contentObjects, header)
    
    CreateToggle("Aimbot", "🎯", 0, function(state)
        aimbotSettings.Enabled = state
        FOVCircle.Visible = state and aimbotSettings.Mode == "FOV"
    end)
    
    CreateDropdown("Mode", "📌", 0.5, {"Normal", "FOV"}, function(value)
        aimbotSettings.Mode = value
        FOVCircle.Visible = aimbotSettings.Enabled and value == "FOV"
    end)
    
    CreateDropdown("Target", "🎯", 0, {"Head", "Torso", "Legs"}, function(value)
        aimbotSettings.Target = value
    end)
    
    CreateToggle("Show FOV", "👁️", 0.5, function(state)
        aimbotSettings.ShowFOV = state
        FOVCircle.Visible = aimbotSettings.Enabled and aimbotSettings.Mode == "FOV" and state
    end)
    
    CreateToggle("Silent Aim", "🤫", 0)
    CreateToggle("Trigger Bot", "⚡", 0.5)
    CreateToggle("Wall Hack", "🧱", 0)
    CreateToggle("Auto Shoot", "🔫", 0.5)
end

-- ============================================
-- 👁️ VISUAL
-- ============================================

local function VisualContent()
    ClearContent()
    
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.Text = "👁️ VISUAL SETTINGS"
    header.TextColor3 = Color3.fromRGB(210, 160, 255)
    header.TextSize = 17
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = ContentContainer
    table.insert(contentObjects, header)
    
    CreateToggle("ESP Enabled", "🟣", 0, function(state)
        espSettings.Enabled = state
        if state then CreateESP() else ClearESP() end
    end)
    
    CreateToggle("ESP Boxes", "📦", 0.5, function(state)
        espSettings.Boxes = state
        if espSettings.Enabled then CreateESP() end
    end)
    
    CreateToggle("ESP Names", "🏷️", 0, function(state)
        espSettings.Names = state
        if espSettings.Enabled then CreateESP() end
    end)
    
    CreateToggle("ESP Health", "❤️", 0.5, function(state)
        espSettings.Health = state
        if espSettings.Enabled then CreateESP() end
    end)
    
    CreateToggle("ESP Weapon", "🔫", 0, function(state)
        espSettings.Weapon = state
        if espSettings.Enabled then CreateESP() end
    end)
    
    CreateToggle("ESP Ping", "📶", 0.5, function(state)
        espSettings.Ping = state
        if espSettings.Enabled then CreateESP() end
    end)
    
    CreateToggle("ESP Distance", "📏", 0, function(state)
        espSettings.Distance = state
        if espSettings.Enabled then CreateESP() end
    end)
end

-- ============================================
-- 🎒 INVENTORY
-- ============================================

local function InventoryContent()
    ClearContent()
    
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 28)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.Text = "🎒 INVENTORY SETTINGS"
    header.TextColor3 = Color3.fromRGB(210, 160, 255)
    header.TextSize = 17
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = ContentContainer
    table.insert(contentObjects, header)
    
    CreateToggle("Infinite Ammo", "♾️", 0)
    CreateToggle("No Reload", "🔄", 0.5)
    CreateToggle("Fast Reload", "⚡", 0)
    CreateToggle("All Weapons", "🗡️", 0.5)
    CreateToggle("Unlock Skins", "🎨", 0)
    CreateToggle("Auto Loot", "📦", 0.5)
end

-- ============================================
-- ОБНОВЛЕНИЕ КОНТЕНТА
-- ============================================

local function UpdateContent(tab)
    if tab == "Combat" then
        CombatContent()
    elseif tab == "Visual" then
        VisualContent()
    elseif tab == "Inventory" then
        InventoryContent()
    end
end

-- Активация первой вкладки
tabs["Combat"].BackgroundColor3 = Color3.fromRGB(120, 60, 220)
tabs["Combat"].BackgroundTransparency = 0.15
tabs["Combat"].TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Combat"].BorderSizePixel = 2
tabs["Combat"].BorderColor3 = Color3.fromRGB(180, 100, 255)
CombatContent()

-- ============================================
-- ФУТЕР
-- ============================================

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -30)
Footer.BackgroundTransparency = 1
Footer.Text = "⚛︎ QUWES v1.0 • Blox Strike Edition"
Footer.TextColor3 = Color3.fromRGB(100, 80, 150)
Footer.TextSize = 12
Footer.Font = Enum.Font.Gotham
Footer.Parent = MainFrame

-- ============================================
-- ОТКРЫТИЕ ПО ПРАВОМУ SHIFT
-- ============================================

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- ============================================
-- ПЕРЕТАСКИВАНИЕ
-- ============================================

local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

runService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = userInputService:GetMouseLocation()
        local delta = mousePos - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ============================================
-- ПУЛЬСАЦИЯ НЕОНА
-- ============================================

coroutine.wrap(function()
    while gui.Parent do
        if gui.Enabled then
            tweenService:Create(NeonBorder, 
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {BackgroundTransparency = 0.4}
            ):Play()
            task.wait(1.5)
            tweenService:Create(NeonBorder, 
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {BackgroundTransparency = 0.7}
            ):Play()
            task.wait(1.5)
        else
            task.wait(0.5)
        end
    end
end)()

-- ============================================
-- 📡 ESP
-- ============================================

local espGui = Instance.new("ScreenGui")
espGui.Name = "ESPGUI"
espGui.Parent = player:WaitForChild("PlayerGui")

local espObjects = {}

local function ClearESP()
    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}
end

local function CreateESP()
    ClearESP()
    if not espSettings.Enabled then return end
    
    for _, target in pairs(game:GetService("Players"):GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character:FindFirstChild("Head") then
            local humanoid = target.Character.Humanoid
            if humanoid and humanoid.Health > 0 then
                local container = Instance.new("Frame")
                container.Name = target.Name .. "_ESP"
                container.Size = UDim2.new(0, 0, 0, 0)
                container.BackgroundTransparency = 1
                container.Parent = espGui
                table.insert(espObjects, container)
                
                local box = Instance.new("Frame")
                box.Name = "Box"
                box.Size = UDim2.new(0, 60, 0, 80)
                box.Position = UDim2.new(0, -30, 0, -40)
                box.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
                box.BackgroundTransparency = 0.6
                box.BorderSizePixel = 2
                box.BorderColor3 = Color3.fromRGB(150, 80, 255)
                box.Parent = container
                box.Visible = espSettings.Boxes
                table.insert(espObjects, box)
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "Name"
                nameLabel.Size = UDim2.new(0, 120, 0, 18)
                nameLabel.Position = UDim2.new(0, -60, 0, -58)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = target.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 12
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextStrokeTransparency = 0.3
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.Parent = container
                nameLabel.Visible = espSettings.Names
                table.insert(espObjects, nameLabel)
                
                local healthLabel = Instance.new("TextLabel")
                healthLabel.Name = "Health"
                healthLabel.Size = UDim2.new(0, 80, 0, 16)
                healthLabel.Position = UDim2.new(0, -40, 0, -78)
                healthLabel.BackgroundTransparency = 1
                healthLabel.Text = "❤️ " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
                healthLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                healthLabel.TextSize = 11
                healthLabel.Font = Enum.Font.GothamBold
                healthLabel.TextStrokeTransparency = 0.3
                healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                healthLabel.Parent = container
                healthLabel.Visible = espSettings.Health
                table.insert(espObjects, healthLabel)
                
                local weaponLabel = Instance.new("TextLabel")
                weaponLabel.Name = "Weapon"
                weaponLabel.Size = UDim2.new(0, 100, 0, 16)
                weaponLabel.Position = UDim2.new(0, -50, 0, 42)
                weaponLabel.BackgroundTransparency = 1
                local tool = target.Character:FindFirstChildOfClass("Tool")
                weaponLabel.Text = "🔫 " .. (tool and tool.Name or "No Weapon")
                weaponLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                weaponLabel.TextSize = 10
                weaponLabel.Font = Enum.Font.GothamBold
                weaponLabel.TextStrokeTransparency = 0.3
                weaponLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                weaponLabel.Parent = container
                weaponLabel.Visible = espSettings.Weapon
                table.insert(espObjects, weaponLabel)
            end
        end
    end
end

runService.RenderStepped:Connect(function()
    if not espSettings.Enabled then return end
    
    for _, container in pairs(espGui:GetChildren()) do
        if string.find(container.Name, "_ESP") then
            local targetName = string.gsub(container.Name, "_ESP", "")
            local target = game:GetService("Players"):FindFirstChild(targetName)
            
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local head = target.Character.Head
                local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    container.Position = UDim2.new(0, pos.X, 0, pos.Y)
                    container.Visible = true
                else
                    container.Visible = false
                end
            else
                container.Visible = false
            end
        end
    end
end)

-- ============================================
-- 🎯 AIMBOT
-- ============================================

local function GetClosestPlayer()
    local closest = nil
    local closestDist = math.huge
    
    for _, target in pairs(game:GetService("Players"):GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character:FindFirstChild("Head") then
            local humanoid = target.Character.Humanoid
            if humanoid and humanoid.Health > 0 then
                local head = target.Character.Head
                local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (camera.CFrame.Position - head.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = target
                    end
                end
            end
        end
    end
    
    return closest
end

runService.RenderStepped:Connect(function()
    if not aimbotSettings.Enabled then return end
    
    local target = GetClosestPlayer()
    if not target then return end
    
    local head = target.Character.Head
    local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
    
    if onScreen then
        if aimbotSettings.Mode == "FOV" then
            local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local fovDist = (Vector2.new(headPos.X, headPos.Y) - center).Magnitude
            if fovDist > aimbotSettings.FOVRadius then return end
        end
        
        local mousePos = userInputService:GetMouseLocation()
        local moveX = (headPos.X - mousePos.X) * aimbotSettings.Smoothness
        local moveY = (headPos.Y - mousePos.Y) * aimbotSettings.Smoothness
        
        if mousemoverel then
            mousemoverel(moveX, moveY)
        end
    end
end)

print("⚛︎ QUWES v1.0 успешно загружен!")
print("Нажми RightShift для открытия меню")
