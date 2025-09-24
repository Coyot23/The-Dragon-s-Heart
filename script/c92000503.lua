--???
--Threshold Borg
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--reduce atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	--atk up
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCondition(s.atkcon)
	e9:SetValue(2400)
	c:RegisterEffect(e9)
	local e8=e9:Clone()
	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(2000)
	c:RegisterEffect(e8)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 and
		Duel.IsExistingMatchingCard(Card.IsRace,c:GetControler(),LOCATION_HAND,0,1,c,RACE_CYBERSE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_HAND,0,1,1,c,RACE_CYBERSE)
	Duel.SendtoGrave(g,REASON_DISCARD|REASON_COST)
end
--second effect
function s.atkcon(e)
	return Duel.IsPhase(PHASE_DAMAGE_CAL)
end