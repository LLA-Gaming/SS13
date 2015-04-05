/obj/item/weapon/picket_sign
	icon_state = "picket"
	name = "blank picket sign"
	desc = "It's blank"
	force = 5
	w_class = 4.0
	attack_verb = list("bashed","smacked")
	var/cooldown = 0
	var/label = ""

/obj/item/weapon/picket_sign/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/toy/crayon))
		var/txt = stripped_input(user, "What would you like to write on the sign?", "Sign Label", null , 30)
		if(txt)
			label = txt
			src.name = "[label] sign"
			desc =	"It reads: [label]"
	..()

/obj/item/weapon/picket_sign/attack_self(mob/living/carbon/human/user)
	if(cooldown) return
	if(label)
		user.visible_message("<span class='warning'>[user] waves around \the \"[label]\" sign.</span>")
	else
		user.visible_message("<span class='warning'>[user] waves around blank sign.</span>")
	cooldown = 1
	spawn(10)
		cooldown = 0
