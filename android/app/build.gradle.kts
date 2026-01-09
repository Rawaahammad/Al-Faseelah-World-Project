plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev. flutter.flutter-gradle-plugin")
    // أضيفي هذا السطر لـ Firebase
    id("com.google.gms.google-services")
}

android {
    // ✅ تم التغيير
    namespace = "com.alfaseelah.parent_app"
    compileSdk = flutter. compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion. VERSION_17.toString()
    }

    defaultConfig {
        // ✅ تم التغيير
        applicationId = "com.alfaseelah.parent_app"

        // ✅ تم تغيير minSdk لدعم Firebase
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ✅ مطلوب لـ Firebase
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs. getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ إضافة dependencies لـ Firebase
dependencies {
    // Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-analytics")

    // MultiDex
    implementation("androidx.multidex:multidex:2.0.1")
}