extends CharacterBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

@export var ACCELERATION = 500
@export var MAX_SPEED = 80
@export var ROLL_SPEED = 120
@export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var can_move = true
var state = MOVE
#var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize()
	stats.connect("no_health", Callable(self, "queue_free"))
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	if can_move:
		match state:
			MOVE:
				move_state(delta)
			
			ROLL:
				roll_state()
			
			ATTACK:
				attack_state()
	
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
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)
	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
