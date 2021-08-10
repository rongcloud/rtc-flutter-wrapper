package cn.rongcloud.rongcloud_rtc_wrapper_plugin;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * RongcloudRtcWrapperPlugin
 */
public class RCRTCWrapperPlugin implements FlutterPlugin {

    private static final String VER = "5.0.0";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        RCRTCEngineWrapper.getInstance().init(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getFlutterAssets());
        RCRTCViewWrapper.getInstance().init(flutterPluginBinding.getTextureRegistry(), flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        RCRTCEngineWrapper.getInstance().unInit();
        RCRTCViewWrapper.getInstance().unInit();
    }
}
