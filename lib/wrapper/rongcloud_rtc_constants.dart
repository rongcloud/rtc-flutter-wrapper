/// @author Pan ming da
/// @time 2021/6/8 16:00
/// @version 1.0

enum RCRTCMediaType {
  audio,
  video,
  audio_video,
}

enum RCRTCRole {
  meeting_member,
  live_broadcaster,
  live_audience,
}

enum RCRTCAudioCodecType {
  pcmu,
  opus,
}

/// 同Android MediaRecorder.AudioSource
enum RCRTCAudioSource {
  normal,
  mic,
  voice_up_link,
  voice_down_link,
  voice_call,
  camcorder,
  voice_recognition,
  voice_communication,
  remote_sub_mix,
  unprocessed,
}

enum RCRTCVideoCodecType {
  h264,
}

enum RCRTCAudioQuality {
  speech,
  music,
  music_high,
}

enum RCRTCAudioScenario {
  normal,
  music_chatroom,
  music_classroom,
}

enum RCRTCVideoFps {
  fps_10,
  fps_15,
  fps_24,
  fps_30,
}

enum RCRTCVideoResolution {
  resolution_144_176,
  resolution_144_256,
  resolution_180_180,
  resolution_180_240,
  resolution_180_320,
  resolution_240_240,
  resolution_240_320,
  resolution_360_360,
  resolution_360_480,
  resolution_360_640,
  resolution_480_480,
  resolution_480_640,
  resolution_480_848,
  resolution_480_720,
  resolution_720_960,
  resolution_720_1280,
  resolution_1080_1920,
}

enum RCRTCCamera {
  none,
  front,
  back,
}

enum RCRTCCameraCaptureOrientation {
  portrait,
  portrait_upside_down,
  landscape_right,
  landscape_left,
}

enum RCRTCViewFitType {
  fill,
  cover,
  center,
}

enum RCRTCLiveMixLayoutMode {
  custom,
  suspension,
  adaptive,
}

enum RCRTCLiveMixRenderMode {
  crop,
  whole,
}

enum RCRTCNetworkType {
  unknown,
  wifi,
  mobile,
}

enum RCRTCAudioMixingMode {
  none,
  mix,
  replace,
}
