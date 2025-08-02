plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Apply Google Services plugin last
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.chat_app"
    compileSdk = 35  // Updated to 35 to meet dependency requirements
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.chat_app"
        minSdk = 23
        targetSdk = 34  // Keep targetSdk at 34 for stability
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
        debug {
            // Add debug configuration if needed
        }
    }
}

dependencies {
    // Firebase dependencies with compatible versions
    implementation("com.google.firebase:firebase-auth:22.3.1")
    implementation("com.google.firebase:firebase-messaging:23.4.1")
    implementation("com.google.firebase:firebase-analytics:21.5.1")
    
    // Google Play Services
    implementation("com.google.android.gms:play-services-auth:20.7.0")
    
    // Android dependencies
    implementation("androidx.browser:browser:1.8.0")
    implementation("com.google.android.play:integrity:1.4.0")
    
    // Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.22")
    
    // Multidex support
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Updated desugar library to meet flutter_local_notifications requirement
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}