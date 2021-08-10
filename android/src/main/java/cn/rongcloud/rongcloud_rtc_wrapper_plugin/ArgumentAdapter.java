package cn.rongcloud.rongcloud_rtc_wrapper_plugin;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import cn.rongcloud.rtc.wrapper.config.RCRTCIWAudioConfig;
import cn.rongcloud.rtc.wrapper.config.RCRTCIWCustomLayout;
import cn.rongcloud.rtc.wrapper.config.RCRTCIWVideoConfig;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWAudioCodecType;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWAudioMixingMode;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWAudioQuality;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWAudioScenario;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWCamera;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWCameraCaptureOrientation;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWLiveMixLayoutMode;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWLiveMixRenderMode;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWLocalAudioStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWLocalVideoStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWMediaType;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWNetworkStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWRemoteAudioStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWRemoteVideoStats;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWRole;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWVideoFps;
import cn.rongcloud.rtc.wrapper.constants.RCRTCIWVideoResolution;
import cn.rongcloud.rtc.wrapper.setup.RCRTCIWAudioSetup;
import cn.rongcloud.rtc.wrapper.setup.RCRTCIWEngineSetup;
import cn.rongcloud.rtc.wrapper.setup.RCRTCIWRoomSetup;
import cn.rongcloud.rtc.wrapper.setup.RCRTCIWVideoSetup;

/**
 * @author panmingda
 * @date 2021/6/9
 */
final class ArgumentAdapter {

    private ArgumentAdapter() {
    }

    static RCRTCIWMediaType toMediaType(@NonNull Integer type) {
        return RCRTCIWMediaType.values()[type];
    }

    static RCRTCIWCamera toCamera(@NonNull Integer camera) {
        return RCRTCIWCamera.values()[camera];
    }

    static RCRTCIWCameraCaptureOrientation toCameraCaptureOrientation(@NonNull Integer orientation) {
        return RCRTCIWCameraCaptureOrientation.values()[orientation];
    }

    static RCRTCIWLiveMixLayoutMode toLiveMixLayoutMode(@NonNull Integer mode) {
        return RCRTCIWLiveMixLayoutMode.values()[mode];
    }

    static RCRTCIWLiveMixRenderMode toLiveMixRenderMode(@NonNull Integer mode) {
        return RCRTCIWLiveMixRenderMode.values()[mode];
    }

    static RCRTCIWVideoResolution toVideoResolution(@NonNull Integer resolution) {
        return RCRTCIWVideoResolution.values()[resolution];
    }

    static RCRTCIWVideoFps toVideoFps(@NonNull Integer fps) {
        return RCRTCIWVideoFps.values()[fps];
    }

    static RCRTCIWAudioMixingMode toAudioMixingMode(@NonNull Integer mode) {
        return RCRTCIWAudioMixingMode.values()[mode];
    }

    static RCRTCIWAudioCodecType toAudioCodecType(@NonNull Integer type) {
        return RCRTCIWAudioCodecType.values()[type];
    }

    static RCRTCIWRole toRole(@NonNull Integer role) {
        return RCRTCIWRole.values()[role];
    }

    static RCRTCIWAudioQuality toAudioQuality(@NonNull Integer quality) {
        return RCRTCIWAudioQuality.values()[quality];
    }

    static RCRTCIWAudioScenario toAudioScenario(@NonNull Integer scenario) {
        return RCRTCIWAudioScenario.values()[scenario];
    }

    static RCRTCIWAudioSetup toAudioSetup(@NonNull HashMap<String, Object> setup) {
        Integer codec = (Integer) setup.get("codec");
        assert (codec != null);
        Integer audioSource = (Integer) setup.get("audioSource");
        assert (audioSource != null);
        Integer audioSampleRate = (Integer) setup.get("audioSampleRate");
        assert (audioSampleRate != null);
        Boolean enableMicrophone = (Boolean) setup.get("enableMicrophone");
        assert (enableMicrophone != null);
        Boolean enableStereo = (Boolean) setup.get("enableStereo");
        assert (enableStereo != null);
        return RCRTCIWAudioSetup.Builder.create()
                .withAudioCodecType(toAudioCodecType(codec))
                .withAudioSource(audioSource)
                .withAudioSampleRate(audioSampleRate)
                .withEnableMicrophone(enableMicrophone)
                .withEnableStereo(enableStereo)
                .build();
    }

    static RCRTCIWVideoSetup toVideoSetup(@NonNull HashMap<String, Object> setup) {
        Boolean enableHardwareDecoder = (Boolean) setup.get("enableHardwareDecoder");
        assert (enableHardwareDecoder != null);
        Boolean enableHardwareEncoder = (Boolean) setup.get("enableHardwareEncoder");
        assert (enableHardwareEncoder != null);
        Boolean enableHardwareEncoderHighProfile = (Boolean) setup.get("enableHardwareEncoderHighProfile");
        assert (enableHardwareEncoderHighProfile != null);
        Integer hardwareEncoderFrameRate = (Integer) setup.get("hardwareEncoderFrameRate");
        assert (hardwareEncoderFrameRate != null);
        Boolean enableEncoderTexture = (Boolean) setup.get("enableEncoderTexture");
        assert (enableEncoderTexture != null);
        Boolean enableTinyStream = (Boolean) setup.get("enableTinyStream");
        assert (enableTinyStream != null);
        return RCRTCIWVideoSetup.Builder.create()
                .withEnableHardwareDecoder(enableHardwareDecoder)
                .withEnableHardwareEncoder(enableHardwareEncoder)
                .withEnableHardwareEncoderHighProfile(enableHardwareEncoderHighProfile)
                .withHardwareEncoderFrameRate(hardwareEncoderFrameRate)
                .withEnableEncoderTexture(enableEncoderTexture)
                .withEnableTinyStream(enableTinyStream)
                .build();
    }

    static RCRTCIWEngineSetup toEngineSetup(@NonNull HashMap<String, Object> setup) {
        Boolean reconnectable = (Boolean) setup.get("reconnectable");
        assert (reconnectable != null);
        Integer statsReportInterval = (Integer) setup.get("statsReportInterval");
        assert (statsReportInterval != null);
        RCRTCIWEngineSetup.Builder builder = RCRTCIWEngineSetup.Builder.create()
                .withReconnectable(reconnectable)
                .withStatusReportInterval(statsReportInterval);
        Object mediaUrl = setup.get("mediaUrl");
        if (mediaUrl != null) {
            builder.withMediaUrl((String) mediaUrl);
        }
        Object audioSetup = setup.get("audioSetup");
        if (audioSetup != null) {
            builder.withAudioSetup(toAudioSetup((HashMap<String, Object>) audioSetup));
        }
        Object videoSetup = setup.get("videoSetup");
        if (videoSetup != null) {
            builder.withVideoSetup(toVideoSetup((HashMap<String, Object>) videoSetup));
        }
        return builder.build();
    }

    @SuppressWarnings("unchecked")
    static RCRTCIWRoomSetup toRoomSetup(@NonNull HashMap<String, Object> setup) {
        Integer type = (Integer) setup.get("type");
        assert (type != null);
        Integer role = (Integer) setup.get("role");
        assert (role != null);
        RCRTCIWRoomSetup.Builder builder = RCRTCIWRoomSetup.Builder.create()
                .withMediaType(toMediaType(type))
                .withRole(toRole(role));
        return builder.build();
    }

    static RCRTCIWAudioConfig toAudioConfig(@NonNull HashMap<String, Object> config) {
        Integer quality = (Integer) config.get("quality");
        assert (quality != null);
        Integer scenario = (Integer) config.get("scenario");
        assert (scenario != null);
        return RCRTCIWAudioConfig.create()
                .setQuality(toAudioQuality(quality))
                .setScenario(toAudioScenario(scenario));
    }

    static RCRTCIWVideoConfig toVideoConfig(@NonNull HashMap<String, Object> config) {
        Integer minBitrate = (Integer) config.get("minBitrate");
        assert (minBitrate != null);
        Integer maxBitrate = (Integer) config.get("maxBitrate");
        assert (maxBitrate != null);
        Integer fps = (Integer) config.get("fps");
        assert (fps != null);
        Integer resolution = (Integer) config.get("resolution");
        assert (resolution != null);
        Boolean mirror = (Boolean) config.get("mirror");
        assert (mirror != null);
        return RCRTCIWVideoConfig.create()
                .setMinBitrate(minBitrate)
                .setMaxBitrate(maxBitrate)
                .setFps(toVideoFps(fps))
                .setResolution(toVideoResolution(resolution))
                .setMirror(mirror);
    }

    static List<RCRTCIWCustomLayout> toLiveMixCustomLayouts(@NonNull List<HashMap<String, Object>> layouts) {
        List<RCRTCIWCustomLayout> lists = new ArrayList<>(layouts.size());
        for (HashMap<String, Object> layout : layouts) {
            lists.add(toLiveMixCustomLayout(layout));
        }
        return lists;
    }

    static RCRTCIWCustomLayout toLiveMixCustomLayout(@NonNull HashMap<String, Object> layout) {
        String id = (String) layout.get("id");
        assert (id != null);
        Integer x = (Integer) layout.get("x");
        assert (x != null);
        Integer y = (Integer) layout.get("y");
        assert (y != null);
        Integer width = (Integer) layout.get("width");
        assert (width != null);
        Integer height = (Integer) layout.get("height");
        assert (height != null);
        return new RCRTCIWCustomLayout(id, x, y, width, height);
    }

    static HashMap<String, Object> fromNetworkStats(@NonNull RCRTCIWNetworkStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("type", stats.getType().ordinal());
        map.put("ip", stats.getIp());
        map.put("sendBitrate", stats.getSendBitrate());
        map.put("receiveBitrate", stats.getReceiveBitrate());
        map.put("rtt", stats.getRtt());
        return map;
    }

    static HashMap<String, Object> fromLocalAudioStats(@NonNull RCRTCIWLocalAudioStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("codec", stats.getCodec().ordinal());
        map.put("bitrate", stats.getBitrate());
        map.put("volume", stats.getVolume());
        map.put("packageLostRate", stats.getPackageLostRate());
        map.put("rtt", stats.getRtt());
        return map;
    }

    static HashMap<String, Object> fromLocalVideoStats(@NonNull RCRTCIWLocalVideoStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("tiny", stats.isTiny());
        map.put("codec", stats.getCodec().ordinal());
        map.put("bitrate", stats.getBitrate());
        map.put("fps", stats.getFps());
        map.put("width", stats.getWidth());
        map.put("height", stats.getHeight());
        map.put("packageLostRate", stats.getPackageLostRate());
        map.put("rtt", stats.getRtt());
        return map;
    }

    static HashMap<String, Object> fromRemoteAudioStats(@NonNull RCRTCIWRemoteAudioStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("id", stats.getUserId());
        map.put("codec", stats.getCodec().ordinal());
        map.put("bitrate", stats.getBitrate());
        map.put("volume", stats.getVolume());
        map.put("packageLostRate", stats.getPackageLostRate());
        map.put("rtt", stats.getRtt());
        return map;
    }

    static HashMap<String, Object> fromRemoteVideoStats(@NonNull RCRTCIWRemoteVideoStats stats) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("id", stats.getUserId());
        map.put("codec", stats.getCodec().ordinal());
        map.put("bitrate", stats.getBitrate());
        map.put("fps", stats.getFps());
        map.put("width", stats.getWidth());
        map.put("height", stats.getHeight());
        map.put("packageLostRate", stats.getPackageLostRate());
        map.put("rtt", stats.getRtt());
        return map;
    }
}
