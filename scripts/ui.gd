extends CanvasLayer


var dialogue_balloon_visible : bool = false;
var journal_visible : bool = false;
var selecting_evidence : bool = false;


@onready var transition_animation = $TransitionAnimation


@onready var room_indicator_label: RichTextLabel = $RoomIndicator/RichTextLabel
@onready var room_indicator_animation: AnimationPlayer = $RoomIndicator/AnimationPlayer

@onready var journal: Control = $Journal


func start_dialogue(dialogue_filename : String) -> void:
	if dialogue_balloon_visible:
		push_warning("trying to start dialogue " + dialogue_filename + " while dialogue box is already up.");
		return;
	DialogueManager.show_dialogue_balloon_scene("res://scenes/dialogue_balloon/balloon.tscn", load("res://dialogue/" + dialogue_filename + ".dialogue"));
	dialogue_balloon_visible = true;
	pass;

func start_dialogue_at_label(dialogue_filename : String, label : String) -> void:
	if dialogue_balloon_visible:
		push_warning("trying to start dialogue " + dialogue_filename + " at label " + label + " while dialogue box is already up.");
		return;
	DialogueManager.show_dialogue_balloon_scene("res://scenes/dialogue_balloon/balloon.tscn", load("res://dialogue/" + dialogue_filename + ".dialogue"), label);
	dialogue_balloon_visible = true;

func start_dialogue_resource_at_label(resource : DialogueResource, label : String, caller : Node) -> void:
	DialogueManager.show_dialogue_balloon_scene("res://scenes/dialogue_balloon/balloon.tscn", resource, label, [caller]);
	dialogue_balloon_visible = true;

func cover_screen_transition() -> void:
	transition_animation.play("enter");
	await transition_animation.animation_finished;

func uncover_screen_transition() -> void:
	transition_animation.play("leave");
	await transition_animation.animation_finished;

func show_room_indicator(room_name : String) -> void:
	if room_indicator_animation.is_playing(): room_indicator_animation.stop();
	room_indicator_label.text = room_name;
	room_indicator_animation.play("show");
	pass;


func show_journal() -> void:
	journal.show();
	journal_visible = true;
	pass;

func hide_journal() -> void:
	journal.hide();
	journal_visible = false;
	pass;
