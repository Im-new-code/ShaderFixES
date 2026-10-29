#version 120
#define DL_SKY_TUNE // Slightly enrich the vanilla sky colour.
#define DL_SKY_HAZE // Blend blue sky into a soft vanilla-coloured horizon haze.
#define DL_FLAT_CLOUDS // Lightweight texture-noise clouds inspired by the Mellow Flat style.
#define DL_CLOUD_OPACITY 0.82 // [0.40 0.50 0.60 0.70 0.82 0.90 1.00]
#define DL_CLOUD_AMOUNT 0.48 // [0.25 0.32 0.40 0.48 0.56 0.64 0.72]
#define DL_CLOUD_SPEED 1.0 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5]

uniform sampler2D noisetex;
uniform float frameTimeCounter;
uniform float rainStrength;
uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec4 dlVertexColor;
varying vec3 dlViewDirection;
varying float dlSkyHeight;

void main() {
    vec4 color = dlVertexColor;

    #ifdef DL_SKY_TUNE
        float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        color.rgb = mix(vec3(luminance), color.rgb, 1.08);
        color.rgb *= vec3(0.99, 1.00, 1.025);
    #endif

    #ifdef DL_SKY_HAZE
        float blueSky = clamp((color.b - color.r * 0.82) * 2.4, 0.0, 1.0);
        float horizonBand = 1.0 - smoothstep(0.015, 0.30, abs(dlSkyHeight));
        float hazeAmount = horizonBand * blueSky * 0.30;
        vec3 hazeColor = mix(skyColor, fogColor, 0.38);
        color.rgb = mix(color.rgb, hazeColor, hazeAmount);
    #endif

    #ifdef DL_FLAT_CLOUDS
        vec3 ray = normalize(dlViewDirection);
        if (ray.y > -0.035) {
            float projectionDenom = max(ray.y + length(ray.xz) / 6.0, 0.025);
            vec2 cloudPos = ray.xz / projectionDenom;
            cloudPos += cameraPosition.xz / 512.0;
            cloudPos += vec2(frameTimeCounter * 0.012, frameTimeCounter * 0.004) * DL_CLOUD_SPEED;
            cloudPos *= 32.0;

            // Two samples of a compact repeating noise texture. This creates
            // a flat cloud sheet without marching, 3D noise or another pass.
            float baseNoise = texture2D(noisetex, cloudPos / 256.0 * 0.75).r;
            float detailNoise = texture2D(noisetex, cloudPos / 256.0 * 5.0).r;
            float noiseValue = max(baseNoise - detailNoise * 0.10, 0.0);
            float cloudAmount = DL_CLOUD_AMOUNT + rainStrength * 0.16;
            float formation = smoothstep(0.0, 0.40, noiseValue - 0.60 + cloudAmount);
            float density = noiseValue * formation * smoothstep(-0.035, 0.20, ray.y);
            float cloudAlpha = clamp(1.0 - exp(-density * 1.5 * DL_CLOUD_OPACITY), 0.0, 0.92);

            vec3 cloudColor = mix(vec3(0.68, 0.73, 0.82),
                                  vec3(0.98, 0.985, 1.0),
                                  smoothstep(0.18, 0.78, baseNoise));
            cloudColor = mix(cloudColor, fogColor, rainStrength * 0.45);
            color.rgb = mix(color.rgb, cloudColor, cloudAlpha);
        }
    #endif

    gl_FragColor = color;
}
