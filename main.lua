---@type string directory of the mod.
local modDirectory = g_currentModDirectory or ""
---@type string name of the mod.
local modName = g_currentModName or "unknown"

---Init the mod.
local function init()
    g_specializationManager:addSpecialization("selfPropelledMulcherExt", "SelfPropelledMulcherExt", modDirectory .. "SelfPropelledMulcherExt.lua", nil)
end

init()