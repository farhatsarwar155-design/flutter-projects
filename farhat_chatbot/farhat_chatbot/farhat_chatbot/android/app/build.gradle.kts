plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.farhat.chatbot"  // <-- Better package name (optional)
    compileSdk = 34  // <-- Updated to 34

    defaultConfig {
        applicationId = "com.farhat.chatbot"  // <-- Same as namespace
        minSdk = 21
        targetSdk = 34  // <-- Updated to 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}