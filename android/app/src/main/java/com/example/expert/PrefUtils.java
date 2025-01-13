package com.example.expert;

import android.content.Context;
import android.content.SharedPreferences;

public class PrefUtils {
    private static final String PREFS_NAME = "FlutterSharedPreferences";
    private static final String KEY_TOKEN = "flutter.token";

    public static String getToken(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getString(KEY_TOKEN, null);
    }

    public static void setToken(Context context, String token) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(KEY_TOKEN, token);
        editor.apply();
    }
}
