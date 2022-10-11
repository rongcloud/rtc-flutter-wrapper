import 'dart:math';

import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/presenter.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';

abstract class View implements IView {
  void onUserListChanged();

  void onUserAudioStateChanged(String id, bool published);

  void onUserVideoStateChanged(String id, bool published);

  void onCustomVideoPublished();

  void onCustomVideoPublishedError(int code);

  void onCustomVideoUnpublished();

  void onCustomVideoUnpublishedError(int code);

  void onUserCustomStateChanged(String id, String tag, bool audio, bool video);

  void onReceiveJoinRequest(String roomId, String userId);

  void onReceiveJoinResponse(String roomId, String userId, bool agree);

  void onExit();

  void onExitWithError(int code);
}

abstract class Model implements IModel {
  Future<bool> changeMic(bool open);

  Future<bool> changeCamera(bool open);

  Future<int> changeAudio(bool publish);

  Future<int> changeVideo(bool publish);

  Future<bool> changeFrontCamera(bool front);

  Future<bool> changeSpeaker(bool speaker);

  Future<bool> changeVideoConfig(RCRTCVideoConfig config);

  Future<bool> changeTinyVideoConfig(RCRTCVideoConfig config);

  Future<bool> switchToNormalStream(String id);

  Future<bool> switchToTinyStream(String id);

  Future<bool> changeRemoteAudioStatus(String id, bool subscribe);

  Future<bool> changeRemoteVideoStatus(String id, bool subscribe);

  Future<int> publishCustomVideo(String id, String path, RCRTCVideoConfig config, bool yuv);

  Future<int> unpublishCustomVideo();

  Future<bool> changeCustomConfig(RCRTCVideoConfig config);

  Future<bool> changeRemoteCustomVideoStatus(String rid, String uid, String tag, bool yuv, bool subscribe);

  Future<bool> changeRemoteCustomAudioStatus(String rid, String uid, String tag, bool subscribe);

  Future<int> responseJoinSubRoom(String rid, String uid, bool agree);

  Future<int> exit();

  Future<int> enableInnerCDN(bool enable);

}

abstract class Presenter implements IPresenter {
  Future<bool> changeMic(bool open);

  Future<bool> changeCamera(bool open);

  Future<int> changeAudio(bool publish);

  Future<int> changeVideo(bool publish);

  Future<bool> changeFrontCamera(bool front);

  Future<bool> changeSpeaker(bool speaker);

  Future<bool> changeVideoConfig(RCRTCVideoConfig config);

  Future<bool> changeTinyVideoConfig(RCRTCVideoConfig config);

  Future<bool> switchToNormalStream(String id);

  Future<bool> switchToTinyStream(String id);

  Future<bool> changeRemoteAudioStatus(String id, bool subscribe);

  Future<bool> changeRemoteVideoStatus(String id, bool subscribe);

  void publishCustomVideo(String id, String path, RCRTCVideoConfig config, bool yuv);

  void unpublishCustomVideo();

  Future<bool> changeCustomConfig(RCRTCVideoConfig config);

  Future<bool> changeRemoteCustomVideoStatus(String rid, String uid, String tag, bool yuv, bool subscribe);

  Future<bool> changeRemoteCustomAudioStatus(String rid, String uid, String tag, bool subscribe);

  Future<int> responseJoinSubRoom(String rid, String uid, bool agree);

  void exit();

  Future<int> enableInnerCDN(bool enable);

}
