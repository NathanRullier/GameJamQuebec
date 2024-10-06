extends Node2D

# Récupération des Nodes 1 et 2 du niveau
@onready var setHero = $"Niveau 1/Hero POV"
@onready var setHisto = $"Niveau 1/Histo POV"
# Récupération des player 1 et 2 du niveau
@onready var playerHero = $"Niveau 1/Hero POV/Player_Hero"
@onready var playerHisto = $"Niveau 1/Histo POV/Player_Histo"
# Récupération des son et music du niveau
@onready var switchSound = $setSwitch_sound
@onready var musiqueHero = $"Niveau 1/Hero POV/Musique_Hero"
@onready var musiqueHisto = $"Niveau 1/Histo POV/Musique_Histo"

@onready var bad_switch = $Bad_Switch

var active_set
var active_player
var active_music

var in_switch_transition = false
var switch_transition_speed = 0.5
#var hidden_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialisation_niveau()
	#queue_redraw()


func _process(delta):
	if in_switch_transition:
		switch_transition(delta)
	# Synchroniser la position du joueur inactif avec le joueur actif
	if active_player == playerHero:
		playerHisto.global_position = playerHero.global_position
		# Pour la suite, synchroniser la positon des elements déplacable
		# uniquement quand ils sont déplacé 
	else:
		playerHero.global_position = playerHisto.global_position
		# Pour la suite, synchroniser la positon des elements déplacable
		# uniquement quand ils sont déplacé 

func _input(event):
	# Switch des Node aqund on presse T sur le clavier
	if event.is_action_pressed("setSwitch"):
		attempt_switch_sets()

func attempt_switch_sets():
	#print("Position avant switch joueur VISIBLE:", active_player.global_position)
	#print("Position avant switch joueur CACHÉ:", hidden_player.global_position)
	if is_position_safe():
		transition_starting()
		sets_switch()
	else:
		bad_switch.bad_switch()
		$scratch_sound_2.play()
		print("Impossible de changer de set : la position est occupée.")
		
func sets_switch():
	switchSound.play()
	# Mettre à jour le set et le joueur actifs
	active_set = setHisto if active_set == setHero else setHero
	active_player = playerHisto if active_player == playerHero else playerHero
	active_music = musiqueHisto if active_music == musiqueHero else musiqueHero
	#hidden_player = playerHero if active_player == playerHisto else playerHisto
	
	#queue_redraw()  # Redessiner la scène après le switch pour voir les nouvelles zones

func is_position_safe():
	#Récupérer les obstacle du set cible (celui sur lequel on veut basculer)
	var target_set = setHisto if active_set == setHero else setHero
	var walls = target_set.get_node("Vide").get_children()
	
	# Vérifier si la position du joueur actif est la même qu'un des mur
	for wall in walls:
		var body = wall.get_node("StaticBody2D")
		var collision_shape = body.get_node("CollisionShape2D").shape
		# Vérifier le type de la forme pour déterminer comment calculer la distance de sécurité
		if collision_shape is RectangleShape2D:
			var rect_size = collision_shape.size
			var rect = Rect2(wall.global_position - rect_size / 2, rect_size)
			if rect.has_point(active_player.global_position):
				print("Collision détectée avec un mur.")
				return false
			#if wall.global_position.distance_to(active_player.global_position) < rect_size.length() / 2:
				#return false
		#elif collision_shape is CircleShape2D:
			#var radius = collision_shape.radius
			#if wall.global_position.distance_to(active_player.global_position) < radius:
				#return false
	return true

func toggle_set(set_node, is_active):
	set_node.visible = is_active
	set_node.process_mode = Node.PROCESS_MODE_INHERIT if is_active else Node.PROCESS_MODE_DISABLED


func switch_transition(delta):
	if setHero.process_mode == Node.PROCESS_MODE_INHERIT:
		setHisto.modulate[3] += delta/switch_transition_speed
		setHero.modulate[3] -= delta/switch_transition_speed
		if setHisto.modulate[3] >= 1:
			setHisto.modulate[3] = 1
			setHero.modulate[3] = 0
			setHero.process_mode = Node.PROCESS_MODE_DISABLED
			setHisto.process_mode = Node.PROCESS_MODE_INHERIT
			transition_finished()
	else:
		setHisto.modulate[3] -= delta/switch_transition_speed
		setHero.modulate[3] += delta/switch_transition_speed
		if setHero.modulate[3] >= 1:
			setHero.modulate[3] = 1
			setHisto.modulate[3] = 0
			setHisto.process_mode = Node.PROCESS_MODE_DISABLED
			setHero.process_mode = Node.PROCESS_MODE_INHERIT
			transition_finished()

func transition_starting():
	in_switch_transition = true
	playerHero.can_move = false
	playerHisto.can_move = false

func transition_finished():
	in_switch_transition = false
	playerHero.can_move = true
	playerHisto.can_move = true


func initialisation_niveau():
	match self.get_name():
		"Lvl_1":
			active_set = setHisto
			active_player = playerHisto
			active_music = musiqueHisto
			#hidden_player = playerHero
			
			# Initialiser le deuxième set comme inactif au démarrage
			setHero.process_mode = Node.PROCESS_MODE_DISABLED
			setHero.modulate[3] = 0
		"Lvl_2":
			active_set = setHero
			active_player = playerHero
			active_music = musiqueHero
			#hidden_player = playerHisto
			
			# Initialiser le deuxième set comme inactif au démarrage
			setHisto.process_mode = Node.PROCESS_MODE_DISABLED
			setHisto.modulate[3] = 0
		"Lvl_3":
			active_set = setHisto
			active_player = playerHisto
			active_music = musiqueHisto
			#hidden_player = playerHero
			
			# Initialiser le deuxième set comme inactif au démarrage
			setHero.process_mode = Node.PROCESS_MODE_DISABLED
			setHero.modulate[3] = 0
		_:
			print ("aucun Level ne match")

##Fonction qui dessine en ROUGE a l'écran les vrai zone de collision
#si on décommente on décommente aussi les queue_redraw() dans la fonction
# set_switch() et ready()
#func _draw():
	#Dessiner les zones de collision de l'ensemble actif
	#var walls = active_set.get_node("Vide").get_children()
	#for wall in walls:
		#var body = wall.get_node("StaticBody2D")
		#if not body:
			#continue  # Ignore les murs sans corps valide
		#
		#var collision_shape = body.get_node("CollisionShape2D").shape
		#if collision_shape is RectangleShape2D:
			#var rect_size = collision_shape.size
			#var rect = Rect2(wall.global_position - rect_size / 2, rect_size)
			#draw_rect(rect, Color(1, 0, 0, 0.5))  # Rouge transparent pour visualiser les murs
