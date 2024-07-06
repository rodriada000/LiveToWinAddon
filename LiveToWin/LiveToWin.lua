local TimeSinceLastUpdate = 0
local isPlaying = false
local inCombat = false
local combatStopTime = 0

StopAfterInSeconds = 0

local function StopPlaying(self)
    if isPlaying == true then
        StopMusic()
        isPlaying = false
    end
end

local function UpdateLiveToWin(self, elapsed)

    TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
    combatStopTime = combatStopTime + elapsed

    -- ensure music is not playing and dont do anything when setting is 0 ("off")
    if LiveToWin_Config.StopAfterSeconds == 0 or LiveToWin_Config.StopMusic then
        StopPlaying()
        LiveToWin_Config.StopMusic = false
        return
    end

    if TimeSinceLastUpdate > 0.25 then
        TimeSinceLastUpdate = 0
        inCombat = InCombatLockdown()
        if inCombat then
            combatStopTime = 0;
        end

        -- stop music if out of combat for few seconds
        if inCombat == false and combatStopTime > LiveToWin_Config.StopAfterSeconds then
            StopPlaying()
        end

        -- start music if not playing and in combat
        if isPlaying == false and inCombat == true then
            isPlaying = true;
            combatStopTime = 0;
            if LiveToWin_Config.PlayAlternative == true then
                PlayMusic("Interface\\AddOns\\LiveToWin\\audio\\LivetoWin_Full.mp3");
            else
                PlayMusic("Interface\\AddOns\\LiveToWin\\audio\\LivetoWin.mp3");
            end
        end
    end
end

function LiveToWin_OnLoad(self, event, ...)
    self:RegisterEvent("ADDON_LOADED")
end

function LiveToWin_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "LiveToWin" then
        self:UnregisterEvent("ADDON_LOADED")
        LiveToWin:SetSize(100, 50)
        LiveToWin:SetPoint("TOP", "Minimap", "BOTTOM", 5, -5)
        LiveToWin:SetScript("OnUpdate", UpdateLiveToWin)
    end
end
