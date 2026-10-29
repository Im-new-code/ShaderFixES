#version 120
attribute vec4 mc_Entity;

varying vec2 dlShadowTexCoord;
varying vec4 dlShadowColor;

void main() {
    dlShadowTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    dlShadowColor = gl_Color;

    // Water is translucent and should not become an opaque shadow-casting sheet.
    if (abs(mc_Entity.x - 10001.0) < 0.5) {
        gl_Position = vec4(2.0, 2.0, 2.0, 1.0);
    } else {
        gl_Position = ftransform();
    }
}
