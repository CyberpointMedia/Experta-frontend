package com.example.expert;

import android.app.*;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.hardware.display.DisplayManager;
import android.hardware.display.VirtualDisplay;
import android.media.MediaRecorder;
import android.os.Environment;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.os.Build;
import android.os.IBinder;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.WindowManager;
import androidx.core.app.NotificationCompat;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.os.ParcelFileDescriptor;
import android.provider.MediaStore;
import android.net.Uri;
import android.content.pm.ServiceInfo;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import androidx.annotation.NonNull;
import android.database.Cursor;
import androidx.loader.content.CursorLoader;
import com.example.expert.PrefUtils; 

public class ScreenRecordingService extends Service {
    private MediaProjection mediaProjection;
    private MediaRecorder mediaRecorder;
    private VirtualDisplay virtualDisplay;
    private MediaProjectionManager mediaProjectionManager;
    private Uri mediaStoreOutput;
    private MethodChannel.Result pendingResult;
    private String filePath;
    private static final String CHANNEL = "com.example.expert/screen_recording";
    private FlutterEngine flutterEngine;
    @Override
    public void onCreate() {
        super.onCreate();
        mediaProjectionManager = (MediaProjectionManager) getSystemService(Context.MEDIA_PROJECTION_SERVICE);
        flutterEngine = new FlutterEngine(this);
        flutterEngine.getDartExecutor().executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        );
    }
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        int resultCode = intent.getIntExtra("resultCode", Activity.RESULT_CANCELED);
        Intent data = intent.getParcelableExtra("data");
        if (resultCode == Activity.RESULT_OK && data != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(1, createNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION);
            } else {
                startForeground(1, createNotification());
            }
            mediaProjection = mediaProjectionManager.getMediaProjection(resultCode, data);
            startRecording();
        } else {
            stopSelf();
        }
        return START_NOT_STICKY;
    }
    private void startRecording() {
        DisplayMetrics metrics = new DisplayMetrics();
        WindowManager windowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        windowManager.getDefaultDisplay().getMetrics(metrics);
        mediaRecorder = new MediaRecorder();
        mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        mediaRecorder.setVideoSource(MediaRecorder.VideoSource.SURFACE);
        mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
        String fileName = "Experta" + timestamp + ".mp4";
        File cacheDir = getCacheDir();
        File outputFile = new File(cacheDir, fileName);
        filePath = outputFile.getAbsolutePath(); 
        try {
            mediaRecorder.setOutputFile(filePath); 
            mediaRecorder.setVideoSize(1280, 720);
            mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264);
            mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
            mediaRecorder.setVideoEncodingBitRate(5 * 1024 * 1024);
            mediaRecorder.setVideoFrameRate(30);

            Log.d("ScreenRecordingService", "File Path: " + filePath); 

            Log.d("ScreenRecordingService", "Creating VirtualDisplay with size: " + metrics.widthPixels + "x" + metrics.heightPixels);
            
            try {
                mediaRecorder.prepare();
            } catch (IOException e) {
                Log.e("ScreenRecordingService", "Failed to prepare MediaRecorder: " + e.getMessage());
                stopSelf();
                return;
            }
            virtualDisplay = mediaProjection.createVirtualDisplay(
                "ScreenRecording",
                metrics.widthPixels,
                metrics.heightPixels,
                metrics.densityDpi,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                mediaRecorder.getSurface(),
                null,
                null
            );
            try {
                mediaRecorder.start();
            } catch (IllegalStateException e) {
                Log.e("ScreenRecordingService", "MediaRecorder failed to start: " + e.getMessage());
                stopSelf();
            }
            startForeground(1, createNotification());
        } catch (Exception e) {
            Log.e("ScreenRecordingService", "Failed to set output file", e);
            stopSelf();
        }
    }
    private Notification createNotification() {
        String notificationChannelId = "SCREEN_RECORDING_CHANNEL";
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    notificationChannelId,
                    "Screen Recording",
                    NotificationManager.IMPORTANCE_LOW
            );
            NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            manager.createNotificationChannel(channel);
        }
        return new NotificationCompat.Builder(this, notificationChannelId)
                .setContentTitle("Screen Recording")
                .setContentText("Recording in progress")
                .setSmallIcon(R.drawable.ic_notification)
                .build();
    }
    @Override
public void onDestroy() {
    super.onDestroy();
    stopRecording();
 if (filePath != null) { 
            new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .invokeMethod("saveRecordingPath", filePath);
            Log.d("ScreenRecordingService", "File path sent to Flutter: " + filePath);
        } else {
            Log.e("ScreenRecordingService", "filePath is null, cannot send to Flutter");
        }
    flutterEngine.destroy();
}
    private void stopRecording() {
        if (mediaRecorder != null) {
            try {
                mediaRecorder.stop();
            } catch (IllegalStateException e) {
                Log.e("ScreenRecordingService", "Error stopping media recorder: " + e.getMessage());
            }
            mediaRecorder.release();
            mediaRecorder = null;
        }

        if (virtualDisplay != null) {
            virtualDisplay.release();
        }

        if (mediaProjection != null) {
            mediaProjection.stop();
        }
    }
    public void clearVideoFileFromCache() {
        if (filePath != null) {
            File videoFile = new File(filePath);
            if (videoFile.exists()) {
                if (videoFile.delete()) {
                    Log.d("ScreenRecordingService", "Video file deleted from cache: " + filePath);
                } else {
                    Log.e("ScreenRecordingService", "Failed to delete video file from cache: " + filePath);
                }
            }
            filePath = null;
        }
    }
   private String getRealPathFromURI(Uri contentUri) {
    String[] proj = {MediaStore.Images.Media.DATA};
    CursorLoader loader = new CursorLoader(this, contentUri, proj, null, null, null);
    Cursor cursor = loader.loadInBackground();
    if (cursor != null) {
        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        String result = cursor.getString(column_index);
        cursor.close();
        return result;
    }
    return null;
}
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
