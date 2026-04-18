shader_type spatial;

uniform sampler2D terrain_color;
uniform float min_height = 0.0;
uniform float max_height = 0.0;
varying float vertex_y;


float inverseLerp(float a, float b, float value){
	float v = (value - a) / (b / a);
	return clamp(0.01, 1.0, v);
}

void fragment() {
	float height = vertex_y;
	float position = inverseLerp(min_height, max_height, height);
	ALBEDO = texture(terrain_color, vec2(position,0.0)).rgb;
	ROUGHNESS = 0.75;
}

void vertex() {
	vertex_y = VERTEX.y;
}
