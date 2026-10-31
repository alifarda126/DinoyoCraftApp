# ProGuard / R8 keep rules untuk DinoyoCraft Mobile

# Suppress peringatan SLF4J dari library Pusher Channels
-dontwarn org.slf4j.impl.StaticLoggerBinder
-dontwarn org.slf4j.**

# Pusher Channels Flutter
-keep class com.pusher.** { *; }
-dontwarn com.pusher.**

# Firebase Core, Messaging, Crashlytics, Analytics
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-dontwarn com.google.firebase.**
-keep class com.google.firebase.** { *; }

