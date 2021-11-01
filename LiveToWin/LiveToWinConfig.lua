local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_LOGIN")

ConfigPanel = {};
ConfigPanel.panel = CreateFrame("Frame", "LiveToWinConfigPanel", UIParent);
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
ConfigPanel.panel.name = "Live To Win";
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(ConfigPanel.panel);

local minValue = 0
local maxValue = 90

local MySlider = CreateFrame("Slider", "MySliderGlobalName", ConfigPanel.panel, "OptionsSliderTemplate")
MySlider:ClearAllPoints()
MySlider:SetPoint("TOPLEFT", 32, -32)
MySlider:SetOrientation('HORIZONTAL')
MySlider:SetWidth(350)
MySlider:SetHeight(15)
MySlider:SetMinMaxValues(minValue, maxValue)
MySlider:SetValueStep(1)
MySlider.tooltipText = 'Number of seconds before music stops when out of combat' -- Creates a tooltip on mouseover.

getglobal(MySlider:GetName() .. 'Low'):SetText('Off'); -- Sets the left-side slider text (default is "Low").
getglobal(MySlider:GetName() .. 'High'):SetText(maxValue); -- Sets the right-side slider text (default is "High").
getglobal(MySlider:GetName() .. 'Text'):SetText('Stop Music After'); -- Sets the "title" text (top-centre of slider).

MySlider:SetScript("OnValueChanged", function(self, value)
    LiveToWin_Config.StopAfterSeconds = floor(value)

    if LiveToWin_Config.StopAfterSeconds > 0 then
        getglobal(MySlider:GetName() .. 'Text'):SetText('Stop Music After ' .. LiveToWin_Config.StopAfterSeconds .. ' Seconds'); -- Sets the "title" text (top-centre of slider).
    else
        getglobal(MySlider:GetName() .. 'Text'):SetText('Combat Music Disabled')
    end

end)

Frame:SetScript("OnEvent", function(...)
    if not LiveToWin_Config then -- first time the addon is used
        LiveToWin_Config = {} -- allocate a table to store your saved variables (the table will be saved to disk on logout)
        LiveToWin_Config.StopAfterSeconds = 30
    end

    MySlider:SetValue(LiveToWin_Config.StopAfterSeconds)
end)
