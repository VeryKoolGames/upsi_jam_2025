shader_type canvas_item;

uniform sampler2D pattern_texture;
uniform vec2 uv_scale = vec2(3.0, 3.0);
uniform float speed = 0.5;

void fragment() {
    vec2 uv = UV * uv_scale;  // Échelle du pattern
    uv.x += TIME * speed;     // Déplacement horizontal
	uv.y += TIME * speed;
    uv = fract(uv);  // Forcer la répétition en ne gardant que la partie décimale des UVs

    vec4 tex_color = texture(pattern_texture, uv);
    COLOR = tex_color;
}