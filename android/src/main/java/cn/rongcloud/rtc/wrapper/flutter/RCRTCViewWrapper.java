package cn.rongcloud.rtc.wrapper.flutter;

import android.util.LongSparseArray;

import androidx.annotation.NonNull;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import cn.rongcloud.rtc.wrapper.platform.flutter.RCRTCIWFlutterRenderEventsListener;
import cn.rongcloud.rtc.wrapper.platform.flutter.RCRTCIWFlutterView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.TextureRegistry;

/**
 * @author panmingda
 * @date 2021/6/11
 */
class RCRTCViewWrapper implements MethodCallHandler {

    // static RCRTCViewWrapper getInstance() {
    //     return RCRTCViewWrapper.SingletonHolder.instance;
    // }

    public RCRTCViewWrapper() {
    }

    void init(TextureRegistry registry, BinaryMessenger messenger) {
        this.registry = registry;
        this.messenger = messenger;
        channel = new MethodChannel(messenger, "cn.rongcloud.rtc.flutter/view");
        channel.setMethodCallHandler(this);
    }

    void unInit() {
        for(int i = 0, size = views.size(); i < size; i++) {
            RCRTCView view = views.valueAt(i);
            view.destroy();
        }
        views.clear();
        channel.setMethodCallHandler(null);
    }

    // Activity 回到前台时重新创建 EGL Surface，避免纹理失效导致卡帧
    void onActivityResumed() {
        for(int i = 0, size = views.size(); i < size; i++) {
            RCRTCView view = views.valueAt(i);
            if (view != null) {
                view.recreateSurfaceIfNeeded();
            }
        }
    }

    public RCRTCView getView(long id) {
        return views.get(id);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "create":
                create(result);
                break;
            case "destroy":
                destroy(call, result);
                break;
        }
    }

    private void create(@NonNull Result result) {
        RCRTCView view = null;
        try {
            view = new RCRTCView(registry, messenger);
        } catch (IllegalAccessException | InvocationTargetException | InstantiationException e) {
            e.printStackTrace();
        }
        if (view != null) {
            views.put(view.id, view);
            MainThreadPoster.success(result, view.id);
        } else {
            MainThreadPoster.success(result, -1);
        }
    }

    private void destroy(@NonNull MethodCall call, @NonNull Result result) {
        Integer id = (Integer) call.arguments;
        assert (id != null);
        RCRTCView view = views.get(id.longValue());
        if (view != null) {
            view.destroy();
        }
        MainThreadPoster.success(result);
    }

    private static class SingletonHolder {
        private static final RCRTCViewWrapper instance = new RCRTCViewWrapper();
    }

    static class RCRTCView extends RCRTCIWFlutterRenderEventsListener implements EventChannel.StreamHandler {

        private RCRTCView(TextureRegistry registry, BinaryMessenger messenger) throws IllegalAccessException, InvocationTargetException, InstantiationException {
            entry = registry.createSurfaceTexture();
            id = entry.id();
            channel = new EventChannel(messenger, "cn.rongcloud.rtc.flutter/view:" + id);
            channel.setStreamHandler(this);
            view = new RCRTCIWFlutterView("RCRTCView[" + id + "]");
            view.setRendererEventsListener(this);
            view.createSurface(entry.surfaceTexture());
        }

        @Override
        public void onListen(Object arguments, EventChannel.EventSink events) {
            sink = new MainThreadSink(events);
        }

        @Override
        public void onCancel(Object arguments) {
            sink = null;
        }

        @Override
        public void onFirstFrame() {
            if (sink != null) {
                HashMap<String, Object> arguments = new HashMap<>();
                arguments.put("event", "onFirstFrame");
                sink.success(arguments);
            }
        }

        @Override
        public void onFrameSizeChanged(int width, int height) {
            if (sink != null) {
                HashMap<String, Object> arguments = new HashMap<>();
                arguments.put("event", "onSizeChanged");
                arguments.put("width", width);
                arguments.put("height", height);
                sink.success(arguments);
            }
        }

        private void destroy() {
            view.destroySurface();
            view.release();
            channel.setStreamHandler(null);
            entry.release();
        }

        private void recreateSurfaceIfNeeded() {
            // Flutter Texture 在进后台一段时间后可能被回收，确保 Surface/EGL 恢复可用
            view.destroySurface();
            view.createSurface(entry.surfaceTexture());
        }

        private final TextureRegistry.SurfaceTextureEntry entry;
        private final long id;
        private final EventChannel channel;
        final RCRTCIWFlutterView view;

        private EventChannel.EventSink sink;
    }

    private TextureRegistry registry;
    private BinaryMessenger messenger;
    private MethodChannel channel;

    private final LongSparseArray<RCRTCView> views = new LongSparseArray<>();

}
