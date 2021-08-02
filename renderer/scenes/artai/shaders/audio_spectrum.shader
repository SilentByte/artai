shader_type canvas_item;

uniform float amplitude = 1.0;

void fragment() {
	float d = distance(UV, vec2(0.5));
	COLOR.rgb = vec3(1);
	COLOR.a = smoothstep(0.4, 0.5, d) * amplitude * 0.5;
}
