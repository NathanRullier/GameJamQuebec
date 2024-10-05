extends Node2D

@onready var exposition = $Exposition
@onready var player = $Player

var is_in_exposition = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exposition.conversation = [
	["Hero","wow le 2eme niveau"],
	["Historien","c bo"],
]
	exposition.next_dialog()
	player.can_move = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exposition_end_exposition(node: Variant) -> void:
	player.can_move = true
	remove_child(node) # Replace with function body.
