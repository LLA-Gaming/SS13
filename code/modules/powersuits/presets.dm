//Standard
/obj/item/clothing/suit/space/powersuit/standard
	model_name = "standard"
	icon_state = "p-armor1"
	armor_attachment_type = /obj/item/weapon/powersuit_attachment/armor/

//Helmet variations
/obj/item/clothing/suit/space/powersuit/standard/hunter
	helmet_type = /obj/item/clothing/head/helmet/space/powerhelmet/hunter

/obj/item/clothing/suit/space/powersuit/standard/chameleon
	helmet_type = /obj/item/clothing/head/helmet/space/powerhelmet/chameleon

/obj/item/clothing/suit/space/powersuit/standard/bugman
	helmet_type = /obj/item/clothing/head/helmet/space/powerhelmet/bugman

//special suits
/obj/item/clothing/suit/space/powersuit/security
	model_name = "security"
	icon_state = "p-armor2"
	helmet_type = /obj/item/clothing/head/helmet/space/powerhelmet/security
	primary_attachment_type = /obj/item/weapon/powersuit_attachment/krav_maga
	secondary_attachment_type = /obj/item/weapon/powersuit_attachment/adrenaline_injector
	armor_attachment_type = /obj/item/weapon/powersuit_attachment/armor/security

/obj/item/clothing/suit/space/powersuit/syndicate
	model_name = "syndicate"
	icon_state = "p-armor3"
	helmet_type = /obj/item/clothing/head/helmet/space/powerhelmet/syndicate
	cell_type = /obj/item/weapon/stock_parts/cell/fusion/extended
	armor_attachment_type = /obj/item/weapon/powersuit_attachment/armor/syndicate

/obj/item/clothing/suit/space/powersuit/mangled
	model_name = "mangled"
	icon_state = "p-armor4"
	helmet_type = /obj/item/clothing/head/helmet/space/powerhelmet/mangled
	cell_type = /obj/item/weapon/stock_parts/cell/fusion/enhanced
	armor_attachment_type = /obj/item/weapon/powersuit_attachment/armor/mangled
	primary_attachment_type = /obj/item/weapon/powersuit_attachment/stun_punch
	secondary_attachment_type = /obj/item/weapon/powersuit_attachment/smoke_bombs