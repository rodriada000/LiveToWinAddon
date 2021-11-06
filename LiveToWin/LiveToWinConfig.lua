local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_LOGIN")

ConfigPanel = {};
ConfigPanelFrame = CreateFrame("Frame", "LiveToWinConfigPanel", UIParent);
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
ConfigPanelFrame.name = "Live To Win";
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(ConfigPanelFrame);

local minValue = 0
local maxValue = 100

local function ShowOrHideMiniMenu()
    if LiveToWin_Config.DisplayMenu then
        LiveToWinMiniPanel:Show()
    else
        LiveToWinMiniPanel:Hide()
    end
end

local MySlider = CreateFrame("Slider", "ConfigSliderStopSeconds", ConfigPanelFrame, "OptionsSliderTemplate")
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

local myCheckButton = CreateFrame("CheckButton", "ConfigCheckboxIsMiniMenuDisplayed", ConfigPanelFrame, "ChatConfigCheckButtonTemplate");
myCheckButton:SetPoint("TOPLEFT", 24, -75);
myCheckButton.tooltip = "Display the slider and pause button";
getglobal(myCheckButton:GetName() .. 'Text'):SetText("Enable Mini Menu");
myCheckButton:SetScript("OnClick", function()
    LiveToWin_Config.DisplayMenu = not LiveToWin_Config.DisplayMenu
    ShowOrHideMiniMenu()
end);

MySlider:SetScript("OnValueChanged", function(self, value)
    LiveToWin_Config.StopAfterSeconds = floor(value)
    MiniSlider:SetValue(floor(value))

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
        LiveToWin_Config.StopMusic = false
        LiveToWin_Config.DisplayMenu = true
    end

    MySlider:SetValue(LiveToWin_Config.StopAfterSeconds)
    myCheckButton:SetChecked(LiveToWin_Config.DisplayMenu)
    LiveToWinMiniPanel:SetUserPlaced(true)

    ShowOrHideMiniMenu()
end)
