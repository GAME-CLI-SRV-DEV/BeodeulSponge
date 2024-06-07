dependencies {
    api(org.geysermc.floodgate:core:2.2.3-SNAPSHOT)
}

platformRelocate("com.fasterxml.jackson")
platformRelocate("io.netty")
platformRelocate("it.unimi.dsi.fastutil")
platformRelocate("com.google.common")
platformRelocate("com.google.guava")
platformRelocate("net.kyori.adventure.text.serializer.gson.legacyimpl")
platformRelocate("net.kyori.adventure.nbt")

// These dependencies are already present on the platform
provided(libs.sponge.api)

application {
    mainClass.set("org.geysermc.floodgate.sponge")
}

tasks.withType<com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar> {
    archiveBaseName.set("Floodgate-Sponge")

}
