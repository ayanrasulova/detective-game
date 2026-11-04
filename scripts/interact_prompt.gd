class_name InteractPrompt
extends Control

@export var label_offset : Vector2;

var target : Node2D = null;

func set_target(t: Node2D) -> void:
	target = t;
	visible = t != null;

func _process(_delta: float) -> void:
	if target == null or not is_instance_valid(target):
		visible = false;
		return;
	
	global_position = target.global_position + label_offset
