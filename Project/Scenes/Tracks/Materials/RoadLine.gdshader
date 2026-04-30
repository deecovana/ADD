shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

// Textures and Parameters
uniform sampler2D albedo_Top : source_color, filter_linear_mipmap_anisotropic;
uniform sampler2D albedo_Side : source_color, filter_linear_mipmap_anisotropic;
uniform sampler2D normal_Top : hint_normal, filter_linear_mipmap_anisotropic;
uniform sampler2D normal_Side : hint_normal, filter_linear_mipmap_anisotropic;
uniform float Side_sharpness : hint_range(0.0, 10.0) = 2.0;
uniform float Side_angle : hint_range(0.0, 1.0) = 0.5;
uniform float texture_scale = 0.1;

varying vec3 v_world_pos;
varying vec3 v_world_normal;

uniform float random_seed = 6.9; // Set via GDScript

void vertex() {
    // Fixed Basis: Calculate world position and normal
    v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    v_world_normal = MODEL_NORMAL_MATRIX * NORMAL;
}

vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
    vec4 samp = vec4(0.0);
    // Triplanar blending function using world-space positions
    samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
    samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
    samp += texture(p_sampler, p_triplanar_pos.zy) * p_weights.x;
    return samp;
}

// Simple hash function for randomness
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

void fragment() {
    vec3 n = normalize(v_world_normal);
    float steepness = 1.0 - dot(n, vec3(0.0, 1.0, 0.0)); // 1.0 is vertical, 0.0 is Top
    float blend = smoothstep(Side_angle - 0.1, Side_angle + 0.1, steepness);

    // Triplanar Setup
    vec3 triplanar_pos = v_world_pos * texture_scale;
    vec3 power_normal = pow(abs(n), vec3(Side_sharpness));
    vec3 weights = power_normal / dot(power_normal, vec3(1.0));
	
	// Create random, but consistent offset for this instance
    vec3 random_offset = vec3(
        hash(random_seed + 1.0),
        hash(random_seed + 2.0),
        hash(random_seed + 3.0)
    ) * 1000.0 * texture_scale; // Scale offset range
    
    triplanar_pos += random_offset;

    // Sample and Mix
    vec4 col_Top = triplanar_texture(albedo_Top, weights, triplanar_pos);
    vec4 col_Side = triplanar_texture(albedo_Side, weights, triplanar_pos);
    ALBEDO = mix(col_Top.rgb, col_Side.rgb, blend);

    vec4 nrm_Top = triplanar_texture(normal_Top, weights, triplanar_pos);
    vec4 nrm_Side = triplanar_texture(normal_Side, weights, triplanar_pos);
    NORMAL_MAP = mix(nrm_Top.rgb, nrm_Side.rgb, blend);
}