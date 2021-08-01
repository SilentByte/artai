extends Sprite

onready var fade_curve = preload("res://scenes/artai/fade_curve.tres")

var _start_time = 0
var _ttl = 0.0
var _movement = Vector2.ZERO
var _rotation = 0.0
var _scale = 0.0
var _smooth_width_fraction = 0.1
var _smooth_width = 0.5


# TODO: IMPLEMENT FADE-OUT.
func animate(ttl: float, movement: Vector2, rotation: float, scale: float, smooth_width_fraction: float) -> void:
	_start_time = OS.get_ticks_usec()
	_ttl = ttl
	_movement = movement
	_rotation = rotation
	_scale = scale
	_smooth_width = 0.4
	_smooth_width_fraction = smooth_width_fraction
	self_modulate.a = 0.0

	yield(get_tree().create_timer(ttl), "timeout")
	queue_free()


func _age() -> float:
	return (OS.get_ticks_usec() - _start_time) / 1_000_000.0


func _process(delta: float) -> void:
	if not _start_time:
		return

	position += _movement * delta
	rotation_degrees += _rotation * delta
	scale += Vector2(_scale * delta, _scale * delta)

	self_modulate.a = fade_curve.interpolate(_age() / _ttl)

	_smooth_width -= clamp(delta * (1.0 / _ttl * _smooth_width_fraction), 0.0, 1.0)
	_smooth_width = clamp(_smooth_width, 0.1, 0.5)
	get_material().set_shader_param("smooth_width", _smooth_width)
