#version 120
#define DL_SKY_TUNE // Slightly enrich the vanilla sky colour.
#define DL_SKY_HAZE // Blend blue sky into a soft vanilla-coloured horizon haze.

uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec4 dlVertexColor;
varying float dlSkyHeight;

void main() {
    vec4 color = dlVertexColor;

    #ifdef DL_SKY_TUNE
        float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        color.rgb = mix(vec3(luminance), color.rgb, 1.08);
        color.rgb *= vec3(0.99, 1.00, 1.025);
    #endif

    #ifdef DL_SKY_HAZE
        // Affect blue-dominant sky only, preserving white stars and dark void.
        float blueSky = clamp((color.b - color.r * 0.82) * 2.4, 0.0, 1.0);
        float horizonBand = 1.0 - smoothstep(0.015, 0.30, abs(dlSkyHeight));
        float hazeAmount = horizonBand * blueSky * 0.30;
        vec3 hazeColor = mix(skyColor, fogColor, 0.38);
        color.rgb = mix(color.rgb, hazeColor, hazeAmount);
    #endif

    gl_FragColor = color;
}
