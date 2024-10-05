extends Node2D

@onready var set1 = $Node2D_Groupe1
@onready var set2 = $Node2D_Groupe2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialiser le deuxième set comme inactif au démarrage
	toggle_set(set2, false)

func _input(event):
	if event.is_action_pressed("setSwitch"):
		sets_switch()

func sets_switch():
	# Inverser l'état des deux sets
	toggle_set(set1, !set1.visible)
	toggle_set(set2, !set2.visible)

func toggle_set(set_node, is_active):
	set_node.visible = is_active
	set_node.process_mode = Node.PROCESS_MODE_INHERIT if is_active else Node.PROCESS_MODE_DISABLED
	
	# Activer/désactiver les collisions pour tous les enfants
	for child in set_node.get_children():
		if child is CollisionObject2D:
			child.set_deferred("disabled", !is_active)
