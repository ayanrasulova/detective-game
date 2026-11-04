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


func interact() -> void:
	UI.start_dialogue_resource_at_label(dialogue_resource, dialogue_cue);
