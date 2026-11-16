class_name InteractPrompt
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var label_offset : Vector2;

var target : Node2D = null;

func set_target(t: Node2D) -> void:
	if(t != null and t != target): animation_player.play("reveal");
	target = t;
	if(not visible and t != null): animation_player.play("reveal");
	visible = t != null;
	

func _process(_delta: float) -> void:
	if target == null or not is_instance_valid(target) or UI.dialogue_balloon_visible:
		visible = false;
		return;
	elif target != null and is_instance_valid(target) and UI.dialogue_balloon_visible:
		visible = true;
	
	global_position = target.global_position + label_offset
