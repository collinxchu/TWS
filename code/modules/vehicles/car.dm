/obj/vehicle/car
	name = "car"
	dir = 4

	health = 150
	maxhealth = 150
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
	powered = 1
	locked = 0
	charge_use = 0
	bound_width = 64
	bound_height = 64
	movable = 0

	var/obj/item/weapon/key/car/key

/obj/item/weapon/key/car
	name = "key"
	desc = "A keyring with a small steel key, and a yellow fob reading \"Choo Choo!\". DON'T ASK."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = 1

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/car/New()
	..()
	cell = new /obj/item/weapon/cell/high(src)
	key = new(src)
	turn_off()	//||so engine verbs are correctly set

/obj/vehicle/car/Move(var/turf/destination)
	if(on && cell.charge < charge_use)
		turn_off()
		if(load)
			load << "The engine briefly whines, then drones to a stop."
	if(on && health <= 10)
		turn_off()
		if(load)
			load << "The engine makes a loud clanking noise before going quiet."
	if(!on)
		return 0

		//||space check ~no flying space cars sorry
	if(on && istype(destination, /turf/space))
		return 0

		//||move
	if(..())
		return 1
	else
		return 0

/obj/vehicle/car/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/key/car))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/car/verb/remove_key
		return
	..()

//-------------------------------------------
// Car procs
//-------------------------------------------

/obj/vehicle/car/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//||bump things away when hit
	if(istype(A, /mob/living))
		var/mob/living/M = A
		var/mob/living/D = load
		visible_message("\red [src] knocks over [M]!")
		M.apply_effects(5, 5)				//||knock people down if you hit them
		M.apply_damages(70 / move_delay)	//||and do damage according to how fast the car is going
		if(istype(load, /mob/living/carbon/human))
			D << "\red You hit [M]!"
			msg_admin_attack("[D.name] ([D.ckey]) hit [M.name] ([M.ckey]) with [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		return

	if(istype(A, /obj/structure))
		if(istype(A, /obj/structure/barricade/wooden))
			var/obj/structure/table/T = A
			load << "\red You crash [src] into the [A]!"
			playsound(src.loc, 'sound/effects/woodcrash.ogg', 80, 0, 11025)
			T.destroy()
			src.take_damage(1)
			return

		if(istype(A, /obj/structure/window/))
			var/obj/structure/window/W = A
			load << "\red You drive [src] into through the [W]!"
			W.hit(14)
			src.take_damage(2)
			return

		if(istype(A, /obj/structure/table/glasstable))
			var/obj/structure/table/glasstable/G = A
			G.shatter()
			src.take_damage(1)  //||crashing the car into things repeatedly is generally a bad idea
			return

		if(istype(A, /obj/structure/table/woodentable))
			var/obj/structure/table/woodentable/T = A
			if(istype(T, /obj/structure/table/rack))
				return
			playsound(src.loc, 'sound/effects/woodcrash.ogg', 80, 0, 11025)
			T.destroy()
			src.take_damage(1)
			return

		load << "\red You crash [src] into the [A]!"
		src.take_damage(1)
		return

	if(istype(A, /obj/machinery/door/window/))
		var/obj/machinery/door/window/W = A
		W.take_damage(80)
		src.take_damage(5)
		return

/obj/vehicle/car/proc/take_damage(damage)
	src.health -= damage
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1

/obj/vehicle/car/sportscar/turn_on()
	if(!key)
		return
	if(health <= 10)
		return
	else
		..()

		verbs -= /obj/vehicle/car/verb/stop_engine
		verbs -= /obj/vehicle/car/verb/start_engine

		if(on)
			verbs += /obj/vehicle/car/verb/stop_engine
		else
			verbs += /obj/vehicle/car/verb/start_engine

/obj/vehicle/car/sportscar/turn_off()
	..()

	verbs -= /obj/vehicle/car/verb/stop_engine
	verbs -= /obj/vehicle/car/verb/start_engine

	if(!on)
		verbs += /obj/vehicle/car/verb/start_engine
	else
		verbs += /obj/vehicle/car/verb/stop_engine

/obj/vehicle/car/proc/honk_horn()
	playsound(src, 'sound/items/bikehorn.ogg',40,1)

//-------------------------------------------
// Interaction procs
//-------------------------------------------

/obj/vehicle/car/relaymove(mob/user, direction)
	if(user != load)
		return 0

	if(Move(get_step(src, direction)))
		return 1
	return 0

/obj/vehicle/car/examine(mob/user)
	if(!..(user, 1))
		return

	if(!istype(usr, /mob/living/carbon/human))
		return

	user << "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition."
	user << "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"
	user << "Car integrity is at [health? round(100.0*health/maxhealth, 0.01) : 0]%"

/obj/vehicle/car/verb/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(on)
		usr << "The engine is already running."
		return

	turn_on()
	if (on)
		usr << "You start [src]'s engine."
	else
		if(cell.charge < charge_use)
			usr << "[src] is out of power."
		else
			usr << "[src]'s engine won't start."

/obj/vehicle/car/verb/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		usr << "The engine is already stopped."
		return

	turn_off()
	if (!on)
		usr << "You stop [src]'s engine."

/obj/vehicle/car/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.get_active_hand())
		usr.put_in_hands(key)
	key = null

	verbs -= /obj/vehicle/car/verb/remove_key

/obj/vehicle/car/verb/honk()
	set name = "Honk horn"
	set category = "Vehicle"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		usr << "Turn on the engine."
		return

	honk_horn()
	usr << "You honk the horn. Hmm...must be broken."

//-------------------------------------------
// Loading/unloading procs
//-------------------------------------------

/obj/vehicle/car/load(var/atom/movable/C, who)
	if(!istype(C, /mob/living/carbon/human))
		return 0
	switch(who)
		if("driver")
			if(load) return 0
		if("passenger")
			if(passenger) return 0

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = 1

	switch(who)
		if("driver")
			load = C
			if(load_item_visible)
				C.pixel_x += load_offset_x
				if(ismob(C))
					C.pixel_y += mob_offset_y
				else
					C.pixel_y += load_offset_y
				C.layer = layer + 0.1		//so it sits above the vehicle
				default_layer = C.layer
		if("passenger")
			passenger = C
			if(passenger_item_visible)
				C.pixel_x += passenger_offset_x
				if(ismob(C))
					C.pixel_y += mob_offset_y
				else
					C.pixel_y += passenger_offset_y
				C.layer = layer + 0.1		//so it sits above the vehicle

	if(ismob(C))
		var/mob/M = C
		M.buckled = src
		switch(who)
			if("driver")
				M.pixel_y = src.load_offset_y
			if("passenger")
				M.pixel_y = src.passenger_offset_y
		M.update_canmove()

	return 1

/obj/vehicle/car/unload(var/mob/user, who, var/direction)
	switch(who)
		if("driver")
			if(!load) return
		if("passenger")
			if(!passenger) return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			switch(who)
				if("driver")
					if(new_dir && load.Adjacent(new_dir))
						options += new_dir
				if("passenger")
					if(new_dir && passenger.Adjacent(new_dir))
						options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	switch(who)
		if("driver")
			load.forceMove(dest)
			load.set_dir(get_dir(loc, dest))
			load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
			load.pixel_x = initial(load.pixel_x)
			load.pixel_y = initial(load.pixel_y)
			load.layer = initial(load.layer)

			if(ismob(load))
				var/mob/M = load
				M.buckled = null
				M.anchored = initial(M.anchored)
				M.update_canmove()

			load = null
		if("passenger")
			passenger.forceMove(dest)
			passenger.set_dir(get_dir(loc, dest))
			passenger.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
			passenger.pixel_x = initial(passenger.pixel_x)
			passenger.pixel_y = initial(passenger.pixel_y)
			passenger.layer = initial(passenger.layer)

			if(ismob(passenger))
				var/mob/M = passenger
				M.buckled = null
				M.anchored = initial(M.anchored)
				M.update_canmove()

			passenger = null

	return 1