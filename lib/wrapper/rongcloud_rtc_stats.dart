/// @author Pan ming da
/// @time 2021/6/8 15:56
/// @version 1.0

import 'rongcloud_rtc_constants.dart';

class RCRTCNetworkStats {
  RCRTCNetworkStats.fromJson(Map<dynamic, dynamic> json)
      : type = RCRTCNetworkType.values[json['type']],
        ip = json['ip'],
        sendBitrate = json['sendBitrate'],
        receiveBitrate = json['receiveBitrate'],
        rtt = json['rtt'];

  final RCRTCNetworkType type;
  final String ip;
  final int sendBitrate;
  final int receiveBitrate;
  final int rtt;
}

class RCRTCLocalAudioStats {
  RCRTCLocalAudioStats.fromJson(Map<dynamic, dynamic> json)
      : codec = RCRTCAudioCodecType.values[json['codec']],
        bitrate = json['bitrate'],
        volume = json['volume'],
        packageLostRate = json['packageLostRate'],
        rtt = json['rtt'];

  final RCRTCAudioCodecType codec;
  final int bitrate;
  final int volume;
  final double packageLostRate;
  final int rtt;
}

class RCRTCLocalVideoStats {
  RCRTCLocalVideoStats.fromJson(Map<dynamic, dynamic> json)
      : tiny = json['tiny'],
        codec = RCRTCVideoCodecType.values[json['codec']],
        bitrate = json['bitrate'],
        fps = json['fps'],
        width = json['width'],
        height = json['height'],
        packageLostRate = json['packageLostRate'],
        rtt = json['rtt'];

  final bool tiny;
  final RCRTCVideoCodecType codec;
  final int bitrate;
  final int fps;
  final int width;
  final int height;
  final double packageLostRate;
  final int rtt;
}

class RCRTCRemoteAudioStats {
  RCRTCRemoteAudioStats.fromJson(Map<dynamic, dynamic> json)
      : userId = json['id'],
        codec = RCRTCAudioCodecType.values[json['codec']],
        bitrate = json['bitrate'],
        volume = json['volume'],
        packageLostRate = json['packageLostRate'],
        rtt = json['rtt'];

  final String userId;
  final RCRTCAudioCodecType codec;
  final int bitrate;
  final int volume;
  final double packageLostRate;
  final int rtt;
}

class RCRTCRemoteVideoStats {
  RCRTCRemoteVideoStats.fromJson(Map<dynamic, dynamic> json)
      : userId = json['id'],
        codec = RCRTCVideoCodecType.values[json['codec']],
        bitrate = json['bitrate'],
        fps = json['fps'],
        width = json['width'],
        height = json['height'],
        packageLostRate = json['packageLostRate'],
        rtt = json['rtt'];

  final String userId;
  final RCRTCVideoCodecType codec;
  final int bitrate;
  final int fps;
  final int width;
  final int height;
  final double packageLostRate;
  final int rtt;
}
