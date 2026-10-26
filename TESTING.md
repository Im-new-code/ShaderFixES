# Testing Notes

## Test run: Initial branch setup

- **Commit:** Pending first branch commit
- **Minecraft:** Java Edition 1.17.1
- **Loader / shader mod:** OptiFine; exact build not recorded here
- **Renderer:** MobileGlues 4.0.0 / GLES 3.2 target
- **Device / GPU:** OPPO A3s / Adreno 506 target
- **Resolution and graphics settings:** Not recorded
- **Scene:** Not tested in game

### Results

- Shader compilation: Not tested
- Emissive overlay loading: Not tested in game
- Visual correctness: Not tested
- FPS / performance: Not measured
- Memory / stability: Not tested

### Static checks performed

- Source structure reviewed against OptiFine's documented composite pipeline and buffer sizing properties.
- Emissive configuration uses the documented `assets/minecraft/optifine/emissive.properties` location and `_e` suffix.
- Overlay PNGs are authored as 16×16 RGBA masks.
- No game launch or shader compiler was available during initial authoring.

### Required in-game checks

- [ ] Shader pack appears and loads without compilation errors.
- [ ] Resource pack loads and emissive overlays align to the 1.17.1 block textures.
- [ ] Torch, soul torch, lantern, soul lantern, glowstone, sea lantern and lava produce a visible but restrained halo.
- [ ] Unlit redstone lamp remains unglowing; lit redstone lamp glows.
- [ ] Sky, white stone, snow, and other non-source objects do not produce unacceptable bloom.
- [ ] No reflections, colored environmental lighting, or smooth-shadow effects have been introduced.
- [ ] Test at the user's usual resolution and render distance; record average FPS and stutter.
- [ ] Verify held items and wall-mounted variants separately.

### Notes

The source-pixel extraction is heuristic, not exact emissive-mask extraction. Bright warm/cyan non-source pixels may bloom. Overlay shapes are initial art and may require UV-alignment edits. Do not describe the shader as verified until the above in-game checks have actually been run.
