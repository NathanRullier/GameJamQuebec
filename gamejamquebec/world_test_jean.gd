extends Node2D

# Récupération des Nodes 1 et 2 du niveau
@onready var setL = $LegendarySet
@onready var setR = $RealitySet
# Récupération des player 1 et 2 du niveau
@onready var playerL = $LegendarySet/PlayerLegend
@onready var playerR = $RealitySet/PlayerReal

var active_set
var active_player
var player_in_area = false  # Détection si le joueur est dans une zone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_set = setL
	active_player = playerL

	# Connecter les signaux des `Area2D` du groupe 1
	#connect_areas_signals(setL)
	#connect_areas_signals(setR)
	
	# Initialiser le deuxième settt comme inactif au démarrage
	toggle_set(setR, false)
	
	# Vérifier si le joueur est déjà dans une zone de collision
	#check_player_in_area()
	
#func check_player_in_area():
	#player_in_area = false  # Réinitialise la détection au départ
	#
	## Parcourir toutes les `Area2D` pour vérifier si le joueur est dedans
	#for wall in setL.get_node("Walls").get_children() + setR.get_node("Walls").get_children():
		#if wall.has_node("Area2D"):
			#var area = wall.get_node("Area2D")
			#if active_player in area.get_overlapping_bodies():
				#player_in_area = true
				#print("Le joueur est déjà dans une zone de collision au démarrage.")
				#break
#
#func connect_areas_signals(set_node):
	## Parcourir tous les enfants de `Walls` dans chaque groupe pour connecter les `Area2D`
	#var walls = set_node.get_node("Walls").get_children()
	#for wall in walls:
		#if wall.has_node("Area2D"):
			#var area = wall.get_node("Area2D")
			#print("Signal connecté pour l'Area2D :", area)
			#area.connect("body_entered", Callable(self, "_on_body_entered"))
			#area.connect("body_exited", Callable(self, "_on_body_exited"))
			#
#func _on_body_entered(body):
	#if body == active_player:
		#player_in_area = true
		#print("Le joueur est entré dans une zone de collision.")
#
#func _on_body_exited(body):
	#if body == active_player:
		#player_in_area = false
		#print("Le joueur a quitté la zone de collision.")
		
func _process(delta):
	# Synchroniser la position du joueur inactif avec le joueur actif
	if active_player == playerL:
		playerR.global_position = playerL.global_position
		# Pour la suite, synchroniser la positon des elements déplacable
		# uniquement quand ils sont déplacé 
	else:
		playerL.global_position = playerR.global_position
		# Pour la suite, synchroniser la positon des elements déplacable
		# uniquement quand ils sont déplacé 

func _input(event):
	# Switch des Node aqund on presse T sur le clavier
	if event.is_action_pressed("setSwitch"):
		attempt_switch_sets()

func attempt_switch_sets():
	#sets_switch()
	#check_player_in_area()
	#if player_in_area:
		#sets_switch()
		#print("Impossible de changer de set : la position est occupée.")
	#else:
		#print("else attempt")
		
	if is_position_safe():
		sets_switch()
	else:
		print("Impossible de changer de set : la position est occupée.")
		
func sets_switch():
	# Inverser l'état des deux sets
	toggle_set(setL, !setL.visible)
	toggle_set(setR, !setR.visible)
	
	# Mettre à jour le set et le joueur actifs
	active_set = setR if active_set == setL else setL
	active_player = playerR if active_player == playerL else playerL

func is_position_safe():
	print("is position safe = reach")
	#Récupérer les buissons du set cible (celui sur lequel on veut basculer)
	var target_set = setR if active_set == setL else setL
	var walls = target_set.get_node("Walls").get_children()
	
	# Vérifier si la position du joueur actif est la même qu'un des buissons
	for wall in walls:
		var body = wall.get_node("StaticBody2D")
		print("StaticBody2D trouvé :", body)
		var collision_shape = body.get_node("CollisionShape2D").shape
		print("collision_shape trouvé :", collision_shape)
		print("Position du mur:", wall.global_position)
		print("Position du joueur:", active_player.global_position)

		# Vérifier le type de la forme pour déterminer comment calculer la distance de sécurité
		if collision_shape is RectangleShape2D:
			var rect_size = collision_shape.size
			if wall.global_position.distance_to(active_player.global_position) < rect_size.length():
				return false
		#elif collision_shape is CircleShape2D:
			#var radius = collision_shape.radius
			#if wall.global_position.distance_to(active_player.global_position) < radius:
				#return false
	return true

func toggle_set(set_node, is_active):
	set_node.visible = is_active
	set_node.process_mode = Node.PROCESS_MODE_INHERIT if is_active else Node.PROCESS_MODE_DISABLED
