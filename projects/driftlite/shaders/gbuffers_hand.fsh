#version 120
uniform sampler2D gtexture;
uniform sampler2D lightmap;
varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    if (color.a < 0.10) discard;
    color.rgb *= texture2D(lightmap, dlLightCoord).rgb;
    gl_FragColor = color;
}
