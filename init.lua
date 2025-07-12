local UILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Main UI Setup
UILibrary.ScreenGui = Instance.new("ScreenGui")
UILibrary.ScreenGui.Name = "UILibrary"
UILibrary.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UILibrary.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
UILibrary.MainFrame = Instance.new("Frame")
UILibrary.MainFrame.Name = "MainFrame"
UILibrary.MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
UILibrary.MainFrame.BorderSizePixel = 0
UILibrary.MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
UILibrary.MainFrame.Size = UDim2.new(0, 492, 0, 319)
UILibrary.MainFrame.Parent = UILibrary.ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = UILibrary.MainFrame

-- Tab System
UILibrary.Tabs = {}
UILibrary.CurrentTab = nil

-- Top Bar
UILibrary.TopBar = Instance.new("Frame")
UILibrary.TopBar.Name = "TopBar"
UILibrary.TopBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
UILibrary.TopBar.BorderColor3 = Color3.fromRGB(30, 30, 30)
UILibrary.TopBar.Size = UDim2.new(1, 0, 0, 41)
UILibrary.TopBar.Parent = UILibrary.MainFrame

-- Tab Button
local TabButton = Instance.new("ImageButton")
TabButton.Name = "TabButton"
TabButton.BackgroundTransparency = 1
TabButton.Position = UDim2.new(0.02, 0, 0.3, 0)
TabButton.Size = UDim2.new(0, 15, 0, 15)
TabButton.Image = "rbxassetid://11432865277"
TabButton.ImageColor3 = Color3.fromRGB(150, 150, 150)
TabButton.Parent = UILibrary.TopBar

-- Search Box
UILibrary.SearchBox = Instance.new("TextBox")
UILibrary.SearchBox.Name = "SearchBox"
UILibrary.SearchBox.BackgroundTransparency = 1
UILibrary.SearchBox.Position = UDim2.new(0.1, 0, 0.31, 0)
UILibrary.SearchBox.Size = UDim2.new(0.78, 0, 0, 19)
UILibrary.SearchBox.Font = Enum.Font.SourceSans
UILibrary.SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
UILibrary.SearchBox.PlaceholderText = "Search options.."
UILibrary.SearchBox.Text = ""
UILibrary.SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
UILibrary.SearchBox.TextSize = 14
UILibrary.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
UILibrary.SearchBox.Parent = UILibrary.TopBar

-- Close Button
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(0.95, 0, 0.32, 0)
CloseButton.Size = UDim2.new(0, 15, 0, 15)
CloseButton.Image = "rbxassetid://11293981586"
CloseButton.ImageColor3 = Color3.fromRGB(150, 150, 150)
CloseButton.Parent = UILibrary.TopBar

-- Minimize Button
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(0.9, 0, 0.32, 0)
MinimizeButton.Size = UDim2.new(0, 15, 0, 15)
MinimizeButton.Image = "rbxassetid://11293980042"
MinimizeButton.ImageColor3 = Color3.fromRGB(150, 150, 150)
MinimizeButton.Parent = UILibrary.TopBar

-- Tab Container
UILibrary.TabContainer = Instance.new("ScrollingFrame")
UILibrary.TabContainer.Name = "TabContainer"
UILibrary.TabContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
UILibrary.TabContainer.BorderSizePixel = 0
UILibrary.TabContainer.Position = UDim2.new(0, 0, 0.16, 0)
UILibrary.TabContainer.Size = UDim2.new(1, 0, 0.84, 0)
UILibrary.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
UILibrary.TabContainer.ScrollBarThickness = 3
UILibrary.TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
UILibrary.TabContainer.Parent = UILibrary.MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = UILibrary.TabContainer

-- Tab Buttons Container
UILibrary.TabButtonsContainer = Instance.new("Frame")
UILibrary.TabButtonsContainer.Name = "TabButtonsContainer"
UILibrary.TabButtonsContainer.BackgroundTransparency = 1
UILibrary.TabButtonsContainer.Size = UDim2.new(0, 150, 1, 0)
UILibrary.TabButtonsContainer.Position = UDim2.new(-0.31, 0, 0, 0)
UILibrary.TabButtonsContainer.Visible = false
UILibrary.TabButtonsContainer.Parent = UILibrary.MainFrame

local TabButtonsList = Instance.new("UIListLayout")
TabButtonsList.Padding = UDim.new(0, 5)
TabButtonsList.Parent = UILibrary.TabButtonsContainer

-- Background Effect
local BackgroundEffect = Instance.new("ImageLabel")
BackgroundEffect.Name = "BackgroundEffect"
BackgroundEffect.BackgroundTransparency = 1
BackgroundEffect.Size = UDim2.new(1.1, 0, 1.1, 0)
BackgroundEffect.Position = UDim2.new(-0.05, 0, -0.05, 0)
BackgroundEffect.Image = "rbxassetid://6014261993"
BackgroundEffect.ImageColor3 = Color3.fromRGB(24, 24, 24)
BackgroundEffect.ImageTransparency = 0.6
BackgroundEffect.ZIndex = -1
BackgroundEffect.Parent = UILibrary.MainFrame

-- Draggable functionality
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    UILibrary.MainFrame.Position = newPos
end

UILibrary.TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = UILibrary.MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UILibrary.TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Button animations
local function buttonHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(5, 5, 5)}):Play()
    end)
end

-- Close and minimize functionality
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(UILibrary.MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 492, 0, 0)}):Play()
    wait(0.2)
    UILibrary.ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    if UILibrary.TabContainer.Visible then
        TweenService:Create(UILibrary.MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 492, 0, 41)}):Play()
        UILibrary.TabContainer.Visible = false
    else
        TweenService:Create(UILibrary.MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 492, 0, 319)}):Play()
        UILibrary.TabContainer.Visible = true
    end
end)

-- Tab button functionality
TabButton.MouseButton1Click:Connect(function()
    UILibrary.TabButtonsContainer.Visible = not UILibrary.TabButtonsContainer.Visible
    if UILibrary.TabButtonsContainer.Visible then
        TweenService:Create(UILibrary.TabButtonsContainer, TweenInfo.new(0.2), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    else
        TweenService:Create(UILibrary.TabButtonsContainer, TweenInfo.new(0.2), {Position = UDim2.new(-0.31, 0, 0, 0)}):Play()
    end
end)

-- Create a new tab
function UILibrary:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    
    -- Tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "TabButton"
    tabButton.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    tabButton.BorderColor3 = Color3.fromRGB(30, 30, 30)
    tabButton.Size = UDim2.new(1, -10, 0, 41)
    tabButton.Text = ""
    tabButton.Parent = UILibrary.TabButtonsContainer
    
    local tabButtonCorner = Instance.new("UICorner")
    tabButtonCorner.CornerRadius = UDim.new(0, 4)
    tabButtonCorner.Parent = tabButton
    
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Name = "Icon"
    tabIcon.BackgroundTransparency = 1
    tabIcon.Position = UDim2.new(0, 5, 0.24, 0)
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Image = icon or "rbxassetid://12967526257"
    tabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    tabIcon.Parent = tabButton
    
    local tabName = Instance.new("TextLabel")
    tabName.Name = "Name"
    tabName.BackgroundTransparency = 1
    tabName.Position = UDim2.new(0.21, 0, 0, 0)
    tabName.Size = UDim2.new(0.79, 0, 1, 0)
    tabName.Font = Enum.Font.SourceSansBold
    tabName.Text = name
    tabName.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabName.TextSize = 15
    tabName.TextXAlignment = Enum.TextXAlignment.Left
    tabName.Parent = tabButton
    
    -- Tab content frame
    tab.Frame = Instance.new("ScrollingFrame")
    tab.Frame.Name = name .. "Frame"
    tab.Frame.BackgroundTransparency = 1
    tab.Frame.Size = UDim2.new(1, 0, 1, 0)
    tab.Frame.Visible = false
    tab.Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Frame.ScrollBarThickness = 3
    tab.Frame.Parent = UILibrary.TabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tab.Frame
    
    -- Set as current tab if first tab
    if #UILibrary.Tabs == 0 then
        UILibrary:SwitchTab(tab)
    end
    
    -- Button click event
    tabButton.MouseButton1Click:Connect(function()
        UILibrary:SwitchTab(tab)
    end)
    
    -- Hover effect
    buttonHoverEffect(tabButton)
    
    table.insert(UILibrary.Tabs, tab)
    return tab
end

-- Switch between tabs
function UILibrary:SwitchTab(tab)
    if self.CurrentTab then
        self.CurrentTab.Frame.Visible = false
    end
    
    self.CurrentTab = tab
    tab.Frame.Visible = true
    
    -- Close tab buttons container
    UILibrary.TabButtonsContainer.Visible = false
    UILibrary.TabButtonsContainer.Position = UDim2.new(-0.31, 0, 0, 0)
end

-- Create a button
function UILibrary:CreateButton(tab, name, description, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    button.BorderColor3 = Color3.fromRGB(30, 30, 30)
    button.Size = UDim2.new(1, -20, 0, 42)
    button.Text = ""
    button.Parent = tab.Frame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    local buttonName = Instance.new("TextLabel")
    buttonName.Name = "Name"
    buttonName.BackgroundTransparency = 1
    buttonName.Position = UDim2.new(0.02, 0, 0.08, 0)
    buttonName.Size = UDim2.new(0.88, 0, 0.35, 0)
    buttonName.Font = Enum.Font.SourceSansBold
    buttonName.Text = name
    buttonName.TextColor3 = Color3.fromRGB(150, 150, 150)
    buttonName.TextSize = 14
    buttonName.TextXAlignment = Enum.TextXAlignment.Left
    buttonName.TextYAlignment = Enum.TextYAlignment.Top
    buttonName.Parent = button
    
    local buttonDesc = Instance.new("TextLabel")
    buttonDesc.Name = "Description"
    buttonDesc.BackgroundTransparency = 1
    buttonDesc.Position = UDim2.new(0.02, 0, 0.46, 0)
    buttonDesc.Size = UDim2.new(0.63, 0, 0.33, 0)
    buttonDesc.Font = Enum.Font.SourceSansSemibold
    buttonDesc.Text = description
    buttonDesc.TextColor3 = Color3.fromRGB(130, 130, 130)
    buttonDesc.TextSize = 12
    buttonDesc.TextWrapped = true
    buttonDesc.TextXAlignment = Enum.TextXAlignment.Left
    buttonDesc.TextYAlignment = Enum.TextYAlignment.Top
    buttonDesc.Parent = button
    
    local buttonIcon = Instance.new("ImageLabel")
    buttonIcon.Name = "Icon"
    buttonIcon.BackgroundTransparency = 1
    buttonIcon.Position = UDim2.new(0.92, 0, 0.23, 0)
    buttonIcon.Size = UDim2.new(0, 20, 0, 20)
    buttonIcon.Image = "rbxassetid://12974400533"
    buttonIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    buttonIcon.Parent = button
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    -- Hover effect
    buttonHoverEffect(button)
    
    return button
end

-- Create a toggle
function UILibrary:CreateToggle(tab, name, description, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    toggleFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Parent = tab.Frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleFrame
    
    local toggleName = Instance.new("TextLabel")
    toggleName.Name = "Name"
    toggleName.BackgroundTransparency = 1
    toggleName.Position = UDim2.new(0.02, 0, 0.24, 0)
    toggleName.Size = UDim2.new(0.62, 0, 0.25, 0)
    toggleName.Font = Enum.Font.SourceSansBold
    toggleName.Text = name
    toggleName.TextColor3 = Color3.fromRGB(150, 150, 150)
    toggleName.TextSize = 14
    toggleName.TextXAlignment = Enum.TextXAlignment.Left
    toggleName.Parent = toggleFrame
    
    local toggleDesc = Instance.new("TextLabel")
    toggleDesc.Name = "Description"
    toggleDesc.BackgroundTransparency = 1
    toggleDesc.Position = UDim2.new(0.02, 0, 0.41, 0)
    toggleDesc.Size = UDim2.new(0.63, 0, 0.14, 0)
    toggleDesc.Font = Enum.Font.SourceSansSemibold
    toggleDesc.Text = description
    toggleDesc.TextColor3 = Color3.fromRGB(130, 130, 130)
    toggleDesc.TextSize = 12
    toggleDesc.TextWrapped = true
    toggleDesc.TextXAlignment = Enum.TextXAlignment.Left
    toggleDesc.Parent = toggleFrame
    
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "ToggleSwitch"
    toggleSwitch.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    toggleSwitch.Position = UDim2.new(0.87, 0, 0.28, 0)
    toggleSwitch.Size = UDim2.new(0, 40, 0, 22)
    toggleSwitch.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch
    
    local toggleCircle = Instance.new("ImageLabel")
    toggleCircle.Name = "Circle"
    toggleCircle.BackgroundTransparency = 1
    toggleCircle.Position = UDim2.new(0, 1, 0.045, 0)
    toggleCircle.Size = UDim2.new(0, 19, 0, 19)
    toggleCircle.Image = "rbxassetid://6755657357"
    toggleCircle.Parent = toggleSwitch
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Button"
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Text = ""
    toggleButton.Parent = toggleSwitch
    
    local state = default or false
    
    local function updateToggle()
        if state then
            TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 170, 255)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.045, 0)}):Play()
        else
            TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(230, 230, 230)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 1, 0.045, 0)}):Play()
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if callback then
            callback(state)
        end
    end)
    
    updateToggle()
    
    -- Hover effect
    buttonHoverEffect(toggleFrame)
    
    return {
        SetState = function(newState)
            state = newState
            updateToggle()
        end,
        GetState = function()
            return state
        end
    }
end

-- Create a slider
function UILibrary:CreateSlider(tab, name, description, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    sliderFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.Parent = tab.Frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderFrame
    
    local sliderName = Instance.new("TextLabel")
    sliderName.Name = "Name"
    sliderName.BackgroundTransparency = 1
    sliderName.Position = UDim2.new(0.02, 0, 0.08, 0)
    sliderName.Size = UDim2.new(0.88, 0, 0.29, 0)
    sliderName.Font = Enum.Font.SourceSansBold
    sliderName.Text = name
    sliderName.TextColor3 = Color3.fromRGB(150, 150, 150)
    sliderName.TextSize = 14
    sliderName.TextXAlignment = Enum.TextXAlignment.Left
    sliderName.Parent = sliderFrame
    
    local sliderDesc = Instance.new("TextLabel")
    sliderDesc.Name = "Description"
    sliderDesc.BackgroundTransparency = 1
    sliderDesc.Position = UDim2.new(0.02, 0, 0.29, 0)
    sliderDesc.Size = UDim2.new(0.63, 0, 0.14, 0)
    sliderDesc.Font = Enum.Font.SourceSansSemibold
    sliderDesc.Text = description
    sliderDesc.TextColor3 = Color3.fromRGB(130, 130, 130)
    sliderDesc.TextSize = 12
    sliderDesc.TextWrapped = true
    sliderDesc.TextXAlignment = Enum.TextXAlignment.Left
    sliderDesc.Parent = sliderFrame
    
    local sliderValue = Instance.new("TextLabel")
    sliderValue.Name = "Value"
    sliderValue.BackgroundTransparency = 1
    sliderValue.Position = UDim2.new(0.92, 0, 0.31, 0)
    sliderValue.Size = UDim2.new(0, 30, 0, 20)
    sliderValue.Font = Enum.Font.SourceSansBold
    sliderValue.Text = tostring(default or min)
    sliderValue.TextColor3 = Color3.fromRGB(150, 150, 150)
    sliderValue.TextSize = 14
    sliderValue.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderBar.Position = UDim2.new(0.02, 0, 0.7, 0)
    sliderBar.Size = UDim2.new(0.96, 0, 0, 4)
    sliderBar.Parent = sliderFrame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Parent = sliderBar
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.BackgroundTransparency = 1
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.Text = ""
    sliderButton.Parent = sliderFrame
    
    local minValue = min or 0
    local maxValue = max or 100
    local currentValue = default or minValue
    
    local function updateSlider(value)
        currentValue = math.clamp(value, minValue, maxValue)
        local percent = (currentValue - minValue) / (maxValue - minValue)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderValue.Text = tostring(math.floor(currentValue))
        
        if callback then
            callback(currentValue)
        end
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                percent = math.clamp(percent, 0, 1)
                local value = minValue + (maxValue - minValue) * percent
                updateSlider(value)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    
    updateSlider(currentValue)
    
    -- Hover effect
    buttonHoverEffect(sliderFrame)
    
    return {
        SetValue = function(value)
            updateSlider(value)
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- Create a label
function UILibrary:CreateLabel(tab, text, description)
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "Label"
    labelFrame.BackgroundTransparency = 1
    labelFrame.Size = UDim2.new(1, -20, 0, description and 50 or 30)
    labelFrame.Parent = tab.Frame
    
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Text"
    labelText.BackgroundTransparency = 1
    labelText.Position = UDim2.new(0.02, 0, 0, 0)
    labelText.Size = UDim2.new(0.98, 0, description and 0.5 or 1, 0)
    labelText.Font = Enum.Font.SourceSansBold
    labelText.Text = text
    labelText.TextColor3 = Color3.fromRGB(150, 150, 150)
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = labelFrame
    
    if description then
        local labelDesc = Instance.new("TextLabel")
        labelDesc.Name = "Description"
        labelDesc.BackgroundTransparency = 1
        labelDesc.Position = UDim2.new(0.02, 0, 0.5, 0)
        labelDesc.Size = UDim2.new(0.98, 0, 0.5, 0)
        labelDesc.Font = Enum.Font.SourceSansSemibold
        labelDesc.Text = description
        labelDesc.TextColor3 = Color3.fromRGB(130, 130, 130)
        labelDesc.TextSize = 12
        labelDesc.TextXAlignment = Enum.TextXAlignment.Left
        labelDesc.Parent = labelFrame
    end
    
    return labelFrame
end

-- Toggle UI visibility
function UILibrary:Toggle()
    UILibrary.ScreenGui.Enabled = not UILibrary.ScreenGui.Enabled
end

return UILibrary
