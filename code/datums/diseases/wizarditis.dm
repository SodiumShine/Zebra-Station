/datum/disease/wizarditis
	name = "Wizarditis"
	max_stages = 4
	spread = "Syringe"
	spread_type = SPECIAL
	cure = "The Manly Dorf & Iron"
	cure_id = list("manlydorf","iron")
	cure_chance = 15
	agent = "Rincewindus Vulgaris"
	affected_species = list("Human")
	curable = 0
	permeability_mod = 0.75
	desc = "Some speculate, that this virus is the cause of Wizard Federation existance. Subjects affected show the signs of mental retardation, yelling obscure sentences or total gibberish. On late stages subjects sometime express the feelings of inner power, and, cite, 'the ability to control the forces of cosmos themselves!' A gulp of strong, manly spirits usually reverts them to normal, humanlike, condition."
	severity = "Harmful"
	requires = 1
	required_limb = list(/obj/item/organ/limb/head)

/*
BIRUZ BENNAR
SCYAR NILA - teleport
NEC CANTIO - dis techno
EI NATH - shocking grasp
AULIE OXIN FIERA - knock
TARCOL MINTI ZHERI - forcewall
STI KALY - blind
*/

/datum/disease/wizarditis/stage_act()
	..()
	var/mob/living/M = affected_mob
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		switch(stage)
			if(2)
				if(prob(3))
					affected_mob.say(pick("You shall not pass!", "Expeliarmus!", "By Merlins beard!", "Feel the power of the Dark Side!"))
				else if(prob(3))
					affected_mob << "\red You feel [pick("that you don't have enough mana.", "that the winds of magic are gone.", "an urge to summon familiar.")]"
				if(H.facial_hair_style == "Shaved")
					H.facial_hair_style = "Adam Jensen Beard"
					H.update_hair()
			if(3)
				if(prob(1)&&prob(50))
					affected_mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!", "STI KALY!", "TARCOL MINTI ZHERI!"))
				if(prob(1)&&prob(50))
					affected_mob << "\red You feel [pick("the magic bubbling in your veins","that this location gives you a +1 to INT","an urge to summon familiar.")]."
				if(!(H.facial_hair_style == "Dwarf Beard") && !(H.facial_hair_style == "Very Long Beard") && !(H.facial_hair_style == "Full Beard"))
					H.facial_hair_style = "Full Beard"
					H.update_hair()
			if(4)
				if(prob(10) && prob(50))
					affected_mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!","STI KALY!","EI NATH!", "TARCOL MINTI ZHERI!"))
					return
				else if(prob(10))
					affected_mob << "\red You feel [pick("the tidal wave of raw power building inside","that this location gives you a +2 to INT and +1 to WIS","an urge to teleport","an urge to summon familiar.","the magic bubbling in your veins")]."
				if(prob(50))
					spawn_wizard_clothes(50)
				if(prob(1))
					teleport()
				if(!(H.facial_hair_style == "Dwarf Beard") && !(H.facial_hair_style == "Very Long Beard"))
					H.facial_hair_style = pick("Dwarf Beard", "Very Long Beard")
					H.update_hair()
		return



/datum/disease/wizarditis/proc/spawn_wizard_clothes(var/chance = 0)
	if(istype(affected_mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = affected_mob
		if(prob(chance))
			if(!istype(H.head, /obj/item/clothing/head/wizard))
				if(!H.unEquip(H.head))
					qdel(H.head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(H), slot_head)
			return
		if(prob(chance))
			if(!istype(H.wear_suit, /obj/item/clothing/suit/wizrobe))
				if(!H.unEquip(H.wear_suit))
					qdel(H.wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(H), slot_wear_suit)
			return
		if(prob(chance))
			if(!istype(H.shoes, /obj/item/clothing/shoes/sandal))
				if(!H.unEquip(H.shoes))
					qdel(H.shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes)
			return
		if(prob(chance))
//			world << "Staff chance done"
			if(!istype(H.r_hand, /obj/item/weapon/gun/magic/wand/fakewizard))
//				world << "Type check for r_hand done"
				H.drop_r_hand()
				H.put_in_r_hand(new /obj/item/weapon/gun/magic/wand/fakewizard(H), slot_r_hand)
	return



/datum/disease/wizarditis/proc/teleport()
	var/list/theareas = new/list()
	for(var/area/AR in orange(80, affected_mob))
		if(theareas.Find(AR) || istype(AR,/area/space)) continue
		theareas += AR

	if(!theareas)
		return

	var/area/thearea = pick(theareas)

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		if(T.z != affected_mob.z) continue
		if(T.name == "space") continue
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L)
		return

	affected_mob.say("SCYAR NILA [uppertext(thearea.name)]!")
	affected_mob.loc = pick(L)

	return
