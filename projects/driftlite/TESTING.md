# DriftLite testing record

## Target
- Minecraft Java 1.17.1 + OptiFine
- PojavLauncher / MobileGlues
- Android 8.1 / Qualcomm Adreno 506 / OPPO A3s

## Implemented source features
- [x] World-space per-pixel sky-ray reconstruction for the sky gradient and horizon haze.
- [x] Angular world-ray cloud mapping to avoid high-derivative plane-projection streaks.
- [x] Animated 2D cloud shape with separate low-frequency coverage and higher-frequency detail noise.
- [x] Sun sprite dimming and warm tint with a bright-pixel fallback for imperfect sky-matrix alignment.
- [x] Depth-aware shoreline foam and blue/teal water tint.
- [x] Two-scale animated water normals with soft directional glints; no reflection ray marching.
- [x] Uploaded World Outline depth-slope method with a finite-depth sky ray and optional chunk fog.
- [x] Outline controls for master switch, thickness, brightness, threshold, near cutoff and distance fade.
- [x] Separate scene-outline, bloom extraction, bloom blur and final composition.
- [x] Bloom extraction uses both peak brightness and luminance to reduce broad blue-sky bloom.
- [x] Adjustable final exposure, saturation, vibrance and contrast.
- [ ] OptiFine 1.17.1 compilation.
- [ ] MobileGlues/GLES compilation.
- [ ] Verify angular cloud stability across yaw/pitch rotation and player movement.
- [ ] Verify softened sun, cloud coverage, and horizon gradient in game.
- [ ] Water normals, foam and depth sampling on beaches, pool edges, rivers and underwater.
- [ ] Outline artifacts on leaves, glass, fences, rails, entities and GUI.
- [ ] Emissive blocks, dropped/held items, hand/offhand lighting.
- [ ] Bloom routing and output brightness.
- [ ] Overworld day/night, caves, rain, Nether and End.
- [ ] FPS/frame-time compared in identical scenes/resolution.

A successful ZIP package is not proof of shader compilation, correctness, compatibility or FPS. The CI job checks source structure and packaging only unless a GLSL compiler step explicitly passes.


## Directional shadow pass
- [x] Alpha-tested shadow pass source, excluding water from shadow casting.
- [x] Terrain shadow-coordinate transform and four-tap depth comparison filter.
- [x] Shadow resolution/distance and strength controls, with shadows disabled in POTATO profile.
- [ ] Verify bias, shadow direction, vegetation cutouts, shadow distance and frame-time in OptiFine 1.17.1 on MobileGlues.
