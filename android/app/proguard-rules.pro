# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep GeneratedPluginRegistrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep Firebase (if used)
-keep class com.google.firebase.** { *; }

# Keep Google Maps
-keep class com.google.android.gms.maps.** { *; }

# Don't warn
-dontwarn io.flutter.embedding.**
-dontwarn javax.annotation.**