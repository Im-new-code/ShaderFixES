#version 120

uniform sampler2D gtexture;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 fogColor;

varying vec2 dlTexCoord;
varying vec4 dlVertexColor;
varying float dlCloudDistance;

void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    if (color.a < 0.10) discard;

    float endDistance = max(fogEnd, fogStart + 1.0);
    float fogAmount = clamp(
        (dlCloudDistance - max(fogStart, 0.0)) /
        (endDistance - max(fogStart, 0.0)),
        0.0,
        1.0
    );
    fogAmount = fogAmount * fogAmount * (3.0 - 2.0 * fogAmount);
    color.rgb = mix(color.rgb, fogColor, fogAmount);

    gl_FragColor = color;
}
