#version 120
#define DL_BLOOM // Soft, restrained glow around the brightest emissive pixels.

uniform sampler2D colortex1;
uniform sampler2D colortex3;
varying vec2 texcoord;

void main() {
    vec3 scene = texture2D(colortex1, texcoord).rgb;
    #ifdef DL_BLOOM
        vec3 glow = texture2D(colortex3, texcoord).rgb;
        scene += glow * 0.24;
    #endif
    gl_FragColor = vec4(scene, 1.0);
}
