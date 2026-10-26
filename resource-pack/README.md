# Emissive Block Glow Resource Pack

Target: Minecraft Java Edition 1.17.1 with OptiFine emissive texture support.

The pack declares `suffix.emissive=_e` in `assets/minecraft/optifine/emissive.properties`. OptiFine looks for an overlay next to the matching base texture, using the same name plus `_e.png`. The overlay is an authored RGBA mask with transparent pixels everywhere that should not be emissive.

The current masks are simple 16×16 prototypes for source pixels, not copies of Mojang's vanilla art. Their pixel placement is provisional and must be checked in-game against the vanilla 1.17.1 texture atlas. If an overlay creates a visible colored patch outside the flame, pane, or molten detail, adjust or remove that mask.

Supported overlay files in this first pass:
- torches and redstone torches (floor and wall variants)
- soul torches (floor and wall variants)
- lanterns and soul lanterns
- glowstone and sea lantern
- still and flowing lava
- shroomlight
- lit redstone lamp texture only

The pack does not change block light levels or propagate light into adjacent blocks. That is the job OptiFine's block-light system already performs; this pack only makes selected texture pixels render at full brightness.
