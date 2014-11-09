/obj/item/clothing/mask/balaclava
	name = "balaclava"
	icon_state = "balaclava"
	item_state = "balaclava"
	item_color = "black"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2

/obj/item/clothing/mask/balaclava/New()
..()
desc="A [item_color] balaclava"

//New dyed balaclavas, complements of Lichling and Raptorblaze
/obj/item/clothing/mask/balaclava/red
	icon_state = "balaclava_red"
	item_state = "balaclava_red"
	item_color = "red"

/obj/item/clothing/mask/balaclava/orange
	icon_state = "balaclava_orange"
	item_state = "balaclava_orange"
	item_color = "orange"

/obj/item/clothing/mask/balaclava/yellow
	icon_state = "balaclava_yellow"
	item_state = "balaclava_yellow"
	item_color = "yellow"

/obj/item/clothing/mask/balaclava/green
	icon_state = "balaclava_green"
	item_state = "balaclava_green"
	item_color = "green"

/obj/item/clothing/mask/balaclava/blue
	icon_state = "balaclava_blue"
	item_state = "balaclava_blue"
	item_color = "blue"

/obj/item/clothing/mask/balaclava/purple
	icon_state = "balaclava_purple"
	item_state = "balaclava_purple"
	item_color = "purple"

/obj/item/clothing/mask/balaclava/rainbow
	icon_state = "balaclava_rainbow"
	item_state = "balaclava_rainbow"
	item_color = "rainbow"

/obj/item/clothing/mask/balaclava/mime
	icon_state = "balaclava_mime"
	item_state = "balaclava_mime"
	item_color = "mime"

/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchag"
	item_state = "luchag"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2

/obj/item/clothing/mask/luchador/speechModification(message)
	if(copytext(message, 1, 2) != "*")
		message = replacetext(message, "captain", "CAPITÁN")
		message = replacetext(message, "station", "ESTACIÓN")
		message = replacetext(message, "sir", "SEÑOR")
		message = replacetext(message, "the ", "el ")
		message = replacetext(message, "my ", "mi ")
		message = replacetext(message, "is ", "es ")
		message = replacetext(message, "it's", "es")
		message = replacetext(message, "friend", "amigo")
		message = replacetext(message, "buddy", "amigo")
		message = replacetext(message, "hello", "hola")
		message = replacetext(message, " hot", " caliente")
		message = replacetext(message, " very ", " muy ")
		message = replacetext(message, "sword", "espada")
		message = replacetext(message, "library", "biblioteca")
		message = replacetext(message, "traitor", "traidor")
		message = replacetext(message, "wizard", "mago")
		message = uppertext(message)	//Things end up looking better this way (no mixed cases), and it fits the macho wrestler image.
		if(prob(25))
			message += " OLE!"
	return message

/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon_state = "luchador"
	item_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon_state = "luchar"
	item_state = "luchar"