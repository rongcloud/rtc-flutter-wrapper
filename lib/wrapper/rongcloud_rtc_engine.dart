/// @author Pan ming da
/// @time 2021/6/8 15:51
/// @version 1.0
import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'rongcloud_rtc_configs.dart';
import 'rongcloud_rtc_constants.dart';
import 'rongcloud_rtc_custom_layout.dart';
import 'rongcloud_rtc_listeners.dart';
import 'rongcloud_rtc_setups.dart';
import 'rongcloud_rtc_stats.dart';
import 'rongcloud_rtc_rect.dart';

part 'rongcloud_rtc_view.dart';

class RCRTCEngine {
  RCRTCEngine._()
    : _channel = MethodChannel('cn.rongcloud.rtc.flutter/engine') {
    _channel.setMethodCallHandler(_handler);
  }

  static Future<RCRTCEngine> create([RCRTCEngineSetup? setup]) {
    if (_instance == null) _instance = RCRTCEngine._();
    return _instance!._create(setup);
  }

  Future<RCRTCEngine> _create(RCRTCEngineSetup? setup) async {
    Map<String, dynamic> arguments = {'setup': setup?.toJson()};
    await _channel.invokeMethod('create', arguments);
    return Future.value(this);
  }

  /// [ZH]
  /// ---
  /// 销毁引擎
  /// ---
  /// [EN]
  /// ---
  /// Destroy engine
  /// ---
  Future<int> destroy() async {
    int code = await _channel.invokeMethod('destroy') ?? -1;
    if (code != 0) return code;
    _instance = null;
    return code;
  }

  /// [ZH]
  /// ---
  /// 加入房间
  /// @param roomId
  /// @param setup
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Join a room
  /// @param roomId
  /// @param setup
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> joinRoom(String roomId, RCRTCRoomSetup setup) async {
    Map<String, dynamic> arguments = {'id': roomId, 'setup': setup.toJson()};
    int code = await _channel.invokeMethod('joinRoom', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 离开房间
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Leave room
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> leaveRoom() async {
    int code = await _channel.invokeMethod('leaveRoom') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 加入房间后, 发布本地资源
  /// @param type 资源类型
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Publish local resources after joining room
  /// @param type Resource type
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> publish(RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {'type': type.index};
    int code = await _channel.invokeMethod('publish', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 加入房间后, 取消发布已经发布的本地资源
  /// @param type 资源类型
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Unpublish local resources after joining room
  /// @param type Resource type
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> unpublish(RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {'type': type.index};
    int code = await _channel.invokeMethod('unpublish', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 加入房间后, 订阅远端用户发布的资源,
  /// @param userIds 远端用户 UserId 列表
  /// @param type    资源类型
  /// @param tiny    视频小流, true:订阅视频小流 false:订阅视频大流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to remote user's resources after joining room
  /// @param userIds List of remote user IDs
  /// @param type    Resource type
  /// @param tiny    Video stream quality: true for low-res, false for high-res
  /// @return 0: success, non-zero: failure
  /// ---
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

  /// [ZH]
  /// ---
  /// 加入房间后, 订阅远端用户发布的资源,
  /// @param userIds 远端用户 UserId 列表
  /// @param type    资源类型
  /// @param tiny    视频小流, true:订阅视频小流 false:订阅视频大流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to remote user's resources after joining room
  /// @param userIds List of remote user IDs
  /// @param type    Resource type
  /// @param tiny    Video stream quality: true for low-res, false for high-res
  /// @return 0: success, non-zero: failure
  /// ---
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

  /// [ZH]
  /// ---
  /// 订阅主播合流资源, 仅供直播观众用户使用
  /// @param type 资源类型
  /// @param tiny 视频小流, true:订阅视频小流 false:订阅视频大流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to host's mixed stream (for live audience only)
  /// @param type Resource type
  /// @param tiny Video stream quality - true: low-res, false: high-res
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> subscribeLiveMix(RCRTCMediaType type, [bool tiny = true]) async {
    Map<String, dynamic> arguments = {'type': type.index, 'tiny': tiny};
    int code = await _channel.invokeMethod('subscribeLiveMix', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 加入房间后, 取消订阅远端用户发布的资源
  /// @param userIds 远端用户 UserId 列表
  /// @param type    资源类型
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe remote resources after joining room
  /// @param userIds List of remote user IDs
  /// @param type    Resource type
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> unsubscribe(String userId, RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {'id': userId, 'type': type.index};
    int code = await _channel.invokeMethod('unsubscribe', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 加入房间后, 取消订阅远端用户发布的资源
  /// @param userIds 远端用户 UserId 列表
  /// @param type    资源类型
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe remote resources after joining room
  /// @param userIds List of remote user IDs
  /// @param type    Resource type
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> unsubscribes(List<String> userIds, RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {'ids': userIds, 'type': type.index};
    int code = await _channel.invokeMethod('unsubscribes', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 取消订阅主播合流资源, 仅供直播观众用户使用
  /// @param type 资源类型
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe from host's mixed stream (for live audience only)
  /// @param type Resource type
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> unsubscribeLiveMix(RCRTCMediaType type) async {
    Map<String, dynamic> arguments = {'type': type.index};
    int code =
        await _channel.invokeMethod('unsubscribeLiveMix', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 音频参数配置
  /// @param config
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Audio parameter configuration
  /// @param config
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setAudioConfig(RCRTCAudioConfig config) async {
    Map<String, dynamic> arguments = {'config': config.toJson()};
    int code = await _channel.invokeMethod('setAudioConfig', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 视频参数配置
  /// @param config
  /// @param tiny   是否小流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Configure video parameters
  /// @param config
  /// @param tiny   Enable low-bitrate stream
  /// @return 0: Success, Non-zero: Failure
  /// ---
  Future<int> setVideoConfig(
    RCRTCVideoConfig config, [
    bool tiny = false,
  ]) async {
    Map<String, dynamic> arguments = {'config': config.toJson(), 'tiny': tiny};
    int code = await _channel.invokeMethod('setVideoConfig', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 打开/关闭麦克风
  /// @param enable true 打开, false 关闭
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Toggle microphone
  /// @param enable true to turn on, false to turn off
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> enableMicrophone(bool enable) async {
    int code = await _channel.invokeMethod('enableMicrophone', enable) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 打开/关闭外放
  /// @param enable true 打开, false 关闭
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Toggle speakerphone
  /// @param enable true to turn on, false to turn off
  /// @return 0 if success, non-zero for failure
  /// ---
  Future<int> enableSpeaker(bool enable) async {
    int code = await _channel.invokeMethod('enableSpeaker', enable) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 调整麦克风的音量
  /// @param volume 0 ~ 100, 默认值: 100
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Adjust mic volume
  /// @param volume Range: 0-100 (default: 100)
  /// @return 0: success, non-zero: failed
  /// ---
  Future<int> adjustLocalVolume(int volume) async {
    int code = await _channel.invokeMethod('adjustLocalVolume', volume) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 打开/关闭指定摄像头
  /// @param enable true 打开, false 关闭
  /// @param camera
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Toggle specified camera
  /// @param enable true to turn on, false to turn off
  /// @param camera
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> enableCamera(bool enable, [RCRTCCamera? camera]) async {
    Map<String, dynamic> arguments = {
      'enable': enable,
      'camera': camera?.index,
    };
    int code = await _channel.invokeMethod('enableCamera', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 切换摄像头
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Switch camera
  /// @return 0: success, non-zero: failed
  /// ---
  Future<int> switchCamera() async {
    int code = await _channel.invokeMethod('switchCamera') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 切换指定摄像头
  /// @param camera
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Switch to specified camera
  /// @param camera Target camera device
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> switchToCamera(RCRTCCamera camera) async {
    int code =
        await _channel.invokeMethod('switchToCamera', camera.index) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 获取当前使用摄像头位置
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Get current camera position
  /// @return 0: success, non-zero: failure
  /// ---
  Future<RCRTCCamera> whichCamera() async {
    int code = await _channel.invokeMethod('whichCamera') ?? -1;
    if (code != 0) return RCRTCCamera.none;
    return RCRTCCamera.values[code + 1];
  }

  /// [ZH]
  /// ---
  /// 摄像头是否支持区域对焦
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Checks if camera supports zone focus
  /// @return 0: success, non-zero: failure
  /// ---
  Future<bool> isCameraFocusSupported() async {
    bool result =
        await _channel.invokeMethod('isCameraFocusSupported') ?? false;
    return result;
  }

  /// [ZH]
  /// ---
  /// 摄像头是否支持区域测光
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Checks if camera supports zone metering
  /// @return 0: success, non-zero: failure
  /// ---
  Future<bool> isCameraExposurePositionSupported() async {
    bool result =
        await _channel.invokeMethod('isCameraExposurePositionSupported') ??
        false;
    return result;
  }

  /// [ZH]
  /// ---
  /// 在指定点区域对焦
  /// @param x
  /// @param y
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Focus on specified point area
  /// @param x
  /// @param y
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setCameraFocusPositionInPreview(double x, double y) async {
    Map<String, dynamic> arguments = {'x': x, 'y': y};
    int code =
        await _channel.invokeMethod(
          'setCameraFocusPositionInPreview',
          arguments,
        ) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 在指定点区域测光
  /// @param x
  /// @param y
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Meter light at specified point
  /// @param x
  /// @param y
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setCameraExposurePositionInPreview(double x, double y) async {
    Map<String, dynamic> arguments = {'x': x, 'y': y};
    int code =
        await _channel.invokeMethod(
          'setCameraExposurePositionInPreview',
          arguments,
        ) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 摄像头采集方向
  /// @param orientation 方向
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Camera capture orientation
  /// @param orientation Orientation
  /// @return 0: Success, Non-zero: Failure
  /// ---
  Future<int> setCameraCaptureOrientation(
    RCRTCCameraCaptureOrientation orientation,
  ) async {
    Map<String, dynamic> arguments = {'orientation': orientation.index};
    int code =
        await _channel.invokeMethod('setCameraCaptureOrientation', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置本地视频View
  /// @param view
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set local video view
  /// @param view
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLocalView(RCRTCView view) async {
    Map<String, dynamic> arguments = {'view': view._id};
    int code = await _channel.invokeMethod('setLocalView', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除本地视频View
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Remove local video view
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> removeLocalView() async {
    int code = await _channel.invokeMethod('removeLocalView') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置远端视频View
  /// @param userId 远端用户的 UserId
  /// @param view   RRCRTCIWView 对象
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set remote video view
  /// @param userId Remote user ID
  /// @param view RRCRTCIWView object
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setRemoteView(String userId, RCRTCView view) async {
    Map<String, dynamic> arguments = {'id': userId, 'view': view._id};
    int code = await _channel.invokeMethod('setRemoteView', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除远端视频View
  /// @param userId 远端用户的 UserId
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Remove remote video view
  /// @param userId Remote user's ID
  /// @return 0: Success, Non-zero: Failure
  /// ---
  Future<int> removeRemoteView(String userId) async {
    int code = await _channel.invokeMethod('removeRemoteView', userId) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置合流视频View
  /// @param view
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set composite video view
  /// @param view
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixView(RCRTCView view) async {
    Map<String, dynamic> arguments = {'view': view._id};
    int code = await _channel.invokeMethod('setLiveMixView', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除合流视频View
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Remove merged video view
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> removeLiveMixView() async {
    int code = await _channel.invokeMethod('removeLiveMixView') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止本地数据渲染
  /// @param type 资源类型
  /// @param mute true: 不渲染 false: 渲染
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop local data rendering
  /// @param type Resource type
  /// @param mute true: mute rendering, false: render
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> muteLocalStream(RCRTCMediaType type, bool mute) async {
    Map<String, dynamic> arguments = {'type': type.index, 'mute': mute};
    int code = await _channel.invokeMethod('muteLocalStream', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止远端数据渲染
  /// @param userId 远端用户的 UserId
  /// @param type   资源类型
  /// @param mute   true: 不渲染 false: 渲染
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop remote data rendering
  /// @param userId Remote user ID
  /// @param type   Resource type
  /// @param mute   true: stop rendering, false: render
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> muteRemoteStream(
    String userId,
    RCRTCMediaType type,
    bool mute,
  ) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'type': type.index,
      'mute': mute,
    };
    int code = await _channel.invokeMethod('muteRemoteStream', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止合流数据渲染
  /// @param type
  /// @param mute
  /// @return
  /// ---
  /// [EN]
  /// ---
  /// Stop mixed stream rendering
  /// @param type Stream type
  /// @param mute Mute flag
  /// @return Operation status
  /// ---
  Future<int> muteLiveMixStream(RCRTCMediaType type, bool mute) async {
    Map<String, dynamic> arguments = {'type': type.index, 'mute': mute};
    int code =
        await _channel.invokeMethod('muteLiveMixStream', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置 CDN 直播推流地址, 仅供直播主播用户使用
  /// @param url 推流地址
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set CDN live streaming URL (hosts only)
  /// @param url Streaming URL
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> addLiveCdn(String url) async {
    int code = await _channel.invokeMethod('addLiveCdn', url) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除 CDN 直播推流地址, 仅供直播主播用户使用
  /// @param url 推流地址
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Remove CDN live streaming URL (for hosts only)
  /// @param url Streaming URL
  /// @return 0: success, non-zero: failed
  /// ---
  Future<int> removeLiveCdn(String url) async {
    int code = await _channel.invokeMethod('removeLiveCdn', url) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播合流布局类型, 仅供直播主播用户使用
  /// @param mode 布局类型
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set live stream layout type (host only)
  /// @param mode Layout type
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixLayoutMode(RCRTCLiveMixLayoutMode mode) async {
    int code =
        await _channel.invokeMethod('setLiveMixLayoutMode', mode.index) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播合流布局填充类型, 仅供直播主播用户使用
  /// @param mode 填充类型
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set live stream layout fill mode (host only)
  /// @param mode Fill mode type
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixRenderMode(RCRTCLiveMixRenderMode mode) async {
    int code =
        await _channel.invokeMethod('setLiveMixRenderMode', mode.index) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播合流布局背景颜色, 仅供直播主播用户使用
  /// @param red   红色 取值范围: 0 ~ 255
  /// @param green 绿色 取值范围: 0 ~ 255
  /// @param blue  蓝色 取值范围: 0 ~ 255
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set live stream layout background color (host only)
  /// @param red   Red value (0-255)
  /// @param green Green value (0-255)
  /// @param blue  Blue value (0-255)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixBackgroundColor(Color color) async {
    Map<String, dynamic> arguments = {
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
    };
    int code =
        await _channel.invokeMethod('setLiveMixBackgroundColor', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播混流布局配置, 仅供直播主播用户使用
  /// @param layouts 混流布局列表
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Configure live stream layout (host only)
  /// @param layouts Array of mixing layouts
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixCustomLayouts(List<RCRTCCustomLayout> layouts) async {
    Map<String, dynamic> arguments = {
      'layouts': layouts.map((layout) => layout.toJson()).toList(),
    };
    int code =
        await _channel.invokeMethod('setLiveMixCustomLayouts', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播自定义音频流列表, 仅供直播主播用户使用
  /// @param userIds 用户UserId 列表
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set custom audio streams for live hosts
  /// @param userIds List of user IDs
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixCustomAudios(List<String> userIds) async {
    Map<String, dynamic> arguments = {'ids': userIds};
    int code =
        await _channel.invokeMethod('setLiveMixCustomAudios', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播合流音频码率, 仅供直播主播用户使用
  /// @param bitrate 音频码率
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set audio bitrate for live stream mixing (hosts only)
  /// @param bitrate Audio bitrate
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixAudioBitrate(int bitrate) async {
    int code =
        await _channel.invokeMethod('setLiveMixAudioBitrate', bitrate) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播合流大流视频码率, 仅供直播主播用户使用
  /// @param bitrate 视频码率
  /// @param tiny    是否小流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set main stream bitrate for live mixing (hosts only)
  /// @param bitrate Video bitrate
  /// @param tiny    Whether it's a substream
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixVideoBitrate(int bitrate, [bool tiny = false]) async {
    Map<String, dynamic> arguments = {'bitrate': bitrate, 'tiny': tiny};
    int code =
        await _channel.invokeMethod('setLiveMixVideoBitrate', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播合流大流视频分辨率, 仅供直播主播用户使用
  /// @param width  视频宽度
  /// @param height 视频高度
  /// @param tiny   是否小流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set merged live stream resolution (host only)
  /// @param width  Video width
  /// @param height Video height
  /// @param tiny   Tiny stream flag
  /// @return 0: success, non-zero: failure
  /// ---
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
    int code =
        await _channel.invokeMethod('setLiveMixVideoResolution', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播合流大流视频帧率, 仅供直播主播用户使用
  /// @param fps  视频帧率
  /// @param tiny 是否小流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set main stream frame rate for live mixing (host only)
  /// @param fps  Frame rate
  /// @param tiny Whether it's substream
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixVideoFps(RCRTCVideoFps fps, [bool tiny = false]) async {
    Map<String, dynamic> arguments = {'fps': fps.index, 'tiny': tiny};
    int code =
        await _channel.invokeMethod('setLiveMixVideoFps', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 引擎音视频数据状态回调通知
  /// @param listener
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// RTC engine data status callback
  /// @param listener Callback handler
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setStatsListener(RCRTCStatsListener? listener) async {
    bool remove = listener == null;
    int code = await _channel.invokeMethod('setStatsListener', remove) ?? -1;
    if (code == 0) {
      _statsListener = listener;
    }
    return code;
  }

  Future<int> createAudioEffectFromAssets(String path, int effectId) async {
    Map<String, dynamic> arguments = {'assets': path, 'id': effectId};
    int code =
        await _channel.invokeMethod('createAudioEffect', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 创建音效, 仅供会议用户或直播主播用户使用
  /// @param uri      文件URI
  /// @param effectId 自定义全局唯一音效Id
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Create sound effect (meeting hosts or live streamers only)
  /// @param uri      File URI
  /// @param effectId Globally unique custom sound ID
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> createAudioEffect(String path, int effectId) async {
    Map<String, dynamic> arguments = {'path': path, 'id': effectId};
    int code =
        await _channel.invokeMethod('createAudioEffect', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 释放音效, 仅供会议用户或直播主播用户使用
  /// @param effectId 自定义全局唯一音效Id
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Release audio effect (for meeting hosts or live streamers only)
  /// @param effectId Unique global sound effect ID
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> releaseAudioEffect(int effectId) async {
    int code =
        await _channel.invokeMethod('releaseAudioEffect', effectId) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 播放音效, 仅供会议用户或直播主播用户使用
  /// @param effectId 自定义全局唯一音效Id
  /// @param volume   音效文件播放音量
  /// @param loop     循环播放次数
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Play sound effect (meeting hosts or live streamers only)
  /// @param effectId Unique global sound effect ID
  /// @param volume   Playback volume level
  /// @param loop     Number of playback loops
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> playAudioEffect(int effectId, int volume, [int loop = 1]) async {
    Map<String, dynamic> arguments = {
      'id': effectId,
      'volume': volume,
      'loop': loop,
    };
    int code = await _channel.invokeMethod('playAudioEffect', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 暂停音效文件播放, 仅供会议用户或直播主播用户使用
  /// @param effectId 自定义全局唯一音效Id
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Pause audio effect playback (meeting hosts/live streamers only)
  /// @param effectId Unique global audio effect ID
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> pauseAudioEffect(int effectId) async {
    int code = await _channel.invokeMethod('pauseAudioEffect', effectId) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 暂停全部音效文件播放, 仅供会议用户或直播主播用户使用
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Pause all sound effects
  /// Available only for meeting participants or live stream hosts
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> pauseAllAudioEffects() async {
    int code = await _channel.invokeMethod('pauseAllAudioEffects') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 恢复音效文件播放, 仅供会议用户或直播主播用户使用
  /// @param effectId 自定义全局唯一音效Id
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Resume audio effect playback (meeting hosts/live streamers only)
  /// @param effectId Unique global audio effect ID
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> resumeAudioEffect(int effectId) async {
    int code = await _channel.invokeMethod('resumeAudioEffect', effectId) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 恢复全部音效文件播放, 仅供会议用户或直播主播用户使用
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Resume all audio playback (meeting hosts & live streamers only)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> resumeAllAudioEffects() async {
    int code = await _channel.invokeMethod('resumeAllAudioEffects') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止音效文件播放, 仅供会议用户或直播主播用户使用
  /// @param effectId 自定义全局唯一音效Id
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop audio effect playback (for meeting hosts or live streamers only)
  /// @param effectId Unique global audio effect ID
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> stopAudioEffect(int effectId) async {
    int code = await _channel.invokeMethod('stopAudioEffect', effectId) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止全部音效文件播放, 仅供会议用户或直播主播用户使用
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop all sound effects playback (meeting hosts or live streamers only)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> stopAllAudioEffects() async {
    int code = await _channel.invokeMethod('stopAllAudioEffects') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置音效文件播放音量, 仅供会议用户或直播主播用户使用
  /// @param effectId 自定义全局唯一音效Id
  /// @param volume   音量 0~100, 默认 100
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set audio effect volume (meeting hosts/live streamers only)
  /// @param effectId Unique sound effect ID
  /// @param volume Volume level (0-100, default 100)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> adjustAudioEffectVolume(int effectId, int volume) async {
    Map<String, dynamic> arguments = {'id': effectId, 'volume': volume};
    int code =
        await _channel.invokeMethod('adjustAudioEffectVolume', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 获取音效文件播放音量, 仅供会议用户或直播主播用户使用
  /// @param effectId 自定义全局唯一音效Id
  /// @return 大于或等于0: 调用成功, 小于0: 调用失败
  /// ---
  /// [EN]
  /// ---
  /// Get audio effect volume (meeting hosts & live streamers only)
  /// @param effectId Unique global effect ID
  /// @return ≥0: success, <0: failure
  /// ---
  Future<int> getAudioEffectVolume(int effectId) async {
    int code =
        await _channel.invokeMethod('getAudioEffectVolume', effectId) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置全局音效文件播放音量, 仅供会议用户或直播主播用户使用
  /// @param volume 音量 0~100, 默认 100
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set global audio volume (meeting hosts & live streamers only)
  /// @param volume Range: 0~100 (default: 100)
  /// @return 0: success, non-zero: failed
  /// ---
  Future<int> adjustAllAudioEffectsVolume(int volume) async {
    int code =
        await _channel.invokeMethod('adjustAllAudioEffectsVolume', volume) ??
        -1;
    return code;
  }

  Future<int> startAudioMixingFromAssets({
    required String path,
    required RCRTCAudioMixingMode mode,
    bool playback = true,
    int loop = 1,
    double position = 0,
  }) async {
    Map<String, dynamic> arguments = {
      'assets': path,
      'mode': mode.index,
      'playback': playback,
      'loop': loop,
      'position': position,
    };
    int code = await _channel.invokeMethod('startAudioMixing', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 开始混音, 仅支持混合本地音频文件数据, 仅供会议用户或直播主播用户使用
  /// @param uri      文件URI
  /// @param mode     混音行为模式
  /// @param playback 是否本地播放
  /// @param loop     循环混音或者播放次数
  /// @param position 进度 0.0 ~ 1.0
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Start audio mixing (local files only)
  /// For meeting hosts or live streamers
  /// @param uri      File URI
  /// @param mode     Mixing mode
  /// @param playback Play locally
  /// @param loop     Loop or play count
  /// @param position Progress (0.0~1.0)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> startAudioMixing({
    required String path,
    required RCRTCAudioMixingMode mode,
    bool playback = true,
    int loop = 1,
    double position = 0,
  }) async {
    Map<String, dynamic> arguments = {
      'path': path,
      'mode': mode.index,
      'playback': playback,
      'loop': loop,
      'position': position,
    };
    int code = await _channel.invokeMethod('startAudioMixing', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止混音, 仅供会议用户或直播主播用户使用
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop audio mixing (for meeting hosts or live streamers only)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> stopAudioMixing() async {
    int code = await _channel.invokeMethod('stopAudioMixing') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 暂停混音, 仅供会议用户或直播主播用户使用
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Pause audio mixing (meeting hosts or live streamers only)
  /// @return 0: success, non-zero: failed
  /// ---
  Future<int> pauseAudioMixing() async {
    int code = await _channel.invokeMethod('pauseAudioMixing') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 恢复混音, 仅供会议用户或直播主播用户使用
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Resume audio mixing (for meeting hosts or live streamers only)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> resumeAudioMixing() async {
    int code = await _channel.invokeMethod('resumeAudioMixing') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 调整混音音量, 仅供会议用户或直播主播用户使用
  /// @param volume 音量 0~100, 默认 100
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Adjust audio mixing volume (for meeting hosts or live streamers only)
  /// @param volume Volume level (0-100, default 100)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> adjustAudioMixingVolume(int volume) async {
    int code =
        await _channel.invokeMethod('adjustAudioMixingVolume', volume) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 调整本地混音音量, 仅供会议用户或直播主播用户使用
  /// @param volume 音量 0~100, 默认 100
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Adjust local mixing volume (for meeting participants or live hosts only)
  /// @param volume Volume level (0-100, default 100)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> adjustAudioMixingPlaybackVolume(int volume) async {
    int code =
        await _channel.invokeMethod(
          'adjustAudioMixingPlaybackVolume',
          volume,
        ) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 获取本地播放混音音量, 仅供会议用户或直播主播用户使用
  /// @return 大于或等于0: 调用成功, 小于0: 调用失败
  /// ---
  /// [EN]
  /// ---
  /// Get local audio mixing volume (for meeting hosts or live streamers only)
  /// @return ≥0 means success, <0 means failure
  /// ---
  Future<int> getAudioMixingPlaybackVolume() async {
    int code =
        await _channel.invokeMethod('getAudioMixingPlaybackVolume') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 调整远端混音音量, 仅供会议用户或直播主播用户使用
  /// @param volume 音量 0~100, 默认 100
  /// @return 大于或等于0: 调用成功, 小于0: 调用失败
  /// ---
  /// [EN]
  /// ---
  /// Adjust remote mixing volume (for meeting participants or live hosts only)
  /// @param volume Volume level 0-100 (default: 100)
  /// @return ≥0 means success, <0 means failure
  /// ---
  Future<int> adjustAudioMixingPublishVolume(int volume) async {
    int code =
        await _channel.invokeMethod('adjustAudioMixingPublishVolume', volume) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 获取远端混音音量, 仅供会议用户或直播主播用户使用
  /// @return 大于或等于0: 调用成功, 小于0: 调用失败
  /// ---
  /// [EN]
  /// ---
  /// Get remote audio mixing volume (for meeting participants or live hosts only)
  /// @return 0 or higher means success, negative means failure
  /// ---
  Future<int> getAudioMixingPublishVolume() async {
    int code = await _channel.invokeMethod('getAudioMixingPublishVolume') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 调整混音进度, 仅供会议用户或直播主播用户使用
  /// @param position 进度 0.0 ~ 1.0
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Adjust audio mixing progress
  /// For meeting hosts or live streamers only
  /// @param position Progress value (0.0~1.0)
  /// @return 0: Success, Non-zero: Failed
  /// ---
  Future<int> setAudioMixingPosition(double position) async {
    int code =
        await _channel.invokeMethod('setAudioMixingPosition', position) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 获取当前混音进度, 仅供会议用户或直播主播用户使用
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Get current mixing progress
  /// For meeting hosts or live streamers only
  /// @return 0: Success, Non-zero: Failed
  /// ---
  Future<double> getAudioMixingPosition() async {
    double code = await _channel.invokeMethod('getAudioMixingPosition') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 获取混音文件时长, 仅供会议用户或直播主播用户使用
  /// @return 大于或等于0: 调用成功, 小于0: 调用失败
  /// ---
  /// [EN]
  /// ---
  /// Get audio mix file duration (for meeting hosts or live streamers only)
  /// @return ≥0: success, <0: failure
  /// ---
  Future<int> getAudioMixingDuration() async {
    int code = await _channel.invokeMethod('getAudioMixingDuration') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 获取房间会话Id
  /// @return
  /// ---
  /// [EN]
  /// ---
  /// Get room session ID
  /// @return
  /// ---
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
    int code =
        await _channel.invokeMethod('createCustomStreamFromFile', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 创建基于文件的自定义流
  /// @param uri
  /// @param tag
  /// @param replace
  /// @param playback
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Create file-based custom stream
  /// @param uri
  /// @param tag
  /// @param replace
  /// @param playback
  /// @return 0: success, non-zero: failure
  /// ---
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
    int code =
        await _channel.invokeMethod('createCustomStreamFromFile', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置自定义流的视频配置
  /// @param tag
  /// @param config
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set custom stream video config
  /// @param tag
  /// @param config
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setCustomStreamVideoConfig(
    String tag,
    RCRTCVideoConfig config,
  ) async {
    Map<String, dynamic> arguments = {'tag': tag, 'config': config.toJson()};
    int code =
        await _channel.invokeMethod('setCustomStreamVideoConfig', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止本地数据渲染
  /// @param tag
  /// @param mute
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop local data rendering
  /// @param tag
  /// @param mute
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> muteLocalCustomStream(String tag, bool mute) async {
    Map<String, dynamic> arguments = {'tag': tag, 'mute': mute};
    int code =
        await _channel.invokeMethod('muteLocalCustomStream', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置本地自定义视频预览窗口
  /// @param tag
  /// @param view
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set local custom video preview window
  /// @param tag
  /// @param view
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLocalCustomStreamView(String tag, RCRTCView view) async {
    Map<String, dynamic> arguments = {'tag': tag, 'view': view._id};
    int code =
        await _channel.invokeMethod('setLocalCustomStreamView', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除本地自定义视频预览窗口
  /// @param tag
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Remove local custom video preview window
  /// @param tag
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> removeLocalCustomStreamView(String tag) async {
    int code =
        await _channel.invokeMethod('removeLocalCustomStreamView', tag) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 发布自定义视频
  /// @param tag
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Publish custom video
  /// @param tag
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> publishCustomStream(String tag) async {
    int code = await _channel.invokeMethod('publishCustomStream', tag) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 取消发布自定义视频
  /// @param tag
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Unpublish custom video
  /// @param tag
  /// @return 0: success, non-zero: failed
  /// ---
  Future<int> unpublishCustomStream(String tag) async {
    int code = await _channel.invokeMethod('unpublishCustomStream', tag) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止远端数据渲染
  /// @param userId
  /// @param tag
  /// @param type
  /// @param mute
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop remote data rendering
  /// @param userId
  /// @param tag
  /// @param type
  /// @param mute
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> muteRemoteCustomStream(
    String userId,
    String tag,
    RCRTCMediaType type,
    bool mute,
  ) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'type': type.index,
      'mute': mute,
    };
    int code =
        await _channel.invokeMethod('muteRemoteCustomStream', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置远端自定义视频预览窗口
  /// @param userId
  /// @param tag
  /// @param view
  /// @return
  /// ---
  /// [EN]
  /// ---
  /// Set remote custom video preview window
  /// @param userId
  /// @param tag
  /// @param view
  /// @return
  /// ---
  Future<int> setRemoteCustomStreamView(
    String userId,
    String tag,
    RCRTCView view,
  ) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'view': view._id,
    };
    int code =
        await _channel.invokeMethod('setRemoteCustomStreamView', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除远端自定义视频预览窗口
  /// @param userId
  /// @param tag
  /// @return
  /// ---
  /// [EN]
  /// ---
  /// Remove remote custom video preview window
  /// @param userId
  /// @param tag
  /// @return
  /// ---
  Future<int> removeRemoteCustomStreamView(String userId, String tag) async {
    Map<String, dynamic> arguments = {'id': userId, 'tag': tag};
    int code =
        await _channel.invokeMethod(
          'removeRemoteCustomStreamView',
          arguments,
        ) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 订阅自定义流
  /// @param userId
  /// @param type
  /// @param tag
  /// @param tiny
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to custom stream
  /// @param userId User identifier
  /// @param type Stream type
  /// @param tag Stream tag
  /// @param tiny Tiny flag
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> subscribeCustomStream(
    String userId,
    String tag,
    RCRTCMediaType type,
    bool tiny,
  ) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'type': type.index,
      'tiny': tiny,
    };
    int code =
        await _channel.invokeMethod('subscribeCustomStream', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 取消订阅自定义流
  /// @param userId
  /// @param type
  /// @param tag
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe from custom stream
  /// @param userId
  /// @param type
  /// @param tag
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> unsubscribeCustomStream(
    String userId,
    String tag,
    RCRTCMediaType type,
  ) async {
    Map<String, dynamic> arguments = {
      'id': userId,
      'tag': tag,
      'type': type.index,
    };
    int code =
        await _channel.invokeMethod('unsubscribeCustomStream', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 请求加入子房间（跨房间连麦）
  /// @param roomId     目标房间id
  /// @param userId     目标主播id
  /// @param autoLayout 是否自动布局
  /// 开启自动布局
  /// 如果被邀请方在加入邀请方房间之前发布了资源，当被邀请方加入邀请者房间成功后，服务器会把被邀请方流资源合并到邀请方视图（默认仅悬浮布局合流）上。
  /// 如果被邀请方在加入邀请方房间之前没有发布过资源，将会在被邀请方发布资源成功后，服务器会把被邀请方流资源合并到邀请方视图（默认仅悬浮布局合流）上。
  /// 双方可以主动设置合流布局。一旦主动设置过合流布局，后续RTC直播过程中设置的自动合流参数将失效。
  /// @param extra      附加信息，默认为空
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Join a sub-room (cross-room co-streaming)
  /// @param roomId     Target room ID
  /// @param userId     Target host ID
  /// @param autoLayout Auto-layout toggle
  /// When enabled:
  /// - If the invitee published streams before joining, their streams merge into inviter's view (floating layout by default) after joining
  /// - If no streams published, merging occurs after the invitee starts streaming
  /// Both parties can manually set layouts. Manual settings override auto-layout during live streaming
  /// @param extra      Additional info (optional)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> requestJoinSubRoom(
    String roomId,
    String userId, [
    bool autoLayout = true,
    String? extra,
  ]) async {
    Map<String, dynamic> arguments = {
      'rid': roomId,
      'uid': userId,
      'auto': autoLayout,
      'extra': extra,
    };
    int code =
        await _channel.invokeMethod('requestJoinSubRoom', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 取消正在进行中的加入子房间（跨房间连麦）请求
  /// @param roomId 正在请求的目标房间id
  /// @param userId 正在请求的目标主播id
  /// @param extra  附加信息，默认为空
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Cancel ongoing sub-room join request (cross-room mic connect)
  /// @param roomId Target room ID for the request
  /// @param userId Target host ID for the request
  /// @param extra  Additional info, empty by default
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> cancelJoinSubRoomRequest(
    String roomId,
    String userId, [
    String? extra,
  ]) async {
    Map<String, dynamic> arguments = {
      'rid': roomId,
      'uid': userId,
      'extra': extra,
    };
    int code =
        await _channel.invokeMethod('cancelJoinSubRoomRequest', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 响应加入子房间（跨房间连麦）请求
  /// @param roomId     发起请求的目标房间id
  /// @param userId     发起请求的主播id
  /// @param agree      是否同意（跨房间连麦）
  /// @param autoLayout 是否自动布局
  /// 开启自动布局
  /// 如果被邀请方在加入邀请方房间之前发布了资源，当被邀请方加入邀请者房间成功后，服务器会把被邀请方流资源合并到邀请方视图（默认仅悬浮布局合流）上。
  /// 如果被邀请方在加入邀请方房间之前没有发布过资源，将会在被邀请方发布资源成功后，服务器会把被邀请方流资源合并到邀请方视图（默认仅悬浮布局合流）上。
  /// 双方可以主动设置合流布局。一旦主动设置过合流布局，后续RTC直播过程中设置的自动合流参数将失效。
  /// @param extra      附加信息，默认为空
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Respond to cross-room co-streaming request
  /// @param roomId     Target room ID
  /// @param userId     Host ID initiating the request
  /// @param agree      Accept co-streaming or not
  /// @param autoLayout Auto-layout toggle
  /// When enabled:
  /// - If invitee published streams before joining, server merges them into inviter's view (floating layout by default)
  /// - If no streams published, merging occurs after invitee starts streaming
  /// Manual layout settings override auto-layout for the entire session
  /// @param extra      Additional info (optional)
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> responseJoinSubRoomRequest(
    String roomId,
    String userId,
    bool agree, [
    bool autoLayout = true,
    String? extra,
  ]) async {
    Map<String, dynamic> arguments = {
      'rid': roomId,
      'uid': userId,
      'agree': agree,
      'auto': autoLayout,
      'extra': extra,
    };
    int code =
        await _channel.invokeMethod('responseJoinSubRoomRequest', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 加入子房间
  /// 前提必须已经 通过 {@link RCRTCIWEngine#joinRoom(String, RCRTCIWRoomSetup)} 加入了主房间
  /// 未建立连麦时，需先调用 {@link RCRTCIWEngine#requestJoinSubRoom(String, String, boolean, String)} 发起加入请求
  /// @param roomId 目标房间id
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Join a sub room
  /// Requires being in main room via {@link RCRTCIWEngine#joinRoom(String, RCRTCIWRoomSetup)} first
  /// Call {@link RCRTCIWEngine#requestJoinSubRoom(String, String, boolean, String)} to request access if no live connection exists
  /// @param roomId Target room ID
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> joinSubRoom(String roomId) async {
    int code = await _channel.invokeMethod('joinSubRoom', roomId) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 离开子房间
  /// @param roomId  子房间id
  /// @param disband 是否解散，解散后再次加入需先调用 {@link RCRTCIWEngine#requestJoinSubRoom(String, String, boolean, String)} 发起加入请求
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Leave sub-room
  /// @param roomId Sub-room ID
  /// @param disband Whether to disband. If disbanded, call {@link RCRTCIWEngine#requestJoinSubRoom(String, String, boolean, String)} to rejoin
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> leaveSubRoom(String roomId, bool disband) async {
    Map<String, dynamic> arguments = {'id': roomId, 'disband': disband};
    int code = await _channel.invokeMethod('leaveSubRoom', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 切换直播角色
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Switch live streaming role
  /// @return 0: Success, Non-zero: Failure
  /// ---
  Future<int> switchLiveRole(RCRTCRole role) async {
    int code = await _channel.invokeMethod('switchLiveRole', role.index) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 开启 SEI 功能，观众身份调用无效
  /// @param enable 是否开启
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Enable SEI feature (invalid for audience role)
  /// @param enable Enable or not
  /// @return Status code: 0 for success, non-zero for failure
  /// ---
  Future<int> enableSei(bool enable) async {
    int code = await _channel.invokeMethod('enableSei', enable) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 发送 SEI 信息，需开启 SEI 功能之后调用
  /// @param sei SEI 信息
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Send SEI message (requires enabled SEI feature)
  /// @param sei SEI message
  /// @return status code (0: success, non-zero: failure)
  /// ---
  Future<int> sendSei(String sei) async {
    int code = await _channel.invokeMethod('sendSei', sei) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 预链接到媒体服务器
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Preconnect to media server
  /// @return Status code: 0 means success, non-zero means failure
  /// ---
  Future<int> preconnectToMediaServer() async {
    int code = await _channel.invokeMethod('preconnectToMediaServer') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 开启直播内置 cdn 功能
  /// @param enable
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Enable built-in CDN for live streaming
  /// @param enable
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> enableLiveMixInnerCdnStream(bool enable) async {
    Map<String, dynamic> arguments = {'enable': enable};
    int code =
        await _channel.invokeMethod('enableLiveMixInnerCdnStream', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 订阅直播内置 cdn 流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to built-in live CDN stream
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> subscribeLiveMixInnerCdnStream() async {
    int code =
        await _channel.invokeMethod('subscribeLiveMixInnerCdnStream') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 取消订阅直播内置 cdn 流
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe from built-in live CDN stream
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> unsubscribeLiveMixInnerCdnStream() async {
    int code =
        await _channel.invokeMethod('unsubscribeLiveMixInnerCdnStream') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 观众端禁用或启用RC内置 CDN 流
  /// @param mute  true: 停止资源渲染，false: 恢复资源渲染
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Toggle RC built-in CDN stream for audience
  /// @param mute  true: stop rendering, false: resume rendering
  /// @return status code (0: success, non-zero: failure)
  /// ---
  Future<int> muteLiveMixInnerCdnStream(bool mute) async {
    Map<String, dynamic> arguments = {'mute': mute};
    int code =
        await _channel.invokeMethod('muteLiveMixInnerCdnStream', arguments) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置直播内置 cdn 流预览窗口
  /// @param view
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set built-in CDN stream preview window for live broadcast
  /// @param view Preview window handle
  /// @return 0: success, non-zero: failure
  /// ---
  Future<int> setLiveMixInnerCdnStreamView(RCRTCView view) async {
    Map<String, dynamic> arguments = {'view': view._id};
    int code =
        await _channel.invokeMethod(
          'setLiveMixInnerCdnStreamView',
          arguments,
        ) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除直播内置 cdn 流预览窗口
  /// @return 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Remove built-in CDN preview window for live streaming
  /// @return 0: success, non-zero: failed
  /// ---
  Future<int> removeLiveMixInnerCdnStreamView() async {
    int code =
        await _channel.invokeMethod('removeLiveMixInnerCdnStreamView') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 观众端 设置订阅 cdn 流的分辨率
  /// @param width    分辨率宽
  /// @param height   高
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set CDN stream resolution for audience
  /// @param width    Stream width
  /// @param height   Stream height
  /// @return Status code (0: success, non-zero: failure)
  /// ---
  Future<int> setLocalLiveMixInnerCdnVideoResolution(
    int width,
    int height,
  ) async {
    Map<String, dynamic> arguments = {'width': width, 'height': height};
    int code =
        await _channel.invokeMethod(
          'setLocalLiveMixInnerCdnVideoResolution',
          arguments,
        ) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 观众端设置订阅 cdn 流的帧率
  /// @param fps   帧率
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set CDN stream frame rate for audience
  /// @param fps   Frame rate
  /// @return Status code (0: success, non-zero: failure)
  /// ---
  Future<int> setLocalLiveMixInnerCdnVideoFps(RCRTCVideoFps fps) async {
    Map<String, dynamic> arguments = {'fps': fps.index};
    int code =
        await _channel.invokeMethod(
          'setLocalLiveMixInnerCdnVideoFps',
          arguments,
        ) ??
        -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 开始网络探测
  /// @param listener 网络探测回调
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Start network probing
  /// @param listener Callback for network probing
  /// @return Status code (0: success, non-zero: failure)
  /// ---
  Future<int> startNetworkProbe(RCRTCNetworkProbeListener listener) async {
    _networkProbeListener = listener;
    int code = await _channel.invokeMethod('startNetworkProbe') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止网络探测
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop network probing
  /// @return Status code (0: success, non-zero: failure)
  /// ---
  Future<int> stopNetworkProbe() async {
    int code = await _channel.invokeMethod('stopNetworkProbe') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 开始麦克风&扬声器检测
  /// @param timeInterval 麦克风录制时间
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Start mic & speaker test
  /// @param timeInterval Recording duration (ms)
  /// @return Status code: 0 means success, non-zero means failure
  /// ---
  Future<int> startEchoTest(int timeInterval) async {
    int code = await _channel.invokeMethod('startEchoTest', timeInterval) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 停止麦克风&扬声器检测，结束检测后必须手动调用停止方法
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Stop mic & speaker detection. Must call this manually after detection ends.
  /// @return status code (0: success, non-zero: failure)
  /// ---
  Future<int> stopEchoTest() async {
    int code = await _channel.invokeMethod('stopEchoTest') ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 设置水印
  /// @param bitmap 水印图片
  /// @param position  水印的位置,参数取值范围 0 ~ 1，
  /// @param zoom  图片缩放系数,参数取值范围 0 ~ 1
  /// SDK 内部会根据视频分辨率计算水印实际的像素位置和尺寸。
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Set watermark
  /// @param bitmap Watermark image
  /// @param position Watermark position (0-1)
  /// @param zoom Image scaling factor (0-1)
  /// SDK calculates actual pixel position/size based on video resolution
  /// @return Status code (0=success, non-zero=failure)
  /// ---
  Future<int> setWatermark(
    String imagePath,
    Point<double> position,
    double zoom,
  ) async {
    Map<String, dynamic> arguments = {
      'imagePath': imagePath,
      'position': {'x': position.x, 'y': position.y},
      'zoom': zoom,
    };
    int code = await _channel.invokeMethod('setWatermark', arguments) ?? -1;
    return code;
  }

  /// [ZH]
  /// ---
  /// 移除水印
  /// @return 接口调用状态码 0: 成功, 非0: 失败
  /// ---
  /// [EN]
  /// ---
  /// Remove watermark
  /// @return Status code: 0 means success, non-zero means failure
  /// ---
  Future<int> removeWatermark() async {
    int code = await _channel.invokeMethod('removeWatermark') ?? -1;
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
      case 'engine:onCameraEnabled':
        Map<dynamic, dynamic> arguments = call.arguments;
        bool enable = arguments['enable'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCameraEnabled?.call(enable, code, message);
        break;
      case 'engine:onCameraSwitched':
        Map<dynamic, dynamic> arguments = call.arguments;
        int camera = arguments['camera'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCameraSwitched?.call(RCRTCCamera.values[camera], code, message);
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
        onRemoteStateChanged?.call(
          rid,
          uid,
          RCRTCMediaType.values[type],
          disabled,
        );
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
        onRemoteCustomStreamPublished?.call(
          rid,
          uid,
          tag,
          RCRTCMediaType.values[type],
        );
        break;
      case 'engine:onRemoteCustomStreamUnpublished':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        onRemoteCustomStreamUnpublished?.call(
          rid,
          uid,
          tag,
          RCRTCMediaType.values[type],
        );
        break;
      case 'engine:onRemoteCustomStreamStateChanged':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        bool disabled = arguments['disabled'];
        onRemoteCustomStreamStateChanged?.call(
          rid,
          uid,
          tag,
          RCRTCMediaType.values[type],
          disabled,
        );
        break;
      case 'engine:onRemoteCustomStreamFirstFrame':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        onRemoteCustomStreamFirstFrame?.call(
          rid,
          uid,
          tag,
          RCRTCMediaType.values[type],
        );
        break;
      case 'engine:onCustomStreamSubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCustomStreamSubscribed?.call(
          id,
          tag,
          RCRTCMediaType.values[type],
          code,
          message,
        );
        break;
      case 'engine:onCustomStreamUnsubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        String id = arguments['id'];
        String tag = arguments['tag'];
        int type = arguments['type'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onCustomStreamUnsubscribed?.call(
          id,
          tag,
          RCRTCMediaType.values[type],
          code,
          message,
        );
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
        bool agree = arguments['agree'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onJoinSubRoomRequestResponded?.call(rid, uid, agree, code, message);
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
      case 'engine:onLiveRoleSwitched':
        Map<dynamic, dynamic> arguments = call.arguments;
        int role = arguments['role'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveRoleSwitched?.call(RCRTCRole.values[role], code, message);
        break;
      case 'engine:onRemoteLiveRoleSwitched':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        int role = arguments['role'];
        onRemoteLiveRoleSwitched?.call(rid, uid, RCRTCRole.values[role]);
        break;
      case 'engine:onSeiEnabled':
        Map<dynamic, dynamic> arguments = call.arguments;
        bool enable = arguments['enable'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onSeiEnabled?.call(enable, code, message);
        break;
      case 'engine:onSeiReceived':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String sei = arguments['sei'];
        onSeiReceived?.call(rid, uid, sei);
        break;
      case 'engine:onLiveMixSeiReceived':
        String sei = call.arguments;
        onLiveMixSeiReceived?.call(sei);
        break;
      case 'engine:onLiveMixInnerCdnStreamEnabled':
        Map<dynamic, dynamic> arguments = call.arguments;
        bool enable = arguments['enable'];
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixInnerCdnStreamEnabled?.call(enable, code, message);
        break;
      case 'engine:onLiveMixInnerCdnStreamSubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixInnerCdnStreamSubscribed?.call(code, message);
        break;
      case 'engine:onLiveMixInnerCdnStreamUnsubscribed':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLiveMixInnerCdnStreamUnsubscribed?.call(code, message);
        break;
      case 'engine:onRemoteLiveMixInnerCdnStreamPublished':
        onRemoteLiveMixInnerCdnStreamPublished?.call();
        break;
      case 'engine:onRemoteLiveMixInnerCdnStreamUnpublished':
        onRemoteLiveMixInnerCdnStreamUnpublished?.call();
        break;
      case 'engine:onLocalLiveMixInnerCdnVideoResolutionSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLocalLiveMixInnerCdnVideoResolutionSet?.call(code, message);
        break;
      case 'engine:onLocalLiveMixInnerCdnVideoFpsSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onLocalLiveMixInnerCdnVideoFpsSet?.call(code, message);
        break;
      case 'engine:onWatermarkSet':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onWatermarkSet?.call(code, message);
        break;
      case 'engine:onWatermarkRemoved':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onWatermarkRemoved?.call(code, message);
        break;
      case 'engine:onNetworkProbeStarted':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onNetworkProbeStarted?.call(code, message);
        break;
      case 'engine:onNetworkProbeStopped':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        onNetworkProbeStopped?.call(code, message);
        break;
      case 'stats:onNetworkStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onNetworkStats(RCRTCNetworkStats.fromJson(arguments));
        break;
      case 'stats:onLocalAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLocalAudioStats(
          RCRTCLocalAudioStats.fromJson(arguments),
        );
        break;
      case 'stats:onLocalVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLocalVideoStats(
          RCRTCLocalVideoStats.fromJson(arguments),
        );
        break;
      case 'stats:onRemoteAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteAudioStats(
          rid,
          uid,
          RCRTCRemoteAudioStats.fromJson(stats),
        );
        break;
      case 'stats:onRemoteVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteVideoStats(
          rid,
          uid,
          RCRTCRemoteVideoStats.fromJson(stats),
        );
        break;
      case 'stats:onLiveMixAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLiveMixAudioStats(
          RCRTCRemoteAudioStats.fromJson(arguments),
        );
        break;
      case 'stats:onLiveMixVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _statsListener?.onLiveMixVideoStats(
          RCRTCRemoteVideoStats.fromJson(arguments),
        );
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
        _statsListener?.onLocalCustomAudioStats(
          tag,
          RCRTCLocalAudioStats.fromJson(stats),
        );
        break;
      case 'stats:onLocalCustomVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String tag = arguments['tag'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onLocalCustomVideoStats(
          tag,
          RCRTCLocalVideoStats.fromJson(stats),
        );
        break;
      case 'stats:onRemoteCustomAudioStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteCustomAudioStats(
          rid,
          uid,
          tag,
          RCRTCRemoteAudioStats.fromJson(stats),
        );
        break;
      case 'stats:onRemoteCustomVideoStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        String rid = arguments['rid'];
        String uid = arguments['uid'];
        String tag = arguments['tag'];
        Map<dynamic, dynamic> stats = arguments['stats'];
        _statsListener?.onRemoteCustomVideoStats(
          rid,
          uid,
          tag,
          RCRTCRemoteVideoStats.fromJson(stats),
        );
        break;
      case 'stats:onNetworkProbeUpLinkStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _networkProbeListener?.onNetworkProbeUpLinkStats(
          RCRTCNetworkProbeStats.fromJson(arguments),
        );
        break;
      case 'stats:onNetworkProbeDownLinkStats':
        Map<dynamic, dynamic> arguments = call.arguments;
        _networkProbeListener?.onNetworkProbeDownLinkStats(
          RCRTCNetworkProbeStats.fromJson(arguments),
        );
        break;
      case 'stats:onNetworkProbeFinished':
        Map<dynamic, dynamic> arguments = call.arguments;
        int code = arguments['code'];
        String? message = arguments['message'];
        _networkProbeListener?.onNetworkProbeFinished(code, message);
        _networkProbeListener = null;
        break;
    }
  }

  static RCRTCEngine? _instance;

  final MethodChannel _channel;

  RCRTCStatsListener? _statsListener;

  RCRTCNetworkProbeListener? _networkProbeListener;

  /// [ZH]
  /// ---
  /// 引擎内部错误回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Engine internal error callback
  /// @param code   0: success, non-zero: failure
  /// @param errMsg failure reason
  /// ---
  Function(int code, String? errMsg)? onError;

  /// [ZH]
  /// ---
  /// 本地用户被踢出房间回调
  /// @param roomId 房间id
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback when local user gets kicked out
  /// @param roomId Room ID
  /// @param errMsg Reason for kickout
  /// ---
  Function(String? roomId, String? errMsg)? onKicked;

  /// [ZH]
  /// ---
  /// 本地用户加入房间回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Local user joined room callback
  /// @param code   0: success, non-zero: failure
  /// @param errMsg failure reason
  /// ---
  Function(int code, String? errMsg)? onRoomJoined;

  /// [ZH]
  /// ---
  /// 本地用户离开房间回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback when local user leaves room
  /// @param code   0: success, non-zero: failure
  /// @param errMsg failure reason
  /// ---
  Function(int code, String? errMsg)? onRoomLeft;

  /// [ZH]
  /// ---
  /// 本地用户发布资源回调
  /// @param type   资源类型
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for local user publishing resources
  /// @param type   Resource type
  /// @param code   0: success, non-zero: failure
  /// @param errMsg Failure reason
  /// ---
  Function(RCRTCMediaType type, int code, String? errMsg)? onPublished;

  /// [ZH]
  /// ---
  /// 本地用户取消发布资源回调
  /// @param type   资源类型
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback when local user unpublishes resources
  /// @param type   Resource type
  /// @param code   0: Success, non-zero: Failure
  /// @param errMsg Failure reason
  /// ---
  Function(RCRTCMediaType type, int code, String? errMsg)? onUnpublished;

  /// [ZH]
  /// ---
  /// 订阅远端用户发布的资源操作回调
  /// @param userId 远端用户UserId
  /// @param type   资源类型
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to remote user's resource operation callbacks
  /// @param userId Remote user ID
  /// @param type   Resource type
  /// @param code   0: Success, non-zero: Failure
  /// @param errMsg Failure reason
  /// ---
  Function(String userId, RCRTCMediaType type, int code, String? errMsg)?
  onSubscribed;

  /// [ZH]
  /// ---
  /// 取消订阅远端用户发布的资源操作回调
  /// @param userId 远端用户UserId
  /// @param type   资源类型
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe from remote user's resource callbacks
  /// @param userId Remote user ID
  /// @param type   Resource type
  /// @param code   0: Success, non-zero: Failure
  /// @param errMsg Error details
  /// ---
  Function(String userId, RCRTCMediaType type, int code, String? errMsg)?
  onUnsubscribed;

  /// [ZH]
  /// ---
  /// 订阅直播合流资源操作回调
  /// @param type   资源类型
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to live mixing resource callbacks
  /// @param type   Resource type
  /// @param code   0: success, non-zero: failure
  /// @param errMsg Failure reason
  /// ---
  Function(RCRTCMediaType type, int code, String? errMsg)? onLiveMixSubscribed;

  /// [ZH]
  /// ---
  /// 取消订阅直播合流资源操作回调
  /// @param type   资源类型
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe from live mixing resource callbacks
  /// @param type   Resource type
  /// @param code   0: success, non-zero: failure
  /// @param errMsg Failure reason
  /// ---
  Function(RCRTCMediaType type, int code, String? errMsg)?
  onLiveMixUnsubscribed;

  /// [ZH]
  /// ---
  /// 本地用户开关摄像头操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for local user's camera toggle
  /// @param code   0: success, non-zero: failure
  /// @param errMsg failure reason
  /// ---
  Function(bool enable, int code, String? errMsg)? onCameraEnabled;

  /// [ZH]
  /// ---
  /// 本地用户切换前后摄像头操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for local user's camera switch
  /// @param code   0: success, non-zero: failed
  /// @param errMsg Failure reason
  /// ---
  Function(RCRTCCamera camera, int code, String? errMsg)? onCameraSwitched;

  /// [ZH]
  /// ---
  /// 添加旁路推流URL操作回调
  /// @param url    CDN URL
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for adding relay push URL
  /// @param url    CDN URL
  /// @param code   0: Success, non-zero: Failure
  /// @param errMsg Error details
  /// ---
  Function(String url, int code, String? errMsg)? onLiveCdnAdded;

  /// [ZH]
  /// ---
  /// 删除旁路推流URL操作回调
  /// @param url    CDN URL
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for removing relay push URL
  /// @param url    CDN URL
  /// @param code   0: Success, non-zero: Failure
  /// @param errMsg Error details
  /// ---
  Function(String url, int code, String? errMsg)? onLiveCdnRemoved;

  /// [ZH]
  /// ---
  /// 设置合流布局类型操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Set layout merge callback
  /// @param code   0: success, non-zero: failure
  /// @param errMsg failure reason
  /// ---
  Function(int code, String? errMsg)? onLiveMixLayoutModeSet;

  /// [ZH]
  /// ---
  /// 设置合流布局填充类型操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for setting mixed-stream layout fill type
  /// @param code   0: success, non-zero: failure
  /// @param errMsg failure reason
  /// ---
  Function(int code, String? errMsg)? onLiveMixRenderModeSet;

  /// [ZH]
  /// ---
  /// 设置合流布局背景颜色操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for setting mixed stream layout background color
  /// @param code   0: success, non-zero: failure
  /// @param errMsg failure reason
  /// ---
  Function(int code, String? errMsg)? onLiveMixBackgroundColorSet;

  /// [ZH]
  /// ---
  /// 设置合流自定义布局操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Set custom layout callback for stream mixing
  /// @param code   0: Success, non-zero: Failure
  /// @param errMsg Error details
  /// ---
  Function(int code, String? errMsg)? onLiveMixCustomLayoutsSet;

  /// [ZH]
  /// ---
  /// 设置需要合流音频操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Set audio mixing callback
  /// @param code   0: Success, non-zero: Failure
  /// @param errMsg Error details
  /// ---
  Function(int code, String? errMsg)? onLiveMixCustomAudiosSet;

  /// [ZH]
  /// ---
  /// 设置合流音频码率操作回调
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for setting audio mixing bitrate
  /// @param code   0: success, non-zero: failed
  /// @param errMsg failure reason
  /// ---
  Function(int code, String? errMsg)? onLiveMixAudioBitrateSet;

  /// [ZH]
  /// ---
  /// 设置默认视频合流码率操作回调
  /// @param tiny   是否小流
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Set default video merge bitrate callback
  /// @param tiny   Small stream flag
  /// @param code   0: success, non-zero: failure
  /// @param errMsg Failure reason
  /// ---
  Function(bool tiny, int code, String? errMsg)? onLiveMixVideoBitrateSet;

  /// [ZH]
  /// ---
  /// 设置合流视频分辨率操作回调
  /// @param tiny   是否小流
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Callback for setting combined video resolution
  /// @param tiny   Whether it's a substream
  /// @param code   0: success, non-zero: failure
  /// @param errMsg Error details
  /// ---
  Function(bool tiny, int code, String? errMsg)? onLiveMixVideoResolutionSet;

  /// [ZH]
  /// ---
  /// 设置直播合流视频帧率操作回调
  /// @param tiny   是否小流
  /// @param code   0: 调用成功, 非0: 失败
  /// @param errMsg 失败原因
  /// ---
  /// [EN]
  /// ---
  /// Set live stream mixing frame rate callback
  /// @param tiny   Whether it's a minor stream
  /// @param code   0: success, non-zero: failure
  /// @param errMsg Failure reason
  /// ---
  Function(bool tiny, int code, String? errMsg)? onLiveMixVideoFpsSet;

  /// [ZH]
  /// ---
  /// 创建音效操作回调
  /// @param effectId 自定义全局唯一音效Id
  /// @param code     0: 调用成功, 非0: 失败
  /// @param errMsg   失败原因
  /// ---
  /// [EN]
  /// ---
  /// Create sound effect callback
  /// @param effectId Globally unique sound effect ID
  /// @param code     0: success, non-zero: failure
  /// @param errMsg   Error description
  /// ---
  Function(int effectId, int code, String? errMsg)? onAudioEffectCreated;

  /// [ZH]
  /// ---
  /// 音效播放结束或主动调用 {@link cn.rongcloud.rtc.wrapper.RCRTCIWEngine#stopAudioEffect(int)} 或 {@link RCRTCIWEngine#stopAllAudioEffects()}  方法后会回调该方法
  /// @param effectId 自定义全局唯一音效Id
  /// ---
  /// [EN]
  /// ---
  /// Triggers when audio effect finishes or after calling {@link cn.rongcloud.rtc.wrapper.RCRTCIWEngine#stopAudioEffect(int)} or {@link RCRTCIWEngine#stopAllAudioEffects()}
  /// @param effectId Unique global audio effect ID
  /// ---
  Function(int effectId)? onAudioEffectFinished;

  /// [ZH]
  /// ---
  /// 开始混音，或是暂停后继续播放
  /// ---
  /// [EN]
  /// ---
  /// Start mixing or resume playback
  /// ---
  Function()? onAudioMixingStarted;

  /// [ZH]
  /// ---
  /// enabled
  /// 混音文件暂停播放
  /// ---
  /// [EN]
  /// ---
  /// enabled
  /// Pause audio mixing
  /// ---
  Function()? onAudioMixingPaused;

  /// [ZH]
  /// ---
  /// 混音文件停止播放
  /// ---
  /// [EN]
  /// ---
  /// Stop audio mixing playback
  /// ---
  Function()? onAudioMixingStopped;

  /// [ZH]
  /// ---
  /// 混音播放结束
  /// ---
  /// [EN]
  /// ---
  /// Mix playback finished
  /// ---
  Function()? onAudioMixingFinished;

  /// [ZH]
  /// ---
  /// 远端用户加入房间操作回调
  /// @param roomId 房间id
  /// @param userId 用户id
  /// ---
  /// [EN]
  /// ---
  /// Callback when a remote user joins the room
  /// @param roomId Room ID
  /// @param userId User ID
  /// ---
  Function(String roomId, String userId)? onUserJoined;

  /// [ZH]
  /// ---
  /// 远端用户因离线离开房间操作回调
  /// @param roomId 房间id
  /// @param userId 用户id
  /// ---
  /// [EN]
  /// ---
  /// Callback when remote user leaves room due to offline status
  /// @param roomId Room ID
  /// @param userId User ID
  /// ---
  Function(String roomId, String userId)? onUserOffline;

  /// [ZH]
  /// ---
  /// 远端用户离开房间操作回调
  /// @param roomId 房间id
  /// @param userId 用户id
  /// ---
  /// [EN]
  /// ---
  /// Callback when remote user leaves room
  /// @param roomId Room ID
  /// @param userId User ID
  /// ---
  Function(String roomId, String userId)? onUserLeft;

  /// [ZH]
  /// ---
  /// 远端用户发布资源操作回调
  /// @param roomId 房间id
  /// @param userId 用户id
  /// @param type   资源类型
  /// ---
  /// [EN]
  /// ---
  /// Callback for remote user's resource publishing
  /// @param roomId Room ID
  /// @param userId User ID
  /// @param type   Resource type
  /// ---
  Function(String roomId, String userId, RCRTCMediaType type)?
  onRemotePublished;

  /// [ZH]
  /// ---
  /// 远端用户取消发布资源操作回调
  /// @param roomId 房间id
  /// @param userId 远端用户 UserId
  /// @param type   资源类型
  /// ---
  /// [EN]
  /// ---
  /// Callback when remote user unpublishes resources
  /// @param roomId Room ID
  /// @param userId Remote user ID
  /// @param type   Resource type
  /// ---
  Function(String roomId, String userId, RCRTCMediaType type)?
  onRemoteUnpublished;

  /// [ZH]
  /// ---
  /// 直播合流资源发布回调
  /// @param type 资源类型
  /// ---
  /// [EN]
  /// ---
  /// Callback for live stream mixing resource publishing
  /// @param type Resource type
  /// ---
  Function(RCRTCMediaType type)? onRemoteLiveMixPublished;

  /// [ZH]
  /// ---
  /// 直播合流资源取消发布回调
  /// @param type 资源类型
  /// ---
  /// [EN]
  /// ---
  /// Callback when unpublishing live mixing resources
  /// @param type Resource type
  /// ---
  Function(RCRTCMediaType type)? onRemoteLiveMixUnpublished;

  /// [ZH]
  /// ---
  /// 远端用户资源状态操作回调
  /// @param roomId   房间id
  /// @param userId   远端用户UserId
  /// @param type     资源类型
  /// @param disabled 是否停止相应资源采集
  /// ---
  /// [EN]
  /// ---
  /// Callback for remote user resource operations
  /// @param roomId Room ID
  /// @param userId Remote user ID
  /// @param type Resource type
  /// @param disabled Whether to stop collecting this resource
  /// ---
  Function(String roomId, String userId, RCRTCMediaType type, bool disabled)?
  onRemoteStateChanged;

  /// [ZH]
  /// ---
  /// 收到远端用户第一帧数据
  /// @param roomId 房间id
  /// @param userId 远端用户UserId
  /// @param type   资源类型
  /// ---
  /// [EN]
  /// ---
  /// First remote video frame received
  /// @param roomId Room ID
  /// @param userId Remote user ID
  /// @param type   Resource type
  /// ---
  Function(String roomId, String userId, RCRTCMediaType type)?
  onRemoteFirstFrame;

  /// [ZH]
  /// ---
  /// 收到直播合流第一帧数据
  /// @param type 资源类型
  /// ---
  /// [EN]
  /// ---
  /// First frame of live stream mix received
  /// @param type Resource type
  /// ---
  Function(RCRTCMediaType type)? onRemoteLiveMixFirstFrame;

  // Function(String roomId, Message message)? onMessageReceived;

  /// [ZH]
  /// ---
  /// 本地用户发布自定义资源回调
  /// @param tag    自定义流标签
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Callback for local user publishing custom streams
  /// @param tag    Custom stream tag
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(String tag, int code, String? errMsg)? onCustomStreamPublished;

  /// [ZH]
  /// ---
  /// 本地用户发布自定义资源完毕
  /// @param tag 自定义流标签
  /// ---
  /// [EN]
  /// ---
  /// Custom resource published
  /// @param tag Custom stream tag
  /// ---
  Function(String tag)? onCustomStreamPublishFinished;

  /// [ZH]
  /// ---
  /// 本地用户取消发布自定义资源回调
  /// @param tag    自定义流标签
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Callback when local user unpublishes custom resource
  /// @param tag    Stream tag
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(String tag, int code, String? errMsg)? onCustomStreamUnpublished;

  /// [ZH]
  /// ---
  /// 远端用户发布自定义资源操作回调
  /// @param roomId 房间id
  /// @param userId 用户id
  /// @param tag    自定义流标签
  /// ---
  /// [EN]
  /// ---
  /// Callback for remote user's custom resource operation
  /// @param roomId Room ID
  /// @param userId User ID
  /// @param tag    Custom stream tag
  /// ---
  Function(String roomId, String userId, String tag, RCRTCMediaType type)?
  onRemoteCustomStreamPublished;

  /// [ZH]
  /// ---
  /// 远端用户取消发布自定义资源操作回调
  /// @param roomId 房间id
  /// @param userId 用户id
  /// @param tag    自定义流标签
  /// ---
  /// [EN]
  /// ---
  /// Callback when remote user unpublishes custom resource
  /// @param roomId Room ID
  /// @param userId User ID
  /// @param tag    Custom stream tag
  /// ---
  Function(String roomId, String userId, String tag, RCRTCMediaType type)?
  onRemoteCustomStreamUnpublished;

  /// [ZH]
  /// ---
  /// 远端用户自定义资源状态操作回调
  /// @param roomId   房间id
  /// @param userId   用户id
  /// @param tag      自定义流标签
  /// @param disabled 是否禁用
  /// ---
  /// [EN]
  /// ---
  /// Callback for remote user's custom resource status
  /// @param roomId   Room ID
  /// @param userId   User ID
  /// @param tag      Custom stream tag
  /// @param disabled Disable status
  /// ---
  Function(
    String roomId,
    String userId,
    String tag,
    RCRTCMediaType type,
    bool disabled,
  )?
  onRemoteCustomStreamStateChanged;

  /// [ZH]
  /// ---
  /// 收到远端用户自定义资源第一帧数据
  /// @param roomId 房间id
  /// @param userId 用户id
  /// @param tag    自定义流标签
  /// ---
  /// [EN]
  /// ---
  /// First frame of remote custom resource received
  /// @param roomId Room ID
  /// @param userId User ID
  /// @param tag    Custom stream tag
  /// ---
  Function(String roomId, String userId, String tag, RCRTCMediaType type)?
  onRemoteCustomStreamFirstFrame;

  /// [ZH]
  /// ---
  /// 订阅远端用户发布的自定义资源操作回调
  /// @param userId 用户id
  /// @param tag    自定义流标签
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to custom resource callbacks from remote users
  /// @param userId User ID
  /// @param tag    Custom stream tag
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(
    String userId,
    String tag,
    RCRTCMediaType type,
    int code,
    String? errMsg,
  )?
  onCustomStreamSubscribed;

  /// [ZH]
  /// ---
  /// 取消订阅远端用户发布的自定义资源操作回调
  /// @param userId 用户id
  /// @param tag    自定义流标签
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe from custom resource callbacks
  /// @param userId Remote user ID
  /// @param tag Custom stream tag
  /// @param code Error code
  /// @param errMsg Error message
  /// ---
  Function(
    String userId,
    String tag,
    RCRTCMediaType type,
    int code,
    String? errMsg,
  )?
  onCustomStreamUnsubscribed;

  /// [ZH]
  /// ---
  /// 请求加入子房间回调
  /// @param roomId 目标房间id
  /// @param userId 目标主播id
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Callback for joining sub-room request
  /// @param roomId Target room ID
  /// @param userId Target host ID
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(String roomId, String userId, int code, String? errMsg)?
  onJoinSubRoomRequested;

  /// [ZH]
  /// ---
  /// 取消请求加入子房间回调
  /// @param roomId 目标房间id
  /// @param userId 目标主播id
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Cancel join-subroom request callback
  /// @param roomId Target room ID
  /// @param userId Target host ID
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(String roomId, String userId, int code, String? errMsg)?
  onJoinSubRoomRequestCanceled;

  /// [ZH]
  /// ---
  /// 响应请求加入子房间回调
  /// @param roomId 目标房间id
  /// @param userId 目标主播id
  /// @param agree  是否同意
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Handle join-subroom request callback
  /// @param roomId Target room ID
  /// @param userId Host user ID
  /// @param agree  Approval status
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(String roomId, String userId, bool agree, int code, String? errMsg)?
  onJoinSubRoomRequestResponded;

  /// [ZH]
  /// ---
  /// 加入子房间回调
  /// @param roomId 子房间id
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Callback for joining sub-room
  /// @param roomId Sub-room ID
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(String roomId, int code, String? errMsg)? onSubRoomJoined;

  /// [ZH]
  /// ---
  /// 离开子房间回调
  /// @param roomId 子房间id
  /// @param code   错误码
  /// @param errMsg 错误信息
  /// ---
  /// [EN]
  /// ---
  /// Callback when leaving a subroom
  /// @param roomId Subroom ID
  /// @param code   Error code
  /// @param errMsg Error message
  /// ---
  Function(String roomId, int code, String? errMsg)? onSubRoomLeft;

  /// [ZH]
  /// ---
  /// 收到加入请求回调
  /// @param roomId 请求来源房间id
  /// @param userId 请求来源主播id
  /// @param extra  Extended Information
  /// ---
  /// [EN]
  /// ---
  /// Callback for join request
  /// @param roomId ID of the requesting room
  /// @param userId ID of the requesting host
  /// @param extra Extended info
  /// ---
  Function(String roomId, String userId, String? extra)?
  onJoinSubRoomRequestReceived;

  /// [ZH]
  /// ---
  /// 收到取消加入请求回调
  /// @param roomId 请求来源房间id
  /// @param userId 请求来源主播id
  /// @param extra  Extended Information
  /// ---
  /// [EN]
  /// ---
  /// Callback for cancel join request
  /// @param roomId Source room ID
  /// @param userId Host user ID
  /// @param extra Extended info
  /// ---
  Function(String roomId, String userId, String? extra)?
  onCancelJoinSubRoomRequestReceived;

  /// [ZH]
  /// ---
  /// 收到加入请求响应回调
  /// @param roomId 响应来源房间id
  /// @param userId 响应来源主播id
  /// @param agree  是否同意
  /// @param extra  Extended Information
  /// ---
  /// [EN]
  /// ---
  /// Callback for join request response
  /// @param roomId Source room ID
  /// @param userId Host user ID
  /// @param agree  Approval status
  /// @param extra  Extended info
  /// ---
  Function(String roomId, String userId, bool agree, String? extra)?
  onJoinSubRoomRequestResponseReceived;

  /// [ZH]
  /// ---
  /// 连麦中的子房间回调
  /// @param roomId 子房间id
  /// ---
  /// [EN]
  /// ---
  /// Callback for sub-room in live streaming
  /// @param roomId Sub-room ID
  /// ---
  Function(String roomId)? onSubRoomBanded;

  /// [ZH]
  /// ---
  /// 子房间结束连麦回调
  /// @param roomId 子房间id
  /// @param userId 结束连麦的用户id
  /// ---
  /// [EN]
  /// ---
  /// Callback when co-streaming ends in a sub-room
  /// @param roomId Sub-room ID
  /// @param userId User ID ending co-streaming
  /// ---
  Function(String roomId, String userId)? onSubRoomDisband;

  /// [ZH]
  /// ---
  /// 切换直播角色回调
  /// @param current   当前角色
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Live role switch callback
  /// @param current   Current role
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(RCRTCRole role, int code, String? errMsg)? onLiveRoleSwitched;

  /// [ZH]
  /// ---
  /// 远端用户身份切换回调
  /// @param roomId    房间号
  /// @param userId    用户id
  /// @param role      用户角色
  /// ---
  /// [EN]
  /// ---
  /// Remote user role change callback
  /// @param roomId    Room ID
  /// @param userId    User ID
  /// @param role      User role
  /// ---
  Function(String roomId, String userId, RCRTCRole role)?
  onRemoteLiveRoleSwitched;

  /// [ZH]
  /// ---
  /// 开启 SEI 功能结果回调
  /// @param enable 是否开启
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Callback for SEI feature toggle result
  /// @param enable Whether to enable
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(bool enable, int code, String? errMsg)? onSeiEnabled;

  /// [ZH]
  /// ---
  /// 收到 SEI 信息回调
  /// @param roomId 房间 id
  /// @param userId 远端用户 id
  /// @param sei SEI 信息
  /// ---
  /// [EN]
  /// ---
  /// Callback for received SEI message
  /// @param roomId Room ID
  /// @param userId Remote user ID
  /// @param sei SEI message
  /// ---
  Function(String roomId, String userId, String sei)? onSeiReceived;

  /// [ZH]
  /// ---
  /// 观众收到合流 SEI 信息回调
  /// @param sei SEI 信息
  /// ---
  /// [EN]
  /// ---
  /// Callback when audience receives merged SEI message
  /// @param sei SEI message
  /// ---
  Function(String sei)? onLiveMixSeiReceived;

  /// [ZH]
  /// ---
  /// 开启直播内置 cdn 结果回调
  /// @param enable    是否开启
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Callback for enabling built-in CDN in live streaming
  /// @param enable    Enable or not
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(bool enable, int code, String? errMsg)?
  onLiveMixInnerCdnStreamEnabled;

  /// [ZH]
  /// ---
  /// 订阅直播内置 cdn 资源回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Subscribe to built-in CDN callbacks for live streaming
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onLiveMixInnerCdnStreamSubscribed;

  /// [ZH]
  /// ---
  /// 取消订阅直播内置 cdn 资源回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Unsubscribe from built-in CDN resource callbacks
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onLiveMixInnerCdnStreamUnsubscribed;

  /// [ZH]
  /// ---
  /// 直播内置 cdn 资源发布回调
  /// ---
  /// [EN]
  /// ---
  /// Live streaming built-in CDN resource publish callback
  /// ---
  Function()? onRemoteLiveMixInnerCdnStreamPublished;

  /// [ZH]
  /// ---
  /// 直播内置 cdn 资源取消发布回调
  /// ---
  /// [EN]
  /// ---
  /// Callback for unpublishing built-in live CDN resources
  /// ---
  Function()? onRemoteLiveMixInnerCdnStreamUnpublished;

  /// [ZH]
  /// ---
  /// 观众端设置订阅 cdn 流的分辨率的回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Callback for setting CDN stream resolution on viewer side
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onLocalLiveMixInnerCdnVideoResolutionSet;

  /// [ZH]
  /// ---
  /// 观众端 设置订阅 cdn 流的帧率的回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Callback for setting subscribed CDN stream frame rate (audience side)
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onLocalLiveMixInnerCdnVideoFpsSet;

  /// [ZH]
  /// ---
  /// 设置水印的回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Set watermark callback
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onWatermarkSet;

  /// [ZH]
  /// ---
  /// 移除水印的回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Watermark removal callback
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onWatermarkRemoved;

  /// [ZH]
  /// ---
  /// 开启网络探测结果回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Enable network probe callback
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onNetworkProbeStarted;

  /// [ZH]
  /// ---
  /// 关闭网络探测结果回调
  /// @param code      错误码
  /// @param errMsg    错误消息
  /// ---
  /// [EN]
  /// ---
  /// Disable network probe callback
  /// @param code      Error code
  /// @param errMsg    Error message
  /// ---
  Function(int code, String? errMsg)? onNetworkProbeStopped;
}
