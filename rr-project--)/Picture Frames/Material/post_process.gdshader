shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

uniform int style = 0; // 0 = Default

void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);

	// Luminance (used in multiple modes)
	float luma = dot(col.rgb, vec3(0.299, 0.587, 0.114));

	// 0 — DEFAULT (Toon only, no filter)
	if (style == 0) {
		COLOR = col;
	}

	// 1 — MONOCHROME (Black & White)
	else if (style == 1) {
		COLOR = vec4(vec3(luma), col.a);
	}

	// 2 — ULTRA SATURATION (Nature documentary)
	else if (style == 2) {
		vec3 saturated = mix(vec3(luma), col.rgb, 1.8);
		COLOR = vec4(saturated, col.a);
	}

	// 3 — SEPIA (Old western / cowboy movie)
	else if (style == 3) {
		vec3 sepia = vec3(
			luma * 1.2,
			luma * 1.0,
			luma * 0.8
		);
		COLOR = vec4(sepia, col.a);
	}

	// 4 — FILMIC (Grain + vignette)
	else if (style == 4) {
		// Film grain
		float grain = fract(sin(dot(SCREEN_UV * 1000.0, vec2(12.9898,78.233))) * 43758.5453);
		col.rgb += (grain - 0.5) * 0.08;

		// Vignette
		float dist = distance(SCREEN_UV, vec2(0.5));
		col.rgb *= smoothstep(0.8, 0.3, dist);

		COLOR = col;
	}
}

