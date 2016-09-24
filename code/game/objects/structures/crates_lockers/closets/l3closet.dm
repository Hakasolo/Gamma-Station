/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio"
	icon_closed = "bio"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/general
	icon_state = "bio_general"
	icon_closed = "bio_general"
	icon_opened = "bio_generalopen"

/obj/structure/closet/l3closet/general/New()
	..()
	new /obj/item/clothing/suit/bio_suit/new_hazmat/general(src)
	new /obj/item/clothing/head/bio_hood/new_hazmat/general(src)


/obj/structure/closet/l3closet/virology
	icon_state = "bio_virology"
	icon_closed = "bio_virology"
	icon_opened = "bio_virologyopen"

/obj/structure/closet/l3closet/virology/New()
	..()
	new /obj/item/clothing/suit/bio_suit/new_hazmat/virology(src)
	new /obj/item/clothing/head/bio_hood/new_hazmat/virology(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/oxygen(src)


/obj/structure/closet/l3closet/security
	icon_state = "bio_security"
	icon_closed = "bio_security"
	icon_opened = "bio_securityopen"

/obj/structure/closet/l3closet/security/New()
	..()
	new /obj/item/clothing/suit/bio_suit/new_hazmat/security(src)
	new /obj/item/clothing/head/bio_hood/new_hazmat/security(src)


/obj/structure/closet/l3closet/janitor
	icon_state = "bio_janitor"
	icon_closed = "bio_janitor"
	icon_opened = "bio_janitoropen"

/obj/structure/closet/l3closet/janitor/New()
	..()
	new /obj/item/clothing/suit/bio_suit/new_hazmat/janitor(src)
	new /obj/item/clothing/head/bio_hood/new_hazmat/janitor(src)


/obj/structure/closet/l3closet/scientist
	icon_state = "bio_scientist"
	icon_closed = "bio_scientist"
	icon_opened = "bio_scientistopen"

/obj/structure/closet/l3closet/scientist/New()
	..()
	new /obj/item/clothing/suit/bio_suit/new_hazmat/scientist(src)
	new /obj/item/clothing/head/bio_hood/new_hazmat/scientist(src)
