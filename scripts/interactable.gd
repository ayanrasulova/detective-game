class_name Interactable
extends Area2D

## The [DialogueResource] to use when starting dialogue.
@export var dialogue_resource: DialogueResource = null:
	set(value):
		dialogue_resource = value
		if dialogue_resource == null:
			dialogue_cue = ""
		notify_property_list_changed()
	get:
		return dialogue_resource

## The target cue to start dialogue from.
@export var dialogue_cue: String = ""

## If this interactable's dialogue will change the room, it'll go here
@export var room_transition : RoomPoint.RoomPoints = RoomPoint.RoomPoints.OutsideSpawn;

## If this interactable's dialogue has multiple rooms to change to, it'll reference this array
@export var room_transitions : Array[RoomPoint.RoomPoints] = [RoomPoint.RoomPoints.OutsideSpawn];

func interact() -> void:
	UI.start_dialogue_resource_at_label(dialogue_resource, dialogue_cue, self);

func go_to_room() -> void:
	GameManager.go_to_room(room_transition);

func go_to_room_index(index : int) -> void:
	GameManager.go_to_room(room_transitions[index]);
