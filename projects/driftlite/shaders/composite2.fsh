#version 120
#define DL_BLOOM
uniform sampler2D colortex4;
uniform float viewWidth;
uniform float viewHeight;
varying vec2 texcoord;

/* DRAWBUFFERS:5 */
void main() {
    vec2 stepSize = vec2(2.0 / max(viewWidth, 1.0), 2.0 / max(viewHeight, 1.0));
    vec3 glow = texture2D(colortex4, texcoord).rgb * 0.28;
    glow += texture2D(colortex4, texcoord + vec2(stepSize.x, 0.0)).rgb * 0.10;
    glow += texture2D(colortex4, texcoord - vec2(stepSize.x, 0.0)).rgb * 0.10;
    glow += texture2D(colortex4, texcoord + vec2(0.0, stepSize.y)).rgb * 0.10;
    glow += texture2D(colortex4, texcoord - vec2(0.0, stepSize.y)).rgb * 0.10;
    glow += texture2D(colortex4, texcoord + stepSize).rgb * 0.08;
    glow += texture2D(colortex4, texcoord - stepSize).rgb * 0.08;
    glow += texture2D(colortex4, texcoord + vec2(stepSize.x, -stepSize.y)).rgb * 0.08;
    glow += texture2D(colortex4, texcoord + vec2(-stepSize.x, stepSize.y)).rgb * 0.08;
    gl_FragData[0] = vec4(glow, 1.0);
}
