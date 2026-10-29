#version 120
uniform sampler2D gtexture;
varying vec2 dlTexCoord;
varying vec4 dlVertexColor;
void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    if (color.a < 0.10) discard;
    gl_FragColor = color;
}
