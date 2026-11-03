extends CharacterBody2D

@export_range(0.0, 1000) var move_speed : float = 500;
@export_range(100.0, 1000.0) var gravity : float = 800;

func _process(_delta: float) -> void:
	
	if(Input.is_action_just_pressed("interact")):
		UI.start_dialogue("test");
	
	pass;

func _physics_process(delta: float) -> void:
	#falling
	if not is_on_floor(): 
		velocity.y += gravity * delta;
	else: velocity.y = 0;
	
	#grounded movement only while dialogue not up
	var move_direction = Input.get_axis("move_left", "move_right");
	if UI.dialogue_balloon_visible: move_direction = 0;
	velocity.x = move_speed * move_direction;
	
	move_and_slide();
	pass;
