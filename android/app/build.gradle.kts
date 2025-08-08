plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.abhijith.shiftwheels"
    compileSdk = 35  // Changed from flutter.compileSdkVersion to explicit version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.abhijith.shiftwheels"
        minSdk = 23
        targetSdk = 35  // Changed from flutter.targetSdkVersion to explicit version
        versionCode = 1  // Changed from flutter.versionCode to explicit value
        versionName = "1.0.0"  // Changed from flutter.versionName to explicit value
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.gms:play-services-location:21.2.0")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.22")
    implementation("androidx.core:core-ktx:1.12.0")  // Added compatible version
}