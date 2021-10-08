package cn.rongcloud.rtc.wrapper.flutter;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.NonNull;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;

import cn.rongcloud.rtc.core.EglBase;
import cn.rongcloud.rtc.wrapper.RCRTCIWEngine;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWCamera;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWLocalAudioStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWLocalVideoStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWMediaType;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWNetworkStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWRemoteAudioStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWRemoteVideoStats;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWListener;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnReadableAudioFrameListener;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnReadableVideoFrameListener;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnWritableAudioFrameListener;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnWritableVideoFrameListener;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWStatusListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.rong.flutter.imlib.MessageFactory;
import io.rong.imlib.model.Message;

/**
 * @author panmingda
 * @date 2021/6/9
 */
public final class RCRTCEngineWrapper implements MethodCallHandler {

    public static RCRTCEngineWrapper getInstance() {
        return SingletonHolder.instance;
    }

    private RCRTCEngineWrapper() {
    }

    void init(Context context, BinaryMessenger messenger, FlutterAssets assets) {
        this.context = context;
        this.assets = assets;
        channel = new MethodChannel(messenger, "cn.rongcloud.rtc.flutter/engine");
        channel.setMethodCallHandler(this);
    }

    void unInit() {
        context = null;
        channel.setMethodCallHandler(null);
    }

    public int setLocalAudioCapturedListener(RCRTCIWOnWritableAudioFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setLocalAudioCapturedListener(listener);
        }
        return code;
    }

    public int setLocalAudioMixedListener(RCRTCIWOnReadableAudioFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setLocalAudioMixedListener(listener);
        }
        return code;
    }

    public int setRemoteAudioReceivedListener(String userId, RCRTCIWOnReadableAudioFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setRemoteAudioReceivedListener(userId, listener);
        }
        return code;
    }

    public int setRemoteAudioMixedListener(RCRTCIWOnWritableAudioFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setRemoteAudioMixedListener(listener);
        }
        return code;
    }

    public int setLocalVideoProcessedListener(RCRTCIWOnWritableVideoFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setLocalVideoProcessedListener(listener);
        }
        return code;
    }

    public int setRemoteVideoProcessedListener(String userId, RCRTCIWOnReadableVideoFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setRemoteVideoProcessedListener(userId, listener);
        }
        return code;
    }

    public int setLocalCustomVideoProcessedListener(String tag, RCRTCIWOnWritableVideoFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setLocalCustomVideoProcessedListener(tag, listener);
        }
        return code;
    }

    public int setRemoteCustomVideoProcessedListener(String userId, String tag, RCRTCIWOnReadableVideoFrameListener listener) {
        int code = -1;
        if (engine != null) {
            code = engine.setRemoteCustomVideoProcessedListener(userId, tag, listener);
        }
        return code;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "create":
                create(call, result);
                break;
            case "destroy":
                destroy(result);
                break;
            case "joinRoom":
                joinRoom(call, result);
                break;
            case "leaveRoom":
                leaveRoom(result);
                break;
            case "publish":
                publish(call, result);
                break;
            case "unpublish":
                unpublish(call, result);
                break;
            case "subscribe":
                subscribe(call, result);
                break;
            case "subscribes":
                subscribes(call, result);
                break;
            case "subscribeLiveMix":
                subscribeLiveMix(call, result);
                break;
            case "unsubscribe":
                unsubscribe(call, result);
                break;
            case "unsubscribes":
                unsubscribes(call, result);
                break;
            case "unsubscribeLiveMix":
                unsubscribeLiveMix(call, result);
                break;
            case "setAudioConfig":
                setAudioConfig(call, result);
                break;
            case "setVideoConfig":
                setVideoConfig(call, result);
                break;
            case "enableMicrophone":
                enableMicrophone(call, result);
                break;
            case "enableSpeaker":
                enableSpeaker(call, result);
                break;
            case "adjustLocalVolume":
                adjustLocalVolume(call, result);
                break;
            case "enableCamera":
                enableCamera(call, result);
                break;
            case "switchCamera":
                switchCamera(result);
                break;
            case "switchToCamera":
                switchToCamera(call, result);
                break;
            case "whichCamera":
                whichCamera(result);
                break;
            case "isCameraFocusSupported":
                isCameraFocusSupported(result);
                break;
            case "isCameraExposurePositionSupported":
                isCameraExposurePositionSupported(result);
                break;
            case "setCameraFocusPositionInPreview":
                setCameraFocusPositionInPreview(call, result);
                break;
            case "setCameraExposurePositionInPreview":
                setCameraExposurePositionInPreview(call, result);
                break;
            case "setCameraCaptureOrientation":
                setCameraCaptureOrientation(call, result);
                break;
            case "setLocalView":
                setLocalView(call, result);
                break;
            case "removeLocalView":
                removeLocalView(result);
                break;
            case "setRemoteView":
                setRemoteView(call, result);
                break;
            case "removeRemoteView":
                removeRemoteView(call, result);
                break;
            case "setLiveMixView":
                setLiveMixView(call, result);
                break;
            case "removeLiveMixView":
                removeLiveMixView(result);
                break;
            case "muteLocalStream":
                muteLocalStream(call, result);
                break;
            case "muteRemoteStream":
                muteRemoteStream(call, result);
                break;
            case "addLiveCdn":
                addLiveCdn(call, result);
                break;
            case "removeLiveCdn":
                removeLiveCdn(call, result);
                break;
            case "setLiveMixLayoutMode":
                setLiveMixLayoutMode(call, result);
                break;
            case "setLiveMixRenderMode":
                setLiveMixRenderMode(call, result);
                break;
            case "setLiveMixCustomLayouts":
                setLiveMixCustomLayouts(call, result);
                break;
            case "setLiveMixCustomAudios":
                setLiveMixCustomAudios(call, result);
                break;
            case "setLiveMixAudioBitrate":
                setLiveMixAudioBitrate(call, result);
                break;
            case "setLiveMixVideoBitrate":
                setLiveMixVideoBitrate(call, result);
                break;
            case "setLiveMixVideoResolution":
                setLiveMixVideoResolution(call, result);
                break;
            case "setLiveMixVideoFps":
                setLiveMixVideoFps(call, result);
                break;
            case "setStatsListener":
                setStatsListener(call, result);
                break;
            case "createAudioEffect":
                createAudioEffect(call, result);
                break;
            case "releaseAudioEffect":
                releaseAudioEffect(call, result);
                break;
            case "playAudioEffect":
                playAudioEffect(call, result);
                break;
            case "pauseAudioEffect":
                pauseAudioEffect(call, result);
                break;
            case "pauseAllAudioEffects":
                pauseAllAudioEffects(result);
                break;
            case "resumeAudioEffect":
                resumeAudioEffect(call, result);
                break;
            case "resumeAllAudioEffects":
                resumeAllAudioEffects(result);
                break;
            case "stopAudioEffect":
                stopAudioEffect(call, result);
                break;
            case "stopAllAudioEffects":
                stopAllAudioEffects(result);
                break;
            case "adjustAudioEffectVolume":
                adjustAudioEffectVolume(call, result);
                break;
            case "getAudioEffectVolume":
                getAudioEffectVolume(call, result);
                break;
            case "adjustAllAudioEffectsVolume":
                adjustAllAudioEffectsVolume(call, result);
                break;
            case "startAudioMixing":
                startAudioMixing(call, result);
                break;
            case "stopAudioMixing":
                stopAudioMixing(result);
                break;
            case "pauseAudioMixing":
                pauseAudioMixing(result);
                break;
            case "resumeAudioMixing":
                resumeAudioMixing(result);
                break;
            case "adjustAudioMixingVolume":
                adjustAudioMixingVolume(call, result);
                break;
            case "adjustAudioMixingPlaybackVolume":
                adjustAudioMixingPlaybackVolume(call, result);
                break;
            case "getAudioMixingPlaybackVolume":
                getAudioMixingPlaybackVolume(result);
                break;
            case "adjustAudioMixingPublishVolume":
                adjustAudioMixingPublishVolume(call, result);
                break;
            case "getAudioMixingPublishVolume":
                getAudioMixingPublishVolume(result);
                break;
            case "setAudioMixingPosition":
                setAudioMixingPosition(call, result);
                break;
            case "getAudioMixingPosition":
                getAudioMixingPosition(result);
                break;
            case "getAudioMixingDuration":
                getAudioMixingDuration(result);
                break;
            case "getSessionId":
                getSessionId(result);
                break;
            case "createCustomStreamFromFile":
                createCustomStreamFromFile(call, result);
                break;
            case "setCustomStreamVideoConfig":
                setCustomStreamVideoConfig(call, result);
                break;
            case "muteLocalCustomStream":
                muteLocalCustomStream(call, result);
                break;
            case "setLocalCustomStreamView":
                setLocalCustomStreamView(call, result);
                break;
            case "removeLocalCustomStreamView":
                removeLocalCustomStreamView(call, result);
                break;
            case "publishCustomStream":
                publishCustomStream(call, result);
                break;
            case "unpublishCustomStream":
                unpublishCustomStream(call, result);
                break;
            case "muteRemoteCustomStream":
                muteRemoteCustomStream(call, result);
                break;
            case "setRemoteCustomStreamView":
                setRemoteCustomStreamView(call, result);
                break;
            case "removeRemoteCustomStreamView":
                removeRemoteCustomStreamView(call, result);
                break;
            case "subscribeCustomStream":
                subscribeCustomStream(call, result);
                break;
            case "unsubscribeCustomStream":
                unsubscribeCustomStream(call, result);
                break;
            default:
                MainThreadPoster.notImplemented(result);
                break;
        }
    }

    private void create(@NonNull MethodCall call, @NonNull Result result) {
        if (engine == null) {
            HashMap<String, Object> setup = call.argument("setup");
            if (setup != null) {
                engine = RCRTCIWEngine.create(context, ArgumentAdapter.toEngineSetup(setup));
            } else {
                engine = RCRTCIWEngine.create(context);
            }
            engine.setListener(new ListenerImpl());
        }
        MainThreadPoster.success(result);
    }

    private void destroy(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            engine.destroy();
            engine = null;
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void joinRoom(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            HashMap<String, Object> setup = call.argument("setup");
            assert (setup != null);
            code = engine.joinRoom(id, ArgumentAdapter.toRoomSetup(setup));
        }
        MainThreadPoster.success(result, code);
    }

    private void leaveRoom(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.leaveRoom();
        }
        MainThreadPoster.success(result, code);
    }

    private void publish(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer type = call.argument("type");
            assert (type != null);
            code = engine.publish(ArgumentAdapter.toMediaType(type));
        }
        MainThreadPoster.success(result, code);
    }

    private void unpublish(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer type = call.argument("type");
            assert (type != null);
            code = engine.unpublish(ArgumentAdapter.toMediaType(type));
        }
        MainThreadPoster.success(result, code);
    }

    private void subscribe(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            Integer type = call.argument("type");
            assert (type != null);
            Boolean tiny = call.argument("tiny");
            assert (tiny != null);
            code = engine.subscribe(id, ArgumentAdapter.toMediaType(type), tiny);
        }
        MainThreadPoster.success(result, code);
    }

    private void subscribes(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            List<String> ids = call.argument("ids");
            Integer type = call.argument("type");
            assert (type != null);
            Boolean tiny = call.argument("tiny");
            assert (tiny != null);
            code = engine.subscribe(ids, ArgumentAdapter.toMediaType(type), tiny);
        }
        MainThreadPoster.success(result, code);
    }

    private void subscribeLiveMix(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer type = call.argument("type");
            assert (type != null);
            Boolean tiny = call.argument("tiny");
            assert (tiny != null);
            code = engine.subscribeLiveMix(ArgumentAdapter.toMediaType(type), tiny);
        }
        MainThreadPoster.success(result, code);
    }

    private void unsubscribe(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            Integer type = call.argument("type");
            assert (type != null);
            code = engine.unsubscribe(id, ArgumentAdapter.toMediaType(type));
        }
        MainThreadPoster.success(result, code);
    }

    private void unsubscribes(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            List<String> ids = call.argument("ids");
            Integer type = call.argument("type");
            assert (type != null);
            code = engine.unsubscribe(ids, ArgumentAdapter.toMediaType(type));
        }
        MainThreadPoster.success(result, code);
    }

    private void unsubscribeLiveMix(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer type = call.argument("type");
            assert (type != null);
            code = engine.unsubscribeLiveMix(ArgumentAdapter.toMediaType(type));
        }
        MainThreadPoster.success(result, code);
    }

    private void setAudioConfig(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            HashMap<String, Object> config = call.argument("config");
            assert (config != null);
            code = engine.setAudioConfig(ArgumentAdapter.toAudioConfig(config));
        }
        MainThreadPoster.success(result, code);
    }

    private void setVideoConfig(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            HashMap<String, Object> config = call.argument("config");
            assert (config != null);
            Boolean tiny = call.argument("tiny");
            assert (tiny != null);
            code = engine.setVideoConfig(ArgumentAdapter.toVideoConfig(config), tiny);
        }
        MainThreadPoster.success(result, code);
    }

    private void enableMicrophone(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            boolean enable = (boolean) call.arguments;
            code = engine.enableMicrophone(enable);
        }
        MainThreadPoster.success(result, code);
    }

    private void enableSpeaker(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            boolean enable = (boolean) call.arguments;
            code = engine.enableSpeaker(enable);
        }
        MainThreadPoster.success(result, code);
    }

    private void adjustLocalVolume(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int volume = (int) call.arguments;
            code = engine.adjustLocalVolume(volume);
        }
        MainThreadPoster.success(result, code);
    }

    private void enableCamera(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Boolean enable = call.argument("enable");
            assert (enable != null);
            Integer camera = call.argument("camera");
            if (camera != null) {
                code = engine.enableCamera(enable, ArgumentAdapter.toCamera(camera));
            } else {
                code = engine.enableCamera(enable);
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void switchCamera(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.switchCamera();
        }
        MainThreadPoster.success(result, code);
    }

    private void switchToCamera(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int camera = (int) call.arguments;
            code = engine.switchToCamera(ArgumentAdapter.toCamera(camera));
        }
        MainThreadPoster.success(result, code);
    }

    private void whichCamera(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            RCRTCIWCamera camera = engine.whichCamera();
            code = camera.getCamera();
        }
        MainThreadPoster.success(result, code);
    }

    private void isCameraFocusSupported(@NonNull Result result) {
        boolean code = false;
        if (engine != null) {
            code = engine.isCameraFocusSupported();
        }
        MainThreadPoster.success(result, code);
    }

    private void isCameraExposurePositionSupported(@NonNull Result result) {
        boolean code = false;
        if (engine != null) {
            code = engine.isCameraExposurePositionSupported();
        }
        MainThreadPoster.success(result, code);
    }

    private void setCameraFocusPositionInPreview(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Double x = call.argument("x");
            assert (x != null);
            Double y = call.argument("y");
            assert (y != null);
            code = engine.setCameraFocusPositionInPreview(x.floatValue(), y.floatValue());
        }
        MainThreadPoster.success(result, code);
    }

    private void setCameraExposurePositionInPreview(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Double x = call.argument("x");
            assert (x != null);
            Double y = call.argument("y");
            assert (y != null);
            code = engine.setCameraExposurePositionInPreview(x.floatValue(), y.floatValue());
        }
        MainThreadPoster.success(result, code);
    }

    private void setCameraCaptureOrientation(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer orientation = call.argument("orientation");
            assert (orientation != null);
            code = engine.setCameraCaptureOrientation(ArgumentAdapter.toCameraCaptureOrientation(orientation));
        }
        MainThreadPoster.success(result, code);
    }

    private void setLocalView(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer view = call.argument("view");
            assert (view != null);
            RCRTCViewWrapper.RCRTCView origin = RCRTCViewWrapper.getInstance().getView(view);
            assert (origin != null);
            try {
                Integer ret = (Integer) SET_LOCAL_VIEW_METHOD.invoke(engine, origin.view);
                assert (ret != null);
                code = ret;
            } catch (IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void removeLocalView(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.removeLocalView();
        }
        MainThreadPoster.success(result, code);
    }

    private void setRemoteView(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            assert (id != null);
            Integer view = call.argument("view");
            assert (view != null);
            RCRTCViewWrapper.RCRTCView origin = RCRTCViewWrapper.getInstance().getView(view);
            assert (origin != null);
            try {
                Integer ret = (Integer) SET_REMOTE_VIEW_METHOD.invoke(engine, id, origin.view);
                assert (ret != null);
                code = ret;
            } catch (IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void removeRemoteView(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String id = (String) call.arguments;
            code = engine.removeRemoteView(id);
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixView(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer view = call.argument("view");
            assert (view != null);
            RCRTCViewWrapper.RCRTCView origin = RCRTCViewWrapper.getInstance().getView(view);
            assert (origin != null);
            try {
                Integer ret = (Integer) SET_LIVE_MIX_VIEW_METHOD.invoke(engine, origin.view);
                assert (ret != null);
                code = ret;
            } catch (IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void removeLiveMixView(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.removeLiveMixView();
        }
        MainThreadPoster.success(result, code);
    }

    private void muteLocalStream(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer type = call.argument("type");
            assert (type != null);
            Boolean mute = call.argument("mute");
            assert (mute != null);
            code = engine.muteLocalStream(ArgumentAdapter.toMediaType(type), mute);
        }
        MainThreadPoster.success(result, code);
    }

    private void muteRemoteStream(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            Integer type = call.argument("type");
            assert (type != null);
            Boolean mute = call.argument("mute");
            assert (mute != null);
            code = engine.muteRemoteStream(id, ArgumentAdapter.toMediaType(type), mute);
        }
        MainThreadPoster.success(result, code);
    }

    private void addLiveCdn(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String url = (String) call.arguments;
            code = engine.addLiveCdn(url);
        }
        MainThreadPoster.success(result, code);
    }

    private void removeLiveCdn(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String url = (String) call.arguments;
            code = engine.removeLiveCdn(url);
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixLayoutMode(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int mode = (int) call.arguments;
            code = engine.setLiveMixLayoutMode(ArgumentAdapter.toLiveMixLayoutMode(mode));
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixRenderMode(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int mode = (int) call.arguments;
            code = engine.setLiveMixRenderMode(ArgumentAdapter.toLiveMixRenderMode(mode));
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixCustomLayouts(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            List<HashMap<String, Object>> layouts = call.argument("layouts");
            assert (layouts != null);
            code = engine.setLiveMixCustomLayouts(ArgumentAdapter.toLiveMixCustomLayouts(layouts));
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixCustomAudios(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            List<String> ids = call.argument("ids");
            assert (ids != null);
            code = engine.setLiveMixCustomAudios(ids);
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixAudioBitrate(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int bitrate = (int) call.arguments;
            code = engine.setLiveMixAudioBitrate(bitrate);
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixVideoBitrate(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer bitrate = call.argument("bitrate");
            assert (bitrate != null);
            Boolean tiny = call.argument("tiny");
            assert (tiny != null);
            code = engine.setLiveMixVideoBitrate(bitrate, tiny);
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixVideoResolution(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer width = call.argument("width");
            assert (width != null);
            Integer height = call.argument("height");
            assert (height != null);
            Boolean tiny = call.argument("tiny");
            assert (tiny != null);
            code = engine.setLiveMixVideoResolution(width, height, tiny);
        }
        MainThreadPoster.success(result, code);
    }

    private void setLiveMixVideoFps(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer fps = call.argument("fps");
            assert (fps != null);
            Boolean tiny = call.argument("tiny");
            assert (tiny != null);
            code = engine.setLiveMixVideoFps(ArgumentAdapter.toVideoFps(fps), tiny);
        }
        MainThreadPoster.success(result, code);
    }

    private void setStatsListener(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            boolean remove = (boolean) call.arguments;
            if (remove) {
                code = engine.setStatsListener(null);
            } else {
                code = engine.setStatsListener(new StatsListenerImpl());
            }
        }
        MainThreadPoster.success(result, code);
    }

    private String getAssetsPath(String assets) {
        if (assets == null) return null;
        return "file:///android_asset/" + this.assets.getAssetFilePathByName(assets);
    }

    private void createAudioEffect(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String path = call.argument("path");
            String assets = call.argument("assets");
            String file = path != null ? path : getAssetsPath(assets);
            assert (file != null);
            URI uri = null;
            try {
                uri = new URI(file);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            }
            assert (uri != null);
            Integer id = call.argument("id");
            assert (id != null);
            code = engine.createAudioEffect(uri, id);
        }
        MainThreadPoster.success(result, code);
    }

    private void releaseAudioEffect(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int id = (int) call.arguments;
            code = engine.releaseAudioEffect(id);
        }
        MainThreadPoster.success(result, code);
    }

    private void playAudioEffect(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer id = call.argument("id");
            assert (id != null);
            Integer volume = call.argument("volume");
            assert (volume != null);
            Integer loop = call.argument("loop");
            assert (loop != null);
            code = engine.playAudioEffect(id, volume, loop);
        }
        MainThreadPoster.success(result, code);
    }

    private void pauseAudioEffect(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int id = (int) call.arguments;
            code = engine.pauseAudioEffect(id);
        }
        MainThreadPoster.success(result, code);
    }

    private void pauseAllAudioEffects(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.pauseAllAudioEffects();
        }
        MainThreadPoster.success(result, code);
    }

    private void resumeAudioEffect(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int id = (int) call.arguments;
            code = engine.resumeAudioEffect(id);
        }
        MainThreadPoster.success(result, code);
    }

    private void resumeAllAudioEffects(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.resumeAllAudioEffects();
        }
        MainThreadPoster.success(result, code);
    }

    private void stopAudioEffect(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int id = (int) call.arguments;
            code = engine.stopAudioEffect(id);
        }
        MainThreadPoster.success(result, code);
    }

    private void stopAllAudioEffects(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.stopAllAudioEffects();
        }
        MainThreadPoster.success(result, code);
    }

    private void adjustAudioEffectVolume(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Integer id = call.argument("id");
            assert (id != null);
            Integer volume = call.argument("volume");
            assert (volume != null);
            code = engine.adjustAudioEffectVolume(id, volume);
        }
        MainThreadPoster.success(result, code);
    }

    private void getAudioEffectVolume(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int id = (int) call.arguments();
            code = engine.getAudioEffectVolume(id);
        }
        MainThreadPoster.success(result, code);
    }

    private void adjustAllAudioEffectsVolume(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int volume = (int) call.arguments();
            code = engine.adjustAllAudioEffectsVolume(volume);
        }
        MainThreadPoster.success(result, code);
    }

    private void startAudioMixing(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String path = call.argument("path");
            String assets = call.argument("assets");
            String file = path != null ? path : getAssetsPath(assets);
            assert (file != null);
            URI uri = null;
            try {
                uri = new URI(file);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            }
            assert (uri != null);
            Integer mode = call.argument("mode");
            assert (mode != null);
            Boolean playback = call.argument("playback");
            assert (playback != null);
            Integer loop = call.argument("loop");
            assert (loop != null);
            code = engine.startAudioMixing(uri, ArgumentAdapter.toAudioMixingMode(mode), playback, loop);
        }
        MainThreadPoster.success(result, code);
    }

    private void stopAudioMixing(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.stopAudioMixing();
        }
        MainThreadPoster.success(result, code);
    }

    private void pauseAudioMixing(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.pauseAudioMixing();
        }
        MainThreadPoster.success(result, code);
    }

    private void resumeAudioMixing(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.resumeAudioMixing();
        }
        MainThreadPoster.success(result, code);
    }

    private void adjustAudioMixingVolume(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int volume = (int) call.arguments;
            code = engine.adjustAudioMixingVolume(volume);
        }
        MainThreadPoster.success(result, code);
    }

    private void adjustAudioMixingPlaybackVolume(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int volume = (int) call.arguments;
            code = engine.adjustAudioMixingPlaybackVolume(volume);
        }
        MainThreadPoster.success(result, code);
    }

    private void getAudioMixingPlaybackVolume(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.getAudioMixingPlaybackVolume();
        }
        MainThreadPoster.success(result, code);
    }

    private void adjustAudioMixingPublishVolume(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            int volume = (int) call.arguments;
            code = engine.adjustAudioMixingPublishVolume(volume);
        }
        MainThreadPoster.success(result, code);
    }

    private void getAudioMixingPublishVolume(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.getAudioMixingPublishVolume();
        }
        MainThreadPoster.success(result, code);
    }

    private void setAudioMixingPosition(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            double position = (double) call.arguments;
            code = engine.setAudioMixingPosition(position);
        }
        MainThreadPoster.success(result, code);
    }

    private void getAudioMixingPosition(@NonNull Result result) {
        double code = -1;
        if (engine != null) {
            code = engine.getAudioMixingPosition();
        }
        MainThreadPoster.success(result, code);
    }

    private void getAudioMixingDuration(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            code = engine.getAudioMixingDuration();
        }
        MainThreadPoster.success(result, code);
    }

    private void getSessionId(@NonNull Result result) {
        String code = null;
        if (engine != null) {
            code = engine.getSessionId();
        }
        MainThreadPoster.success(result, code);
    }

    private void createCustomStreamFromFile(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String path = call.argument("path");
            String assets = call.argument("assets");
            String file = path != null ? path : getAssetsPath(assets);
            assert (file != null);
            URI uri = null;
            try {
                uri = new URI(file);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            }
            assert (uri != null);
            String tag = call.argument("tag");
            assert (tag != null);
            Boolean replace = call.argument("replace");
            assert (replace != null);
            Boolean playback = call.argument("playback");
            assert (playback != null);
            code = engine.createCustomStreamFromFile(uri, tag, replace, playback);
        }
        MainThreadPoster.success(result, code);
    }

    private void setCustomStreamVideoConfig(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String tag = call.argument("tag");
            assert (tag != null);
            HashMap<String, Object> config = call.argument("config");
            assert (config != null);
            code = engine.setCustomStreamVideoConfig(tag, ArgumentAdapter.toVideoConfig(config));
        }
        MainThreadPoster.success(result, code);
    }

    private void muteLocalCustomStream(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String tag = call.argument("tag");
            assert (tag != null);
            Boolean mute = call.argument("mute");
            assert (mute != null);
            code = engine.muteLocalCustomStream(tag, mute);
        }
        MainThreadPoster.success(result, code);
    }

    private void setLocalCustomStreamView(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String tag = call.argument("tag");
            assert (tag != null);
            Integer view = call.argument("view");
            assert (view != null);
            RCRTCViewWrapper.RCRTCView origin = RCRTCViewWrapper.getInstance().getView(view);
            assert (origin != null);
            try {
                Integer ret = (Integer) SET_LOCAL_CUSTOM_VIEW_METHOD.invoke(engine, tag, origin.view);
                assert (ret != null);
                code = ret;
            } catch (IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void removeLocalCustomStreamView(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String tag = (String) call.arguments;
            code = engine.removeLocalCustomStreamView(tag);
        }
        MainThreadPoster.success(result, code);
    }

    private void publishCustomStream(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String tag = (String) call.arguments;
            code = engine.publishCustomStream(tag);
        }
        MainThreadPoster.success(result, code);
    }

    private void unpublishCustomStream(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String tag = (String) call.arguments;
            code = engine.unpublishCustomStream(tag);
        }
        MainThreadPoster.success(result, code);
    }

    private void muteRemoteCustomStream(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            assert (id != null);
            String tag = call.argument("tag");
            assert (tag != null);
            Boolean mute = call.argument("mute");
            assert (mute != null);
            code = engine.muteRemoteCustomStream(id, tag, mute);
        }
        MainThreadPoster.success(result, code);
    }

    private void setRemoteCustomStreamView(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            assert (id != null);
            String tag = call.argument("tag");
            assert (tag != null);
            Integer view = call.argument("view");
            assert (view != null);
            RCRTCViewWrapper.RCRTCView origin = RCRTCViewWrapper.getInstance().getView(view);
            assert (origin != null);
            try {
                Integer ret = (Integer) SET_REMOTE_CUSTOM_VIEW_METHOD.invoke(engine, id, tag, origin.view);
                assert (ret != null);
                code = ret;
            } catch (IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void removeRemoteCustomStreamView(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            assert (id != null);
            String tag = call.argument("tag");
            assert (tag != null);
            code = engine.removeRemoteCustomStreamView(id, tag);
        }
        MainThreadPoster.success(result, code);
    }

    private void subscribeCustomStream(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            assert (id != null);
            String tag = call.argument("tag");
            assert (tag != null);
            code = engine.subscribeCustomStream(id, tag);
        }
        MainThreadPoster.success(result, code);
    }

    private void unsubscribeCustomStream(MethodCall call, Result result) {
        int code = -1;
        if (engine != null) {
            String id = call.argument("id");
            assert (id != null);
            String tag = call.argument("tag");
            assert (tag != null);
            code = engine.unsubscribeCustomStream(id, tag);
        }
        MainThreadPoster.success(result, code);
    }

    EglBase.Context getEglBaseContext() {
        if (engine != null) {
            try {
                Object object = GET_EGL_BASE_CONTEXT_METHOD.invoke(engine);
                if (object instanceof EglBase.Context) return (EglBase.Context) object;
            } catch (IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    private static class SingletonHolder {
        @SuppressLint("StaticFieldLeak")
        private static final RCRTCEngineWrapper instance = new RCRTCEngineWrapper();
    }

    private class ListenerImpl extends RCRTCIWListener {
        @Override
        public void onError(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onError", arguments);
                }
            });
        }

        @Override
        public void onKicked(String id, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            if (id != null) {
                arguments.put("id", id);
            }
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onKicked", arguments);
                }
            });
        }

        @Override
        public void onRoomJoined(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRoomJoined", arguments);
                }
            });
        }

        @Override
        public void onRoomLeft(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRoomLeft", arguments);
                }
            });
        }

        @Override
        public void onPublished(RCRTCIWMediaType type, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("type", type.ordinal());
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onPublished", arguments);
                }
            });
        }

        @Override
        public void onUnpublished(RCRTCIWMediaType type, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("type", type.ordinal());
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onUnpublished", arguments);
                }
            });
        }

        @Override
        public void onSubscribed(String id, RCRTCIWMediaType type, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("type", type.ordinal());
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onSubscribed", arguments);
                }
            });
        }

        @Override
        public void onUnsubscribed(String id, RCRTCIWMediaType type, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("type", type.ordinal());
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onUnsubscribed", arguments);
                }
            });
        }

        @Override
        public void onLiveMixSubscribed(RCRTCIWMediaType type, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("type", type.ordinal());
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixSubscribed", arguments);
                }
            });
        }

        @Override
        public void onLiveMixUnsubscribed(RCRTCIWMediaType type, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("type", type.ordinal());
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixUnsubscribed", arguments);
                }
            });
        }

        @Override
        public void onEnableCamera(boolean enable, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("enable", enable);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onEnableCamera", arguments);
                }
            });
        }

        @Override
        public void onSwitchCamera(RCRTCIWCamera camera, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("camera", camera.ordinal());
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onSwitchCamera", arguments);
                }
            });
        }

        @Override
        public void onLiveCdnAdded(String url, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("url", url);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveCdnAdded", arguments);
                }
            });
        }

        @Override
        public void onLiveCdnRemoved(String url, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("url", url);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveCdnRemoved", arguments);
                }
            });
        }

        @Override
        public void onLiveMixLayoutModeSet(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixLayoutModeSet", arguments);
                }
            });
        }

        @Override
        public void onLiveMixRenderModeSet(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixRenderModeSet", arguments);
                }
            });
        }

        @Override
        public void onLiveMixCustomLayoutsSet(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixCustomLayoutsSet", arguments);
                }
            });
        }

        @Override
        public void onLiveMixCustomAudiosSet(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixCustomAudiosSet", arguments);
                }
            });
        }

        @Override
        public void onLiveMixAudioBitrateSet(int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixAudioBitrateSet", arguments);
                }
            });
        }

        @Override
        public void onLiveMixVideoBitrateSet(boolean tiny, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("tiny", tiny);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixVideoBitrateSet", arguments);
                }
            });
        }

        @Override
        public void onLiveMixVideoResolutionSet(boolean tiny, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("tiny", tiny);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixVideoResolutionSet", arguments);
                }
            });
        }

        @Override
        public void onLiveMixVideoFpsSet(boolean tiny, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("tiny", tiny);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onLiveMixVideoFpsSet", arguments);
                }
            });
        }

        @Override
        public void onAudioEffectCreated(int id, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onAudioEffectCreated", arguments);
                }
            });
        }

        @Override
        public void onAudioEffectFinished(final int id) {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onAudioEffectFinished", id);
                }
            });
        }

        @Override
        public void onAudioMixingStarted() {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onAudioMixingStarted", null);
                }
            });
        }

        @Override
        public void onAudioMixingPaused() {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onAudioMixingPaused", null);
                }
            });
        }

        @Override
        public void onAudioMixingStopped() {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onAudioMixingStopped", null);
                }
            });
        }

        @Override
        public void onAudioMixingFinished() {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onAudioMixingFinished", null);
                }
            });
        }

        @Override
        public void onUserJoined(final String id) {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onUserJoined", id);
                }
            });
        }

        @Override
        public void onUserOffline(final String id) {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onUserOffline", id);
                }
            });
        }

        @Override
        public void onUserLeft(final String id) {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onUserLeft", id);
                }
            });
        }

        @Override
        public void onRemotePublished(String id, RCRTCIWMediaType type) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("type", type.ordinal());
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemotePublished", arguments);
                }
            });
        }

        @Override
        public void onRemoteUnpublished(String id, RCRTCIWMediaType type) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("type", type.ordinal());
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteUnpublished", arguments);
                }
            });
        }

        @Override
        public void onRemoteLiveMixPublished(final RCRTCIWMediaType type) {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteLiveMixPublished", type.ordinal());
                }
            });
        }

        @Override
        public void onRemoteLiveMixUnpublished(final RCRTCIWMediaType type) {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteLiveMixUnpublished", type.ordinal());
                }
            });
        }

        @Override
        public void onRemoteStateChanged(String id, RCRTCIWMediaType type, boolean disabled) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("type", type.ordinal());
            arguments.put("disabled", disabled);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteStateChanged", arguments);
                }
            });
        }

        @Override
        public void onRemoteFirstFrame(String id, RCRTCIWMediaType type) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("type", type.ordinal());
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteFirstFrame", arguments);
                }
            });
        }

        @Override
        public void onRemoteLiveMixFirstFrame(final RCRTCIWMediaType type) {
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteLiveMixFirstFrame", type.ordinal());
                }
            });
        }

        @Override
        public void onMessageReceived(Message message) {
            final String argument = MessageFactory.getInstance().message2String(message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onMessageReceived", argument);
                }
            });
        }

        @Override
        public void onCustomStreamPublished(String tag, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("tag", tag);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onCustomStreamPublished", arguments);
                }
            });
        }

        @Override
        public void onCustomStreamUnpublished(String tag, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("tag", tag);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onCustomStreamUnpublished", arguments);
                }
            });
        }

        @Override
        public void onRemoteCustomStreamPublished(String userId, String tag) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", userId);
            arguments.put("tag", tag);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteCustomStreamPublished", arguments);
                }
            });
        }

        @Override
        public void onCustomStreamPublishFinished(String tag) {
            final String argument = tag;
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onCustomStreamPublishFinished", argument);
                }
            });
        }

        @Override
        public void onRemoteCustomStreamUnpublished(String userId, String tag) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", userId);
            arguments.put("tag", tag);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteCustomStreamUnpublished", arguments);
                }
            });
        }

        @Override
        public void onRemoteCustomStreamStateChanged(String userId, String tag, boolean disabled) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", userId);
            arguments.put("tag", tag);
            arguments.put("disabled", disabled);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteCustomStreamStateChanged", arguments);
                }
            });
        }

        @Override
        public void onRemoteCustomStreamFirstFrame(String userId, String tag) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", userId);
            arguments.put("tag", tag);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onRemoteCustomStreamFirstFrame", arguments);
                }
            });
        }

        @Override
        public void onCustomStreamSubscribed(String userId, String tag, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", userId);
            arguments.put("tag", tag);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onCustomStreamSubscribed", arguments);
                }
            });
        }

        @Override
        public void onCustomStreamUnsubscribed(String userId, String tag, int code, String message) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", userId);
            arguments.put("tag", tag);
            arguments.put("code", code);
            arguments.put("message", message);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("engine:onCustomStreamUnsubscribed", arguments);
                }
            });
        }
    }

    private class StatsListenerImpl extends RCRTCIWStatusListener {
        @Override
        public void onNetworkStats(RCRTCIWNetworkStats stats) {
            final HashMap<String, Object> argument = ArgumentAdapter.fromNetworkStats(stats);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onNetworkStats", argument);
                }
            });
        }

        @Override
        public void onLocalAudioStats(RCRTCIWLocalAudioStats stats) {
            final HashMap<String, Object> argument = ArgumentAdapter.fromLocalAudioStats(stats);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onLocalAudioStats", argument);
                }
            });
        }

        @Override
        public void onLocalVideoStats(RCRTCIWLocalVideoStats stats) {
            final HashMap<String, Object> argument = ArgumentAdapter.fromLocalVideoStats(stats);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onLocalVideoStats", argument);
                }
            });
        }

        @Override
        public void onRemoteAudioStats(String id, RCRTCIWRemoteAudioStats stats) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("stats", ArgumentAdapter.fromRemoteAudioStats(stats));
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onRemoteAudioStats", arguments);
                }
            });
        }

        @Override
        public void onRemoteVideoStats(String id, RCRTCIWRemoteVideoStats stats) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("stats", ArgumentAdapter.fromRemoteVideoStats(stats));
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onRemoteVideoStats", arguments);
                }
            });
        }

        @Override
        public void onLiveMixAudioStats(RCRTCIWRemoteAudioStats stats) {
            final HashMap<String, Object> argument = ArgumentAdapter.fromRemoteAudioStats(stats);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onLiveMixAudioStats", argument);
                }
            });
        }

        @Override
        public void onLiveMixVideoStats(RCRTCIWRemoteVideoStats stats) {
            final HashMap<String, Object> argument = ArgumentAdapter.fromRemoteVideoStats(stats);
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onLiveMixVideoStats", argument);
                }
            });
        }

        @Override
        public void onLocalCustomAudioStats(String tag, RCRTCIWLocalAudioStats stats) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("tag", tag);
            arguments.put("stats", ArgumentAdapter.fromLocalAudioStats(stats));
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onLocalCustomAudioStats", arguments);
                }
            });
        }

        @Override
        public void onLocalCustomVideoStats(String tag, RCRTCIWLocalVideoStats stats) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("tag", tag);
            arguments.put("stats", ArgumentAdapter.fromLocalVideoStats(stats));
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onLocalCustomVideoStats", arguments);
                }
            });
        }

        @Override
        public void onRemoteCustomAudioStats(String id, String tag, RCRTCIWRemoteAudioStats stats) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("tag", tag);
            arguments.put("stats", ArgumentAdapter.fromRemoteAudioStats(stats));
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onRemoteCustomAudioStats", arguments);
                }
            });
        }

        @Override
        public void onRemoteCustomVideoStats(String id, String tag, RCRTCIWRemoteVideoStats stats) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", id);
            arguments.put("tag", tag);
            arguments.put("stats", ArgumentAdapter.fromRemoteVideoStats(stats));
            MainThreadPoster.post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("stats:onRemoteCustomVideoStats", arguments);
                }
            });
        }
    }

    private Context context;
    private FlutterAssets assets;
    private MethodChannel channel;

    private RCRTCIWEngine engine = null;

    private static Method GET_EGL_BASE_CONTEXT_METHOD;
    private static Method SET_LOCAL_VIEW_METHOD;
    private static Method SET_REMOTE_VIEW_METHOD;
    private static Method SET_LIVE_MIX_VIEW_METHOD;
    private static Method SET_LOCAL_CUSTOM_VIEW_METHOD;
    private static Method SET_REMOTE_CUSTOM_VIEW_METHOD;

    static {
        try {
            Class<?> clazz = Class.forName("cn.rongcloud.rtc.wrapper.RCRTCIWEngineImpl");
            GET_EGL_BASE_CONTEXT_METHOD = clazz.getDeclaredMethod("getEglBaseContext");
            GET_EGL_BASE_CONTEXT_METHOD.setAccessible(true);
            Class<?> viewClazz = Class.forName("cn.rongcloud.rtc.wrapper.core.IRCRTCIWView");
            SET_LOCAL_VIEW_METHOD = clazz.getDeclaredMethod("setLocalView", viewClazz);
            SET_LOCAL_VIEW_METHOD.setAccessible(true);
            SET_REMOTE_VIEW_METHOD = clazz.getDeclaredMethod("setRemoteView", String.class, viewClazz);
            SET_REMOTE_VIEW_METHOD.setAccessible(true);
            SET_LIVE_MIX_VIEW_METHOD = clazz.getDeclaredMethod("setLiveMixView", viewClazz);
            SET_LIVE_MIX_VIEW_METHOD.setAccessible(true);
            SET_LOCAL_CUSTOM_VIEW_METHOD = clazz.getDeclaredMethod("setLocalCustomStreamView", String.class, viewClazz);
            SET_LOCAL_CUSTOM_VIEW_METHOD.setAccessible(true);
            SET_REMOTE_CUSTOM_VIEW_METHOD = clazz.getDeclaredMethod("setRemoteCustomStreamView", String.class, String.class, viewClazz);
            SET_REMOTE_CUSTOM_VIEW_METHOD.setAccessible(true);
        } catch (ClassNotFoundException | NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
}
