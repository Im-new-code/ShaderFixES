// Screen-space outline detection.
// Uses a median of four gathered depth samples so one off-surface sample
// cannot dominate the edge test. The comparison stays in raw depth space to
// avoid multiple depth-linearization divisions on the full-screen pass.
vec3 get_outline(vec3 Color, vec3 ScreenPos, bool IsDH) {
    if (ScreenPos.z >= 0.999999) return Color;

    const ivec2[4] Offsets = ivec2[4](
        ivec2(-1,-1) * OUTLINE_THICKNESS,
        ivec2(-1, 1) * OUTLINE_THICKNESS,
        ivec2(1, -1) * OUTLINE_THICKNESS,
        ivec2(1, 1) * OUTLINE_THICKNESS
    );

    vec4 DepthSamples = textureGatherOffsets(depthtex0, texcoord, Offsets);
    #ifdef DISTANT_HORIZONS
        if (IsDH) {
            DepthSamples = textureGatherOffsets(dhDepthTex0, texcoord, Offsets);
        }
    #endif

    // Treat sky/far-plane samples as the center depth. This avoids false
    // outlines where a wall's gather footprint crosses into the sky.
    DepthSamples = mix(
        DepthSamples,
        vec4(ScreenPos.z),
        step(vec4(0.999999), DepthSamples)
    );

    float MinAB = min(DepthSamples.x, DepthSamples.y);
    float MaxAB = max(DepthSamples.x, DepthSamples.y);
    float MinCD = min(DepthSamples.z, DepthSamples.w);
    float MaxCD = max(DepthSamples.z, DepthSamples.w);

    // Median of four values: robust against a single depth outlier.
    float DepthMedian = 0.5 * (max(MinAB, MinCD) + min(MaxAB, MaxCD));

    // Equivalent first-order depth-space threshold to the original
    // linear-depth threshold, without linearizing every gathered sample.
    float DepthDelta = DepthMedian - ScreenPos.z;
    float DepthThreshold = 0.0009 * near * OUTLINE_THRESHOLD
        * (1.0 - DepthMedian) / max(1.0 - ScreenPos.z, 0.000001);

    if (DepthDelta > DepthThreshold) {
        Color *= OUTLINE_BRIGHTNESS;
    }

    return Color;
}
