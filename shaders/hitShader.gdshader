    shader_type canvas_item;

    uniform float white_progress : hint_range(0,1) = 0; // For flashing effects

    void fragment() {
        vec4 origin = texture(TEXTURE, UV);
        // This will blend between the original color and white
        COLOR.rgb = mix(origin.rgb, vec3(1,1,1), white_progress);
        COLOR.a = origin.a; // Keep the original alpha
    }