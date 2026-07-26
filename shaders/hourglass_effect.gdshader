shader_type canvas_item;

uniform float t;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV - vec2(0.5, 0.5);
	float a = 0.0f;
	float m = 0.1 + 0.05*sin(3.0*t);
	if (uv.x == 0.0f) {
		a = uv.y > 0.0f ? PI/2.0f : -PI/2.0f;
	} else {
		a = atan(uv.y, uv.x);
	}
	a += t;
	float r = 2.0*length(uv) * (1.0 + m + m*sin(10.0*a));
	COLOR = texture(TEXTURE, UV);
	COLOR.a = 0.3f;
	COLOR.a *= 1.0 - step(1.0, r);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
