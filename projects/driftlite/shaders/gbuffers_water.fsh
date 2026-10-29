#version 120
uniform sampler2D texture; uniform sampler2D lightmap; varying vec2 dlTexCoord; varying vec2 dlLightCoord; varying vec4 dlVertexColor;
void main(){ vec4 c=texture2D(texture,dlTexCoord)*dlVertexColor; c.rgb*=texture2D(lightmap,dlLightCoord).rgb; gl_FragColor=c; }
