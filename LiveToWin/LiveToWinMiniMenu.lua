local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_LOGIN")

MiniPanelFrame = CreateFrame("Frame", "LiveToWinMiniPanel", UIParent);
MiniPanelFrame:SetSize(125, 35)
MiniPanelFrame:SetPoint("TOP", "Minimap", "BOTTOM", 0, -15)
MiniPanelFrame:SetMovable(true)
MiniPanelFrame:EnableMouse(true)

local minValue = 0
local maxValue = 100
local sliderText = "Off"

local function SetSliderText()
    if LiveToWin_Config.StopAfterSeconds == 0 then
        sliderText = "Off"
    else
        sliderText = LiveToWin_Config.StopAfterSeconds .. " seconds"
    end
end

local MySlider = CreateFrame("Slider", "MiniSlider", MiniPanelFrame, "OptionsSliderTemplate")
MySlider:ClearAllPoints()
MySlider:SetPoint("CENTER", 0, -15)
MySlider:SetOrientation('HORIZONTAL')
MySlider:SetWidth(80)
MySlider:SetHeight(15)
MySlider:SetMinMaxValues(minValue, maxValue)
MySlider:SetValueStep(1)
MySlider:SetAlpha(0.4)

getglobal(MySlider:GetName() .. 'Low'):SetText(''); -- Sets the left-side slider text (default is "Low").
getglobal(MySlider:GetName() .. 'High'):SetText(''); -- Sets the right-side slider text (default is "High").

MySlider:SetScript("OnValueChanged", function(self, value)
    LiveToWin_Config.StopAfterSeconds = floor(value)
    ConfigSliderStopSeconds:SetValue(floor(value))
    SetSliderText()
    getglobal(MySlider:GetName() .. 'Text'):SetText(sliderText);
end)

-- Create the button:
local button = CreateFrame("Button", "StopMusicButton", MiniPanelFrame, "SecureActionButtonTemplate")
button:SetSize(28, 28)
button:SetPoint("RIGHT", 0, -15)
button:SetScript("OnClick", function(...)
    LiveToWin_Config.StopMusic = true
end)

-- Add the icon for the button
local icon = button:CreateTexture(nil, "ARTWORK")
icon:SetAllPoints(true)
icon:SetTexture("Interface\\Buttons\\CancelButton-Up")
button.icon = icon
button:SetAlpha(0.4)

Frame:SetScript("OnEvent", function(...)
    MySlider:SetValue(LiveToWin_Config.StopAfterSeconds)
    getglobal(MySlider:GetName() .. 'Text'):SetText("");

    MiniPanelFrame:RegisterForDrag("LeftButton")
    MiniPanelFrame:SetScript("OnDragStart", MiniPanelFrame.StartMoving)
    MiniPanelFrame:SetScript("OnDragStop", MiniPanelFrame.StopMovingOrSizing)

    button:SetScript("OnEnter", function(...)
        getglobal(MySlider:GetName() .. 'Text'):SetText("Stop Music");
        button:SetAlpha(0.8)
    end)
    button:SetScript("OnLeave", function(...)
        button:SetAlpha(0.4)
        getglobal(MySlider:GetName() .. 'Text'):SetText("");
    end)

    MySlider:SetScript("OnEnter", function(...)
        MySlider:SetAlpha(0.8)
        SetSliderText()
        getglobal(MySlider:GetName() .. 'Text'):SetText(sliderText);
    end)
    MySlider:SetScript("OnLeave", function(...)
        MySlider:SetAlpha(0.4)
        getglobal(MySlider:GetName() .. 'Text'):SetText("");
    end)

end)
