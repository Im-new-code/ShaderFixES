#version 120
#define DL_SKY_TUNE // Slightly deepen the vanilla sky colour. Very low performance impact.

varying vec4 dlVertexColor;

void main() {
    vec4 color = dlVertexColor;

    #ifdef DL_SKY_TUNE
        float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        color.rgb = mix(vec3(luminance), color.rgb, 1.08);
        color.rgb *= vec3(0.99, 1.00, 1.025);
    #endif

    gl_FragColor = color;
}
