class_name TagSystem

## Tag-based entity classification system
## Used for ability targeting, elemental reactions, and synergy checks

enum Tag {
	FIRE,
	WATER,
	WOOD,
	METAL,
	EARTH,
	LIGHTNING,
	WIND,
	ICE,
	FORMATION,
	ARTIFACT,
	SWORD,
	TIME,
	SPACE,
	SUMMON,
	BOSS,
	ELITE,
	DOT,
	AURA,
	DEBUFF,
	BUFF,
	PROJECTILE,
	MELEE,
	AREA,
}

static var TAG_NAMES: Dictionary = {
	Tag.FIRE: "fire",
	Tag.WATER: "water",
	Tag.WOOD: "wood",
	Tag.METAL: "metal",
	Tag.EARTH: "earth",
	Tag.LIGHTNING: "lightning",
	Tag.WIND: "wind",
	Tag.ICE: "ice",
	Tag.FORMATION: "formation",
	Tag.ARTIFACT: "artifact",
	Tag.SWORD: "sword",
	Tag.TIME: "time",
	Tag.SPACE: "space",
	Tag.SUMMON: "summon",
	Tag.BOSS: "boss",
	Tag.ELITE: "elite",
	Tag.DOT: "dot",
	Tag.AURA: "aura",
	Tag.DEBUFF: "debuff",
	Tag.BUFF: "buff",
	Tag.PROJECTILE: "projectile",
	Tag.MELEE: "melee",
	Tag.AREA: "area",
}


static func to_string(tag: Tag) -> String:
	return TAG_NAMES.get(tag, "unknown")


static func from_string(tag_name: String) -> Tag:
	for key: Tag in TAG_NAMES:
		if TAG_NAMES[key] == tag_name:
			return key
	return Tag.FIRE


static func has_tag(tags: Array[Tag], tag: Tag) -> bool:
	return tag in tags


static func has_any(tags: Array[Tag], check_tags: Array[Tag]) -> bool:
	for t: Tag in check_tags:
		if t in tags:
			return true
	return false
