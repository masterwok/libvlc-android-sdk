[![Release](https://jitpack.io/v/masterwok/libvlc-android-sdk.svg)](https://jitpack.io/#masterwok/libvlc-android-sdk)

# [UNOFFICIAL] libvlc-android-sdk
An unofficial library of LibVLC for Android. The goal of this project is to be able to use LibVLC as an Android dependency. 

## Usage

Add this in your root build.gradle at the end of repositories:
```gradle
allprojects {
    repositories {
        maven { url "https://jitpack.io" }
    }
}
```
and add the following in the dependent module:

```gradle
dependencies {
    implementation 'com.github.masterwok:libvlc-android-sdk:3.0.13'
}
```
unless you're a fan of large APKs, you'll probably want to add the following to the build.gradle of your app so an APK is generated per ABI:

```gradle
android {
    ...
    splits {
        abi {
            enable true
            reset()
            include 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
            universalApk false
        }
    }
}

// Map for the version code that gives each ABI a value.
ext.abiCodes = [
        'armeabi-v7a': 1,
        'arm64-v8a'  : 2,
        'x86'        : 3,
        'x86_64'     : 4
]

import com.android.build.OutputFile

android.applicationVariants.all { variant ->
    variant.outputs.each { output ->
        def baseAbiVersionCode = project.ext.abiCodes.get(output.getFilter(OutputFile.ABI))

        if (baseAbiVersionCode != null) {
            output.versionCodeOverride = baseAbiVersionCode * 10000000 + variant.versionCode
        }
    }
}
```



## Building (LibVLC)
This is the tricky bit. If you want to build this project on your own, I would recommend doing it within a Ubuntu VM. I ran into quite a few build problems and found it helpful to fallback to snapshots when initially attempting to build LibVLC. Follow the official compile wiki [here](https://wiki.videolan.org/AndroidCompile/#Get_VLC_Source) to setup your development environment (no need to clone repo or that jazz yet, see below). Once completed, follow these steps:
1. Clone this repository.
2. Open the repository in Android Studio.
3. Delete the jniLib folders for all architectures within the libvlc module of this project.
4. Delete the org.videolan.libvlc directory under the libvlc module of this project.
5. Delete the vlc-android directory should it exist in the root of the project.
6. Run, './buildlibvlc.sh -a ARCH' where ARCH is the architecture you wish to build for (i.e. x86, x86_64, armeabi-v7a, arm64-v8a)
7. If the build was successful, celebrate and continue onto the next step. Else, slam face into keyboard, tweak your development environment, maybe grab a beer, and go back to step 5.
8. Unzip the AAR file at, "vlc-android-libvlc/build/outputs/aar"
9. Copy the folder of the architecture you just compiled from within the jni folder (i.e. armeabi-v7a) of the extracted AAR to the jniLib folder within the libvlc module.
10. Repeat from step 5 until all architectures are built.
11. Copy "vlc-android/libvlc/src/org" to the java folder of the libvlc module of this project.
12. Build and run the sample project. SUCCESS!

## Licensing

[See VLC FAQ](https://wiki.videolan.org/Frequently_Asked_Questions/#May_I_redistribute_libVLC_in_my_application.3F)
