extends CharacterBody2D

var can_move = true

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	randomize()
	animationTree.active = true

func _physics_process(delta):
	if can_move:
		move_state(delta)
	
func move_state(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	self.velocity = input_vector*delta*5000
	
	if input_vector == Vector2.ZERO:
		animationTree.get("parameters/playback").travel("Idle")
	else:
		animationTree.get("parameters/playback").travel("Walk")
		animationTree.set("parameters/Walk/BlendSpace2D/blend_position", input_vector)
	move()

func move():
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
