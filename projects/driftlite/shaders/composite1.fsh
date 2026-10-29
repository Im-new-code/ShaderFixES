#version 120
#define DL_BLOOM // Soft, restrained glow around bright highlights.

uniform sampler2D colortex3;
varying vec2 texcoord;

/* DRAWBUFFERS:4 */
void main() {
    vec3 scene = texture2D(colortex3, texcoord).rgb;
    float peak = max(scene.r, max(scene.g, scene.b));
    float luminance = dot(scene, vec3(0.2126, 0.7152, 0.0722));

    // Use both peak and luminance so saturated blue sky is less likely to
    // create a broad washed-out halo, while bright sun and light sources glow.
    float peakMask = smoothstep(0.82, 1.08, peak);
    float luminanceMask = smoothstep(0.68, 0.96, luminance);
    float mask = peakMask * luminanceMask;
    vec3 bright = max(scene - vec3(0.76), vec3(0.0));
    bright *= mask * 0.78;
    gl_FragData[0] = vec4(bright, 1.0);
}
