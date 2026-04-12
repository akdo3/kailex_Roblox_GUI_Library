# 🌌 Kailex UI Library
**Created by AKDO**

A sleek, modern, highly customizable, and animated UI library for Roblox. Kailex UI provides a smooth user experience with built-in search, resizable windows, tooltips, notifications, and a massive variety of interactive components.

---

## ✨ Features
* 🚀 **Smooth Animations:** Hover, click ripples, and smooth transitions.
* 🎨 **Fully Customizable:** Easily change themes, colors, and layouts.
* 🔍 **Built-in Search:** Automatically filters tab elements based on user input.
* 📱 **Adaptive & Resizable:** Draggable, resizable, and minimizable windows.
* 🔔 **Notification System:** Built-in dynamic notification queue.
* 🧩 **Rich Components:** Sliders, Color Pickers, Keybinds, Multi-Dropdowns, and more.

---

## ⚡ Quick Start (For Fast Learners)
Want to get your script running in under a minute? Copy and paste this code:

```lua
-- 1. Load the Library
local kailex = loadstring(game:HttpGet("https://raw.githubusercontent.com/akdo3/kailex_Roblox_GUI_Library/refs/heads/main/kailex_GUI_Library.lua"))()

-- 2. Create Window (Title, Minimized Button Text)
local Window = kailex:createFrame("Kailex Hub", "Kailex")

-- 3. Create a Tab (Name, Optional Icon ID)
local Tab = Window:addTab("Main Features", "6031090994")

-- 4. Add Components
Tab:addToggle("Auto Farm", "Enable automatic farming", function(state)
    print("Auto Farm is now: ", state)
end, false)

Tab:addButton("Print Hello", "Prints hello to console", function()
    print("Hello World!")
end)

-- 5. Initialize & Show Window
Window:Init()
```

---

## 📖 Detailed Documentation (For Advanced Users)

Every component function generally follows this pattern for its first two arguments:
1. `Name` (String): The text displayed on the element.
2. `Info` (String/nil): Tooltip text. If provided, an info icon appears next to the element. (Requires `kailex.Setting.Info = true` globally, which is enabled by default if passed).

### 🪟 Window & Tabs

**Create the Main Window:**
```lua
local Window = kailex:createFrame("Window Title", "Minimized Text")
```

**Create a Tab:**
```lua
local Tab1 = Window:addTab("Tab Name", "IconID") -- IconID is optional
```

### 🧩 Standard Components

**Button:**
```lua
Tab1:addButton("Button Name", "Tooltip Info", function()
    print("Clicked!")
end)
```

**Toggle:**
```lua
-- Name, Info, Callback, DefaultState, Style (true/false)
Tab1:addToggle("Toggle Name", "Tooltip Info", function(state)
    print(state)
end, false, true)
```

**Slider:**
```lua
-- Name, Info, DefaultValue, Min, Max, Callback
Tab1:addSlider("WalkSpeed", "Change speed", 16, 16, 100, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

**Dropdown:**
```lua
-- Name, Info, {List}, ItemsPerRow, Callback, DefaultSelection
Tab1:addDropdown("Select Player", "Choose a target", {"Player1", "Player2"}, 1, function(selected)
    print(selected)
end, "Player1")
```

**Multi-Dropdown:**
```lua
-- Same as Dropdown, but allows multiple selections. Returns a table of selected items.
Tab1:addMultiDropdown("Select ESP", "Choose ESP options", {"Boxes", "Names", "Health"}, 1, function(selectedTable)
    print(selectedTable[1]) 
end, {"Boxes"}) 
```

**TextBox:**
```lua
-- Name, Info, Placeholder, Callback, DefaultValue, LiveTyping(boolean)
Tab1:addTextBox("Input Text", "Type here", "Type...", function(text)
    print(text)
end, "", false)
```

**Color Picker:**
```lua
-- Name, Info, DefaultColor, Callback
Tab1:addColorPicker("ESP Color", "Change box color", Color3.fromRGB(255, 0, 0), function(color)
    print(color)
end)
```

**Keybind:**
```lua
-- Name, Info, DefaultKey, Callback
Tab1:addKeybind("Toggle GUI", "Press to hide", Enum.KeyCode.RightControl, function(key)
    print("Key pressed:", key)
end)
```

### 📂 Layout & Organization

**Section / Separators:**
```lua
Tab1:addSection("Player Settings")
Tab1:addSeparator()
```

**Dropdown Section (Collapsible Menu):**
```lua
-- Name, Info, DefaultExpanded
local Section = Tab1:addDropdownSection("Advanced Options", "Extra stuff", false)
Section:addButton("Secret Button", nil, function() end)
```

**Labels:**
```lua
Tab1:addLabel("This is a simple text label.")
```

---

## 🚀 Advanced Combo Components
Kailex UI offers unique combined elements to save space!

* `addSB`: Slider + Button
* `addST`: Slider + Toggle
* `addDT`: Dropdown + Toggle
* `addMDT`: Multi-Dropdown + Toggle

*Example (Slider + Toggle):*
```lua
-- Name, Info, DefaultVal, Min, Max, Callback(value, state), DefaultToggle
Tab1:addST("Aimbot FOV", "Adjust FOV and enable", 50, 10, 100, function(value, state)
    print("FOV:", value, "Enabled:", state)
end, false)
```

---

## 🔔 Popups & Visuals

**Notifications:**
```lua
kailex:Notification("This is a sleek notification!")
```

**Confirmation Dialog:**
```lua
kailex:ConfirmationFrame("Are you sure you want to delete this?", function()
    print("User clicked Yes!")
end)
```

---

## 🎨 Changing Themes & Settings
You can modify the library's look before creating your frame, or update it dynamically!

```lua
kailex:UpdateTheme({
    BackgroundColor = Color3.fromRGB(15, 15, 20),
    AccentColor = Color3.fromRGB(25, 25, 35),
    ToggleOnColor = Color3.fromRGB(0, 255, 150),
    TextColor = Color3.fromRGB(255, 255, 255)
})
```
*Note: Check the top of the source script `kailex.Setting.Theme` for all editable color properties.*

---
### 📝 License & Credits
Developed with ❤️ by **AKDO**. 
Feel free to use this library in your scripts. Please credit the original creator when publishing your hubs!
