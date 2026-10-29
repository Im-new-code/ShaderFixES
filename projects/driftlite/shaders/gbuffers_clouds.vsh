#version 120

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

varying vec2 dlTexCoord;
varying vec4 dlVertexColor;
varying float dlCloudDistance;

void main() {
    // Vanilla cloud rendering can use a model-view transform that differs
    // from the main world pass. Convert through the world-relative frame
    // before projecting clouds with the active gbuffers camera.
    vec3 viewPosition = (gl_ModelViewMatrix * gl_Vertex).xyz;
    vec3 worldRelativePosition =
        (gbufferModelViewInverse * vec4(viewPosition, 1.0)).xyz;

    gl_Position = gl_ProjectionMatrix *
                  gbufferModelView *
                  vec4(worldRelativePosition, 1.0);

    dlTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    dlVertexColor = gl_Color;
    dlCloudDistance = length(worldRelativePosition);
}
