local ShaguKill = {}

function ShaguKill:CHAT_MSG_COMBAT_HOSTILE_DEATH()
  self.oldXP =  UnitXP("player")
  self.slainTime = GetTime()
end

function ShaguKill:PLAYER_XP_UPDATE()
  if not self.slainTime then return end
  if GetTime() - self.slainTime < 1 then
    local curXP = UnitXP("player")
    local difXP = curXP - self.oldXP
    if difXP > 0 then
      local maxXP = UnitXPMax("player")
      local remainingKills = ceil((maxXP - curXP)/difXP)
      UIErrorsFrame:AddMessage("next level: |cffffffaa~" .. remainingKills .. "|r kills.")
    end
  end
  self.slainTime = nil
end

function ShaguKill:UNIT_PET_EXPERIENCE()
  local petCurXP, petMaxXP = GetPetExperience()
  if self.petOldXP ~= nil then
    local petDifXP = petCurXP - self.petOldXP
    if petDifXP > 0 then
      local petRemainingKills = ceil((petMaxXP - petCurXP)/petDifXP)
      UIErrorsFrame:AddMessage("pet: |cffffffaa~" .. petRemainingKills .. "|r kills.")
    end
  end
  self.petOldXP = petCurXP
end

local function handleEvents(eventHandler)
  local EventManager = CreateFrame("Frame")
  for event in pairs(eventHandler) do
    EventManager:RegisterEvent(event)
  end
  EventManager:SetScript("OnEvent", function() eventHandler[event](eventHandler) end)
end

handleEvents(ShaguKill)
