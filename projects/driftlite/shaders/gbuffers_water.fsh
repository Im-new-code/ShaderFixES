#version 120
#define DL_WATER_TINT // Complementary-inspired turquoise water colour.
#define DL_WATER_FOAM // Soft, broken shoreline foam from scene-depth and world noise.
#define DL_WATER_NORMALS // Animated noise-based ripples; no reflections.
#define DL_FOAM_STRENGTH 0.85 // [0.0 0.25 0.5 0.65 0.85 1.0 1.25 1.5]
#define DL_WATER_NORMAL_STRENGTH 1.0 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 2.0]

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
uniform float viewWidth;
uniform float viewHeight;
uniform float frameTimeCounter;
uniform float rainStrength;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlMaterial;
varying vec3 dlWorldPos;
varying vec3 dlWorldNormal;

vec3 ReconstructViewPos(vec2 uv, float depth) {
    vec4 p = gbufferProjectionInverse * vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    float safeW = abs(p.w) < 0.000001 ? (p.w < 0.0 ? -0.000001 : 0.000001) : p.w;
    return p.xyz / safeW;
}

vec2 GetWaterNoise(vec2 coords) {
    // Two-scale, world-anchored noise normal inspired by Mellow's low-cost
    // water treatment. It perturbs highlights only; no ray-marched reflections.
    coords /= 64.0;
    vec2 n = (texture2D(noisetex, (coords + frameTimeCounter * 0.15) / 24.0).yz * 2.0 - 1.0) * 0.05;
    n += (texture2D(noisetex, (coords - frameTimeCounter * 0.60) / 64.0).yz * 2.0 - 1.0) * 0.10;
    return n * DL_WATER_NORMAL_STRENGTH;
}

void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    color.rgb *= texture2D(lightmap, dlLightCoord).rgb;

    if (abs(dlMaterial - 10001.0) < 0.5) {
        vec2 screenUV = gl_FragCoord.xy / vec2(max(viewWidth, 1.0), max(viewHeight, 1.0));
        float waterDistance = length(ReconstructViewPos(screenUV, gl_FragCoord.z));
        float opaqueDepth = texture2D(depthtex0, screenUV).r;
        float gap = 1000.0;
        float shore = 0.0;

        if (opaqueDepth < 0.99999) {
            float opaqueDistance = length(ReconstructViewPos(screenUV, opaqueDepth));
            gap = max(opaqueDistance - waterDistance, 0.0);
            shore = 1.0 - smoothstep(0.18, 1.15, gap);
        }

        float topSurface = smoothstep(0.35, 0.85, abs(dlWorldNormal.y));

        #ifdef DL_WATER_TINT
            float deepWater = smoothstep(1.0, 7.0, gap);
            color.rgb *= vec3(0.94, 1.02, 1.08);
            color.rgb = mix(color.rgb, vec3(0.055, 0.31, 0.48), deepWater * 0.32);
        #endif

        #ifdef DL_WATER_NORMALS
            vec2 wave = GetWaterNoise(dlWorldPos.xz);
            vec3 rippleNormal = normalize(dlWorldNormal + vec3(wave.x, 0.0, wave.y) * topSurface);
            vec3 sunWorld = normalize(mat3(gbufferModelViewInverse) * sunPosition);
            float diffuse = max(dot(rippleNormal, sunWorld), 0.0);
            float glint = pow(diffuse, 14.0) * topSurface * (1.0 - rainStrength * 0.65);
            color.rgb *= 0.96 + diffuse * 0.08 * topSurface;
            color.rgb += vec3(0.13, 0.18, 0.22) * glint * 0.20;
        #endif

        #ifdef DL_WATER_FOAM
            vec2 foamUV = dlWorldPos.xz * 0.055;
            float foamNoiseA = texture2D(noisetex, foamUV + vec2(frameTimeCounter * 0.012, frameTimeCounter * 0.008)).r;
            float foamNoiseB = texture2D(noisetex, foamUV * 1.73 - vec2(frameTimeCounter * 0.007, frameTimeCounter * 0.011)).r;
            float brokenFoam = smoothstep(0.28, 0.69, foamNoiseA * 0.72 + foamNoiseB * 0.28);
            float foam = shore * brokenFoam * DL_FOAM_STRENGTH * (1.0 - rainStrength * 0.18) * topSurface;
            color.rgb = mix(color.rgb, vec3(0.78, 0.91, 0.96), clamp(foam * 0.80, 0.0, 1.0));
            color.a = max(color.a, clamp(foam * 0.70, 0.0, 0.85));
        #endif
    }

    gl_FragColor = color;
}
