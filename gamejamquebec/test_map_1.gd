extends Node2D

@onready var player = $Player
@onready var exposition = $Exposition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exposition.conversation = [
	["Hero","Allo"],
	["Historien","Allo"],
	["Historien","ca va?"],
	["Hero","Oui, Merci"]
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
