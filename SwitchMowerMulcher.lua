SwitchMowerMulcher = {}
SwitchMowerMulcher.MOWER = "MOWER"
SwitchMowerMulcher.MULCHER = "MULCHER"

function SwitchMowerMulcher.initSpecialization()
    g_configurationManager:addConfigurationType("SwitchMowerMulcher", g_i18n:getText("design_BigMwMulcher_Block_Title"), "SwitchMowerMulcher", nil, nil, nil, ConfigurationUtil.SELECTOR_MULTIOPTION)

    local schemaSavegame = Vehicle.xmlSchemaSavegame
    local schemaKey = "SwitchMowerMulcher"

    schemaSavegame:register(XMLValueType.STRING, "vehicles.vehicle(?)."..schemaKey.."#mode", "Mower or Mulcher Mode", SwitchMowerMulcher.MOWER)
end
function SwitchMowerMulcher:onLoad(savegame)

    self.spec_SwitchMowerMulcher = self["spec_SwitchMowerMulcher"]

    local spec = self.spec_SwitchMowerMulcher

    spec.useMowerMulcher = SwitchMowerMulcher.MOWER
end

function SwitchMowerMulcher:onPostLoad(savegame)
    local spec = self.spec_SwitchMowerMulcher
    if self.configurations["SwitchMowerMulcher"] ~= nil then
        if self.configurations["SwitchMowerMulcher"] == 1 then
            spec.useMowerMulcher = SwitchMowerMulcher.MOWER
        end
        if self.configurations["SwitchMowerMulcher"] == 2 then
            spec.useMowerMulcher = SwitchMowerMulcher.MULCHER
        end
    end
    if savegame ~= nil then
        local xmlFile = savegame.xmlFile
        local key = savegame.key ..".SwitchMowerMulcher"
        spec.useMowerMulcher = xmlFile:getValue(key.."#mode", spec.useMowerMulcher)
    end
end

function SwitchMowerMulcher:saveToXMLFile(xmlFile, key, usedModNames)
    local spec = self.spec_SwitchMowerMulcher
    xmlFile:setValue(key.."#mode", spec.useMowerMulcher)
end

function SwitchMowerMulcher:onReadStream(streamId, connection)
    local spec = self.spec_SwitchMowerMulcher
    spec.useMowerMulcher = streamReadString(streamId, connection)
end

function SwitchMowerMulcher:onReadStream(streamId, connection)
    local spec = self.spec_SwitchMowerMulcher
    streamWriteString(streamId, spec.useMowerMulcher)
end

function SwitchMowerMulcher:onReadUpdateStream(streamId, timestamp, connection)
	if not connection:getIsServer() then
		local spec = self.spec_SwitchMowerMulcher
        if streamReadBool(streamId) then
            spec.useMowerMulcher = streamReadString(streamId)
        end
    end
end

function SwitchMowerMulcher:onWriteUpdateStream(streamId, connection, dirtyMask)
    if connection:getIsServer() then
        local spec = self.spec_SwitchMowerMulcher
        if streamWriteBool(streamId, bitAND(dirtyMask, spec.dirtyFlag) ~= 0) then
            streamWriteString(streamId, spec.useMowerMulcher)
        end
    end
end

function SwitchMowerMulcher:processMowerMulcherArea(workArea, dt)
    local spec = self.spec_SwitchMowerMulcher
    local mode = spec.useMowerMulcher
    if mode == SwitchMowerMulcher.MOWER then
        return Mower:processMowerArea(workArea, dt)
    end
    if mode == SwitchMowerMulcher.MULCHER then
        return Mulcher:processMulcherArea(workArea, dt)
    end
    print("Error neither mode applied using Mower")
    return Mower:processMowerArea(workArea, dt)
end

function SwitchMowerMulcher.prerequisitesPresent(specializations)
	return SpecializationUtil.hasSpecialization(Mulcher, specializations) and SpecializationUtil.hasSpecialization(Mower, specializations)
end

-- function SwitchMowerMulcher.registerOverwrittenFunctions(vehicleType)
--     SpecializationUtil.registerOverwrittenFunction(vehicleType,"", SwitchMowerMulcher.)
-- end

function SwitchMowerMulcher.registerFunctions(vehicleType)
    SpecializationUtil.registerFunction(vehicleType, "processMowerMulcherArea", SwitchMowerMulcher.processMowerMulcherArea)
end

function SwitchMowerMulcher.registerEventListeners(vehicleType)
	SpecializationUtil.registerEventListener(vehicleType, "onUpdate", SwitchMowerMulcher)
	SpecializationUtil.registerEventListener(vehicleType, "onLoad", SwitchMowerMulcher)
	SpecializationUtil.registerEventListener(vehicleType, "onPostLoad", SwitchMowerMulcher)
	SpecializationUtil.registerEventListener(vehicleType, "saveToXMLFile", SwitchMowerMulcher)
 	SpecializationUtil.registerEventListener(vehicleType, "onReadStream", SwitchMowerMulcher)
	SpecializationUtil.registerEventListener(vehicleType, "onWriteStream", SwitchMowerMulcher)
	SpecializationUtil.registerEventListener(vehicleType, "onReadUpdateStream", SwitchMowerMulcher)
	SpecializationUtil.registerEventListener(vehicleType, "onWriteUpdateStream", SwitchMowerMulcher)
end