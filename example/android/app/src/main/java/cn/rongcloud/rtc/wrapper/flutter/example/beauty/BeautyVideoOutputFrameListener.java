package cn.rongcloud.rtc.wrapper.flutter.example.beauty;

import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnWritableVideoFrameListener;
import cn.rongcloud.rtc.wrapper.module.RCRTCIWVideoFrame;

public class BeautyVideoOutputFrameListener implements RCRTCIWOnWritableVideoFrameListener {

    public BeautyVideoOutputFrameListener() {
        filter = new GPUImageBeautyFilter();
    }

    @Override
    public RCRTCIWVideoFrame onVideoFrame(RCRTCIWVideoFrame frame) {
        frame.setTextureId(filter.draw(frame.getWidth(), frame.getHeight(), frame.getTextureId()));
        return frame;
    }

    public void destroy() {
        filter.destroy();
    }

    private final GPUImageFilter filter;
}
