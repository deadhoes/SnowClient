local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ModernUI = {}
ModernUI.__index = ModernUI

-- Varsayılan renkler ve ayarlar
local theme = {
    primary = Color3.fromRGB(88, 101, 242),
    secondary = Color3.fromRGB(32, 34, 37),
    background = Color3.fromRGB(54, 57, 63),
    surface = Color3.fromRGB(64, 68, 75),
    text = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(181, 186, 193),
    accent = Color3.fromRGB(114, 137, 218),
    success = Color3.fromRGB(67, 181, 129),
    warning = Color3.fromRGB(250, 166, 26),
    error = Color3.fromRGB(240, 71, 71)
}

-- Animasyon ayarları
local animations = {
    fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    slow = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Yardımcı fonksiyonlar
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createPadding(parent, padding)
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, padding)
    uiPadding.PaddingBottom = UDim.new(0, padding)
    uiPadding.PaddingLeft = UDim.new(0, padding)
    uiPadding.PaddingRight = UDim.new(0, padding)
    uiPadding.Parent = parent
    return uiPadding
end

local function createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or theme.surface
    stroke.Transparency = 0.7
    stroke.Parent = parent
    return stroke
end

local function rippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Parent = button
    
    createCorner(ripple, 100)
    
    local expandTween = TweenService:Create(ripple, animations.fast, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Ana kütüphane fonksiyonu
function ModernUI:CreateWindow(config)
    local window = {}
    
    -- Varsayılan ayarlar
    config = config or {}
    config.Name = config.Name or "ModernUI"
    config.LoadingTitle = config.LoadingTitle or "Loading..."
    config.LoadingSubtitle = config.LoadingSubtitle or "Please wait"
    config.ConfigurationSaving = config.ConfigurationSaving or {}
    config.Discord = config.Discord or {}
    config.KeySystem = config.KeySystem or false
    
    -- Ana GUI oluştur
    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernUI"
    gui.Parent = playerGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Ana frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 550, 0, 400)
    main.Position = UDim2.new(0.5, -275, 0.5, -200)
    main.BackgroundColor3 = theme.background
    main.BorderSizePixel = 0
    main.Parent = gui
    
    createCorner(main, 12)
    createStroke(main, 1, theme.surface)
    
    -- Başlık çubuğu
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = theme.secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    createCorner(titleBar, 12)
    
    -- Başlık metni
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name
    title.TextColor3 = theme.text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Kapat butonu
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = theme.error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = theme.text
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    createCorner(closeButton, 6)
    
    -- Minimize butonu
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -75, 0, 10)
    minimizeButton.BackgroundColor3 = theme.warning
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = theme.text
    minimizeButton.TextSize = 20
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleBar
    
    createCorner(minimizeButton, 6)
    
    -- Sekme container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = theme.secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = main
    
    -- Sekme listesi
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.Position = UDim2.new(0, 0, 0, 0)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 4
    tabList.ScrollBarImageColor3 = theme.primary
    tabList.Parent = tabContainer
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = tabList
    
    createPadding(tabList, 10)
    
    -- İçerik alanı
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -150, 1, -50)
    contentArea.Position = UDim2.new(0, 150, 0, 50)
    contentArea.BackgroundColor3 = theme.background
    contentArea.BorderSizePixel = 0
    contentArea.Parent = main
    
    -- Sürükleme fonksiyonu
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Pencere kontrolleri
    local minimized = false
    local originalSize = main.Size
    
    closeButton.MouseButton1Click:Connect(function()
        rippleEffect(closeButton)
        gui:Destroy()
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        rippleEffect(minimizeButton)
        if minimized then
            TweenService:Create(main, animations.medium, {Size = originalSize}):Play()
            minimized = false
        else
            TweenService:Create(main, animations.medium, {Size = UDim2.new(0, 550, 0, 50)}):Play()
            minimized = true
        end
    end)
    
    -- Buton hover efektleri
    local function setupButtonHover(button, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, animations.fast, {BackgroundColor3 = hoverColor}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, animations.fast, {BackgroundColor3 = button.BackgroundColor3}):Play()
        end)
    end
    
    setupButtonHover(closeButton, Color3.fromRGB(255, 100, 100))
    setupButtonHover(minimizeButton, Color3.fromRGB(255, 200, 50))
    
    -- Sekme sistemi
    local tabs = {}
    local currentTab = nil
    
    function window:CreateTab(config)
        local tab = {}
        config = config or {}
        config.Name = config.Name or "Tab"
        config.Image = config.Image or "rbxassetid://4483345998"
        config.ImageSize = config.ImageSize or 20
        
        -- Sekme butonu
        local tabButton = Instance.new("TextButton")
        tabButton.Name = config.Name
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.BackgroundColor3 = theme.surface
        tabButton.BorderSizePixel = 0
        tabButton.Text = ""
        tabButton.Parent = tabList
        
        createCorner(tabButton, 6)
        
        -- Sekme ikonu
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, config.ImageSize, 0, config.ImageSize)
        tabIcon.Position = UDim2.new(0, 10, 0.5, -config.ImageSize/2)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = config.Image
        tabIcon.ImageColor3 = theme.textSecondary
        tabIcon.Parent = tabButton
        
        -- Sekme metni
        local tabText = Instance.new("TextLabel")
        tabText.Name = "Text"
        tabText.Size = UDim2.new(1, -40, 1, 0)
        tabText.Position = UDim2.new(0, 35, 0, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = config.Name
        tabText.TextColor3 = theme.textSecondary
        tabText.TextSize = 14
        tabText.Font = Enum.Font.Gotham
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        tabText.Parent = tabButton
        
        -- Sekme içeriği
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = config.Name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = theme.primary
        tabContent.Visible = false
        tabContent.Parent = contentArea
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = tabContent
        
        createPadding(tabContent, 15)
        
        -- Sekme tıklama
        tabButton.MouseButton1Click:Connect(function()
            rippleEffect(tabButton)
            
            -- Diğer sekmeleri gizle
            for _, otherTab in pairs(tabs) do
                otherTab.button.BackgroundColor3 = theme.surface
                otherTab.icon.ImageColor3 = theme.textSecondary
                otherTab.text.TextColor3 = theme.textSecondary
                otherTab.content.Visible = false
            end
            
            -- Bu sekmeyi aktif et
            tabButton.BackgroundColor3 = theme.primary
            tabIcon.ImageColor3 = theme.text
            tabText.TextColor3 = theme.text
            tabContent.Visible = true
            currentTab = tab
        end)
        
        -- Hover efekti
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tab then
                TweenService:Create(tabButton, animations.fast, {BackgroundColor3 = theme.accent}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tab then
                TweenService:Create(tabButton, animations.fast, {BackgroundColor3 = theme.surface}):Play()
            end
        end)
        
        -- Tab nesnesini sakla
        tab.button = tabButton
        tab.icon = tabIcon
        tab.text = tabText
        tab.content = tabContent
        tab.name = config.Name
        
        tabs[config.Name] = tab
        
        -- İlk sekme ise aktif et
        if #tabs == 1 then
            tabButton.BackgroundColor3 = theme.primary
            tabIcon.ImageColor3 = theme.text
            tabText.TextColor3 = theme.text
            tabContent.Visible = true
            currentTab = tab
        end
        
        -- Element oluşturma fonksiyonları
        function tab:CreateButton(config)
            config = config or {}
            config.Name = config.Name or "Button"
            config.Callback = config.Callback or function() end
            
            local button = Instance.new("TextButton")
            button.Name = config.Name
            button.Size = UDim2.new(1, 0, 0, 40)
            button.BackgroundColor3 = theme.primary
            button.BorderSizePixel = 0
            button.Text = config.Name
            button.TextColor3 = theme.text
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = tabContent
            
            createCorner(button, 6)
            
            button.MouseButton1Click:Connect(function()
                rippleEffect(button)
                config.Callback()
            end)
            
            -- Hover efekti
            button.MouseEnter:Connect(function()
                TweenService:Create(button, animations.fast, {BackgroundColor3 = theme.accent}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, animations.fast, {BackgroundColor3 = theme.primary}):Play()
            end)
            
            return button
        end
        
        function tab:CreateToggle(config)
            config = config or {}
            config.Name = config.Name or "Toggle"
            config.Default = config.Default or false
            config.Callback = config.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = config.Name
            toggleFrame.Size = UDim2.new(1, 0, 0, 40)
            toggleFrame.BackgroundColor3 = theme.surface
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = tabContent
            
            createCorner(toggleFrame, 6)
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.Position = UDim2.new(0, 15, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = config.Name
            toggleLabel.TextColor3 = theme.text
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            toggleButton.BackgroundColor3 = config.Default and theme.primary or theme.secondary
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            createCorner(toggleButton, 10)
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Name = "Circle"
            toggleCircle.Size = UDim2.new(0, 16, 0, 16)
            toggleCircle.Position = config.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            toggleCircle.BackgroundColor3 = theme.text
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleButton
            
            createCorner(toggleCircle, 8)
            
            local toggled = config.Default
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                local circlePos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local buttonColor = toggled and theme.primary or theme.secondary
                
                TweenService:Create(toggleCircle, animations.fast, {Position = circlePos}):Play()
                TweenService:Create(toggleButton, animations.fast, {BackgroundColor3 = buttonColor}):Play()
                
                config.Callback(toggled)
            end)
            
            return {
                frame = toggleFrame,
                getValue = function()
                    return toggled
                end,
                setValue = function(value)
                    toggled = value
                    local circlePos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local buttonColor = toggled and theme.primary or theme.secondary
                    
                    TweenService:Create(toggleCircle, animations.fast, {Position = circlePos}):Play()
                    TweenService:Create(toggleButton, animations.fast, {BackgroundColor3 = buttonColor}):Play()
                end
            }
        end
        
        function tab:CreateSlider(config)
            config = config or {}
            config.Name = config.Name or "Slider"
            config.Range = config.Range or {0, 100}
            config.Increment = config.Increment or 1
            config.Suffix = config.Suffix or ""
            config.CurrentValue = config.CurrentValue or config.Range[1]
            config.Callback = config.Callback or function() end
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = config.Name
            sliderFrame.Size = UDim2.new(1, 0, 0, 60)
            sliderFrame.BackgroundColor3 = theme.surface
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = tabContent
            
            createCorner(sliderFrame, 6)
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "Label"
            sliderLabel.Size = UDim2.new(1, -80, 0, 20)
            sliderLabel.Position = UDim2.new(0, 15, 0, 10)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = config.Name
            sliderLabel.TextColor3 = theme.text
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.Name = "Value"
            sliderValue.Size = UDim2.new(0, 70, 0, 20)
            sliderValue.Position = UDim2.new(1, -80, 0, 10)
            sliderValue.BackgroundTransparency = 1
            sliderValue.Text = tostring(config.CurrentValue) .. config.Suffix
            sliderValue.TextColor3 = theme.primary
            sliderValue.TextSize = 14
            sliderValue.Font = Enum.Font.GothamBold
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Name = "Track"
            sliderTrack.Size = UDim2.new(1, -30, 0, 4)
            sliderTrack.Position = UDim2.new(0, 15, 1, -20)
            sliderTrack.BackgroundColor3 = theme.secondary
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Parent = sliderFrame
            
            createCorner(sliderTrack, 2)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "Fill"
            sliderFill.Size = UDim2.new((config.CurrentValue - config.Range[1]) / (config.Range[2] - config.Range[1]), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = theme.primary
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderTrack
            
            createCorner(sliderFill, 2)
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Name = "Button"
            sliderButton.Size = UDim2.new(1, 0, 1, 0)
            sliderButton.Position = UDim2.new(0, 0, 0, 0)
            sliderButton.BackgroundTransparency = 1
            sliderButton.Text = ""
            sliderButton.Parent = sliderTrack
            
            local dragging = false
            local currentValue = config.CurrentValue
            
            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouse = UserInputService:GetMouseLocation()
                    local trackPosition = sliderTrack.AbsolutePosition
                    local trackSize = sliderTrack.AbsoluteSize
                    
                    local relativeX = math.clamp((mouse.X - trackPosition.X) / trackSize.X, 0, 1)
                    local newValue = config.Range[1] + (config.Range[2] - config.Range[1]) * relativeX
                    newValue = math.floor(newValue / config.Increment) * config.Increment
                    
                    currentValue = newValue
                    sliderValue.Text = tostring(currentValue) .. config.Suffix
                    
                    TweenService:Create(sliderFill, animations.fast, {
                        Size = UDim2.new(relativeX, 0, 1, 0)
                    }):Play()
                    
                    config.Callback(currentValue)
                end
            end)
            
            return {
                frame = sliderFrame,
                getValue = function()
                    return currentValue
                end,
                setValue = function(value)
                    currentValue = value
                    sliderValue.Text = tostring(currentValue) .. config.Suffix
                    local relativeX = (currentValue - config.Range[1]) / (config.Range[2] - config.Range[1])
                    TweenService:Create(sliderFill, animations.fast, {
                        Size = UDim2.new(relativeX, 0, 1, 0)
                    }):Play()
                end
            }
        end
        
        function tab:CreateLabel(config)
            config = config or {}
            config.Text = config.Text or "Label"
            config.TextSize = config.TextSize or 14
            config.TextColor = config.TextColor or theme.text
            
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, 0, 0, 30)
            label.BackgroundTransparency = 1
            label.Text = config.Text
            label.TextColor3 = config.TextColor
            label.TextSize = config.TextSize
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tabContent
            
            return {
                label = label,
                setText = function(text)
                    label.Text = text
                end
            }
        end
        
        return tab
    end
    
    -- Canvas boyutunu güncelle
    local function updateCanvasSize()
        for _, tab in pairs(tabs) do
            tab.content.CanvasSize = UDim2.new(0, 0, 0, tab.content.UIListLayout.AbsoluteContentSize.Y + 30)
        end
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 20)
    end
    
    -- Canvas boyutunu sürekli güncelle
    RunService.Heartbeat:Connect(updateCanvasSize)
    
    return window
end

return ModernUI
