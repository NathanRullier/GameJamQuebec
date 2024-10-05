extends Node2D

@onready var Legend_Node = $Legende
@onready var Historien_Node = $Historien

signal start_exposition
signal end_exposition(node)
var initialized = false

var dialog_index = -1
var conversation = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_exposition.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		next_dialog()

func next_dialog():
	dialog_index+=1
	if dialog_index < conversation.size() && conversation.size() != 0:
		if conversation[dialog_index][0] == "Hero":
			use_hero_exposition()
		else:
			use_historien_exposition()
	else:
		end_exposition.emit(self)
		

func use_historien_exposition():
	Legend_Node.visible = false
	Historien_Node.visible = true
	Historien_Node.get_node("Text").set_text(conversation[dialog_index][1])
	
func use_hero_exposition():
	Legend_Node.visible = true
	Historien_Node.visible = false
	Legend_Node.get_node("Text").set_text(conversation[dialog_index][1])
