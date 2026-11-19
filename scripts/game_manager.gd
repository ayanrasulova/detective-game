extends Node
var player : Player;

var room_locations : Dictionary[RoomPoint.RoomPoints, Vector2] = {};

func _ready() -> void:
	await get_tree().root.ready;
	#get a ref to the player
	player = get_tree().get_first_node_in_group("Player") as Player;
	
	#store a dictionary of room points that the player can teleport to
	var room_points = get_tree().get_nodes_in_group("RoomPoint");
	print(room_points.size());
	for point in room_points:
		print(point);
		var rp := point as RoomPoint;
		print(rp.location_index)
		room_locations[rp.location_index] = rp.global_position;


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
