#version 120
varying vec2 dlTexCoord; varying vec2 dlLightCoord; varying vec4 dlVertexColor;
void main(){ gl_Position=ftransform(); dlTexCoord=gl_MultiTexCoord0.st; dlLightCoord=gl_MultiTexCoord1.st; dlVertexColor=gl_Color; }
