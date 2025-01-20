package com.example.expert;

import android.Manifest;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.projection.MediaProjectionManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.content.IntentFilter;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.os.PowerManager;
import android.net.Uri;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MainActivity extends FlutterActivity {
    private static final Logger logger = Logger.getLogger(MainActivity.class.getName());
    private MethodChannel.Result pendingResult; 
    private BroadcastReceiver recordingReceiver;
    private static final String CHANNEL = "com.example.expert/screen_capture";
    private static final String FOREGROUND_SERVICE_CHANNEL = "com.example.expert/foreground_service";
    private static final String TAG = "MainActivity";
    private static final int PERMISSIONS_REQUEST_CODE = 102;
    private static final int REQUEST_CODE_SCREEN_CAPTURE = 1001;
    private static final int REQUEST_CODE_OVERLAY_PERMISSION = 1234;

    private static final String[] REQUIRED_PERMISSIONS = {
        Manifest.permission.RECORD_AUDIO,
        Manifest.permission.FOREGROUND_SERVICE
    };

    private PowerManager.WakeLock wakeLock;
    private MediaProjectionManager mediaProjectionManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupBroadcastReceiver();
        checkAndRequestPermissions(REQUIRED_PERMISSIONS);
        setupMethodChannels();
        acquireWakeLock();
        mediaProjectionManager = (MediaProjectionManager) getSystemService(MEDIA_PROJECTION_SERVICE);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), FOREGROUND_SERVICE_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("startForegroundService")) {
                        startForegroundService();
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                });

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.example.expert/screen_recording")
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "startScreenCapture":
                        startScreenCapture(result);
                        break;
                    case "stopScreenCapture":
                        stopScreenCapture(result);
                        break;
                    case "saveRecordingPath":
                        String filePath = call.argument("filePath");
                        saveRecordingPath(filePath);
                        result.success(null);
                        break;
                    default:
                        result.notImplemented();
                }
            });
    }

  private void setupBroadcastReceiver() {
     if (recordingReceiver == null) {
         recordingReceiver = new BroadcastReceiver() {
             @Override
             public void onReceive(Context context, Intent intent) {
                 String path = intent.getStringExtra("recording_path");
                 Log.i(TAG, "Received broadcast with path: " + path);
                 if (path != null) {
                     new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), 
                         CHANNEL)
                         .invokeMethod("saveRecordingPath", path);
                     Log.i(TAG, "Invoked saveRecordingPath method with path: " + path);
                 } else {
                     Log.e(TAG, "Received null path in broadcast");
                 }
             }
         };
            
         IntentFilter filter = new IntentFilter("com.example.expert.RECORDING_COMPLETED");
            
         // Use registerReceiver with appropriate flags based on API level
         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
             registerReceiver(recordingReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
         } else {
             registerReceiver(recordingReceiver, filter);
         }
     }
 }

    private void setupMethodChannels() {
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "startService":
                        startScreenCaptureService(result);
                        break;
                    case "stopService":
                        stopScreenCaptureService(result);
                        break;
                    default:
                        result.notImplemented();
                }
            });
    }

    private boolean checkPermissions() {
        Log.d(TAG, "Checking permissions...");
        
        // First check overlay permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            boolean canDrawOverlays = Settings.canDrawOverlays(this);
            Log.d(TAG, "Can draw overlays: " + canDrawOverlays);
            if (!canDrawOverlays) {
                return false;
            }
        }

        // Then check other permissions
        for (String permission : REQUIRED_PERMISSIONS) {
            boolean granted = ContextCompat.checkSelfPermission(this, permission) 
                == PackageManager.PERMISSION_GRANTED;
            Log.d(TAG, "Permission " + permission + " granted: " + granted);
            if (!granted) {
                return false;
            }
        }
        return true;
    }

    private void requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + getPackageName()));
                startActivityForResult(intent, REQUEST_CODE_OVERLAY_PERMISSION);
            }
        }
    }

    private void checkAndRequestPermissions(String[] permissions) {
        List<String> permissionsToRequest = new ArrayList<>();
        
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) 
                != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(permission);
            }
        }
        
        if (!permissionsToRequest.isEmpty()) {
            ActivityCompat.requestPermissions(
                this,
                permissionsToRequest.toArray(new String[0]),
                PERMISSIONS_REQUEST_CODE
            );
        }
    }

    private void startScreenCapture(MethodChannel.Result result) {
        Log.d(TAG, "Starting screen capture...");
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            Log.d(TAG, "Requesting overlay permission...");
            pendingResult = result;
            requestOverlayPermission();
            return;
        }

        if (!checkPermissions()) {
            Log.d(TAG, "Requesting regular permissions...");
            pendingResult = result;
            requestPermissions(result);
            return;
        }

        Log.d(TAG, "All permissions granted, proceeding with screen capture...");
        pendingResult = result;
        Intent captureIntent = mediaProjectionManager.createScreenCaptureIntent();
        startActivityForResult(captureIntent, REQUEST_CODE_SCREEN_CAPTURE);
    }

    private void handleOverlayPermissionResult() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Settings.canDrawOverlays(this)) {
            // Check other permissions now that overlay is granted
            if (!checkPermissions()) {
                requestPermissions(pendingResult);
            } else {
                // All permissions granted, proceed with screen capture
                Intent captureIntent = mediaProjectionManager.createScreenCaptureIntent();
                startActivityForResult(captureIntent, REQUEST_CODE_SCREEN_CAPTURE);
            }
        } else {
            if (pendingResult != null) {
                pendingResult.error("PERMISSION_DENIED", "Overlay permission required", null);
                pendingResult = null;
            }
        }
    }

    private void requestPermissions(MethodChannel.Result result) {
        Log.i(TAG, "Requesting permissions...");
        List<String> permissionsToRequest = new ArrayList<>();
        
        for (String permission : REQUIRED_PERMISSIONS) {
            if (ContextCompat.checkSelfPermission(this, permission) 
                    != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(permission);
            }
        }

        if (!permissionsToRequest.isEmpty()) {
            pendingResult = result;
            ActivityCompat.requestPermissions(
                this,
                permissionsToRequest.toArray(new String[0]),
                PERMISSIONS_REQUEST_CODE
            );
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        
        Log.d(TAG, "onActivityResult: requestCode=" + requestCode + ", resultCode=" + resultCode);
        
        if (requestCode == REQUEST_CODE_OVERLAY_PERMISSION) {
            handleOverlayPermissionResult();
        } else if (requestCode == REQUEST_CODE_SCREEN_CAPTURE) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                Intent serviceIntent = new Intent(this, ScreenRecordingService.class);
                serviceIntent.putExtra("resultCode", (Integer) resultCode); // Explicitly cast to Integer
                serviceIntent.putExtra("data", (Intent) data); // Explicitly cast to Intent
                startForegroundService(serviceIntent);
                if (pendingResult != null) {
                    pendingResult.success(null);
                    pendingResult = null;
                }
            } else {
                if (pendingResult != null) {
                    pendingResult.error("SCREEN_CAPTURE_FAILED", "Screen capture permission denied", null);
                    pendingResult = null;
                }
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        
        if (requestCode == PERMISSIONS_REQUEST_CODE) {
            boolean allGranted = true;
            
            for (int i = 0; i < permissions.length; i++) {
                if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                    allGranted = false;
                    Log.w(TAG, "Permission denied: " + permissions[i]);
                }
            }
            
            if (allGranted) {
                Log.i(TAG, "All permissions granted...");
                if (pendingResult != null) {
                    startScreenCapture(pendingResult);
                }
            } else {
                Log.w(TAG, "Some permissions were denied");
                if (pendingResult != null) {
                    pendingResult.error("PERMISSION_DENIED", "Required permissions not granted", null);
                    pendingResult = null;
                }
            }
        }
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
            logger.info("Screen capture service started.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to start screen capture service", e);
            result.error("SERVICE_ERROR", "Failed to start service", e.getMessage());
        }
    }

    private void stopScreenCaptureService(MethodChannel.Result result) {
        try {
            Intent serviceIntent = new Intent(this, ScreenCaptureService.class);
            stopService(serviceIntent);
            result.success(null);
            logger.info("Screen capture service stopped.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to stop screen capture service", e);
            result.error("SERVICE_ERROR", "Failed to stop service", e.getMessage());
        }
    }

    private void acquireWakeLock() {
        PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
        if (powerManager != null) {
            wakeLock = powerManager.newWakeLock(PowerManager.FULL_WAKE_LOCK, "experta:WakeLock");
            wakeLock.acquire();
        }
    }

    private void releaseWakeLock() {
        if (wakeLock != null && wakeLock.isHeld()) {
            wakeLock.release();
        }
    }

    private void startForegroundService() {
        Intent serviceIntent = new Intent(this, ForegroundService.class);
        startForegroundService(serviceIntent);
    }

    private void stopScreenCapture(MethodChannel.Result result) {
        Intent serviceIntent = new Intent(this, ScreenRecordingService.class);
        stopService(serviceIntent);
        result.success(null);
    }

    private void saveRecordingPath(String filePath) {
        // Handle the saveRecordingPath method here
        Log.i(TAG, "Saving recording path: " + filePath);
    }

    @Override
    protected void onDestroy() {
        if (recordingReceiver != null) {
            unregisterReceiver(recordingReceiver);
        }
        releaseWakeLock();
        super.onDestroy();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "startService":
                        startScreenCaptureService(result);
                        break;
                    case "stopService":
                        stopScreenCaptureService(result);
                        break;
                    case "startScreenRecording":
                        Intent serviceIntent = new Intent(this, ScreenRecordingService.class);
                        serviceIntent.putExtra("resultCode", (Integer) call.argument("resultCode")); 
                        serviceIntent.putExtra("data", (Intent) call.argument("data")); 
                        startService(serviceIntent);
                        result.success(null);
                        break;
                    case "stopScreenRecording":
                        Intent stopServiceIntent = new Intent(this, ScreenRecordingService.class);
                        stopService(stopServiceIntent);
                        result.success(null);
                        break;
                    case "getToken":
                        String token = PrefUtils.getToken(this);
                        result.success(token);
                        break;
                    default:
                        result.notImplemented();
                        break;
                }
            });
    }

}