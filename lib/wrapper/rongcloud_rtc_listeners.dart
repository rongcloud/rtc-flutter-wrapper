/// @author Pan ming da
/// @time 2021/6/8 15:56
/// @version 1.0

import 'rongcloud_rtc_stats.dart';

abstract class RCRTCStatsListener {
  void onNetworkStats(RCRTCNetworkStats stats) {}

  void onLocalAudioStats(RCRTCLocalAudioStats stats) {}

  void onLocalVideoStats(RCRTCLocalVideoStats stats) {}

  void onRemoteAudioStats(RCRTCRemoteAudioStats stats) {}

  void onRemoteVideoStats(RCRTCRemoteVideoStats stats) {}
}
