extends Control

const JOURNAL_EVIDENCE_ITEM = preload("uid://cm1itas2dmo8k")
const JOURNAL_ITEM = preload("uid://cir5h4q722nww")


enum BumperButtonPrompts {
		Left,
		Right,
		Both
}

enum Page {
	Suspects,
	SuspectNotes,
	Items,
	Misc
}

var current_page : Page = Page.Suspects;

@onready var lb_prompt: TextureRect = $LBPrompt
@onready var lb_exclamation: RichTextLabel = $LBPrompt/Notification
@onready var rb_prompt: TextureRect = $RBPrompt
@onready var rb_exclamation: RichTextLabel = $RBPrompt/Notification


@onready var misc: Control = $TextureRect/Misc
@onready var misc_container: VBoxContainer = $TextureRect/Misc/VBoxContainer
@onready var misc_container_2: VBoxContainer = $TextureRect/Misc/VBoxContainer2



@onready var items: Control = $TextureRect/Items
@onready var items_container: GridContainer = $TextureRect/Items/ItemsContainer;
@onready var info: RichTextLabel = $TextureRect/Items/Info


@onready var suspects: Control = $TextureRect/Suspects
var viewing_suspect_notes : bool = false;
var currently_viewed_portrait : JournalPortrait;
@onready var portraits: Control = $TextureRect/Suspects/Portraits
@onready var make_select_text: RichTextLabel = $TextureRect/Suspects/Notes/SelectText
@onready var no_evidence_text: RichTextLabel = $TextureRect/Suspects/Notes/NoEvidenceText
@onready var suspect_name_text: RichTextLabel = $TextureRect/Suspects/Notes/SuspectNameText
@onready var exit_button_prompt: TextureRect = $TextureRect/Suspects/Notes/ExitPrompt
@onready var evidence_list: VBoxContainer = $TextureRect/Suspects/Notes/EvidenceList



func _ready() -> void:
	viewing_suspect_notes = false;
	hide();
	visibility_changed.connect(_on_visibility_changed);

func _on_visibility_changed() -> void:
	if not visible:
		current_page = Page.Suspects;
		items.hide();
		misc.hide();
		suspects.show();
	if visible:
		#when the journal opens
		#populate the items grid
		for item in items_container.get_children():
			item.queue_free();
		await get_tree().process_frame;

		for item : Item in GameManager.get_collected_items():
			var spawn : JournalItem = JOURNAL_ITEM.instantiate();
			spawn.associated_item = item;
			spawn.info_reference = info;
			items_container.add_child(spawn);
			spawn.texture = item.texture;
			if not item.new:
				spawn.exclamation.hide();
			if item.used_up: spawn.check.show();
			else: spawn.check.hide();
		reset_to_suspects_page();

func _unhandled_input(event: InputEvent) -> void:
	if not visible and not UI.dialogue_balloon_visible:
		if event.is_action_pressed("ui_cancel"):
			GameManager.browse_evidence();
			return;
	
	match current_page:
		Page.Suspects:
			if event.is_action_pressed("ui_cancel"):
				#closing journal
				GameManager.finish_browsing_evidence();
				pass;
			elif event.is_action_pressed("ui_accept"):
				#selecting a suspect and going into the evidence browsing
				viewing_suspect_notes = true;
				var selected_portrait : JournalPortrait = get_viewport().gui_get_focus_owner() as JournalPortrait;
				if not selected_portrait:
					push_error("something went wrong");
					return;
				var selected_suspect : GameTypes.Suspects = selected_portrait.suspect;
				populate_suspect_notes_list(selected_suspect);
				currently_viewed_portrait = selected_portrait;
			elif event.is_action_pressed("ui_page_down"):
				#moving to items page
				suspects.hide();
				items.show();
				reset_to_items_page();
			pass;
		Page.SuspectNotes:
			if event.is_action_pressed("ui_cancel"):
				#leaving suspect evidence selection
				exit_button_prompt.hide();
				suspect_name_text.hide();
				make_select_text.show();
				for child in evidence_list.get_children():
					child.queue_free();
				await get_tree().process_frame;
				set_portraits_focusable();
				currently_viewed_portrait.grab_focus();
				currently_viewed_portrait.selected = false;
				current_page = Page.Suspects;
			elif event.is_action_pressed("ui_page_down"):
				#moving to items page
				suspects.hide();
				items.show();
				reset_to_items_page();
			pass;
		Page.Items:
			if event.is_action_pressed("ui_page_up"):
				#move to suspects page
				items.hide();
				suspects.show();
				reset_to_suspects_page();
			elif event.is_action_pressed("ui_page_down"):
				#move to misc page
				items.hide();
				misc.show();
				reset_to_misc_page();
			elif event.is_action_pressed("ui_cancel"):
				#close the journal
				GameManager.finish_browsing_evidence();
			pass;
		Page.Misc:
			if event.is_action_pressed("ui_page_up"):
				#move to items page
				misc.hide();
				items.show();
				reset_to_items_page();
			if event.is_action_pressed("ui_cancel"):
				#close the journal
				GameManager.finish_browsing_evidence();
			pass;


func reset_to_misc_page() -> void:
	current_page = Page.Misc;
	set_bumper_button_prompts(BumperButtonPrompts.Left);
	rb_exclamation.hide();
	if GameManager.any_unviewed_new_items() or GameManager.any_unviewed_new_suspect_evidence(): lb_exclamation.show();
	else: lb_exclamation.hide();
	for child in misc_container.get_children():
		child.queue_free();
	for child in misc_container_2.get_children():
		child.queue_free();
	await get_tree().process_frame;

	var misc_evidence : Array[Evidence] = GameManager.get_collected_evidence().filter(func(e : Evidence): return e.associated_suspect == GameTypes.Suspects.None);
	for ev in misc_evidence:
		var spawn : JournalEvidenceItem = JOURNAL_EVIDENCE_ITEM.instantiate();
		spawn.associated_evidence = ev;
		misc_container.add_child(spawn);
		spawn.text = ev.evidence_string_description;
		if not ev.new: spawn.exclamation.hide();

	if misc_container.get_child_count() > 0:
		misc_container.get_child(0).grab_focus();
	
func reset_to_suspects_page() -> void:
	current_page = Page.Suspects;
	for child in portraits.get_children():
		child.selected = false;
	for child in evidence_list.get_children():
		child.queue_free();
	if viewing_suspect_notes and currently_viewed_portrait:
		currently_viewed_portrait.unselect();
	exit_button_prompt.hide();
	make_select_text.show();
	set_portraits_focusable();
	suspect_name_text.hide();
	set_bumper_button_prompts(BumperButtonPrompts.Right);
	if GameManager.any_unviewed_new_items() or GameManager.any_unviewed_new_misc_evidence():
		rb_exclamation.show();
		print("unviewed new items or misc evidence");
	else: rb_exclamation.hide();
	lb_exclamation.hide();
	portraits.get_children()[0].grab_focus();
	pass;

func reset_to_items_page() -> void:
	set_bumper_button_prompts(BumperButtonPrompts.Both);
	if GameManager.any_unviewed_new_suspect_evidence(): lb_exclamation.show();
	else: lb_exclamation.hide();
	if GameManager.any_unviewed_new_misc_evidence(): rb_exclamation.show();
	else: rb_exclamation.hide();
	current_page = Page.Items;
	if items_container.get_child_count() > 0:
		items_container.get_child(0).grab_focus();
	else:
		info.text = "you haven't collected any items yet.";
	pass;

func populate_suspect_notes_list(suspect : GameTypes.Suspects) -> void:
	print("suspect %s" % suspect);
	var filtered_evidence : Array[Evidence];
	filtered_evidence = GameManager.get_collected_evidence().filter(func(e : Evidence): return e.associated_suspect == suspect );
	
	for child in evidence_list.get_children():
		child.queue_free();
	
	await get_tree().process_frame;
	
	for evidence in filtered_evidence:
		var new_list_element : JournalEvidenceItem = JOURNAL_EVIDENCE_ITEM.instantiate();
		new_list_element.text = evidence.evidence_string_description;
		new_list_element.associated_evidence = evidence;
		evidence_list.add_child(new_list_element);
		if not evidence.new : new_list_element.exclamation.hide();

	if evidence_list.get_child_count() > 0:
		#we successfully selected a portrait of a suspect that we have evidence on
		var first : JournalEvidenceItem = evidence_list.get_child(0) as JournalEvidenceItem;
		var selected_portrait : JournalPortrait = get_viewport().gui_get_focus_owner() as JournalPortrait;
		selected_portrait.selected = true;
		make_select_text.hide();
		exit_button_prompt.show();
		set_portraits_unfocusable();
		first.grab_focus();
		current_page = Page.SuspectNotes;
		suspect_name_text.text = GameTypes.SUSPECT_NAMES[suspect];
		suspect_name_text.show();
	else:
		#no evidence for this suspect, yet
		var tween = create_tween();
		tween.tween_property(no_evidence_text, "modulate:a", 1, 0.2);
		tween.tween_interval(0.5);
		tween.tween_property(no_evidence_text, "modulate:a", 0, 0.2);
		tween.set_parallel(false);
		tween.play();


func set_portraits_unfocusable() -> void:
	for portrait in portraits.get_children():
		portrait = portrait as JournalPortrait;
		portrait.focus_mode = Control.FOCUS_NONE;

func set_portraits_focusable() -> void:
	for portrait in portraits.get_children():
		portrait = portrait as JournalPortrait;
		portrait.focus_mode = Control.FOCUS_ALL;

func set_bumper_button_prompts(value : BumperButtonPrompts) -> void:
	match value:
		BumperButtonPrompts.Left:
			lb_prompt.modulate.a = 1;
			rb_prompt.modulate.a = 0.1;
		BumperButtonPrompts.Right:
			lb_prompt.modulate.a = 0.1;
			rb_prompt.modulate.a = 1;
		BumperButtonPrompts.Both:
			lb_prompt.modulate.a = 1;
			rb_prompt.modulate.a = 1;
