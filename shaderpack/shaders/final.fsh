#version 120

#define GLOW_STRENGTH 0.50 // Final glow strength [0.25 0.35 0.50 0.65]

uniform sampler2D colortex0;
uniform sampler2D colortex3;

varying vec2 texcoord;

void main() {
    vec3 scene = texture2D(colortex0, texcoord).rgb;
    vec3 bloom = texture2D(colortex3, texcoord).rgb;
    gl_FragColor = vec4(scene + bloom * GLOW_STRENGTH, 1.0);
}
