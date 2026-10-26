# Emissive Block Glow

> A lightweight OptiFine shader-pack experiment that adds a restrained bloom halo to selected emissive-looking block pixels, without colored block lighting or dynamic-light simulation.

## Project status

- **Type:** Create / Experiment
- **Status:** In progress; source review only
- **Minecraft version:** Java Edition 1.17.1
- **Shader pipeline:** OptiFine Shaders, GLSL 1.20-style composite passes
- **Renderer target:** MobileGlues / GLES 3.2 compatibility path
- **Device target:** OPPO A3s, Adreno 506
- **Last tested:** Not tested in game

## Goal

Pair OptiFine emissive texture overlays with a small-screen-space bloom effect for torches, soul torches, lanterns, soul lanterns, glowstone, sea lanterns, lava, shroomlight, and a lit redstone lamp.

**No colored lighting is implemented.** The project does not calculate colored light propagation, dynamic lights, global illumination, shadows, or reflections. Emissive overlays supply full-bright pixels; the shader applies a low-resolution post-process halo around selected bright warm/cyan pixels.

## Important technical distinction

OptiFine's emissive texture feature renders an overlay at full brightness, but it **does not illuminate surrounding blocks**. Bloom is a screen-space effect and only makes already-rendered bright pixels appear to bleed softly into nearby screen pixels. References: [OptiFine emissive.properties example](https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/emissive.properties) and [OptiDocs: Emissive Textures](https://optifine.readthedocs.io/emissive_textures.html).

The current bloom extraction uses a brightness threshold, a warm/cyan color heuristic, and a depth check to suppress the sky. It is intentionally light-weight, but it is **not a material-ID mask**: similarly bright pixels with matching colors elsewhere in the scene can also bloom. A future dedicated emissive mask would require more invasive G-buffer work.

## Repository layout

- `shaderpack/`: OptiFine shader pack source.
- `resource-pack/`: Minecraft 1.17.1 resource pack with `assets/minecraft/optifine/emissive.properties` and hand-authored `_e.png` overlays.
- `TESTING.md`: repeatable test notes and current verification status.

The 16×16 overlays are initial stylized masks, not copied vanilla textures. UV alignment and visual quality have not been confirmed in-game yet; refine the masks against the 1.17.1 vanilla texture atlas if they do not sit precisely on the flame/panes/molten areas.

## Planned visual behavior

- Torches and lanterns: restrained warm halo.
- Soul torches and soul lanterns: restrained cyan halo.
- Glowstone, sea lanterns, lava and shroomlight: bloom only, no extra environmental light.
- Redstone lamp: emissive overlay is provided for the lit texture only; the unlit texture should remain unaffected.

## Performance approach

- No shadow map.
- No dynamic-light pass or colored lightmap.
- Bright-pass target and two separable blur targets are downscaled to 50% in each dimension.
- Blur uses five taps per pass, followed by a final additive composite.
- Actual FPS and memory use remain unmeasured.

## Installation source layout

Create two separate archives whose roots contain the contents of each folder:

1. Zip the **contents** of `shaderpack/` into a shader-pack archive.
2. Zip the **contents** of `resource-pack/` into a resource-pack archive.
3. Put the shader pack in Minecraft's `shaderpacks` folder and enable it in OptiFine Shaders.
4. Put the resource pack in `resourcepacks` and enable it above other packs.

Do not zip the outer `shaderpack` or `resource-pack` folder as an extra top-level directory; Minecraft must see `shaders.properties` or `pack.mcmeta` at the archive root.

## Changelog

- Initial branch: lightweight threshold bloom, OptiFine emissive configuration, stylized overlays, and explicit untested status.
