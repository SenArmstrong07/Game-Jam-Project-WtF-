shader_type canvas_item;

// The color you want to overlay
uniform vec4 overlay_color : source_color = vec4(1.0, 0.0, 1.0, 1.0);
// Controls how much of the overlay is applied (0.0 = original, 1.0 = fully overlayed)
uniform float overlay_strength : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	UV.x += TIME * .01;
	UV.y += TIME * .01;
}

void fragment() {
    // Sample the sprite's original texture
    vec4 original_color = texture(TEXTURE, UV);
    
    // Mix the original color with the overlay color
    vec4 final_color = mix(original_color, overlay_color, overlay_strength);
    
    // Preserve the sprite's original transparency (alpha)
    final_color.a = original_color.a;
    
    // Output the final color to the screen
    COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
