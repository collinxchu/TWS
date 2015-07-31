//rename to sportscar if you need
//mostly, my changes just update the C.pixel_ y and x on every iteration of the overlay update proc, since default vehicle code //only does that upon entering. Watch the weird formatting pastebin introduces.

/obj/vehicle/train/cargo/engine/sportscar
	name = "sports car"
	desc = "A very luxurious vehicle."
	icon = 'icons/vehicles/sportscar.dmi'
	icon_state = "sportscar"
	emagged = 0
	health = 100
	charge_use = 0
	bound_width = 64
	bound_height = 64
	movable = 0
	fits_passenger = 1
	passenger_item_visible = 1
	//pixel_y offset for mob overlay


/obj/vehicle/train/cargo/engine/sportscar/proc/update_dir_sportscar_overlays()
	var/atom/movable/C = src.load
	var/atom/movable/D = src.passenger
	src.overlays = null
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)
			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_north", layer = src.layer + 0.2) //over mobs
			src.overlays += I

			src.mob_offset_x = 2
			src.mob_offset_y = 20

			if(passenger && load) //move the driver back to the original layer
				C.layer = default_layer
			src.passenger_offset_x = 22
			src.passenger_offset_y = 20

		else if(src.dir == SOUTH)

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_south", layer = src.layer + 0.2) //over mobs
			overlays += I

			if(passenger && load) //moves the driver back to the original layer
				C.layer = default_layer
			src.mob_offset_x = 20
			src.mob_offset_y = 27

			src.passenger_offset_x = 3
			src.passenger_offset_y = 27

		else if(src.dir == WEST)

			src.mob_offset_x = 34
			src.mob_offset_y = 10

			if(passenger && load) //move the driver the one layer above the passenger, so he is displayed properly when they overlap
				C.layer = default_layer + 0.1
			src.passenger_offset_x = 34
			src.passenger_offset_y = 23

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_west", layer = src.layer + 0.2) //over mobs
			src.overlays += I
			if(passenger && !load)
				var/image/S = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_west_passenger", layer = src.layer + 0.2) //over mobs
				src.overlays += S

		else if(src.dir == EAST)

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_east_passenger", layer = src.layer + 0.2) //over mobs

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10

			if(passenger && load) //move the driver back to the original layer
				C.layer = default_layer
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_east", layer = src.layer + 0.2) //over mobs
				src.overlays += S

	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x
	if(ismob(D))
		D.pixel_y = src.passenger_offset_y
		D.pixel_x = src.passenger_offset_x

/obj/vehicle/train/cargo/engine/sportscar/New()
	..()
	update_dir_sportscar_overlays()

/obj/vehicle/train/cargo/engine/sportscar/Move()
	..()
	update_dir_sportscar_overlays()

/obj/vehicle/train/cargo/engine/sportscar/verb/honk()
	set name = "Honk horn"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		usr << "Turn on the engine."
		return

	honk_horn()
	usr << "You honk the horn. Hmm...must be broken."

/obj/vehicle/train/cargo/engine/sportscar/proc/honk_horn()
	playsound(src, 'sound/items/bikehorn.ogg',40,1)

/obj/vehicle/train/cargo/engine/sportscar/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump things away when hit
	if(istype(A, /mob/living))
		var/mob/living/M = A
		var/mob/living/D = load
		visible_message("\red [src] knocks over [M]!")
		M.apply_effects(5, 5)				//knock people down if you hit them
		M.apply_damages(70 / move_delay)	// and do damage according to how fast the car is going
		if(istype(load, /mob/living/carbon/human))
			D << "\red You hit [M]!"
			msg_admin_attack("[D.name] ([D.ckey]) hit [M.name] ([M.ckey]) with [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

	else if(istype(A, /obj/structure/table/glasstable))
		var/obj/structure/table/glasstable/G = A
		G.shatter()
		src.take_damage(1)  //crashing the car into things repeatedly is generally a bad idea

	else if(istype(A, /obj/structure/table/woodentable))
		var/obj/structure/table/woodentable/T = A
		if(istype(T, /obj/structure/table/rack))
			return
		T.destroy()
		src.take_damage(1)

	else if(istype(A, /obj/structure/window/))
		var/obj/structure/window/W = A
		load << "\red You drive [src] straight through the [W]!"
		W.shatter()
		src.take_damage(5)

	else if(istype(A, /obj/machinery/door/window/))
		var/obj/machinery/door/window/W = A
		W.take_damage(80)
		src.take_damage(5)

	else if(istype(A, /obj/structure))
		if(istype(A, /obj/structure/barricade/wooden))
			var/obj/structure/table/T = A
			load << "\red You crash [src] into the [A]!"
			T.destroy()
			src.take_damage(1)
			return
		load << "\red You crash [src] into the [A]!"
		src.take_damage(10)

/obj/vehicle/train/cargo/engine/sportscar/proc/take_damage(damage)
	src.health -= damage
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	if (src.health > 0 && src.health <= 15)
		load << "\red You've done some serious damage, [src] likely won't survive another crash."
	spawn(1) healthcheck()
	return 1

/obj/vehicle/train/cargo/engine/sportscar/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !user.canmove))
		return
	if(istype(C,/obj/vehicle/train))
		return
	if(ismob(C))
		var/utype = alert("Which seat do you want them to take?",,"Driver's", "Shotgun")
		switch(utype)
			if("Driver's")
				load(C)
				update_dir_sportscar_overlays()
			if("Shotgun")
				load_passenger(C)
				update_dir_sportscar_overlays()
	else
		if(!load(C))
			user << "\red You were unable to load [C] on [src]."

/obj/vehicle/train/cargo/engine/sportscar/attack_hand(mob/living/user as mob)
	if(user.stat || user.restrained() || !Adjacent(user))
		return 0
	src.add_fingerprint(user)
	if(user != load && (user in src))
		user.forceMove(loc)			//for handling players stuck in src

	else if(!load && passenger && passenger != user) //what happens when there is already a passenger in the car
		var/utype = alert("What would you like to do?",,"Enter driver's seat", "Remove passenger")
		switch(utype)
			if("Enter driver's seat")
				load(user)
				update_dir_sportscar_overlays()
			if("Remove passenger")
				if(user.canmove && (user.last_special <= world.time))
					user.next_move = world.time + 100
					user.last_special = world.time + 100

					user << "\red You attempt to pull [passenger] out of the vehicle. (This will take around 5 seconds and you need to stand still)"
					for(var/mob/O in viewers(user))
						O.show_message( "\red <B>[user] attempts to pull [passenger] out of the vehicle!</B>", 1)

					spawn(0)
						if(do_after(user, 20))
							if(user.restrained() || user.buckled)
								return
							for(var/mob/O in viewers(user))
								O.show_message("\red <B>[user] is struggling to remove [passenger]'s seatbelt!</B>", 1)
						if(do_after(user, 50))
							for(var/mob/O in viewers(user))
								O.show_message("\red <B>[user] pulls [passenger] out of their seat!</B>", 1)
							user << "\blue You successfully remove [passenger] from the vehicle."
							unload_passenger(passenger)
							update_dir_sportscar_overlays()
							return
				else return

	else if(load && !passenger && load != user) //what happens when there is already a driver in the car
		var/utype = alert("What would you like to do?",,"Enter passenger's seat", "Remove driver")
		switch(utype)
			if("Enter passenger's seat")
				load_passenger(user)
				update_dir_sportscar_overlays()
			if("Remove driver")
				if(user.canmove && (user.last_special <= world.time))
					user.next_move = world.time + 100
					user.last_special = world.time + 100

					user << "\red You attempt to pull [load] out of the vehicle. (This will take around 5 seconds and you need to stand still)"
					for(var/mob/O in viewers(user))
						O.show_message( "\red <B>[user] attempts to pull [load] out of the vehicle!</B>", 1)
					spawn(0)
						if(do_after(user, 20))
							if(user.restrained() || user.buckled)
								return
							for(var/mob/O in viewers(user))
								O.show_message("\red <B>[user] is struggling to remove [load]'s seatbelt!</B>", 1)
						if(do_after(user, 50))
							for(var/mob/O in viewers(user))
								O.show_message("\red <B>[user] pulls [load] out of their seat!</B>", 1)
							user << "\blue You successfully remove [load] from the vehicle."
							unload(load)
							update_dir_sportscar_overlays()
							return
				else return

	else if(load == user)
		unload(user)		//else try get out of vehicle
		if(passenger)
			update_dir_sportscar_overlays()

	else if(passenger == user)
		unload_passenger(user)		//else try get out of vehicle
		update_dir_sportscar_overlays()

	else if(!load && !user.buckled && !passenger)
		var/utype = alert("How will you ride?",,"Drive", "Shotgun!")
		switch(utype)
			if("Drive")
				load(user)
				update_dir_sportscar_overlays()
			if("Shotgun!")
				load_passenger(user)				//else try climbing on board
				update_dir_sportscar_overlays()
	else
		return 0

/obj/vehicle/train/cargo/engine/motorcycle
	name = "motorcycle"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/vehicles/motorcycle.dmi'
	icon_state = "motorcycle_4dir"
	emagged = 0
	mob_offset_y = 6
	load_offset_x = 0
	health = 100
	charge_use = 0

/obj/vehicle/train/cargo/engine/motorcycle/proc/update_dir_motorcycle_overlays()
	overlays = null
	if(src.dir == NORTH||SOUTH)
		if(src.dir == NORTH)
			var/image/I = new(icon = 'icons/vehicles/motorcycle.dmi', icon_state = "motorcycle_overlay_n", layer = src.layer + 0.2) //over mobs
			overlays += I
		else if(src.dir == SOUTH)
			var/image/I = new(icon = 'icons/vehicles/motorcycle.dmi', icon_state = "motorcycle_overlay_s", layer = src.layer + 0.2) //over mobs
			overlays += I
	else
		var/image/I = new(icon = 'icons/vehicles/motorcycle.dmi', icon_state = "motorcycle_overlay_side", layer = src.layer + 0.2) //over mobs
		overlays += I

/obj/vehicle/train/cargo/engine/motorcycle/New()
	..()
	update_dir_motorcycle_overlays()

/obj/vehicle/train/cargo/engine/motorcycle/Move()
	..()
	update_dir_motorcycle_overlays()

/obj/vehicle/train/cargo/engine/motorcycle/handle_rotation()
	update_dir_motorcycle_overlays() //this goes first, because vehicle/handle_rotation() just returns
	..()


/obj/vehicle/train/cargo/engine/fourwheeler //make this hold passengers
	name = "fourwheeler"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/vehicles/4wheeler.dmi'
	icon_state = "fourwheel"
	emagged = 0
	mob_offset_y = 6
	load_offset_x = 0
	health = 200
	charge_use = 0

/obj/vehicle/train/cargo/engine/fourwheeler/proc/update_dir_fourwheel_overlays()
	overlays = null
	if(src.dir == NORTH||SOUTH)
		if(src.dir == NORTH)
			var/image/I = new(icon = 'icons/vehicles/4wheeler.dmi', icon_state = "4wheeler_north", layer = src.layer + 0.2) //over mobs
			overlays += I
		else if(src.dir == SOUTH)
			var/image/I = new(icon = 'icons/vehicles/4wheeler.dmi', icon_state = "4wheeler_south", layer = src.layer + 0.2) //over mobs
			overlays += I

/obj/vehicle/train/cargo/engine/fourwheeler/New()
	..()
	update_dir_fourwheel_overlays()

/obj/vehicle/train/cargo/engine/fourwheeler/Move()
	..()
	update_dir_fourwheel_overlays()

/obj/vehicle/train/cargo/engine/fourwheeler/handle_rotation()
	update_dir_fourwheel_overlays()
	..()