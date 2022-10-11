/// @author Pan ming da
/// @time 2021/6/8 15:56
/// @version 1.0

import 'rongcloud_rtc_stats.dart';

abstract class RCRTCStatsListener {
  void onNetworkStats(RCRTCNetworkStats stats) {}

  void onLocalAudioStats(RCRTCLocalAudioStats stats) {}

  void onLocalVideoStats(RCRTCLocalVideoStats stats) {}

  void onRemoteAudioStats(String roomId, String userId, RCRTCRemoteAudioStats stats) {}

  void onRemoteVideoStats(String roomId, String userId, RCRTCRemoteVideoStats stats) {}

  void onLiveMixAudioStats(RCRTCRemoteAudioStats stats) {}

  void onLiveMixVideoStats(RCRTCRemoteVideoStats stats) {}

  void onLiveMixMemberAudioStats(String userId, int volume) {}

  void onLiveMixMemberCustomAudioStats(String userId, String tag, int volume) {}

  void onLocalCustomAudioStats(String tag, RCRTCLocalAudioStats stats) {}

  void onLocalCustomVideoStats(String tag, RCRTCLocalVideoStats stats) {}

  void onRemoteCustomAudioStats(String roomId, String userId, String tag, RCRTCRemoteAudioStats stats) {}

  void onRemoteCustomVideoStats(String roomId, String userId, String tag, RCRTCRemoteVideoStats stats) {}
}

abstract class RCRTCNetworkProbeListener {
  void onNetworkProbeUpLinkStats(RCRTCNetworkProbeStats stats) {}
  void onNetworkProbeDownLinkStats(RCRTCNetworkProbeStats stats) {}
  void onNetworkProbeFinished(int code, String? errMsg) {}
}
