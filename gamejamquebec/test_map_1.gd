extends Node2D

@onready var player = $Player
@onready var exposition = $Exposition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exposition.conversation = [
	["Hero","Allo","ExpositionHero_1"],
	["Historien","Allo", "ExpositionHistorien_1"],
	["Historien","ca va?", "ExpositionHistorien_1"],
	["Hero","Oui, Merci","ExpositionHero_2"]
]
	exposition.next_dialog()
	player.can_move = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exposition_end_exposition(node: Variant) -> void:
	player.can_move = true
	remove_child(node)


func _on_exposition_start_exposition() -> void:
	if player != null:
		player.can_move = false
