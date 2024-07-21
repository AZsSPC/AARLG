shader_type canvas_item;

void fragment() {
	vec2 pixel_uv = vec2(UV / TEXTURE_PIXEL_SIZE);
	
	if (int(pixel_uv.y) / 32 % 3 != 2) 
		COLOR.a *= float(int(pixel_uv.y) % 96) / 64.0;
}
