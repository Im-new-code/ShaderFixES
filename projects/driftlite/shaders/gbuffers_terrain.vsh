#version 120

attribute vec4 mc_Entity;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlViewDepth;
varying float dlMaterial;
varying vec3 dlViewPos;

void main() {
    gl_Position = ftransform();
    dlTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    dlLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
    dlVertexColor = gl_Color;
    dlViewDepth = gl_Position.w;
    dlMaterial = mc_Entity.x;
    dlViewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
}
