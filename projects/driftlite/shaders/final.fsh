#version 120
#define DL_BLOOM // Low-resolution glow around bright mapped light sources.

uniform sampler2D colortex0;
uniform sampler2D colortex2;
varying vec2 texcoord;

void main() {
    vec3 scene = texture2D(colortex0, texcoord).rgb;
    #ifdef DL_BLOOM
        vec3 glow = texture2D(colortex2, texcoord).rgb;
        scene += glow * 0.72;
    #endif
    gl_FragColor = vec4(scene, 1.0);
}
