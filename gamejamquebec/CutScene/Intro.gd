extends Node2D

@onready var Legend_Node = $Legende
@onready var Historien_Node = $Historien
@onready var Images_Node = $Images
@onready var Sound_Node = $Sounds

signal start_exposition
signal end_exposition(node)
var initialized = false

var conversation = [
	["Historien",
	"Il est donc possible, à travers la relecture et la
	reinterpretation des textes, de démontrer la nature
	démesurée des faits présentés.",
	"Scene1",
	"Intro1"],
	["Historien",
	"Un exemple Classique d'une telle situation serait la
	Légende de Jean-Nathan.",
	"Scene2",
	"Intro2"],
	["Hero",
	"Un instant! Je refuse de vous laisser amoindrir
	l'histoire de ma vie une seconde de plus!",
	"Scene3",
	"Intro3"],
	["Hero",
	"Vous pensez, vous et les autres savants de ce monde,
	connaître la verité absolue! Laissez-moi vous éclairer.",
	"Scene5",
	"Intro4"],
	["Hero",
	"Comme vous le saviez déjà, j'étais à la recherche de la 
	couronne du roi fou dont le squelette reposait toujours
	sur son trône.",
	"Scene5",
	"Intro5"],
	["Hero",
	"Cependant, ce que les textes ne vous disent pas c'est que
	les ruines et le roi étaient maudits.",
	"Scene5",
	"Intro6"],
	["Historien",
	"Inconcevable!!!!
	Les textes ne parlaient que de simples ruines.",
	"Scene5",
	"Intro7"],
]
var dialog_index = -1 
var is_talking = false
var text_to_show = ""
var text = ""
var text_pos = 0
var text_box
var vitesse_affichage = 0.05
var affichage_time = 0

var image
var sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_dialog()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	affichage_time += delta
	if affichage_time >= vitesse_affichage:
		
		affichage_time = 0	
		
		if is_talking:
			if text_pos >= text_to_show.length()-1:
				text_pos = text_to_show.length()-1
				finished_talking()
		

			text += conversation[dialog_index][1][text_pos]
			text_box.set_text(text)
			text_pos += 1
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_talking: 
			text_box.set_text(text_to_show)
			finished_talking()
		else:
			next_dialog()

func next_dialog():
	text = ""
	text_pos = 0
	dialog_index+=1
	
		
	
	if dialog_index < conversation.size() && conversation.size() != 0:
		started_talking(conversation[dialog_index][3])
		
		text_to_show = conversation[dialog_index][1]
		
		if conversation[dialog_index][0] == "Hero":
			use_hero_exposition()
		else:
			use_historien_exposition()
	else:
		next_level()
		
func started_talking(sound_name):
	is_talking = true
	if sound != null:
		sound.stop()
	sound = Sound_Node.get_node(sound_name)
	sound.play()
		
func finished_talking():
	is_talking = false
	#sound.stop()	

func use_historien_exposition():
	Legend_Node.visible = false
	Historien_Node.visible = true
	if image == null:
		Images_Node.get_node(conversation[dialog_index][2]).visible = true
		image = conversation[dialog_index][2]
	
	if image != conversation[dialog_index][2]:
		Images_Node.get_node(image).visible = false
		Images_Node.get_node(conversation[dialog_index][2]).visible = true
		image = conversation[dialog_index][2]
		
	text_box = Historien_Node.get_node("Text")
	
func use_hero_exposition():
	Legend_Node.visible = true
	Historien_Node.visible = false
	if image == null:
		Images_Node.get_node(conversation[dialog_index][2]).visible = true
		image = conversation[dialog_index][2]
		
	if image != conversation[dialog_index][2]:
		Images_Node.get_node(image).visible = false
		Images_Node.get_node(conversation[dialog_index][2]).visible = true
		image = conversation[dialog_index][2]
		
	text_box = Legend_Node.get_node("Text")

func next_level():
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Level/Level_1.tscn")
