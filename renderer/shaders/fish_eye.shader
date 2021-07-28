shader_type canvas_item;

uniform float aperture = 180.0;

const float PI = 3.14159265358979323846;

void fragment() {
    float aperture_half = 0.5 * aperture * (PI / 180.0);
    float max_factor = sin(aperture_half);
    vec2 xy = 2.0 * UV.xy - 1.0;

    if(length(xy) < (2.0 - max_factor)) {
        float d = length(xy * max_factor);
        float z = sqrt(1.0 - d * d);
        float r = atan(d, z) / PI;
        float phi = atan(xy.y, xy.x);

        COLOR = texture(TEXTURE, vec2(r * cos(phi) + 0.5, r * sin(phi) + 0.5));
    }
    else {
        COLOR.a = 0.0;
    }
}
