package com.dinoyocraft

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val shareChannel = "com.dinoyocraft/share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shareChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "shareText") {
                    val text = call.argument<String>("text") ?: ""
                    val subject = call.argument<String>("subject")
                    val chooserTitle = call.argument<String>("chooserTitle") ?: "Bagikan melalui"
                    if (text.isEmpty()) {
                        result.error("EMPTY_TEXT", "Teks tautan kosong", null)
                    } else {
                        val sendIntent = Intent(Intent.ACTION_SEND).apply {
                            type = "text/plain"
                            putExtra(Intent.EXTRA_TEXT, text)
                            if (!subject.isNullOrBlank()) {
                                putExtra(Intent.EXTRA_SUBJECT, subject)
                            }
                        }
                        val shareIntent = Intent.createChooser(sendIntent, chooserTitle)
                        startActivity(shareIntent)
                        result.success(true)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
