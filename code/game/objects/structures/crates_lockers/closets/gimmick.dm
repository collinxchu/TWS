/obj/structure/closet/cabinet
	name = "classic cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet"
	icon_door = "classic_cabinet"
	burn_state = 0 //Burnable
	burntime = 20

/obj/structure/closet/acloset
	name = "strange closet"
	desc = "It looks alien!"
	icon_state = "alien"

/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "It's a storage unit for things that have no right being here."
	icon_state = "syndicate_green"
	anchored = 0

/obj/structure/closet/gimmick/russian
	name = "russian surplus closet"
	desc = "It's a storage unit for Russian standard-issue surplus."

/obj/structure/closet/gimmick/russian/New()
	..()
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)


/obj/structure/closet/gimmick/tacticool
	name = "tacticool gear closet"
	desc = "It's a storage unit for Tacticool gear."

/obj/structure/closet/gimmick/tacticool/New()
	..()
	new /obj/item/clothing/glasses/eyepatch(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/shoes/swat(src)
	new /obj/item/clothing/shoes/swat(src)
	new /obj/item/clothing/suit/armor/swat(src)
	new /obj/item/clothing/suit/armor/swat(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)


/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	anchored = 1

/obj/structure/closet/thunderdome/New()
	..()

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"
	icon_door = "red"

/obj/structure/closet/thunderdome/tdred/New()
	..()
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	icon_door = "green"

/obj/structure/closet/thunderdome/tdgreen/New()
	..()
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/melee/energy/sword(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/gun/energy/laser(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/melee/baton(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
