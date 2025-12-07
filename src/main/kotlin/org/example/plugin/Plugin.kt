package org.example.plugin

import org.bukkit.plugin.java.JavaPlugin

@Suppress("unused")
class Plugin : JavaPlugin() {
    private val pair = Pair("Hello, world!", "Goodbye, world!")

    override fun onEnable() {
        logger.info(pair.first)
    }

    override fun onDisable() {
        logger.info(pair.second)
    }
}

