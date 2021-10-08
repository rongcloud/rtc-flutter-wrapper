/// @author Pan ming da
/// @time 2021/6/8 15:56
/// @version 1.0

import 'rongcloud_rtc_stats.dart';

abstract class RCRTCStatsListener {
  void onNetworkStats(RCRTCNetworkStats stats) {}

  void onLocalAudioStats(RCRTCLocalAudioStats stats) {}

  void onLocalVideoStats(RCRTCLocalVideoStats stats) {}

  void onRemoteAudioStats(String userId, RCRTCRemoteAudioStats stats) {}

  void onRemoteVideoStats(String userId, RCRTCRemoteVideoStats stats) {}

  void onLiveMixAudioStats(RCRTCRemoteAudioStats stats) {}

  void onLiveMixVideoStats(RCRTCRemoteVideoStats stats) {}

  void onLocalCustomAudioStats(String tag, RCRTCLocalAudioStats stats) {}

  void onLocalCustomVideoStats(String tag, RCRTCLocalVideoStats stats) {}

  void onRemoteCustomAudioStats(String userId, String tag, RCRTCRemoteAudioStats stats) {}

  void onRemoteCustomVideoStats(String userId, String tag, RCRTCRemoteVideoStats stats) {}
}
