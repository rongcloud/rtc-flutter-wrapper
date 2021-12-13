/// @author Pan ming da
/// @time 2021/6/8 15:55
/// @version 1.0
import 'rongcloud_rtc_constants.dart';

class RCRTCAudioConfig {
  RCRTCAudioConfig.create({
    this.quality = RCRTCAudioQuality.speech,
    this.scenario = RCRTCAudioScenario.normal,
    this.recordingVolume = 100,
  });

  Map<String, dynamic> toJson() => {
        'quality': quality.index,
        'scenario': scenario.index,
        'recordingVolume': recordingVolume,
      };

  RCRTCAudioQuality quality;
  RCRTCAudioScenario scenario;
  int recordingVolume;
}

class RCRTCVideoConfig {
  RCRTCVideoConfig.create({
    this.minBitrate = 500,
    this.maxBitrate = 2200,
    this.fps = RCRTCVideoFps.fps_24,
    this.resolution = RCRTCVideoResolution.resolution_720_1280,
    this.mirror = false,
  });

  Map<String, dynamic> toJson() => {
        'minBitrate': minBitrate,
        'maxBitrate': maxBitrate,
        'fps': fps.index,
        'resolution': resolution.index,
        'mirror': mirror,
      };

  int minBitrate;
  int maxBitrate;
  RCRTCVideoFps fps;
  RCRTCVideoResolution resolution;
  bool mirror;
}
