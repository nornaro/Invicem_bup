shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 mask_color = texture(mask_texture, UV);

    // Use the red channel of mask to determine transparency
    if (mask_color.r < 0.5) {
        discard;
    }

    COLOR = tex_color;
}
