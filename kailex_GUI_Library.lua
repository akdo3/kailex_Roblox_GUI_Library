--[[

    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
    ▒															 	▒
    ▒	                                                    		▒
    ▒   	██╗  ██╗  █████╗  ██╗ ██╗      ███████╗ ██╗  ██╗		▒
    ▒   	██║ ██╔╝ ██╔══██╗ ██║ ██║      ██╔════╝ ╚██╗██╔╝        ▒
    ▒   	█████╔╝  ███████║ ██║ ██║      █████╗    ╚███╔╝         ▒
    ▒   	██╔═██╗  ██╔══██║ ██║ ██║      ██╔══╝    ██╔██╗         ▒
    ▒   	██║  ██╗ ██║  ██║ ██║ ███████╗ ███████╗ ██╔╝ ██╗        ▒
    ▒   	╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝ ╚══════╝ ╚══════╝ ╚═╝  ╚═╝        ▒
    ▒                                                            	▒
    ▒   	------------------------------------------------	 	▒
    ▒            MADE BY ME(AKDO) | KAILEX UI LIBRARY         	 	▒
    ▒   	------------------------------------------------		▒
    ▒                                                            	▒
    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

]]

local cloneref = cloneref or function(obj) return obj end
local newcclosure = newcclosure or function(f) return f end
local Services = setmetatable({}, {
	__index = function(_, k) 
		return cloneref(game:GetService(k)) 
	end
})

local Players, CoreGui, GuiService = Services.Players, Services.CoreGui, Services.GuiService
local SoundService, TextService, TweenService, UserInputService, RunService = Services.SoundService, Services.TextService, Services.TweenService, Services.UserInputService, Services.RunService

local v2n, v2z = Vector2.new, Vector2.zero
local v3n, v3z = Vector3.new, Vector3.zero
local cfn, cfa = CFrame.new, CFrame.Angles
local clamp, floor, rad, random, sqrt = math.clamp, math.floor, math.rad, math.random, math.sqrt
local huge = math.huge
local ti_new = TweenInfo.new
local find, lower, format = string.find, string.lower, string.format
local t_insert, t_remove, t_find, t_clear = table.insert, table.remove, table.find, table.clear
local inst_new = Instance.new
local udim2_new, udim2_off = UDim2.new, UDim2.fromOffset
local rgb = Color3.fromRGB

local U2n, U2s, U2o = UDim2.new, UDim2.fromScale, UDim2.fromOffset
local V2n = Vector2.new
local C3r, C3n = Color3.fromRGB, Color3.new
local EnumSort = Enum.SortOrder.LayoutOrder
local EnumFill = Enum.FillDirection.Horizontal
local EnumAlignX = Enum.TextXAlignment.Left
local EnumAlignY = Enum.VerticalAlignment.Center
local EnumTouch = Enum.UserInputType.Touch
local EnumMouse1 = Enum.UserInputType.MouseButton1
local EnumMouseMove = Enum.UserInputType.MouseMovement

local SafeParent = (function()
	local s, r = pcall(function() return gethui and gethui() end)
	if s and r then return r end
	local s2, r2 = pcall(function() return game:GetService("CoreGui") end)
	if s2 and r2 then return r2 end
	local s3, r3 = pcall(function() return game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui") end)
	if s3 and r3 then return r3 end
	return game:GetService("CoreGui")
end)()

local function GenerateRandomName(length)
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local name = ""
	for _ = 1, length or random(8, 16) do
		local r = random(1, #chars)
		name = name .. chars:sub(r, r)
	end
	return name
end

local function Create(class, props)
	local inst = inst_new(class)
	inst.Name = GenerateRandomName()

	local prnt = props.Parent
	props.Parent = nil

	local children = {}
	local cCount = 0

	for k, v in next, props do
		if type(k) == "number" then
			cCount = cCount + 1
			children[cCount] = v
		else
			inst[k] = v
		end
	end

	for i = 1, cCount do
		children[i].Parent = inst
	end

	if prnt then
		inst.Parent = prnt
	end

	return inst
end

local function PlayTween(inst, info, props, cb)
	if not inst or not inst.Parent then return end
	local t = TweenService:Create(inst, info, props)
	t:Play()

	local connection
	connection = t.Completed:Connect(function(playbackState)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		pcall(function() t:Destroy() end)
		if cb and playbackState == Enum.PlaybackState.Completed then 
			task.spawn(cb)
		end
	end)

	task.spawn(function()
		while inst and inst.Parent and t.PlaybackState == Enum.PlaybackState.Playing do
			task.wait()
		end
		if (not inst or not inst.Parent) and connection then
			connection:Disconnect()
			connection = nil
			pcall(function() t:Destroy() end)
		end
	end)

	return t
end

local kailex = {
	Setting = {
		Layout = {
			ButtonSizeY = 28,
			Padding = UDim.new(0, 14),
			ElementCorner = UDim.new(0, 8),
			WindowCorner = UDim.new(0, 14),
			ButtonSize = U2n(0.96, 0, 0, 28),
			ButtonPOS = U2n(0.02, 0, 0, 0),
			TextSize = {
				Full = U2n(1, 0, 1, 0),
				WithIcon = U2n(0.9, 0, 1, 0),
				WithTwoIcons = U2n(0.8, 0, 1, 0)
			}
		},
		Theme = {
			Transparency = 0.1,
			BackgroundColor = C3r(10, 10, 14),
			TextColor = C3r(245, 245, 255),
			BorderColor = C3r(45, 45, 60),
			AccentColor = C3r(18, 18, 26),
			NotificationsMainColor = C3r(110, 150, 255),
			ButtonColor = C3r(20, 20, 28),
			ErrorColor = C3r(255, 90, 100),
			TabUnderLineColor = C3r(110, 150, 255),
			Toggle = {
				ToggleOnColor = C3r(110, 150, 255),
				ToggleOffColor = C3r(30, 30, 40),
				ToggleOnBorderColor = C3r(130, 170, 255),
				ToggleOffBorderColor = C3r(55, 55, 75)
			},
			confirmationFrame = {
				Transparency = 0.05,
				BackgroundColor = C3r(12, 12, 18),
				TextColor = C3r(255, 255, 255),
				BorderColor = C3r(110, 150, 255),
				ButtonColor = C3r(24, 24, 34),
				ButtonHoverColor = C3r(36, 36, 48)
			}
		},
		Animation = {
			TweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), Fast = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			Hover = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), MaximizeButton = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			MinimizeButton = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), titleButton = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		},
		Components = {
			InfoImage = {
				ImageSize = U2n(0.1, 0, 1, 0),
				InfoImagePOS = U2n(0.9, 0, 0, 0),
				InfoImageId = "http://www.roblox.com/asset/?id=6026568210"
			}
		},
		Audio = {
			Hover 		= "rbxassetid://6895056269",
			Click 		= "rbxassetid://6895058005",
			ToggleOn 	= "rbxassetid://6895049796",
			ToggleOff 	= "rbxassetid://6895049969",
			Slider 		= "",
			Dropdown 	= "",
			Error 		= "rbxassetid://6895080068",
		},
		Info = false,
		Sounds = false,
	}
}

local Setting = kailex.Setting
local Theme, Layout, Animation, Audio = Setting.Theme, Setting.Layout, Setting.Animation, Setting.Audio
local TextSize, tTheme, InfoImage = Layout.TextSize, Theme.Toggle, Setting.Components.InfoImage
local SharedTweens = {
	HoverIn     = TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
	HoverOut    = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
	Fast        = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	NormalOut   = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	SlowOut     = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
	BackIn      = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
	BackOut     = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

function kailex:UpdateTheme(newThemeSettings)
	if not self.CurrentScreenGui then return end

	local oldTheme = {}
	for k, v in pairs(kailex.Setting.Theme) do
		oldTheme[k] = v
	end

	for k, v in pairs(newThemeSettings) do
		if type(v) == "table" and kailex.Setting.Theme[k] then
			for subK, subV in pairs(v) do
				kailex.Setting.Theme[k][subK] = subV
			end
		else
			kailex.Setting.Theme[k] = v
		end
	end

	local function UpdateElementColors(element)
		pcall(function()
			for key, oldColor in pairs(oldTheme) do
				if typeof(oldColor) == "Color3" then
					local newColor = newThemeSettings[key]
					if not newColor then continue end

					if element:IsA("GuiObject") and element.BackgroundColor3 == oldColor then
						TweenService:Create(element, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
					end

					if (element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox")) and element.TextColor3 == oldColor then
						TweenService:Create(element, TweenInfo.new(0.3), {TextColor3 = newColor}):Play()
					end

					if element:IsA("UIStroke") and element.Color == oldColor then
						TweenService:Create(element, TweenInfo.new(0.3), {Color = newColor}):Play()
					end

					if (element:IsA("ImageLabel") or element:IsA("ImageButton")) and element.ImageColor3 == oldColor then
						TweenService:Create(element, TweenInfo.new(0.3), {ImageColor3 = newColor}):Play()
					end
				end
			end
		end)
	end

	for _, child in pairs(self.CurrentScreenGui:GetDescendants()) do
		UpdateElementColors(child)
	end
end

local CachedSound = Create("Sound", {Parent = SoundService})

local function PlayInteractSound(audioType)
	if kailex.Setting.Sounds then
		CachedSound.SoundId = kailex.Setting.Audio[audioType] or kailex.Setting.Audio.Click
		SoundService:PlayLocalSound(CachedSound)
	end	
end

local ripplePool = {}
local rippleCount = 0

local function GetRipple()
	for i = 1, rippleCount do
		local r = ripplePool[i]
		if not r.Visible then
			return r
		end
	end

	local r = inst_new("Frame")
	r.BackgroundColor3 = rgb(255, 255, 255)
	r.ZIndex = 100
	r.AnchorPoint = v2n(0.5, 0.5)
	r.Visible = false

	local corner = inst_new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = r

	rippleCount = rippleCount + 1
	ripplePool[rippleCount] = r
	return r
end

local function ApplyRipple(tgt)
	if not tgt or not tgt.Parent then return end
	local s = pcall(function() return tgt.Parent end)
	if not s then return end

	local m = UserInputService:GetMouseLocation()
	local ins = GuiService:GetGuiInset()
	local absPos = tgt.AbsolutePosition
	local absSize = tgt.AbsoluteSize
	local targetSize = sqrt((absSize.X * absSize.X) + (absSize.Y * absSize.Y)) * 1.2

	local rpl = GetRipple()
	rpl.Position = udim2_off((m.X - ins.X) - absPos.X, (m.Y - ins.Y) - absPos.Y)
	rpl.Size = udim2_off(0, 0)
	rpl.BackgroundTransparency = 0.5
	rpl.ZIndex = tgt.ZIndex + 1

	local success = pcall(function()
		rpl.Parent = tgt
		rpl.Visible = true
	end)
	if not success then
		rpl.Visible = false
		return
	end

	tgt.ClipsDescendants = true

	Create("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.8, 0.5),
			NumberSequenceKeypoint.new(1, 1)
		}),
		Parent = rpl
	})

	local t = TweenService:Create(rpl, ti_new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = udim2_off(targetSize, targetSize)
	})

	local tAlpha = TweenService:Create(rpl, ti_new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	})

	t:Play()
	tAlpha:Play()

	local conn
	conn = t.Completed:Connect(function()
		conn:Disconnect()
		rpl:ClearAllChildren()
		rpl.Visible = false
		rpl.Parent = nil
		t:Destroy()
		tAlpha:Destroy()
	end)
end

hoverTweenInfo = ti_new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
scaleTweenInfo = ti_new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
GlobalDragState = false

local function ApplyHover(hit, tgt, hCol, dCol)
	local strk = tgt:FindFirstChildOfClass("UIStroke")

	local originalThick = strk and strk.Thickness or 0
	local originalCol = strk and strk.Color or Color3.new(1, 1, 1)
	local originalTrans = strk and strk.Transparency or 0

	local isHovering, isPressed = false, false
	local activeTween, activeStrkTween

	local function updateVisuals()
		local col = isPressed and dCol or (isHovering and hCol or dCol)

		if activeTween then activeTween:Cancel() activeTween:Destroy() end
		activeTween = TweenService:Create(tgt, hoverTweenInfo, {BackgroundColor3 = col})
		activeTween:Play()

		if strk then
			local s = isHovering or isPressed

			if activeStrkTween then activeStrkTween:Cancel() activeStrkTween:Destroy() end

			activeStrkTween = TweenService:Create(strk, hoverTweenInfo, {
				Thickness = s and originalThick + 0.5 or originalThick,
				Transparency = s and math.clamp(originalTrans - 0.3, 0, 1) or originalTrans,
				Color = s and Color3.new(
					math.clamp(originalCol.R + 0.15, 0, 1), 
					math.clamp(originalCol.G + 0.15, 0, 1), 
					math.clamp(originalCol.B + 0.15, 0, 1)
				) or originalCol
			})

			activeStrkTween:Play()
		end
	end

	local conns = {}
	t_insert(conns, hit.MouseEnter:Connect(function()
		if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then return end
		isHovering = true
		PlayInteractSound("Hover")
		updateVisuals()
	end))

	t_insert(conns, hit.MouseLeave:Connect(function()
		isHovering = false
		isPressed = false
		updateVisuals()
	end))

	t_insert(conns, hit.InputBegan:Connect(function(inp)
		local t = inp.UserInputType
		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			isPressed = true
			updateVisuals()
		end
	end))

	t_insert(conns, hit.InputEnded:Connect(function(inp)
		local t = inp.UserInputType
		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			isPressed = false
			updateVisuals()
		end
	end))

	return function()
		for i = 1, #conns do conns[i]:Disconnect() end
		t_clear(conns)
		if activeTween then activeTween:Cancel() activeTween:Destroy() end
		if activeStrkTween then activeStrkTween:Cancel() activeStrkTween:Destroy() end
	end
end

local function GetCorner()
	return Create("UICorner", {CornerRadius = Layout.ElementCorner})
end

local function GetStroke(trans, applyMode)
	return Create("UIStroke", {Thickness = 1.5, Color = Theme.BorderColor, Transparency = trans or 0.6, ApplyStrokeMode = applyMode or Enum.ApplyStrokeMode.Contextual})
end

local function GetAdaptiveSize(scaleX, scaleY)
	local viewport = workspace.CurrentCamera.ViewportSize
	local isMobile = viewport.X < 800
	return UDim2.new(
		scaleX.Scale, scaleX.Offset + (isMobile and 10 or 0),
		scaleY.Scale, scaleY.Offset + (isMobile and 5 or 0)
	)
end

local function ApplyShadow(target, intensity, size)
	local shadow = Create("ImageLabel", {
		Name = "DropShadow",
		BackgroundTransparency = 1,
		Image = "rbxassetid://6015897843",
		ImageColor3 = C3n(0, 0, 0),
		ImageTransparency = intensity or 0.4,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		Size = U2n(1, size or 40, 1, size or 40),
		Position = U2n(0.5, 0, 0.5, 2),
		AnchorPoint = V2n(0.5, 0.5),
		ZIndex = target.ZIndex - 1,
		Parent = target
	})
	return shadow
end

local function CreateBaseComp(parent)
	return Create("Frame", {
		Size = Layout.ButtonSize,
		BackgroundColor3 = Theme.ButtonColor,
		BackgroundTransparency = Theme.Transparency + 0.2,
		ClipsDescendants = false,
		Parent = parent,
		GetCorner(),
		GetStroke(),
		Create("UIPadding", {PaddingLeft = UDim.new(0.02, 0), PaddingRight = UDim.new(0.02, 0)}),
		Create("UIListLayout", {Padding = UDim.new(0.02, 0), FillDirection = EnumFill, SortOrder = EnumSort, VerticalAlignment = EnumAlignY})
	})
end

local function CreateLabeledBase(parent, name, sizeX)
	local baseFrame = CreateBaseComp(parent)
	local btn = Create("TextButton", {
		Size = U2s(sizeX or 0.813, 1),
		BackgroundTransparency = 1,
		Position = Layout.ButtonPOS,
		Text = name or "Element",
		TextColor3 = Theme.TextColor,
		TextScaled = true,
		TextXAlignment = EnumAlignX,
		AutoButtonColor = false,
		ZIndex = 3,
		Parent = baseFrame,
		Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill})
	})
	return baseFrame, btn
end

local function MakeDraggable(el, tgt)
	local dragging = false
	local dragInput, mousePos, framePos

	el.InputBegan:Connect(function(input)
		if input.UserInputType == EnumMouse1 or input.UserInputType == EnumTouch then
			dragging = true
			dragInput = input
			mousePos = input.Position
			framePos = tgt.Position

			local endConn
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if endConn then endConn:Disconnect() end
				end
			end)
		end
	end)

	el.InputChanged:Connect(function(input)
		if input.UserInputType == EnumMouseMove or input.UserInputType == EnumTouch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			local targetPos = udim2_new(
				framePos.X.Scale, framePos.X.Offset + delta.X,
				framePos.Y.Scale, framePos.Y.Offset + delta.Y
			)
			TweenService:Create(tgt, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = targetPos}):Play()
		end
	end)
end

function kailex:createFrame(title, buttontxt)
	pcall(function() if not game:IsLoaded() then game.Loaded:Wait() end end)
	task.wait(0.5)

	local LibraryConnections = {}
	local function Track(c) table.insert(LibraryConnections, c) return c end

	local ScreenGui = Create("ScreenGui", {
		IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 100, Parent = SafeParent 
	})

	kailex.CurrentScreenGui = ScreenGui

	local Frame = Create("Frame", {
		Position = U2s(0.5, 0.5), AnchorPoint = V2n(0.5, 0.5), Size = U2s(0.35, 0.6), 
		BackgroundColor3 = Theme.BackgroundColor, BackgroundTransparency = 1, Visible = false, Parent = ScreenGui, 
		Create("UISizeConstraint", { MaxSize = V2n(800, 600), MinSize = V2n(200, 200) }), 
		Create("UICorner", { CornerRadius = Layout.WindowCorner }),
		Create("UIGradient", { Rotation = 35, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C3n(1, 1, 1)), ColorSequenceKeypoint.new(0.5, C3n(0.85, 0.85, 0.85)), ColorSequenceKeypoint.new(1, C3n(0.6, 0.6, 0.6)) }) })
	})

	local FrameStroke = Create("UIStroke", { Thickness = 1.5, Color = Theme.TabUnderLineColor, Transparency = 1, Parent = Frame })

	local Blur = Instance.new("BlurEffect")
	Blur.Size = 0
	Blur.Parent = game:GetService("Lighting")

	local fScale = Create("UIScale", {Scale = 0.85, Parent = Frame})
	local fShadow = ApplyShadow(Frame, 0.5, 50)
	fShadow.ImageTransparency = 1

	local InteractionBlocker = Create("TextButton", { Size = U2s(1, 1), BackgroundTransparency = 1, Text = "", Visible = false, ZIndex = 9999, Parent = Frame })
	local ContentClipper = Create("CanvasGroup", { Size = U2s(1, 1), BackgroundTransparency = 1, GroupTransparency = 1, Parent = Frame, Create("UICorner", { CornerRadius = Layout.WindowCorner }) })

	local Header = Create("Frame", { 
		Size = U2s(1, 0.125), Position = U2s(0, -0.15), BackgroundColor3 = Theme.AccentColor, BackgroundTransparency = Theme.Transparency, Active = true, Parent = ContentClipper, Create("UICorner", { CornerRadius = Layout.WindowCorner }) 
	})

	local HeaderLine = Create("Frame", { Size = U2n(1, 0, 0, 1), Position = U2n(0, 0, 1, 0), BackgroundColor3 = Theme.BorderColor, BorderSizePixel = 0, Parent = Header, Create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }) }) })
	MakeDraggable(Header, Frame)

	local SidebarToggleBtn = Create("TextButton", { Size = U2s(0.06, 1), Position = U2s(0.02, 0), BackgroundTransparency = 1, Text = "≡", Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Theme.TextColor, Parent = Header })
	local titleLbl = Create("TextLabel", { Size = U2s(0.5, 0.6), Position = U2s(0.09, 0.2), Text = title or "kailex", TextColor3 = Theme.TextColor, TextScaled = true, TextXAlignment = EnumAlignX, BackgroundTransparency = 1, Parent = Header })

	local SearchContainer = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(0.82, 0, 0.5, 0), Size = UDim2.new(0.06, 0, 0.75, 0), BackgroundColor3 = Theme.AccentColor, BackgroundTransparency = 1, ClipsDescendants = true, Parent = Header, Create("UICorner", {CornerRadius = UDim.new(0.3, 0)}) })
	local SCUIS = Create("UIStroke", { Thickness = 1.5, Color = Theme.BorderColor, Transparency = 1, Parent = SearchContainer })
	local SearchIconBtn = Create("ImageButton", { AnchorPoint = V2n(1, 0.5), Position = U2s(0.95, 0.5), Size = U2n(0, 18, 0, 18), BackgroundTransparency = 1, Image = "rbxassetid://6031154871", ImageColor3 = Theme.TextColor, Parent = SearchContainer })
	local SearchInputFrame = Create("TextBox", { Size = U2s(0.75, 0.9), Position = U2s(0.05, 0.05), BackgroundTransparency = 1, PlaceholderText = "Search...", Text = "", TextColor3 = Theme.TextColor, TextScaled = true, TextXAlignment = EnumAlignX, ClearTextOnFocus = false, Visible = false, Parent = SearchContainer })

	local InteractionBlocker = Create("TextButton", { Size = U2s(1, 1), BackgroundTransparency = 1, Text = "", Visible = false, ZIndex = 9999, Parent = Frame })
	local ContentClipper = Create("Frame", { Size = U2s(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Parent = Frame, Create("UICorner", { CornerRadius = Layout.WindowCorner }) })

	local Header = Create("Frame", { 
		Size = U2s(1, 0.125), Position = U2s(0, -0.15), BackgroundColor3 = Theme.AccentColor, BackgroundTransparency = 1, Active = true, Parent = ContentClipper, Create("UICorner", { CornerRadius = Layout.WindowCorner }) 
	})

	local HeaderLine = Create("Frame", { Size = U2n(1, 0, 0, 1), Position = U2n(0, 0, 1, 0), BackgroundColor3 = Theme.BorderColor, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = Header, Create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }) }) })
	MakeDraggable(Header, Frame)

	local SidebarToggleBtn = Create("TextButton", { Size = U2s(0.06, 1), Position = U2s(0.02, 0), BackgroundTransparency = 1, Text = "≡", Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Theme.TextColor, TextTransparency = 1, Parent = Header })
	local titleLbl = Create("TextLabel", { Size = U2s(0.5, 0.6), Position = U2s(0.09, 0.2), Text = title or "kailex", TextColor3 = Theme.TextColor, TextScaled = true, TextXAlignment = EnumAlignX, BackgroundTransparency = 1, TextTransparency = 1, Parent = Header })

	local SearchContainer = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(0.82, 0, 0.5, 0), Size = UDim2.new(0.06, 0, 0.75, 0), BackgroundColor3 = Theme.AccentColor, BackgroundTransparency = 1, ClipsDescendants = true, Parent = Header, Create("UICorner", {CornerRadius = UDim.new(0.3, 0)}) })
	local SCUIS = Create("UIStroke", { Thickness = 1.5, Color = Theme.BorderColor, Transparency = 1, Parent = SearchContainer })
	local SearchIconBtn = Create("ImageButton", { AnchorPoint = V2n(1, 0.5), Position = U2s(0.95, 0.5), Size = U2n(0, 18, 0, 18), BackgroundTransparency = 1, Image = "rbxassetid://6031154871", ImageColor3 = Theme.TextColor, ImageTransparency = 1, Parent = SearchContainer })
	local SearchInputFrame = Create("TextBox", { Size = U2s(0.75, 0.9), Position = U2s(0.05, 0.05), BackgroundTransparency = 1, PlaceholderText = "Search...", Text = "", TextColor3 = Theme.TextColor, TextScaled = true, TextXAlignment = EnumAlignX, ClearTextOnFocus = false, Visible = false, Parent = SearchContainer })

	Frame.Visible = true
	TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = Theme.Transparency}):Play()
	TweenService:Create(FrameStroke, TweenInfo.new(0.6), {Transparency = 0.6}):Play()
	TweenService:Create(fScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	TweenService:Create(fShadow, TweenInfo.new(0.6), {ImageTransparency = 0.5}):Play()
	TweenService:Create(Blur, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = 0}):Play()

	task.delay(0.8, function() Blur:Destroy() end)

	task.wait(0.2)
	TweenService:Create(Header, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = U2s(0, 0), BackgroundTransparency = Theme.Transparency}):Play()
	TweenService:Create(HeaderLine, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()

	task.wait(0.15)
	TweenService:Create(SidebarToggleBtn, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	TweenService:Create(SearchIconBtn, TweenInfo.new(0.4), {ImageTransparency = 0}):Play()

	local InteractionBlocker = Create("TextButton", {
		Size = U2s(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		Visible = false,
		ZIndex = 9999,
		Parent = Frame
	})

	local ContentClipper = Create("Frame", {
		Size = U2s(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = Frame,
		Create("UICorner", { CornerRadius = Layout.WindowCorner })
	})

	local Header = Create("Frame", { 
		Size = U2s(1, 0.125), 
		BackgroundColor3 = Theme.AccentColor, 
		BackgroundTransparency = Theme.Transparency,
		Active = true,
		Parent = ContentClipper, 
		Create("UICorner", { CornerRadius = Layout.WindowCorner }) 
	})

	Create("Frame", {
		Size = U2n(1, 0, 0, 1),
		Position = U2n(0, 0, 1, 0),
		BackgroundColor3 = Theme.BorderColor,
		BorderSizePixel = 0,
		Parent = Header,
		Create("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(1, 1)
			})
		})
	})

	MakeDraggable(Header, Frame)

	local SidebarToggleBtn = Create("TextButton", {
		Size = U2s(0.06, 1),
		Position = U2s(0.02, 0),
		BackgroundTransparency = 1,
		Text = "≡",
		Font = Enum.Font.GothamBold,
		TextScaled = true,
		TextColor3 = Theme.TextColor,
		Parent = Header
	})

	local title = Create("TextLabel", { 
		Size = U2s(0.5, 0.6), 
		Position = U2s(0.09, 0.2), 
		Text = title or "kailex", 
		TextColor3 = Theme.TextColor, 
		TextScaled = true, 
		TextXAlignment = EnumAlignX, 
		BackgroundTransparency = 1,
		Parent = Header 
	})

	local SearchContainer = Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(0.82, 0, 0.5, 0),
		Size = UDim2.new(0.06, 0, 0.75, 0),
		BackgroundColor3 = Theme.AccentColor,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = Header,
		Create("UICorner", {CornerRadius = UDim.new(0.3, 0)}),
	})

	local SCUIS = Create("UIStroke", {
		Thickness = 1.5,
		Color = Theme.BorderColor,
		Transparency = 1,
		Parent = SearchContainer,
	})

	local SearchIconBtn = Create("ImageButton", {
		AnchorPoint = V2n(1, 0.5), Position = U2s(0.95, 0.5), Size = U2n(0, 18, 0, 18),
		BackgroundTransparency = 1, Image = "rbxassetid://6031154871", ImageColor3 = Theme.TextColor, Parent = SearchContainer
	})
	local SearchInputFrame = Create("TextBox", {
		Size = U2s(0.75, 0.9), Position = U2s(0.05, 0.05), BackgroundTransparency = 1,
		PlaceholderText = "Search...", Text = "", TextColor3 = Theme.TextColor, TextScaled = true,
		TextXAlignment = EnumAlignX, ClearTextOnFocus = false, Visible = false, Parent = SearchContainer
	})

	local searchExpanded = false
	local function ToggleSearch(force)
		searchExpanded = force ~= nil and force or not searchExpanded
		PlayInteractSound()
		if searchExpanded then
			SearchInputFrame.Visible = true
			PlayTween(title, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
			PlayTween(SearchContainer, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.65, 0, 0.75, 0), BackgroundTransparency = 0.1})
			PlayTween(SCUIS, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.15, Color = Theme.Toggle.ToggleOnColor})
			PlayTween(SearchInputFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0})
			SearchInputFrame:CaptureFocus()
		else
			SearchInputFrame.Text = ""
			PlayTween(title, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0})
			PlayTween(SearchContainer, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = U2s(0.06, 0.75), BackgroundTransparency = 1})
			PlayTween(SCUIS, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 1, Color = Theme.BorderColor})
			PlayTween(SearchInputFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}, function()
				if not searchExpanded then SearchInputFrame.Visible = false end
			end)
		end
	end

	Track(SearchIconBtn.MouseButton1Click:Connect(function() ToggleSearch(not searchExpanded) end))
	Track(SearchInputFrame.FocusLost:Connect(function() if SearchInputFrame.Text == "" then ToggleSearch(false) end end))

	local MinimizedContainer = Create("Frame", {
		Size = U2s(0.1, 0.08),
		AnchorPoint = V2n(0.5, 0.5),
		Position = U2s(0.5, 0.5),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 1000,
		Parent = ScreenGui
	})

	local MinimizedButton = Create("TextButton", {
		Size = U2s(1, 1),
		Position = U2s(0.5, 0.5),
		AnchorPoint = V2n(0.5, 0.5),
		BackgroundColor3 = C3n(0, 0, 0),
		BackgroundTransparency = 0.3,
		Font = Enum.Font.GothamBlack,
		Text = buttontxt or title or "kailex",
		TextColor3 = Theme.TextColor,
		Active = true,
		TextScaled = true,
		TextTransparency = 1,
		Parent = MinimizedContainer,
		Create("UIStroke", { Thickness = 1.5, Color = C3n(0,0,0) }),
		Create("UICorner", { CornerRadius = UDim.new(0.2, 0) })
	})

	MakeDraggable(MinimizedButton, MinimizedContainer)

	local HeaderButtonsList = {}
	local function CreateHeaderBtn(sym, pos, color, cb)
		local btn = Create("TextButton", {
			Size = U2s(0.066, 1),
			Position = U2s(pos, -0.8),
			BackgroundTransparency = 1,
			Text = sym,
			Font = Enum.Font.GothamBold,
			TextScaled = true,
			TextColor3 = color or Theme.TextColor,
			TextTransparency = 1,
			AutoButtonColor = false,
			Parent = Header
		})

		table.insert(HeaderButtonsList, { element = btn, targetPos = U2s(pos, 0) })
		local line = Create("Frame", {
			AnchorPoint = V2n(0.5, 0.5),
			Size = U2o(0, 2),
			Position = U2n(0.5, 0, 1, -2),
			BackgroundColor3 = color or Theme.TextColor,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = btn
		})

		local function setLine(hov)
			PlayTween(line, SharedTweens.Fast, { Size = U2n(hov and 0.8 or 0, 0, 0, 2), BackgroundTransparency = hov and 0 or 1 })
		end

		local function setPress(dn)
			PlayTween(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = U2s(pos, 0) + U2o(0, dn and 2 or 0), TextSize = dn and 12 or 16 })
		end

		Track(btn.MouseEnter:Connect(function() setLine(true) PlayTween(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextSize = 18}) end))
		Track(btn.MouseLeave:Connect(function() setLine(false) PlayTween(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextSize = 16}) end))
		Track(btn.MouseButton1Down:Connect(function() setPress(true) end))
		Track(btn.MouseButton1Up:Connect(function() setPress(false) end))
		Track(btn.MouseButton1Click:Connect(function() PlayInteractSound() cb() end))
		return btn
	end

	function kailex:ConfirmationFrame(text, onAccept)
		if Frame:FindFirstChild("kailex_confirm") then return end
		local cT = Theme.confirmationFrame
		local cDimmer = Create("TextButton", {
			Name = "kailex_dimmer",
			Size = U2s(1, 1),
			BackgroundColor3 = C3n(0, 0, 0),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "", ZIndex = 98,
			Parent = Frame
		})

		local cFrame = Create("CanvasGroup", {
			Name = "kailex_confirm",
			AnchorPoint = V2n(0.5, 0.5),
			Position = U2s(0.5, 0.55),
			Size = U2s(0.55, 0.36),
			BackgroundColor3 = cT.BackgroundColor,
			BackgroundTransparency = cT.Transparency,
			GroupTransparency = 1,
			ZIndex = 99,
			Parent = Frame,
			Create("UICorner", { CornerRadius = Layout.WindowCorner }),
			Create("UIStroke", { Thickness = 1.5, Color = cT.BorderColor })
		})

		local cHolder = Create("Frame", {
			Name = "ContentHolder",
			Size = U2s(1, 1),
			Position = U2s(0, 0),
			BackgroundTransparency = 1,
			Parent = cFrame
		})

		Create("TextLabel", {
			Size = U2n(1, -40, 0.3, 0),
			Position = U2n(0, 20, 0.05, 0),
			Text = text,
			TextColor3 = cT.TextColor,
			TextScaled = true,
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBlack,
			ZIndex = 100,
			Parent = cHolder
		})

		local cScale = Create("UIScale", { Scale = 0.7, Parent = cFrame })
		PlayTween(cDimmer, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { BackgroundTransparency = 0.4 })
		PlayTween(cFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { Position = U2s(0.5, 0.5), GroupTransparency = 0 })
		PlayTween(cScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
		local function Close(acc)
			PlayTween(cDimmer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
			PlayTween(cScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.8 })
			PlayTween(cFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { GroupTransparency = 1 }, function()
				cDimmer:Destroy(); cFrame:Destroy()
				if acc and onAccept then onAccept() end
			end)
		end
		PlayTween(cFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { Size = U2s(0.55, 0.36), Position = U2s(0.5, 0.5), BackgroundTransparency = cT.Transparency })
		PlayTween(cHolder, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { Position = U2s(0, 0) })
		local function CreateTBtn(t, pos, cb)
			local b = Create("TextButton", {
				Size = U2s(0.42, 0.25),
				Position = pos,
				Text = t,
				Font = Enum.Font.GothamBlack,
				TextColor3 = cT.TextColor,
				TextScaled = true,
				BackgroundColor3 = cT.ButtonColor,
				AutoButtonColor = false,
				ZIndex = 100,
				Parent = cHolder,
				Create("UICorner", { CornerRadius = Layout.ElementCorner }),
				Create("UIStroke", { Thickness = 2, Color = cT.BorderColor, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
			})

			ApplyHover(b, b, cT.ButtonHoverColor, cT.ButtonColor)
			Track(b.MouseButton1Click:Connect(function() ApplyRipple(b) PlayInteractSound() cb() end))
		end
		CreateTBtn("Yes", U2s(0.53, 0.6), function() Close(true) end)
		CreateTBtn("No", U2s(0.05, 0.6), function() Close(false) end)
		local xBtn = Create("TextButton", {
			Text = "X",
			Font = Enum.Font.GothamBold,
			TextScaled = true,
			TextColor3 = Theme.ErrorColor,
			BackgroundTransparency = 1,
			Size = U2s(0.1, 0.2),
			Position = U2s(0.9, 0),
			ZIndex = 101,
			Parent = cHolder
		})

		Track(xBtn.MouseButton1Click:Connect(function() Close(false) end))
		return cFrame
	end

	CreateHeaderBtn("X", 0.93, Theme.ErrorColor, function()
		kailex:ConfirmationFrame("Are you sure you want to close?", function()
			PlayTween(Frame:FindFirstChildOfClass("UIScale"), TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.8 })
			PlayTween(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
			local endTween = TweenService:Create(ScreenGui, TweenInfo.new(0.45), {})
			endTween:Play()
			endTween.Completed:Connect(function() for _, c in next, LibraryConnections do c:Disconnect() end table.clear(LibraryConnections) ScreenGui:Destroy() end)
		end)
	end)

	local wState, oSize, oPos, lMinPos = "Restored", nil, nil, nil
	CreateHeaderBtn("–", 0.865, Theme.TextColor, function()
		if wState ~= "Restored" then return end
		wState, oPos, oSize = "Animating", Frame.Position, Frame.Size
		local tPos = lMinPos or U2n(oPos.X.Scale + oSize.X.Scale / 2, oPos.X.Offset + oSize.X.Offset / 2, oPos.Y.Scale + oSize.Y.Scale / 2, oPos.Y.Offset + oSize.Y.Offset / 2)
		PlayTween(Frame, Animation.MinimizeButton, { Size = U2o(0, 0), Position = tPos, BackgroundTransparency = 1 }, function()
			Frame.Visible, MinimizedContainer.Position, MinimizedContainer.Visible, wState = false, tPos, true, "Minimized"
			PlayTween(MinimizedButton, Animation.MinimizeButton, { TextTransparency = 0 })
		end)
	end)

	local tStartPos
	Track(MinimizedButton.InputBegan:Connect(function(inp) if inp.UserInputType == EnumMouse1 or inp.UserInputType == EnumTouch then tStartPos = inp.Position end end))
	Track(MinimizedButton.InputEnded:Connect(function(inp)
		if (inp.UserInputType == EnumMouse1 or inp.UserInputType == EnumTouch) then
			if tStartPos and (V2n(inp.Position.X, inp.Position.Y) - V2n(tStartPos.X, tStartPos.Y)).Magnitude < 5 and wState == "Minimized" then
				wState, lMinPos = "Animating", MinimizedContainer.Position
				PlayTween(MinimizedButton, Animation.titleButton, { TextTransparency = 1 })
				PlayTween(MinimizedContainer, TweenInfo.new(0), {}, function()
					Frame.Position, Frame.Size, Frame.BackgroundTransparency, Frame.Visible, MinimizedContainer.Visible = MinimizedContainer.Position, U2o(0, 0), 1, true, false
					PlayTween(Frame, Animation.titleButton, { Size = oSize, Position = oPos, BackgroundTransparency = Theme.Transparency }, function() wState = "Restored" end)
				end)
			end
			tStartPos = nil
		end
	end))

	local ToolTipFrame = Create("Frame", {
		BackgroundColor3 = Theme.AccentColor, 
		BackgroundTransparency = 0.15, 
		Size = U2o(0, 25), 
		ZIndex = 1000, 
		Visible = false, 
		Parent = ScreenGui, 
		Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
	})

	local TTFUIS = Create("UIStroke", {
		Thickness = 1.5,
		Color = Theme.Toggle.ToggleOnColor,
		Transparency = 0.3,
		Parent = ToolTipFrame,
	})

	local ToolTipText = Create("TextLabel", {
		BackgroundTransparency = 1, 
		Size = U2n(1, -10, 1, 0), 
		Position = U2o(5, 0), 
		Font = Enum.Font.GothamMedium, 
		TextSize = 13, 
		ZIndex = ToolTipFrame.ZIndex + 1, 
		TextColor3 = Theme.TextColor, 
		TextXAlignment = Enum.TextXAlignment.Center, 
		Parent = ToolTipFrame
	})

	local toolTipConn
	local function ShowInfo(msg)
		ToolTipText.Text = msg
		local b = TextService:GetTextSize(msg, 13, Enum.Font.GothamMedium, V2n(1000, 25))
		ToolTipFrame.Size = U2o(b.X + 20, 28) 

		local m = UserInputService:GetMouseLocation()
		ToolTipFrame.Position = U2o(m.X + 15, m.Y - 20)

		ToolTipFrame.BackgroundTransparency = 1
		ToolTipText.TextTransparency = 1
		TTFUIS.Transparency = 1
		ToolTipFrame.Visible = true

		TweenService:Create(ToolTipFrame, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
		TweenService:Create(ToolTipText, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		TweenService:Create(TTFUIS, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Transparency = 0.3}):Play()

		if toolTipConn then toolTipConn:Disconnect() end
		toolTipConn = Track(UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == EnumMouse1 or input.UserInputType == EnumMouseMove or input.UserInputType == EnumTouch then
				local loc = UserInputService:GetMouseLocation()
				TweenService:Create(ToolTipFrame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
					Position = U2o(loc.X + 15, loc.Y - 20)
				}):Play()
			end
		end))
	end

	local function HideInfo() 
		ToolTipFrame.Visible = false 
		if toolTipConn then 
			toolTipConn:Disconnect() 
			toolTipConn = nil 
		end 
	end

	local NotificationFrame = Create("Frame", {
		Size = U2s(0.15, 1), 
		Position = U2s(0.84, 0), 
		BackgroundTransparency = 1, 
		Parent = ScreenGui, 
		Create("UIListLayout", {SortOrder = EnumSort, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 10)})
	})

	local NotificationQueue = {}
	local ActiveNotifications = 0
	local MAX_NOTIFICATIONS = 5
	local NotifPool = {}
	local NotifCount = 0

	local function GetNotificationInstance()
		for i = 1, NotifCount do
			local n = NotifPool[i]
			if not n.Visible then return n end
		end

		local n = Create("Frame", {
			Size = udim2_new(0.8, 0, 0, 35),
			Position = udim2_off(0, 0),
			BackgroundTransparency = Theme.Transparency,
			BackgroundColor3 = Theme.BackgroundColor,
			Visible = false,
			Parent = NotificationFrame,
			Create("UICorner", {CornerRadius = UDim.new(0.15, 0)}),
			Create("UIStroke", {Thickness = 1, Color = Theme.Toggle.ToggleOnColor, Transparency = 0.5})
		})
		ApplyShadow(n, 0.35, 45)

		local clipContainer = Create("Frame", {
			Size = U2s(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Parent = n,
			Create("UICorner", {CornerRadius = UDim.new(0.15, 0)})
		})

		local txtLbl = Create("TextLabel", {
			Size = udim2_new(0.9, 0, 0.9, 0),
			Position = udim2_new(0.05, 0, 0.05, 0),
			BackgroundTransparency = 1,
			TextColor3 = Theme.TextColor,
			TextScaled = true,
			TextXAlignment = EnumAlignX,
			Parent = n
		})

		local bar = Create("Frame", {
			Position = udim2_new(0, 0, 0.95, 0),
			Size = udim2_new(1, 0, 0.05, 0),
			BorderSizePixel = 0,
			Parent = n,
			Create("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Theme.NotificationsMainColor),
					ColorSequenceKeypoint.new(0.5, Theme.Toggle.ToggleOnColor),
					ColorSequenceKeypoint.new(1, Theme.NotificationsMainColor)
				})
			})
		})

		local dBtn = Create("TextButton", {
			Size = udim2_new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 10,
			Parent = n
		})

		n:SetAttribute("TxtObj", txtLbl.Name)
		n:SetAttribute("BarObj", bar.Name)
		n:SetAttribute("BtnObj", dBtn.Name)

		NotifCount = NotifCount + 1
		NotifPool[NotifCount] = n
		return n
	end

	local function ProcessNotification()
		if ActiveNotifications >= MAX_NOTIFICATIONS or #NotificationQueue == 0 then return end
		ActiveNotifications = ActiveNotifications + 1
		local txt = t_remove(NotificationQueue, 1)

		local n = GetNotificationInstance()
		ApplyShadow(n, 0.45, 55)
		local txtObj = n:FindFirstChild(n:GetAttribute("TxtObj"))
		local barObj = n:FindFirstChild(n:GetAttribute("BarObj"))
		local btnObj = n:FindFirstChild(n:GetAttribute("BtnObj"))

		txtObj.Text = txt
		barObj.Size = udim2_new(1, 0, 0.05, 0)
		n.Size = udim2_new(0.8, 0, 0, 35)
		n.BackgroundTransparency = 1
		txtObj.TextTransparency = 1
		n.Visible = true

		PlayTween(n, ti_new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = udim2_new(1, 0, 0, 38),
			BackgroundTransparency = Theme.Transparency - 0.05
		})
		PlayTween(txtObj, ti_new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		})

		local progressTween = PlayTween(barObj, ti_new(4, Enum.EasingStyle.Linear), {Size = udim2_new(0, 0, 0.05, 0)})
		local dismissed = false

		local function dismissNotification()
			if dismissed then return end
			dismissed = true
			if progressTween then progressTween:Cancel() end

			PlayTween(n, ti_new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
				Size = udim2_new(0.8, 0, 0, 35),
				BackgroundTransparency = 1
			})
			PlayTween(txtObj, ti_new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
				TextTransparency = 1
			}, function()
				n.Visible = false
				ActiveNotifications = ActiveNotifications - 1
				task.defer(ProcessNotification)
			end)
		end

		local btnConn
		btnConn = btnObj.MouseButton1Click:Connect(function()
			btnConn:Disconnect()
			dismissNotification()
		end)

		task.delay(4, function()
			if btnConn then btnConn:Disconnect() end
			dismissNotification()
		end)
	end

	function kailex:Notification(txt)
		table.insert(NotificationQueue, txt)
		ProcessNotification()
	end

	local TabContainer = Create("ScrollingFrame", {
		Size = U2s(0.1, 0.835), 
		Position = U2s(0, 0.15), 
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, 
		ScrollBarThickness = 0, 
		VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left, 
		CanvasSize = U2o(0, 0), 
		Parent = ContentClipper, 
		Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
		Create("UIPadding", {PaddingBottom = UDim.new(0, 10)}),
		Create("UIListLayout", { 
			Padding = UDim.new(0, 9),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),
	})

	local TabContentScroll = Create("ScrollingFrame", {
		Size = U2s(0.88, 0.835), 
		Position = U2s(0.11, 0.15), 
		BackgroundTransparency = 1, 
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageTransparency = 0.5,
		ScrollBarImageColor3 = Theme.BorderColor,
		ScrollingDirection = Enum.ScrollingDirection.Y, 
		CanvasSize = U2o(0, 0), 
		Parent = ContentClipper, 
		Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
		Create("UIPadding", {PaddingBottom = UDim.new(0, Layout.ButtonSizeY), PaddingLeft = UDim.new(0.007, 0), PaddingTop = UDim.new(0.007, 0)}), 
	})

	local Tabs, TabsButtons, currentTab, isAnimating = {}, {}, nil, false
	local CreateFrameBtn, CreateRow

	local SearchCache = {}
	local function BuildCache(prnt, cacheList)
		for _, child in pairs(prnt:GetChildren()) do
			if child:IsA("Frame") and not child:IsA("ScrollingFrame") then
				if child:GetAttribute("IsRow") then
					BuildCache(child, cacheList)
				else
					local isSep = child:GetAttribute("IsSeparator") == true
					local txtObj = child:FindFirstChildWhichIsA("TextLabel", true) or child:FindFirstChildWhichIsA("TextButton", true)
					if isSep then
						table.insert(cacheList, {element = child, isSep = true, origSize = child.Size})
					elseif txtObj and txtObj.Text ~= "" then
						table.insert(cacheList, {element = child, text = txtObj.Text:lower(), origSize = child.Size})
					end
				end
			end
		end
	end

	local function UpdateSearchCache()
		if not currentTab then return end
		SearchCache[currentTab] = {}
		BuildCache(currentTab, SearchCache[currentTab])
	end

	local function ApplySearchFilter()
		local query = lower(SearchInputFrame.Text)
		if not currentTab then return end
		if not SearchCache[currentTab] or #SearchCache[currentTab] == 0 then UpdateSearchCache() end
		local isEmpty = query == ""
		local cache = SearchCache[currentTab]

		task.spawn(function()
			for i = 1, #cache do
				local data = cache[i]
				local el = data.element
				if data.isSep then
					if el.Visible ~= isEmpty then el.Visible = isEmpty end
				else
					local match = isEmpty or find(data.text, query, 1, true) ~= nil
					if match and not el.Visible then
						el.Visible = true
						el.Size = data.origSize
					elseif not match and el.Visible then
						el.Visible = false
						el.Size = udim2_new(data.origSize.X.Scale, data.origSize.X.Offset, 0, 0)
					end
				end
				if i % 15 == 0 then task.wait() end
			end
		end)
	end

	Track(SearchInputFrame:GetPropertyChangedSignal("Text"):Connect(ApplySearchFilter))

	local function HandleInfo(parentFrame, info)
		local api, icon = {}, nil
		function api:Update(newInfo)
			if newInfo and newInfo ~= "" then
				if not icon then 
					icon = Create("ImageButton", {
						BackgroundTransparency = 1, 
						Position = InfoImage.InfoImagePOS, 
						Size = InfoImage.ImageSize, 
						Image = InfoImage.InfoImageId, 
						ImageColor3 = Theme.TextColor, 
						ZIndex = parentFrame.ZIndex + 1, 
						Parent = parentFrame
					})
					Track(icon.MouseButton1Click:Connect(function() 
						if ToolTipFrame.Visible then HideInfo() else ShowInfo(newInfo) end 
					end)) 
				end
			elseif icon then icon:Destroy() icon = nil end
		end

		function api:Destroy() if icon then icon:Destroy() end end

		api:Update(info)
		return api
	end

	local function BindBaseAPI(api, baseFrame, infoHandler, extraCleanup)
		function api:Visible(state)
			baseFrame.Visible = state ~= nil and state or not baseFrame.Visible
		end
		function api:destroy()
			if infoHandler then infoHandler:Destroy() end
			if extraCleanup then extraCleanup() end
			if baseFrame then baseFrame:Destroy() end
		end
	end

	local function AttachExtraButtons(wrapperFrame, extraButtonsData)
		for _, btnData in ipairs(extraButtonsData) do
			local bContent, bCb = btnData.content, btnData.cb
			if type(bContent) == "string" and type(bCb) == "function" then
				local isIcon = tonumber(bContent) or string.match(bContent, "rbxassetid://") or string.match(bContent, "http://")
				local extraBtn = Create("TextButton", {
					BackgroundColor3 = Theme.ButtonColor,
					BackgroundTransparency = Theme.Transparency + 0.2,
					Size = U2n(0, Layout.ButtonSizeY, 1, 0),
					Text = not isIcon and bContent or "",
					TextColor3 = Theme.TextColor,
					TextScaled = true,
					Parent = wrapperFrame,
					GetCorner(),
					GetStroke(0.7, Enum.ApplyStrokeMode.Border)
				})
				if isIcon then
					Create("ImageLabel", {
						BackgroundTransparency = 1, Size = U2s(1, 1), Position = U2s(0.2, 0.2),
						Image = tonumber(bContent) and ("rbxassetid://" .. bContent) or bContent,
						ImageColor3 = Theme.TextColor, Parent = extraBtn
					})
				end
				ApplyHover(extraBtn, extraBtn, Theme.AccentColor, Theme.ButtonColor)
				Track(extraBtn.MouseButton1Click:Connect(function()
					ApplyRipple(extraBtn)
					PlayInteractSound()
					bCb()
				end))
			end
		end
	end

	local function BuildComponents(compTable, parent, prnt2)

		local function getArgs(...) if Setting.Info then return ... else return nil, ... end end

		local function AnimateDropdown(list, icon, expanded, count, rowCount)
			PlayTween(icon, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = expanded and 180 or 0})

			local layout = list:FindFirstChildOfClass("UIGridLayout")
			local targetHeight = expanded and math.min(math.ceil(count / rowCount) * 35, 150) or 0

			if expanded then 
				list.Visible = true 
				if layout then 
					layout.CellPadding = U2o(5, 20)
					layout.CellSize = U2n(1 / rowCount, -10, 0, 0)
				end
			end

			PlayTween(list, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = U2n(1, 0, 0, targetHeight)}, function() 
				list.Visible = expanded 
			end)

			if layout then
				PlayTween(layout, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					CellPadding = U2o(5, 5),
					CellSize = U2n(1 / rowCount, -10, 0, 30)
				})
			end

			local delayTime = 0
			for _, child in ipairs(list:GetChildren()) do
				if child:IsA("TextButton") then
					if expanded then
						child.Position = U2o(0, -10)
						child.TextTransparency = 1
						child.BackgroundTransparency = 1
					end
					task.delay(expanded and delayTime or 0, function()
						if child and child.Parent then
							PlayTween(child, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
								BackgroundTransparency = expanded and 0.1 or 1, 
								TextTransparency = expanded and 0 or 1,
								Position = U2o(0, 0)
							})
						end
					end)
					delayTime = delayTime + 0.03
				end
			end
		end

		local function SetupToggle(parentFrame, defaultVal, style)
			local toggled = defaultVal or false
			local rad = style and UDim.new(0.3, 0) or UDim.new(1, 0)
			local tTheme = Theme.Toggle

			local btn = Create("TextButton", {
				AnchorPoint = V2n(1, 0.5), Position = U2n(1, -12, 0.5, 0),
				Size = U2o(36, 18), AutoButtonColor = false, Text = "",
				BackgroundColor3 = toggled and tTheme.ToggleOnColor or tTheme.ToggleOffColor, 
				Parent = parentFrame
			})

			local bUIC = Create("UICorner", {CornerRadius = rad, Parent = btn})

			local stroke = Create("UIStroke", {
				Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = toggled and tTheme.ToggleOnBorderColor or tTheme.ToggleOffBorderColor, 
				Parent = btn
			})

			local dot = Create("Frame", {
				AnchorPoint = V2n(0, 0.5), Size = U2o(14, 14),
				Position = U2n(0, toggled and 20 or 2, 0.5, 0), BackgroundColor3 = C3r(255, 255, 255), 
				Parent = btn,
				Create("UIStroke", {Thickness = 1, Color = C3n(0,0,0), Transparency = 0.8, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}),
				Create("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, C3n(1, 1, 1)),
						ColorSequenceKeypoint.new(1, C3n(0.8, 0.8, 0.8))
					})
				})
			})

			local dUIC = Create("UICorner", {CornerRadius = rad, Parent = dot})

			ApplyShadow(dot, 0.2, 18)

			local api = {}
			function api:newStyle(nSt) 
				local nRad = nSt and UDim.new(0.3, 0) or UDim.new(1, 0)
				bUIC.CornerRadius, dUIC.CornerRadius = nRad, nRad 
			end

			function api:getTValue() return toggled end

			local function HandleToggle(forceState)
				if forceState ~= nil then toggled = forceState
				else toggled = not toggled end

				PlayInteractSound(toggled and "ToggleOn" or "ToggleOff")

				local t1 = TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = U2o(24, 12),
					Position = U2n(0, toggled and 6 or 8, 0.5, 0)
				})
				t1:Play()

				local conn
				conn = t1.Completed:Connect(function()
					conn:Disconnect()
					t1:Destroy()
					TweenService:Create(dot, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = U2o(14, 14),
						Position = U2n(0, toggled and 20 or 2, 0.5, 0),
					}):Play()
				end)

				PlayTween(btn, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					BackgroundColor3 = toggled and tTheme.ToggleOnColor or tTheme.ToggleOffColor
				})
				PlayTween(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Color = toggled and tTheme.ToggleOnBorderColor or tTheme.ToggleOffBorderColor,
				})
				return toggled
			end

			function api:setTValue(state, silent, cb)
				if toggled == state then return end
				HandleToggle(state)
				if not silent and cb then cb(toggled) end
			end

			return api, btn, HandleToggle
		end

		local function CreateSlider(name, info, beginVal, minVal, maxVal, callback, tSize, trackSize)
			local api = {} 
			local currentVal = beginVal
			local callback = callback or function() end
			local baseFrame = CreateBaseComp(parent)

			local label = Create("TextLabel", {
				Size = U2s(tSize, 1),
				BackgroundTransparency = 1,
				Text = name or "Slider",
				TextColor3 = Theme.TextColor, 
				TextScaled = true,
				TextXAlignment = EnumAlignX,
				Parent = baseFrame,
				Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill})
			})

			local textBox = Create("TextBox", {
				Size = U2s(0.1, 0.8),
				BackgroundTransparency = 1,
				PlaceholderColor3 = Theme.TextColor,
				Text = tostring(math.floor(beginVal)), 
				TextColor3 = Theme.TextColor,
				TextScaled = true,
				Parent = baseFrame
			})

			local sliderTrack = Create("TextButton", {
				Size = trackSize, Text = "", AutoButtonColor = false, BackgroundColor3 = Theme.BackgroundColor, Parent = baseFrame, 
				Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
			})

			local sTUIS = Create("UIStroke", {
				Thickness = 1,
				Color = Theme.BorderColor,
				Transparency = 0.5,
				Parent = sliderTrack
			})

			local sliderFill = Create("Frame", {
				BackgroundColor3 = Theme.Toggle.ToggleOnColor, Parent = sliderTrack, 
				Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
				Create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, C3r(255,255,255)), ColorSequenceKeypoint.new(1, Theme.Toggle.ToggleOnColor)}), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})})
			})

			local sliderKnob = Create("Frame", {
				AnchorPoint = V2n(0.5, 0.5), Size = U2o(14, 14), Position = U2n(1, 0, 0.5, 0), BackgroundColor3 = C3r(255, 255, 255), 
				ZIndex = 5, Parent = sliderFill, Create("UICorner", {CornerRadius = UDim.new(1, 0)}), Create("UIStroke", {Thickness = 1.5, Color = C3n(0,0,0), Transparency = 0.8})
			})

			local infoHandler
			task.defer(function() infoHandler = HandleInfo(baseFrame, info) end)

			local function UpdateVisuals(v)
				local range = maxVal - minVal
				local fraction = (range == 0) and 1 or math.clamp((v - minVal) / range, 0, 1)

				TweenService:Create(sliderFill, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = U2s(fraction, 1)}):Play()

				local isSmallRange = (maxVal - minVal) <= 1
				local isInt = (math.floor(minVal) == minVal) and (math.floor(maxVal) == maxVal) and not isSmallRange
				local formattedVal = isInt and tostring(math.floor(v)) or string.format("%.2f", v):gsub("%.?0+$", "")

				if formattedVal == "" then formattedVal = "0" end
				if formattedVal ~= textBox.Text and not textBox:IsFocused() then textBox.Text = formattedVal end 
				currentVal = v
			end

			local dragging, moveConn, endConn = false, nil, nil
			local function GetVal(posX) return math.clamp((posX - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1) * (maxVal - minVal) + minVal end

			Track(sliderTrack.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not GlobalDragState then
					GlobalDragState = true
					dragging = true 
					PlayInteractSound() 

					PlayTween(sTUIS, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Color = Theme.Toggle.ToggleOnColor, Transparency = 0})
					PlayTween(sliderKnob, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = U2o(24, 24), BackgroundColor3 = Theme.Toggle.ToggleOnColor})
					PlayTween(textBox, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Theme.Toggle.ToggleOnColor})

					local v = GetVal(input.Position.X)
					UpdateVisuals(v)
					callback(v)

					moveConn = Track(UserInputService.InputChanged:Connect(function(changedInput) 
						if dragging and (changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch) then 
							local cv = GetVal(changedInput.Position.X)
							UpdateVisuals(cv)
							callback(cv) 
						end 
					end))

					endConn = Track(UserInputService.InputEnded:Connect(function(endedInput) 
						if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then 
							if dragging then
								dragging = false 
								GlobalDragState = false
							end
							PlayTween(sTUIS, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = Theme.BorderColor, Transparency = 0.5})
							PlayTween(sliderKnob, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = U2o(14, 14), BackgroundColor3 = C3r(255, 255, 255)})
							PlayTween(textBox, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Theme.TextColor})
							if moveConn then moveConn:Disconnect() end 
							if endConn then endConn:Disconnect() end 
						end 
					end))
				end
			end))

			Track(textBox.FocusLost:Connect(function() 
				local num = tonumber(textBox.Text)
				if num then api:setValue(num) else textBox.Text = tostring(math.floor(currentVal)) end
			end))

			function api:setValue(v, silent) local nV = math.clamp(v, minVal, maxVal); UpdateVisuals(nV); if not silent then callback(nV) end end
			function api:getSValue() return currentVal end
			function api:update(n, i, cMin, cMax, cb) name = n or name; minVal = cMin or minVal; maxVal = cMax or maxVal; callback = cb or callback; label.Text = name; if maxVal <= minVal then maxVal = minVal + 1 end; api:setValue(currentVal, true); infoHandler:Update(i) end
			function api:destroy() infoHandler:Destroy(); baseFrame:Destroy() end
			function api:Visible(state) baseFrame.Visible = state ~= nil and state or not baseFrame.Visible end

			UpdateVisuals(beginVal) 
			return api, baseFrame, label
		end

		local function CreateDropdown(name, info, items, perRow, callback, defaultVal, dSize, dPos)
			local api = {}
			local perRow, selected, callback = perRow or 1, defaultVal or nil, callback or function() end
			local expanded

			local baseFrame = CreateBaseComp(parent)

			local btn = Create("TextButton", {
				BackgroundTransparency = 1, 
				Size = dSize or TextSize.WithIcon, 
				Position = Layout.ButtonPOS, 
				Text = selected and (name .. ": " .. tostring(selected)) or (name or "Dropdown"), 
				TextColor3 = Theme.TextColor, 
				TextScaled = true, 
				TextXAlignment = EnumAlignX,
				Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}),
				Parent = baseFrame
			})

			local iconBtn = Create("ImageButton", {
				BackgroundTransparency = 1, 
				Position = dPos or U2s(0.9, 0), 
				Size = U2s(0.1, 1), 
				Image = "http://www.roblox.com/asset/?id=6031090994", 
				ImageColor3 = Theme.TextColor, 
				Parent = baseFrame
			})

			local infoHandler = HandleInfo(baseFrame, info) 

			local listFrame = Create("ScrollingFrame", {
				BackgroundColor3 = Theme.BackgroundColor, 
				BackgroundTransparency = Theme.Transparency + 0.3,
				Size = U2s(1, 0),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = false, 
				ScrollBarThickness = 3, 
				Parent = prnt2 or parent,
				Create("UICorner", {CornerRadius = Layout.ElementCorner}),
				Create("UIPadding", {
					PaddingBottom = UDim.new(0, 5),
					PaddingTop = UDim.new(0, 5)
				})
			})

			local lFUIGL = Create("UIGridLayout", {
				CellSize = U2n(1 / perRow, -10, 0, 30), 
				CellPadding = U2o(5, 5), 
				FillDirection = EnumFill, 
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Parent = listFrame,
			})

			local function ToggleDropdown(forceState)
				local targetState = forceState ~= nil and forceState or not expanded
				if targetState == expanded then return end 
				expanded = targetState 
				PlayInteractSound()
				AnimateDropdown(listFrame, iconBtn, expanded, #items, perRow)
			end

			local itemPool = {}
			local function BuildItems()
				local activeCount = #items
				for i, child in ipairs(itemPool) do
					child.Visible = false
				end

				for i, item in ipairs(items) do
					local itemBtn = itemPool[i]
					if not itemBtn then
						itemBtn = Create("TextButton", {
							BackgroundColor3 = Theme.ButtonColor,
							TextColor3 = Theme.TextColor,
							TextScaled = true,
							BackgroundTransparency = 1,
							TextTransparency = 1,
							ZIndex = 51,
							Parent = listFrame,
							GetCorner()
						})
						table.insert(itemPool, itemBtn)
						Track(itemBtn.MouseButton1Click:Connect(function()
							selected = items[table.find(itemPool, itemBtn)]
							btn.Text = selected and (name .. ": " .. tostring(selected)) or name
							callback(selected)
							ToggleDropdown(false)
						end))
					end
					itemBtn.Text = tostring(item)
					itemBtn.Visible = true
				end
			end

			BuildItems()

			if selected then
				callback(selected)
			end

			for _, b in {btn, iconBtn} do Track(b.MouseButton1Click:Connect(function() ToggleDropdown() end)) end

			function api:ToggleDropdown(state) ToggleDropdown(state) end
			function api:newName(n) btn.Text = selected and (n .. ": " .. tostring(selected)) or n end
			function api:newInfo(i) infoHandler:Update(i) end
			function api:newCallback(c) callback = c end

			function api:addItems(i)
				if not table.find(items, i) then
					table.insert(items, i) 
					BuildItems() 
				end
			end

			function api:removeItems(i) 
				local idx = table.find(items, i) 
				if idx then 
					table.remove(items, idx) 
					if selected == i then 
						selected = nil
						btn.Text = selected and (name .. ": " .. tostring(selected)) or name
					end 
					BuildItems() 
				end 
			end
			function api:setItems(t) 
				if type(t) == "table" then
					items = t 
					if selected and not table.find(items, selected) then 
						selected = nil
						btn.Text = selected and (name .. ": " .. tostring(selected)) or name
					end 
					BuildItems() 
				end 
			end
			function api:update(n, i, t, pR, cb) 
				api:newName(n) 
				api:newInfo(i) 
				api:setItems(t) 
				callback = cb or callback 
				if type(pR) == "number" and pR > 0 then 
					perRow = pR 
					lFUIGL.CellSize = U2n(1/perRow, -10, 0, 30) 
				end 
				BuildItems() 
			end
			function api:getSelected() return selected end
			function api:setSelected(s, silent) 
				if table.find(items, s) then 
					selected = s
					btn.Text = selected and (name .. ": " .. tostring(selected)) or name
					if not silent then callback(s) end 
				end 
			end
			function api:destroy() baseFrame:Destroy() end

			function api:Visible(state)
				local targetState = state ~= nil and state or not baseFrame.Visible
				baseFrame.Visible = targetState
				if not targetState and expanded then ToggleDropdown(false) end
			end
			return api, baseFrame
		end

		function compTable:addButton(name, ...)
			local args = {...}
			local info = Setting.Info and args[1] or nil
			local callback = Setting.Info and args[2] or args[1]
			callback = callback or function() end
			local startIndex = Setting.Info and 3 or 2
			local rightIcon = (args[startIndex] ~= nil and type(args[startIndex + 1]) ~= "function") and args[startIndex] or nil
			if rightIcon then startIndex = startIndex + 1 end

			local extraButtonsData = {}
			for i = startIndex, #args, 2 do
				table.insert(extraButtonsData, {content = args[i], cb = args[i+1]})
			end

			local api = {}
			local wrapperFrame = Create("Frame", {
				BackgroundTransparency = 1, Size = Layout.ButtonSize, Parent = parent,
				Create("UIListLayout", {Padding = UDim.new(0, 8), FillDirection = EnumFill, SortOrder = EnumSort, VerticalAlignment = EnumAlignY})
			})

			local baseFrame = Create("Frame", {
				Size = U2n(1, 0, 1, 0), BackgroundColor3 = Theme.ButtonColor, BackgroundTransparency = Theme.Transparency + 0.2,
				ClipsDescendants = true, Parent = wrapperFrame,
				GetCorner(), GetStroke(0.7),
				Create("UIPadding", {PaddingLeft = UDim.new(0.02, 0), PaddingRight = UDim.new(0.02, 0)}),
				Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}),
				Create("UIListLayout", {Padding = UDim.new(0.02, 0), FillDirection = EnumFill, SortOrder = EnumSort, VerticalAlignment = EnumAlignY})
			})

			local btn = Create("TextButton", {
				BackgroundTransparency = 1, Size = TextSize.Full, Position = Layout.ButtonPOS,
				Text = name or "Button", TextColor3 = Theme.TextColor, TextScaled = true,
				TextXAlignment = EnumAlignX, ZIndex = 2, Parent = baseFrame,
				Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill})
			})

			local ImageButton
			if rightIcon then
				ImageButton = Create("ImageButton", {
					BackgroundTransparency = 1, Size = U2s(0.1, 1),
					Image = tonumber(rightIcon) and ("rbxassetid://" .. rightIcon) or rightIcon,
					ImageColor3 = Theme.TextColor, Parent = baseFrame
				})
			end

			AttachExtraButtons(wrapperFrame, extraButtonsData)

			local infoHandler = HandleInfo(baseFrame, info)
			local clearHover = ApplyHover(btn, baseFrame, Theme.AccentColor, Theme.ButtonColor)

			local function trigger()
				ApplyRipple(btn)
				PlayInteractSound()
				callback()
			end

			local conn = Track(btn.MouseButton1Click:Connect(trigger))
			local conn2 = ImageButton and Track(ImageButton.MouseButton1Click:Connect(trigger))

			function api:updatename(n) btn.Text = n end
			function api:updateInfo(i) infoHandler:Update(i) end
			function api:updatecallback(c) callback = c end
			function api:update(n, i, c) api:updatename(n) api:updateInfo(i) api:updatecallback(c) end
			function api:destroy() infoHandler:Destroy() clearHover() if conn then conn:Disconnect() end wrapperFrame:Destroy() end
			function api:Visible(state) wrapperFrame.Visible = state ~= nil and state or not wrapperFrame.Visible end

			return api
		end

		function compTable:addToggle(name, ...)
			local Info, callback, defaultVal, style = getArgs(...)
			local api = {}
			local callback = callback or function() end

			local baseFrame, btn = CreateLabeledBase(parent, name, U2n(1, -60, 1, 0))
			local tApi, tBtn, doToggle = SetupToggle(baseFrame, defaultVal, style)
			local infoHandler = HandleInfo(baseFrame, Info)
			local clearHover = ApplyHover(btn, baseFrame, Theme.AccentColor, Theme.ButtonColor)

			local function action()
				ApplyRipple(btn)
				PlayInteractSound()
				callback(doToggle())
			end

			Track(btn.MouseButton1Click:Connect(action))
			Track(tBtn.MouseButton1Click:Connect(action))

			if defaultVal and callback then task.spawn(callback, defaultVal) end

			function api:NewName(n) name = n or name; btn.Text = name end
			function api:newInfo(i) infoHandler:Update(i) end
			function api:newcallback(c) callback = c end
			function api:update(n, i, c, s) api:NewName(n) api:newInfo(i) api:newcallback(c) tApi:newStyle(s) end
			function api:setValue(s, silent) tApi:setValue(s, silent, callback) end
			function api:getTValue() return tApi:getTValue() end
			function api:destroy() infoHandler:Destroy() clearHover() baseFrame:Destroy() end
			function api:Visible(state) baseFrame.Visible = state ~= nil and state or not baseFrame.Visible end

			for k, v in pairs(tApi) do api[k] = v end
			return api
		end

		function compTable:addSlider(name, ...)
			local info, beginVal, minVal, maxVal, callback = getArgs(...)
			return CreateSlider(name, info, beginVal, minVal, maxVal, callback, 0.38, U2s(0.45, 0.3))
		end

		function compTable:addDropdown(name, ...)
			local info, items, perRow, callback, defaultVal = getArgs(...)
			return CreateDropdown(name, info, items, perRow, callback, defaultVal)
		end

		function compTable:addMultiDropdown(name, ...)
			local info, items, perRow, callback, defaultVals = getArgs(...)
			local api = {}
			local perRow = perRow or 1
			local expanded = false
			local selectedItems = {}
			local callback = callback or function() end

			if type(defaultVals) == "table" then
				for _, val in ipairs(defaultVals) do
					if table.find(items, val) then selectedItems[val] = true end
				end
			end

			local function getSelectedArray()
				local arr = {}
				for k in pairs(selectedItems) do table.insert(arr, k) end
				return arr
			end

			local baseFrame = CreateBaseComp(parent)

			local btn = Create("TextButton", {
				BackgroundTransparency = 1, 
				Size = TextSize.WithIcon, 
				Position = Layout.ButtonPOS, 
				Text = name or "Multi Dropdown", 
				TextColor3 = Theme.TextColor, 
				TextScaled = true, 
				TextXAlignment = EnumAlignX,
				Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}),
				Parent = baseFrame
			})

			local iconBtn = Create("ImageButton", {
				BackgroundTransparency = 1, 
				Position = U2s(0.9, 0), 
				Size = U2s(0.1, 1), 
				Image = "http://www.roblox.com/asset/?id=6031090994", 
				ImageColor3 = Theme.TextColor, 
				Parent = baseFrame
			})

			local infoHandler = HandleInfo(baseFrame, info) 

			local listFrame = Create("ScrollingFrame", {
				BackgroundColor3 = Theme.BackgroundColor, 
				BackgroundTransparency = Theme.Transparency + 0.3, 
				Position = U2s(0, 1), 
				Size = U2s(1, 0), 
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = U2o(0, 0),
				Visible = false, 
				ScrollBarThickness = 3, 
				Parent = prnt2 or parent, 
				Create("UICorner", {CornerRadius = Layout.ElementCorner}), 
				Create("UIGridLayout", {
					CellSize = U2n(1 / perRow, -10, 0, 30), 
					CellPadding = U2o(5, 5), 
					FillDirection = EnumFill, 
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				})
			})

			local function updateBtnText()
				local count = 0
				for _ in pairs(selectedItems) do count += 1 end
				btn.Text = count > 0 and (name .. ": [" .. count .. "]") or name
			end
			updateBtnText()

			local function ToggleDropdown(forceState)
				local targetState = forceState ~= nil and forceState or not expanded
				if targetState == expanded then return end 
				expanded = targetState 
				PlayInteractSound()
				AnimateDropdown(listFrame, iconBtn, expanded, #items, perRow)
			end

			local itemPool = {}
			local function BuildItems()
				local activeCount = #items
				for i, child in ipairs(itemPool) do
					child.Visible = false
				end

				for i, item in ipairs(items) do
					local itemBtn = itemPool[i]
					if not itemBtn then
						itemBtn = Create("TextButton", {
							BackgroundColor3 = Theme.ButtonColor,
							Size = U2n(1, 0, 0, Layout.ButtonSizeY),
							TextColor3 = Theme.TextColor,
							TextScaled = true,
							BackgroundTransparency = 1,
							TextTransparency = 1,
							ZIndex = 51,
							Parent = listFrame,
							GetCorner()
						})
						table.insert(itemPool, itemBtn)
						Track(itemBtn.MouseButton1Click:Connect(function()
							local selected = items[table.find(itemPool, itemBtn)]
							btn.Text = selected and (name .. ": " .. tostring(selected)) or name
							callback(selected)
							ToggleDropdown(false)
						end))
					end
					itemBtn.Text = tostring(item)
					itemBtn.Visible = true
				end
			end

			BuildItems()
			if next(selectedItems) then task.spawn(function() callback(getSelectedArray()) end) end

			for _, b in {btn, iconBtn} do Track(b.MouseButton1Click:Connect(function() ToggleDropdown() end)) end

			function api:ToggleDropdown(state) ToggleDropdown(state) end
			function api:newName(n) name = n updateBtnText() end
			function api:newInfo(i) infoHandler:Update(i) end
			function api:newCallback(c) callback = c end
			function api:setItems(t) 
				if type(t) == "table" then 
					items = t 
					local newSel = {}
					for k in pairs(selectedItems) do if table.find(items, k) then newSel[k] = true end end
					selectedItems = newSel
					updateBtnText()
					BuildItems() 
				end 
			end
			function api:getSelected() return getSelectedArray() end
			function api:setSelected(arr, silent) 
				if type(arr) == "table" then
					selectedItems = {}
					for _, v in ipairs(arr) do if table.find(items, v) then selectedItems[v] = true end end
					updateBtnText()
					BuildItems()
					if not silent then callback(getSelectedArray()) end
				end
			end
			function api:destroy() baseFrame:Destroy() listFrame:Destroy() end
			function api:Visible(state)
				local targetState = state ~= nil and state or not baseFrame.Visible
				baseFrame.Visible = targetState
				if not targetState and expanded then ToggleDropdown(false) end
			end
			return api
		end

		function compTable:addDropdownSection(name, ...)
			local args = {...}
			local info = Setting.Info and args[1] or nil
			local state = Setting.Info and args[2] or args[1]
			local extraDataStart = Setting.Info and 3 or 2

			local api = {}
			local expanded = state or false

			local sectionOuter = Create("Frame", {
				Size = UDim2.new(Layout.ButtonSize.X.Scale, Layout.ButtonSize.X.Offset, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = parent,
				Create("UIListLayout", {SortOrder = EnumSort, Padding = UDim.new(0, 6)})
			})

			local headerWrapper = Create("Frame", {
				BackgroundTransparency = 1,
				Size = U2n(1, 0, 0, Layout.ButtonSizeY),
				Parent = sectionOuter,
				Create("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = EnumFill,
					SortOrder = EnumSort,
					VerticalAlignment = EnumAlignY
				})
			})

			local headerBase = Create("Frame", {
				Size = U2n(1, 0, 1, 0),
				BackgroundColor3 = expanded and Theme.AccentColor or Theme.ButtonColor,
				BackgroundTransparency = Theme.Transparency + 0.2,
				ClipsDescendants = true,
				Parent = headerWrapper,
				GetCorner(),
				GetStroke(0.7),
				Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill})
			})

			local btn = Create("TextButton", {
				BackgroundTransparency = 1,
				Size = U2n(0.9, 0, 1, 0),
				Position = U2n(0.02, 0, 0, 0),
				Text = name or "Section",
				TextColor3 = Theme.TextColor,
				TextScaled = true,
				TextXAlignment = EnumAlignX,
				Parent = headerBase
			})

			local toggleIcon = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = U2n(0.9, 0, 0, 0),
				Size = U2n(0.1, 0, 1, 0),
				Text = expanded and "-" or "+",
				Font = Enum.Font.GothamBold,
				TextColor3 = Theme.TextColor,
				TextScaled = true,
				Parent = headerBase
			})

			for i = extraDataStart, #args, 2 do
				local bContent, bCb = args[i], args[i+1]
				if type(bContent) == "string" and type(bCb) == "function" then
					local isIcon = tonumber(bContent) or string.match(bContent, "rbxassetid://") or string.match(bContent, "http://")
					local extraBtn = Create("TextButton", {
						BackgroundColor3 = Theme.ButtonColor,
						BackgroundTransparency = Theme.Transparency + 0.2,
						Size = U2n(0, Layout.ButtonSizeY, 1, 0),
						Text = not isIcon and bContent or "",
						TextColor3 = Theme.TextColor,
						TextScaled = true,
						Parent = headerWrapper,
						GetCorner(),
						GetStroke(0.7, Enum.ApplyStrokeMode.Border)
					})
					if isIcon then
						Create("ImageLabel", {
							BackgroundTransparency = 1,
							AnchorPoint = V2n(0.5, 0.5),
							Position = U2s(0.5, 0.5),
							Size = U2s(0.6, 0.6),
							ScaleType = Enum.ScaleType.Fit,
							Image = tonumber(bContent) and ("rbxassetid://" .. bContent) or bContent,
							ImageColor3 = Theme.TextColor,
							Parent = extraBtn
						})
					end
					ApplyHover(extraBtn, extraBtn, Theme.AccentColor, Theme.ButtonColor)
					Track(extraBtn.MouseButton1Click:Connect(function() ApplyRipple(extraBtn) PlayInteractSound() bCb() end))
				end
			end

			local infoHandler = HandleInfo(headerBase, info)

			local contentWrapper = Create("Frame", {
				Size = U2n(1, 0, 0, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = sectionOuter
			})

			Create("Frame", {
				Size = U2n(0, 2, 1, -8),
				Position = U2n(0.025, 0, 0, 4),
				BackgroundColor3 = Theme.TabUnderLineColor,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				Parent = contentWrapper,
				GetCorner()
			})

			local innerContent = Create("Frame", {
				Size = U2n(0.95, 0, 1, 0),
				Position = U2n(0.05, 0, 0, 0),
				BackgroundTransparency = 1,
				Parent = contentWrapper,
				Create("UIPadding", {
					PaddingTop = UDim.new(0, 4),
					PaddingBottom = UDim.new(0, 4)
				})
			})

			local iCUILL = Create("UIListLayout", {
				SortOrder = EnumSort,
				Padding = UDim.new(0, 8),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Parent = innerContent,
			})

			local function UpdateVisuals()
				toggleIcon.Text = expanded and "-" or "+"
				PlayTween(headerBase, SharedTweens.HoverIn, {BackgroundColor3 = expanded and Theme.AccentColor or Theme.ButtonColor})
				local targetHeight = expanded and (iCUILL.AbsoluteContentSize.Y + 8) or 0
				PlayTween(contentWrapper, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = U2n(1, 0, 0, targetHeight)})
			end

			local function Toggle(force)
				local target = force ~= nil and force or not expanded
				if target == expanded then return end
				expanded = target
				PlayInteractSound()
				UpdateVisuals()
			end

			ApplyHover(btn, headerBase, Theme.AccentColor, Theme.ButtonColor)
			Track(btn.MouseButton1Click:Connect(function() ApplyRipple(btn) Toggle() end))

			Track(iCUILL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
				if expanded then contentWrapper.Size = U2n(1, 0, 0, iCUILL.AbsoluteContentSize.Y + 8) end 
			end))

			function api:Toggle(force) Toggle(force) end
			function api:getState() return expanded end
			function api:update(newName, newInfo) if newName then btn.Text = newName end infoHandler:Update(newInfo) end
			function api:destroy() infoHandler:Destroy() sectionOuter:Destroy() end
			function api:addRow(fpr, lns) return CreateRow(innerContent, fpr, lns) end
			function api:addFrameButton(n, i) return CreateFrameBtn(n, i, innerContent) end
			function api:Visible(state) sectionOuter.Visible = state ~= nil and state or not sectionOuter.Visible end

			BuildComponents(api, innerContent, prnt2)
			if expanded then task.defer(function() contentWrapper.Size = U2n(1, 0, 0, iCUILL.AbsoluteContentSize.Y + 8) end) end

			return api
		end

		function compTable:addTextBox(name, ...)
			local info, placeholder, callback, defultvalue, live = getArgs(...)
			local api = {}
			local callback = callback or function() end

			local baseFrame, label = CreateLabeledBase(parent, name)

			local textBox = Create("TextBox", {
				BackgroundColor3 = Theme.AccentColor,
				Size = U2s(0.15, 0.8),
				Position = U2s(0.83, 0.1),
				PlaceholderText = placeholder or "",
				PlaceholderColor3 = Theme.TextColor,
				Text = tostring(defultvalue) or "",
				TextColor3 = Theme.TextColor,
				Font = Enum.Font.Gotham,
				TextScaled = true,
				ClearTextOnFocus = false,
				ZIndex = 2,
				Parent = baseFrame,
				Create("UICorner", {CornerRadius = UDim.new(0.15, 0)}),
				GetStroke(0, Enum.ApplyStrokeMode.Border)
			})

			local infoHandler = HandleInfo(baseFrame, info)
			local isProgrammatic = false

			if live then
				Track(textBox:GetPropertyChangedSignal("Text"):Connect(function()
					if not isProgrammatic then callback(textBox.Text) end
				end))
			else
				Track(textBox.FocusLost:Connect(function() callback(textBox.Text) end))
			end

			function api:setText(t, silent)
				isProgrammatic = true
				textBox.Text = t or ""
				isProgrammatic = false
				if not silent then callback(textBox.Text) end
			end
			function api:getText()
				return textBox.Text
			end
			function api:destroy() infoHandler:Destroy() baseFrame:Destroy() end
			function api:Visible(state) baseFrame.Visible = state ~= nil and state or not baseFrame.Visible end
			return api
		end

		function compTable:addColorPicker(name, ...)
			local info, defColor, callback = getArgs(...)
			local callback = callback or function() end
			local api = {}
			defColor = typeof(defColor) == "Color3" and defColor or C3n(1, 1, 1)

			local h, s, v = defColor:ToHSV()
			local expanded = false

			local function ToHex(color)
				local r = math.floor(color.R * 255 + 0.5)
				local g = math.floor(color.G * 255 + 0.5)
				local b = math.floor(color.B * 255 + 0.5)
				return string.format("%02X%02X%02X", r, g, b)
			end

			local baseFrame = CreateBaseComp(parent)

			local innerFrame = Create("Frame", {
				Size = U2s(1, 1),
				BackgroundTransparency = 1,
				Parent = baseFrame
			})

			local label = Create("TextButton", {
				BackgroundTransparency = 1, 
				Size = U2s(0.7, 1), 
				Position = Layout.ButtonPOS, 
				Text = name or "Color Picker", 
				TextColor3 = Theme.TextColor, 
				TextScaled = true, 
				TextXAlignment = EnumAlignX, 
				Parent = innerFrame
			})

			local colorDisplay = Create("TextButton", {
				BackgroundColor3 = defColor, 
				Size = U2s(0.15, 0.7), 
				Position = U2s(0.8, 0.15), 
				Text = "", 
				AutoButtonColor = false,
				Parent = innerFrame, 
				Create("UICorner", {CornerRadius = UDim.new(0.2, 0)}), 
				Create("UIStroke", {Thickness = 1, Color = Theme.BorderColor})
			})

			local infoHandler = HandleInfo(innerFrame, info)

			local pickerContainer = Create("CanvasGroup", {
				BackgroundColor3 = Theme.BackgroundColor, 
				BackgroundTransparency = Theme.Transparency + 0.1, 
				Position = U2s(0, 1), 
				Size = U2n(1, 0, 0, 150), 
				GroupTransparency = 1,
				Visible = false, 
				Parent = prnt2 or parent, 
				Create("UICorner", {CornerRadius = Layout.ElementCorner}),
				Create("UIStroke", {Thickness = 1.5, Color = Theme.BorderColor})
			})

			local satFrame = Create("TextButton", {
				Size = U2s(0.68, 0.55), 
				Position = U2s(0.02, 0.04), 
				BackgroundColor3 = Color3.fromHSV(h, 1, 1),
				AutoButtonColor = false,
				Text = "",
				ZIndex = 51, 
				Parent = pickerContainer, 
				Create("UICorner", {CornerRadius = UDim.new(0.04, 0)})
			})

			Create("Frame", {
				Size = U2s(1, 1),
				BackgroundColor3 = C3n(1, 1, 1),
				ZIndex = 52,
				Parent = satFrame,
				Create("UICorner", {CornerRadius = UDim.new(0.04, 0)}),
				Create("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			})

			Create("Frame", {
				Size = U2s(1, 1),
				BackgroundColor3 = C3n(0, 0, 0),
				ZIndex = 53,
				Parent = satFrame,
				Create("UICorner", {CornerRadius = UDim.new(0.04, 0)}),
				Create("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})

			local satCursor = Create("Frame", {
				Size = U2o(10, 10),
				AnchorPoint = V2n(0.5, 0.5),
				Position = U2s(s, 1 - v),
				BackgroundColor3 = C3n(1, 1, 1),
				ZIndex = 55,
				Parent = satFrame,
				Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
				Create("UIStroke", {Thickness = 1.5, Color = C3n(0, 0, 0)})
			})

			local hueFrame = Create("TextButton", {
				Size = U2s(0.08, 0.55), 
				Position = U2s(0.72, 0.04), 
				BackgroundColor3 = C3n(1, 1, 1),
				AutoButtonColor = false,
				Text = "",
				ZIndex = 51, 
				Parent = pickerContainer, 
				Create("UICorner", {CornerRadius = UDim.new(0.2, 0)}),
				Create("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, C3r(255, 0, 0)),
						ColorSequenceKeypoint.new(0.167, C3r(255, 255, 0)),
						ColorSequenceKeypoint.new(0.333, C3r(0, 255, 0)),
						ColorSequenceKeypoint.new(0.5, C3r(0, 255, 255)),
						ColorSequenceKeypoint.new(0.667, C3r(0, 0, 255)),
						ColorSequenceKeypoint.new(0.833, C3r(255, 0, 255)),
						ColorSequenceKeypoint.new(1, C3r(255, 0, 0))
					})
				})
			})

			local hueCursor = Create("Frame", {
				Size = U2n(1.4, 0, 0, 5),
				AnchorPoint = V2n(0.5, 0.5),
				Position = U2s(0.5, 1 - h),
				BackgroundColor3 = C3n(1, 1, 1),
				ZIndex = 55,
				Parent = hueFrame,
				Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
				Create("UIStroke", {Thickness = 1.5, Color = C3n(0, 0, 0)})
			})

			local previewFrame = Create("Frame", {
				Size = U2s(0.14, 0.55),
				Position = U2s(0.84, 0.04),
				BackgroundColor3 = Theme.AccentColor,
				ClipsDescendants = true,
				ZIndex = 51,
				Parent = pickerContainer,
				Create("UICorner", {CornerRadius = UDim.new(0.1, 0)}),
				Create("UIStroke", {Thickness = 1, Color = Theme.BorderColor})
			})

			local oldColorPreview = Create("Frame", {
				Size = U2s(1, 0.5),
				Position = U2s(0, 0),
				BackgroundColor3 = defColor,
				BorderSizePixel = 0,
				ZIndex = 52,
				Parent = previewFrame
			})

			local newColorPreview = Create("Frame", {
				Size = U2s(1, 0.5),
				Position = U2s(0, 0.5),
				BackgroundColor3 = defColor,
				BorderSizePixel = 0,
				ZIndex = 52,
				Parent = previewFrame
			})

			local hexInput = Create("TextBox", {
				Size = U2s(0.3, 0.16),
				Position = U2s(0.02, 0.63),
				BackgroundColor3 = Theme.AccentColor,
				TextColor3 = Theme.TextColor,
				PlaceholderText = "HEX",
				Text = "#" .. ToHex(defColor),
				TextScaled = true,
				ZIndex = 51,
				ClearTextOnFocus = false,
				Parent = pickerContainer,
				Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Create("UIStroke", {Thickness = 1, Color = Theme.BorderColor})
			})

			local rgbInput = Create("TextBox", {
				Size = U2s(0.48, 0.16),
				Position = U2s(0.34, 0.63),
				BackgroundColor3 = Theme.AccentColor,
				TextColor3 = Theme.TextColor,
				PlaceholderText = "R, G, B",
				Text = string.format("%d, %d, %d", math.floor(defColor.R * 255), math.floor(defColor.G * 255), math.floor(defColor.B * 255)),
				TextScaled = true,
				ZIndex = 51,
				ClearTextOnFocus = false,
				Parent = pickerContainer,
				Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Create("UIStroke", {Thickness = 1, Color = Theme.BorderColor})
			})

			local paletteFrame = Create("Frame", {
				Size = U2s(0.96, 0.12),
				Position = U2s(0.02, 0.83),
				BackgroundTransparency = 1,
				ZIndex = 51,
				Parent = pickerContainer,
				Create("UIListLayout", {
					FillDirection = EnumFill,
					HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
					SortOrder = EnumSort
				})
			})

			local presetColors = {
				C3r(255, 50, 50), C3r(255, 150, 50), C3r(255, 255, 50),
				C3r(50, 255, 50), C3r(50, 255, 255), C3r(50, 150, 255),
				C3r(150, 50, 255), C3r(255, 50, 255), C3r(255, 255, 255),
				C3r(20, 20, 20)
			}

			local function UpdateColor(isTyping)
				h = math.clamp(h, 0, 1)
				s = math.clamp(s, 0, 1)
				v = math.clamp(v, 0, 1)

				local col = Color3.fromHSV(h, s, v) 
				colorDisplay.BackgroundColor3 = col 
				newColorPreview.BackgroundColor3 = col
				satFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

				PlayTween(satCursor, SharedTweens.Fast, {Position = U2s(s, 1 - v)})
				PlayTween(hueCursor, SharedTweens.Fast, {Position = U2s(0.5, 1 - h)})

				if not isTyping then
					if not hexInput:IsFocused() then hexInput.Text = "#" .. ToHex(col) end
					if not rgbInput:IsFocused() then rgbInput.Text = string.format("%d, %d, %d", math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255)) end
				end

				callback(col)
			end

			for _, pColor in ipairs(presetColors) do
				local pBtn = Create("TextButton", {
					Size = U2s(0.085, 1),
					BackgroundColor3 = pColor,
					Text = "",
					ZIndex = 52,
					Parent = paletteFrame,
					Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
					Create("UIStroke", {Thickness = 1, Color = Theme.BorderColor})
				})
				Track(pBtn.MouseButton1Click:Connect(function()
					h, s, v = pColor:ToHSV()
					UpdateColor()
				end))
			end

			local function TogglePicker() 
				expanded = not expanded
				PlayInteractSound()

				if expanded then
					oldColorPreview.BackgroundColor3 = colorDisplay.BackgroundColor3
					pickerContainer.Visible = true
					pickerContainer.Size = U2n(1, 0, 0, 150)
					PlayTween(pickerContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = U2n(1, 0, 0, 175),
						GroupTransparency = 0
					})
				else
					PlayTween(pickerContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
						Size = U2n(1, 0, 0, 150),
						GroupTransparency = 1
					}, function()
						if not expanded then pickerContainer.Visible = false end
					end)
				end
			end

			Track(colorDisplay.MouseButton1Click:Connect(TogglePicker))
			Track(label.MouseButton1Click:Connect(TogglePicker))

			local function BindDrag(frame, isHue)
				local dragInput, dragConn, scrollFrame

				local current = frame
				while current and current ~= game do
					if current:IsA("ScrollingFrame") then scrollFrame = current break end
					current = current.Parent
				end

				local function updateDrag(input)
					local absPos = frame.AbsolutePosition
					local absSize = frame.AbsoluteSize
					local width = math.max(1, absSize.X)
					local height = math.max(1, absSize.Y)
					local pos = input.Position

					if isHue then
						h = 1 - math.clamp((pos.Y - absPos.Y) / height, 0, 1)
					else
						s = math.clamp((pos.X - absPos.X) / width, 0, 1)
						v = 1 - math.clamp((pos.Y - absPos.Y) / height, 0, 1)
					end
					UpdateColor(false)
				end

				Track(frame.InputBegan:Connect(function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not GlobalDragState then
						GlobalDragState = true
						dragInput = input
						if scrollFrame then scrollFrame.ScrollingEnabled = false end
						updateDrag(input)

						if dragConn then dragConn:Disconnect() end
						dragConn = Track(UserInputService.InputChanged:Connect(function(changedInput)
							if changedInput == dragInput or (changedInput.UserInputType == Enum.UserInputType.MouseMovement and input.UserInputType == Enum.UserInputType.MouseButton1) then
								updateDrag(changedInput)
							end
						end))
					end
				end))

				Track(UserInputService.InputEnded:Connect(function(input)
					if dragInput then
						if input == dragInput or (input.UserInputType == Enum.UserInputType.MouseButton1 and dragInput.UserInputType == Enum.UserInputType.MouseButton1) or input.UserInputType == Enum.UserInputType.Touch then
							GlobalDragState = false
							if dragConn then dragConn:Disconnect(); dragConn = nil end
							dragInput = nil
							if scrollFrame then scrollFrame.ScrollingEnabled = true end
						end
					end
				end))
			end

			BindDrag(satFrame, false)
			BindDrag(hueFrame, true)

			Track(hexInput.FocusLost:Connect(function()
				local txt = hexInput.Text:gsub("#", "")
				local r, g, b

				if #txt == 3 then
					local r1, g1, b1 = txt:match("(%x)(%x)(%x)")
					if r1 then r, g, b = r1..r1, g1..g1, b1..b1 end
				elseif #txt >= 6 then
					r, g, b = txt:match("(%x%x)(%x%x)(%x%x)")
				end

				if r and g and b then
					local col = C3r(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
					h, s, v = col:ToHSV()
					UpdateColor(false)
				else
					hexInput.Text = "#" .. ToHex(colorDisplay.BackgroundColor3)
				end
			end))

			Track(rgbInput.FocusLost:Connect(function()
				local r, g, b = rgbInput.Text:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
				if r and g and b then
					local col = C3r(math.clamp(tonumber(r), 0, 255), math.clamp(tonumber(g), 0, 255), math.clamp(tonumber(b), 0, 255))
					h, s, v = col:ToHSV()
					UpdateColor(false)
				else
					rgbInput.Text = string.format("%d, %d, %d", math.floor(colorDisplay.BackgroundColor3.R * 255), math.floor(colorDisplay.BackgroundColor3.G * 255), math.floor(colorDisplay.BackgroundColor3.B * 255))
				end
			end))

			function api:setColor(col)
				if typeof(col) == "Color3" then
					h, s, v = col:ToHSV()
					UpdateColor(false)
				end
			end

			function api:getColor()
				return Color3.fromHSV(h, s, v) 
			end

			function api:update(newName, newInfo)
				if newName then label.Text = newName end
				infoHandler:Update(newInfo)
			end

			function api:destroy()
				infoHandler:Destroy()
				baseFrame:Destroy()
				pickerContainer:Destroy()
			end

			function api:Visible(state)
				local targetState = state ~= nil and state or not baseFrame.Visible
				baseFrame.Visible = targetState
				if not targetState and expanded then TogglePicker() end
			end

			return api
		end

		function compTable:addKeybind(name, ...)
			local info, defBind, callback = getArgs(...)
			local api = {}
			local callback = callback or function() end
			local baseFrame = CreateBaseComp(parent) 
			local currentBind = defBind or Enum.KeyCode.Unknown 
			local isBinding = false

			Create("TextLabel", {
				BackgroundTransparency = 1, 
				Size = U2s(0.6, 1), 
				Position = Layout.ButtonPOS, 
				Text = name or "Keybind", 
				TextColor3 = Theme.TextColor, 
				TextScaled = true, 
				TextXAlignment = EnumAlignX, 
				Parent = baseFrame
			})

			local bindBtn = Create("TextButton", {
				BackgroundColor3 = Theme.AccentColor, 
				Size = U2s(0.3, 0.8), 
				Position = U2s(0.65, 0.1), 
				Text = currentBind.Name, 
				TextColor3 = Theme.TextColor, 
				TextScaled = true, 
				Parent = baseFrame, 
				Create("UICorner", {CornerRadius = UDim.new(0.15, 0)}), 
				Create("UIStroke", {Thickness = 1, Color = Theme.BorderColor})
			})

			local infoHandler = HandleInfo(baseFrame, info)

			Track(bindBtn.MouseButton1Click:Connect(function() 
				isBinding = true 
				bindBtn.Text = "..." 
				TweenService:Create(bindBtn, SharedTweens.Fast, {BackgroundColor3 = Theme.NotificationsMainColor}):Play() 
			end))

			local inputConn = Track(UserInputService.InputBegan:Connect(function(input, gpe)
				if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then 
					if input.KeyCode == Enum.KeyCode.Escape then
						isBinding = false
						bindBtn.Text = currentBind.Name
					elseif not gpe then
						currentBind = input.KeyCode 
						bindBtn.Text = currentBind.Name 
						isBinding = false 
						callback(currentBind)
					end

					if not isBinding then
						TweenService:Create(bindBtn, SharedTweens.Fast, {BackgroundColor3 = Theme.AccentColor}):Play()
					end
				elseif not isBinding and input.KeyCode == currentBind and not gpe then 
					callback(currentBind) 
				end
			end))

			function api:updateBind(nb) 
				currentBind = nb 
				bindBtn.Text = currentBind.Name 
			end

			function api:destroy() 
				if inputConn then inputConn:Disconnect() end 
				infoHandler:Destroy() 
				baseFrame:Destroy() 
			end

			function api:Visible(state)
				local targetState = state ~= nil and state or not baseFrame.Visible
				baseFrame.Visible = targetState
			end
			return api
		end

		function compTable:addSB(name, ...)
			local Info, btnText, beginVal, min, max, callback = getArgs(...)
			local currentSliderVal = beginVal or min
			local callback = callback or function() end

			local api, frame = CreateSlider(name, Info, beginVal, min, max, function(val)
				currentSliderVal = val
				callback(currentSliderVal, false)
			end, 0.28, U2s(0.35, 0.4))

			local actionBtn = Create("TextButton", {
				BackgroundColor3 = Theme.ButtonColor:Lerp(C3n(0,0,0), 0.25), 
				TextColor3 = Theme.TextColor, 
				Text = btnText or "Button", 
				TextScaled = true, 
				Size = U2s(0.2, 0.8), 
				Position = U2s(0.78, 0.1), 
				Parent = frame, 
				Create("UICorner", {CornerRadius = UDim.new(0.15, 0)}), 
				Create("UIStroke", {Thickness = 1.5, Color = Theme.BorderColor, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
			})

			Track(actionBtn.MouseButton1Click:Connect(function() 
				ApplyRipple(actionBtn)
				PlayInteractSound() 
				callback(currentSliderVal, true)
			end))

			return api
		end

		function compTable:addST(name, ...)
			local info, beginVal, minVal, maxVal, callback, defaultToggle, style = getArgs(...)
			local callback = callback or function() end
			

			local currentSliderVal = beginVal or minVal
			local currentToggleVal = defaultToggle or false

			local api, frame, LTB = CreateSlider(name, info, beginVal, minVal, maxVal, function(val)
				currentSliderVal = val
				callback(currentSliderVal, currentToggleVal)
			end, 0.28, U2s(0.35, 0.4))

			local tApi, tBtn, doToggle = SetupToggle(frame, defaultToggle, style)

			Track(tBtn.MouseButton1Click:Connect(function() 
				currentToggleVal = doToggle()
				callback(currentSliderVal, currentToggleVal)
			end))

			if defaultToggle then task.spawn(function() callback(currentSliderVal, currentToggleVal) end) end

			for k, v in pairs(tApi) do api[k] = v end 
			return api
		end

		function compTable:addDT(name, ...)
			local info, items, perRow, callback, defaultDrop, defaultToggle, style = getArgs(...)
			local callback, DropVal, ToggleVal = callback or function() end, defaultDrop, defaultToggle or false

			local api, frame = CreateDropdown(name, info, items, perRow, function(v)
				DropVal = v
				callback(DropVal, ToggleVal)
			end, defaultDrop, U2n(1, -110, 1, 0), U2n(1, -90, 0, 0))

			local tApi, tBtn, doToggle = SetupToggle(frame, defaultToggle, style)

			Track(tBtn.MouseButton1Click:Connect(function() 
				ToggleVal = doToggle()
				callback(DropVal, ToggleVal)
			end))

			if defaultToggle then task.spawn(function() callback(DropVal, ToggleVal) end) end

			for k, v in pairs(tApi) do api[k] = v end 
			return api
		end

		function compTable:addMDT(name, ...)
			local info, items, perRow, defaultVals, callback, defaultToggle, style = getArgs(...)
			local api = {}
			local expanded = false
			local selectedItems = {}
			local currentToggleVal = defaultToggle or false
			local callback = callback or function() end

			if type(defaultVals) == "table" then
				for _, val in ipairs(defaultVals) do
					if table.find(items, val) then selectedItems[val] = true end
				end
			end

			local function getSelectedArray()
				local arr = {}
				for k in pairs(selectedItems) do table.insert(arr, k) end
				return arr
			end

			local baseFrame = CreateBaseComp(parent)

			local btn = Create("TextButton", {
				BackgroundTransparency = 1, 
				Size = U2n(1, -110, 1, 0), 
				Position = Layout.ButtonPOS, 
				Text = name or "Multi Dropdown Toggle", 
				TextColor3 = Theme.TextColor, 
				TextScaled = true, 
				TextXAlignment = EnumAlignX,
				Create("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}),
				Parent = baseFrame
			})

			local iconBtn = Create("ImageButton", {
				BackgroundTransparency = 1, 
				Position = U2n(1, -90, 0, 0), 
				Size = U2s(0.1, 1), 
				Image = "http://www.roblox.com/asset/?id=6031090994", 
				ImageColor3 = Theme.TextColor, 
				Parent = baseFrame
			})

			local tApi, tBtn, doToggle = SetupToggle(baseFrame, defaultToggle, style)
			local infoHandler = HandleInfo(baseFrame, info) 

			local listFrame = Create("ScrollingFrame", {
				BackgroundColor3 = Theme.BackgroundColor, 
				BackgroundTransparency = Theme.Transparency + 0.3, 
				Position = U2s(0, 1), 
				Size = U2s(1, 0), 
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = U2o(0, 0),
				Visible = false, 
				ScrollBarThickness = 3, 
				Parent = prnt2 or parent, 
				Create("UICorner", {CornerRadius = Layout.ElementCorner}), 
				Create("UIGridLayout", {
					CellSize = U2n(1 / perRow, -10, 0, 30), 
					CellPadding = U2o(5, 5), 
					FillDirection = EnumFill, 
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				})
			})

			local function updateBtnText()
				local count = 0
				for _ in pairs(selectedItems) do count += 1 end
				btn.Text = count > 0 and (name .. ":[" .. count .. "]") or name
			end
			updateBtnText()

			local function ToggleDropdown(forceState)
				local targetState = forceState ~= nil and forceState or not expanded
				if targetState == expanded then return end 
				expanded = targetState 
				PlayInteractSound()
				AnimateDropdown(listFrame, iconBtn, expanded, #items, perRow)
			end

			local itemPool = {}
			local function BuildItems()
				for i, child in ipairs(itemPool) do
					child.Visible = false
				end

				for i, item in ipairs(items) do
					local itemBtn = itemPool[i]
					if not itemBtn then
						itemBtn = Create("TextButton", {
							BackgroundColor3 = Theme.ButtonColor,
							Size = U2n(1, 0, 0, Layout.ButtonSizeY),
							TextColor3 = Theme.TextColor,
							TextScaled = true,
							BackgroundTransparency = 1,
							TextTransparency = 1,
							ZIndex = 51,
							Parent = listFrame,
							GetCorner()
						})
						table.insert(itemPool, itemBtn)
						Track(itemBtn.MouseButton1Click:Connect(function()
							local selected = items[table.find(itemPool, itemBtn)]
							btn.Text = selected and (name .. ": " .. tostring(selected)) or name
							callback(getSelectedArray(), currentToggleVal)
							ToggleDropdown(false)
						end))
					end
					itemBtn.Text = tostring(item)
					itemBtn.Visible = true
				end
			end

			BuildItems()

			local action = function() 
				currentToggleVal = doToggle()
				callback(getSelectedArray(), currentToggleVal)
			end
			Track(tBtn.MouseButton1Click:Connect(action))
			for _, b in {btn, iconBtn} do Track(b.MouseButton1Click:Connect(function() ToggleDropdown() end)) end

			if next(selectedItems) then task.spawn(function() callback(getSelectedArray(), currentToggleVal) end) end
			if defaultToggle then task.spawn(function() callback(getSelectedArray(), currentToggleVal) end) end

			function api:ToggleDropdown(state) ToggleDropdown(state) end
			function api:newName(n) name = n updateBtnText() end
			function api:newInfo(i) infoHandler:Update(i) end
			function api:newCallback(c) callback = c end
			function api:setItems(t) 
				if type(t) == "table" then 
					items = t 
					local newSel = {}
					for k in pairs(selectedItems) do if table.find(items, k) then newSel[k] = true end end
					selectedItems = newSel
					updateBtnText()
					BuildItems() 
				end 
			end
			function api:getSelected() return getSelectedArray() end
			function api:setSelected(arr, silent) 
				if type(arr) == "table" then
					selectedItems = {}
					for _, v in ipairs(arr) do if table.find(items, v) then selectedItems[v] = true end end
					updateBtnText()
					BuildItems()
					if not silent then callback(getSelectedArray(), currentToggleVal) end
				end
			end
			function api:destroy() baseFrame:Destroy() listFrame:Destroy() end

			function api:Visible(state)
				local targetState = state ~= nil and state or not baseFrame.Visible
				baseFrame.Visible = targetState
				if not targetState and expanded then ToggleDropdown(false) end
			end

			for k, v in pairs(tApi) do api[k] = v end 
			return api
		end

		function compTable:addLabel(text)
			local api = {} 
			local labelFrame = Create("Frame", {
				Size = Layout.ButtonSize,
				BackgroundColor3 = Theme.ButtonColor,
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				Parent = parent,
				GetCorner(),
				Create("UIPadding", {PaddingLeft = UDim.new(0.02, 0), PaddingRight = UDim.new(0.02, 0)}),
				Create("UIListLayout", {Padding = UDim.new(0.02, 0), FillDirection = EnumFill, SortOrder = EnumSort, VerticalAlignment = EnumAlignY})
			})

			local label = Create("TextLabel", {
				Size = U2s(1, 1),
				Position = Layout.ButtonPOS,
				Text = text or "Label", 
				TextColor3 = Theme.TextColor,
				TextScaled = true,
				BackgroundTransparency = 1,
				Parent = labelFrame
			})

			function api:updateLabel(t) label.Text = t or label.Text end
			BindBaseAPI(api, labelFrame)
			return api
		end	

		function compTable:addSection(text)
			local api = {} 
			local section = Create("TextLabel", {
				Size = Layout.ButtonSize, 
				BackgroundColor3 = Theme.ButtonColor, 
				Text = "  " .. (text or "Section"), 
				TextColor3 = Theme.TextColor, 
				TextScaled = true, 
				TextXAlignment = EnumAlignX, 
				Parent = parent, 
				Create("UICorner", {CornerRadius = Layout.ElementCorner})
			})

			function api:updateSection(t) section.Text = "  " .. (t or section.Text) end
			function api:destroy() section:Destroy() end
			function api:Visible(state)
				local targetState = state ~= nil and state or not section.Visible
				section.Visible = targetState
			end
			return api
		end

		function compTable:addSeparator() 
			local api = {}
			local sep = Create("Frame", {
				BackgroundColor3 = C3r(120, 120, 120), BackgroundTransparency = Theme.Transparency + 0.5, 
				Size = U2n(0.95, 0, 0, 1), Parent = parent, Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
			})

			BindBaseAPI(api, sep)
			return api
		end
	end

	CreateFrameBtn = function(fn, fInfo, prnt)
		local api = {} 
		local childContent = Create("Frame", {
			Size = U2s(1, 1), 
			BackgroundTransparency = 1, 
			Visible = false, 
			Parent = TabContentScroll, 
			Create("UIListLayout", {
				SortOrder = EnumSort, 
				HorizontalAlignment = Enum.HorizontalAlignment.Center, 
				Padding = UDim.new(0.007, 5)
			})
		})
		Tabs[#Tabs + 1] = childContent 

		local baseFrame = CreateBaseComp(prnt)
		local btn = Create("TextButton", {
			BackgroundTransparency = 1, 
			Position = Layout.ButtonPOS, 
			Size = TextSize.WithIcon, 
			Text = fn, 
			TextColor3 = Theme.TextColor, 
			TextScaled = true, 
			TextXAlignment = EnumAlignX, 
			Parent = baseFrame
		})

		Create("TextLabel", {
			BackgroundTransparency = 1, 
			Position = U2s(0.9, 0), 
			Size = U2s(0.1, 1), 
			Text = "→", 
			TextColor3 = Theme.TextColor, 
			TextScaled = true, 
			Parent = baseFrame
		})

		local infoHandler = HandleInfo(baseFrame, fInfo)

		Track(btn.MouseButton1Click:Connect(function() 
			ApplyRipple(btn)
			PlayInteractSound() 
			for _, tb in pairs(Tabs) do tb.Visible = false end
			childContent.Visible = true 
			TabContentScroll.CanvasPosition = V2n(0, 0)
		end))

		local backBase = CreateBaseComp(childContent)
		local backBtn = Create("TextButton", {
			BackgroundTransparency = 1, 
			Position = Layout.ButtonPOS, 
			Size = TextSize.Full, 
			Text = "← Back", 
			TextColor3 = Theme.TextColor, 
			TextScaled = true, 
			TextXAlignment = EnumAlignX, 
			Parent = backBase
		})

		Track(backBtn.MouseButton1Click:Connect(function() 
			ApplyRipple(backBtn)
			PlayInteractSound() 
			for _, tb in pairs(Tabs) do tb.Visible = false end 
			prnt.Visible = true
			TabContentScroll.CanvasPosition = V2n(0, 0)
		end))

		ApplyHover(btn, baseFrame, Theme.AccentColor, Theme.ButtonColor) 
		ApplyHover(backBtn, backBase, Theme.AccentColor, Theme.ButtonColor)

		function api:updateFrameButton(n, i) btn.Text = n or fn infoHandler:Update(i) end
		function api:openFrame() 
			for _, tb in pairs(Tabs) do tb.Visible = false end 
			childContent.Visible = true
		end
		function api:destroy() 
			infoHandler:Destroy() 
			childContent:Destroy() 
			baseFrame:Destroy() 
		end
		function api:addRow(fpr, lns) return CreateRow(childContent, fpr, lns) end
		function api:addFrameButton(n, i) return CreateFrameBtn(n, i, childContent) end

		BuildComponents(api, childContent) 
		return api
	end

	CreateRow = function(parnt, count, lns)
		local api = {} 
		local rowFrame = Create("Frame", {
			Size = U2n(0.95, 0, 0, 30), 
			BackgroundTransparency = 1, 
			Parent = parnt
		})

		local gridLayout = Create("UIGridLayout", {
			CellPadding = U2n(0.02, 0, 0, 5), 
			FillDirection = EnumFill, 
			HorizontalAlignment = Enum.HorizontalAlignment.Center, 
			VerticalAlignment = Enum.VerticalAlignment.Top, 
			SortOrder = EnumSort, 
			Parent = rowFrame
		})

		local function UpdateRow()
			local visCount = 0 
			for _, c in ipairs(rowFrame:GetChildren()) do 
				if c:IsA("GuiObject") and c.Visible then visCount += 1 end 
			end
			if visCount == 0 then return end 

			local actFpr = count and math.min(visCount, count) or visCount
			local cellW = actFpr > 0 and ((1 - ((actFpr - 1) * gridLayout.CellPadding.X.Scale)) / actFpr) or 1
			local numRows = math.ceil(visCount / actFpr)
			local cellH = (lns and lns > 0) and (30 / lns) or 30

			gridLayout.CellSize = U2n(cellW, 0, 0, cellH)
			rowFrame.Size = U2n(0.95, 0, 0, (numRows * cellH) + ((numRows - 1) * gridLayout.CellPadding.Y.Offset))
		end

		Track(rowFrame.ChildAdded:Connect(UpdateRow)) 
		Track(rowFrame.ChildRemoved:Connect(UpdateRow)) 
		UpdateRow()

		function api:addFrameButton(n, i) return CreateFrameBtn(n, i, rowFrame) end
		function api:addRow(nf, nl) return CreateRow(rowFrame, nf, nl) end

		BuildComponents(api, rowFrame, parnt) 
		return api
	end

	local SidebarCollapsed = true
	local TabsTextLabels = {}

	Track(SidebarToggleBtn.MouseButton1Click:Connect(function()
		SidebarCollapsed = not SidebarCollapsed
		PlayInteractSound()

		local targetTabWidth = SidebarCollapsed and UDim2.new(0.1, 0, 0.835, 0) or UDim2.new(0.2, 0, 0.835, 0)
		local targetContentWidth = SidebarCollapsed and UDim2.new(0.88, 0, 0.835, 0) or UDim2.new(0.77, 0, 0.835, 0)
		local targetContentPos = SidebarCollapsed and UDim2.new(0.11, 0, 0.15, 0) or UDim2.new(0.2, 0, 0.15, 0)

		for _, btn in ipairs(TabsButtons) do
			local container = btn:FindFirstChild("ContentContainer")
			if container then
				local layout = container:FindFirstChildOfClass("UIListLayout")
				if layout then
					layout.HorizontalAlignment = SidebarCollapsed and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
				end
				local padding = container:FindFirstChildOfClass("UIPadding")
				if padding then
					padding.PaddingLeft = SidebarCollapsed and UDim.new(0, 0) or UDim.new(0, 5)
				end
			end
		end

		PlayTween(TabContainer, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = targetTabWidth})
		PlayTween(TabContentScroll, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = targetContentWidth, Position = targetContentPos})

		for _, txtLabel in ipairs(TabsTextLabels) do
			if SidebarCollapsed then
				PlayTween(txtLabel, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextTransparency = 1, Size = UDim2.new(0, 0, 1, 0)})
			else
				PlayTween(txtLabel, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0, Size = UDim2.new(0.7, -5, 1, 0)})
			end
		end
	end))

	local function AddTabInternal(text, iconId)
		local tabBtn = Create("TextButton", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			Size = UDim2.new(0.85, 0, 0, 28),
			Parent = TabContainer
		})

		local contentContainer = Create("Frame", {
			Name = "ContentContainer",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Parent = tabBtn,
			Create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = SidebarCollapsed and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 8)
			}),
			Create("UIPadding", {
				PaddingLeft = SidebarCollapsed and UDim.new(0, 0) or UDim.new(0, 5)
			})
		})

		local iconLabel
		if iconId then 
			iconLabel = Create("ImageLabel", {
				Size = UDim2.new(0, 20, 0, 20),
				ImageColor3 = Theme.TextColor, 
				Image = tonumber(iconId) and ("rbxassetid://" .. iconId) or iconId, 
				BackgroundTransparency = 1,
				Parent = contentContainer
			}) 
		end

		local textLabel = Create("TextLabel", {
			Size = SidebarCollapsed and UDim2.new(0, 0, 1, 0) or UDim2.new(0.7, -5, 1, 0),
			BackgroundTransparency = 1,
			Text = text or "Tab",
			TextColor3 = Theme.TextColor,
			TextScaled = true,
			TextXAlignment = EnumAlignX,
			TextTransparency = SidebarCollapsed and 1 or 0,
			ClipsDescendants = true,
			Parent = contentContainer
		})

		table.insert(TabsTextLabels, textLabel)

		local contentFrame = Create("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = TabContentScroll, 
			Create("UIListLayout", {
				SortOrder = EnumSort,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.015, 5)
			})
		})

		Tabs[#Tabs + 1] = contentFrame 
		TabsButtons[#TabsButtons + 1] = tabBtn

		if #Tabs == 1 then contentFrame.Visible = true currentTab = contentFrame end

		local underline = Create("Frame", {
			Name = "Underline",
			Size = UDim2.new(0, 0, 0, 2),
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0), 
			BackgroundColor3 = Theme.TabUnderLineColor,
			BorderSizePixel = 0,
			Parent = tabBtn,
			Create("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Theme.TabUnderLineColor),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Theme.TabUnderLineColor)
				})
			})
		})

		if #Tabs == 1 then underline.Size = UDim2.new(1, 0, 0, 2) end

		Track(tabBtn.MouseEnter:Connect(function() 
			if currentTab ~= contentFrame then PlayTween(underline, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, 0, 0, 2)}) end
			if iconLabel then PlayTween(iconLabel, SharedTweens.Fast, {ImageTransparency = 0.2}) end
			if SidebarCollapsed and UserInputService:GetLastInputType() ~= Enum.UserInputType.Touch then ShowInfo(text or "Tab") end
		end))

		Track(tabBtn.MouseLeave:Connect(function() 
			if currentTab ~= contentFrame then PlayTween(underline, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 2)}) end
			if iconLabel then PlayTween(iconLabel, SharedTweens.Fast, {ImageTransparency = 0}) end
			if SidebarCollapsed then HideInfo() end
		end))

		Track(tabBtn.MouseButton1Click:Connect(function()
			if isAnimating or currentTab == contentFrame then return end 
			PlayTween(underline, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 2)})

			for _, tBtn in ipairs(TabsButtons) do
				if tBtn ~= tabBtn then
					local otherUnderline = tBtn:FindFirstChild("Underline")
					if otherUnderline then PlayTween(otherUnderline, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 2)}) end
				end
			end 

			PlayInteractSound() 
			isAnimating = true 
			local previous = currentTab 
			currentTab = contentFrame 

			UpdateSearchCache()
			ApplySearchFilter()

			for _, btn in ipairs(TabsButtons) do 
				PlayTween(btn, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundColor3 = (btn == tabBtn) and Theme.AccentColor or Theme.ButtonColor}) 
			end

			if previous then 
				previous.Visible = false 
				previous.Position = UDim2.new(0, 0, 0, 0)
			end

			contentFrame.Position = UDim2.new(0, 0, 0, 15)
			contentFrame.BackgroundTransparency = 1
			contentFrame.Visible = true

			PlayTween(contentFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}, function()
				isAnimating = false
			end)
		end))

		return contentFrame
	end

	local TabsAndStyles = {}

	function TabsAndStyles:addTab(name, icon)
		local tabContent = AddTabInternal(name, icon) 
		local tabApi = {} 
		BuildComponents(tabApi, tabContent)

		function tabApi:addFrameButton(n, i) return CreateFrameBtn(n, i, tabContent) end
		function tabApi:addRow(fpr, lns) return CreateRow(tabContent, fpr, lns) end

		return tabApi
	end

	local Resizer = Create("TextButton", {
		Size = UDim2.new(0, 22, 0, 22),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 100,
		ClipsDescendants = true,
		Parent = Frame
	})

	local resizerVisual = Create("Frame", {
		Size = UDim2.new(0, 44, 0, 44),
		Position = UDim2.new(1, -2, 1, -2),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Parent = Resizer,
		Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
	})

	local rVUIS = Create("UIStroke", {
		Thickness = 2.5,
		Color = Theme.TextColor,
		Transparency = 0.6,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = resizerVisual,
	})

	local rzng, rzInput, rzStartPos, rzStartSize
	local function updateResizerVisuals(trans)
		PlayTween(rVUIS, SharedTweens.Fast, {Transparency = trans})
	end

	Track(Resizer.MouseEnter:Connect(function() updateResizerVisuals(0.1) end))
	Track(Resizer.MouseLeave:Connect(function() if not rzng then updateResizerVisuals(0.6) end end))
	Track(Resizer.InputBegan:Connect(function(input)
		if (input.UserInputType == EnumMouse1 or input.UserInputType == EnumTouch) and not GlobalDragState then
			GlobalDragState = true
			InteractionBlocker.Visible = true
			rzng, rzStartPos, rzStartSize = true, input.Position, Frame.AbsoluteSize
			updateResizerVisuals(0.1)
		end
	end))
	Track(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == EnumMouseMove or input.UserInputType == EnumTouch then rzInput = input end
	end))
	Track(RunService.Heartbeat:Connect(function()
		if rzng and rzInput then 
			local targetX = math.clamp(rzStartSize.X + (rzInput.Position.X - rzStartPos.X), 200, 800)
			local targetY = math.clamp(rzStartSize.Y + (rzInput.Position.Y - rzStartPos.Y), 200, 600)
			Frame.Size = U2o(targetX, targetY) 
		end
	end))
	Track(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == EnumMouse1 or input.UserInputType == EnumTouch then
			if rzng then
				GlobalDragState = false
				InteractionBlocker.Visible = false
			end
			rzng, rzInput = false, nil
			updateResizerVisuals(0.6)
		end
	end))

	task.spawn(function()
		for i, data in ipairs(HeaderButtonsList) do
			task.spawn(function()
				task.wait((i - 1) * 0.06)
				PlayTween(data.element, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { 
					Position = data.targetPos, TextTransparency = 0 
				})
			end)
		end

		task.wait(0.15)

		PlayTween(TabContainer, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = U2s(0, 0.153)})

		task.wait(0.1)

		PlayTween(TabContentScroll, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {CanvasPosition = V2n(0, 0)})
	end)

	function TabsAndStyles:Init()
		local Blur = Instance.new("BlurEffect")
		Blur.Size = 0
		Blur.Parent = game:GetService("Lighting")

		local LoadGui = Create("Frame", {
			Size = U2o(260, 4), Position = U2s(0.5, 0.5), AnchorPoint = V2n(0.5, 0.5),
			BackgroundColor3 = Theme.AccentColor, ClipsDescendants = true, Parent = ScreenGui,
			Create("UICorner", { CornerRadius = UDim.new(1, 0) })
		})

		local LoadBar = Create("Frame", {
			Size = U2s(0, 1), BackgroundColor3 = Theme.Toggle.ToggleOnColor, Parent = LoadGui,
			Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
			Create("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C3r(255, 255, 255)), ColorSequenceKeypoint.new(1, Theme.Toggle.ToggleOnColor) }) })
		})

		local LoadTxt = Create("TextLabel", {
			Size = U2o(200, 20), Position = U2s(0.5, 0.5), AnchorPoint = V2n(0.5, 3), BackgroundTransparency = 1, Text = "INITIALIZING",
			Font = Enum.Font.GothamBlack, TextColor3 = Theme.TextColor, TextSize = 12, TextTransparency = 1, Parent = ScreenGui
		})

		TweenService:Create(Blur, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = 22}):Play()
		TweenService:Create(LoadTxt, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

		local steps = {0.3, 0.65, 0.9, 1}
		for _, v in ipairs(steps) do
			TweenService:Create(LoadBar, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = U2s(v, 1)}):Play()
			task.wait(random(2, 4) / 10)
		end

		TweenService:Create(LoadTxt, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		local lgHide = TweenService:Create(LoadGui, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = U2o(0, 4)})
		lgHide:Play()
		lgHide.Completed:Wait()
		LoadGui:Destroy()
		LoadTxt:Destroy()

		local sBtns = {}
		for _, c in ipairs(TabContainer:GetChildren()) do
			if c:IsA("TextButton") then c.Position = UDim2.new(c.Position.X.Scale, -25, c.Position.Y.Scale, c.Position.Y.Offset) table.insert(sBtns, c) end
		end

		local cEls = {}
		if currentTab then
			for _, c in ipairs(currentTab:GetChildren()) do
				if c:IsA("Frame") and not c:IsA("UIListLayout") then
					c.Position = UDim2.new(c.Position.X.Scale, c.Position.X.Offset, c.Position.Y.Scale, c.Position.Y.Offset + 25)
					c.BackgroundTransparency = 1
					for _, desc in ipairs(c:GetDescendants()) do
						if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then desc.TextTransparency = 1 end
						if desc:IsA("ImageLabel") or desc:IsA("ImageButton") then desc.ImageTransparency = 1 end
						if desc:IsA("UIStroke") then desc.Transparency = 1 end
						if desc:IsA("Frame") and desc ~= c then desc.BackgroundTransparency = 1 end
					end
					table.insert(cEls, c)
				end
			end
		end

		Frame.Visible = true
		TweenService:Create(Frame, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = Theme.Transparency}):Play()
		TweenService:Create(Frame:FindFirstChild("UIStroke"), TweenInfo.new(0.7), {Transparency = 0.6}):Play()
		TweenService:Create(fScale, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
		TweenService:Create(fShadow, TweenInfo.new(0.7), {ImageTransparency = 0.5}):Play()
		TweenService:Create(ContentClipper, TweenInfo.new(0.7), {GroupTransparency = 0}):Play()

		task.wait(0.2)
		TweenService:Create(Header, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = U2s(0, 0)}):Play()

		task.wait(0.15)
		for _, tb in ipairs(sBtns) do
			TweenService:Create(tb, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(tb.Position.X.Scale, 0, tb.Position.Y.Scale, tb.Position.Y.Offset)}):Play()
			task.wait(0.04)
		end

		for _, el in ipairs(cEls) do
			TweenService:Create(el, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(el.Position.X.Scale, el.Position.X.Offset, el.Position.Y.Scale, el.Position.Y.Offset - 25)}):Play()
			TweenService:Create(el, TweenInfo.new(0.5), {BackgroundTransparency = Theme.Transparency + 0.2}):Play()
			for _, desc in ipairs(el:GetDescendants()) do
				if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then TweenService:Create(desc, TweenInfo.new(0.4), {TextTransparency = 0}):Play() end
				if desc:IsA("ImageLabel") or desc:IsA("ImageButton") then TweenService:Create(desc, TweenInfo.new(0.4), {ImageTransparency = 0}):Play() end
				if desc:IsA("UIStroke") then TweenService:Create(desc, TweenInfo.new(0.4), {Transparency = 0.6}):Play() end
				if desc:IsA("Frame") and desc ~= el then TweenService:Create(desc, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play() end
			end
			task.wait(0.03)
		end

		TweenService:Create(Blur, TweenInfo.new(1.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = 0}):Play()
		task.delay(1.5, function() Blur:Destroy() end)
	end

	return TabsAndStyles
end

function kailex:UpdateSettings(newSettings)
	if not self.CurrentScreenGui then return end

	local oldSettings = {}
	local function cloneDeep(tbl)
		local copy = {}
		for k, v in pairs(tbl) do
			if type(v) == "table" then copy[k] = cloneDeep(v) else copy[k] = v end
		end
		return copy
	end
	oldSettings = cloneDeep(kailex.Setting)

	local function updateDeep(target, source)
		for k, v in pairs(source) do
			if type(v) == "table" and type(target[k]) == "table" then 
				updateDeep(target[k], v) 
			else 
				target[k] = v 
			end
		end
	end
	updateDeep(kailex.Setting, newSettings)

	local updates = {}
	local function mapUpdates(old, new)
		for k, v in pairs(old) do
			if type(v) == "table" then
				mapUpdates(v, new[k])
			elseif new[k] ~= nil and v ~= new[k] then
				table.insert(updates, {old = v, new = new[k]})
			end
		end
	end
	mapUpdates(oldSettings, kailex.Setting)

	for _, el in ipairs(self.CurrentScreenGui:GetDescendants()) do
		pcall(function()
			for _, diff in ipairs(updates) do
				local oldVal = diff.old
				local newVal = diff.new
				local tInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

				if typeof(oldVal) == "Color3" then
					if el:IsA("GuiObject") and el.BackgroundColor3 == oldVal then TweenService:Create(el, tInfo, {BackgroundColor3 = newVal}):Play() end
					if (el:IsA("TextLabel") or el:IsA("TextButton") or el:IsA("TextBox")) and el.TextColor3 == oldVal then TweenService:Create(el, tInfo, {TextColor3 = newVal}):Play() end
					if el:IsA("UIStroke") and el.Color == oldVal then TweenService:Create(el, tInfo, {Color = newVal}):Play() end
					if (el:IsA("ImageLabel") or el:IsA("ImageButton")) and el.ImageColor3 == oldVal then TweenService:Create(el, tInfo, {ImageColor3 = newVal}):Play() end
				elseif typeof(oldVal) == "UDim" then
					if el:IsA("UICorner") and el.CornerRadius == oldVal then TweenService:Create(el, tInfo, {CornerRadius = newVal}):Play() end
					if el:IsA("UIPadding") then
						if el.PaddingLeft == oldVal then TweenService:Create(el, tInfo, {PaddingLeft = newVal}):Play() end
						if el.PaddingRight == oldVal then TweenService:Create(el, tInfo, {PaddingRight = newVal}):Play() end
						if el.PaddingTop == oldVal then TweenService:Create(el, tInfo, {PaddingTop = newVal}):Play() end
						if el.PaddingBottom == oldVal then TweenService:Create(el, tInfo, {PaddingBottom = newVal}):Play() end
					end
				elseif typeof(oldVal) == "UDim2" then
					if el:IsA("GuiObject") and el.Size == oldVal then TweenService:Create(el, tInfo, {Size = newVal}):Play() end
					if el:IsA("UIGridLayout") and el.CellSize == oldVal then TweenService:Create(el, tInfo, {CellSize = newVal}):Play() end
				end
			end
		end)
	end
end

return kailex
