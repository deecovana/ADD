shader_type spatial;

uniform bool use_textures = false;
uniform vec4 top_color : source_color = vec4(0.2, 0.8, 0.2, 1.0); // Green
uniform vec4 side_color : source_color = vec4(0.5, 0.3, 0.1, 1.0); // Brown
uniform sampler2D top_texture : source_color;
uniform sampler2D side_texture : source_color;
//uniform sampler2D top_normal : source_color;
//uniform sampler2D side_normal : source_color;
uniform vec4 tint_color : source_color;
uniform float uv_scale = 1.0;
uniform float slope_sharpness : hint_range(0.0, 1.0) = 0.5;
uniform float slope_angle : hint_range(0.0, 1.0) = 0.5;

varying vec3 v_normal;

void vertex() {
    v_normal = NORMAL; // Pass normal to fragment shader
}

void fragment() {
    // 1. Calculate dot product between world-up (0,1,0) and normalized surface normal
    float slope = dot(normalize(v_normal), vec3(0.0, 1.0, 0.0));

    // 2. Smoothstep to define the cutoff between top and sides
    float mask = smoothstep(slope_angle - slope_sharpness, slope_angle + slope_sharpness, slope);

	if(!use_textures) {
	    // 3. Blend colors based on mask
	    ALBEDO = mix(side_color.rgb, top_color.rgb, mask);
	}
	else {
		// 3a. The same but textured
	    // Sample textures
	    vec4 top_tex = texture(top_texture, UV * uv_scale);
	    vec4 side_tex = texture(side_texture, UV * uv_scale);
	    ALBEDO = mix(side_tex.rgb, top_tex.rgb, mask);
	    //vec4 top_nor = texture(top_normal, UV * uv_scale);
	    //vec4 side_nor = texture(side_normal, UV * uv_scale);
	    //NORMAL_MAP = mix(side_nor.rgb, top_nor.rgb, mask);
		//vec2 combined_uv = UV + UV2;
		ROUGHNESS = 0.95;
	}
}