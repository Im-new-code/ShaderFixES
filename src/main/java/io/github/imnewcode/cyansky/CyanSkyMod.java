package io.github.imnewcode.cyansky;

import net.fabricmc.api.ModInitializer;
import net.fabricmc.loader.api.FabricLoader;
import net.minecraft.client.MinecraftClient;
import net.minecraft.world.World;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public final class CyanSkyMod implements ModInitializer {
    private static final Logger LOGGER = LoggerFactory.getLogger("cyan-sky-fog");
    private static final Path CONFIG_PATH =
            FabricLoader.getInstance().getConfigDir().resolve("cyan-sky-fog.properties");

    public static volatile boolean enabled = true;
    public static volatile boolean forceFog = true;
    public static volatile int skyColor = 0x62CBF2;
    public static volatile int fogColor = 0xA0DEF1;
    public static volatile float terrainFogStart = 0.68F;
    public static volatile float terrainFogEnd = 1.0F;
    public static volatile float skyFogStart = 0.0F;
    public static volatile float skyFogEnd = 1.0F;

    public CyanSkyMod() {
    }

    @Override
    public void onInitialize() {
        loadConfig();
        LOGGER.info("Cyan Sky Fog loaded (sky=#{}, fog=#{}, forced fog={})",
                hex(skyColor), hex(fogColor), forceFog);
    }

    public static boolean shouldApplyOverworldColors() {
        if (!enabled) {
            return false;
        }

        MinecraftClient client = MinecraftClient.getInstance();
        return client != null
                && client.world != null
                && World.OVERWORLD.equals(client.world.getRegistryKey());
    }

    private static void loadConfig() {
        Properties properties = new Properties();
        boolean writeDefaults = !Files.exists(CONFIG_PATH);

        try {
            if (!writeDefaults) {
                try (InputStream input = Files.newInputStream(CONFIG_PATH)) {
                    properties.load(input);
                }
            }

            enabled = Boolean.parseBoolean(properties.getProperty("enabled", "true").trim());
            forceFog = Boolean.parseBoolean(properties.getProperty("force_fog", "true").trim());
            skyColor = parseHex(properties.getProperty("sky_color", "62CBF2"), 0x62CBF2);
            fogColor = parseHex(properties.getProperty("fog_color", "A0DEF1"), 0xA0DEF1);
            terrainFogStart = ratio(properties, "terrain_fog_start", 0.68F);
            terrainFogEnd = ratio(properties, "terrain_fog_end", 1.0F);
            skyFogStart = ratio(properties, "sky_fog_start", 0.0F);
            skyFogEnd = ratio(properties, "sky_fog_end", 1.0F);

            if (terrainFogEnd <= terrainFogStart) {
                terrainFogEnd = Math.min(1.0F, terrainFogStart + 0.05F);
                if (terrainFogEnd <= terrainFogStart) {
                    terrainFogStart = Math.max(0.0F, terrainFogEnd - 0.05F);
                }
            }
            if (skyFogEnd <= skyFogStart) {
                skyFogEnd = Math.min(1.0F, skyFogStart + 0.05F);
                if (skyFogEnd <= skyFogStart) {
                    skyFogStart = Math.max(0.0F, skyFogEnd - 0.05F);
                }
            }

            if (writeDefaults) {
                writeConfig();
            }
        } catch (IOException exception) {
            LOGGER.warn("Could not read or write {}. Using built-in Cyan Sky defaults.", CONFIG_PATH, exception);
        }
    }

    private static void writeConfig() throws IOException {
        Files.createDirectories(CONFIG_PATH.getParent());
        Properties defaults = new Properties();
        defaults.setProperty("enabled", Boolean.toString(enabled));
        defaults.setProperty("force_fog", Boolean.toString(forceFog));
        defaults.setProperty("sky_color", hex(skyColor));
        defaults.setProperty("fog_color", hex(fogColor));
        defaults.setProperty("terrain_fog_start", Float.toString(terrainFogStart));
        defaults.setProperty("terrain_fog_end", Float.toString(terrainFogEnd));
        defaults.setProperty("sky_fog_start", Float.toString(skyFogStart));
        defaults.setProperty("sky_fog_end", Float.toString(skyFogEnd));

        try (OutputStream output = Files.newOutputStream(CONFIG_PATH)) {
            defaults.store(output, "Cyan Sky Fog settings. RGB hex colours omit the # prefix.");
        }
    }

    private static int parseHex(String value, int fallback) {
        try {
            String clean = value.trim().replace("#", "");
            int parsed = Integer.parseInt(clean, 16);
            if (clean.length() > 6 || parsed < 0) {
                return fallback;
            }
            return parsed & 0xFFFFFF;
        } catch (RuntimeException exception) {
            return fallback;
        }
    }

    private static float ratio(Properties properties, String key, float fallback) {
        try {
            float value = Float.parseFloat(properties.getProperty(key, Float.toString(fallback)).trim());
            if (Float.isNaN(value) || Float.isInfinite(value)) {
                return fallback;
            }
            return Math.max(0.0F, Math.min(1.0F, value));
        } catch (RuntimeException exception) {
            return fallback;
        }
    }

    private static String hex(int color) {
        return String.format("%06X", color & 0xFFFFFF);
    }
}
