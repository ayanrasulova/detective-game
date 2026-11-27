class_name Evidence
extends Resource

enum Enum {
	HasGun,
	KnewTheVictim,
	Test
}

@export var associated_suspect : GameTypes.Suspects = GameTypes.Suspects.Grandma;
@export var evidence_string_description : String;
var new : bool = true;
