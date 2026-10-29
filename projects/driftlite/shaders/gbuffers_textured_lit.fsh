#version 120
#define DL_HANDHELD_LIGHTS // Add inexpensive light falloff from held light sources.

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;

varying vec2 dlTexCoord;
varying vec2 dlLightCoord;
varying vec4 dlVertexColor;
varying vec3 dlViewPos;

void main() {
    vec4 color = texture2D(gtexture, dlTexCoord) * dlVertexColor;
    if (color.a < 0.10) discard;

    vec2 lightCoord = dlLightCoord;
    #ifdef DL_HANDHELD_LIGHTS
        float heldValue = float(max(heldBlockLightValue, heldBlockLightValue2));
        float heldLight = max((heldValue - length(dlViewPos)) / 15.0, 0.0);
        heldLight = pow(heldLight, 1.65);
        lightCoord.x = max(lightCoord.x, heldLight);
    #endif

    color.rgb *= texture2D(lightmap, lightCoord).rgb;
    gl_FragColor = color;
}
