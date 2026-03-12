shader_type spatial;

uniform vec3 water_color : source_color = vec3(0.0, 0.4, 0.8);
uniform vec3 deep_water_color : source_color = vec3(0.0, 0.2, 0.5);
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_height : hint_range(0.0, 2.0) = 0.2;
uniform float foam_level : hint_range(0.0, 2.0) = 0.5;

varying float height;

void vertex() {
	// Simple procedural waves using sine and cosine
	float w1 = sin(VERTEX.x * 0.5 + TIME * wave_speed) * cos(VERTEX.z * 0.5 + TIME * wave_speed);
	float w2 = sin(VERTEX.x * 1.5 - TIME * wave_speed * 0.8) * cos(VERTEX.z * 1.5 + TIME * wave_speed * 1.2);
	height = (w1 + w2 * 0.5) * wave_height;
	VERTEX.y += height;
}

void fragment() {
	// Basic depth effect based on fragment height (since we don't have complex depth texture setup yet)
	float h_norm = clamp((height / wave_height + 1.0) / 2.0, 0.0, 1.0);
	vec3 color = mix(deep_water_color, water_color, h_norm);
	
	// Add some specular-like highlights for "sparkle"
	float sparkle = pow(max(0.0, dot(NORMAL, vec3(0, 1, 0))), 64.0);
	color += vec3(sparkle * 0.2);
	
	ALBEDO = color;
	METALLIC = 0.1;
	ROUGHNESS = 0.05;
	SPECULAR = 0.5;
}
