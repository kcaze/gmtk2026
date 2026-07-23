shader_type canvas_item;

uniform float percent;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV - vec2(0.5, 0.5);
	float r = 2.0*length(uv);
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= 1.0 - step(percent, r);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
