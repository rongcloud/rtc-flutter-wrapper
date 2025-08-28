package cn.rongcloud.rtc.wrapper.flutter;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/**
 * RongcloudRtcWrapperPlugin
 */
public class RCRTCWrapperPlugin implements FlutterPlugin, ActivityAware, Application.ActivityLifecycleCallbacks {

    public RCRTCEngineWrapper engineWrapper;
    public RCRTCViewWrapper viewWrapper;
    private Activity activity;
    private Application application;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        engineWrapper = new RCRTCEngineWrapper();
        engineWrapper.init(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getFlutterAssets(), flutterPluginBinding.getFlutterEngine());
        viewWrapper = new RCRTCViewWrapper();
        viewWrapper.init(flutterPluginBinding.getTextureRegistry(), flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        engineWrapper.unInit();
        viewWrapper.unInit();
    }

    // ActivityAware
    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
        this.application = this.activity.getApplication();
        this.application.registerActivityLifecycleCallbacks(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        if (this.application != null) {
            this.application.unregisterActivityLifecycleCallbacks(this);
        }
        this.activity = null;
        this.application = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        if (this.application != null) {
            this.application.unregisterActivityLifecycleCallbacks(this);
        }
        this.activity = null;
        this.application = null;
    }

    // Application.ActivityLifecycleCallbacks
    @Override
    public void onActivityResumed(@NonNull Activity activity) {
        if (this.activity == activity && viewWrapper != null) {
            // 重新创建 EGL Surface，修复回前台后画面停在最后一帧
            viewWrapper.onActivityResumed();
            if (engineWrapper != null) {
                engineWrapper.onActivityResumed();
            }
        }
    }

    @Override public void onActivityCreated(@NonNull Activity activity, Bundle savedInstanceState) { }
    @Override public void onActivityStarted(@NonNull Activity activity) { }
    @Override public void onActivityPaused(@NonNull Activity activity) { }
    @Override public void onActivityStopped(@NonNull Activity activity) { }
    @Override public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) { }
    @Override public void onActivityDestroyed(@NonNull Activity activity) { }
}
