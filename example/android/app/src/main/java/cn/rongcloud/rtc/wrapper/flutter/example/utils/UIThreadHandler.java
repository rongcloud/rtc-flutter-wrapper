package cn.rongcloud.rtc.wrapper.flutter.example.utils;

import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.MethodChannel.Result;

public class UIThreadHandler {
    public static void post(Runnable runnable) {
        handler.post(runnable);
    }

    public static void success(Result result, Object obj) {
        post(() -> result.success(obj));
    }

    private static final Handler handler = new Handler(Looper.getMainLooper());
}
