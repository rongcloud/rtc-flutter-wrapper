import 'package:flutter/widgets.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/presenter.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';

import 'meeting_page_contract.dart';
import 'meeting_page_model.dart';

class MeetingPagePresenter extends AbstractPresenter<View, Model> implements Presenter {
  @override
  IModel createModel() {
    return MeetingPageModel();
  }

  @override
  Future<void> init(BuildContext context) async {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Config config = Config.fromJson(arguments['config']);

    await changeVideoConfig(config.videoConfig);
    await changeMic(config.mic);
    await changeSpeaker(config.speaker);
    await changeTinyVideoConfig(RCRTCVideoConfig.create(
      minBitrate: 100,
      maxBitrate: 500,
      fps: RCRTCVideoFps.fps_15,
      resolution: RCRTCVideoResolution.resolution_180_320,
    ));

    view.onUserListChanged();

    Utils.users.forEach((user) {
      view.onUserAudioStateChanged(user.id, user.audioPublished);
      view.onUserVideoStateChanged(user.id, user.videoPublished);
    });

    Utils.onUserListChanged = () {
      view.onUserListChanged();
    };

    Utils.onUserAudioStateChanged = (id, published) {
      view.onUserAudioStateChanged(id, published);
    };

    Utils.onUserVideoStateChanged = (id, published) {
      view.onUserVideoStateChanged(id, published);
    };
  }

  @override
  Future<bool> changeMic(bool open) {
    return model.changeMic(open);
  }

  @override
  Future<bool> changeCamera(bool open) {
    return model.changeCamera(open);
  }

  @override
  Future<int> changeAudio(bool publish) {
    return model.changeAudio(publish);
  }

  @override
  Future<int> changeVideo(bool publish) {
    return model.changeVideo(publish);
  }

  @override
  Future<bool> changeFrontCamera(bool front) {
    return model.changeFrontCamera(front);
  }

  @override
  Future<bool> changeSpeaker(bool open) {
    return model.changeSpeaker(open);
  }

  @override
  Future<bool> changeVideoConfig(RCRTCVideoConfig config) {
    return model.changeVideoConfig(config);
  }

  @override
  Future<bool> changeTinyVideoConfig(RCRTCVideoConfig config) {
    return model.changeTinyVideoConfig(config);
  }

  @override
  Future<bool> changeRemoteAudioStatus(String id, bool subscribe) {
    return model.changeRemoteAudioStatus(id, subscribe);
  }

  @override
  Future<bool> changeRemoteVideoStatus(String id, bool subscribe, bool tiny) {
    return model.changeRemoteVideoStatus(id, subscribe, tiny);
  }

  @override
  void exit() async {
    int code = await model.exit();
    if (code != 0)
      view.onExitWithError(code);
    else
      view.onExit();
  }
}
