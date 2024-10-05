extends Camera2D


@onready var top_left = $TopLeft
@onready var bottom_right = $BottomRight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit_top = top_left.global_position.y
	limit_left = top_left.global_position.x
	limit_bottom = bottom_right.global_position.y
	limit_right = bottom_right.global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
