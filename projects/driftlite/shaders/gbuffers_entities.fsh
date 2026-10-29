#version 120
#define DL_FOG 1
#define DL_COLOR_TUNE 1
uniform sampler2D texture; uniform sampler2D lightmap; uniform float fogStart; uniform float fogEnd; uniform vec3 fogColor;
varying vec2 dlTexCoord; varying vec2 dlLightCoord; varying vec4 dlVertexColor; varying float dlViewDepth;
void main(){
 vec4 texel=texture2D(texture,dlTexCoord)*dlVertexColor; if(texel.a<0.10) discard;
 vec3 color=texel.rgb*texture2D(lightmap,dlLightCoord).rgb;
 #if DL_COLOR_TUNE == 1
 color=mix(color,color*vec3(1.035,1.020,0.985),0.35);
 #endif
 #if DL_FOG == 1
 float s=max(fogStart,0.0); float e=max(fogEnd,s+0.001);
 float f=clamp((dlViewDepth-s)/(e-s),0.0,1.0); f=f*f*(3.0-2.0*f); color=mix(color,fogColor,f);
 #endif
 gl_FragColor=vec4(color,texel.a);
}
