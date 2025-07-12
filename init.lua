local UILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Configuration
local CONFIG = {
    MAIN_COLOR = Color3.fromRGB(18, 18, 18),
    SECONDARY_COLOR = Color3.fromRGB(25, 25, 25),
    ACCENT_COLOR = Color3.fromRGB(100, 150, 255),
    TEXT_COLOR = Color3.fromRGB(220, 220, 220),
    SECONDARY_TEXT_COLOR = Color3.fromRGB(150, 150, 150),
    BORDER_COLOR = Color3.fromRGB(45, 45, 45),
    HOVER_COLOR = Color3.fromRGB(35, 35, 35),
    CORNER_RADIUS = 8,
    ANIMATION_SPEED = 0.25
}

-- Utility Functions
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or CONFIG.CORNER_RADIUS)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CONFIG.BORDER_COLOR
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function createPadding(parent, padding)
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, padding or 10)
    uiPadding.PaddingBottom = UDim.new(0, padding or 10)
    uiPadding.PaddingLeft = UDim.new(0, padding or 10)
    uiPadding.PaddingRight = UDim.new(0, padding or 10)
    uiPadding.Parent = parent
    return uiPadding
end

local function animateHover(element, hoverColor, normalColor)
    local hovering = false
    
    element.MouseEnter:Connect(function()
        hovering = true
        TweenService:Create(element, TweenInfo.new(CONFIG.ANIMATION_SPEED/2), {
            BackgroundColor3 = hoverColor or CONFIG.HOVER_COLOR
        }):Play()
    end)
    
    element.MouseLeave:Connect(function()
        hovering = false
        TweenService:Create(element, TweenInfo.new(CONFIG.ANIMATION_SPEED/2), {
            BackgroundColor3 = normalColor or CONFIG.SECONDARY_COLOR
        }):Play()
    end)
    
    return hovering
end

local function createRippleEffect(button)
    button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.8
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.ZIndex = button.ZIndex + 1
        createCorner(ripple, CONFIG.CORNER_RADIUS)
        ripple.Parent = button
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        local expandTween = TweenService:Create(ripple, TweenInfo.new(0.5), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        })
        
        expandTween:Play()
        expandTween.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

-- Main UI Setup
UILibrary.ScreenGui = Instance.new("ScreenGui")
UILibrary.ScreenGui.Name = "ModernUILibrary"
UILibrary.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UILibrary.ScreenGui.ResetOnSpawn = false
UILibrary.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
UILibrary.MainFrame = Instance.new("Frame")
UILibrary.MainFrame.Name = "MainFrame"
UILibrary.MainFrame.BackgroundColor3 = CONFIG.MAIN_COLOR
UILibrary.MainFrame.BorderSizePixel = 0
UILibrary.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
UILibrary.MainFrame.Size = UDim2.new(0, 600, 0, 400)
UILibrary.MainFrame.ClipsDescendants = true
UILibrary.MainFrame.Parent = UILibrary.ScreenGui

createCorner(UILibrary.MainFrame, CONFIG.CORNER_RADIUS)
createStroke(UILibrary.MainFrame, CONFIG.BORDER_COLOR, 1)

-- Drop Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.ZIndex = UILibrary.MainFrame.ZIndex - 1
shadow.Parent = UILibrary.MainFrame

-- Title Bar
UILibrary.TitleBar = Instance.new("Frame")
UILibrary.TitleBar.Name = "TitleBar"
UILibrary.TitleBar.BackgroundColor3 = CONFIG.SECONDARY_COLOR
UILibrary.TitleBar.BorderSizePixel = 0
UILibrary.TitleBar.Size = UDim2.new(1, 0, 0, 50)
UILibrary.TitleBar.Parent = UILibrary.MainFrame

createCorner(UILibrary.TitleBar, CONFIG.CORNER_RADIUS)

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 15, 0, 0)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "Modern UI Library"
title.TextColor3 = CONFIG.TEXT_COLOR
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = UILibrary.TitleBar

-- Control Buttons
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "Controls"
controlsFrame.BackgroundTransparency = 1
controlsFrame.Position = UDim2.new(1, -120, 0, 0)
controlsFrame.Size = UDim2.new(0, 120, 1, 0)
controlsFrame.Parent = UILibrary.TitleBar

local controlsLayout = Instance.new("UIListLayout")
controlsLayout.FillDirection = Enum.FillDirection.Horizontal
controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
controlsLayout.Padding = UDim.new(0, 10)
controlsLayout.Parent = controlsFrame

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.BackgroundColor3 = CONFIG.SECONDARY_COLOR
minimizeButton.BorderSizePixel = 0
minimizeButton.Size = UDim2.new(0, 35, 0, 30)
minimizeButton.Text = "−"
minimizeButton.TextColor3 = CONFIG.TEXT_COLOR
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = controlsFrame

createCorner(minimizeButton, 4)
animateHover(minimizeButton)
createRippleEffect(minimizeButton)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Size = UDim2.new(0, 35, 0, 30)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = controlsFrame

createCorner(closeButton, 4)
animateHover(closeButton, Color3.fromRGB(255, 70, 70), Color3.fromRGB(220, 50, 50))
createRippleEffect(closeButton)

-- Content Area
UILibrary.ContentArea = Instance.new("Frame")
UILibrary.ContentArea.Name = "ContentArea"
UILibrary.ContentArea.BackgroundTransparency = 1
UILibrary.ContentArea.Position = UDim2.new(0, 0, 0, 50)
UILibrary.ContentArea.Size = UDim2.new(1, 0, 1, -50)
UILibrary.ContentArea.Parent = UILibrary.MainFrame

-- Tab System
UILibrary.TabBar = Instance.new("Frame")
UILibrary.TabBar.Name = "TabBar"
UILibrary.TabBar.BackgroundColor3 = CONFIG.SECONDARY_COLOR
UILibrary.TabBar.BorderSizePixel = 0
UILibrary.TabBar.Size = UDim2.new(0, 200, 1, 0)
UILibrary.TabBar.Parent = UILibrary.ContentArea

createStroke(UILibrary.TabBar, CONFIG.BORDER_COLOR, 1)

local tabBarLayout = Instance.new("UIListLayout")
tabBarLayout.Padding = UDim.new(0, 5)
tabBarLayout.Parent = UILibrary.TabBar

createPadding(UILibrary.TabBar, 10)

-- Tab Content
UILibrary.TabContent = Instance.new("Frame")
UILibrary.TabContent.Name = "TabContent"
UILibrary.TabContent.BackgroundTransparency = 1
UILibrary.TabContent.Position = UDim2.new(0, 200, 0, 0)
UILibrary.TabContent.Size = UDim2.new(1, -200, 1, 0)
UILibrary.TabContent.Parent = UILibrary.ContentArea

-- Tab Management
UILibrary.Tabs = {}
UILibrary.CurrentTab = nil

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    UILibrary.MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

UILibrary.TitleBar.InputBegan:Connect(function(input)
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

UILibrary.TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Control button functionality
local isMinimized = false

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(UILibrary.MainFrame, TweenInfo.new(CONFIG.ANIMATION_SPEED), {
            Size = UDim2.new(0, 600, 0, 50)
        }):Play()
        UILibrary.ContentArea.Visible = false
        minimizeButton.Text = "□"
    else
        TweenService:Create(UILibrary.MainFrame, TweenInfo.new(CONFIG.ANIMATION_SPEED), {
            Size = UDim2.new(0, 600, 0, 400)
        }):Play()
        UILibrary.ContentArea.Visible = true
        minimizeButton.Text = "−"
    end
end)

closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(UILibrary.MainFrame, TweenInfo.new(CONFIG.ANIMATION_SPEED), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        UILibrary.ScreenGui:Destroy()
    end)
end)

-- Create Tab Function
function UILibrary:CreateTab(name, icon)
    local tab = {
        Name = name,
        Icon = icon or "rbxassetid://6031075931",
        Elements = {}
    }
    
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    tabButton.BorderSizePixel = 0
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Text = ""
    tabButton.Parent = UILibrary.TabBar
    
    createCorner(tabButton, 6)
    animateHover(tabButton)
    createRippleEffect(tabButton)
    
    -- Tab Icon
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Name = "Icon"
    tabIcon.BackgroundTransparency = 1
    tabIcon.Position = UDim2.new(0, 10, 0.5, -10)
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Image = tab.Icon
    tabIcon.ImageColor3 = CONFIG.SECONDARY_TEXT_COLOR
    tabIcon.Parent = tabButton
    
    -- Tab Name
    local tabName = Instance.new("TextLabel")
    tabName.Name = "Name"
    tabName.BackgroundTransparency = 1
    tabName.Position = UDim2.new(0, 40, 0, 0)
    tabName.Size = UDim2.new(1, -50, 1, 0)
    tabName.Font = Enum.Font.Gotham
    tabName.Text = name
    tabName.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
    tabName.TextSize = 14
    tabName.TextXAlignment = Enum.TextXAlignment.Left
    tabName.Parent = tabButton
    
    -- Tab Content Frame
    tab.Frame = Instance.new("ScrollingFrame")
    tab.Frame.Name = name .. "Content"
    tab.Frame.BackgroundTransparency = 1
    tab.Frame.Size = UDim2.new(1, 0, 1, 0)
    tab.Frame.ScrollBarThickness = 4
    tab.Frame.ScrollBarImageColor3 = CONFIG.ACCENT_COLOR
    tab.Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Frame.Visible = false
    tab.Frame.Parent = UILibrary.TabContent
    
    createPadding(tab.Frame, 15)
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tab.Frame
    
    -- Tab Selection
    tabButton.MouseButton1Click:Connect(function()
        UILibrary:SelectTab(tab)
    end)
    
    -- Select first tab by default
    if #UILibrary.Tabs == 0 then
        UILibrary:SelectTab(tab)
    end
    
    table.insert(UILibrary.Tabs, tab)
    return tab
end

-- Select Tab Function
function UILibrary:SelectTab(tab)
    -- Hide all tabs
    for _, t in pairs(UILibrary.Tabs) do
        t.Frame.Visible = false
        -- Reset tab button colors
        local tabButton = UILibrary.TabBar:FindFirstChild(t.Name .. "Tab")
        if tabButton then
            tabButton.BackgroundColor3 = CONFIG.SECONDARY_COLOR
            tabButton.Icon.ImageColor3 = CONFIG.SECONDARY_TEXT_COLOR
            tabButton.Name.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
        end
    end
    
    -- Show selected tab
    tab.Frame.Visible = true
    UILibrary.CurrentTab = tab
    
    -- Highlight selected tab
    local selectedButton = UILibrary.TabBar:FindFirstChild(tab.Name .. "Tab")
    if selectedButton then
        selectedButton.BackgroundColor3 = CONFIG.ACCENT_COLOR
        selectedButton.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        selectedButton.Name.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Create Button Function
function UILibrary:CreateButton(tab, name, description, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Text = ""
    button.Parent = tab.Frame
    
    createCorner(button, 6)
    createStroke(button, CONFIG.BORDER_COLOR, 1)
    animateHover(button)
    createRippleEffect(button)
    
    -- Button Content
    local buttonName = Instance.new("TextLabel")
    buttonName.Name = "Name"
    buttonName.BackgroundTransparency = 1
    buttonName.Position = UDim2.new(0, 15, 0, 8)
    buttonName.Size = UDim2.new(1, -30, 0, 20)
    buttonName.Font = Enum.Font.GothamBold
    buttonName.Text = name
    buttonName.TextColor3 = CONFIG.TEXT_COLOR
    buttonName.TextSize = 14
    buttonName.TextXAlignment = Enum.TextXAlignment.Left
    buttonName.Parent = button
    
    if description then
        local buttonDesc = Instance.new("TextLabel")
        buttonDesc.Name = "Description"
        buttonDesc.BackgroundTransparency = 1
        buttonDesc.Position = UDim2.new(0, 15, 0, 26)
        buttonDesc.Size = UDim2.new(1, -30, 0, 16)
        buttonDesc.Font = Enum.Font.Gotham
        buttonDesc.Text = description
        buttonDesc.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
        buttonDesc.TextSize = 12
        buttonDesc.TextXAlignment = Enum.TextXAlignment.Left
        buttonDesc.Parent = button
    end
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    table.insert(tab.Elements, button)
    return button
end

-- Create Toggle Function
function UILibrary:CreateToggle(tab, name, description, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Size = UDim2.new(1, 0, 0, 60)
    toggleFrame.Parent = tab.Frame
    
    createCorner(toggleFrame, 6)
    createStroke(toggleFrame, CONFIG.BORDER_COLOR, 1)
    animateHover(toggleFrame)
    
    -- Toggle Content
    local toggleName = Instance.new("TextLabel")
    toggleName.Name = "Name"
    toggleName.BackgroundTransparency = 1
    toggleName.Position = UDim2.new(0, 15, 0, 8)
    toggleName.Size = UDim2.new(0.7, 0, 0, 20)
    toggleName.Font = Enum.Font.GothamBold
    toggleName.Text = name
    toggleName.TextColor3 = CONFIG.TEXT_COLOR
    toggleName.TextSize = 14
    toggleName.TextXAlignment = Enum.TextXAlignment.Left
    toggleName.Parent = toggleFrame
    
    if description then
        local toggleDesc = Instance.new("TextLabel")
        toggleDesc.Name = "Description"
        toggleDesc.BackgroundTransparency = 1
        toggleDesc.Position = UDim2.new(0, 15, 0, 26)
        toggleDesc.Size = UDim2.new(0.7, 0, 0, 16)
        toggleDesc.Font = Enum.Font.Gotham
        toggleDesc.Text = description
        toggleDesc.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
        toggleDesc.TextSize = 12
        toggleDesc.TextXAlignment = Enum.TextXAlignment.Left
        toggleDesc.Parent = toggleFrame
    end
    
    -- Toggle Switch
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Name = "Switch"
    toggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleSwitch.Position = UDim2.new(1, -60, 0.5, -12)
    toggleSwitch.Size = UDim2.new(0, 50, 0, 24)
    toggleSwitch.Parent = toggleFrame
    
    createCorner(toggleSwitch, 12)
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Parent = toggleSwitch
    
    createCorner(toggleCircle, 10)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Button"
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Text = ""
    toggleButton.Parent = toggleSwitch
    
    local state = default or false
    
    local function updateToggle()
        if state then
            TweenService:Create(toggleSwitch, TweenInfo.new(CONFIG.ANIMATION_SPEED), {
                BackgroundColor3 = CONFIG.ACCENT_COLOR
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(CONFIG.ANIMATION_SPEED), {
                Position = UDim2.new(1, -22, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(toggleSwitch, TweenInfo.new(CONFIG.ANIMATION_SPEED), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            }):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(CONFIG.ANIMATION_SPEED), {
                Position = UDim2.new(0, 2, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
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
    
    table.insert(tab.Elements, toggleFrame)
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

-- Create Slider Function
function UILibrary:CreateSlider(tab, name, description, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Size = UDim2.new(1, 0, 0, 70)
    sliderFrame.Parent = tab.Frame
    
    createCorner(sliderFrame, 6)
    createStroke(sliderFrame, CONFIG.BORDER_COLOR, 1)
    animateHover(sliderFrame)
    
    -- Slider Content
    local sliderName = Instance.new("TextLabel")
    sliderName.Name = "Name"
    sliderName.BackgroundTransparency = 1
    sliderName.Position = UDim2.new(0, 15, 0, 8)
    sliderName.Size = UDim2.new(0.7, 0, 0, 20)
    sliderName.Font = Enum.Font.GothamBold
    sliderName.Text = name
    sliderName.TextColor3 = CONFIG.TEXT_COLOR
    sliderName.TextSize = 14
    sliderName.TextXAlignment = Enum.TextXAlignment.Left
    sliderName.Parent = sliderFrame
    
    local sliderValue = Instance.new("TextLabel")
    sliderValue.Name = "Value"
    sliderValue.BackgroundTransparency = 1
    sliderValue.Position = UDim2.new(1, -60, 0, 8)
    sliderValue.Size = UDim2.new(0, 50, 0, 20)
    sliderValue.Font = Enum.Font.GothamBold
    sliderValue.Text = tostring(default or min)
    sliderValue.TextColor3 = CONFIG.ACCENT_COLOR
    sliderValue.TextSize = 14
    sliderValue.TextXAlignment = Enum.TextXAlignment.Right
    sliderValue.Parent = sliderFrame
    
    if description then
        local sliderDesc = Instance.new("TextLabel")
        sliderDesc.Name = "Description"
        sliderDesc.BackgroundTransparency = 1
        sliderDesc.Position = UDim2.new(0, 15, 0, 26)
        sliderDesc.Size = UDim2.new(1, -30, 0, 16)
        sliderDesc.Font = Enum.Font.Gotham
        sliderDesc.Text = description
        sliderDesc.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
        sliderDesc.TextSize = 12
        sliderDesc.TextXAlignment = Enum.TextXAlignment.Left
        sliderDesc.Parent = sliderFrame
    end
    
    -- Slider Track
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderTrack.Position = UDim2.new(0, 15, 1, -15)
    sliderTrack.Size = UDim2.new(1, -30, 0, 6)
    sliderTrack.Parent = sliderFrame
    
    createCorner(sliderTrack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.BackgroundColor3 = CONFIG.ACCENT_COLOR
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Parent = sliderTrack
    
    createCorner(sliderFill, 3)
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "Handle"
    sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderHandle.Position = UDim2.new(0, -8, 0.5, -8)
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Parent = sliderFill
    
    createCorner(sliderHandle, 8)
    
    -- Slider Logic
    local minValue = min or 0
    local maxValue = max or 100
    local currentValue = default or minValue
    local dragging = false
    
    local function updateSlider(value)
        currentValue = math.clamp(value, minValue, maxValue)
        local percent = (currentValue - minValue) / (maxValue - minValue)
        
        TweenService:Create(sliderFill, TweenInfo.new(0.1), {
            Size = UDim2.new(percent, 0, 1, 0)
        }):Play()
        
        sliderValue.Text = tostring(math.floor(currentValue))
        
        if callback then
            callback(currentValue)
        end
    end
    
    local function onInput(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local percent = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local value = minValue + (maxValue - minValue) * percent
            updateSlider(value)
        end
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            onInput(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            onInput(input)
        end
    end)
    
    -- Initialize slider
    updateSlider(currentValue)
    
    table.insert(tab.Elements, sliderFrame)
    return {
        SetValue = function(value)
            updateSlider(value)
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- Create Dropdown Function
function UILibrary:CreateDropdown(tab, name, description, options, default, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = name .. "Dropdown"
    dropdownFrame.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
    dropdownFrame.Parent = tab.Frame
    
    createCorner(dropdownFrame, 6)
    createStroke(dropdownFrame, CONFIG.BORDER_COLOR, 1)
    animateHover(dropdownFrame)
    
    -- Dropdown Content
    local dropdownName = Instance.new("TextLabel")
    dropdownName.Name = "Name"
    dropdownName.BackgroundTransparency = 1
    dropdownName.Position = UDim2.new(0, 15, 0, 8)
    dropdownName.Size = UDim2.new(0.7, 0, 0, 20)
    dropdownName.Font = Enum.Font.GothamBold
    dropdownName.Text = name
    dropdownName.TextColor3 = CONFIG.TEXT_COLOR
    dropdownName.TextSize = 14
    dropdownName.TextXAlignment = Enum.TextXAlignment.Left
    dropdownName.Parent = dropdownFrame
    
    if description then
        local dropdownDesc = Instance.new("TextLabel")
        dropdownDesc.Name = "Description"
        dropdownDesc.BackgroundTransparency = 1
        dropdownDesc.Position = UDim2.new(0, 15, 0, 26)
        dropdownDesc.Size = UDim2.new(0.7, 0, 0, 16)
        dropdownDesc.Font = Enum.Font.Gotham
        dropdownDesc.Text = description
        dropdownDesc.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
        dropdownDesc.TextSize = 12
        dropdownDesc.TextXAlignment = Enum.TextXAlignment.Left
        dropdownDesc.Parent = dropdownFrame
    end
    
    -- Dropdown Button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "Button"
    dropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownButton.Position = UDim2.new(1, -150, 0.5, -15)
    dropdownButton.Size = UDim2.new(0, 140, 0, 30)
    dropdownButton.Text = default or (options[1] or "Select...")
    dropdownButton.TextColor3 = CONFIG.TEXT_COLOR
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    createCorner(dropdownButton, 4)
    animateHover(dropdownButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(40, 40, 40))
    
    -- Dropdown Arrow
    local dropdownArrow = Instance.new("TextLabel")
    dropdownArrow.Name = "Arrow"
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Position = UDim2.new(1, -25, 0, 0)
    dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
    dropdownArrow.TextSize = 10
    dropdownArrow.Font = Enum.Font.Gotham
    dropdownArrow.Parent = dropdownButton
    
    -- Dropdown List
    local dropdownList = Instance.new("Frame")
    dropdownList.Name = "List"
    dropdownList.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    dropdownList.Position = UDim2.new(1, -150, 1, 5)
    dropdownList.Size = UDim2.new(0, 140, 0, 0)
    dropdownList.Visible = false
    dropdownList.ZIndex = dropdownFrame.ZIndex + 1
    dropdownList.Parent = dropdownFrame
    
    createCorner(dropdownList, 4)
    createStroke(dropdownList, CONFIG.BORDER_COLOR, 1)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropdownList
    
    local currentValue = default or options[1]
    local isOpen = false
    
    -- Create options
    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        optionButton.BackgroundTransparency = 1
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Text = option
        optionButton.TextColor3 = CONFIG.TEXT_COLOR
        optionButton.TextSize = 12
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = dropdownList
        
        animateHover(optionButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(0, 0, 0))
        
        optionButton.MouseButton1Click:Connect(function()
            currentValue = option
            dropdownButton.Text = option
            isOpen = false
            dropdownList.Visible = false
            dropdownArrow.Text = "▼"
            
            if callback then
                callback(option)
            end
        end)
    end
    
    -- Update dropdown size
    dropdownList.Size = UDim2.new(0, 140, 0, #options * 30)
    
    -- Toggle dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        dropdownList.Visible = isOpen
        dropdownArrow.Text = isOpen and "▲" or "▼"
    end)
    
    table.insert(tab.Elements, dropdownFrame)
    return {
        SetValue = function(value)
            if table.find(options, value) then
                currentValue = value
                dropdownButton.Text = value
            end
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- Create Input Function
function UILibrary:CreateInput(tab, name, description, placeholder, callback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = name .. "Input"
    inputFrame.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    inputFrame.BorderSizePixel = 0
    inputFrame.Size = UDim2.new(1, 0, 0, 60)
    inputFrame.Parent = tab.Frame
    
    createCorner(inputFrame, 6)
    createStroke(inputFrame, CONFIG.BORDER_COLOR, 1)
    animateHover(inputFrame)
    
    -- Input Content
    local inputName = Instance.new("TextLabel")
    inputName.Name = "Name"
    inputName.BackgroundTransparency = 1
    inputName.Position = UDim2.new(0, 15, 0, 8)
    inputName.Size = UDim2.new(0.7, 0, 0, 20)
    inputName.Font = Enum.Font.GothamBold
    inputName.Text = name
    inputName.TextColor3 = CONFIG.TEXT_COLOR
    inputName.TextSize = 14
    inputName.TextXAlignment = Enum.TextXAlignment.Left
    inputName.Parent = inputFrame
    
    if description then
        local inputDesc = Instance.new("TextLabel")
        inputDesc.Name = "Description"
        inputDesc.BackgroundTransparency = 1
        inputDesc.Position = UDim2.new(0, 15, 0, 26)
        inputDesc.Size = UDim2.new(0.7, 0, 0, 16)
        inputDesc.Font = Enum.Font.Gotham
        inputDesc.Text = description
        inputDesc.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
        inputDesc.TextSize = 12
        inputDesc.TextXAlignment = Enum.TextXAlignment.Left
        inputDesc.Parent = inputFrame
    end
    
    -- Input Box
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "TextBox"
    inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    inputBox.Position = UDim2.new(1, -150, 0.5, -15)
    inputBox.Size = UDim2.new(0, 140, 0, 30)
    inputBox.PlaceholderText = placeholder or "Enter text..."
    inputBox.PlaceholderColor3 = CONFIG.SECONDARY_TEXT_COLOR
    inputBox.Text = ""
    inputBox.TextColor3 = CONFIG.TEXT_COLOR
    inputBox.TextSize = 12
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputFrame
    
    createCorner(inputBox, 4)
    createStroke(inputBox, CONFIG.BORDER_COLOR, 1)
    
    -- Input events
    inputBox.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(inputBox.Text)
        end
    end)
    
    table.insert(tab.Elements, inputFrame)
    return {
        SetText = function(text)
            inputBox.Text = text
        end,
        GetText = function()
            return inputBox.Text
        end
    }
end

-- Create Label Function
function UILibrary:CreateLabel(tab, text, color)
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "Label"
    labelFrame.BackgroundTransparency = 1
    labelFrame.Size = UDim2.new(1, 0, 0, 30)
    labelFrame.Parent = tab.Frame
    
    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color or CONFIG.TEXT_COLOR
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = labelFrame
    
    table.insert(tab.Elements, labelFrame)
    return {
        SetText = function(newText)
            label.Text = newText
        end,
        SetColor = function(newColor)
            label.TextColor3 = newColor
        end
    }
end

-- Create Separator Function
function UILibrary:CreateSeparator(tab)
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.BackgroundColor3 = CONFIG.BORDER_COLOR
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Parent = tab.Frame
    
    table.insert(tab.Elements, separator)
    return separator
end

-- Notification System
function UILibrary:CreateNotification(title, message, duration)
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = CONFIG.SECONDARY_COLOR
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, -320, 0, 20)
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Parent = UILibrary.ScreenGui
    
    createCorner(notification, 6)
    createStroke(notification, CONFIG.BORDER_COLOR, 1)
    
    -- Notification content
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Name = "Title"
    notifTitle.BackgroundTransparency = 1
    notifTitle.Position = UDim2.new(0, 15, 0, 10)
    notifTitle.Size = UDim2.new(1, -30, 0, 20)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.Text = title
    notifTitle.TextColor3 = CONFIG.TEXT_COLOR
    notifTitle.TextSize = 14
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notification
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Name = "Message"
    notifMessage.BackgroundTransparency = 1
    notifMessage.Position = UDim2.new(0, 15, 0, 30)
    notifMessage.Size = UDim2.new(1, -30, 0, 35)
    notifMessage.Font = Enum.Font.Gotham
    notifMessage.Text = message
    notifMessage.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
    notifMessage.TextSize = 12
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    notifMessage.TextYAlignment = Enum.TextYAlignment.Top
    notifMessage.TextWrapped = true
    notifMessage.Parent = notification
    
    -- Slide in animation
    TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 0, 20)
    }):Play()
    
    -- Auto dismiss
    wait(duration)
    local slideOut = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, 0, 0, 20)
    })
    slideOut:Play()
    slideOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- Set Title Function
function UILibrary:SetTitle(newTitle)
    local titleLabel = UILibrary.TitleBar:FindFirstChild("Title")
    if titleLabel then
        titleLabel.Text = newTitle
    end
end

-- Show/Hide Function
function UILibrary:SetVisible(visible)
    UILibrary.ScreenGui.Enabled = visible
end

-- Destroy Function
function UILibrary:Destroy()
    UILibrary.ScreenGui:Destroy()
end

return UILibrary
