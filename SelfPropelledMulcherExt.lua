SelfPropelledMulcherExt = {}

function SelfPropelledMulcherExt:doCheckSpeedLimit(superFunc)
    return (self:getIsTurnedOn() and (self.getIsImplementChainLowered == nil or self:getIsImplementChainLowered())) or (self:getIsTurnedOn() and (self.getIsLowered == nil or self:getIsLowered()))
end

---Checks if all prerequisite specializations are loaded
-- @param table specializations specializations
-- @return boolean hasPrerequisite true if all prerequisite specializations are loaded
function SelfPropelledMulcherExt.prerequisitesPresent(specializations)
	return SpecializationUtil.hasSpecialization(Mulcher, specializations)
end

function SelfPropelledMulcherExt.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType,"doCheckSpeedLimit", SelfPropelledMulcherExt.doCheckSpeedLimit)
end