package cn.rongcloud.rtc.wrapper.flutter.example;

import androidx.annotation.NonNull;

import cn.rongcloud.rtc.wrapper.flutter.RCRTCEngineWrapper;
import cn.rongcloud.rtc.wrapper.flutter.example.beauty.VideoOutputFrameListener;
import cn.rongcloud.rtc.wrapper.flutter.example.utils.UIThreadHandler;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        init(flutterEngine.getDartExecutor().getBinaryMessenger());
    }

    @Override
    public void cleanUpFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine);
        release();
    }

    private void init(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "cn.rongcloud.rtc.flutter.demo");
        channel.setMethodCallHandler(this);
    }

    private void release() {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "openBeauty":
                openBeauty();
                UIThreadHandler.success(result, null);
                break;
            case "closeBeauty":
                closeBeauty();
                UIThreadHandler.success(result, null);
                break;
        }
    }

    private void openBeauty() {
        if (listener == null) {
            listener = new VideoOutputFrameListener();
            RCRTCEngineWrapper.getInstance().setVideoListener(listener);
        }
    }

    private void closeBeauty() {
        if (listener != null) {
            RCRTCEngineWrapper.getInstance().setVideoListener(null);
            listener.destroy();
            listener = null;
        }
    }

    private MethodChannel channel;
    private VideoOutputFrameListener listener;
}
