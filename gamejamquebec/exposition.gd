extends Node2D

@onready var Legend_Node = $Legende
@onready var Historien_Node = $Historien
@onready var type_sound = $TypingSound

signal start_exposition
signal end_exposition(node)
var initialized = false

var dialog_index = -1 
var conversation = []
var is_talking = false
var text_to_show = ""
var text = ""
var text_pos = 0
var text_box
var vitesse_affichage = 0.1
var affichage_time = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_exposition.emit()

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
	
	started_talking()
	
	if dialog_index < conversation.size() && conversation.size() != 0:
		
		text_to_show = conversation[dialog_index][1]
		if conversation[dialog_index][0] == "Hero":
			use_hero_exposition()
		else:
			use_historien_exposition()
	else:
		end_exposition.emit(self)
		
func started_talking():
	is_talking = true
	type_sound.play()
		
func finished_talking():
	is_talking = false
	type_sound.stop()	

func use_historien_exposition():
	Legend_Node.visible = false
	Historien_Node.visible = true
	text_box = Historien_Node.get_node("Text")
	
func use_hero_exposition():
	Legend_Node.visible = true
	Historien_Node.visible = false
	text_box = Legend_Node.get_node("Text")
