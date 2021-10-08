package cn.rongcloud.rtc.wrapper.flutter.example.yuv;

import android.content.Context;
import android.widget.Toast;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import cn.rongcloud.rtc.wrapper.flutter.example.utils.UIThreadHandler;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnWritableVideoFrameListener;
import cn.rongcloud.rtc.wrapper.module.RCRTCIWVideoFrame;

/**
 * @author panmingda
 * @date 2021/8/31
 */
public class LocalYuvVideoFrameListener implements RCRTCIWOnWritableVideoFrameListener {

    public LocalYuvVideoFrameListener(Context context, String roomId, String hostId, String userId, String tag) {
        this.tag = tag;
        frameCount = 0;
        try {
            String path = "/RongCloud/" + roomId + "@" + System.currentTimeMillis() + "/" + hostId + "/" + userId;
            File dir = new File(context.getExternalFilesDir(null), path);
            if (!dir.exists()) dir.mkdirs();
            File time = new File(dir, "/sendTime.txt");
            timeWriter = new FileWriter(time);
        } catch (IOException e) {
            UIThreadHandler.post(() -> Toast.makeText(context, "Can't write to local!", Toast.LENGTH_LONG).show());
            e.printStackTrace();
        }
    }

    @Override
    public RCRTCIWVideoFrame onVideoFrame(RCRTCIWVideoFrame frame) {
        try {
            frameCount++;
            timeWriter.append(",");
            timeWriter.append(String.valueOf(frameCount));
            timeWriter.append(",");
            timeWriter.append(String.valueOf(System.currentTimeMillis()));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return frame;
    }

    public String getTag() {
        return tag;
    }

    public void destroy() {
        if (timeWriter != null) {
            try {
                timeWriter.flush();
                timeWriter.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            timeWriter = null;
        }
    }

    private final String tag;
    private long frameCount;
    private FileWriter timeWriter;

}
