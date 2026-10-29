#version 120
#define DL_FOG 1
#define DL_COLOR_TUNE 1

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlViewDepth;

void main() {
    vec4 texel = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    if (texel.a < 0.10) discard;

    vec3 color = texel.rgb * texture2D(lightmap, dlLightCoord).rgb;

    #if DL_COLOR_TUNE == 1
        vec3 warmer = color * vec3(1.075, 1.045, 1.010);
        color = mix(color, warmer, 0.60);
        color = max((color - vec3(0.5)) * 1.06 + vec3(0.5), vec3(0.0));
    #endif

    #if DL_FOG == 1
        float startDistance = max(fogStart, 0.0);
        float endDistance = max(fogEnd, startDistance + 1.0);
        float fogAmount = clamp((max(dlViewDepth, 0.0) - startDistance) / (endDistance - startDistance), 0.0, 1.0);
        fogAmount = fogAmount * fogAmount * (3.0 - 2.0 * fogAmount);
        color = mix(color, fogColor, fogAmount);
    #endif

    gl_FragColor = vec4(color, texel.a);
}
