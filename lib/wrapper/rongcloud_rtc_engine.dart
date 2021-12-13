/// @author Pan ming da
/// @time 2021/6/8 15:51
/// @version 1.0
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'rongcloud_rtc_configs.dart';
import 'rongcloud_rtc_constants.dart';
import 'rongcloud_rtc_custom_layout.dart';
import 'rongcloud_rtc_listeners.dart';
import 'rongcloud_rtc_setups.dart';
import 'rongcloud_rtc_stats.dart';

part 'rongcloud_rtc_view.dart';

class RCRTCEngine {
  RCRTCEngine._() : _channel = MethodChannel('cn.rongcloud.rtc.flutter/engine') {
    _channel.setMethodCallHandler(_handler);
  }

  static Future<RCRTCEngine> create([RCRTCEngineSetup? setup]) {
    if (_instance == null) _instance = RCRTCEngine._();
    return _instance!._create(setup);
  }

  Future<RCRTCEngine> _create(RCRTCEngineSetup? setup) async {
    Map<String, dynamic> arguments = {
      'setup': setup?.toJson(),
    };
    await _channel.invokeMethod('create', arguments);
    return Future.value(this);
  }

  Future<int> destroy() async {
    int code = await _channel.invokeMethod('destroy') ?? -1;
    if (code != 0) return code;
    _instance = null;
    return code;
  }

  Future<int> joinRoom(String roomId, RCRTCRoomSetup setup) async {
    Map<String, dynamic> arguments = {
      'id': roomId,
      'setup': setup.toJson(),
    };
    int code = await _channel.invokeMethod('joinRoom', arguments) ?? -1;
    return code;
  }

  Future<int> leaveRoom() async {
    int code = await _channel.invokeMethod('leaveRoom') ?? -1;
    return code;
  }

  Future<int> publish(RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {
      'type': type.index,
    };
    int code = await _channel.invokeMethod('publish', arguments) ?? -1;
    return code;
  }

  Future<int> unpublish(RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {
      'type': type.index,
    };
    int code = await _channel.invokeMethod('unpublish', arguments) ?? -1;
    return code;
  }

  Future<int> subscribe(
    String userId,
    RCRTCMediaType type, [
    bool tiny = true,
  ]) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'type': type.index,
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('subscribe', arguments) ?? -1;
    return code;
  }

  Future<int> subscribes(
    List<String> userIds,
    RCRTCMediaType type, [
    bool tiny = true,
  ]) async {
    Map<String, dynamic> arguments = {
      'ids': userIds,
      'type': type.index,
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('subscribes', arguments) ?? -1;
    return code;
  }

  Future<int> subscribeLiveMix(
    RCRTCMediaType type, [
    bool tiny = true,
  ]) async {
    Map<String, dynamic> arguments = {
      'type': type.index,
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('subscribeLiveMix', arguments) ?? -1;
    return code;
  }

  Future<int> unsubscribe(
    String userId,
    RCRTCMediaType type,
  ) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'type': type.index,
    };
    int code = await _channel.invokeMethod('unsubscribe', arguments) ?? -1;
    return code;
  }

  Future<int> unsubscribes(
    List<String> userIds,
    RCRTCMediaType type,
  ) async {
    Map<String, dynamic> arguments = {
      'ids': userIds,
      'type': type.index,
    };
    int code = await _channel.invokeMethod('unsubscribes', arguments) ?? -1;
    return code;
  }

  Future<int> unsubscribeLiveMix(
    RCRTCMediaType type,
  ) async {
    Map<String, dynamic> arguments = {
      'type': type.index,
    };
    int code = await _channel.invokeMethod('unsubscribeLiveMix', arguments) ?? -1;
    return code;
  }

  Future<int> setAudioConfig(RCRTCAudioConfig config) async {
    Map<String, dynamic> arguments = {
      'config': config.toJson(),
    };
    int code = await _channel.invokeMethod('setAudioConfig', arguments) ?? -1;
    return code;
  }

  Future<int> setVideoConfig(
    RCRTCVideoConfig config, [
    bool tiny = false,
  ]) async {
    Map<String, dynamic> arguments = {
      'config': config.toJson(),
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('setVideoConfig', arguments) ?? -1;
    return code;
  }

  Future<int> enableMicrophone(bool enable) async {
    int code = await _channel.invokeMethod('enableMicrophone', enable) ?? -1;
    return code;
  }

  Future<int> enableSpeaker(bool enable) async {
    int code = await _channel.invokeMethod('enableSpeaker', enable) ?? -1;
    return code;
  }

  Future<int> adjustLocalVolume(int volume) async {
    int code = await _channel.invokeMethod('adjustLocalVolume', volume) ?? -1;
    return code;
  }

  Future<int> enableCamera(
    bool enable, [
    RCRTCCamera? camera,
  ]) async {
    Map<String, dynamic> arguments = {
      'enable': enable,
      'camera': camera?.index,
    };
    int code = await _channel.invokeMethod('enableCamera', arguments) ?? -1;
    return code;
  }

  Future<int> switchCamera() async {
    int code = await _channel.invokeMethod('switchCamera') ?? -1;
    return code;
  }

  Future<int> switchToCamera(RCRTCCamera camera) async {
    int code = await _channel.invokeMethod('switchToCamera', camera.index) ?? -1;
    return code;
  }

  Future<RCRTCCamera> whichCamera() async {
    int code = await _channel.invokeMethod('whichCamera') ?? -1;
    if (code != 0) return RCRTCCamera.none;
    return RCRTCCamera.values[code + 1];
  }

  Future<bool> isCameraFocusSupported() async {
    bool result = await _channel.invokeMethod('isCameraFocusSupported') ?? false;
    return result;
  }

  Future<bool> isCameraExposurePositionSupported() async {
    bool result = await _channel.invokeMethod('isCameraExposurePositionSupported') ?? false;
    return result;
  }

  Future<int> setCameraFocusPositionInPreview(double x, double y) async {
    Map<String, dynamic> arguments = {
      'x': x,
      'y': y,
    };
    int code = await _channel.invokeMethod('setCameraFocusPositionInPreview', arguments) ?? -1;
    return code;
  }

  Future<int> setCameraExposurePositionInPreview(double x, double y) async {
    Map<String, dynamic> arguments = {
      'x': x,
      'y': y,
    };
    int code = await _channel.invokeMethod('setCameraExposurePositionInPreview', arguments) ?? -1;
    return code;
  }

  Future<int> setCameraCaptureOrientation(RCRTCCameraCaptureOrientation orientation) async {
    Map<String, dynamic> arguments = {
      'orientation': orientation.index,
    };
    int code = await _channel.invokeMethod('setCameraCaptureOrientation', arguments) ?? -1;
    return code;
  }

  Future<int> setLocalView(RCRTCView view) async {
    Map<String, dynamic> arguments = {
      'view': view._id,
    };
    int code = await _channel.invokeMethod('setLocalView', arguments) ?? -1;
    return code;
  }

  Future<int> removeLocalView() async {
    int code = await _channel.invokeMethod('removeLocalView') ?? -1;
    return code;
  }

  Future<int> setRemoteView(String userId, RCRTCView view) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'view': view._id,
    };
    int code = await _channel.invokeMethod('setRemoteView', arguments) ?? -1;
    return code;
  }

  Future<int> removeRemoteView(String userId) async {
    int code = await _channel.invokeMethod('removeRemoteView', userId) ?? -1;
    return code;
  }

  Future<int> setLiveMixView(RCRTCView view) async {
    Map<String, dynamic> arguments = {
      'view': view._id,
    };
    int code = await _channel.invokeMethod('setLiveMixView', arguments) ?? -1;
    return code;
  }

  Future<int> removeLiveMixView() async {
    int code = await _channel.invokeMethod('removeLiveMixView') ?? -1;
    return code;
  }

  Future<int> muteLocalStream(RCRTCMediaType type, bool mute) async {
    Map<String, dynamic> arguments = {
      'type': type.index,
      'mute': mute,
    };
    int code = await _channel.invokeMethod('muteLocalStream', arguments) ?? -1;
    return code;
  }

  Future<int> muteRemoteStream(String userId, RCRTCMediaType type, bool mute) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'type': type.index,
      'mute': mute,
    };
    int code = await _channel.invokeMethod('muteRemoteStream', arguments) ?? -1;
    return code;
  }

  Future<int> muteLiveMixStream(RCRTCMediaType type, bool mute) async {
    Map<String, dynamic> arguments = {
      'type': type.index,
      'mute': mute,
    };
    int code = await _channel.invokeMethod('muteLiveMixStream', arguments) ?? -1;
    return code;
  }

  Future<int> addLiveCdn(String url) async {
    int code = await _channel.invokeMethod('addLiveCdn', url) ?? -1;
    return code;
  }

  Future<int> removeLiveCdn(String url) async {
    int code = await _channel.invokeMethod('removeLiveCdn', url) ?? -1;
    return code;
  }

  Future<int> setLiveMixLayoutMode(RCRTCLiveMixLayoutMode mode) async {
    int code = await _channel.invokeMethod('setLiveMixLayoutMode', mode.index) ?? -1;
    return code;
  }

  Future<int> setLiveMixRenderMode(RCRTCLiveMixRenderMode mode) async {
    int code = await _channel.invokeMethod('setLiveMixRenderMode', mode.index) ?? -1;
    return code;
  }

  Future<int> setLiveMixBackgroundColor(Color color) async {
    Map<String, dynamic> arguments = {
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
    };
    int code = await _channel.invokeMethod('setLiveMixBackgroundColor', arguments) ?? -1;
    return code;
  }

  Future<int> setLiveMixCustomLayouts(List<RCRTCCustomLayout> layouts) async {
    Map<String, dynamic> arguments = {
      'layouts': layouts.map((layout) => layout.toJson()).toList(),
    };
    int code = await _channel.invokeMethod('setLiveMixCustomLayouts', arguments) ?? -1;
    return code;
  }

  Future<int> setLiveMixCustomAudios(List<String> userIds) async {
    Map<String, dynamic> arguments = {
      'ids': userIds,
    };
    int code = await _channel.invokeMethod('setLiveMixCustomAudios', arguments) ?? -1;
    return code;
  }

  Future<int> setLiveMixAudioBitrate(int bitrate) async {
    int code = await _channel.invokeMethod('setLiveMixAudioBitrate', bitrate) ?? -1;
    return code;
  }

  Future<int> setLiveMixVideoBitrate(
    int bitrate, [
    bool tiny = false,
  ]) async {
    Map<String, dynamic> arguments = {
      'bitrate': bitrate,
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('setLiveMixVideoBitrate', arguments) ?? -1;
    return code;
  }

  Future<int> setLiveMixVideoResolution(
    int width,
    int height, [
    bool tiny = false,
  ]) async {
    Map<String, dynamic> arguments = {
      'width': width,
      'height': height,
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('setLiveMixVideoResolution', arguments) ?? -1;
    return code;
  }

  Future<int> setLiveMixVideoFps(
    RCRTCVideoFps fps, [
    bool tiny = false,
  ]) async {
    Map<String, dynamic> arguments = {
      'fps': fps.index,
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('setLiveMixVideoFps', arguments) ?? -1;
    return code;
  }

  Future<int> setStatsListener(RCRTCStatsListener? listener) async {
    bool remove = listener == null;
    int code = await _channel.invokeMethod('setStatsListener', remove) ?? -1;
    if (code == 0) {
      _statsListener = listener;
    }
    return code;
  }

  Future<int> createAudioEffectFromAssets(String path, int effectId) async {
    Map<String, dynamic> arguments = {
      'assets': path,
      'id': effectId,
    };
    int code = await _channel.invokeMethod('createAudioEffect', arguments) ?? -1;
    return code;
  }

  Future<int> createAudioEffect(String path, int effectId) async {
    Map<String, dynamic> arguments = {
      'path': path,
      'id': effectId,
    };
    int code = await _channel.invokeMethod('createAudioEffect', arguments) ?? -1;
    return code;
  }

  Future<int> releaseAudioEffect(int effectId) async {
    int code = await _channel.invokeMethod('releaseAudioEffect', effectId) ?? -1;
    return code;
  }

  Future<int> playAudioEffect(
    int effectId,
    int volume, [
    int loop = 1,
  ]) async {
    Map<String, dynamic> arguments = {
      'id': effectId,
      'volume': volume,
      'loop': loop,
    };
    int code = await _channel.invokeMethod('playAudioEffect', arguments) ?? -1;
    return code;
  }

  Future<int> pauseAudioEffect(int effectId) async {
    int code = await _channel.invokeMethod('pauseAudioEffect', effectId) ?? -1;
    return code;
  }

  Future<int> pauseAllAudioEffects() async {
    int code = await _channel.invokeMethod('pauseAllAudioEffects') ?? -1;
    return code;
  }

  Future<int> resumeAudioEffect(int effectId) async {
    int code = await _channel.invokeMethod('resumeAudioEffect', effectId) ?? -1;
    return code;
  }

  Future<int> resumeAllAudioEffects() async {
    int code = await _channel.invokeMethod('resumeAllAudioEffects') ?? -1;
    return code;
  }

  Future<int> stopAudioEffect(int effectId) async {
    int code = await _channel.invokeMethod('stopAudioEffect', effectId) ?? -1;
    return code;
  }

  Future<int> stopAllAudioEffects() async {
    int code = await _channel.invokeMethod('stopAllAudioEffects') ?? -1;
    return code;
  }

  Future<int> adjustAudioEffectVolume(int effectId, int volume) async {
    Map<String, dynamic> arguments = {
      'id': effectId,
      'volume': volume,
    };
    int code = await _channel.invokeMethod('adjustAudioEffectVolume', arguments) ?? -1;
    return code;
  }

  Future<int> getAudioEffectVolume(int effectId) async {
    int code = await _channel.invokeMethod('getAudioEffectVolume', effectId) ?? -1;
    return code;
  }

  Future<int> adjustAllAudioEffectsVolume(int volume) async {
    int code = await _channel.invokeMethod('adjustAllAudioEffectsVolume', volume) ?? -1;
    return code;
  }

  Future<int> startAudioMixingFromAssets({
    required String path,
    required RCRTCAudioMixingMode mode,
    bool playback = true,
    int loop = 1,
  }) async {
    Map<String, dynamic> arguments = {
      'assets': path,
      'mode': mode.index,
      'playback': playback,
      'loop': loop,
    };
    int code = await _channel.invokeMethod('startAudioMixing', arguments) ?? -1;
    return code;
  }

  Future<int> startAudioMixing({
    required String path,
    required RCRTCAudioMixingMode mode,
    bool playback = true,
    int loop = 1,
  }) async {
    Map<String, dynamic> arguments = {
      'path': path,
      'mode': mode.index,
      'playback': playback,
      'loop': loop,
    };
    int code = await _channel.invokeMethod('startAudioMixing', arguments) ?? -1;
    return code;
  }

  Future<int> stopAudioMixing() async {
    int code = await _channel.invokeMethod('stopAudioMixing') ?? -1;
    return code;
  }

  Future<int> pauseAudioMixing() async {
    int code = await _channel.invokeMethod('pauseAudioMixing') ?? -1;
    return code;
  }

  Future<int> resumeAudioMixing() async {
    int code = await _channel.invokeMethod('resumeAudioMixing') ?? -1;
    return code;
  }

  Future<int> adjustAudioMixingVolume(int volume) async {
    int code = await _channel.invokeMethod('adjustAudioMixingVolume', volume) ?? -1;
    return code;
  }

  Future<int> adjustAudioMixingPlaybackVolume(int volume) async {
    int code = await _channel.invokeMethod('adjustAudioMixingVolume', volume) ?? -1;
    return code;
  }

  Future<int> getAudioMixingPlaybackVolume() async {
    int code = await _channel.invokeMethod('getAudioMixingPlaybackVolume') ?? -1;
    return code;
  }

  Future<int> adjustAudioMixingPublishVolume(int volume) async {
    int code = await _channel.invokeMethod('adjustAudioMixingPublishVolume', volume) ?? -1;
    return code;
  }

  Future<int> getAudioMixingPublishVolume() async {
    int code = await _channel.invokeMethod('getAudioMixingPublishVolume') ?? -1;
    return code;
  }

  Future<int> setAudioMixingPosition(double position) async {
    int code = await _channel.invokeMethod('setAudioMixingPosition', position) ?? -1;
    return code;
  }

  Future<double> getAudioMixingPosition() async {
    double code = await _channel.invokeMethod('getAudioMixingPosition') ?? -1;
    return code;
  }

  Future<int> getAudioMixingDuration() async {
    int code = await _channel.invokeMethod('getAudioMixingDuration') ?? -1;
    return code;
  }

  Future<String?> getSessionId() async {
    String? id = await _channel.invokeMethod('getSessionId');
    return id;
  }

  Future<int> createCustomStreamFromAssetsFile({
    required String path,
    required String tag,
    bool replace = false,
    bool playback = true,
  }) async {
    Map<String, dynamic> arguments = {
      'assets': path,
      'tag': tag,
      'replace': replace,
      'playback': playback,
    };
    int code = await _channel.invokeMethod('createCustomStreamFromFile', arguments) ?? -1;
    return code;
  }

  Future<int> createCustomStreamFromFile({
    required String path,
    required String tag,
    bool replace = false,
    bool playback = true,
  }) async {
    Map<String, dynamic> arguments = {
      'path': path,
      'tag': tag,
      'replace': replace,
      'playback': playback,
    };
    int code = await _channel.invokeMethod('createCustomStreamFromFile', arguments) ?? -1;
    return code;
  }

  Future<int> setCustomStreamVideoConfig(String tag, RCRTCVideoConfig config) async {
    Map<String, dynamic> arguments = {
      'tag': tag,
      'config': config.toJson(),
    };
    int code = await _channel.invokeMethod('setCustomStreamVideoConfig', arguments) ?? -1;
    return code;
  }

  Future<int> muteLocalCustomStream(String tag, bool mute) async {
    Map<String, dynamic> arguments = {
      'tag': tag,
      'mute': mute,
    };
    int code = await _channel.invokeMethod('muteLocalCustomStream', arguments) ?? -1;
    return code;
  }

  Future<int> setLocalCustomStreamView(String tag, RCRTCView view) async {
    Map<String, dynamic> arguments = {
      'tag': tag,
      'view': view._id,
    };
    int code = await _channel.invokeMethod('setLocalCustomStreamView', arguments) ?? -1;
    return code;
  }

  Future<int> removeLocalCustomStreamView(String tag) async {
    int code = await _channel.invokeMethod('removeLocalCustomStreamView', tag) ?? -1;
    return code;
  }

  Future<int> publishCustomStream(String tag) async {
    int code = await _channel.invokeMethod('publishCustomStream', tag) ?? -1;
    return code;
  }

  Future<int> unpublishCustomStream(String tag) async {
    int code = await _channel.invokeMethod('unpublishCustomStream', tag) ?? -1;
    return code;
  }

  Future<int> muteRemoteCustomStream(String userId, String tag, RCRTCMediaType type, bool mute) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'type': type.index,
      'mute': mute,
    };
    int code = await _channel.invokeMethod('muteRemoteCustomStream', arguments) ?? -1;
    return code;
  }

  Future<int> setRemoteCustomStreamView(String userId, String tag, RCRTCView view) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'view': view._id,
    };
    int code = await _channel.invokeMethod('setRemoteCustomStreamView', arguments) ?? -1;
    return code;
  }

  Future<int> removeRemoteCustomStreamView(String userId, String tag) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
    };
    int code = await _channel.invokeMethod('removeRemoteCustomStreamView', arguments) ?? -1;
    return code;
  }

  Future<int> subscribeCustomStream(String userId, String tag, RCRTCMediaType type, bool tiny) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'type': type.index,
      'tiny': tiny,
    };
    int code = await _channel.invokeMethod('subscribeCustomStream', arguments) ?? -1;
    return code;
  }

  Future<int> unsubscribeCustomStream(String userId, String tag, RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'type': type.index,
    };
    int code = await _channel.invokeMethod('unsubscribeCustomStream', arguments) ?? -1;
    return code;
  }

  Future<int> requestJoinSubRoom(String roomId, String userId, [bool autoLayout = true, String? extra]) async {
    Map<String, dynamic> arguments = {
      'rid': roomId,
      'uid': userId,
      'auto': autoLayout,
      'extra': extra,
    };
    int code = await _channel.invokeMethod('requestJoinSubRoom', arguments) ?? -1;
    return code;
  }

  Future<int> cancelJoinSubRoomRequest(String roomId, String userId, [String? extra]) async {
    Map<String, dynamic> arguments = {
      'rid': roomId,
      'uid': userId,
      'extra': extra,
    };
    int code = await _channel.invokeMethod('cancelJoinSubRoomRequest', arguments) ?? -1;
    return code;
  }

  Future<int> responseJoinSubRoomRequest(String roomId, String userId, bool agree, [bool autoLayout = true, String? extra]) async {
    Map<String, dynamic> arguments = {
      'rid': roomId,
      'uid': userId,
      'agree': agree,
      'auto': autoLayout,
      'extra': extra,
    };
    int code = await _channel.invokeMethod('responseJoinSubRoomRequest', arguments) ?? -1;
    return code;
  }

  Future<int> joinSubRoom(String roomId) async {
    int code = await _channel.invokeMethod('joinSubRoom', roomId) ?? -1;
    return code;
  }

  Future<int> leaveSubRoom(String roomId, bool disband) async {
    Map<String, dynamic> arguments = {
      'id': roomId,
      'disband': disband,
    };
    int code = await _channel.invokeMethod('leaveSubRoom', arguments) ?? -1;
    return code;
  }

  Future<dynamic> _handler(MethodCall call) async {
    switch (call.method) {
      case 'engine:onError':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onError?.call(code, message);
        break;
      case 'engine:onKicked':
        Map<dynamic, dynamic> arguments = call.arguments;
        String? id = arguments.containsKey('id') ? arguments['id'] : null;
        String? message = arguments['message'];
        onKicked?.call(id, message);
        break;
      case 'engine:onRoomJoined':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onRoomJoined?.call(code, message);
        break;
      case 'engine:onRoomLeft':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onRoomLeft?.call(code, message);
        break;
      case 'engine:onPublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onPublished?.call(RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onUnpublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onUnpublished?.call(RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onSubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onSubscribed?.call(id, RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onUnsubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onUnsubscribed?.call(id, RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onLiveMixSubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixSubscribed?.call(RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onLiveMixUnsubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixUnsubscribed?.call(RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onEnableCamera':
        Map<dynamic, dynamic> arguments = call.arguments;
        bool enable = arguments['enable'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onEnableCamera?.call(enable, code, message);
        break;
      case 'engine:onSwitchCamera':
        Map<dynamic, dynamic> arguments = call.arguments;
        int camera = arguments['camera'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onSwitchCamera?.call(RCRTCCamera.values[camera], code, message);
        break;
      case 'engine:onLiveCdnAdded':
        Map<dynamic, dynamic> arguments = call.arguments;
        String url = arguments['url'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveCdnAdded?.call(url, code, message);
        break;
      case 'engine:onLiveCdnRemoved':
        Map<dynamic, dynamic> arguments = call.arguments;
        String url = arguments['url'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveCdnRemoved?.call(url, code, message);
        break;
      case 'engine:onLiveMixLayoutModeSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixLayoutModeSet?.call(code, message);
        break;
      case 'engine:onLiveMixRenderModeSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixRenderModeSet?.call(code, message);
        break;
      case 'engine:onLiveMixBackgroundColorSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixBackgroundColorSet?.call(code, message);
        break;
      case 'engine:onLiveMixCustomLayoutsSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixCustomLayoutsSet?.call(code, message);
        break;
      case 'engine:onLiveMixCustomAudiosSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixCustomAudiosSet?.call(code, message);
        break;
      case 'engine:onLiveMixAudioBitrateSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixAudioBitrateSet?.call(code, message);
        break;
      case 'engine:onLiveMixVideoBitrateSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        bool tiny = arguments['tiny'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixVideoBitrateSet?.call(tiny, code, message);
        break;
      case 'engine:onLiveMixVideoResolutionSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        bool tiny = arguments['tiny'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixVideoResolutionSet?.call(tiny, code, message);
        break;
      case 'engine:onLiveMixVideoFpsSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        bool tiny = arguments['tiny'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixVideoFpsSet?.call(tiny, code, message);
        break;
      case 'engine:onAudioEffectCreated':
        Map<dynamic, dynamic> arguments = call.arguments;
        int id = arguments['id'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onAudioEffectCreated?.call(id, code, message);
        break;
      case 'engine:onAudioEffectFinished':
        int argument = call.arguments;
        onAudioEffectFinished?.call(argument);
        break;
      case 'engine:onAudioMixingStarted':
        onAudioMixingStarted?.call();
        break;
      case 'engine:onAudioMixingPaused':
        onAudioMixingPaused?.call();
        break;
      case 'engine:onAudioMixingStopped':
        onAudioMixingStopped?.call();
        break;
      case 'engine:onAudioMixingFinished':
        onAudioMixingFinished?.call();
        break;
      case 'engine:onUserJoined':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        onUserJoined?.call(rid, uid);
        break;
      case 'engine:onUserOffline':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        onUserOffline?.call(rid, uid);
        break;
      case 'engine:onUserLeft':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        onUserLeft?.call(rid, uid);
        break;
      case 'engine:onRemotePublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int type = arguments['type'];
        onRemotePublished?.call(rid, uid, RCRTCMediaType.values[type]);
        break;
      case 'engine:onRemoteUnpublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int type = arguments['type'];
        onRemoteUnpublished?.call(rid, uid, RCRTCMediaType.values[type]);
        break;
      case 'engine:onRemoteLiveMixPublished':
        int argument = call.arguments;
        onRemoteLiveMixPublished?.call(RCRTCMediaType.values[argument]);
        break;
      case 'engine:onRemoteLiveMixUnpublished':
        int argument = call.arguments;
        onRemoteLiveMixUnpublished?.call(RCRTCMediaType.values[argument]);
        break;
      case 'engine:onRemoteStateChanged':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int type = arguments['type'];
        bool disabled = arguments['disabled'];
        onRemoteStateChanged?.call(rid, uid, RCRTCMediaType.values[type], disabled);
        break;
      case 'engine:onRemoteFirstFrame':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int type = arguments['type'];
        onRemoteFirstFrame?.call(rid, uid, RCRTCMediaType.values[type]);
        break;
      case 'engine:onRemoteLiveMixFirstFrame':
        int argument = call.arguments;
        onRemoteLiveMixFirstFrame?.call(RCRTCMediaType.values[argument]);
        break;
      // case 'engine:onMessageReceived':
      //   Map<dynamic, dynamic> arguments = call.arguments;
      //   String id = arguments['id'];
      //   Message? message = MessageFactory.instance?.string2Message(arguments['message']);
      //   if (message != null) onMessageReceived?.call(id, message);
      //   break;
      case 'engine:onCustomStreamPublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        String tag = arguments['tag'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCustomStreamPublished?.call(tag, code, message);
        break;
      case 'engine:onCustomStreamPublishFinished':
        String argument = call.arguments;
        onCustomStreamPublishFinished?.call(argument);
        break;
      case 'engine:onCustomStreamUnpublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        String tag = arguments['tag'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCustomStreamUnpublished?.call(tag, code, message);
        break;
      case 'engine:onRemoteCustomStreamPublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        onRemoteCustomStreamPublished?.call(rid, uid, tag, RCRTCMediaType.values[type]);
        break;
      case 'engine:onRemoteCustomStreamUnpublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        onRemoteCustomStreamUnpublished?.call(rid, uid, tag, RCRTCMediaType.values[type]);
        break;
      case 'engine:onRemoteCustomStreamStateChanged':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        bool disabled = arguments['disabled'];
        onRemoteCustomStreamStateChanged?.call(rid, uid, tag, RCRTCMediaType.values[type], disabled);
        break;
      case 'engine:onRemoteCustomStreamFirstFrame':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        onRemoteCustomStreamFirstFrame?.call(rid, uid, tag, RCRTCMediaType.values[type]);
        break;
      case 'engine:onCustomStreamSubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCustomStreamSubscribed?.call(id, tag, RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onCustomStreamUnsubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCustomStreamUnsubscribed?.call(id, tag, RCRTCMediaType.values[type], code, message);
        break;
      case 'engine:onJoinSubRoomRequested':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onJoinSubRoomRequested?.call(rid, uid, code, message);
        break;
      case 'engine:onJoinSubRoomRequestCanceled':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onJoinSubRoomRequestCanceled?.call(rid, uid, code, message);
        break;
      case 'engine:onJoinSubRoomRequestResponded':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onJoinSubRoomRequestResponded?.call(rid, uid, code, message);
        break;
      case 'engine:onSubRoomJoined':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onSubRoomJoined?.call(id, code, message);
        break;
      case 'engine:onSubRoomLeft':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onSubRoomLeft?.call(id, code, message);
        break;
      case 'engine:onJoinSubRoomRequestReceived':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String? extra = arguments['extra'];
        onJoinSubRoomRequestReceived?.call(rid, uid, extra);
        break;
      case 'engine:onCancelJoinSubRoomRequestReceived':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String? extra = arguments['extra'];
        onCancelJoinSubRoomRequestReceived?.call(rid, uid, extra);
        break;
      case 'engine:onJoinSubRoomRequestResponseReceived':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        bool agree = arguments['agree'];
        String? extra = arguments['extra'];
        onJoinSubRoomRequestResponseReceived?.call(rid, uid, agree, extra);
        break;
      case 'engine:onSubRoomBanded':
        String argument = call.arguments;
        onSubRoomBanded?.call(argument);
        break;
      case 'engine:onSubRoomDisband':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        onSubRoomDisband?.call(rid, uid);
        break;
      case 'stats:onNetworkStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onNetworkStats(RCRTCNetworkStats.fromJson(arguments));
        break;
      case 'stats:onLocalAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLocalAudioStats(RCRTCLocalAudioStats.fromJson(arguments));
        break;
      case 'stats:onLocalVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLocalVideoStats(RCRTCLocalVideoStats.fromJson(arguments));
        break;
      case 'stats:onRemoteAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteAudioStats(rid, uid, RCRTCRemoteAudioStats.fromJson(stats));
        break;
      case 'stats:onRemoteVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteVideoStats(rid, uid, RCRTCRemoteVideoStats.fromJson(stats));
        break;
      case 'stats:onLiveMixAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLiveMixAudioStats(RCRTCRemoteAudioStats.fromJson(arguments));
        break;
      case 'stats:onLiveMixVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLiveMixVideoStats(RCRTCRemoteVideoStats.fromJson(arguments));
        break;
      case 'stats:onLiveMixMemberAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        int volume = arguments['volume'];
        _statsListener?.onLiveMixMemberAudioStats(id, volume);
        break;
      case 'stats:onLiveMixMemberCustomAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        String tag = arguments['tag'];
        int volume = arguments['volume'];
        _statsListener?.onLiveMixMemberCustomAudioStats(id, tag, volume);
        break;
      case 'stats:onLocalCustomAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String tag = arguments['tag'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onLocalCustomAudioStats(tag, RCRTCLocalAudioStats.fromJson(stats));
        break;
      case 'stats:onLocalCustomVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String tag = arguments['tag'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onLocalCustomVideoStats(tag, RCRTCLocalVideoStats.fromJson(stats));
        break;
      case 'stats:onRemoteCustomAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteCustomAudioStats(rid, uid, tag, RCRTCRemoteAudioStats.fromJson(stats));
        break;
      case 'stats:onRemoteCustomVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteCustomVideoStats(rid, uid, tag, RCRTCRemoteVideoStats.fromJson(stats));
        break;
    }
  }

  static RCRTCEngine? _instance;

  final MethodChannel _channel;

  RCRTCStatsListener? _statsListener;

  Function(int code, String? errMsg)? onError;
  Function(String? roomId, String? errMsg)? onKicked;

  Function(int code, String? errMsg)? onRoomJoined;
  Function(int code, String? errMsg)? onRoomLeft;

  Function(RCRTCMediaType type, int code, String? errMsg)? onPublished;
  Function(RCRTCMediaType type, int code, String? errMsg)? onUnpublished;

  Function(String userId, RCRTCMediaType type, int code, String? errMsg)? onSubscribed;
  Function(String userId, RCRTCMediaType type, int code, String? errMsg)? onUnsubscribed;

  Function(RCRTCMediaType type, int code, String? errMsg)? onLiveMixSubscribed;
  Function(RCRTCMediaType type, int code, String? errMsg)? onLiveMixUnsubscribed;

  Function(bool enable, int code, String? errMsg)? onEnableCamera;
  Function(RCRTCCamera camera, int code, String? errMsg)? onSwitchCamera;

  Function(String url, int code, String? errMsg)? onLiveCdnAdded;
  Function(String url, int code, String? errMsg)? onLiveCdnRemoved;

  Function(int code, String? errMsg)? onLiveMixLayoutModeSet;

  Function(int code, String? errMsg)? onLiveMixRenderModeSet;

  Function(int code, String? errMsg)? onLiveMixBackgroundColorSet;

  Function(int code, String? errMsg)? onLiveMixCustomLayoutsSet;

  Function(int code, String? errMsg)? onLiveMixCustomAudiosSet;

  Function(int code, String? errMsg)? onLiveMixAudioBitrateSet;

  Function(bool tiny, int code, String? errMsg)? onLiveMixVideoBitrateSet;
  Function(bool tiny, int code, String? errMsg)? onLiveMixVideoResolutionSet;
  Function(bool tiny, int code, String? errMsg)? onLiveMixVideoFpsSet;

  Function(int effectId, int code, String? errMsg)? onAudioEffectCreated;
  Function(int effectId)? onAudioEffectFinished;

  Function()? onAudioMixingStarted;
  Function()? onAudioMixingPaused;
  Function()? onAudioMixingStopped;
  Function()? onAudioMixingFinished;

  Function(String roomId, String userId)? onUserJoined;
  Function(String roomId, String userId)? onUserOffline;
  Function(String roomId, String userId)? onUserLeft;

  Function(String roomId, String userId, RCRTCMediaType type)? onRemotePublished;
  Function(String roomId, String userId, RCRTCMediaType type)? onRemoteUnpublished;

  Function(RCRTCMediaType type)? onRemoteLiveMixPublished;
  Function(RCRTCMediaType type)? onRemoteLiveMixUnpublished;

  Function(String roomId, String userId, RCRTCMediaType type, bool disabled)? onRemoteStateChanged;

  Function(String roomId, String userId, RCRTCMediaType type)? onRemoteFirstFrame;

  Function(RCRTCMediaType type)? onRemoteLiveMixFirstFrame;

  // Function(String roomId, Message message)? onMessageReceived;

  Function(String tag, int code, String? errMsg)? onCustomStreamPublished;
  Function(String tag)? onCustomStreamPublishFinished;
  Function(String tag, int code, String? errMsg)? onCustomStreamUnpublished;

  Function(String roomId, String userId, String tag, RCRTCMediaType type)? onRemoteCustomStreamPublished;
  Function(String roomId, String userId, String tag, RCRTCMediaType type)? onRemoteCustomStreamUnpublished;

  Function(String roomId, String userId, String tag, RCRTCMediaType type, bool disabled)? onRemoteCustomStreamStateChanged;

  Function(String roomId, String userId, String tag, RCRTCMediaType type)? onRemoteCustomStreamFirstFrame;

  Function(String userId, String tag, RCRTCMediaType type, int code, String? errMsg)? onCustomStreamSubscribed;
  Function(String userId, String tag, RCRTCMediaType type, int code, String? errMsg)? onCustomStreamUnsubscribed;

  Function(String roomId, String userId, int code, String? errMsg)? onJoinSubRoomRequested;
  Function(String roomId, String userId, int code, String? errMsg)? onJoinSubRoomRequestCanceled;
  Function(String roomId, String userId, int code, String? errMsg)? onJoinSubRoomRequestResponded;

  Function(String roomId, int code, String? errMsg)? onSubRoomJoined;
  Function(String roomId, int code, String? errMsg)? onSubRoomLeft;

  Function(String roomId, String userId, String? extra)? onJoinSubRoomRequestReceived;
  Function(String roomId, String userId, String? extra)? onCancelJoinSubRoomRequestReceived;
  Function(String roomId, String userId, bool agree, String? extra)? onJoinSubRoomRequestResponseReceived;

  Function(String roomId)? onSubRoomBanded;
  Function(String roomId, String userId)? onSubRoomDisband;
}
