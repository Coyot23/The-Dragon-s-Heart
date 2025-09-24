--???
--Link Infra-Flier
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon itself from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetValue(s.spval)
	c:RegisterEffect(e1)
	--atk up
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCondition(s.sexatkcon)
	e9:SetValue(0)
	c:RegisterEffect(e9)
	local e8=e9:Clone()
	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(1800)
	c:RegisterEffect(e8)
end
-- second effect
function s.sexatkcon(e)
	return Duel.IsPhase(PHASE_DAMAGE_CAL)
end
function s.spval(e,c)
	return 0,aux.GetMMZonesPointedTo(c:GetControler())
end