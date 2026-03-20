# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep our app classes
-keep class com.aydigitalcentre.speedest.** { *; }

# Keep Android network/telephony classes used via reflection
-keep class android.net.wifi.WifiInfo { *; }
-keep class android.telephony.TelephonyManager { *; }

# Suppress notes about missing classes
-dontnote io.flutter.**
-dontwarn io.flutter.embedding.**
