local SnowClient = {}

-- Theme colors
SnowClient.Theme = {
    Primary = Color3.fromRGB(81, 134, 248),
    Background = Color3.fromRGB(0, 0, 0),
    Text = Color3.fromRGB(255, 255, 255)
}

-- Create the main UI
function SnowClient:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SnowClientUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Menu
    local Menu = Instance.new("Frame")
    Menu.Name = "Menu"
    Menu.Parent = ScreenGui
    Menu.BackgroundColor3 = self.Theme.Background
    Menu.BorderSizePixel = 0
    Menu.Position = UDim2.new(0.3, 0, 0.3, 0)
    Menu.Size = UDim2.new(0, 415, 0, 486)
    Menu.Visible = false -- Hidden by default

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Menu
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.267, 0, 0.001, 0)
    Title.Size = UDim2.new(0, 193, 0, 50)
    Title.Font = Enum.Font.Ubuntu
    Title.Text = name or "Snow Client"
    Title.TextColor3 = self.Theme.Primary
    Title.TextSize = 14

    -- Tabs container
    local Tabs = Instance.new("Frame")
    Tabs.Name = "Tabs"
    Tabs.Parent = Menu
    Tabs.BackgroundColor3 = self.Theme.Background
    Tabs.BorderSizePixel = 0
    Tabs.Position = UDim2.new(-0.424, 0, 0, 0)
    Tabs.Size = UDim2.new(0, 167, 0, 486)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Tabs
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content container
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Parent = Menu
    Content.Active = true
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0.103, 0)
    Content.Size = UDim2.new(0, 415, 0, 436)
    Content.BottomImage = ""
    Content.MidImage = ""
    Content.TopImage = ""
    Content.ScrollBarThickness = 5

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = Content
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 5)

    -- Loader (shown while UI is loading)
    local Loader = Instance.new("Frame")
    Loader.Name = "Loader"
    Loader.Parent = ScreenGui
    Loader.BackgroundColor3 = self.Theme.Background
    Loader.BorderSizePixel = 0
    Loader.Position = UDim2.new(0.238, 0, 0.097, 0)
    Loader.Size = UDim2.new(0, 193, 0, 197)

    local Spinner = Instance.new("ImageLabel")
    Spinner.Name = "Spinner"
    Spinner.Parent = Loader
    Spinner.BackgroundTransparency = 1
    Spinner.Position = UDim2.new(0.238, 0, 0.142, 0)
    Spinner.Size = UDim2.new(0, 100, 0, 100)
    Spinner.Image = "rbxassetid://80990588449079"
    Spinner.ImageColor3 = self.Theme.Primary

    local LoaderText = Instance.new("TextLabel")
    LoaderText.Parent = Loader
    LoaderText.BackgroundTransparency = 1
    LoaderText.Position = UDim2.new(0, 0, 0.746, 0)
    LoaderText.Size = UDim2.new(0, 193, 0, 50)
    LoaderText.Font = Enum.Font.Ubuntu
    LoaderText.Text = name or "Snow Client"
    LoaderText.TextColor3 = self.Theme.Primary
    LoaderText.TextSize = 14

    -- Spinner animation
    coroutine.wrap(function()
        while Loader.Parent do
            task.wait(0.02)
            Spinner.Rotation = (Spinner.Rotation + 2) % 360
        end
    end)()

    -- Hide loader and show menu after delay
    task.delay(2, function()
        Loader.Visible = false
        Menu.Visible = true
    end)

    -- Window methods
    local Window = {}
    Window.Gui = ScreenGui
    Window.Menu = Menu
    Window.Tabs = Tabs
    Window.Content = Content

    function Window:Toggle()
        Menu.Visible = not Menu.Visible
    end

    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Parent = Tabs
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0, 167, 0, 50)
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Text = name
        TabButton.TextColor3 = self.Theme.Primary
        TabButton.TextSize = 14

        local TabContent = Instance.new("Frame")
        TabContent.Name = name
        TabContent.Parent = Content
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.Visible = false
        TabContent.AutomaticSize = Enum.AutomaticSize.Y

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Parent = TabContent
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 5)

        -- Set first tab as active by default
        if #Tabs:GetChildren() == 1 then
            TabContent.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(Content:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            
            for _, child in ipairs(Tabs:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = self.Theme.Primary
                end
            end
            
            TabContent.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local Tab = {}
        Tab.Button = TabButton
        Tab.Content = TabContent

        function Tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.Parent = TabContent
            Button.BackgroundColor3 = SnowClient.Theme.Primary
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(0, 368, 0, 27)
            Button.Font = Enum.Font.Ubuntu
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14

            Button.MouseButton1Click:Connect(callback)
            
            return Button
        end

        function Tab:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Size = UDim2.new(0, 368, 0, 27)
            ToggleFrame.AutomaticSize = Enum.AutomaticSize.Y

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = default and SnowClient.Theme.Primary or Color3.fromRGB(60, 60, 60)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(0, 0, 0, 0)
            ToggleButton.Size = UDim2.new(0, 27, 0, 27)
            ToggleButton.Font = Enum.Font.Ubuntu
            ToggleButton.Text = ""
            ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            ToggleButton.TextSize = 14

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 35, 0, 0)
            ToggleLabel.Size = UDim2.new(0, 333, 0, 27)
            ToggleLabel.Font = Enum.Font.Ubuntu
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = SnowClient.Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local state = default or false

            local function updateToggle()
                ToggleButton.BackgroundColor3 = state and SnowClient.Theme.Primary or Color3.fromRGB(60, 60, 60)
                callback(state)
            end

            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
            end)

            updateToggle()
            
            return {
                Set = function(newState)
                    state = newState
                    updateToggle()
                end,
                Get = function()
                    return state
                end
            }
        end

        function Tab:AddDropdown(text, options, default, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = text
            DropdownFrame.Parent = TabContent
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Size = UDim2.new(0, 368, 0, 27)
            DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundColor3 = SnowClient.Theme.Primary
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Size = UDim2.new(0, 368, 0, 27)
            DropdownButton.Font = Enum.Font.Ubuntu
            DropdownButton.Text = text .. ": " .. (default or options[1])
            DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            DropdownButton.TextSize = 14

            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "Options"
            OptionsFrame.Parent = DropdownFrame
            OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            OptionsFrame.BorderSizePixel = 0
            OptionsFrame.Position = UDim2.new(0, 0, 0, 32)
            OptionsFrame.Size = UDim2.new(0, 368, 0, 0)
            OptionsFrame.Visible = false
            OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y

            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.Parent = OptionsFrame
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Parent = OptionsFrame
                OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                OptionButton.BorderSizePixel = 0
                OptionButton.Size = UDim2.new(0, 368, 0, 27)
                OptionButton.Font = Enum.Font.Ubuntu
                OptionButton.Text = option
                OptionButton.TextColor3 = SnowClient.Theme.Text
                OptionButton.TextSize = 14

                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = text .. ": " .. option
                    OptionsFrame.Visible = false
                    callback(option)
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                OptionsFrame.Visible = not OptionsFrame.Visible
            end)

            local dropdown = {
                Set = function(option)
                    if table.find(options, option) then
                        DropdownButton.Text = text .. ": " .. option
                        callback(option)
                    end
                end,
                Get = function()
                    return string.sub(DropdownButton.Text, string.len(text) + 3)
                end
            }

            return dropdown
        end

        function Tab:AddColorPicker(text, default, callback)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Name = text
            ColorFrame.Parent = TabContent
            ColorFrame.BackgroundTransparency = 1
            ColorFrame.Size = UDim2.new(0, 368, 0, 27)
            ColorFrame.AutomaticSize = Enum.AutomaticSize.Y

            local ColorButton = Instance.new("TextButton")
            ColorButton.Name = "ColorButton"
            ColorButton.Parent = ColorFrame
            ColorButton.BackgroundColor3 = default or Color3.fromRGB(255, 0, 0)
            ColorButton.BorderSizePixel = 0
            ColorButton.Position = UDim2.new(0, 0, 0, 0)
            ColorButton.Size = UDim2.new(0, 27, 0, 27)
            ColorButton.Font = Enum.Font.Ubuntu
            ColorButton.Text = ""
            ColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            ColorButton.TextSize = 14

            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Name = "ColorLabel"
            ColorLabel.Parent = ColorFrame
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Position = UDim2.new(0, 35, 0, 0)
            ColorLabel.Size = UDim2.new(0, 333, 0, 27)
            ColorLabel.Font = Enum.Font.Ubuntu
            ColorLabel.Text = text
            ColorLabel.TextColor3 = SnowClient.Theme.Text
            ColorLabel.TextSize = 14
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left

            local PickerFrame = Instance.new("Frame")
            PickerFrame.Name = "ColorPicker"
            PickerFrame.Parent = ColorFrame
            PickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            PickerFrame.BorderSizePixel = 0
            PickerFrame.Position = UDim2.new(0, 0, 0, 32)
            PickerFrame.Size = UDim2.new(0, 368, 0, 100)
            PickerFrame.Visible = false

            -- Simple color picker implementation
            local HueBar = Instance.new("Frame")
            HueBar.Name = "HueBar"
            HueBar.Parent = PickerFrame
            HueBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            HueBar.BorderSizePixel = 0
            HueBar.Position = UDim2.new(0, 10, 0, 10)
            HueBar.Size = UDim2.new(0, 20, 0, 80)

            local ColorPreview = Instance.new("Frame")
            ColorPreview.Name = "ColorPreview"
            ColorPreview.Parent = PickerFrame
            ColorPreview.BackgroundColor3 = default or Color3.fromRGB(255, 0, 0)
            ColorPreview.BorderSizePixel = 0
            ColorPreview.Position = UDim2.new(0, 40, 0, 10)
            ColorPreview.Size = UDim2.new(0, 80, 0, 80)

            local function updateColor(hue)
                local color = Color3.fromHSV(hue, 1, 1)
                ColorButton.BackgroundColor3 = color
                ColorPreview.BackgroundColor3 = color
                callback(color)
            end

            local hue = 0
            local isDragging = false

            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    local y = input.Position.Y - HueBar.AbsolutePosition.Y
                    hue = math.clamp(y / HueBar.AbsoluteSize.Y, 0, 1)
                    updateColor(hue)
                end
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local y = input.Position.Y - HueBar.AbsolutePosition.Y
                    hue = math.clamp(y / HueBar.AbsoluteSize.Y, 0, 1)
                    updateColor(hue)
                end
            end)

            ColorButton.MouseButton1Click:Connect(function()
                PickerFrame.Visible = not PickerFrame.Visible
            end)

            local colorPicker = {
                Set = function(color)
                    ColorButton.BackgroundColor3 = color
                    ColorPreview.BackgroundColor3 = color
                    callback(color)
                end,
                Get = function()
                    return ColorButton.BackgroundColor3
                end
            }

            return colorPicker
        end

        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = text
            Label.Parent = TabContent
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0, 368, 0, 27)
            Label.Font = Enum.Font.Ubuntu
            Label.Text = text
            Label.TextColor3 = SnowClient.Theme.Text
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            return Label
        end

        return Tab
    end

    return Window
end

return SnowClient
