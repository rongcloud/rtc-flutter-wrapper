package cn.rongcloud.rtc.wrapper.flutter.example.audio;

import android.widget.Toast;

import cn.rongcloud.rtc.wrapper.constants.RCRTCIWAudioDeviceType;
import cn.rongcloud.rtc.wrapper.flutter.example.MainActivity;
import cn.rongcloud.rtc.wrapper.listener.IRCRTCIWAudioRouteingListener;

public class AudioRouteingListener implements IRCRTCIWAudioRouteingListener {

    @Override
    public void onAudioDeviceRouted(RCRTCIWAudioDeviceType rcrtciwAudioDeviceType) {

        String tipString = "";

        switch (rcrtciwAudioDeviceType) {
            case PHONE:
                tipString = "听筒";
                break;
            case SPEAKER:
                tipString = "扬声器";
                break;
            case WIRED_HEADSET:
                tipString = "有线耳机";
                break;
            case BLUETOOTH_HEADSET:
                tipString = "蓝牙耳机";
                break;
        }
        Toast.makeText(MainActivity.getMainContext(), "当前已切换为" + tipString, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onAudioDeviceRouteFailed(RCRTCIWAudioDeviceType rcrtciwAudioDeviceType, RCRTCIWAudioDeviceType rcrtciwAudioDeviceType1) {
        Toast.makeText(MainActivity.getMainContext(), "切换失败！当前状态：" + rcrtciwAudioDeviceType + "，失败状态：" + rcrtciwAudioDeviceType1, Toast.LENGTH_SHORT).show();
    }
}
