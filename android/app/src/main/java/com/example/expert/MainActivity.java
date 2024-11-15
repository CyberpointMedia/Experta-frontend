package com.example.expert;

import android.content.Intent;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import com.example.expert.ScreenCaptureService;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.expert/screen_capture";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("startService")) {
                        Intent serviceIntent = new Intent(this, ScreenCaptureService.class);
                        startForegroundService(serviceIntent);
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }
}
