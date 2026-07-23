shader_type canvas_item;

uniform float saturation = 1.0;

// RGB to HSL conversion function
vec3 rgb2hsl(vec3 c) {
    float max_c = max(max(c.r, c.g), c.b);
    float min_c = min(min(c.r, c.g), c.b);
    float delta = max_c - min_c;

    float h = 0.0;
    if (delta > 0.0) {
        if (max_c == c.r) {
            h = mod((c.g - c.b) / delta, 6.0);
        } else if (max_c == c.g) {
            h = ((c.b - c.r) / delta) + 2.0;
        } else {
            h = ((c.r - c.g) / delta) + 4.0;
        }
        h /= 6.0;
    }

    float l = (max_c + min_c) / 2.0;
    float s = 0.0;
    if (delta > 0.0) {
        s = delta / (1.0 - abs(2.0 * l - 1.0));
    }

    return vec3(h, s, l);
}

// HSL to RGB conversion function
vec3 hsl2rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return c.z + c.y * (rgb - 0.5) * (1.0 - abs(2.0 * c.z - 1.0));
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	vec3 hsl = rgb2hsl(COLOR.rgb);
	hsl.y *= saturation;
	COLOR.rgb = hsl2rgb(hsl);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
