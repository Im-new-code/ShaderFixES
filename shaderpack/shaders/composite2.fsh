#version 120

#define GLOW_RADIUS 1.0 // Blur radius [0.75 1.00 1.25]

uniform sampler2D colortex3;
uniform float viewHeight;

varying vec2 texcoord;

void main() {
    // colortex3 is half-resolution, so one texel is approximately 2/viewHeight.
    vec2 stepUV = vec2(0.0, (2.0 * GLOW_RADIUS) / viewHeight);

    vec3 blur = texture2D(colortex3, texcoord).rgb * 0.40;
    blur += texture2D(colortex3, texcoord + stepUV).rgb * 0.24;
    blur += texture2D(colortex3, texcoord - stepUV).rgb * 0.24;
    blur += texture2D(colortex3, texcoord + stepUV * 2.0).rgb * 0.06;
    blur += texture2D(colortex3, texcoord - stepUV * 2.0).rgb * 0.06;

    /* DRAWBUFFERS:3 */
    gl_FragData[0] = vec4(blur, 1.0);
}
