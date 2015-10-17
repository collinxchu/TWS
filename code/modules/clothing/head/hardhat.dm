/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	item_state = "hardhat0_yellow"
	brightness_on = 4 //luminosity when on
	item_color = "yellow" //Determines used sprites: hardhat[on]_[color] and hardhat[on]_[color]2 (lying down sprite)
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	flags_inv = 0
	siemens_coefficient = 0.9
	action_button_name = "Toggle Helmet Light"
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/head/hardhat/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "<span class='warning'>You cannot turn the light on while in this [user.loc]!</span>" //To prevent some lighting anomalities.
		return
	on = !on
	icon_state = "hardhat[on]_[item_color]"
	item_state = "hardhat[on]_[item_color]"
	user.update_inv_head()	//so our mob-overlays update

	if(on)	set_light(brightness_on)
	else	set_light(0)


/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	item_state = "hardhat0_orange"
	item_color = "orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	item_state = "hardhat0_red"
	item_color = "red"
	name = "firefighter helmet"
	flags = STOPSPRESSUREDMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	item_state = "hardhat0_white"
	item_color = "white"
	flags = STOPSPRESSUREDMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT


/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat0_dblue"
	item_state = "hardhat0_dblue"
	item_color = "dblue"

/obj/item/clothing/head/hardhat/atmos
	icon_state = "hardhat0_atmos"
	item_state = "hardhat0_atmos"
	item_color = "atmos"
	name = "atmospheric technician's firefighting helmet"
	desc = "A firefighter's helmet, able to keep the user cool in any situation."
	flags = STOPSPRESSUREDMAGE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT