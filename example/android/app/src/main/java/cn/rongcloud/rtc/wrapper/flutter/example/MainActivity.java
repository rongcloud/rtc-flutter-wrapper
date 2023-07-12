package cn.rongcloud.rtc.wrapper.flutter.example;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;

import cn.rongcloud.rtc.wrapper.constants.RCRTCIWAudioDeviceErrorType;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWVideoDeviceErrorType;
import cn.rongcloud.rtc.wrapper.flutter.RCRTCEngineWrapper;
import cn.rongcloud.rtc.wrapper.flutter.example.audio.AudioRouteingListener;
import cn.rongcloud.rtc.wrapper.flutter.example.beauty.BeautyVideoOutputFrameListener;
import cn.rongcloud.rtc.wrapper.flutter.example.utils.UIThreadHandler;
import cn.rongcloud.rtc.wrapper.flutter.example.yuv.LocalYuvVideoFrameListener;
import cn.rongcloud.rtc.wrapper.flutter.example.yuv.RemoteYuvVideoFrameListener;
import cn.rongcloud.rtc.wrapper.listener.IRCRTCIWLocalDeviceErrorListener;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {

    private static Context context;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        context = getApplicationContext();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_DENIED ||
                    checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_DENIED) {
                String[] permissions = new String[]{
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                };
                requestPermissions(permissions, 1000);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        for (int permission : grantResults) {
            if (permission == PackageManager.PERMISSION_DENIED) {
                Toast.makeText(this, "申请权限失败", Toast.LENGTH_LONG).show();
                break;
            }
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        init(flutterEngine.getDartExecutor().getBinaryMessenger());
    }

    @Override
    public void cleanUpFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine);
        releaseChannel();
    }

    public static Context getMainContext() {
        return context;
    }

    private void init(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "cn.rongcloud.rtc.flutter.demo");
        channel.setMethodCallHandler(this);
    }

    private void releaseChannel() {
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
            case "enableLocalCustomYuv":
                enableLocalCustomYuv(call);
                UIThreadHandler.success(result, null);
                break;
            case "disableLocalCustomYuv":
                disableLocalCustomYuv();
                UIThreadHandler.success(result, null);
                break;
            case "enableRemoteCustomYuv":
                enableRemoteCustomYuv(call);
                UIThreadHandler.success(result, null);
                break;
            case "disableRemoteCustomYuv":
                disableRemoteCustomYuv(call);
                UIThreadHandler.success(result, null);
                break;
            case "disableAllRemoteCustomYuv":
                disableAllRemoteCustomYuv();
                UIThreadHandler.success(result, null);
                break;
            case "writeReceiveVideoFps":
                writeReceiveVideoFps(call);
                UIThreadHandler.success(result, null);
                break;
            case "writeReceiveVideoBitrate":
                writeReceiveVideoBitrate(call);
                UIThreadHandler.success(result, null);
                break;
            case "startAudioRouteing":
                setLocalDeviceErrorListener();
                startAudioRouteing();
                UIThreadHandler.success(result, null);
                break;
            case "stopAudioRouteing":
                stopAudioRouteing();
                UIThreadHandler.success(result, null);
                break;
            case "resetAudioRouteing":
                resetAudioRouteing();
                UIThreadHandler.success(result, null);
                break;
        }
    }

    private void openBeauty() {
        if (beautyVideoOutputFrameListener == null) {
            beautyVideoOutputFrameListener = new BeautyVideoOutputFrameListener();
            RCRTCEngineWrapper.getInstance().setLocalVideoProcessedListener(beautyVideoOutputFrameListener);
        }
    }

    private void closeBeauty() {
        if (beautyVideoOutputFrameListener != null) {
            RCRTCEngineWrapper.getInstance().setLocalVideoProcessedListener(null);
            beautyVideoOutputFrameListener.destroy();
            beautyVideoOutputFrameListener = null;
        }
    }

    private void enableLocalCustomYuv(MethodCall call) {
        if (localYuvVideoFrameListener == null) {
            String roomId = call.argument("rid");
            String hostId = call.argument("hid");
            String userId = call.argument("uid");
            String tag = call.argument("tag");
            localYuvVideoFrameListener = new LocalYuvVideoFrameListener(this, roomId, hostId, userId, tag);
            RCRTCEngineWrapper.getInstance().setLocalCustomVideoProcessedListener(tag, localYuvVideoFrameListener);
        }
    }

    private void disableLocalCustomYuv() {
        if (localYuvVideoFrameListener != null) {
            RCRTCEngineWrapper.getInstance().setLocalCustomVideoProcessedListener(localYuvVideoFrameListener.getTag(), null);
            localYuvVideoFrameListener.destroy();
            localYuvVideoFrameListener = null;
        }
    }

    private void enableRemoteCustomYuv(MethodCall call) {
        String roomId = call.argument("rid");
        String hostId = call.argument("hid");
        String userId = call.argument("uid");
        String tag = call.argument("tag");
        String key = userId + "@" + tag;
        RemoteYuvVideoFrameListener listener = remoteYuvVideoFrameListeners.get(key);
        if (listener == null) {
            listener = new RemoteYuvVideoFrameListener(this, roomId, hostId, userId, tag);
            remoteYuvVideoFrameListeners.put(key, listener);
            RCRTCEngineWrapper.getInstance().setRemoteCustomVideoProcessedListener(userId, tag, listener);
        }
    }

    private void disableRemoteCustomYuv(MethodCall call) {
        String userId = call.argument("id");
        String tag = call.argument("tag");
        String key = userId + "@" + tag;
        RemoteYuvVideoFrameListener listener = remoteYuvVideoFrameListeners.remove(key);
        if (listener != null) {
            RCRTCEngineWrapper.getInstance().setRemoteCustomVideoProcessedListener(userId, tag, null);
            listener.destroy();
        }
    }

    private void disableAllRemoteCustomYuv() {
        for (RemoteYuvVideoFrameListener listener : remoteYuvVideoFrameListeners.values()) {
            RCRTCEngineWrapper.getInstance().setRemoteCustomVideoProcessedListener(listener.getUserId(), listener.getTag(), null);
            listener.destroy();
        }
        remoteYuvVideoFrameListeners.clear();
    }

    private void writeReceiveVideoFps(MethodCall call) {
        String userId = call.argument("id");
        String tag = call.argument("tag");
        String fps = call.argument("fps");
        String key = userId + "@" + tag;
        RemoteYuvVideoFrameListener listener = remoteYuvVideoFrameListeners.get(key);
        if (listener != null) {
            listener.writeFps(fps);
        }
    }

    private void writeReceiveVideoBitrate(MethodCall call) {
        String userId = call.argument("id");
        String tag = call.argument("tag");
        String bitrate = call.argument("bitrate");
        String key = userId + "@" + tag;
        RemoteYuvVideoFrameListener listener = remoteYuvVideoFrameListeners.get(key);
        if (listener != null) {
            listener.writeBitrate(bitrate);
        }
    }

    private void startAudioRouteing() {
        if (audioRouteingListener == null) {
            audioRouteingListener = new AudioRouteingListener();
        }
        RCRTCEngineWrapper.getInstance().startAudioRouteing(audioRouteingListener);
    }

    private void stopAudioRouteing() {
        RCRTCEngineWrapper.getInstance().stopAudioRouteing();
        if (audioRouteingListener != null) {
            audioRouteingListener = null;
        }
    }

    private void resetAudioRouteing() {
        Toast.makeText(getMainContext(),"重置成功",Toast.LENGTH_SHORT).show();
        RCRTCEngineWrapper.getInstance().resetAudioRouteingState();
    }

    private int setLocalDeviceErrorListener() {
        return RCRTCEngineWrapper.getInstance().setLocalDeviceErrorListener(new IRCRTCIWLocalDeviceErrorListener(){
            @Override
            public void onAudioDeviceError(RCRTCIWAudioDeviceErrorType type) {
                String tipString = "";
                switch (type) {
                    case IN_INTERRUPTION:
                        tipString = "音频采集设备被其他应用抢占";
                        break;
                    case END_INTERRUPTION:
                        tipString = "其他应用释放音频设备，尝试恢复音频设备";
                        break;
                    case AUDIO_RECORD_START_FAILED:
                        tipString = "开启音频采集设备失败";
                        break;
                    default:
                        tipString = "未知错误";
                        break;
                }
                Log.e("Flutter_RTC_Demo", "音频设备错误状态：" + tipString);
            }

            @Override
            public void onVideoDeviceError(RCRTCIWVideoDeviceErrorType type) {
                String tipString = "";
                switch (type) {
                    case IN_INTERRUPTION:
                        tipString = "摄像头资源被其他应用抢占";
                        break;
                    case END_INTERRUPTION:
                        tipString = "摄像头资源恢复";
                        break;
                    case END_CAMERA_ERROR_UNKNOWN:
                        // 对应Camera.ErrorCallback#CAMERA_ERROR_UNKNOWN
                        // 目前应用退后台后，摄像头自动停止采集这种场景Camera会报CAMERA_ERROR_UNKNOWN，应通知开发者
                        tipString = "应用退后台自动停止采集";
                        break;
                    default:
                        tipString = "未知错误";
                        break;
                }
                Log.e("Flutter_RTC_Demo", "摄像头错误状态：" + tipString);
            }
        });
    }

    private MethodChannel channel;
    private BeautyVideoOutputFrameListener beautyVideoOutputFrameListener;
    private AudioRouteingListener audioRouteingListener;
    private LocalYuvVideoFrameListener localYuvVideoFrameListener;
    private final HashMap<String, RemoteYuvVideoFrameListener> remoteYuvVideoFrameListeners = new HashMap<>();
}
