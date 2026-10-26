# Emissive Block Glow Shader Pack

This shader pack adds a screen-space bloom pass after the rendered scene. It does not change the lightmap, block-light propagation, or surface shading.

## Pipeline

1. `composite.fsh`: threshold the current scene for bright warm/cyan pixels, suppress sky pixels using depth, and write bloom candidates to half-resolution `colortex3`.
2. `composite1.fsh`: horizontal five-tap blur. It reuses `colortex3` through OptiFine's main/alternate ping-pong buffers.
3. `composite2.fsh`: vertical five-tap blur, again reusing `colortex3`.
4. `final.fsh`: add the blurred halo from `colortex3` to the untouched scene in `colortex0`.

Only one additional color attachment is used, downscaled to 50% in both dimensions, to limit memory and bandwidth costs on constrained devices. The `GLOW_THRESHOLD`, `GLOW_RADIUS`, and `GLOW_STRENGTH` settings are intentionally conservative.

The texture/color heuristic is not an exact emissive-material identifier, so visually inspect for false positives.

Target syntax is conservative GLSL 1.20. The shader has not yet been compiled with the user's OptiFine build or MobileGlues, so API and driver compatibility are unverified.
