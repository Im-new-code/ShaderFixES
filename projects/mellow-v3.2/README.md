# Mellow v3.2 outline and water patch

**Status: Experimental. Not yet verified in Minecraft.**

This branch contains a focused patch set for the user-provided Mellow-derived shader archive. It aims to preserve the current visual style while reducing screen-space outline artifacts and switching water to the vanilla-textured path without reflections.

## Source and attribution

- Original shader: [Mellow by TheCMK](https://modrinth.com/shader/mellow).
- The supplied archive identifies its existing modifications as BalancedGlow.
- This branch stores the patch and documentation, not a repackaged copy of the entire upstream shader pack. Apply the patch to the corresponding source archive and preserve its original `LICENSE` and `LICENSE-APACHE` files.

## Changes

1. Rework outline detection to use the median of four depth samples, replace far-plane samples with the center depth, and avoid linearizing all four samples.
2. Pass the current depth-source flag into the outline function so Distant Horizons depth can be sampled when applicable.
3. Set the default water texture mode to `0`, which samples the vanilla water texture.
4. Keep reflections disabled and keep the user's water normals setting disabled in the provided test configuration.

## Patch files

- `patches/outline.glsl`: replacement for `shaders/global/outline.glsl`.
- `patches/deferred1-call.patch`: update the outline call in `shaders/program/deferred1.fsh`.
- `patches/water-texture-mode.patch`: set the shader default to vanilla-textured water.
- `patches/test-settings.txt`: updated copy of the supplied shader settings, changing only `WATER_TEXTURE_MODE=2` to `WATER_TEXTURE_MODE=0`.

## Test goals

- Compare the same scene and camera against the original pack.
- Check wall edges at shallow viewing angles and while moving the camera.
- Check water in shallow and deep areas, across biomes, and underwater.
- Record FPS at the same resolution, render distance, renderer, and shader options.
- Verify standard worlds and Distant Horizons worlds if that integration is used.

A successful static review is not proof of a working shader. Do not describe this patch as fixed or faster until it has been tested on the target renderer.
