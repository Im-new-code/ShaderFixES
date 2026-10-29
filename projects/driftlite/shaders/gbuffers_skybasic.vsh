#version 120

varying vec4 dlVertexColor;
varying float dlSkyHeight;

void main() {
    gl_Position = ftransform();
    dlVertexColor = gl_Color;

    // Sky geometry is camera-rotated; this normalized direction gives a
    // cheap view-height factor for a soft haze band around the horizon.
    vec3 viewDirection = (gl_ModelViewMatrix * gl_Vertex).xyz;
    dlSkyHeight = viewDirection.y / max(length(viewDirection), 0.0001);
}
