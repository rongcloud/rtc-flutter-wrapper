package cn.rongcloud.rtc.wrapper.flutter.example.yuv;

import android.content.Context;
import android.widget.Toast;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;

import cn.rongcloud.rtc.wrapper.flutter.example.utils.UIThreadHandler;
import cn.rongcloud.rtc.wrapper.listener.RCRTCIWOnReadableVideoFrameListener;
import cn.rongcloud.rtc.wrapper.module.RCRTCIWVideoFrame;

/**
 * @author panmingda
 * @date 2021/8/31
 */
public class RemoteYuvVideoFrameListener implements RCRTCIWOnReadableVideoFrameListener {

    public RemoteYuvVideoFrameListener(Context context, String roomId, String hostId, String userId, String tag) {
        this.userId = userId;
        this.tag = tag;
        try {
            String path = "RongCloud/" + roomId + "@" + System.currentTimeMillis() + "/" + hostId + "/" + userId;
            File dir = new File(context.getExternalFilesDir(null), path);
            if (!dir.exists()) dir.mkdirs();
            File yuv = new File(dir, "recv.yuv");
            yuvOutputStream = new FileOutputStream(yuv);
            File yuvTag = new File(dir, "recvTag.yuv");
            yuvTagOutputStream = new FileOutputStream(yuvTag);
            File time = new File(dir, "recvTime.txt");
            timeWriter = new FileWriter(time);
            File fps = new File(dir, "fps.txt");
            fpsWriter = new FileWriter(fps);
            File bitrate = new File(dir, "bitrate.txt");
            bitrateWriter = new FileWriter(bitrate);
        } catch (IOException e) {
            UIThreadHandler.post(() -> Toast.makeText(context, "Can't write to local!", Toast.LENGTH_LONG).show());
            e.printStackTrace();
        }
    }

    @Override
    public void onVideoFrame(RCRTCIWVideoFrame frame) {
        try {
            float zoomWidth = frame.getWidth() / 1280.0f;
            if (zoomWidth > 1) {
                zoomWidth = 1.0f;
            }
            float zoomHeight = frame.getHeight() / 720.0f;
            if (zoomHeight > 1) {
                zoomHeight = 1.0f;
            }
            int tagWidth = Math.round(240 * zoomWidth);
            int tagHeight = Math.round(60 * zoomHeight);
            int tagYLength = tagWidth * tagHeight;
            int tagULength = tagYLength >> 2;
            int tagVLength = tagULength;
            byte[] tagData = new byte[tagYLength + tagULength + tagVLength];

            if (frame.getType() == RCRTCIWVideoFrame.Type.BUFFER_I420) {
                final byte[] y = frame.getY();
                final byte[] u = frame.getU();
                final byte[] v = frame.getV();
                yuvOutputStream.write(y);
                yuvOutputStream.write(u);
                yuvOutputStream.write(v);
                for (int i = 0; i < tagHeight; i++) {
                    System.arraycopy(y, frame.getYStride() * i, tagData, tagWidth * i, tagWidth);
                    int stride = tagWidth >> 1;
                    int height = tagHeight >> 1;
                    if (i < height) {
                        System.arraycopy(u, frame.getUStride() * i, tagData, tagYLength + stride * i, stride);
                        System.arraycopy(v, frame.getVStride() * i, tagData, tagYLength + tagULength + stride * i, stride);
                    }
                }
            } else if (frame.getType() == RCRTCIWVideoFrame.Type.BUFFER_NV12 ||
                    frame.getType() == RCRTCIWVideoFrame.Type.BUFFER_NV21) {
                final byte[] data = frame.getData();
                yuvOutputStream.write(data);
                int frameWidth = frame.getWidth();
                int yLength = frameWidth * frame.getHeight();
                for (int i = 0; i < tagHeight - 1; i++) {
                    System.arraycopy(data, frameWidth * i, tagData, tagWidth * i, tagWidth);
                    int stride = tagWidth >> 1;
                    System.arraycopy(data, yLength + frameWidth * i, tagData, tagYLength + stride * i, stride);
                }
            }
            yuvTagOutputStream.write(tagData);
            timeWriter.append(",");
            timeWriter.append(String.valueOf(System.currentTimeMillis()));
            timeWriter.append(",");
            timeWriter.append(String.valueOf(frame.getWidth()));
            timeWriter.append(",");
            timeWriter.append(String.valueOf(frame.getHeight()));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void writeFps(String fps) {
        try {
            fpsWriter.append(",");
            fpsWriter.append(fps);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void writeBitrate(String bitrate) {
        try {
            bitrateWriter.append(",");
            bitrateWriter.append(bitrate);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String getUserId() {
        return userId;
    }

    public String getTag() {
        return tag;
    }

    public void destroy() {
        if (yuvOutputStream != null) {
            try {
                yuvOutputStream.flush();
                yuvOutputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            yuvOutputStream = null;
        }
        if (yuvTagOutputStream != null) {
            try {
                yuvTagOutputStream.flush();
                yuvTagOutputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            yuvTagOutputStream = null;
        }
        if (timeWriter != null) {
            try {
                timeWriter.flush();
                timeWriter.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            timeWriter = null;
        }
        if (fpsWriter != null) {
            try {
                fpsWriter.flush();
                fpsWriter.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            fpsWriter = null;
        }
        if (bitrateWriter != null) {
            try {
                bitrateWriter.flush();
                bitrateWriter.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            bitrateWriter = null;
        }
    }

    private final String userId;
    private final String tag;
    private FileOutputStream yuvOutputStream;
    private FileOutputStream yuvTagOutputStream;
    private FileWriter timeWriter;
    private FileWriter fpsWriter;
    private FileWriter bitrateWriter;
}
