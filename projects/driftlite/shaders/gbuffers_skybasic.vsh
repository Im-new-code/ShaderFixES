#version 120
uniform mat4 gbufferModelViewInverse;

varying vec4 dlVertexColor;
varying vec3 dlWorldDirection;

void main() {
    gl_Position = ftransform();
    dlVertexColor = gl_Color;

    // Undo the camera rotation before passing the ray to the cloud shader.
    // Using view-space directions here makes the cloud texture slide as the
    // camera turns; world-space directions keep the cloud sheet anchored.
    vec3 viewDirection = (gl_ModelViewMatrix * gl_Vertex).xyz;
    dlWorldDirection = mat3(gbufferModelViewInverse) * viewDirection;
}
