package io.github.imnewcode.cyansky.mixin;

import com.mojang.blaze3d.systems.RenderSystem;
import io.github.imnewcode.cyansky.CyanSkyMod;
import net.minecraft.client.render.BackgroundRenderer;
import net.minecraft.client.render.Camera;
import net.minecraft.client.render.CameraSubmersionType;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(BackgroundRenderer.class)
public abstract class BackgroundRendererMixin {
    /**
     * OptiFine's Details > Fog > OFF can leave the fog start/end uniforms at a
     * no-fog range. Reapply the normal shader-fog uniforms after the game's
     * own setup. This is intentionally restricted to dry Overworld rendering:
     * underwater, lava, powder-snow, Nether, and End fog stay vanilla.
     */
    @Inject(method = "applyFog", at = @At("TAIL"))
    private static void cyanSky$forceOverworldFog(
            Camera camera,
            BackgroundRenderer.FogType fogType,
            float viewDistance,
            boolean thickFog,
            CallbackInfo ci
    ) {
        if (!CyanSkyMod.shouldApplyOverworldColors()
                || !CyanSkyMod.forceFog
                || camera.getSubmersionType() != CameraSubmersionType.NONE) {
            return;
        }

        float safeDistance = Math.max(16.0F, viewDistance);
        boolean skyFog = fogType == BackgroundRenderer.FogType.FOG_SKY;
        float startRatio = skyFog ? CyanSkyMod.skyFogStart : CyanSkyMod.terrainFogStart;
        float endRatio = skyFog ? CyanSkyMod.skyFogEnd : CyanSkyMod.terrainFogEnd;
        float start = safeDistance * startRatio;
        float end = Math.max(start + 1.0F, safeDistance * endRatio);

        int color = CyanSkyMod.fogColor;
        RenderSystem.setShaderFogStart(start);
        RenderSystem.setShaderFogEnd(end);
        RenderSystem.setShaderFogColor(
                ((color >> 16) & 0xFF) / 255.0F,
                ((color >> 8) & 0xFF) / 255.0F,
                (color & 0xFF) / 255.0F,
                1.0F
        );
    }
}
