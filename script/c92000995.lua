--Cipher Stream of Destruction
local s,id=GetID()
function s.initial_effect(c)
	--Activate 1 of these effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMING_BATTLE_START|TIMING_BATTLE_END|TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
end
s.listed_series={0xe5}
s.listed_names={id}
--first effect filter
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe5) and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end
function s.cfilter2(c,code)
	return c:IsFaceup() and c:IsSetCard(0xe5) and c:IsCode(code)
end
--second effect filter
--function s.runfn(fn,eff,re,tp,chk)
--	return not fn or fn(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,re,REASON_EFFECT,PLAYER_NONE,chk)
--end
--function s.efffilter(c,e,tp)
--	if c:IsFacedown() or IsSpellTrap() or not (c:IsSetCard(0xe5) and c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp))then return false end
--	for _,eff in ipairs({c:GetOwnEffects()}) do
--		if eff:HasDetachCost() and s.runfn(eff:GetCondition(),eff,e,tp) and s.runfn(eff:GetTarget(),eff,e,tp,0) then return true end
--	end
--	return false
--end
--third effect filter
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsType(TYPE_XYZ)
end
--
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local op=e:GetLabel()
		if op==1 or not (chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)) then return false end
		return --(op==2 and s.efffilter(chkc)) or 
		(op==3 and s.spfilter(chkc,e,tp))
	end
--correct
	local b1=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.HasFlagEffect(tp,id)
--correct
--	local b2=Duel.IsExistingTarget(s.efffilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
--		and not Duel.HasFlagEffect(tp,id+1)
--correct
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and not Duel.HasFlagEffect(tp,id+2)
	if chk==0 then return b1 or b2 or b3 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{b3,aux.Stringid(id,3)})
	e:SetLabel(op)
--correct
	if op==1 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(0)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,0)
--correct (fuck if i know)
--	elseif op==2 then
--		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE|PHASE_END,0,1)
--		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
--		Duel.SelectTarget(tp,s.efffilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
--correct
	elseif op==3 then
		Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE|PHASE_END,0,1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		--Destroy all monsters your opp controls (correct)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
--	elseif op==2 then
		--Tachyon Unit
--		local tc=Duel.GetFirstTarget()
--		if not tc:IsRelateToEffect(e) then return end
--		local effs={}
--		local options={}
--		for _,eff in ipairs({tc:GetOwnEffects()}) do
--			if eff:HasDetachCost() then
--				table.insert(effs,eff)
--				local eff_chk=s.runfn(eff:GetCondition(),eff,e,tp) and s.runfn(eff:GetTarget(),eff,e,tp,0)
--				table.insert(options,{eff_chk,eff:GetDescription()})
--			end
--		end
--		local op=#options==1 and 1 or Duel.SelectEffect(tp,table.unpack(options))
--		if not op then return end
--		local te=effs[op]
--		if not te then return end
--		Duel.ClearTargetCard()
--		s.runfn(te:GetTarget(),te,e,tp,1)
--		Duel.BreakEffect()
--		tc:CreateEffectRelation(te)
--		Duel.BreakEffect()
--		local tg=Duel.GetTargetCards(te)
--		tg:ForEach(Card.CreateEffectRelation,te)
--		s.runfn(te:GetOperation(),te,e,tp,1)
--		tg:ForEach(Card.ReleaseEffectRelation,te)
	elseif op==3 then
		--Special Summon 1 LIGHT Xyz Dragon monster from your GY in Defense Position (correct)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end