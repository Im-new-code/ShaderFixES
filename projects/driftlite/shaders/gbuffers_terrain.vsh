#version 120
#define DL_SHADOWS // Lightweight directional shadow map with four-tap filtering.
#define DL_SHADOW_STRENGTH 0.72 // [0.35 0.45 0.55 0.65 0.72 0.80 0.90 1.00]

attribute vec4 mc_Entity;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying float dlViewDepth;
varying float dlMaterial;
varying vec3 dlViewPos;
varying vec3 dlViewNormal;
varying vec4 dlShadowPos;
varying float dlShadowFacing;

void main() {
    vec4 viewPosition = gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gl_ProjectionMatrix * viewPosition;

    dlTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    dlLightCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
    dlVertexColor = gl_Color;
    dlViewDepth = gl_Position.w;
    dlMaterial = mc_Entity.x;
    dlViewPos = viewPosition.xyz;
    dlViewNormal = normalize(gl_NormalMatrix * gl_Normal);

    #ifdef DL_SHADOWS
        // Transform the view-space point back into player/world space, then
        // into the light's shadow camera. Projecting in the fragment shader
        // keeps the perspective divide correct for the interpolated position.
        vec4 playerPosition = gbufferModelViewInverse * viewPosition;
        dlShadowPos = shadowProjection * shadowModelView * playerPosition;
        dlShadowFacing = dot(normalize(shadowLightPosition), dlViewNormal);
    #else
        dlShadowPos = vec4(0.0, 0.0, 0.0, 1.0);
        dlShadowFacing = 0.0;
    #endif
}
