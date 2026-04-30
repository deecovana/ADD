shader_type spatial;
render_mode cull_disabled; // Double sided

//uniform float height_scale = 3;
//uniform sampler2D noise;
uniform sampler2D normalmap;
uniform sampler2D texturemap;
varying vec2 nor_position;
varying vec2 tex_position;

void vertex() {
	//// Add Noise
	nor_position = VERTEX.xz / 14.5 + 0.5;
	tex_position = VERTEX.xz / 7.5 + 0.5;
	//float height = texture(noise, tex_position).x;
	// VERTEX.y += height * height_scale - 0.5;
	//// Add Waves
	//VERTEX.y += cos(VERTEX.x*PI) * sin(VERTEX.z*PI)/(PI*PI);
	//// Clamp Borders
	//if ((VERTEX.z < -63.0 || VERTEX.z > 63.0)
			//|| (VERTEX.x < -63.0 || VERTEX.x > 63.0)) {
		//VERTEX.y = 0.0;
	//}
}

void fragment() {
	// Set Color
	//ALBEDO = vec3(0.45, 0.24, 0.05);
	ALBEDO = texture(texturemap, tex_position).xyz * vec3(0.95, 0.64, 0.15);
	// Add Normals
	NORMAL_MAP = texture(normalmap, nor_position).xyz;
	
}