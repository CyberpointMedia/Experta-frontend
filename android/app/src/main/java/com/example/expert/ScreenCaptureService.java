// ScreenCaptureService.java
package com.example.expert;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import androidx.annotation.Nullable;

public class ScreenCaptureService extends Service {

    @Nullable
    @Override
    public IBinder onBind(Intent intent) { 
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String channelId = "ScreenCaptureServiceChannel";
            NotificationChannel channel = new NotificationChannel(
                channelId,
                "Screen Capture Service",
                NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);

            Notification notification = new Notification.Builder(this, channelId)
                .setContentTitle("Screen Capture")
                .setContentText("Screen capture is running")
                .setSmallIcon(R.drawable.ic_notification) 
                .build();

            startForeground(1, notification);
        }
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // Clean up resources if needed
    }
}
