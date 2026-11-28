extends Node
var player : Player;


@export var all_items : Dictionary[GameTypes.Items, Item];
@export var collected_items : Dictionary[GameTypes.Items, bool];

@export var collected_evidence : Dictionary[Evidence.Enum, bool];
@export var all_evidence: Dictionary[Evidence.Enum, Evidence];

#for city ambiance sound
@onready var city_ambiance_bus: int = AudioServer.get_bus_index("City Ambiance")
@onready var city_ambiance_lowpass: AudioEffectLowPassFilter = AudioServer.get_bus_effect(city_ambiance_bus, 0)

var room_locations : Dictionary[RoomPoint.RoomPoints, Vector2] = {};
var last_room_point : RoomPoint.RoomPoints = RoomPoint.RoomPoints.OutsideSpawn;


signal evidence_collected;
signal journal_opened;
signal journal_closed;
signal new_evidence_viewed;
var selecting_evidence : bool = false;

func viewed_new_evidence() -> void:
	new_evidence_viewed.emit();

func _ready() -> void:
	await get_tree().root.ready;
	#get a ref to the player
	player = get_tree().get_first_node_in_group("Player") as Player;
	
	#store a dictionary of room points that the player can teleport to
	var room_points = get_tree().get_nodes_in_group("RoomPoint");
	for point in room_points:
		var rp := point as RoomPoint;
		room_locations[rp.location_index] = rp.global_position;

func collect_item(id : GameTypes.Items) -> void:
	if collected_items.has(id):
		return;
	collected_items[id] = true;
	evidence_collected.emit();

func has_item(id : GameTypes.Items) -> bool:
	return collected_items.has(id);

func get_collected_items() -> Array[Item]:
	var result : Array[Item] = [];
	for id in collected_items:
		result.append(all_items[id]);
	return result;

func make_item_used_up(id : GameTypes.Items) -> void:
	if not collected_items.has(id): return;
	else: all_items.get(id).used_up = true;

func any_unviewed_new_items() -> bool:
	return not get_collected_items().filter(func(i : Item): return i.new).is_empty();


func collect_evidence(id : Evidence.Enum) -> void:
	if collected_evidence.has(id):
		return;
	collected_evidence[id] = true;
	evidence_collected.emit();

func has_evidence(id : Evidence.Enum) -> bool:
	return collected_evidence.has(id);

func get_collected_evidence() -> Array[Evidence]:
	var result : Array[Evidence] = [];
	for id in collected_evidence:
		result.append(all_evidence[id]);
	return result;

func any_unviewed_new_suspect_evidence() -> bool:
	return not get_collected_evidence().filter(func(e : Evidence): return e.associated_suspect != GameTypes.Suspects.None and e.new).is_empty();

func any_unviewed_new_misc_evidence() -> bool:
	return not get_collected_evidence().filter(func(e : Evidence): return e.associated_suspect == GameTypes.Suspects.None and e.new).is_empty();


func teleport_player_to_room_point(point : RoomPoint.RoomPoints) -> void:
	player.global_position = room_locations[point];

func go_to_room(point : RoomPoint.RoomPoints) -> void:
	if not room_locations.has(point):
		error_string("No room location for point " + RoomPoint.RoomPoints.find_key(point));
		return;
	player.can_move = false;
	await UI.cover_screen_transition();
	player.global_position = room_locations[point];
	player.can_move = true;
	UI.uncover_screen_transition();
	
	#see if there's a room name to display
	if RoomPoint.ROOM_NAMES_BY_POINT.has(point):
		UI.show_room_indicator(RoomPoint.ROOM_NAMES_BY_POINT[point]);
	
	#when we go inside from outside or outside from inside, we change the lowpass on the city ambiance sound
	if (last_room_point == RoomPoint.RoomPoints.OutsideSpawn or last_room_point == RoomPoint.RoomPoints.OutsideDoor and
		point == RoomPoint.RoomPoints.FirstFloorCenter):
		muffle_city_ambiance(true);
	elif (last_room_point != RoomPoint.RoomPoints.OutsideSpawn or last_room_point != RoomPoint.RoomPoints.OutsideDoor and 
		point == RoomPoint.RoomPoints.OutsideDoor):
		muffle_city_ambiance(false);
	
	
	last_room_point = point;

func muffle_city_ambiance(muffled : bool) -> void:
	var target_hz: float = 600.0 if muffled else 20500.0
	var tween := create_tween()
	
	if muffled:
		AudioServer.set_bus_effect_enabled(city_ambiance_bus, 0, true)

	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(city_ambiance_lowpass, "cutoff_hz", target_hz, 1)
	
	if not muffled:
		tween.tween_callback(AudioServer.set_bus_effect_enabled.bind(city_ambiance_bus, 0, false))

func browse_evidence() -> void:
	player.can_move = false;
	selecting_evidence = false;
	journal_opened.emit();
	UI.show_journal();

func finish_browsing_evidence() -> void:
	player.can_move = true;
	journal_closed.emit();
	UI.hide_journal();

	
func select_evidence() -> void:
	selecting_evidence = true;
	pass;
