//rename to sportscar if you need
//mostly, my changes just update the C.pixel_ y and x on every iteration of the overlay update proc, since default vehicle code //only does that upon entering. Watch the weird formatting pastebin introduces.

/obj/vehicle/car/sportscar
	name = "sports car"
	desc = "A very luxurious vehicle."
	icon = 'icons/vehicles/sportscar.dmi'
	icon_state = "sportscar"

	bound_width = 64
	bound_height = 64

	fits_passenger = 1
	passenger_item_visible = 1
	load_item_visible = 1
	load_offset_x = 0

		//||pixel_y offset for mob overlay
	mob_offset_y = 7
	passenger_offset_y = 20

//-------------------------------------------
// Standard procs
//-------------------------------------------

/obj/vehicle/car/sportscar/New()
	..()
	update_dir_sportscar_overlays()

/obj/vehicle/car/sportscar/Move()
	..()
	update_dir_sportscar_overlays()

/obj/vehicle/car/sportscar/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !user.canmove))
		return
	if(istype(C,/obj/vehicle/train))
		return
	if(ismob(C))
			//||car is empty
		if(!load && !passenger)
			var/utype = alert("Which seat do you want them to take?",,"Driver's", "Shotgun")
			switch(utype)
				if("Driver's")
					load(C, "driver")
					update_dir_sportscar_overlays()
				if("Shotgun")
					load(C, "passenger")
					update_dir_sportscar_overlays()
			return
			//||passenger's seat is taken
		if(!load)
			load(C, "driver")
			update_dir_sportscar_overlays()
			return
			//||driver's seat is taken
		if(!passenger)
			load(C, "passenger")
			update_dir_sportscar_overlays()
			return
	else
		if(!load(C))
			user << "\red You were unable to load [C] on [src]."

/obj/vehicle/car/sportscar/attack_hand(mob/living/user as mob)
	if(user.stat || user.restrained() || !Adjacent(user))
		return 0
	if(user != load && (user in src)) //||for handling players stuck in src
		user.forceMove(loc)

	src.add_fingerprint(user)
		//||what happens when there is already a passenger in the car
	if(!load && passenger && passenger != user)
		var/utype = alert("What would you like to do?",,"Enter driver's seat", "Remove passenger", "Nothing")
		switch(utype)
			if("Enter driver's seat")
				load(user, "driver")
				update_dir_sportscar_overlays()
			if("Remove passenger")
				remove_occupant(user, passenger, "passenger")
			if("Nothing")
				return
		return
		//||what happens when there is already a driver in the car
	if(load && !passenger && load != user)
		var/utype = alert("What would you like to do?",,"Enter passenger's seat", "Remove driver", "Nothing")
		switch(utype)
			if("Enter passenger's seat")
				load(user, "passenger")
				update_dir_sportscar_overlays()
			if("Remove driver")
				remove_occupant(user, load, "driver")
			if("Nothing")
				return
		return
		//||what happens when there are two people in the car
	if(load && passenger && load != user && passenger != user)
		var/utype = alert("What would you like to do?",,"Remove driver", "Remove passenger", "Nothing")
		switch(utype)
			if("Remove driver")
				remove_occupant(user, load, "driver")
			if("Remove passenger")
				remove_occupant(user, passenger, "passenger")
			if("Nothing")
				return
		return
		//||user is already in the driver's seat; click vehicle to exit
	if(load == user)
		unload(user, "driver")
		if(passenger)
			update_dir_sportscar_overlays()
		return
		//||user is already in the passenger's seat; click vehicle to exit
	if(passenger == user)
		unload(user, "passenger")
		update_dir_sportscar_overlays()
		return
		//||car is empty
	if(!load && !user.buckled && !passenger)
		var/utype = alert("How will you ride?",,"Drive", "Shotgun!", "I will not")
		switch(utype)
			if("Drive")
				load(user, "driver")
				update_dir_sportscar_overlays()
			if("Shotgun!")
				load(user, "passenger")
				update_dir_sportscar_overlays()
			if("I will not")
				return
		return

	return 0

/obj/vehicle/car/sportscar/proc/remove_occupant(user, occupant, who)
	var/mob/living/M	= user
	if(M.canmove && (M.last_special <= world.time))
		M.changeNext_move(CLICK_CD_BREAKOUT)
		M.last_special = world.time + CLICK_CD_BREAKOUT

		M << "\red You attempt to pull [occupant] out of the vehicle. (This will take around 5 seconds and you need to stand still)"
		for(var/mob/O in viewers(M))
			O.show_message( "\red <B>[M] attempts to pull [occupant] out of the vehicle!</B>", 1)

		if(do_after(user, 50, 10))
			if(M.restrained() || M.buckled)
				return
			for(var/mob/O in viewers(M))
				O.show_message("\red <B>[M] pulls [occupant] out of their seat!</B>", 1)
			user << "\blue You successfully remove [occupant] from the vehicle."
			switch (who)
				if("driver")
					unload(occupant, who)
				if("passenger")
					unload(occupant, who)
			update_dir_sportscar_overlays()
			return
		else
			user << "\blue You fail to remove [occupant] from the vehicle."
			return

/obj/vehicle/car/sportscar/proc/update_dir_sportscar_overlays()
	var/atom/movable/C = src.load
	var/atom/movable/D = src.passenger
	src.overlays = null
	if(src.dir == NORTH||SOUTH||WEST)
		if(src.dir == NORTH)	//|| place car sprite over mobs
			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_north", layer = src.layer + 0.2)
			src.overlays += I

			src.mob_offset_x = 2
			src.mob_offset_y = 20
				//||move the driver back to the original layer
			if(passenger && load)
				C.layer = default_layer
			src.passenger_offset_x = 22
			src.passenger_offset_y = 20

		else if(src.dir == SOUTH)

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_south", layer = src.layer + 0.2)
			overlays += I
				//||move the driver back to the original layer
			if(passenger && load)
				C.layer = default_layer
			src.mob_offset_x = 20
			src.mob_offset_y = 27

			src.passenger_offset_x = 3
			src.passenger_offset_y = 27

		else if(src.dir == WEST)

			src.mob_offset_x = 34
			src.mob_offset_y = 10
				//||move the driver the one layer above the passenger, so he is displayed properly when they overlap
			if(passenger && load)
				C.layer = default_layer + 0.1
			src.passenger_offset_x = 34
			src.passenger_offset_y = 23

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_west", layer = src.layer + 0.2)
			src.overlays += I
			if(passenger && !load)
				var/image/S = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_west_passenger", layer = src.layer + 0.2)
				src.overlays += S

		else if(src.dir == EAST)

			var/image/I = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_east_passenger", layer = src.layer + 0.2)

			src.passenger_offset_x = 20
			src.passenger_offset_y = 10
				//||move the driver back to the original layer
			if(passenger && load)
				C.layer = default_layer
			src.mob_offset_x = 20
			src.mob_offset_y = 23

			src.overlays += I

			if(!passenger )
				var/image/S = new(icon = 'icons/vehicles/sportscar.dmi', icon_state = "sportscar_east", layer = src.layer + 0.2)
				src.overlays += S

	if(ismob(C))
		C.pixel_y = src.mob_offset_y
		C.pixel_x = src.mob_offset_x
	if(ismob(D))
		D.pixel_y = src.passenger_offset_y
		D.pixel_x = src.passenger_offset_x