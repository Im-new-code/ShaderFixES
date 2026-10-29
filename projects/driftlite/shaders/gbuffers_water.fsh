#version 120
#define DL_WATER_TINT // Complementary-inspired turquoise water colour.
#define DL_WATER_FOAM // Soft, broken shoreline foam from scene-depth and world noise.

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;
uniform mat4 gbufferProjectionInverse;
uniform float viewWidth;
uniform float viewHeight;
uniform float frameTimeCounter;
uniform float rainStrength;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlMaterial;
varying vec3 dlWorldPos;

vec3 ReconstructViewPos(vec2 uv, float depth) {
    vec4 p = gbufferProjectionInverse * vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    return p.xyz / max(abs(p.w), 0.00001) * sign(p.w);
}

void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    color.rgb *= texture2D(lightmap, dlLightCoord).rgb;

    // Only alter mapped water blocks. Other translucent materials retain
    // their vanilla sampling and alpha.
    if (abs(dlMaterial - 10001.0) < 0.5) {
        float waterDistance = length(ReconstructViewPos(
            gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z));

        float opaqueDepth = texture2D(depthtex0, gl_FragCoord.xy / vec2(viewWidth, viewHeight)).r;
        float shore = 0.0;
        if (opaqueDepth < 0.99999) {
            float opaqueDistance = length(ReconstructViewPos(
                gl_FragCoord.xy / vec2(viewWidth, viewHeight), opaqueDepth));
            float gap = max(opaqueDistance - waterDistance, 0.0);
            shore = 1.0 - smoothstep(0.18, 1.15, gap);
        }

        #ifdef DL_WATER_TINT
            float depthTint = smoothstep(0.1, 7.0, shore > 0.5 ? 0.0 : 2.0);
            color.rgb *= vec3(0.94, 1.02, 1.08);
            color.rgb = mix(color.rgb, vec3(0.055, 0.31, 0.48), 0.20 * (1.0 - depthTint));
        #endif

        #ifdef DL_WATER_FOAM
            vec2 foamUV = dlWorldPos.xz * 0.055;
            float foamNoiseA = texture2D(noisetex, foamUV + vec2(frameTimeCounter * 0.012, frameTimeCounter * 0.008)).r;
            float foamNoiseB = texture2D(noisetex, foamUV * 1.73 - vec2(frameTimeCounter * 0.007, frameTimeCounter * 0.011)).r;
            float brokenFoam = smoothstep(0.28, 0.69, foamNoiseA * 0.72 + foamNoiseB * 0.28);
            float foam = shore * brokenFoam * (1.0 - rainStrength * 0.18);
            color.rgb = mix(color.rgb, vec3(0.78, 0.91, 0.96), foam * 0.80);
            color.a = max(color.a, foam * 0.70);
        #endif
    }

    gl_FragColor = color;
}
