# 🎨 Kailex UI Library

**An advanced, highly customizable, and feature-rich User Interface Library for Roblox (Lua).** 
Created by **AKDO**, Kailex UI is designed to provide scripters with a modern aesthetic, buttery-smooth animations, and a deeply integrated API for complete programmatic control over every element.

---

## 🌟 Core Features & Highlights

*   **Extensive Component API:** Every single UI element returns an API table, allowing you to update names, values, items, visibility, and callbacks *dynamically* after creation.
*   **Combined Components:** Unique hybrid elements like Slider+Button, Slider+Toggle, and Dropdown+Toggle to save space and enhance UX.
*   **Window Resizing:** Users can freely resize the menu by dragging the bottom-right corner.
*   **Built-in Search System:** A robust search bar built into the header. It caches element text dynamically and filters elements instantly.
*   **Inline Extra Buttons:** Add infinite mini-buttons or icons inside standard Buttons or Dropdown Sections.
*   **Nested Sub-menus (FrameButtons):** Transform a tab into a multi-level menu. Clicking a `FrameButton` hides the current tab and slides in a new sub-page with a built-in `<- Back` button.
*   **Sidebar Toggling:** The sidebar can be collapsed into a minimal icon-only view to save screen real estate.
*   **Interactive Visuals:** Features a highly optimized Mouse Ripple Effect, dynamic Stroke highlights, and Drop Shadows.
*   **Tooltip System (Info):** Optional integrated tooltip system. Hovering over a designated (i) icon displays a dynamic tooltip that follows your cursor.

---

## 🚀 Getting Started & Initialization

First, load the library and configure the global settings. 

```lua
local kailex = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

-- [Global Settings]
kailex.Setting.Sounds = true -- Enable/Disable click & hover sounds
kailex.Setting.Info = false  -- VERY IMPORTANT: If set to true, the argument structure changes (See 'Tooltip System' section below)

-- 1. Create the Main Window
-- Window = kailex:createFrame(Title, MinimizedText)
local Window = kailex:createFrame("Kailex Hub", "Kailex")

-- 2. Create a Tab
-- Tab = Window:addTab(TabName, IconAssetID)
local MainTab = Window:addTab("General", "rbxassetid://6026568210")

-- 3. ALWAYS call Init() at the very end to play the intro animation and show the UI
Window:Init()
```

---

## ⚙️ Global UI Management APIs

### 1. Theming & Settings
You can update the library's theme and layout dynamically at runtime.
```lua
kailex:UpdateTheme({
    BackgroundColor = Color3.fromRGB(15, 15, 20),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(25, 25, 35),
    Toggle = {
        ToggleOnColor = Color3.fromRGB(110, 150, 255)
    }
})

-- Update layouts, sizes, or animations globally
kailex:UpdateSettings({
    Layout = { ButtonSizeY = 24 },
    Animation = { Fast = TweenInfo.new(0.1) }
})
```

### 2. Notifications & Confirmations
```lua
-- Spawns a sleek notification at the bottom right
Window:Notification("Successfully injected the script!")

-- Prompts a Yes/No modal box
Window:ConfirmationFrame("Are you sure you want to execute this?", function()
    print("User clicked Yes!")
end)
```

---

## 🗂️ Layout & Routing Systems

Kailex offers powerful ways to organize your UI beyond simple top-to-bottom lists.

### 1. Grid Rows
Places elements horizontally next to each other.
```lua
-- addRow(ElementsPerRow, NumberOfLines)
local Row = MainTab:addRow(2, 1)

Row:addToggle("Aimbot", function() end)
Row:addToggle("ESP", function() end)
```

### 2. Dropdown Sections
Collapsible containers that can hold other elements.
```lua
-- addDropdownSection(Name, DefaultState, [ExtraButtonIcon, ExtraButtonCallback]...)
local SectionApi = MainTab:addDropdownSection("Advanced Settings", false, "rbxassetid://6031090994", function()
    print("Extra icon clicked!")
end)

SectionApi:addSlider("FOV", 90, 70, 120, function() end)

-- Returned API methods:
SectionApi:Toggle(boolean)      -- Force open/close
SectionApi:getState()           -- Returns true if open
SectionApi:update(newName, newInfo)
SectionApi:addRow(ElementsPerRow, Lines)
SectionApi:addFrameButton(Name, Info)
SectionApi:Visible(boolean)
SectionApi:destroy()
```

### 3. Frame Buttons (Sub-Menus)
Creates a button that opens a completely separate sub-page.
```lua
local SubMenu = MainTab:addFrameButton("Open Config Manager")
SubMenu:addButton("Save Config", function() end)
-- SubMenu inherits the ability to add Toggles, Sliders, Dropdowns, etc.

-- Returned API methods:
SubMenu:updateFrameButton(newName, newInfo)
SubMenu:openFrame() -- Programmatically open this sub-menu
SubMenu:destroy()
```

---

## 🧩 Components & Returned APIs

Every UI element returns an `API` table. This allows you to manipulate the element programmatically via your script without user interaction.
*(Note: Documentation assumes `kailex.Setting.Info = false`)*

### 1. Button
```lua
-- addButton(Name, Callback, [RightIcon], [ExtraContent1, ExtraCallback1]...)
local BtnApi = MainTab:addButton("Click Me", function()
    print("Clicked!")
end, "rbxassetid://6031090994", "MiniBtn", function() print("Mini clicked") end)
```
**API Methods:**
*   `BtnApi:updatename(newName)`
*   `BtnApi:updatecallback(newCallback)`
*   `BtnApi:Visible(boolean)` - *Toggles element visibility*
*   `BtnApi:destroy()` - *Deletes the element safely*

### 2. Toggle
```lua
-- addToggle(Name, Callback, DefaultValue, Style)
-- Style: false = Rounded/Pill shape, true = Square shape
local ToggleApi = MainTab:addToggle("God Mode", function(state)
    print("State:", state)
end, false, false)
```
**API Methods:**
*   `ToggleApi:setValue(state, silent)` - *`silent` (bool) prevents the callback from firing.*
*   `ToggleApi:getTValue()` - *Returns current boolean state.*
*   `ToggleApi:NewName(newName)`
*   `ToggleApi:newcallback(newCallback)`
*   `ToggleApi:newStyle(boolean)` - *Changes pill/square style.*
*   `ToggleApi:Visible(boolean)`
*   `ToggleApi:destroy()`

### 3. Slider
```lua
-- addSlider(Name, DefaultValue, Min, Max, Callback)
local SliderApi = MainTab:addSlider("WalkSpeed", 16, 16, 200, function(value)
    print("Speed:", value)
end)
```
**API Methods:**
*   `SliderApi:setValue(value, silent)`
*   `SliderApi:getSValue()` - *Returns current number.*
*   `SliderApi:update(newName, newInfo, newMin, newMax, newCallback)`
*   `SliderApi:Visible(boolean)`
*   `SliderApi:destroy()`

### 4. Dropdown (Single Selection)
```lua
-- addDropdown(Name, ItemsTable, ItemsPerRow, Callback, DefaultValue)
local DropApi = MainTab:addDropdown("Target Part", {"Head", "Torso", "Legs"}, 1, function(selected)
    print("Targeting:", selected)
end, "Head")
```
**API Methods:**
*   `DropApi:setSelected(item, silent)`
*   `DropApi:getSelected()` - *Returns string.*
*   `DropApi:setItems(newTable)` - *Replaces the entire list.*
*   `DropApi:addItems(item)` / `DropApi:removeItems(item)`
*   `DropApi:ToggleDropdown(boolean)` - *Force opens/closes the list.*
*   `DropApi:update(newName, newInfo, newTable, newItemsPerRow, newCallback)`
*   `DropApi:Visible(boolean)`
*   `DropApi:destroy()`

### 5. Multi-Dropdown (Multiple Selection)
```lua
-- addMultiDropdown(Name, ItemsTable, ItemsPerRow, Callback, DefaultValuesArray)
local MultiDropApi = MainTab:addMultiDropdown("Hitboxes", {"Head", "Arm", "Leg"}, 2, function(array)
    for _, v in ipairs(array) do print(v) end
end, {"Head", "Arm"})
```
**API Methods:**
*   `MultiDropApi:setSelected(array, silent)`
*   `MultiDropApi:getSelected()` - *Returns an array of strings.*
*   `MultiDropApi:setItems(newTable)`
*   `MultiDropApi:ToggleDropdown(boolean)`
*   `MultiDropApi:Visible(boolean)`
*   `MultiDropApi:destroy()`

### 6. TextBox
```lua
-- addTextBox(Name, Placeholder, Callback, DefaultValue, LiveUpdate)
-- LiveUpdate (bool): If true, fires on every keystroke. If false, fires on FocusLost (Enter).
local TextApi = MainTab:addTextBox("Player Name", "Enter here...", function(text)
    print("Text:", text)
end, "", false)
```
**API Methods:**
*   `TextApi:setText(text, silent)`
*   `TextApi:getText()`
*   `TextApi:Visible(boolean)`
*   `TextApi:destroy()`

### 7. ColorPicker
```lua
-- addColorPicker(Name, DefaultColor3, Callback)
local ColorApi = MainTab:addColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("R:", color.R)
end)
```
**API Methods:**
*   `ColorApi:setColor(Color3)`
*   `ColorApi:getColor()` - *Returns Color3.*
*   `ColorApi:Visible(boolean)`
*   `ColorApi:destroy()`

### 8. Keybind
```lua
-- addKeybind(Name, DefaultEnum, Callback)
local KeyApi = MainTab:addKeybind("Toggle UI", Enum.KeyCode.RightShift, function(key)
    print("Pressed:", key.Name)
end)
```
**API Methods:**
*   `KeyApi:updateBind(Enum.KeyCode)`
*   `KeyApi:Visible(boolean)`
*   `KeyApi:destroy()`

### 9. Static Elements (Labels, Sections, Separators)
```lua
local LabelApi = MainTab:addLabel("Just a simple text")
local SectionApi = MainTab:addSection("--- Category ---")
local SepApi = MainTab:addSeparator()

-- APIs usually include: updateLabel(text), updateSection(text), Visible(boolean), destroy()
```

---

## 🔥 Combined Components (Hybrids)

Kailex allows packing multiple functionalities into a single UI element row to maximize efficiency.

### 1. Slider + Button (`addSB`)
```lua
-- addSB(Name, ButtonText, DefaultVal, Min, Max, Callback)
-- Callback passes (Value, isButtonClicked)
MainTab:addSB("Velocity", "Apply", 50, 0, 100, function(value, buttonClicked)
    if buttonClicked then
        print("Applied:", value)
    end
end)
```

### 2. Slider + Toggle (`addST`)
```lua
-- addST(Name, DefaultVal, Min, Max, Callback, DefaultToggle, Style)
-- Callback passes (Value, ToggleState)
MainTab:addST("Aura Range", 15, 0, 50, function(value, state)
    print("Range:", value, "Enabled:", state)
end, true, false)
```

### 3. Dropdown + Toggle (`addDT`)
```lua
-- addDT(Name, Items, PerRow, Callback, DefaultDrop, DefaultToggle, Style)
-- Callback passes (SelectedString, ToggleState)
MainTab:addDT("Auto Farm Area", {"Spawn", "Desert"}, 1, function(selected, state)
    print("Farming:", selected, "Status:", state)
end, "Spawn", false, false)
```

### 4. Multi-Dropdown + Toggle (`addMDT`)
```lua
-- addMDT(Name, Items, PerRow, DefaultVals, Callback, DefaultToggle, Style)
-- Callback passes (SelectedArray, ToggleState)
MainTab:addMDT("Whitelist", {"Players", "NPCs", "Items"}, 2, {"Players"}, function(array, state)
    print("Enabled:", state)
end, true, false)
```

*(Note: Combined components return a merged API table inheriting functions from both base components, e.g., `api:setValue()` and `api:setSelected()`).*

---

## 💡 The Tooltip System (`kailex.Setting.Info`)

If you want to add descriptive tooltips to your UI, you must enable `kailex.Setting.Info = true` **BEFORE** initializing the components.

**⚠️ IMPORTANT ARGUMENT SHIFT:**
When `Info = true`, **every** component function expects a string as its *second argument* representing the tooltip description.

**Example with `Info = false`:**
```lua
MainTab:addToggle("Aimbot", function(state) end, false)
```
**Example with `Info = true`:**
```lua
-- addToggle(Name, InfoText, Callback, DefaultValue, Style)
MainTab:addToggle("Aimbot", "Automatically locks onto enemy heads.", function(state) end, false)
```
This applies to Buttons, Sliders, Dropdowns, TextBoxes, ColorPickers, and Keybinds.

---
*Created and Maintained by AKDO. Engineered for unparalleled scripter control and elite user experience.*
