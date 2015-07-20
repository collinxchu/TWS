/obj/machinery/street/
	name = "street"

/obj/machinery/street/lamp
	name = "street lamp"
	anchored = 1
	density = 1
	luminosity = 3
	pixel_x = -16
	layer = 9
	icon = 'icons/obj/street.dmi'
	icon_state = "streetlamp1"
	var/on = 1
	var/brightness_on = 3		//can't remember what the maxed out value is




/obj/machinery/street/lamp/attack_hand(mob/user as mob)

	if(on)
		on = 0
		user << "\blue You turn off the light"
		SetLuminosity(0)
	else
		on = 1
		user << "\blue You turn on the light"
		SetLuminosity(brightness_on)



