class_name Evidence
extends Resource

enum Enum {
	HasGun,
	KnewTheVictim,
	Test,
	MiscTest1,
	MiscTest2,
	MiscTest3,
}

@export var associated_suspect : GameTypes.Suspects = GameTypes.Suspects.Grandma;
@export var evidence_string_description : String;
var new : bool = true;
