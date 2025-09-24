--???
--Bravedrive
--scripted by andre
local s,id=GetID()
function s.initial_effect(c)
	--gains attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--atk up
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCondition(s.sexatkcon)
	e9:SetValue(1500)
	c:RegisterEffect(e9)
	local e8=e9:Clone()
	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(1000)
	c:RegisterEffect(e8)
end
-- second effect
function s.sexatkcon(e)
	return Duel.IsPhase(PHASE_DAMAGE_CAL)
end
function s.condition(e,tp)
	return Duel.GetAttacker():IsControler(tp) and Duel.GetAttacker():IsRace(RACE_CYBERSE)
end
function s.cfilter(c)
	return c:IsDiscardable() and c:IsMonster()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST|REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return at:IsRelateToBattle() end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at and at:IsFaceup() and at:CanAttack() and at:IsRelateToBattle() and not at:IsStatus(STATUS_ATTACK_CANCELED) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(600)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			at:RegisterEffect(e1)
	end
end