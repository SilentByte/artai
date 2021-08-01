extends Sprite

var _started = false
var _ttl = 0.0
var _fade_fraction = 1.0
var _movement = Vector2.ZERO
var _rotation = 0.0
var _scale = 0.0
var _smooth_width_fraction = 0.1
var _smooth_width = 0.0


# TODO: IMPLEMENT FADE-OUT.
func animate(ttl: float, fade_fraction: float, movement: Vector2, rotation: float, scale: float, smooth_width_fraction: float) -> void:
	_started = true
	_ttl = ttl
	_fade_fraction = fade_fraction
	_movement = movement
	_rotation = rotation
	_scale = scale
	_smooth_width = 0.5
	_smooth_width_fraction = smooth_width_fraction
	self_modulate.a = 0.0

	yield(get_tree().create_timer(ttl), "timeout")
	queue_free()


func _process(delta: float) -> void:
	if not _started:
		return

	position += _movement * delta
	rotation_degrees += _rotation * delta
	scale += Vector2(_scale * delta, _scale * delta)
	self_modulate.a += clamp(delta * (1.0 / _ttl * _fade_fraction), 0.0, 1.0)

	_smooth_width -= clamp(delta * (1.0 / _ttl * _smooth_width_fraction), 0.0, 1.0)
	get_material().set_shader_param("smooth_width", _smooth_width)
