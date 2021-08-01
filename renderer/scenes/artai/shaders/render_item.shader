shader_type canvas_item;

uniform float smooth_width : hint_range(0.0, 1.0) = 0.1;
uniform float saturation = 0.0;

const vec3 luminosity = vec3(0.2126, 0.7152, 0.0722);

vec3 saturate(vec3 color, float value) {
	vec3 grayscale = vec3(dot(color, luminosity));
	return mix(grayscale, color, 1.0 + value);
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = saturate(COLOR.rgb, saturation);

	float d = distance(UV, vec2(0.5));
	COLOR.a = smoothstep(0.5, 0.5 + smooth_width, 1.0 - d);
}
