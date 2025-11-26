pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    val localProperties = java.util.Properties()
    val localPropertiesFile = file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { localProperties.load(it) }
    }

    val flutterSdkPath = localProperties.getProperty("flutter.sdk")
        ?: throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("com.google.gms.google-services") version "4.4.0" apply false
}

rootProject.name = "sabore_front"
include(":app")