#version 120

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlViewDepth;
varying vec3 dlViewPos;

void main() {
    gl_Position = ftransform();
    dlTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    dlLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
    dlVertexColor = gl_Color;
    dlViewDepth = gl_Position.w;
    dlViewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
}
