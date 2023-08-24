package com.example.loonaz_application;

import android.app.Activity;
import android.content.Context;
import android.media.RingtoneManager;
import android.os.Build;
import android.provider.Settings;
import android.content.Intent;
import android.content.SharedPreferences;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;

public class DefaultNotificationSoundHandler {
//    private static final String CHANNEL = "default_notification_sound";
//
//    public static void setDefaultNotificationSound(Context context, String ringtoneUri) {
//        String currentRingtone = Settings.System.getString(context.getContentResolver(), Settings.System.NOTIFICATION_SOUND);
//
//        if (!ringtoneUri.equals(currentRingtone)) {
//            SharedPreferences sharedPreferences = context.getSharedPreferences("my_app_prefs", Context.MODE_PRIVATE);
//            SharedPreferences.Editor editor = sharedPreferences.edit();
//            editor.putString("default_notification_sound", ringtoneUri);
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD) {
//                editor.apply();
//            }
//
//            Intent notificationSoundIntent = new Intent(Settings.ACTION_NOTIFICATION_ASSISTANT_SETTINGS);
//            notificationSoundIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            context.startActivity(notificationSoundIntent);
//        }
//    }
//
//    public static void registerWith(FlutterEngine flutterEngine) {
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//                .setMethodCallHandler(
//                        (call, result) -> {
//                            if (call.method.equals("setDefaultNotificationSound")) {
//                                String ringtoneUri = call.argument("ringtoneUri");
//                                setDefaultNotificationSound(flutterEngine.getContext(), ringtoneUri);
//                                result.success(true);
//                            } else {
//                                result.notImplemented();
//                            }
//                        }
//                );
//    }
}
