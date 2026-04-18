shader_type spatial;

uniform sampler2D terrain_grass;
uniform sampler2D terrain_rock;
uniform float min_grass_height;
uniform float max_rock_height;
uniform vec2 uvscale;
varying float vertex_y;

void fragment(){
	vec3 grass = texture(terrain_grass, UV * uvscale).rgb;
	vec3 rock = texture(terrain_rock, UV * uvscale).rgb;
	float weight = smoothstep(min_grass_height, max_rock_height, vertex_y);
	ALBEDO = mix(grass, rock, weight);
	ROUGHNESS = 0.75;
}

void vertex(){
	vertex_y = VERTEX.y;
}
