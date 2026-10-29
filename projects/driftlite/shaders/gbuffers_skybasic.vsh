#version 120

varying vec4 dlVertexColor;
varying vec3 dlViewDirection;
varying float dlSkyHeight;

void main() {
    gl_Position = ftransform();
    dlVertexColor = gl_Color;
    dlViewDirection = (gl_ModelViewMatrix * gl_Vertex).xyz;
    dlSkyHeight = dlViewDirection.y / max(length(dlViewDirection), 0.0001);
}
