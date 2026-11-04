extends CharacterBody2D

@export_category("Movement")
@export_range(0.0, 1000) var move_speed : float = 500;
@export_range(100.0, 1000.0) var gravity : float = 800;

@export_category("Interaction")
@export_range(0.0, 100) var interaction_box_distance : float = 20;

@onready var sprite_2d: Sprite2D = $Sprite2D;
@onready var interaction_area: Area2D = $InteractionBox
@onready var interaction_collision_shape: CollisionShape2D = $InteractionBox/CollisionShape2D


var nearby_interactables : Array[Interactable] = [];

func _ready() -> void:
	#catch when the player's interaction box overlaps/leaves range
	#of interactables in the world
	interaction_area.area_entered.connect(func(area : Area2D):
		if area is Interactable: nearby_interactables.append(area)
		print(nearby_interactables.size()));
	interaction_area.area_exited.connect(func(area : Area2D):
		if area is Interactable: nearby_interactables.erase(area)
		print(nearby_interactables.size()));
	pass;


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var target = _get_nearest_interactable();
		print(target);
		if target:
			target.interact();
			get_viewport().set_input_as_handled();
	pass;

func _get_nearest_interactable() -> Interactable:
	var nearest : Interactable = null;
	var closest_distance : float = INF;
	for interactable in nearby_interactables:
		var distance := global_position.distance_squared_to(interactable.global_position);
		if distance < closest_distance: 
			nearest = interactable;
			closest_distance = distance;
	return nearest;


func _physics_process(delta: float) -> void:
	#falling
	if not is_on_floor(): 
		velocity.y += gravity * delta;
	else: velocity.y = 0;
	
	#grounded movement only while dialogue not up
	var move_direction = Input.get_axis("move_left", "move_right");
	if UI.dialogue_balloon_visible: move_direction = 0;
	velocity.x = move_speed * move_direction;
	
	#flip sprite
	if move_direction < 0: sprite_2d.flip_h = false;
	elif move_direction > 0: sprite_2d.flip_h = true;
	
	#move interaction box based on player orientation
	var interaction_collision_target : float = interaction_box_distance if sprite_2d.flip_h else -interaction_box_distance;
	interaction_collision_shape.position.x = lerpf(interaction_collision_shape.position.x, interaction_collision_target, delta * 10);
	
	#see if there's any interactables nearby
	#if there are, we need to let the interactprompt know
	#there's only one interactprompt in the game so singleton usage here is OKAY don't kill me
	var prompt : InteractPrompt = get_tree().get_first_node_in_group("InteractPrompt");
	var nearest : Interactable = _get_nearest_interactable();
	prompt.set_target(nearest); #nearest might be null but das okay
	
	move_and_slide();
	pass;
