#version 120
#define DL_BLOOM // Soft, restrained glow around the brightest emissive pixels.
#define DL_COLOR_GRADING // Exposure, saturation, vibrance and contrast controls.
#define DL_EXPOSURE 1.00 // [0.75 0.85 0.95 1.00 1.05 1.10 1.20 1.30]
#define DL_SATURATION 1.10 // [0.80 0.90 1.00 1.10 1.20 1.30 1.40]
#define DL_VIBRANCE 1.20 // [0.80 0.90 1.00 1.10 1.20 1.30 1.40]
#define DL_CONTRAST 1.00 // [0.80 0.90 1.00 1.05 1.10 1.20]

uniform sampler2D colortex1;
uniform sampler2D colortex3;
varying vec2 texcoord;

void main() {
    vec3 color = texture2D(colortex1, texcoord).rgb;

    #ifdef DL_BLOOM
        color += texture2D(colortex3, texcoord).rgb * 0.24;
    #endif

    #ifdef DL_COLOR_GRADING
        color *= DL_EXPOSURE;
        float luma = dot(color, vec3(0.2126, 0.7152, 0.0722));
        color = mix(vec3(luma), color, DL_SATURATION);

        float maxChannel = max(color.r, max(color.g, color.b));
        float minChannel = min(color.r, min(color.g, color.b));
        float chroma = maxChannel - minChannel;
        float vibranceFactor = 1.0 + (1.0 - clamp(chroma, 0.0, 1.0)) * (DL_VIBRANCE - 1.0);
        color = mix(vec3(luma), color, vibranceFactor);
        color = max((color - vec3(0.5)) * DL_CONTRAST + vec3(0.5), vec3(0.0));
        // Soft highlight compression prevents bright sun/cloud pixels from
        // turning into large white smears when bloom is enabled.
        color = color / (vec3(1.0) + max(color - vec3(1.0), vec3(0.0)) * 0.35);
    #endif

    gl_FragColor = vec4(color, 1.0);
}
