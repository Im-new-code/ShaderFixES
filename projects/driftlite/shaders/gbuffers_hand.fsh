#version 120
#define DL_ITEM_GLOW // Heuristic emission for vivid torch/lava-like item textures.

uniform sampler2D gtexture;
uniform sampler2D lightmap;
varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;

void main() {
    vec4 texel = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    if (texel.a < 0.10) discard;

    vec3 color = texel.rgb * texture2D(lightmap, dlLightCoord).rgb;

    #ifdef DL_ITEM_GLOW
        float maxChannel = max(texel.r, max(texel.g, texel.b));
        float warm = smoothstep(0.12, 0.34, texel.r - texel.b * 0.55) * smoothstep(0.26, 0.62, maxChannel);
        float cool = smoothstep(0.10, 0.30, texel.b - texel.r * 0.55) * smoothstep(0.28, 0.64, maxChannel);
        float emission = max(warm, cool * 0.65);
        color += texel.rgb * emission * 0.42;
    #endif

    gl_FragColor = vec4(color, texel.a);
}
