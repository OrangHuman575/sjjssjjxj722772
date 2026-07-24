-- Roblox Fly GUI LocalScript
-- Place this LocalScript in StarterPlayerScripts or run it from a trusted local context.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local flySpeed = 60
local flying = false
local movement = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false,
}

local currentVelocity
local currentGyro
local flyConnection

local function getCharacterParts()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    return character, humanoid, rootPart
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "FlyFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 190)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -95)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -16, 0, 36)
titleLabel.Position = UDim2.new(0, 8, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ranggi4561 Fly Gui"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -20, 0, 24)
statusLabel.Position = UDim2.new(0, 10, 0, 46)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 110, 110)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "Speed"
speedLabel.Size = UDim2.new(1, -20, 0, 24)
speedLabel.Position = UDim2.new(0, 10, 0, 78)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(210, 210, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

local function createButton(name, text, position, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 120, 0, 38)
    button.Position = position
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = mainFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    return button
end

local toggleButton = createButton("ToggleFly", "Fly: OFF", UDim2.new(0, 15, 0, 120), Color3.fromRGB(190, 65, 65))
local slowerButton = createButton("Slower", "- Speed", UDim2.new(0, 145, 0, 120), Color3.fromRGB(70, 80, 120))
local fasterButton = createButton("Faster", "+ Speed", UDim2.new(0, 145, 0, 75), Color3.fromRGB(70, 120, 80))

local controlsLabel = Instance.new("TextLabel")
controlsLabel.Name = "Controls"
controlsLabel.Size = UDim2.new(1, -20, 0, 20)
controlsLabel.Position = UDim2.new(0, 10, 1, -26)
controlsLabel.BackgroundTransparency = 1
controlsLabel.Text = "WASD move | Space up | Ctrl down"
controlsLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
controlsLabel.TextScaled = true
controlsLabel.Font = Enum.Font.Gotham
controlsLabel.Parent = mainFrame

local function updateGui()
    if flying then
        statusLabel.Text = "Status: ON"
        statusLabel.TextColor3 = Color3.fromRGB(110, 255, 140)
        toggleButton.Text = "Fly: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(65, 170, 80)
    else
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 110, 110)
        toggleButton.Text = "Fly: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(190, 65, 65)
    end

    speedLabel.Text = "Speed: " .. flySpeed
end

local function stopFlying()
    flying = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if currentVelocity then
        currentVelocity:Destroy()
        currentVelocity = nil
    end

    if currentGyro then
        currentGyro:Destroy()
        currentGyro = nil
    end

    local _, humanoid = getCharacterParts()
    humanoid.PlatformStand = false
    updateGui()
end

local function startFlying()
    local _, humanoid, rootPart = getCharacterParts()
    flying = true
    humanoid.PlatformStand = true

    currentVelocity = Instance.new("BodyVelocity")
    currentVelocity.Name = "FlyVelocity"
    currentVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    currentVelocity.Velocity = Vector3.zero
    currentVelocity.Parent = rootPart

    currentGyro = Instance.new("BodyGyro")
    currentGyro.Name = "FlyGyro"
    currentGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    currentGyro.P = 9000
    currentGyro.CFrame = rootPart.CFrame
    currentGyro.Parent = rootPart

    flyConnection = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        local direction = Vector3.zero

        if movement.Forward then direction += camera.CFrame.LookVector end
        if movement.Backward then direction -= camera.CFrame.LookVector end
        if movement.Right then direction += camera.CFrame.RightVector end
        if movement.Left then direction -= camera.CFrame.RightVector end
        if movement.Up then direction += Vector3.yAxis end
        if movement.Down then direction -= Vector3.yAxis end

        if direction.Magnitude > 0 then
            currentVelocity.Velocity = direction.Unit * flySpeed
        else
            currentVelocity.Velocity = Vector3.zero
        end

        currentGyro.CFrame = camera.CFrame
    end)

    updateGui()
end

local function toggleFly()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end

toggleButton.MouseButton1Click:Connect(toggleFly)

fasterButton.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, 10, 200)
    updateGui()
end)

slowerButton.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, 10, 200)
    updateGui()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.W then
        movement.Forward = true
    elseif input.KeyCode == Enum.KeyCode.S then
        movement.Backward = true
    elseif input.KeyCode == Enum.KeyCode.A then
        movement.Left = true
    elseif input.KeyCode == Enum.KeyCode.D then
        movement.Right = true
    elseif input.KeyCode == Enum.KeyCode.Space then
        movement.Up = true
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        movement.Down = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        movement.Forward = false
    elseif input.KeyCode == Enum.KeyCode.S then
        movement.Backward = false
    elseif input.KeyCode == Enum.KeyCode.A then
        movement.Left = false
    elseif input.KeyCode == Enum.KeyCode.D then
        movement.Right = false
    elseif input.KeyCode == Enum.KeyCode.Space then
        movement.Up = false
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        movement.Down = false
    end
end)

player.CharacterAdded:Connect(function()
    if flying then
        stopFlying()
    end
end)

updateGui()
