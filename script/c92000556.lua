--???
--Traffic Ghost
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,3,3)
	--atk up
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCondition(s.sexatkcon)
	e9:SetValue(1800)
	c:RegisterEffect(e9)
end
-- second effect
function s.sexatkcon(e)
	return Duel.IsPhase(PHASE_DAMAGE_CAL)
end