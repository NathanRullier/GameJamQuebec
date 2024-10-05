extends Node2D

var show = false;
@onready var HeroPOV =$"Hero POV"
@onready var HistoPOV =$"Histo POV"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HeroPOV.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if show:
			show = false
			HeroPOV.visible = false
			HistoPOV.visible = true
		else:
			show = true
			HeroPOV.visible = true
			HistoPOV.visible = false
