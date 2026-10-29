#version 120
varying vec2 dlTexCoord;
varying vec4 dlVertexColor;
void main() {
    gl_Position = ftransform();
    dlTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    dlVertexColor = gl_Color;
}
