#version 120
#define DL_FOG // Blend distant terrain into vanilla fog.
#define DL_COLOR_TUNE // Richer daylight colour and contrast.
#define DL_FOLIAGE_TUNE // Slightly enhance green-dominant terrain texels.
#define DL_WORLD_LIGHTING // Subtly reshape lightmap response for more readable lighting.
#define DL_LIGHT_FALLOFF 1.35 // [1.0 1.15 1.25 1.35 1.5 1.65 1.85 2.1 2.4]
#define DL_EMISSIVE_GLOW // Keep mapped light-source blocks bright for optional bloom.
#define DL_HANDHELD_LIGHTS // Add inexpensive light falloff from a held torch-like item.
#define DL_SHADOWS // Lightweight directional shadow map with four-tap filtering.
#define DL_SHADOW_STRENGTH 0.72 // [0.35 0.45 0.55 0.65 0.72 0.80 0.90 1.00]

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D shadowtex0;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlViewDepth;
varying float dlMaterial;
varying vec3 dlViewPos;
varying vec3 dlViewNormal;
varying vec4 dlShadowPos;
varying float dlShadowFacing;

const float DL_SHADOW_MAP_RESOLUTION = 1024.0;

float DL_GetShadowVisibility() {
    if (dlShadowFacing <= 0.0) return 0.0;

    float safeW = abs(dlShadowPos.w) < 0.000001
        ? (dlShadowPos.w < 0.0 ? -0.000001 : 0.000001)
        : dlShadowPos.w;
    vec3 shadowCoord = dlShadowPos.xyz / safeW * 0.5 + 0.5;

    // Out-of-map samples should be lit rather than clamp to the map border.
    if (shadowCoord.x <= 0.001 || shadowCoord.x >= 0.999 ||
        shadowCoord.y <= 0.001 || shadowCoord.y >= 0.999 ||
        shadowCoord.z <= 0.0 || shadowCoord.z >= 1.0) {
        return 1.0;
    }

    float facing = clamp(dlShadowFacing, 0.0, 1.0);
    float bias = 0.00065 + (1.0 - facing) * 0.00115;
    vec2 texel = vec2(1.0 / DL_SHADOW_MAP_RESOLUTION);
    vec2 d = texel * 0.5;

    float visibility = 0.0;
    visibility += step(shadowCoord.z - bias, texture2D(shadowtex0, shadowCoord.xy + vec2(-d.x, -d.y)).r);
    visibility += step(shadowCoord.z - bias, texture2D(shadowtex0, shadowCoord.xy + vec2( d.x, -d.y)).r);
    visibility += step(shadowCoord.z - bias, texture2D(shadowtex0, shadowCoord.xy + vec2(-d.x,  d.y)).r);
    visibility += step(shadowCoord.z - bias, texture2D(shadowtex0, shadowCoord.xy + vec2( d.x,  d.y)).r);
    return visibility * 0.25;
}

void main() {
    vec4 texel = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    if (texel.a < 0.10) discard;

    vec2 lightCoord = dlLightCoord;
    #ifdef DL_WORLD_LIGHTING
        lightCoord = max(lightCoord * 1.06667 - vec2(0.0625), vec2(0.0));
        lightCoord.x = pow(max(lightCoord.x, 0.0), DL_LIGHT_FALLOFF);
    #endif

    #ifdef DL_HANDHELD_LIGHTS
        float heldValue = float(max(heldBlockLightValue, heldBlockLightValue2));
        float heldLight = max((heldValue - length(dlViewPos)) / 15.0, 0.0);
        heldLight = pow(heldLight, 1.65);
        lightCoord.x = max(lightCoord.x, heldLight);
    #endif

    #ifdef DL_SHADOWS
        if (dlShadowFacing > 0.0) {
            float visibility = DL_GetShadowVisibility();
            lightCoord.y *= mix(1.0 - DL_SHADOW_STRENGTH, 1.0, visibility);
        } else {
            // Modest directional fill reduction for back-facing terrain while
            // retaining enough skylight to avoid crushing the shaded side.
            lightCoord.y *= 1.0 - DL_SHADOW_STRENGTH * 0.16;
        }
    #endif

    vec3 color = texel.rgb * texture2D(lightmap, lightCoord).rgb;

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

    #ifdef DL_EMISSIVE_GLOW
        if (abs(dlMaterial - 10008.0) < 0.5) {
            float maxChannel = max(texel.r, max(texel.g, texel.b));
            float emission = smoothstep(0.18, 0.78, maxChannel);
            color = max(color, texel.rgb * (1.00 + 0.42 * emission));
        }
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
