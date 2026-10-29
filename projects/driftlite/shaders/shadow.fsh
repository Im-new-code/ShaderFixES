#version 120
uniform sampler2D gtexture;

varying vec2 dlShadowTexCoord;
varying vec4 dlShadowColor;

void main() {
    // Preserve alpha cutouts for leaves, grass, flowers and other foliage.
    vec4 texel = texture2D(gtexture, dlShadowTexCoord) * dlShadowColor;
    if (texel.a < 0.10) discard;
}
