diff --git a/My Executor b/My Executor
index ad25a9dadf86e6669f71b875ca704142c5a2cc8d..dc5e42af84b83690c9b197d409d1c5477a8e378a 100644
--- a/My Executor	
+++ b/My Executor	
@@ -1,162 +1,262 @@
--- ranggi4561 destroys Roblox games Executor (Smaller Version)
-local player = game.Players.LocalPlayer
+-- Roblox Fly GUI LocalScript
+-- Place this LocalScript in StarterPlayerScripts or run it from a trusted local context.
+
+local Players = game:GetService("Players")
+local RunService = game:GetService("RunService")
+local UserInputService = game:GetService("UserInputService")
+
+local player = Players.LocalPlayer
 local playerGui = player:WaitForChild("PlayerGui")
 
+local flySpeed = 60
+local flying = false
+local movement = {
+    Forward = false,
+    Backward = false,
+    Left = false,
+    Right = false,
+    Up = false,
+    Down = false,
+}
+
+local currentVelocity
+local currentGyro
+local flyConnection
+
+local function getCharacterParts()
+    local character = player.Character or player.CharacterAdded:Wait()
+    local humanoid = character:WaitForChild("Humanoid")
+    local rootPart = character:WaitForChild("HumanoidRootPart")
+
+    return character, humanoid, rootPart
+end
+
 local screenGui = Instance.new("ScreenGui")
-screenGui.Name = "Ranggi4561Executor"
+screenGui.Name = "FlyGui"
 screenGui.ResetOnSpawn = false
 screenGui.Parent = playerGui
 
--- Smaller Main Frame
 local mainFrame = Instance.new("Frame")
-mainFrame.Name = "ExecutorFrame"
-mainFrame.Size = UDim2.new(0, 480, 0, 320)           -- Smaller
-mainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
-mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
+mainFrame.Name = "FlyFrame"
+mainFrame.Size = UDim2.new(0, 280, 0, 190)
+mainFrame.Position = UDim2.new(0.5, -140, 0.5, -95)
+mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
 mainFrame.BorderSizePixel = 0
 mainFrame.Active = true
 mainFrame.Draggable = true
-mainFrame.Visible = true
 mainFrame.Parent = screenGui
 
--- Top Bar
-local topBar = Instance.new("Frame")
-topBar.Size = UDim2.new(1, 0, 0, 35)                 -- Slightly thinner
-topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
-topBar.BorderSizePixel = 0
-topBar.Parent = mainFrame
+local frameCorner = Instance.new("UICorner")
+frameCorner.CornerRadius = UDim.new(0, 12)
+frameCorner.Parent = mainFrame
 
 local titleLabel = Instance.new("TextLabel")
-titleLabel.Size = UDim2.new(1, -120, 1, 0)
-titleLabel.Position = UDim2.new(0, 10, 0, 0)
+titleLabel.Name = "Title"
+titleLabel.Size = UDim2.new(1, -16, 0, 36)
+titleLabel.Position = UDim2.new(0, 8, 0, 6)
 titleLabel.BackgroundTransparency = 1
-titleLabel.Text = "ranggi4561 destroys Roblox games"
+titleLabel.Text = "ranggi4561 Fly Gui"
 titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
 titleLabel.TextScaled = true
-titleLabel.Font = Enum.Font.SourceSansBold
-titleLabel.TextXAlignment = Enum.TextXAlignment.Left
-titleLabel.Parent = topBar
-
--- Minimize Button
-local minimizeBtn = Instance.new("TextButton")
-minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
-minimizeBtn.Position = UDim2.new(1, -33, 0.5, -14)
-minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
-minimizeBtn.Text = "−"
-minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
-minimizeBtn.TextScaled = true
-minimizeBtn.Font = Enum.Font.SourceSansBold
-minimizeBtn.Parent = topBar
-
--- Smaller Circular Floating Button with Red "R"
-local floatBtn = Instance.new("TextButton")
-floatBtn.Name = "FloatingButton"
-floatBtn.Size = UDim2.new(0, 75, 0, 75)              -- Much smaller
-floatBtn.Position = UDim2.new(0.5, -37.5, 0.15, 0)
-floatBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
-floatBtn.BorderSizePixel = 3
-floatBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
-floatBtn.Text = "R"
-floatBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
-floatBtn.TextScaled = true
-floatBtn.Font = Enum.Font.SourceSansBold
-floatBtn.Visible = false
-floatBtn.Active = true
-floatBtn.Draggable = true
-floatBtn.Parent = screenGui
-
-local uiCorner = Instance.new("UICorner")
-uiCorner.CornerRadius = UDim.new(0.5, 0)
-uiCorner.Parent = floatBtn
-
--- Rest of UI (scaled down)
-local autoLabel = Instance.new("TextLabel")
-autoLabel.Size = UDim2.new(0, 130, 0, 18)
-autoLabel.Position = UDim2.new(0, 10, 0, 40)
-autoLabel.BackgroundTransparency = 1
-autoLabel.Text = "Auto Username Fill"
-autoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
-autoLabel.TextXAlignment = Enum.TextXAlignment.Left
-autoLabel.TextScaled = true
-autoLabel.Parent = mainFrame
-
-local scriptBox = Instance.new("TextBox")
-scriptBox.Size = UDim2.new(1, -20, 1, -105)
-scriptBox.Position = UDim2.new(0, 10, 0, 62)
-scriptBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
-scriptBox.TextColor3 = Color3.fromRGB(0, 255, 0)
-scriptBox.Text = "-- Paste your script here\nprint(\"ranggi4561 destroys Roblox games loaded!\")"
-scriptBox.TextWrapped = true
-scriptBox.MultiLine = true
-scriptBox.Font = Enum.Font.Code
-scriptBox.TextSize = 13                     -- Smaller text
-scriptBox.Parent = mainFrame
-
-local bottomBar = Instance.new("Frame")
-bottomBar.Size = UDim2.new(1, 0, 0, 42)
-bottomBar.Position = UDim2.new(0, 0, 1, -42)
-bottomBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
-bottomBar.Parent = mainFrame
-
--- Bottom Buttons (smaller)
-local function createButton(name, pos, color, text)
-    local btn = Instance.new("TextButton")
-    btn.Size = UDim2.new(0.24, -8, 0.85, 0)
-    btn.Position = pos
-    btn.BackgroundColor3 = color
-    btn.Text = text
-    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
-    btn.TextScaled = true
-    btn.Font = Enum.Font.SourceSansBold
-    btn.Parent = bottomBar
-    return btn
+titleLabel.Font = Enum.Font.GothamBold
+titleLabel.Parent = mainFrame
+
+local statusLabel = Instance.new("TextLabel")
+statusLabel.Name = "Status"
+statusLabel.Size = UDim2.new(1, -20, 0, 24)
+statusLabel.Position = UDim2.new(0, 10, 0, 46)
+statusLabel.BackgroundTransparency = 1
+statusLabel.Text = "Status: OFF"
+statusLabel.TextColor3 = Color3.fromRGB(255, 110, 110)
+statusLabel.TextScaled = true
+statusLabel.Font = Enum.Font.Gotham
+statusLabel.Parent = mainFrame
+
+local speedLabel = Instance.new("TextLabel")
+speedLabel.Name = "Speed"
+speedLabel.Size = UDim2.new(1, -20, 0, 24)
+speedLabel.Position = UDim2.new(0, 10, 0, 78)
+speedLabel.BackgroundTransparency = 1
+speedLabel.Text = "Speed: " .. flySpeed
+speedLabel.TextColor3 = Color3.fromRGB(210, 210, 255)
+speedLabel.TextScaled = true
+speedLabel.Font = Enum.Font.Gotham
+speedLabel.Parent = mainFrame
+
+local function createButton(name, text, position, color)
+    local button = Instance.new("TextButton")
+    button.Name = name
+    button.Size = UDim2.new(0, 120, 0, 38)
+    button.Position = position
+    button.BackgroundColor3 = color
+    button.Text = text
+    button.TextColor3 = Color3.fromRGB(255, 255, 255)
+    button.TextScaled = true
+    button.Font = Enum.Font.GothamBold
+    button.Parent = mainFrame
+
+    local buttonCorner = Instance.new("UICorner")
+    buttonCorner.CornerRadius = UDim.new(0, 8)
+    buttonCorner.Parent = button
+
+    return button
+end
+
+local toggleButton = createButton("ToggleFly", "Fly: OFF", UDim2.new(0, 15, 0, 120), Color3.fromRGB(190, 65, 65))
+local slowerButton = createButton("Slower", "- Speed", UDim2.new(0, 145, 0, 120), Color3.fromRGB(70, 80, 120))
+local fasterButton = createButton("Faster", "+ Speed", UDim2.new(0, 145, 0, 75), Color3.fromRGB(70, 120, 80))
+
+local controlsLabel = Instance.new("TextLabel")
+controlsLabel.Name = "Controls"
+controlsLabel.Size = UDim2.new(1, -20, 0, 20)
+controlsLabel.Position = UDim2.new(0, 10, 1, -26)
+controlsLabel.BackgroundTransparency = 1
+controlsLabel.Text = "WASD move | Space up | Ctrl down"
+controlsLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
+controlsLabel.TextScaled = true
+controlsLabel.Font = Enum.Font.Gotham
+controlsLabel.Parent = mainFrame
+
+local function updateGui()
+    if flying then
+        statusLabel.Text = "Status: ON"
+        statusLabel.TextColor3 = Color3.fromRGB(110, 255, 140)
+        toggleButton.Text = "Fly: ON"
+        toggleButton.BackgroundColor3 = Color3.fromRGB(65, 170, 80)
+    else
+        statusLabel.Text = "Status: OFF"
+        statusLabel.TextColor3 = Color3.fromRGB(255, 110, 110)
+        toggleButton.Text = "Fly: OFF"
+        toggleButton.BackgroundColor3 = Color3.fromRGB(190, 65, 65)
+    end
+
+    speedLabel.Text = "Speed: " .. flySpeed
 end
 
-local executeBtn = createButton("Execute", UDim2.new(0, 8, 0.08, 0), Color3.fromRGB(0, 100, 0), "Execute")
-local clearBtn   = createButton("Clear",   UDim2.new(0.25, 8, 0.08, 0), Color3.fromRGB(150, 0, 0), "Clear")
-local resetBtn   = createButton("Reset",   UDim2.new(0.5, 8, 0.08, 0), Color3.fromRGB(100, 100, 100), "Reset Character")
-local bodyBtn    = createButton("Body",    UDim2.new(0.75, 8, 0.08, 0), Color3.fromRGB(100, 100, 100), "Body Switch")
-
-local redHead = Instance.new("ImageLabel")
-redHead.Size = UDim2.new(0, 65, 0, 65)
-redHead.Position = UDim2.new(1, -60, 0, -25)
-redHead.BackgroundTransparency = 1
-redHead.Image = "rbxassetid://357249130"
-redHead.ImageColor3 = Color3.fromRGB(255, 0, 0)
-redHead.Parent = mainFrame
-
--- Minimize Logic
-local minimized = false
-
-local function toggleMinimize()
-    minimized = not minimized
-    mainFrame.Visible = not minimized
-    floatBtn.Visible = minimized
+local function stopFlying()
+    flying = false
+
+    if flyConnection then
+        flyConnection:Disconnect()
+        flyConnection = nil
+    end
+
+    if currentVelocity then
+        currentVelocity:Destroy()
+        currentVelocity = nil
+    end
+
+    if currentGyro then
+        currentGyro:Destroy()
+        currentGyro = nil
+    end
+
+    local _, humanoid = getCharacterParts()
+    humanoid.PlatformStand = false
+    updateGui()
 end
 
-minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
-floatBtn.MouseButton1Click:Connect(toggleMinimize)
+local function startFlying()
+    local _, humanoid, rootPart = getCharacterParts()
+    flying = true
+    humanoid.PlatformStand = true
+
+    currentVelocity = Instance.new("BodyVelocity")
+    currentVelocity.Name = "FlyVelocity"
+    currentVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
+    currentVelocity.Velocity = Vector3.zero
+    currentVelocity.Parent = rootPart
+
+    currentGyro = Instance.new("BodyGyro")
+    currentGyro.Name = "FlyGyro"
+    currentGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
+    currentGyro.P = 9000
+    currentGyro.CFrame = rootPart.CFrame
+    currentGyro.Parent = rootPart
 
--- Button Functions
-executeBtn.MouseButton1Click:Connect(function()
-    local code = scriptBox.Text
-    if code and #code > 0 then
-        local success, err = pcall(loadstring(code))
-        if not success then warn("[ranggi4561] " .. tostring(err)) end
+    flyConnection = RunService.RenderStepped:Connect(function()
+        local camera = workspace.CurrentCamera
+        local direction = Vector3.zero
+
+        if movement.Forward then direction += camera.CFrame.LookVector end
+        if movement.Backward then direction -= camera.CFrame.LookVector end
+        if movement.Right then direction += camera.CFrame.RightVector end
+        if movement.Left then direction -= camera.CFrame.RightVector end
+        if movement.Up then direction += Vector3.yAxis end
+        if movement.Down then direction -= Vector3.yAxis end
+
+        if direction.Magnitude > 0 then
+            currentVelocity.Velocity = direction.Unit * flySpeed
+        else
+            currentVelocity.Velocity = Vector3.zero
+        end
+
+        currentGyro.CFrame = camera.CFrame
+    end)
+
+    updateGui()
+end
+
+local function toggleFly()
+    if flying then
+        stopFlying()
+    else
+        startFlying()
     end
+end
+
+toggleButton.MouseButton1Click:Connect(toggleFly)
+
+fasterButton.MouseButton1Click:Connect(function()
+    flySpeed = math.clamp(flySpeed + 10, 10, 200)
+    updateGui()
+end)
+
+slowerButton.MouseButton1Click:Connect(function()
+    flySpeed = math.clamp(flySpeed - 10, 10, 200)
+    updateGui()
 end)
 
-clearBtn.MouseButton1Click:Connect(function() scriptBox.Text = "" end)
+UserInputService.InputBegan:Connect(function(input, gameProcessed)
+    if gameProcessed then return end
 
-resetBtn.MouseButton1Click:Connect(function()
-    if player.Character then player.Character:BreakJoints() end
+    if input.KeyCode == Enum.KeyCode.F then
+        toggleFly()
+    elseif input.KeyCode == Enum.KeyCode.W then
+        movement.Forward = true
+    elseif input.KeyCode == Enum.KeyCode.S then
+        movement.Backward = true
+    elseif input.KeyCode == Enum.KeyCode.A then
+        movement.Left = true
+    elseif input.KeyCode == Enum.KeyCode.D then
+        movement.Right = true
+    elseif input.KeyCode == Enum.KeyCode.Space then
+        movement.Up = true
+    elseif input.KeyCode == Enum.KeyCode.LeftControl then
+        movement.Down = true
+    end
+end)
+
+UserInputService.InputEnded:Connect(function(input)
+    if input.KeyCode == Enum.KeyCode.W then
+        movement.Forward = false
+    elseif input.KeyCode == Enum.KeyCode.S then
+        movement.Backward = false
+    elseif input.KeyCode == Enum.KeyCode.A then
+        movement.Left = false
+    elseif input.KeyCode == Enum.KeyCode.D then
+        movement.Right = false
+    elseif input.KeyCode == Enum.KeyCode.Space then
+        movement.Up = false
+    elseif input.KeyCode == Enum.KeyCode.LeftControl then
+        movement.Down = false
+    end
 end)
 
-bodyBtn.MouseButton1Click:Connect(function()
-    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
-    if hum then
-        hum.RigType = hum.RigType == Enum.HumanoidRigType.R15 and Enum.HumanoidRigType.R6 or Enum.HumanoidRigType.R15
+player.CharacterAdded:Connect(function()
+    if flying then
+        stopFlying()
     end
 end)
 
-print("ranggi4561 destroys Roblox games Executor Loaded! (Small Version)")
+updateGui()
