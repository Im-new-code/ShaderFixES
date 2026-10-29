#version 120
uniform sampler2D texture; varying vec2 dlTexCoord; varying vec4 dlVertexColor;
void main(){ vec4 c=texture2D(texture,dlTexCoord)*dlVertexColor; if(c.a<0.10) discard; gl_FragColor=c; }
