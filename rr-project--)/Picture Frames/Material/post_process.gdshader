shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform int style = 0; // 0 = Default

void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);

	// Luminance
	float luma = dot(col.rgb, vec3(0.299, 0.587, 0.114));

	// 0 — DEFAULT
	if (style == 0) {
		COLOR = col;
	}

	// 1 — MONOCHROME
	else if (style == 1) {
		COLOR = vec4(vec3(luma), col.a);
	}

	// 2 — ULTRA SATURATION
	else if (style == 2) {
		vec3 saturated = mix(vec3(luma), col.rgb, 1.8);
		COLOR = vec4(saturated, col.a);
	}

	// 3 — SEPIA
	else if (style == 3) {
		vec3 sepia = vec3(
			luma * 1.2,
			luma,
			luma * 0.8
		);
		COLOR = vec4(sepia, col.a);
	}

	// 4 — FILMIC
	else if (style == 4) {
		float grain = fract(
			sin(dot(SCREEN_UV * 1000.0, vec2(12.9898, 78.233))) * 43758.5453
		);

		col.rgb += (grain - 0.5) * 0.08;

		float dist = distance(SCREEN_UV, vec2(0.5));
		col.rgb *= smoothstep(0.8, 0.3, dist);

		COLOR = col;
	}

	// 5 — RIO (Instagram 2016 warm pastel)
	else if (style == 5) {
		// Warm lift
		col.rgb += vec3(0.06, 0.03, -0.02);

		// Slight fade
		col.rgb = mix(col.rgb, vec3(luma), 0.15);

		// Gentle contrast
		col.rgb = pow(col.rgb, vec3(0.9));

		COLOR = col;
	}

// 6 — VHS (90s)
else if (style == 6) {

	// Scanlines
	float scanline = sin(SCREEN_UV.y * 800.0 + TIME * 10.0) * 0.04;
	col.rgb -= scanline;

	// Horizontal noise jitter
	float noise = fract(
		sin(dot(vec2(SCREEN_UV.y * 500.0, TIME), vec2(12.9898,78.233)))
		* 43758.5453
	);
	col.rgb += (noise - 0.5) * 0.08;

	// Chromatic aberration
	col.r = texture(screen_texture, SCREEN_UV + vec2(0.002, 0.0)).r;
	col.b = texture(screen_texture, SCREEN_UV - vec2(0.002, 0.0)).b;

	COLOR = col;
}
}


