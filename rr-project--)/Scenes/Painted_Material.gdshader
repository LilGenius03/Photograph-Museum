shader_type spatial;
render_mode specular_disabled, diffuse_burley, cull_back;

uniform sampler2D brush_noise;
uniform sampler2D paper_texture;

uniform float brush_scale = 2.2;
uniform float motion_strength = 0.02;
uniform float pigment_strength = 0.18;
uniform float paper_strength = 0.35;
uniform float outline_strength = 0.25;
uniform float shading_strength = 0.6;

uniform vec3 palette_a : source_color = vec3(0.9, 0.85, 0.75);
uniform vec3 palette_b : source_color = vec3(0.45, 0.6, 0.7);
uniform vec3 palette_c : source_color = vec3(0.85, 0.45, 0.35);

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	/* ---------------- World Brush UVs ---------------- */
	vec2 uv = world_pos.xz * brush_scale;

	/* ---------------- Animated Paint Motion ---------------- */
	uv += vec2(
		sin(TIME * 0.6 + uv.y),
		cos(TIME * 0.5 + uv.x)
	) * motion_strength;

	/* ---------------- Textures ---------------- */
	float brush = texture(brush_noise, uv).r;
	float paper = texture(paper_texture, uv * 0.5).r;

	/* ---------------- Pigment Pooling ---------------- */
	float pigment = pow(brush, 1.6) * pigment_strength;

	/* ---------------- Painterly Shading ---------------- */
	float shade = mix(0.85, 1.6, brush);
	shade = mix(1.0, shade, shading_strength);

	/* ---------------- Color Mixing ---------------- */
	vec3 base_color = mix(palette_a, palette_b, brush);
	base_color = mix(base_color, palette_c, brush * 0.5);

	/* ---------------- Paper Texture ---------------- */
	base_color *= mix(1.0, paper, paper_strength);

	/* ---------------- Soft Painted Outline ---------------- */
	float edge = 1.0 - abs(NORMAL.y);
	edge = smoothstep(0.4, 0.9, edge);
	base_color *= mix(1.0, 1.0 - outline_strength, edge);

	/* ---------------- Final Paint ---------------- */
	base_color *= shade;
	base_color += pigment;

	ALBEDO = base_color;
}






