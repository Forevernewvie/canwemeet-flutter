import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystoreProperties = keystorePropertiesFile.exists()

if (hasKeystoreProperties) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val isReleaseTask =
    gradle.startParameter.taskNames.any { it.contains("Release", ignoreCase = true) }

val adMobAppIdProp =
    (project.findProperty("ADMOB_APP_ID") as? String)?.trim().orEmpty()

if (isReleaseTask) {
    if (!hasKeystoreProperties) {
        throw GradleException(
            "Missing android/key.properties. Create it to sign release builds for Google Play.",
        )
    }
    if (adMobAppIdProp.isBlank()) {
        throw GradleException(
            "Missing ADMOB_APP_ID in android/gradle.properties. This is required for release builds.",
        )
    }
    if (adMobAppIdProp == "ca-app-pub-3940256099942544~3347511713") {
        throw GradleException("Do not use the AdMob test App ID in release builds.")
    }
}

android {
    namespace = "com.ourmatchwell.ourmatchwell_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            if (!hasKeystoreProperties) return@create

            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ourmatchwell.ourmatchwell_flutter"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Used by AndroidManifest.xml via ${ADMOB_APP_ID}.
        // For release builds, set a real value in android/gradle.properties:
        // ADMOB_APP_ID=ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy
        manifestPlaceholders["ADMOB_APP_ID"] =
            (project.findProperty("ADMOB_APP_ID") as? String)
                ?: "ca-app-pub-3940256099942544~3347511713"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.ump:user-messaging-platform:4.0.0")
}
