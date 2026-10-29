# DriftLite: Mellow-based techniques, Complementary-inspired look

DriftLite is a separate OptiFine-format shader experiment for Minecraft Java 1.17.1, focused first on correct rendering and a polished visual style. The target runtime is PojavLauncher + OptiFine + MobileGlues on Android 8.1 / Adreno 506, but the pack still needs on-device shader compilation and visual verification.

## What changed

- **World-anchored Flat clouds:** sky rays are transformed back into world space before the Mellow-style 2D noise projection. The cloud sheet should no longer slide when the player rotates their head.
- **Shoreline foam:** water samples the existing opaque depth and a world-anchored noise texture to create broken foam along shallow intersections. Water is tinted toward a deeper turquoise/blue without reflections.
- **World outlines:** the supplied World Outline Shader source informed an outline pass using projection-inverse view-distance reconstruction and symmetric depth taps. Threshold, thickness, brightness and distance fade are exposed as options.
- **Lighting:** mapped torch/lantern/glowstone and related blocks receive an emissive treatment. Handheld light falloff and item glow are optional. These do not create physically correct coloured light propagation.
- **Bloom:** optional high-threshold extraction plus a nine-tap half-resolution blur. It is deliberately off in the REIMAGINED profile to avoid the blown-out sky/radial smear from earlier builds; the BALANCED profile includes it.
- **Colour grade:** exposure, saturation, vibrance and contrast controls. The supplied settings file informed the starting direction: saturation 1.1, vibrance 1.2 and neutral contrast. The supplied Mellow v3.4.1a.zip.txt is a settings text file, not the full shader source archive.
- **Mellow source/licence:** the custom noise texture is derived from the MIT-licensed Mellow-derived source noted in shaders/lib/MELLOW_MIT_NOTICE.txt. The cloud shader implementation is independently adapted for GLSL 1.20 / OptiFine uniforms rather than a full import of the current Mellow source tree.

## Profiles

- **REIMAGINED:** visual features, custom clouds, shoreline foam, mapped emissive sources and outlines; bloom disabled.
- **BALANCED:** same features with soft bloom enabled.
- **POTATO:** colour/light/outline extras disabled, but world-anchored Flat clouds remain enabled.

## Install notes

While DriftLite is active, set Minecraft **Options → Video Settings → Details → Clouds → OFF**. This prevents vanilla Fast/Fancy clouds from drawing over the custom sky cloud layer. DL_FLAT_CLOUDS controls the custom cloud layer.

## Important limitations

- The full shader program has not yet been compiled inside OptiFine 1.17.1 or MobileGlues.
- The foam depends on depth-texture availability in the translucent water pass; test for shoreline coverage and artifacts.
- Emissive blocks/items are brightened, but do not illuminate nearby blocks with coloured light. Handheld lighting is an approximation using OptiFine light uniforms.
- The workflow checks files, GLSL version tags, braces and packaging only. It is not a GLSL compiler or a performance benchmark.
- Complementary Reimagined remains the high-level visual reference. No Complementary code/assets are included.

## License

Original DriftLite code is MIT licensed in LICENSE.txt. The Mellow-derived noise asset is covered by its included MIT attribution notice.
