//| used to determine whether or not an item can light something on fire
/proc/is_hot(obj/item/W)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/O = W
		if(O.isOn())
			return 3800
		else
			return 0
	if(istype(W, /obj/item/weapon/flame/lighter))
		var/obj/item/weapon/flame/lighter/O = W
		if(O.lit)
			return 1500
		else
			return 0
	if(istype(W, /obj/item/weapon/flame/match))
		var/obj/item/weapon/flame/match/O = W
		if(O.lit == 1)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/O = W
		if(O.lit)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/O = W
		if(O.lit)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/O = W
		if(O.on)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		return 3800
	if(istype(W, /obj/item/weapon/melee/energy))
		var/obj/item/weapon/melee/energy/O = W
		if(O.active)
			return 3500
		else
			return 0
	if(istype(W, /obj/item/device/assembly/igniter))
		return 1000
	else
		return 0