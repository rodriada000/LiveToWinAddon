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

    if LiveToWin_Config.DisplayVolSlider then
        MiniVolumeSlider:Show()
    else
        MiniVolumeSlider:Hide()
    end
end

local function InitDefaultConfigValues()
    if not LiveToWin_Config then -- first time the addon is used
        LiveToWin_Config = {} -- allocate a table to store your saved variables (the table will be saved to disk on logout)
    end

    if LiveToWin_Config.PlayAlternative == nil then
        LiveToWin_Config.PlayAlternative = false
    end

    if LiveToWin_Config.StopAfterSeconds == nil then
        LiveToWin_Config.StopAfterSeconds = 30
    end

    if LiveToWin_Config.StopMusic == nil then
        LiveToWin_Config.StopMusic = false
    end

    if LiveToWin_Config.DisplayMenu == nil then
        LiveToWin_Config.DisplayMenu = true
    end

    if LiveToWin_Config.DisplayVolSlider == nil then
        LiveToWin_Config.DisplayVolSlider = true
    end
end

local timeSlider = CreateFrame("Slider", "ConfigSliderStopSeconds", ConfigPanelFrame, "OptionsSliderTemplate")
timeSlider:ClearAllPoints()
timeSlider:SetPoint("TOPLEFT", 32, -32)
timeSlider:SetOrientation('HORIZONTAL')
timeSlider:SetWidth(350)
timeSlider:SetHeight(15)
timeSlider:SetMinMaxValues(minValue, maxValue)
timeSlider:SetValueStep(1)
timeSlider.tooltipText = 'Number of seconds before music stops when out of combat' -- Creates a tooltip on mouseover.

getglobal(timeSlider:GetName() .. 'Low'):SetText('Off'); -- Sets the left-side slider text (default is "Low").
getglobal(timeSlider:GetName() .. 'High'):SetText(maxValue); -- Sets the right-side slider text (default is "High").
getglobal(timeSlider:GetName() .. 'Text'):SetText('Stop Music After'); -- Sets the "title" text (top-centre of slider).

local menuCheckButton = CreateFrame("CheckButton", "ConfigCheckboxIsMiniMenuDisplayed", ConfigPanelFrame, "ChatConfigCheckButtonTemplate");
menuCheckButton:SetPoint("TOPLEFT", 24, -75);
menuCheckButton.tooltip = "Display the slider and pause button";
getglobal(menuCheckButton:GetName() .. 'Text'):SetText("Show Mini Menu");
menuCheckButton:SetScript("OnClick", function()
    LiveToWin_Config.DisplayMenu = not LiveToWin_Config.DisplayMenu
    ShowOrHideMiniMenu()
end);

local volumeCheckButton = CreateFrame("CheckButton", "ConfigCheckboxIsVolumeDisplayed", ConfigPanelFrame, "ChatConfigCheckButtonTemplate");
volumeCheckButton:SetPoint("TOPLEFT", 24, -100);
volumeCheckButton.tooltip = "Display the music volume slider";
getglobal(volumeCheckButton:GetName() .. 'Text'):SetText("Show Volume Slider");
volumeCheckButton:SetScript("OnClick", function()
    LiveToWin_Config.DisplayVolSlider = not LiveToWin_Config.DisplayVolSlider
    ShowOrHideMiniMenu()
end);

local altCheckButton = CreateFrame("CheckButton", "ConfigCheckboxIsAltVersion", ConfigPanelFrame, "ChatConfigCheckButtonTemplate");
altCheckButton:SetPoint("TOPLEFT", 24, -125);
altCheckButton.tooltip = "Play the music without South Park audio overlay";
getglobal(altCheckButton:GetName() .. 'Text'):SetText("Play Alternative Version");
altCheckButton:SetScript("OnClick", function()
    LiveToWin_Config.PlayAlternative = not LiveToWin_Config.PlayAlternative
    ShowOrHideMiniMenu()
end);

timeSlider:SetScript("OnValueChanged", function(self, value)
    LiveToWin_Config.StopAfterSeconds = floor(value)
    MiniSlider:SetValue(floor(value))

    if LiveToWin_Config.StopAfterSeconds > 0 then
        getglobal(timeSlider:GetName() .. 'Text'):SetText('Stop Music After ' .. LiveToWin_Config.StopAfterSeconds .. ' Seconds'); -- Sets the "title" text (top-centre of slider).
    else
        getglobal(timeSlider:GetName() .. 'Text'):SetText('Combat Music Disabled')
    end
end)

Frame:SetScript("OnEvent", function(...)
    InitDefaultConfigValues()

    timeSlider:SetValue(LiveToWin_Config.StopAfterSeconds)
    menuCheckButton:SetChecked(LiveToWin_Config.DisplayMenu)
    volumeCheckButton:SetChecked(LiveToWin_Config.DisplayVolSlider)
    altCheckButton:SetChecked(LiveToWin_Config.PlayAlternative)


    LiveToWinMiniPanel:SetUserPlaced(true)

    ShowOrHideMiniMenu()
end)
