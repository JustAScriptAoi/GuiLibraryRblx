local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local LIB_NAME = "FhriiXPloitMiniUi"
local FONT = Enum.Font.Roboto
local ORANGE = Color3.fromRGB(255, 140, 0)
local WHITE = Color3.new(1, 1, 1)
local ROUND_IMG = "rbxassetid://3570695787"
local BG_DARK = Color3.new(0.098, 0.098, 0.098)
local BG_BODY = Color3.new(0.137, 0.137, 0.137)
local BG_SECTION = Color3.new(0.176, 0.176, 0.176)
local BTN_GREY = Color3.new(0.254902, 0.254902, 0.254902)
local ROW = 30
local BODY_CLOSED = 35
local PILL_POS = UDim2.new(0.052941, 0, 0, 3)
local PILL_SIZE = UDim2.new(0, 153, 0, 24)
local PRESS_POS = UDim2.new(0.052941, 4, 0, 4)
local PRESS_SIZE = UDim2.new(0, 145, 0, 22)

local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_MED = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_SLOW = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_SLIDE = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local windowOffset = 0
local hue = 0

if CoreGui:FindFirstChild(LIB_NAME) then
    CoreGui:FindFirstChild(LIB_NAME):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = LIB_NAME
ScreenGui.Parent = CoreGui

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = ScreenGui
Container.BackgroundColor3 = WHITE
Container.BackgroundTransparency = 1
Container.Size = UDim2.new(0, 100, 0, 100)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

local function tween(instance, info, goal)
    local t = TweenService:Create(instance, info, goal)
    t:Play()
    return t
end

local function stripSpaces(str)
    return (str:gsub(" ", ""))
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = ORANGE
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function makeText(parent, name, text, pos, size)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Parent = parent
    lbl.BackgroundTransparency = 1
    lbl.BorderSizePixel = 0
    lbl.Position = pos
    lbl.Size = size
    lbl.Font = FONT
    lbl.Text = text
    lbl.TextColor3 = WHITE
    lbl.TextSize = 13
    lbl.TextScaled = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MaxTextSize = 13
    constraint.MinTextSize = 6
    constraint.Parent = lbl
    return lbl
end

local function makeHolder(name)
    local holder = Instance.new("Frame")
    holder.Name = name
    holder.BackgroundColor3 = BG_BODY
    holder.BorderSizePixel = 0
    holder.Size = UDim2.new(0, 170, 0, ROW)
    return holder
end

local function makeRound(parent, name, pos, size, color)
    local img = Instance.new("ImageLabel")
    img.Name = name
    img.Parent = parent
    img.BackgroundTransparency = 1
    img.Position = pos
    img.Size = size
    img.Image = ROUND_IMG
    img.ImageColor3 = color
    img.ScaleType = Enum.ScaleType.Slice
    img.SliceCenter = Rect.new(100, 100, 100, 100)
    img.SliceScale = 0.04
    return img
end

local function makeRgbLabel(parent, name, x)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Parent = parent
    lbl.BackgroundColor3 = BTN_GREY
    lbl.BorderSizePixel = 0
    lbl.Position = UDim2.new(0, x, 0, 127)
    lbl.Size = UDim2.new(0, 50, 0, 16)
    lbl.Font = FONT
    lbl.Text = ""
    lbl.TextColor3 = WHITE
    lbl.TextSize = 13
    addCorner(lbl, 4)
    return lbl
end

local function hover(btn, normal, over)
    btn.MouseEnter:Connect(function()
        tween(btn, TWEEN_FAST, { TextColor3 = over })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, TWEEN_FAST, { TextColor3 = normal })
    end)
end

local function reveal(holder)
    local target = holder.BackgroundTransparency
    holder.BackgroundTransparency = 1
    tween(holder, TWEEN_MED, { BackgroundTransparency = target })
    for _, obj in ipairs(holder:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local t = obj.TextTransparency
            obj.TextTransparency = 1
            tween(obj, TWEEN_MED, { TextTransparency = t })
        end
    end
end

local function pressVisual(pill, btn, pressed)
    local pos = pressed and PRESS_POS or PILL_POS
    local size = pressed and PRESS_SIZE or PILL_SIZE
    tween(pill, TWEEN_FAST, { Position = pos, Size = size, ImageColor3 = pressed and ORANGE or BTN_GREY })
    tween(btn, TWEEN_FAST, { Position = pos, Size = size })
end

local function swapText(items)
    for _, item in ipairs(items) do
        tween(item.Button, TWEEN_FAST, { TextTransparency = 1 })
    end
    task.delay(TWEEN_FAST.Time, function()
        for _, item in ipairs(items) do
            item.Button.Text = item.Text
            item.Button.TextSize = item.Size
            tween(item.Button, TWEEN_FAST, { TextTransparency = 0 })
        end
    end)
end

local function Dragging(frame, handle)
    local dragStart, startPos, dragging
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

coroutine.wrap(function()
    while wait() do
        hue = hue + 0.00392156862745098
        if hue >= 1 then hue = 0 end
    end
end)()

return {
    NewWindow = function(_, windowTitle)
        windowOffset = windowOffset + 2

        local windowId = stripSpaces(windowTitle)
        local windowOpen = true
        local contentHeight = BODY_CLOSED
        local sectionCount = 0
        local windowClosers = {}
        local finalPos = UDim2.new(windowOffset, -100, 3, -265)

        local WindowRoot = Instance.new("ImageLabel")
        local WindowScale = Instance.new("UIScale")
        local Topbar = Instance.new("Frame")
        local ToggleBtn = Instance.new("TextButton")
        local TitleLabel = Instance.new("TextLabel")
        local TitleConstraint = Instance.new("UITextSizeConstraint")
        local DragHandle = Instance.new("TextButton")
        local BottomCover = Instance.new("Frame")
        local Body = Instance.new("ImageLabel")
        local BodySorter = Instance.new("UIListLayout")
        local BodyTopCover = Instance.new("Frame")

        WindowRoot.Name = windowId .. "Window"
        WindowRoot.Parent = Container
        WindowRoot.BackgroundTransparency = 1
        WindowRoot.Position = finalPos + UDim2.new(0, 0, 0, 18)
        WindowRoot.Size = UDim2.new(0, 170, 0, ROW)
        WindowRoot.ZIndex = 2
        WindowRoot.Image = ROUND_IMG
        WindowRoot.ImageColor3 = BG_DARK
        WindowRoot.ScaleType = Enum.ScaleType.Slice
        WindowRoot.SliceCenter = Rect.new(100, 100, 100, 100)
        WindowRoot.SliceScale = 0.05
        WindowScale.Scale = 0.85
        WindowScale.Parent = WindowRoot

        Topbar.Name = "Topbar"
        Topbar.Parent = WindowRoot
        Topbar.BackgroundTransparency = 1
        Topbar.BorderSizePixel = 0
        Topbar.Size = UDim2.new(0, 170, 0, ROW)
        Topbar.ZIndex = 2

        ToggleBtn.Name = "WindowToggle"
        ToggleBtn.Parent = Topbar
        ToggleBtn.BackgroundTransparency = 1
        ToggleBtn.Position = UDim2.new(0.82245, 0, 0, 0)
        ToggleBtn.Size = UDim2.new(0, 30, 0, ROW)
        ToggleBtn.ZIndex = 2
        ToggleBtn.AutoButtonColor = false
        ToggleBtn.Font = FONT
        ToggleBtn.Text = "-"
        ToggleBtn.TextColor3 = WHITE
        ToggleBtn.TextSize = 20
        ToggleBtn.TextWrapped = true
        hover(ToggleBtn, WHITE, ORANGE)

        TitleLabel.Name = "WindowTitle"
        TitleLabel.Parent = Topbar
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(0, 170, 0, ROW)
        TitleLabel.ZIndex = 2
        TitleLabel.Font = FONT
        TitleLabel.Text = windowTitle
        TitleLabel.TextColor3 = WHITE
        TitleLabel.TextSize = 13
        TitleLabel.TextScaled = true
        TitleConstraint.MaxTextSize = 13
        TitleConstraint.MinTextSize = 6
        TitleConstraint.Parent = TitleLabel

        DragHandle.Name = "DragHandle"
        DragHandle.Parent = Topbar
        DragHandle.BackgroundTransparency = 1
        DragHandle.Size = UDim2.new(0.8, 0, 1, 0)
        DragHandle.Text = ""
        DragHandle.AutoButtonColor = false
        DragHandle.ZIndex = 2
        Dragging(WindowRoot, DragHandle)

        BottomCover.Name = "BottomRoundCover"
        BottomCover.Parent = Topbar
        BottomCover.BackgroundColor3 = BG_DARK
        BottomCover.BorderSizePixel = 0
        BottomCover.Position = UDim2.new(0, 0, 0.8333, 0)
        BottomCover.Size = UDim2.new(0, 170, 0, 5)
        BottomCover.ZIndex = 2

        Body.Name = "Body"
        Body.Parent = WindowRoot
        Body.BackgroundTransparency = 1
        Body.ClipsDescendants = true
        Body.Size = UDim2.new(0, 170, 0, BODY_CLOSED)
        Body.Image = ROUND_IMG
        Body.ImageColor3 = BG_BODY
        Body.ImageTransparency = 1
        Body.ScaleType = Enum.ScaleType.Slice
        Body.SliceCenter = Rect.new(100, 100, 100, 100)
        Body.SliceScale = 0.05
        addCorner(Body, 5)
        addStroke(Body, 1.5)

        BodySorter.Name = "Sorter"
        BodySorter.Parent = Body
        BodySorter.SortOrder = Enum.SortOrder.LayoutOrder

        BodyTopCover.Name = "TopbarBodyCover"
        BodyTopCover.Parent = Body
        BodyTopCover.BackgroundTransparency = 1
        BodyTopCover.BorderSizePixel = 0
        BodyTopCover.Size = UDim2.new(0, 170, 0, ROW)
        BodyTopCover.LayoutOrder = 0

        local function applyBodySize()
            tween(Body, TWEEN_MED, { Size = UDim2.new(0, 170, 0, windowOpen and contentHeight or BODY_CLOSED) })
        end

        ToggleBtn.MouseButton1Down:Connect(function()
            windowOpen = not windowOpen
            swapText({ { Button = ToggleBtn, Text = windowOpen and "-" or "v", Size = windowOpen and 20 or 14 } })
            for _, close in ipairs(windowClosers) do
                close()
            end
            applyBodySize()
        end)

        tween(WindowScale, TWEEN_MED, { Scale = 1 })
        tween(WindowRoot, TWEEN_MED, { Position = finalPos })
        tween(Body, TWEEN_MED, { ImageTransparency = 0 })
        TitleLabel.TextTransparency = 1
        tween(TitleLabel, TWEEN_MED, { TextTransparency = 0 })

        return {
            NewSection = function(_, sectionTitle)
                sectionCount = sectionCount + 1
                contentHeight = contentHeight + ROW
                local sectionOpen = false
                local sectionHeight = ROW
                local elementCount = 0
                local sectionClosers = {}

                local SectionFrame = Instance.new("Frame")
                local SectionInfo = Instance.new("Frame")
                local SectionToggle = Instance.new("TextButton")
                local SectionLayout = Instance.new("UIListLayout")

                SectionFrame.Name = stripSpaces(sectionTitle) .. "Section"
                SectionFrame.Parent = Body
                SectionFrame.BackgroundColor3 = BG_SECTION
                SectionFrame.BorderSizePixel = 0
                SectionFrame.ClipsDescendants = true
                SectionFrame.LayoutOrder = sectionCount
                SectionFrame.Size = UDim2.new(0, 170, 0, ROW)

                SectionInfo.Name = "SectionInfo"
                SectionInfo.Parent = SectionFrame
                SectionInfo.BackgroundTransparency = 1
                SectionInfo.LayoutOrder = 0
                SectionInfo.Size = UDim2.new(0, 170, 0, ROW)

                SectionToggle.Name = "SectionToggle"
                SectionToggle.Parent = SectionInfo
                SectionToggle.BackgroundTransparency = 1
                SectionToggle.Position = UDim2.new(0.82245, 0, 0, 0)
                SectionToggle.Size = UDim2.new(0, 30, 0, ROW)
                SectionToggle.ZIndex = 2
                SectionToggle.AutoButtonColor = false
                SectionToggle.Font = FONT
                SectionToggle.Text = "v"
                SectionToggle.TextColor3 = WHITE
                SectionToggle.TextSize = 14
                SectionToggle.TextWrapped = true
                hover(SectionToggle, WHITE, ORANGE)

                makeText(SectionInfo, "SectionTitle", sectionTitle, UDim2.new(0.052941, 0, 0, 0), UDim2.new(0, 125, 0, ROW))

                SectionLayout.Name = "Layout"
                SectionLayout.Parent = SectionFrame
                SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder

                applyBodySize()

                local function targetHeight()
                    if sectionOpen then
                        return ROW + elementCount * ROW
                    end
                    return ROW
                end

                local function applySectionHeight(h)
                    contentHeight = contentHeight + (h - sectionHeight)
                    sectionHeight = h
                    tween(SectionFrame, TWEEN_MED, { Size = UDim2.new(0, 170, 0, h) })
                    applyBodySize()
                end

                local function registerCloser(fn)
                    table.insert(sectionClosers, fn)
                    table.insert(windowClosers, fn)
                end

                local function clipPopups(on)
                    SectionFrame.ClipsDescendants = not on
                    Body.ClipsDescendants = not on
                end

                local function addElement(holder)
                    elementCount = elementCount + 1
                    holder.LayoutOrder = elementCount
                    holder.Parent = SectionFrame
                    reveal(holder)
                    if sectionOpen then
                        applySectionHeight(targetHeight())
                    end
                end

                local function setSectionOpen(open)
                    sectionOpen = open
                    swapText({ { Button = SectionToggle, Text = open and "-" or "v", Size = open and 20 or 14 } })
                    for _, close in ipairs(sectionClosers) do
                        close()
                    end
                    applySectionHeight(targetHeight())
                end

                SectionToggle.MouseButton1Down:Connect(function()
                    setSectionOpen(not sectionOpen)
                end)

                return {
                    CreateToggle = function(_, label, callback)
                        local state = false
                        local Holder = makeHolder(stripSpaces(label) .. "ToggleHolder")
                        makeText(Holder, "ToggleTitle", label, UDim2.new(0.052941, 0, 0, 0), UDim2.new(0, 125, 0, ROW))
                        local Background = makeRound(Holder, "ToggleBackground", UDim2.new(0.847059, 0, 0.166667, 0), UDim2.new(0, 20, 0, 20), BTN_GREY)
                        local Dot = makeRound(Background, "ToggleDot", UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 4, 0, 4), ORANGE)
                        Dot.AnchorPoint = Vector2.new(0.5, 0.5)
                        Dot.ImageTransparency = 1
                        local Hit = Instance.new("TextButton")
                        Hit.Name = "ToggleHit"
                        Hit.Parent = Background
                        Hit.BackgroundTransparency = 1
                        Hit.Size = UDim2.new(1, 0, 1, 0)
                        Hit.Text = ""
                        Hit.AutoButtonColor = false
                        Hit.MouseButton1Down:Connect(function()
                            state = not state
                            tween(Dot, TWEEN_MED, {
                                Size = state and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 4, 0, 4),
                                ImageTransparency = state and 0 or 1,
                            })
                            callback(state)
                        end)
                        addElement(Holder)
                    end,

                    CreateSlider = function(_, label, min, max, default, isFloat, callback)
                        local dragging = false
                        local Holder = makeHolder(stripSpaces(label) .. "SliderHolder")
                        makeText(Holder, "SliderTitle", label, UDim2.new(0.052941, 0, 0, 1), UDim2.new(0, 110, 0, 15))

                        local ValueHolder = Instance.new("ImageLabel")
                        ValueHolder.Name = "SliderValueHolder"
                        ValueHolder.Parent = Holder
                        ValueHolder.BackgroundTransparency = 1
                        ValueHolder.Position = UDim2.new(0.747059, 0, 0, 1)
                        ValueHolder.Size = UDim2.new(0, 35, 0, 15)
                        ValueHolder.Image = ROUND_IMG
                        ValueHolder.ImageColor3 = BTN_GREY
                        ValueHolder.ImageTransparency = 0.5
                        ValueHolder.ScaleType = Enum.ScaleType.Slice
                        ValueHolder.SliceCenter = Rect.new(100, 100, 100, 100)
                        ValueHolder.SliceScale = 0.02

                        local ValueLabel = Instance.new("TextLabel")
                        ValueLabel.Name = "SliderValue"
                        ValueLabel.Parent = ValueHolder
                        ValueLabel.BackgroundTransparency = 1
                        ValueLabel.Size = UDim2.new(1, 0, 1, 0)
                        ValueLabel.Font = FONT
                        ValueLabel.Text = ""
                        ValueLabel.TextColor3 = WHITE
                        ValueLabel.TextSize = 12

                        local Track = Instance.new("ImageLabel")
                        Track.Name = "SliderTrack"
                        Track.Parent = Holder
                        Track.BackgroundTransparency = 1
                        Track.Position = UDim2.new(0.052941, 0, 0, 20)
                        Track.Size = UDim2.new(0, 153, 0, 5)
                        Track.Image = ROUND_IMG
                        Track.ImageColor3 = BTN_GREY
                        Track.ScaleType = Enum.ScaleType.Slice
                        Track.SliceCenter = Rect.new(100, 100, 100, 100)
                        Track.SliceScale = 0.02

                        local Fill = Instance.new("ImageLabel")
                        Fill.Name = "SliderFill"
                        Fill.Parent = Track
                        Fill.BackgroundTransparency = 1
                        Fill.Size = UDim2.new(0, 0, 1, 0)
                        Fill.Image = ROUND_IMG
                        Fill.ImageColor3 = ORANGE
                        Fill.ScaleType = Enum.ScaleType.Slice
                        Fill.SliceCenter = Rect.new(100, 100, 100, 100)
                        Fill.SliceScale = 0.02

                        local Knob = Instance.new("Frame")
                        Knob.Name = "SliderKnob"
                        Knob.Parent = Track
                        Knob.AnchorPoint = Vector2.new(0.5, 0.5)
                        Knob.BackgroundColor3 = WHITE
                        Knob.BorderSizePixel = 0
                        Knob.Position = UDim2.new(0, 0, 0.5, 0)
                        Knob.Size = UDim2.new(0, 12, 0, 12)
                        Knob.ZIndex = 2
                        addCorner(Knob, 6)

                        local Hit = Instance.new("TextButton")
                        Hit.Name = "SliderHit"
                        Hit.Parent = Holder
                        Hit.BackgroundTransparency = 1
                        Hit.Position = UDim2.new(0.052941, 0, 0, 14)
                        Hit.Size = UDim2.new(0, 153, 0, 16)
                        Hit.Text = ""
                        Hit.AutoButtonColor = false

                        local function setValue(v, silent, instant)
                            v = math.clamp(v, min, max)
                            if isFloat then
                                v = tonumber(string.format("%.2f", v))
                            else
                                v = math.floor(v)
                            end
                            local scale = (v - min) / (max - min)
                            ValueLabel.Text = tostring(v)
                            if instant then
                                Fill.Size = UDim2.new(scale, 0, 1, 0)
                                Knob.Position = UDim2.new(scale, 0, 0.5, 0)
                            else
                                tween(Fill, TWEEN_SLIDE, { Size = UDim2.new(scale, 0, 1, 0) })
                                tween(Knob, TWEEN_SLIDE, { Position = UDim2.new(scale, 0, 0.5, 0) })
                            end
                            if not silent then
                                callback(v)
                            end
                        end

                        local function valueFromInput(input)
                            local scale = math.clamp((input.Position.X - Hit.AbsolutePosition.X) / Hit.AbsoluteSize.X, 0, 1)
                            return min + scale * (max - min)
                        end

                        Hit.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                dragging = true
                                setValue(valueFromInput(input))
                            end
                        end)

                        UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                dragging = false
                            end
                        end)

                        UserInputService.InputChanged:Connect(function(input)
                            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                                setValue(valueFromInput(input))
                            end
                        end)

                        setValue(default or min, true, true)
                        addElement(Holder)
                    end,

                    CreateColorPicker = function(_, label, defaultColor, callback)
                        local pickerOpen = false
                        local rainbowOn = false
                        local satConn, hueConn
                        local h, s, v = defaultColor:ToHSV()
                        local HSV = { H = h, S = s, V = v }

                        local Holder = makeHolder(stripSpaces(label) .. "ColorPickerHolder")
                        makeText(Holder, "ColorPickerTitle", label, UDim2.new(0.052941, 0, 0, 0), UDim2.new(0, 125, 0, ROW))

                        local Swatch = Instance.new("ImageButton")
                        Swatch.Name = "ColorPickerToggle"
                        Swatch.Parent = Holder
                        Swatch.BackgroundTransparency = 1
                        Swatch.Position = UDim2.new(0.822, 0, 0.167, 0)
                        Swatch.Size = UDim2.new(0, 22, 0, 20)
                        Swatch.AutoButtonColor = false
                        Swatch.Image = ROUND_IMG
                        Swatch.ImageColor3 = defaultColor
                        Swatch.ScaleType = Enum.ScaleType.Slice
                        Swatch.SliceCenter = Rect.new(100, 100, 100, 100)
                        Swatch.SliceScale = 0.04

                        local PickerPopup = Instance.new("ImageLabel")
                        PickerPopup.Name = "ColorPickerMain"
                        PickerPopup.Parent = Holder
                        PickerPopup.BackgroundTransparency = 1
                        PickerPopup.ClipsDescendants = true
                        PickerPopup.Position = UDim2.new(1, 8, 0, 0)
                        PickerPopup.Size = UDim2.new(0, 0, 0, 175)
                        PickerPopup.Image = ROUND_IMG
                        PickerPopup.ImageColor3 = BG_BODY
                        PickerPopup.ScaleType = Enum.ScaleType.Slice
                        PickerPopup.SliceCenter = Rect.new(100, 100, 100, 100)
                        PickerPopup.SliceScale = 0.05

                        local SatHolder = Instance.new("Frame")
                        SatHolder.Name = "SaturationHolder"
                        SatHolder.Parent = PickerPopup
                        SatHolder.BackgroundColor3 = BTN_GREY
                        SatHolder.BorderSizePixel = 0
                        SatHolder.ClipsDescendants = true
                        SatHolder.Position = UDim2.new(0, 7, 0, 6)
                        SatHolder.Size = UDim2.new(0, 122, 0, 114)
                        addCorner(SatHolder, 4)

                        local SatSurface = Instance.new("ImageButton")
                        SatSurface.Name = "SaturationSurface"
                        SatSurface.Parent = SatHolder
                        SatSurface.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1)
                        SatSurface.BorderSizePixel = 0
                        SatSurface.Size = UDim2.new(1, 0, 1, 0)
                        SatSurface.AutoButtonColor = false
                        SatSurface.Image = "rbxassetid://4805274903"

                        local SatMarker = Instance.new("Frame")
                        SatMarker.Name = "SaturationMarker"
                        SatMarker.Parent = SatHolder
                        SatMarker.AnchorPoint = Vector2.new(0.5, 0.5)
                        SatMarker.BackgroundTransparency = 1
                        SatMarker.Size = UDim2.new(0, 10, 0, 10)
                        SatMarker.Position = UDim2.new(HSV.S, 0, 1 - HSV.V, 0)
                        addCorner(SatMarker, 5)
                        local satStroke = Instance.new("UIStroke")
                        satStroke.Color = WHITE
                        satStroke.Thickness = 2
                        satStroke.Parent = SatMarker

                        local HueHolder = Instance.new("Frame")
                        HueHolder.Name = "HueHolder"
                        HueHolder.Parent = PickerPopup
                        HueHolder.BackgroundColor3 = BTN_GREY
                        HueHolder.BorderSizePixel = 0
                        HueHolder.ClipsDescendants = true
                        HueHolder.Position = UDim2.new(0, 136, 0, 6)
                        HueHolder.Size = UDim2.new(0, 28, 0, 114)
                        addCorner(HueHolder, 4)

                        local HueBar = Instance.new("ImageButton")
                        HueBar.Name = "HueBar"
                        HueBar.Parent = HueHolder
                        HueBar.BackgroundTransparency = 1
                        HueBar.Size = UDim2.new(1, 0, 1, 0)
                        HueBar.AutoButtonColor = false
                        HueBar.Image = "rbxassetid://4801885250"
                        HueBar.ScaleType = Enum.ScaleType.Crop

                        local HueMarker = Instance.new("Frame")
                        HueMarker.Name = "HueMarker"
                        HueMarker.Parent = HueHolder
                        HueMarker.AnchorPoint = Vector2.new(0.5, 0.5)
                        HueMarker.BackgroundColor3 = WHITE
                        HueMarker.BorderSizePixel = 0
                        HueMarker.Position = UDim2.new(0.5, 0, 1 - HSV.H, 0)
                        HueMarker.Size = UDim2.new(1, 6, 0, 4)

                        local LabelR = makeRgbLabel(PickerPopup, "ColorValueR", 7)
                        local LabelG = makeRgbLabel(PickerPopup, "ColorValueG", 60)
                        local LabelB = makeRgbLabel(PickerPopup, "ColorValueB", 114)

                        makeText(PickerPopup, "RainbowTitle", "Rainbow", UDim2.new(0, 7, 0, 143), UDim2.new(0, 120, 0, 20))
                        local RainbowBg = makeRound(PickerPopup, "RainbowToggle", UDim2.new(0, 140, 0, 143), UDim2.new(0, 20, 0, 20), BTN_GREY)
                        local RainbowDot = makeRound(RainbowBg, "RainbowDot", UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 4, 0, 4), ORANGE)
                        RainbowDot.AnchorPoint = Vector2.new(0.5, 0.5)
                        RainbowDot.ImageTransparency = 1
                        local RainbowHit = Instance.new("TextButton")
                        RainbowHit.Name = "RainbowHit"
                        RainbowHit.Parent = RainbowBg
                        RainbowHit.BackgroundTransparency = 1
                        RainbowHit.Size = UDim2.new(1, 0, 1, 0)
                        RainbowHit.Text = ""
                        RainbowHit.AutoButtonColor = false

                        local function updateLabels()
                            local c = Swatch.ImageColor3
                            LabelR.Text = "R: " .. math.floor(c.R * 255)
                            LabelG.Text = "G: " .. math.floor(c.G * 255)
                            LabelB.Text = "B: " .. math.floor(c.B * 255)
                        end

                        local function applyHSV()
                            local c = Color3.fromHSV(HSV.H, HSV.S, HSV.V)
                            Swatch.ImageColor3 = c
                            SatSurface.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1)
                            updateLabels()
                            callback(c)
                        end

                        local function getUV(frame)
                            local x = math.clamp((Mouse.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
                            local y = math.clamp((Mouse.Y - frame.AbsolutePosition.Y) / frame.AbsoluteSize.Y, 0, 1)
                            return x, y
                        end

                        local function stopSat()
                            if satConn then
                                satConn:Disconnect()
                                satConn = nil
                            end
                        end

                        local function stopHue()
                            if hueConn then
                                hueConn:Disconnect()
                                hueConn = nil
                            end
                        end

                        local function closePopup()
                            if not pickerOpen then
                                return
                            end
                            pickerOpen = false
                            stopSat()
                            stopHue()
                            tween(PickerPopup, TWEEN_SLOW, { Size = UDim2.new(0, 0, 0, 175) })
                            clipPopups(false)
                        end

                        local function setRainbow(on)
                            rainbowOn = on
                            tween(RainbowDot, TWEEN_MED, {
                                Size = on and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 4, 0, 4),
                                ImageTransparency = on and 0 or 1,
                            })
                            if on then
                                task.spawn(function()
                                    while rainbowOn do
                                        local c = Color3.fromHSV(hue, 1, 1)
                                        Swatch.ImageColor3 = c
                                        SatSurface.BackgroundColor3 = c
                                        updateLabels()
                                        callback(c)
                                        wait()
                                    end
                                end)
                            end
                        end

                        SatSurface.MouseButton1Down:Connect(function()
                            if rainbowOn then
                                return
                            end
                            stopSat()
                            satConn = RunService.RenderStepped:Connect(function()
                                local u, w = getUV(SatHolder)
                                HSV.S = u
                                HSV.V = 1 - w
                                SatMarker.Position = UDim2.new(u, 0, w, 0)
                                applyHSV()
                            end)
                        end)

                        HueBar.MouseButton1Down:Connect(function()
                            if rainbowOn then
                                return
                            end
                            stopHue()
                            hueConn = RunService.RenderStepped:Connect(function()
                                local _, w = getUV(HueHolder)
                                HSV.H = 1 - w
                                HueMarker.Position = UDim2.new(0.5, 0, w, 0)
                                applyHSV()
                            end)
                        end)

                        UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                stopSat()
                                stopHue()
                            end
                        end)

                        Swatch.MouseButton1Down:Connect(function()
                            if pickerOpen then
                                closePopup()
                            else
                                pickerOpen = true
                                clipPopups(true)
                                tween(PickerPopup, TWEEN_SLOW, { Size = UDim2.new(0, 171, 0, 175) })
                            end
                        end)

                        RainbowHit.MouseButton1Down:Connect(function()
                            setRainbow(not rainbowOn)
                        end)

                        registerCloser(closePopup)
                        updateLabels()
                        addElement(Holder)
                    end,

                    CreateButton = function(_, label, callback)
                        local Holder = makeHolder(stripSpaces(label) .. "ButtonHolder")
                        local Pill = makeRound(Holder, "Pill", PILL_POS, PILL_SIZE, BTN_GREY)
                        local Btn = Instance.new("TextButton")
                        Btn.Name = "Button"
                        Btn.Parent = Holder
                        Btn.BackgroundTransparency = 1
                        Btn.Position = PILL_POS
                        Btn.Size = PILL_SIZE
                        Btn.AutoButtonColor = false
                        Btn.Font = FONT
                        Btn.Text = label
                        Btn.TextColor3 = WHITE
                        Btn.TextSize = 13
                        hover(Btn, WHITE, ORANGE)
                        Btn.MouseButton1Down:Connect(function()
                            pressVisual(Pill, Btn, true)
                            callback(Btn)
                        end)
                        Btn.MouseButton1Up:Connect(function()
                            pressVisual(Pill, Btn, false)
                        end)
                        Btn.MouseLeave:Connect(function()
                            pressVisual(Pill, Btn, false)
                        end)
                        addElement(Holder)
                    end,

                    CreateTextbox = function(_, placeholder, callback)
                        local Holder = makeHolder(stripSpaces(placeholder) .. "TextBoxHolder")
                        local Pill = makeRound(Holder, "Pill", PILL_POS, PILL_SIZE, BTN_GREY)
                        local TB = Instance.new("TextBox")
                        TB.Name = "Input"
                        TB.Parent = Holder
                        TB.BackgroundTransparency = 1
                        TB.Position = PILL_POS
                        TB.Size = PILL_SIZE
                        TB.ClearTextOnFocus = false
                        TB.Font = FONT
                        TB.PlaceholderText = placeholder
                        TB.PlaceholderColor3 = Color3.new(0.6, 0.6, 0.6)
                        TB.Text = ""
                        TB.TextColor3 = WHITE
                        TB.TextSize = 13
                        TB.TextXAlignment = Enum.TextXAlignment.Left
                        local pad = Instance.new("UIPadding")
                        pad.PaddingLeft = UDim.new(0, 6)
                        pad.Parent = TB
                        TB.Focused:Connect(function()
                            tween(Pill, TWEEN_FAST, { ImageColor3 = ORANGE })
                        end)
                        TB.FocusLost:Connect(function(enterPressed)
                            tween(Pill, TWEEN_FAST, { ImageColor3 = BTN_GREY })
                            if enterPressed then
                                callback(TB.Text)
                            end
                        end)
                        addElement(Holder)
                    end,

                    CreateDropdown = function(_, label, options, defaultIndex, callback)
                        local selected = options[defaultIndex or 1]
                        local isOpen = false
                        local rowHeight = 25
                        local dropHeight = math.min(#options, 4) * rowHeight

                        local Holder = makeHolder(stripSpaces(label) .. "DropdownHolder")
                        makeRound(Holder, "Pill", PILL_POS, PILL_SIZE, BTN_GREY)

                        local DisplayLabel = Instance.new("TextLabel")
                        DisplayLabel.Name = "DropdownTitle"
                        DisplayLabel.Parent = Holder
                        DisplayLabel.BackgroundTransparency = 1
                        DisplayLabel.Position = PILL_POS
                        DisplayLabel.Size = PILL_SIZE
                        DisplayLabel.Font = FONT
                        DisplayLabel.Text = selected
                        DisplayLabel.TextColor3 = WHITE
                        DisplayLabel.TextSize = 13
                        DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
                        local pad = Instance.new("UIPadding")
                        pad.PaddingLeft = UDim.new(0, 6)
                        pad.Parent = DisplayLabel

                        local ArrowLbl = Instance.new("TextLabel")
                        ArrowLbl.Name = "DropdownArrow"
                        ArrowLbl.Parent = DisplayLabel
                        ArrowLbl.BackgroundTransparency = 1
                        ArrowLbl.AnchorPoint = Vector2.new(0.5, 0.5)
                        ArrowLbl.Position = UDim2.new(1, -12, 0.5, 0)
                        ArrowLbl.Size = UDim2.new(0, 16, 0, 16)
                        ArrowLbl.Font = FONT
                        ArrowLbl.Text = "v"
                        ArrowLbl.TextColor3 = WHITE
                        ArrowLbl.TextSize = 13

                        local Popup = Instance.new("ImageLabel")
                        Popup.Name = "DropdownMain"
                        Popup.Parent = DisplayLabel
                        Popup.BackgroundTransparency = 1
                        Popup.ClipsDescendants = true
                        Popup.Position = UDim2.new(1, 8, 0, 0)
                        Popup.Size = UDim2.new(0, 0, 0, dropHeight)
                        Popup.Image = ROUND_IMG
                        Popup.ImageColor3 = BG_BODY
                        Popup.ScaleType = Enum.ScaleType.Slice
                        Popup.SliceCenter = Rect.new(100, 100, 100, 100)
                        Popup.SliceScale = 0.04

                        local Scroll = Instance.new("ScrollingFrame")
                        Scroll.Name = "Options"
                        Scroll.Parent = Popup
                        Scroll.BackgroundTransparency = 1
                        Scroll.BorderSizePixel = 0
                        Scroll.Size = UDim2.new(0, 153, 0, dropHeight)
                        Scroll.CanvasSize = UDim2.new(0, 0, 0, #options * rowHeight)
                        Scroll.ScrollBarThickness = 3
                        Scroll.ScrollBarImageColor3 = ORANGE
                        Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
                        Scroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
                        Scroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

                        local ScrollLayout = Instance.new("UIListLayout")
                        ScrollLayout.Parent = Scroll
                        ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

                        local function closeDropdown()
                            if not isOpen then
                                return
                            end
                            isOpen = false
                            DisplayLabel.Text = selected
                            tween(ArrowLbl, TWEEN_MED, { Rotation = 0 })
                            tween(DisplayLabel, TWEEN_MED, { TextColor3 = WHITE })
                            tween(Popup, TWEEN_MED, { Size = UDim2.new(0, 0, 0, dropHeight) })
                            clipPopups(false)
                        end

                        local function openDropdown()
                            if isOpen then
                                return
                            end
                            isOpen = true
                            DisplayLabel.Text = label
                            tween(ArrowLbl, TWEEN_MED, { Rotation = 180 })
                            tween(DisplayLabel, TWEEN_MED, { TextColor3 = ORANGE })
                            tween(Popup, TWEEN_MED, { Size = UDim2.new(0, 153, 0, dropHeight) })
                            clipPopups(true)
                        end

                        for i, optionText in ipairs(options) do
                            local OptionBtn = Instance.new("TextButton")
                            OptionBtn.Name = stripSpaces(optionText) .. "Option"
                            OptionBtn.Parent = Scroll
                            OptionBtn.BackgroundColor3 = BTN_GREY
                            OptionBtn.BackgroundTransparency = 1
                            OptionBtn.BorderSizePixel = 0
                            OptionBtn.LayoutOrder = i
                            OptionBtn.Size = UDim2.new(0, 153, 0, rowHeight)
                            OptionBtn.AutoButtonColor = false
                            OptionBtn.Font = FONT
                            OptionBtn.Text = optionText
                            OptionBtn.TextColor3 = WHITE
                            OptionBtn.TextSize = 13
                            OptionBtn.MouseEnter:Connect(function()
                                tween(OptionBtn, TWEEN_FAST, { BackgroundTransparency = 0.5, TextColor3 = ORANGE })
                            end)
                            OptionBtn.MouseLeave:Connect(function()
                                tween(OptionBtn, TWEEN_FAST, { BackgroundTransparency = 1, TextColor3 = WHITE })
                            end)
                            OptionBtn.MouseButton1Down:Connect(function()
                                selected = optionText
                                callback(optionText)
                                closeDropdown()
                            end)
                        end

                        local Hit = Instance.new("TextButton")
                        Hit.Name = "DropdownHit"
                        Hit.Parent = Holder
                        Hit.BackgroundTransparency = 1
                        Hit.Position = PILL_POS
                        Hit.Size = PILL_SIZE
                        Hit.Text = ""
                        Hit.AutoButtonColor = false
                        Hit.MouseButton1Down:Connect(function()
                            if isOpen then
                                closeDropdown()
                            else
                                openDropdown()
                            end
                        end)

                        registerCloser(closeDropdown)
                        addElement(Holder)
                    end,
                }
            end,
        }
    end,
}
