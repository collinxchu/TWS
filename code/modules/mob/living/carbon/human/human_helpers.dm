///checkeyeprot()
///Returns a number between -1 to 2
/mob/living/carbon/human/check_eye_prot()
	var/number = ..()
	if(!species.has_organ["eyes"]) //No eyes, can't hurt them.
		return 2
	if(internal_organs_by_name["eyes"]) // Eyes are fucked, not a 'weak point'.
		var/obj/item/organ/I = internal_organs_by_name["eyes"]
		if(I.status & ORGAN_CUT_AWAY)
			return 2
	if(istype(src.head, /obj/item/clothing/head))			//are they wearing something on their head
		var/obj/item/clothing/head/HFP = src.head			//if yes gets the flash protection value from that item
		number += HFP.flash_protect
	if(istype(src.glasses, /obj/item/clothing/glasses))		//glasses
		var/obj/item/clothing/glasses/GFP = src.glasses
		number += GFP.flash_protect
	if(istype(src.wear_mask, /obj/item/clothing/mask))		//mask
		var/obj/item/clothing/mask/MFP = src.wear_mask
		number += MFP.flash_protect
	return number

//check for ear protection
/mob/living/carbon/human/check_ear_prot()
	if(r_ear)
		if(r_ear.flags & EARBANGPROTECT)
			return 1
	if(l_ear)
		if(l_ear.flags & EARBANGPROTECT)
			return 1
	if(head)
		if(head.flags & HEADBANGPROTECT)
			return 1