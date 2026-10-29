# DriftLite testing record

## Target
- Minecraft Java 1.17.1 + OptiFine
- PojavLauncher / MobileGlues
- Android 8.1 / Qualcomm Adreno 506 / OPPO A3s

## Implemented source features
- [x] World-space sky-ray transform for Flat clouds.
- [x] Two-sample animated 2D cloud noise.
- [x] Depth-aware shoreline foam and blue/teal water tint.
- [x] Two-scale animated water normals with soft directional glints; no reflection ray marching.
- [x] Uploaded World Outline depth-slope method with a finite-depth sky ray and optional chunk fog.
- [x] Outline controls for master switch, thickness, brightness, threshold, near cutoff and distance fade.
- [x] Separate scene-outline, bloom extraction, bloom blur and final composition.
- [x] Adjustable final exposure, saturation, vibrance and contrast.
- [ ] OptiFine 1.17.1 compilation.
- [ ] MobileGlues/GLES compilation.
- [ ] Flat cloud stability during yaw/pitch rotation and player movement.
- [ ] Water normals, foam and depth sampling on beaches, pool edges, rivers and underwater.
- [ ] Outline artifacts on leaves, glass, fences, rails, entities and GUI.
- [ ] Emissive blocks, dropped/held items, hand/offhand lighting.
- [ ] Bloom routing and output brightness.
- [ ] Overworld day/night, caves, rain, Nether and End.
- [ ] FPS/frame-time compared in identical scenes/resolution.

A successful ZIP package is not proof of shader compilation, correctness, compatibility or FPS.
