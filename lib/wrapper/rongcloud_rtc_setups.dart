/// @author Pan ming da
/// @time 2021/6/8 15:56
/// @version 1.0

import 'rongcloud_rtc_constants.dart';

class RCRTCEngineSetup {
  RCRTCEngineSetup.create({
    this.reconnectable = true,
    this.statsReportInterval = 1000,
    this.mediaUrl,
    this.audioSetup,
    this.videoSetup,
  });

  Map<String, dynamic> toJson() => {
        'reconnectable': reconnectable,
        'statsReportInterval': statsReportInterval,
        'mediaUrl': mediaUrl,
        'audioSetup': audioSetup?.toJson(),
        'videoSetup': videoSetup?.toJson(),
      };

  final bool reconnectable;
  final int statsReportInterval;
  final String? mediaUrl;

  final RCRTCAudioSetup? audioSetup;
  final RCRTCVideoSetup? videoSetup;
}

class RCRTCAudioSetup {
  RCRTCAudioSetup.create({
    this.codec = RCRTCAudioCodecType.opus,
    this.audioSource = RCRTCAudioSource.voice_communication,
    this.audioSampleRate = 16000,
    this.enableMicrophone = true,
    this.enableStereo = true,
  });

  Map<String, dynamic> toJson() => {
        'codec': codec.index,
        'audioSource': audioSource.index,
        'audioSampleRate': audioSampleRate,
        'enableMicrophone': enableMicrophone,
        'enableStereo': enableStereo,
      };

  final RCRTCAudioCodecType codec;

  /// 以下参数仅在android平台生效
  final RCRTCAudioSource audioSource;
  final int audioSampleRate;
  final bool enableMicrophone;
  final bool enableStereo;
}

class RCRTCVideoSetup {
  RCRTCVideoSetup.create({
    this.enableTinyStream = true,
    this.enableHardwareDecoder = true,
    this.enableHardwareEncoder = true,
    this.enableHardwareEncoderHighProfile = false,
    this.hardwareEncoderFrameRate = 30,
    this.enableTexture = true,
  });

  Map<String, dynamic> toJson() => {
        'enableHardwareDecoder': enableHardwareDecoder,
        'enableHardwareEncoder': enableHardwareEncoder,
        'enableHardwareEncoderHighProfile': enableHardwareEncoderHighProfile,
        'hardwareEncoderFrameRate': hardwareEncoderFrameRate,
        'enableEncoderTexture': enableTexture,
        'enableTinyStream': enableTinyStream,
      };

  final bool enableTinyStream;

  /// 以下参数仅在android平台生效
  final bool enableHardwareDecoder;
  final bool enableHardwareEncoder;
  final bool enableHardwareEncoderHighProfile;
  final int hardwareEncoderFrameRate;
  final bool enableTexture;
}

class RCRTCRoomSetup {
  RCRTCRoomSetup.create({
    required this.type,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'role': role.index,
      };

  final RCRTCMediaType type;
  final RCRTCRole role;
}
