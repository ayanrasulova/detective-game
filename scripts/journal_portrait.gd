class_name JournalPortrait
extends TextureRect

@export var suspect : GameTypes.Suspects;

const EVIDENCE_BUTTON = preload("uid://dqe42de2hmk2o")
const SELECT_BUTTON = preload("uid://csp8vf64g71dv")


@onready var panel: Panel = $Panel
@onready var select_prompt: TextureRect = $SelectPrompt

var selected : bool = false;

func _ready() -> void:
	panel.hide();
	select_prompt.hide();
	z_index = 1;
	
	GameManager.journal_opened.connect(func():
		select_prompt.texture = EVIDENCE_BUTTON if GameManager.selecting_evidence else SELECT_BUTTON);
	focus_entered.connect(func():
		z_index = 3;
		panel.show()
		select_prompt.show());
	focus_exited.connect(func():
		if selected :
			select_prompt.hide();
			return;
		z_index = 1;
		panel.hide()
		select_prompt.hide());

func unselect() -> void:
	panel.hide();
	z_index = 1;
	select_prompt.hide();
