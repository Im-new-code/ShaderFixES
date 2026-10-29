#version 120
#define DL_WATER_TINT // Slight blue-teal tint for clearer-looking water. Very low performance impact.

uniform sampler2D gtexture;
uniform sampler2D lightmap;
varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;

void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    color.rgb *= texture2D(lightmap, dlLightCoord).rgb;

    #ifdef DL_WATER_TINT
        color.rgb *= vec3(0.965, 1.015, 1.055);
        color.rgb = mix(color.rgb, vec3(0.20, 0.48, 0.60), 0.055);
    #endif

    gl_FragColor = color;
}
