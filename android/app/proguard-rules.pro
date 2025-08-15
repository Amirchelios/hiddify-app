# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep VPN service classes
-keep class com.hiddify.hiddify.bg.** { *; }
-keep class io.nekohasekai.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Hiddify specific classes
-keep class com.hiddify.hiddify.** { *; }

# Keep Sing-box related classes
-keep class io.nekohasekai.libbox.** { *; }

# Keep VPN related classes
-keep class android.net.VpnService { *; }
-keep class android.net.VpnService.Builder { *; }

# Keep JSON related classes
-keep class com.google.gson.** { *; }

# Keep Android lifecycle classes
-keep class androidx.lifecycle.** { *; }
-keep class androidx.core.** { *; }
-keep class androidx.appcompat.** { *; }

# Disable optimization for debug builds
-dontoptimize
-dontpreverify
