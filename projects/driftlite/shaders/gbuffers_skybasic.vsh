#version 120
varying vec4 dlVertexColor;

void main() {
    gl_Position = ftransform();
    dlVertexColor = gl_Color;
}
