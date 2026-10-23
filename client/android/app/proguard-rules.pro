# ProGuard/R8 rules for Naijatax Android release builds.

# ── Flutter engine & plugins ────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ── Play Core ───────────────────────────────────────────────────────────────
# Flutter references Play Core for deferred components, which are not
# bundled with this app; R8 would otherwise fail on the missing classes.
-dontwarn com.google.android.play.core.**

# ── Common transitive dependencies stripped by R8 ───────────────────────────
-dontwarn org.slf4j.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.apache.http.**

# ── Keep annotations used by reflection-based libraries ─────────────────────
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses,EnclosingMethod

# ── Method-channel plugins rely on JNI entry points being preserved ─────────
-keepclasseswithmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
