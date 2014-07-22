/*
* All weapon related code goes here.
*/


#define EP_STUNTIME_SINGLE 6.25
#define EP_STUNTIME_AOE 3

#define SKNIFE_STUNTIME 7.5

#define USE_SKNIFE_CHARGES 0
#define SKNIFE_CHARGE_COST 200
#define SKNIFE_CHARGE_INTERVAL 50

//Type of implant needed to shoot the gun.
/obj/item/weapon/gun/var/locked

/*
* Energy Magazines
*/

/obj/item/weapon/stock_parts/cell/magazine
	name = "energy magazine"
	icon = 'icons/obj/ammo.dmi'
	item_state = "ammomagazine"
	w_class = 2

	update_icon()
		overlays.Cut()
		overlays += image("icon" = 'icons/obj/ammo.dmi', "icon_state" = "[initial(icon_state)]mag[round(charge/maxcharge, 0.2)*100]")

	New()
		..()
		spawn(5)
			update_icon()

/obj/item/weapon/stock_parts/cell/magazine/ep90
	name = "ep90 energy magazine"
	icon_state = "ep90"
	maxcharge = 1000

/*
* Projectiles and ammo_casings for the EP90.
*/

/obj/item/projectile/energy/ep90_single
	name = "energy"
	icon_state = "ep90"
	hitsound = 0

	stun = EP_STUNTIME_SINGLE
	weaken = EP_STUNTIME_SINGLE
	stutter = EP_STUNTIME_SINGLE

	damage = 1
	damage_type = BURN
	flag = "energy"

/obj/item/projectile/energy/ep90_aoe
	name = "energy"
	icon_state = "ep90"
	hitsound = 0

	bump_at_ttile = 1

	stun = EP_STUNTIME_AOE
	weaken = EP_STUNTIME_AOE
	stutter = EP_STUNTIME_AOE

	damage = 1
	damage_type = BURN
	flag = "energy"

	bump_at_ttile = 1

	on_hit(var/atom/target, var/blocked = 0)
		for(var/turf/T in range(1, target))
			new /obj/effect/effect/sparks(get_turf(T))
			for(var/mob/living/M in T)
				M.SetWeakened(EP_STUNTIME_AOE)

/obj/item/ammo_casing/energy/ep90_single
	select_name = "semi-automatic fire"
	projectile_type = /obj/item/projectile/energy/ep90_single
	e_cost = 20
	fire_sound = 'sound/weapons/ep90.ogg'

/obj/item/ammo_casing/energy/ep90_aoe
	select_name = "area-of-effect fire"
	projectile_type = /obj/item/projectile/energy/ep90_aoe
	e_cost = 125
	fire_sound = 'sound/weapons/ep90.ogg'

/obj/item/ammo_casing/energy/ep90_burst_3
	select_name = "3-round-burst"
	projectile_type = /obj/item/projectile/energy/ep90_single
	e_cost = 20
	fire_sound = 'sound/weapons/ep90.ogg'

	burst = 2
	burst_delay = 0.16

/obj/item/ammo_casing/energy/ep90_burst_5
	select_name = "5-round-burst"
	projectile_type = /obj/item/projectile/energy/ep90_single
	e_cost = 20
	fire_sound = 'sound/weapons/ep90.ogg'

	burst = 4
	burst_delay = 0.27

/*
* EP-90
*/

/obj/item/weapon/gun/energy/ep90
	name = "Energy Project-90"
	desc = "An ancient model, reworked to fire light energy pulses."
	icon_state = "ep90"
	w_class = 3.0
	item_state = "ep"
	m_amt = 2000
	cell_type = "/obj/item/weapon/stock_parts/cell/magazine/ep90"
	ammo_type = list(/obj/item/ammo_casing/energy/ep90_single, /obj/item/ammo_casing/energy/ep90_aoe, /obj/item/ammo_casing/energy/ep90_burst_3, /obj/item/ammo_casing/energy/ep90_burst_5)
	fire_sound = 'sound/weapons/ep90.ogg'
	locked = /obj/item/weapon/implant/enforcer

	attack_self(var/mob/living/user as mob)
		select_fire(user)

	update_icon()
		if(power_supply)
			icon_state = "[initial(icon_state)]_mag[round(power_supply.percent(), 25)]"
		else
			icon_state = "ep90"

	/*
	* Inserting and removing the power_supply (battery)
	*/

	attack_hand(var/mob/living/M)
		if(power_supply && (M.l_hand == src || M.r_hand == src))
			power_supply.loc = get_turf(src)
			M << "<div class='notice'>You remove the [power_supply] from the [src].</div>"
			var/obj/item/I = power_supply
			power_supply.update_icon()
			power_supply = 0
			update_icon()
			if(!M.put_in_any_hand_if_possible(I))	return
			return
		..()

	attackby(var/obj/item/I, var/mob/living/M)
		if(istype(I, /obj/item/weapon/stock_parts/cell))
			if(power_supply)
				M << "<div class='warning'>There is already a power supply installed.</div>"
				return
			M.drop_item()
			I.loc = src
			power_supply = I
			M << "<div class='notice'>You insert the [I] into the [src].</div>"
			update_icon()
		..()

/*
* Five Seven
*/

/obj/item/projectile/bullet/fiveseven
	damage = 49
	stun = 3
	weaken = 3

/obj/item/ammo_casing/fiveseven
	desc = "A 5.7x28mm casing"
	caliber = "5.7x28mm"
	projectile_type = /obj/item/projectile/bullet/fiveseven


/obj/item/ammo_box/magazine/fiveseven
	name = "5.7x28mm magazine"
	icon_state = "50ae"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/fiveseven
	caliber = "5.7x28mm"
	max_ammo = 20
	multiple_sprites = 0

/obj/item/weapon/gun/projectile/automatic/fiveseven
	name = "five-seven"
	icon = 'icons/obj/gun.dmi'
	icon_state = "fiveseven"
	mag_type = /obj/item/ammo_box/magazine/fiveseven
	locked = /obj/item/weapon/implant/enforcer
	force = 10

	update_icon()
		return

/*
* Stun Knife
*/

/obj/item/weapon/stun_knife
	name = "Stun Knife"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sknife"
	item_state = "sknife"

	force = 17
	throwforce = 2
	w_class = 2

	var/locked = /obj/item/weapon/implant/enforcer
	var/mode = 1 //0 = attack | 1 = stun
	var/lastCharge = 0
	var/obj/item/weapon/stock_parts/cell/power_supply

	update_icon()
		icon_state = "[initial(icon_state)][mode]"

	New()
		..()
		if(USE_SKNIFE_CHARGES)
			power_supply = new()
			processing_objects.Add(src)
		update_icon()

	examine()
		..()
		usr << "<div class='notice'>The charge indicator reads: [power_supply.percent()]% charge left.</div>"

	process()
		if(SKNIFE_CHARGE_INTERVAL < world.time - lastCharge)
			power_supply.give(SKNIFE_CHARGE_COST)
			lastCharge = world.time

	attack(var/mob/living/M, var/mob/living/user)
		if(USE_SKNIFE_CHARGES)
			if(power_supply.charge - SKNIFE_CHARGE_COST < 0)
				user << "<div class='warning'>Out of charge.</div>"
				return
		if(locked)
			if(!user.check_contents_for(locked))
				var/datum/effect/effect/system/spark_spread/S = new/datum/effect/effect/system/spark_spread(get_turf(src))
				S.set_up(3, 0, get_turf(src))
				S.start()
				user << "<div class='warning'>The [src] shocks you.</div>"
				user.AdjustWeakened(2)
				return
		add_fingerprint(user)
		if(USE_SKNIFE_CHARGES)
			power_supply.use(SKNIFE_CHARGE_COST)
		switch(mode)
			if(1)
				M.SetStunned(SKNIFE_STUNTIME)
				M.SetWeakened(SKNIFE_STUNTIME)
				M.stuttering = SKNIFE_STUNTIME
				M.lastattacker = user
				var/turf/T = get_turf(M)
				T.visible_message("\red [M] has been stunned by [user] with \the [src]")
			if(0)
				M.apply_damage(force, BRUTE)
				M.lastattacker = user
				var/turf/T = get_turf(M)
				T.visible_message("\red [M] has been attacked by [user] with \the [src]")

	attack_self(var/mob/user)
		..()
		mode = !mode
		user << "<div class='notice'>The [src] is now set to [mode ? "stun" : "lethal"].</div>"
		force = mode == 0 ? 17 : 1
		update_icon()


#undef EP_STUNTIME_SINGLE
#undef EP_STUNTIME_AOE

#undef SKNIFE_STUNTIME
#undef SKNIFE_CHARGE_COST
#undef SKNIFE_CHARGE_INTERVAL
#undef USE_SKNIFE_CHARGES