#version 120
attribute vec4 mc_Entity;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlMaterial;
varying vec3 dlWorldPos;
varying vec3 dlWorldNormal;

void main() {
    gl_Position = ftransform();
    dlTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    dlLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
    dlVertexColor = gl_Color;
    dlMaterial = mc_Entity.x;

    vec3 viewPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;
    dlWorldPos = (gbufferModelViewInverse * vec4(viewPosition, 1.0)).xyz + cameraPosition;
    dlWorldNormal = normalize(mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal));
}
