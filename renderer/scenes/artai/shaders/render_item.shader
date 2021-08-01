shader_type canvas_item;

uniform float smooth_width : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	float d = distance(UV, vec2(0.5));
	COLOR.a = smoothstep(0.5, 0.5 + smooth_width, 1.0 - d);
}
