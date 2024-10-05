extends Node2D

@onready var groupe_1 = $Node2D_Groupe1
@onready var groupe_2 = $Node2D_Groupe2

var active_set = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialiser le premier set comme actif et le deuxième comme inactif
	groupe_1.show()
	groupe_2.hide()
	groupe_1.set_process(true)
	groupe_2.set_process(false)
	groupe_1.set_physics_process(true)
	groupe_2.set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
