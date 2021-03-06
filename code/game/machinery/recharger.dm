//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/recharger
	name = "recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	desc = "A charging dock for energy based weaponry."
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 250
	interact_offline = TRUE
	var/obj/item/weapon/charging = null
	var/recharge_coeff = 1
	var/static/list/allowed_items = list(
                                        /obj/item/weapon/gun/energy,
                                        /obj/item/weapon/melee/baton,
                                        /obj/item/weapon/twohanded/shockpaddles/standalone,
                                        /obj/item/ammo_box/magazine/l10mag
                                    )

/obj/machinery/recharger/atom_init()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/recharger()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	RefreshParts()

/obj/machinery/recharger/RefreshParts()
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		recharge_coeff = C.rating

/obj/machinery/recharger/attackby(obj/item/weapon/G, mob/user)
	if(istype(user,/mob/living/silicon))
		return
	if(is_type_in_list(G, allowed_items))
		if(charging || panel_open)
			return

		// Checks to make sure he's not in space doing it, and that the area got proper power.
		var/area/a = get_area(src)
		if(!isarea(a))
			to_chat(user, "\red The [name] blinks red as you try to insert the item!")
			return
		if(!a.power_equip && a.requires_power)
			to_chat(user, "\red The [name] blinks red as you try to insert the item!")
			return

		if (istype(G, /obj/item/weapon/gun/energy/gun/nuclear) || istype(G, /obj/item/weapon/gun/energy/crossbow))
			to_chat(user, "<span class='notice'>Your gun's recharge port was removed to make room for a miniaturized reactor.</span>")
			return
		if (istype(G, /obj/item/weapon/gun/magic))
			return
		user.drop_item()
		G.loc = src
		charging = G
		use_power = 2
		update_icon()
	else if(istype(G, /obj/item/weapon/wrench))
		if(charging)
			to_chat(user, "\red Remove the weapon first!")
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
	if (anchored && !charging)
		if(default_deconstruction_screwdriver(user, istype(src, /obj/machinery/recharger/wallcharger) ? "wrechargeropen" : "rechargeropen", istype(src, /obj/machinery/recharger/wallcharger) ? "wrecharger0" : "recharger0", G))
			return

		if(panel_open && istype(G, /obj/item/weapon/crowbar))
			default_deconstruction_crowbar(G)
			return

/obj/machinery/recharger/attack_ai(mob/user)
	if(IsAdminGhost(user))
		return ..()
	return 1

/obj/machinery/recharger/attack_hand(mob/user)
	if(..())
		return 1

	if(charging)
		charging.update_icon()
		charging.loc = loc
		charging = null
		use_power = 1
		update_icon()

/obj/machinery/recharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		return

	if(charging)
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(E.power_supply.charge < E.power_supply.maxcharge)
				//E.power_supply.give(E.power_supply.chargerate * recharge_coeff)
				E.power_supply.give(100 * recharge_coeff)
				icon_state = "recharger1"
				use_power(250 * recharge_coeff)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			//if(B.bcell.give(B.bcell.chargerate * recharge_coeff))
			if(B.charges < initial(B.charges))
				B.charges++
				icon_state = "recharger1"
				use_power(200 * recharge_coeff)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/weapon/twohanded/shockpaddles/standalone))
			var/obj/item/weapon/twohanded/shockpaddles/standalone/D = charging
			if(D.charges < initial(D.charges))
				D.charges++
				icon_state = "recharger1"
				use_power(200 * recharge_coeff)
			else
				icon_state = "recharger2"
			return
		if(istype(charging, /obj/item/ammo_box/magazine/l10mag))
			var/obj/item/ammo_box/magazine/l10mag/M = charging
			if (M.stored_ammo.len < M.max_ammo)
				M.stored_ammo += new M.ammo_type(M)
				if(prob(80)) //double charging speed
					if (M.stored_ammo.len < M.max_ammo)
						M.stored_ammo += new M.ammo_type(M)
				update_icon()
				icon_state = "recharger1"
				use_power(500 * recharge_coeff)
			else
				icon_state = "recharger2"

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(istype(charging,  /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/E = charging
		if(E.power_supply)
			E.power_supply.emp_act(severity)

	else if(istype(charging, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = charging
		B.charges = 0
	..(severity)

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(stat & (NOPOWER|BROKEN) || !anchored)
		icon_state = "rechargeroff"
	else if(panel_open)
		icon_state = "rechargeropen"
	else if(charging)
		icon_state = "recharger1"
	else
		icon_state = "recharger0"

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"

/obj/machinery/recharger/wallcharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		return

	if(charging)
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(E.power_supply.charge < E.power_supply.maxcharge)
				E.power_supply.give(100 * recharge_coeff)
				icon_state = "wrecharger1"
				use_power(250 * recharge_coeff)
			else
				icon_state = "wrecharger2"
			return
		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			if(B.charges < initial(B.charges))
				B.charges++
				icon_state = "wrecharger1"
				use_power(200 * recharge_coeff)
			else
				icon_state = "wrecharger2"
			return
		if(istype(charging, /obj/item/weapon/twohanded/shockpaddles/standalone))
			var/obj/item/weapon/twohanded/shockpaddles/standalone/D = charging
			if(D.charges < initial(D.charges))
				D.charges++
				icon_state = "wrecharger1"
				use_power(200 * recharge_coeff)
			else
				icon_state = "wrecharger2"
		if(istype(charging, /obj/item/ammo_box/magazine/l10mag))
			var/obj/item/ammo_box/magazine/l10mag/M = charging
			if (M.stored_ammo.len < M.max_ammo)
				M.stored_ammo += new M.ammo_type(M)
				if(prob(80)) //double charging speed
					if (M.stored_ammo.len < M.max_ammo)
						M.stored_ammo += new M.ammo_type(M)
				update_icon()
				icon_state = "wrecharger1"
				use_power(500 * recharge_coeff)
			else
				icon_state = "wrecharger2"

/obj/machinery/recharger/wallcharger/update_icon()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		icon_state = "wrechargeroff"
	else if(panel_open)
		icon_state = "wrechargeropen"
	else if(charging)
		icon_state = "wrecharger1"
	else
		icon_state = "wrecharger0"
