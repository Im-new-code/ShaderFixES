#version 120
#define DL_FOG // Blend distant terrain into vanilla fog. Very low performance impact.
#define DL_COLOR_TUNE // Richer daylight colour and contrast. Very low performance impact.
#define DL_FOLIAGE_TUNE // Slightly enhance green-dominant terrain texels. Very low performance impact.

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

    #ifdef DL_COLOR_TUNE
        float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
        color = mix(vec3(luminance), color, 1.10);
        color *= vec3(1.035, 1.020, 0.995);
        color = max((color - vec3(0.5)) * 1.055 + vec3(0.5), vec3(0.0));
    #endif

    #ifdef DL_FOLIAGE_TUNE
        float greenDominance = clamp((color.g - max(color.r, color.b)) * 2.0, 0.0, 1.0);
        color.g *= 1.0 + 0.035 * greenDominance;
        color.r *= 1.0 - 0.008 * greenDominance;
    #endif

    #ifdef DL_FOG
        float startDistance = max(fogStart, 0.0);
        float endDistance = max(fogEnd, startDistance + 1.0);
        float fogAmount = clamp((max(dlViewDepth, 0.0) - startDistance) / (endDistance - startDistance), 0.0, 1.0);
        fogAmount = fogAmount * fogAmount * (3.0 - 2.0 * fogAmount);
        color = mix(color, fogColor, fogAmount);
    #endif

    gl_FragColor = vec4(color, texel.a);
}
