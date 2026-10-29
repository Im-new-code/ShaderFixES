#version 120
#define WORLD_OUTLINE // Depth-based world outlines inspired by the uploaded World Outline Shader.
#define WORLD_OUTLINE_THICKNESS 2.0 // [1.0 1.5 2.0 2.5 3.0 4.0]
#define WORLD_OUTLINE_I 1.15 // [0.25 0.5 0.75 1.0 1.15 1.5 2.0 2.5]
#define WORLD_OUTLINE_DISTANCE_FADE 192.0 // [32.0 64.0 96.0 128.0 192.0 256.0 384.0 512.0]
#define WORLD_OUTLINE_THRESHOLD 3.0 // [1.0 1.5 2.0 2.5 3.0 3.5 4.0 5.0]

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform vec3 fogColor;

varying vec2 texcoord;

float ReconstructDistance(vec2 uv, float depth) {
    if (depth >= 0.999999) return 1e6;
    vec4 p = gbufferProjectionInverse * vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    return length(p.xyz / max(abs(p.w), 0.00001));
}

/* DRAWBUFFERS:1 */
void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;
    float centerDepth = texture2D(depthtex0, texcoord).r;

    // Keep sky pixels free of geometry outlines. Blend a small haze band to
    // reduce the hard terrain/sky seam, using the inverse view rotation.
    if (centerDepth >= 0.999999) {
        vec4 viewPos = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, 1.0, 1.0);
        vec3 worldDir = normalize(mat3(gbufferModelViewInverse) * normalize(viewPos.xyz / max(abs(viewPos.w), 0.00001)));
        float horizon = pow(clamp(1.0 - abs(worldDir.y), 0.0, 1.0), 3.0);
        vec3 haze = fogColor;
        if (dot(haze, vec3(1.0)) < 0.01) haze = vec3(0.62, 0.76, 0.94);
        color = mix(color, haze, horizon * 0.20);
        gl_FragData[0] = vec4(color, 1.0);
        return;
    }

    float centerDistance = ReconstructDistance(texcoord, centerDepth);

    #ifdef WORLD_OUTLINE
        if (centerDistance > 0.5) {
            vec2 px = vec2(1.0 / max(viewWidth, 1.0), 1.0 / max(viewHeight, 1.0)) * WORLD_OUTLINE_THICKNESS;
            float edgeSignal = 0.0;

            // Symmetric sampling avoids the directional bias and edge wash
            // of the older corner-only outline detector.
            vec2 offsets[8];
            offsets[0] = vec2( 1.0, 0.0);
            offsets[1] = vec2(-1.0, 0.0);
            offsets[2] = vec2( 0.0, 1.0);
            offsets[3] = vec2( 0.0,-1.0);
            offsets[4] = vec2( 1.0, 1.0);
            offsets[5] = vec2(-1.0, 1.0);
            offsets[6] = vec2( 1.0,-1.0);
            offsets[7] = vec2(-1.0,-1.0);

            for (int i = 0; i < 8; ++i) {
                vec2 sampleUV = clamp(texcoord + offsets[i] * px, vec2(0.001), vec2(0.999));
                float sampleDepth = texture2D(depthtex0, sampleUV).r;
                float sampleDistance = ReconstructDistance(sampleUV, sampleDepth);
                float relativeDifference;
                if (sampleDistance > 1e5) {
                    relativeDifference = 1.0;
                } else {
                    relativeDifference = abs(sampleDistance - centerDistance) / max(centerDistance, 1.0);
                }
                edgeSignal = max(edgeSignal, relativeDifference);
            }

            float thresholdLow = 0.0015 * WORLD_OUTLINE_THRESHOLD;
            float thresholdHigh = 0.0060 * WORLD_OUTLINE_THRESHOLD;
            float edge = smoothstep(thresholdLow, thresholdHigh, edgeSignal);
            float distanceFade = 1.0 - smoothstep(WORLD_OUTLINE_DISTANCE_FADE * 0.70,
                                                  WORLD_OUTLINE_DISTANCE_FADE,
                                                  centerDistance);
            float outline = edge * distanceFade * WORLD_OUTLINE_I;

            // Hue-preserving highlight rather than a black ink border.
            color += min(color * outline * 0.38, vec3(outline * 0.22));
        }
    #endif

    gl_FragData[0] = vec4(color, 1.0);
}
