# DriftLite testing record

## Target
- Minecraft Java 1.17.1
- OptiFine 1.17.1
- PojavLauncher / MobileGlues
- Android 8.1 / Qualcomm Adreno 506 / OPPO A3s

## Source features added
- [x] Terrain/entity colour tuning and foliage tint.
- [x] Water tint and sky/horizon haze options.
- [x] Mellow-style 2D Flat cloud layer with a credited MIT noise asset.
- [x] Mapped emissive block treatment using block.properties.
- [x] Heuristic glow treatment for warm/cool item texture pixels.
- [x] Held-item light falloff using OptiFine uniforms.
- [x] Lightmap coordinate shaping and adjustable torch falloff.
- [x] Optional half-resolution bloom extraction/blur and profiles.
- [x] Workflow checks expanded to cover the new files/assets.
- [ ] Set Minecraft Clouds to Off and verify no Fast clouds appear over the custom layer.
- [ ] OptiFine 1.17.1 option parsing and shader compilation checked.
- [ ] MobileGlues/GLES compilation checked.
- [ ] Flat clouds assessed for banding, orientation and time animation in-game.
- [ ] Torches, lanterns, glowstone, lava and emissive items assessed in-game.
- [ ] Main-hand/off-hand light falloff assessed in-game.
- [ ] Bloom artifacts/brightness and framebuffer routing checked in-game.
- [ ] Day/night, rain, caves, water, Nether and End tested.
- [ ] FPS/frame time measured against vanilla and prior build in the same scene/resolution.

A successful ZIP package is not proof of shader compilation, correctness, compatibility or performance on the target phone.
