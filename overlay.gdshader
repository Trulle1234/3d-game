shader_type canvas_item;

#define MAXCOLORS 16

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform bool enabled = true;
uniform bool dithering = true;
uniform int colors : hint_range(1, MAXCOLORS) = 12;
uniform int dither_size: hint_range(1, 8) = 1;

float dithering_pattern(ivec2 fragcoord) {
	const float pattern[] = {
		0.00, 0.50, 0.10, 0.65,
		0.75, 0.25, 0.90, 0.35,
		0.20, 0.70, 0.05, 0.50,
		0.95, 0.40, 0.80, 0.30
	};

	int x = fragcoord.x % 4;
	int y = fragcoord.y % 4;

	return pattern[y * 4 + x];
}

float reduce_color(float raw, float dither, int depth) {
	float scaled = raw * float(depth);
	float base = floor(scaled);
	float fraction = scaled - base;

	if (fraction > dither) {
		base += 1.0;
	}

	return clamp(base / float(depth), 0.0, 1.0);
}

void fragment() {
	vec4 raw = texture(screen_texture, SCREEN_UV);
	ivec2 uv = ivec2(FRAGCOORD.xy / float(dither_size));

	if (enabled) {
		float dithering_value = 1.0;

		if (dithering) {
			dithering_value = dithering_pattern(uv);
		}

		float dither = (dithering_value - 0.5) * dithering_value + 0.5;

		COLOR.r = reduce_color(raw.r, dither, colors - 1);
		COLOR.g = reduce_color(raw.g, dither, colors - 1);
		COLOR.b = reduce_color(raw.b, dither, colors - 1);
		COLOR.a = 1.0;
	} else {
		COLOR = raw;
	}
}