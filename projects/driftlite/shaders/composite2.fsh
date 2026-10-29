#version 120
#define DL_BLOOM
uniform sampler2D colortex1;
uniform float viewWidth;
uniform float viewHeight;
varying vec2 texcoord;

/* DRAWBUFFERS:2 */
void main() {
    // Nine taps on half-resolution buffers: a soft glow at low cost.
    vec2 stepSize = vec2(2.0 / max(viewWidth, 1.0), 2.0 / max(viewHeight, 1.0));
    vec3 glow = texture2D(colortex1, texcoord).rgb * 0.28;
    glow += texture2D(colortex1, texcoord + vec2(stepSize.x, 0.0)).rgb * 0.12;
    glow += texture2D(colortex1, texcoord - vec2(stepSize.x, 0.0)).rgb * 0.12;
    glow += texture2D(colortex1, texcoord + vec2(0.0, stepSize.y)).rgb * 0.12;
    glow += texture2D(colortex1, texcoord - vec2(0.0, stepSize.y)).rgb * 0.12;
    glow += texture2D(colortex1, texcoord + stepSize).rgb * 0.06;
    glow += texture2D(colortex1, texcoord - stepSize).rgb * 0.06;
    glow += texture2D(colortex1, texcoord + vec2(stepSize.x, -stepSize.y)).rgb * 0.06;
    glow += texture2D(colortex1, texcoord + vec2(-stepSize.x, stepSize.y)).rgb * 0.06;
    gl_FragData[0] = vec4(glow, 1.0);
}
