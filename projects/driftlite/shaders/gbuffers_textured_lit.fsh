#version 120
#define DL_WORLD_LIGHTING // Subtly reshape lightmap response.
#define DL_LIGHT_FALLOFF 1.35 // [1.0 1.15 1.25 1.35 1.5 1.65 1.85 2.1 2.4]
#define DL_HANDHELD_LIGHTS // Add inexpensive light falloff from held light sources.
#define DL_ITEM_GLOW // Heuristic emission for vivid warm/cool item texture pixels.

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying vec3 dlViewPos;

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

    vec3 color = texel.rgb * texture2D(lightmap, lightCoord).rgb;
    #ifdef DL_ITEM_GLOW
        float maxChannel = max(texel.r, max(texel.g, texel.b));
        float warm = smoothstep(0.12, 0.34, texel.r - texel.b * 0.55) * smoothstep(0.26, 0.62, maxChannel);
        float cool = smoothstep(0.10, 0.30, texel.b - texel.r * 0.55) * smoothstep(0.28, 0.64, maxChannel);
        float emission = max(warm, cool * 0.65);
        color += texel.rgb * emission * 0.42;
    #endif
    gl_FragColor = vec4(color, texel.a);
}
