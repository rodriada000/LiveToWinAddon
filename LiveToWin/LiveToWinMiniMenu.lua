local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_LOGIN")

MiniPanelFrame = CreateFrame("Frame", "LiveToWinMiniPanel", UIParent, "BackdropTemplate");
MiniPanelFrame:SetSize(125, 45)
MiniPanelFrame:SetPoint("TOP", "Minimap", "BOTTOM", 0, -25)
MiniPanelFrame:SetMovable(true)
MiniPanelFrame:EnableMouse(true)

local minValue = 0
local maxValue = 100

local defaultAlpha = 0.4
local onHoverAlpha = 0.8
local unfocusAlpha = 0.1

local function GetSliderText()
    if LiveToWin_Config.StopAfterSeconds == 0 then
        return "Off"
    else
        return LiveToWin_Config.StopAfterSeconds .. " seconds"
    end
end

local function GetVolumePercent()
    local volume = tonumber(GetCVar("Sound_MusicVolume"));
    volume = math.floor(volume * 100);
    return volume;
end

local MySlider = CreateFrame("Slider", "MiniSlider", MiniPanelFrame, "OptionsSliderTemplate")
MySlider:ClearAllPoints()
MySlider:SetPoint("LEFT", 5, -10)
MySlider:SetOrientation('HORIZONTAL')
MySlider:SetWidth(80)
MySlider:SetHeight(15)
MySlider:SetMinMaxValues(minValue, maxValue)
MySlider:SetValueStep(1)
MySlider:SetAlpha(defaultAlpha)

getglobal(MySlider:GetName() .. 'Low'):SetText('');
getglobal(MySlider:GetName() .. 'High'):SetText('');

MySlider:SetScript("OnValueChanged", function(self, value)
    LiveToWin_Config.StopAfterSeconds = floor(value)
    ConfigSliderStopSeconds:SetValue(floor(value))
    getglobal(MySlider:GetName() .. 'Text'):SetText(GetSliderText());
end)

local soundSlider = CreateFrame("Slider", "MiniVolumeSlider", MiniPanelFrame, "OptionsSliderTemplate")
soundSlider:ClearAllPoints()
soundSlider:SetPoint("LEFT", 5, 10)
soundSlider:SetOrientation('HORIZONTAL')
soundSlider:SetWidth(80)
soundSlider:SetHeight(15)
soundSlider:SetMinMaxValues(0, 1)
soundSlider:SetValueStep(0.05)
soundSlider:SetAlpha(defaultAlpha)

getglobal(soundSlider:GetName() .. 'Low'):SetText(''); -- Sets the left-side slider text (default is "Low").
getglobal(soundSlider:GetName() .. 'High'):SetText(''); -- Sets the right-side slider text (default is "High").

soundSlider:SetScript("OnValueChanged", function(self, value)
    SetCVar("Sound_MusicVolume", value)
    getglobal(soundSlider:GetName() .. 'Text'):SetText(GetVolumePercent() .. "%");
end)

-- Create the button:
local button = CreateFrame("Button", "StopMusicButton", MiniPanelFrame, "SecureActionButtonTemplate")
button:SetSize(28, 28)
button:SetPoint("RIGHT", -15, -11)
button:SetScript("OnClick", function(...)
    LiveToWin_Config.StopMusic = true
end)

-- Add the icon for the button
local icon = button:CreateTexture(nil, "ARTWORK")
icon:SetAllPoints(true)
icon:SetTexture("Interface\\Buttons\\CancelButton-Up")
button.icon = icon
button:SetAlpha(defaultAlpha)

Frame:SetScript("OnEvent", function(...)
    MySlider:SetValue(LiveToWin_Config.StopAfterSeconds)
    soundSlider:SetValue(tonumber(GetCVar("Sound_MusicVolume")))
    getglobal(MySlider:GetName() .. 'Text'):SetText("");
    getglobal(soundSlider:GetName() .. 'Text'):SetText("");

    MiniPanelFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    });
    MiniPanelFrame:SetBackdropColor(0, 0, 0, 0.5);
    MiniPanelFrame:SetBackdropBorderColor(1, 1, 1, 1);

    MiniPanelFrame:SetScript("OnEnter", function(...)
        MiniPanelFrame:SetBackdropColor(0, 0, 0, 0.75);
        MiniPanelFrame:SetBackdropBorderColor(1, 1, 1, 0.25);
    end)
    MiniPanelFrame:SetScript("OnLeave", function(...)
        MiniPanelFrame:SetBackdropColor(0, 0, 0, 0);
        MiniPanelFrame:SetBackdropBorderColor(1, 1, 1, 0);
    end)


    MiniPanelFrame:RegisterForDrag("LeftButton")
    MiniPanelFrame:SetScript("OnDragStart", MiniPanelFrame.StartMoving)
    MiniPanelFrame:SetScript("OnDragStop", MiniPanelFrame.StopMovingOrSizing)

    button:SetScript("OnEnter", function(...)
        getglobal(MySlider:GetName() .. 'Text'):SetText("Stop Music");
        soundSlider:SetAlpha(unfocusAlpha)
        button:SetAlpha(onHoverAlpha)
    end)
    button:SetScript("OnLeave", function(...)
        button:SetAlpha(defaultAlpha)
        soundSlider:SetAlpha(defaultAlpha)
        getglobal(MySlider:GetName() .. 'Text'):SetText("");
    end)

    MySlider:SetScript("OnEnter", function(...)
        MySlider:SetAlpha(onHoverAlpha)
        soundSlider:SetAlpha(unfocusAlpha)
        getglobal(MySlider:GetName() .. 'Text'):SetText(GetSliderText());
    end)
    MySlider:SetScript("OnLeave", function(...)
        MySlider:SetAlpha(defaultAlpha)
        soundSlider:SetAlpha(defaultAlpha)
        getglobal(MySlider:GetName() .. 'Text'):SetText("");
    end)

    soundSlider:SetScript("OnEnter", function(...)
        soundSlider:SetAlpha(onHoverAlpha)
        MySlider:SetAlpha(unfocusAlpha)
        getglobal(soundSlider:GetName() .. 'Text'):SetText(GetVolumePercent() .. "%");
    end)
    soundSlider:SetScript("OnLeave", function(...)
        soundSlider:SetAlpha(defaultAlpha)
        MySlider:SetAlpha(defaultAlpha)
        getglobal(soundSlider:GetName() .. 'Text'):SetText("");
    end)

end)
