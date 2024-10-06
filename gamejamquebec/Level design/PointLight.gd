extends PointLight2D


var time = 0
var radius = 1
const radius_max = 1.4
const radius_min = 1
const variation = 0.1
const variation2 = 0.05
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > 0.2:
		time = 0
		var radnom_number = randf_range(1-variation, 1+variation)
		radius *= radnom_number
		if radius > radius_max:
			radius = randf_range(1-variation2, radius_max)
		if radius < radius_min:
			radius = randf_range(radius_min, 1+variation2)
		set_texture_scale(radius)	
	
