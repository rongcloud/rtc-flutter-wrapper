package cn.rongcloud.rongcloud_rtc_wrapper_plugin_example.beauty;

import cn.rongcloud.rtc.wrapper.constants.RCRTCIWVideoFrame;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnVideoFrameListener;

public class VideoOutputFrameListener implements RCRTCIWOnVideoFrameListener {

    public VideoOutputFrameListener() {
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
