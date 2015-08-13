/obj/structure/closet/secure_closet/cargotech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	icon_state = "cargo"

	New()
		..()
		new /obj/item/clothing/under/rank/cargotech(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/soft(src)
//		new /obj/item/weapon/cartridge/quartermaster(src)
		return

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	icon_state = "qm"

	New()
		..()
		new /obj/item/clothing/under/rank/cargo(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/clothing/gloves/black(src)
//		new /obj/item/weapon/cartridge/quartermaster(src)
		new /obj/item/clothing/suit/fire/firefighter(src)
		new /obj/item/weapon/tank/emergency_oxygen(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/clothing/head/soft(src)
		return
