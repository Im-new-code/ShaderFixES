#version 120
#define DL_BLOOM // Low-resolution glow around bright mapped light sources.

uniform sampler2D colortex0;
varying vec2 texcoord;

/* DRAWBUFFERS:1 */
void main() {
    vec3 scene = texture2D(colortex0, texcoord).rgb;
    float peak = max(scene.r, max(scene.g, scene.b));
    float threshold = smoothstep(0.72, 0.98, peak);
    vec3 bright = max(scene - vec3(0.72), vec3(0.0));
    bright *= threshold * 1.65;
    gl_FragData[0] = vec4(bright, 1.0);
}
