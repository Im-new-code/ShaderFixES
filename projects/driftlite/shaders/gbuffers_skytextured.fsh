#version 120
uniform sampler2D gtexture;
varying vec2 dlTexCoord;
varying vec4 dlVertexColor;
void main() {
    gl_FragColor = texture2D(gtexture, dlTexCoord) * dlVertexColor;
}
