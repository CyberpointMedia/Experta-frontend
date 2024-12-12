package com.example.expert;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.expert/screen_capture";
    private static final String TAG = "MainActivity";
    private static final int SMS_PERMISSION_CODE = 100;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Check for SMS permission
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_SMS}, SMS_PERMISSION_CODE);
        } else {
            // Permission already granted, proceed with reading SMS
            readSms();
        }

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.example.expert/foreground_service")
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startForegroundService")) {
                                startForegroundService();
                                result.success(null);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "startService":
                            startScreenCaptureService(result);
                            break;
                        case "stopService":
                            stopScreenCaptureService(result);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                }
            );
    }

    private void startScreenCaptureService(MethodChannel.Result result) {
        try {
            Intent serviceIntent = new Intent(this, ScreenCaptureService.class);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent);
            } else {
                startService(serviceIntent);
            }
            result.success(null);
            Log.d(TAG, "Screen capture service started.");
        } catch (Exception e) {
            Log.e(TAG, "Failed to start screen capture service", e);
            result.error("SERVICE_ERROR", "Failed to start service", e.getMessage());
        }
    }

    private void stopScreenCaptureService(MethodChannel.Result result) {
        try {
            Intent serviceIntent = new Intent(this, ScreenCaptureService.class);
            stopService(serviceIntent);
            result.success(null);
            Log.d(TAG, "Screen capture service stopped.");
        } catch (Exception e) {
            Log.e(TAG, "Failed to stop screen capture service", e);
            result.error("SERVICE_ERROR", "Failed to stop service", e.getMessage());
        }
    }

    private void readSms() {
        // Implement your logic to read SMS here
    }

    private void startForegroundService() {
        Intent serviceIntent = new Intent(this, ForegroundService.class);
        startForegroundService(serviceIntent);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == SMS_PERMISSION_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted, proceed with reading SMS
                readSms();
            } else {
                // Permission denied, handle accordingly
            }
        }
    }
}
