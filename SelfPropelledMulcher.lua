SelfPropelledMulcher = {}

function SelfPropelledMulcher:doCheckSpeedLimit(superFunc)
    return (self:getIsTurnedOn() and (self.getIsImplementChainLowered == nil or self:getIsImplementChainLowered())) or (self:getIsTurnedOn() and (self.getIsLowered == nil or self:getIsLowered()))
end

---Checks if all prerequisite specializations are loaded
-- @param table specializations specializations
-- @return boolean hasPrerequisite true if all prerequisite specializations are loaded
function SelfPropelledMulcher.prerequisitesPresent(specializations)
	return SpecializationUtil.hasSpecialization(Mulcher, specializations)
end

function SelfPropelledMulcher.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType,"doCheckSpeedLimit", SelfPropelledMulcher.doCheckSpeedLimit)
end