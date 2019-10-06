shader_type canvas_item;

uniform vec4 bg_color : hint_color;
uniform vec4 fg_color : hint_color;
uniform vec4 special_color : hint_color;
uniform sampler3D hatch;
uniform float hatch_min : hint_range(0, 0.5);
uniform float hatch_max : hint_range(0.7, 1.0);
uniform float hatch_max_deviation : hint_range(0, 0.2);
uniform sampler2D bg_texture;
uniform vec2 bg_texture_size;
uniform sampler2D vignette_texture;
uniform float vignette_power : hint_range(0, 10.0);

void fragment() {
    vec4 col = texture(TEXTURE, SCREEN_UV);

	float timem1 = ceil(TIME * 3.0);
	float timem2 = ceil(TIME * 10.0);
	vec2 off = timem1 * vec2(sin(timem1), cos(timem2)) + timem2 * vec2(sin(timem2), cos(timem1)) * 0.01;

	float htch_level = col.b;
	float hl_max = hatch_max + hatch_max_deviation * cos(TIME * 7.31 + SCREEN_UV.x * sin(timem2) + SCREEN_UV.y * cos(timem1));
	htch_level = mix(hatch_min, hl_max, htch_level);
	float htch = 1.0 - texture(hatch, vec3(off + SCREEN_UV / SCREEN_PIXEL_SIZE / 256.0, htch_level)).r;
	float w = max(htch, col.g);

	float vignette_sample = texture(vignette_texture, SCREEN_UV).r;
	w = w * pow(vignette_sample, vignette_power);

	vec4 bg_sample = texture(bg_texture, SCREEN_UV / SCREEN_PIXEL_SIZE / bg_texture_size - off.yx);
	vec4 bg = bg_color * bg_sample;

    COLOR = mix(mix(bg, fg_color, w), special_color * mix(0.6, 1, bg_sample.r), col.r);
}
