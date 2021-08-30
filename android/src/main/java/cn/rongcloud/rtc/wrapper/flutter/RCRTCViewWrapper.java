package cn.rongcloud.rtc.wrapper.flutter;

import android.util.LongSparseArray;

import androidx.annotation.NonNull;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import cn.rongcloud.rtc.api.stream.RCRTCTextureView;
import cn.rongcloud.rtc.core.RendererCommon;
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

    static RCRTCViewWrapper getInstance() {
        return RCRTCViewWrapper.SingletonHolder.instance;
    }

    private RCRTCViewWrapper() {
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

    RCRTCView getView(long id) {
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

    static class RCRTCView implements EventChannel.StreamHandler, RendererCommon.RendererEvents {

        private RCRTCView(TextureRegistry registry, BinaryMessenger messenger) throws IllegalAccessException, InvocationTargetException, InstantiationException {
            entry = registry.createSurfaceTexture();
            id = entry.id();
            channel = new EventChannel(messenger, "cn.rongcloud.rtc.flutter/view:" + id);
            channel.setStreamHandler(this);
            view = VIEW_CONSTRUCTOR.newInstance("RCRTCView[" + id + "]");
            RCRTCTextureView view = (RCRTCTextureView) this.view;
            view.init(RCRTCEngineWrapper.getInstance().getEglBaseContext(), this);
            view.surfaceCreated(entry.surfaceTexture());
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
        public void onFirstFrameRendered() {
            if (sink != null) {
                HashMap<String, Object> arguments = new HashMap<>();
                arguments.put("event", "onFirstFrame");
                sink.success(arguments);
            }
        }

        @Override
        public void onFrameResolutionChanged(int width, int height, int rotation) {
            if (sink != null) {
                if (width != this.width || height != this.height) {
                    HashMap<String, Object> arguments = new HashMap<>();
                    arguments.put("event", "onSizeChanged");
                    arguments.put("width", width);
                    arguments.put("height", height);
                    arguments.put("rotation", rotation);
                    this.width = width;
                    this.height = height;
                    this.rotation = rotation;
                    sink.success(arguments);
                }
                if (rotation != this.rotation) {
                    HashMap<String, Object> arguments = new HashMap<>();
                    arguments.put("event", "onRotationChanged");
                    arguments.put("rotation", rotation);
                    this.rotation = rotation;
                    sink.success(arguments);
                }
            }
        }

        @Override
        public void onCreateEglFailed(Exception e) {
        }

        private void destroy() {
            RCRTCTextureView view = (RCRTCTextureView) this.view;
            view.release();
            channel.setStreamHandler(null);
            entry.release();
        }

        private final TextureRegistry.SurfaceTextureEntry entry;
        private final long id;
        private final EventChannel channel;
        final Object view;

        private EventChannel.EventSink sink;

        private int rotation = -1;
        private int width = 0, height = 0;
    }

    private TextureRegistry registry;
    private BinaryMessenger messenger;
    private MethodChannel channel;

    private final LongSparseArray<RCRTCView> views = new LongSparseArray<>();

    private static Constructor<?> VIEW_CONSTRUCTOR;

    static {
        try {
            Class<?> clazz = Class.forName("cn.rongcloud.rtc.wrapper.platform.flutter.RCRTCIWFlutterView");
            VIEW_CONSTRUCTOR = clazz.getDeclaredConstructor(String.class);
            VIEW_CONSTRUCTOR.setAccessible(true);
        } catch (ClassNotFoundException | NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
}
