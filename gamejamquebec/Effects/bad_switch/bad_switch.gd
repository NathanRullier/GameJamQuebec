extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished():
		color_rect.visible = false
	
func bad_switch():
	color_rect.visible = true
	animation_player.play("bad_switch")
