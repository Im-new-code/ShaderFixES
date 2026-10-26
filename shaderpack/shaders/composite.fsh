#version 120

#define GLOW_THRESHOLD 0.68 // Bright-pixel threshold [0.60 0.64 0.68 0.74 0.80]
#define GLOW_PALETTE_FILTER // Limit glow candidates to warm/cyan source colors

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

varying vec2 texcoord;

void main() {
    vec3 scene = texture2D(colortex0, texcoord).rgb;
    float depth = texture2D(depthtex0, texcoord).r;

    float luminance = dot(scene, vec3(0.2126, 0.7152, 0.0722));
    float bright = smoothstep(GLOW_THRESHOLD, GLOW_THRESHOLD + 0.12, luminance);

    // Keep the sky from producing a full-screen bloom veil.
    float geometryMask = 1.0 - smoothstep(0.9990, 1.0, depth);

    float sourceMask = 1.0;
#ifdef GLOW_PALETTE_FILTER
    // These are post-process selection heuristics, not colored lighting.
    float warm = smoothstep(0.04, 0.20, scene.r - scene.b)
               * smoothstep(0.02, 0.16, scene.g - scene.b);
    float cyan = smoothstep(0.015, 0.16, scene.b - scene.r)
               * smoothstep(0.01, 0.14, scene.g - scene.r);
    sourceMask = max(warm, cyan);
#endif

    vec3 glow = scene * bright * geometryMask * sourceMask;

    /* DRAWBUFFERS:34 */
    gl_FragData[0] = vec4(scene, 1.0);
    gl_FragData[1] = vec4(glow, 1.0);
}
