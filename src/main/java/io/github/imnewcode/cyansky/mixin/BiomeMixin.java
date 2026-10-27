package io.github.imnewcode.cyansky.mixin;

import io.github.imnewcode.cyansky.CyanSkyMod;
import net.minecraft.world.biome.Biome;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(Biome.class)
public abstract class BiomeMixin {
    @Inject(method = "getSkyColor", at = @At("RETURN"), cancellable = true)
    private void cyanSky$replaceSkyColor(CallbackInfoReturnable<Integer> cir) {
        if (CyanSkyMod.shouldApplyOverworldColors()) {
            cir.setReturnValue(CyanSkyMod.skyColor);
        }
    }

    @Inject(method = "getFogColor", at = @At("RETURN"), cancellable = true)
    private void cyanSky$replaceFogColor(CallbackInfoReturnable<Integer> cir) {
        if (CyanSkyMod.shouldApplyOverworldColors()) {
            cir.setReturnValue(CyanSkyMod.fogColor);
        }
    }
}
