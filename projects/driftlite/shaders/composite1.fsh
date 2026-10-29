#version 120
#define DL_BLOOM // Soft, restrained glow around the brightest emissive pixels.

uniform sampler2D colortex3;
varying vec2 texcoord;

/* DRAWBUFFERS:4 */
void main() {
    vec3 scene = texture2D(colortex3, texcoord).rgb;
    float peak = max(scene.r, max(scene.g, scene.b));
    float mask = smoothstep(0.84, 0.99, peak);
    vec3 bright = max(scene - vec3(0.84), vec3(0.0));
    bright *= mask * 0.72;
    gl_FragData[0] = vec4(bright, 1.0);
}
