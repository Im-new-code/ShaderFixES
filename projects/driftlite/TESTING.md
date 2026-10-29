# DriftLite testing record

## Target
- Minecraft Java 1.17.1 + OptiFine
- PojavLauncher / MobileGlues
- Android 8.1 / Qualcomm Adreno 506 / OPPO A3s

## Implemented source features
- [x] World-space sky-ray transform for Flat clouds.
- [x] Two-sample animated 2D cloud noise.
- [x] Depth-aware shoreline foam and blue/teal water tint.
- [x] Projection-inverse, symmetric depth outline detector.
- [x] Outline options: master toggle, thickness, brightness, threshold and fade distance.
- [x] Separate scene-outline, bloom extraction, bloom blur and final composition.
- [x] Bloom remains optional and is disabled by the REIMAGINED preset.
- [x] Adjustable final exposure, saturation, vibrance and contrast.
- [x] Workflow validation covers the new program/texture files.

## Still unverified in-game
- [ ] OptiFine 1.17.1 compilation.
- [ ] MobileGlues/GLES compilation.
- [ ] Flat cloud stability during yaw/pitch rotation and player movement.
- [ ] Flat-cloud blend with sun/moon and weather.
- [ ] Shore foam on beaches, pool edges, rivers, underwater and at night.
- [ ] Outline artifacts on leaves, transparent glass, fences, rails, entities and GUI.
- [ ] Emissive blocks and held torch lighting.
- [ ] Bloom threshold and half-resolution routing.
- [ ] Overworld day/night, caves, rain, Nether and End.
- [ ] FPS/frame-time compared in the same scene and resolution.

A successful ZIP package is not proof of shader compilation, correctness, compatibility or FPS.
