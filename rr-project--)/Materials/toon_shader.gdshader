shader_type spatial;

uniform vec3 main_color : source_color = vec3(0.5, 0.3, 0.9);
uniform float shade_low : hint_range (0.0, 1.0) = 0.05;
uniform float shade_high : hint_range(0.0, 1.0) = 0.15;
uniform float brightness : hint_range(0.0, 4.0) = 1.0;


void fragment() {
	ALBEDO = main_color;
}

void light(){
	float nDotL = dot(NORMAL, LIGHT);
	nDotL = clamp(nDotL, 0.0, 1.0);
	
	float toon_factor = smoothstep(shade_low, shade_high, nDotL);
	
	DIFFUSE_LIGHT += toon_factor * brightness;
}


