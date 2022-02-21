import 'dart:async';

import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/constants.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/network/network.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/global_config.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';

import 'connect_page_contract.dart';

class ConnectPageModel extends AbstractModel implements Model {
  @override
  void clear() {
    DefaultData.clear();
  }

  @override
  void load() {
    DefaultData.loadUsers();
  }

  @override
  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
    StateCallback callback,
  ) {
    if (key.isEmpty) key = GlobalConfig.appKey;
    if (navigate.isEmpty) navigate = GlobalConfig.navServer;
    if (file.isEmpty) file = GlobalConfig.fileServer;
    if (media.isEmpty) media = GlobalConfig.mediaServer;

    RongIMClient.setServerInfo(navigate, file);
    RongIMClient.init(key);

    if (media.isNotEmpty) {
      _media = media;
    }

    RongIMClient.connect(token, (code, id) {
      if (code == RCErrorCode.Success) {
        User user = User.create(
          id!,
          key,
          navigate,
          file,
          media,
          token,
        );
        DefaultData.user = user;
      }
      callback(code, id);
    });
  }

  @override
  void disconnect() {
    RongIMClient.disconnect(false);
  }

  @override
  void action(
    String id,
    RCRTCMediaType type,
    RCRTCRole role,
    bool tiny,
    bool yuv,
    bool srtp,
    StateCallback callback,
  ) async {
    RCRTCVideoSetup videoSetup = RCRTCVideoSetup.create(
      enableTinyStream: tiny,
      enableTexture: !yuv,
    );
    RCRTCEngineSetup engineSetup = RCRTCEngineSetup.create(
      enableSRTP: srtp,
      mediaUrl: _media,
      videoSetup: videoSetup,
    );
    Utils.engine = await RCRTCEngine.create(engineSetup);

    RCRTCRoomSetup setup = RCRTCRoomSetup.create(type: type, role: role);
    Utils.engine?.onRoomJoined = (int code, String? message) {
      Utils.engine?.onRoomJoined = null;
      callback(code, code == 0 ? id : '$message');
    };
    int ret = await Utils.engine?.joinRoom(id, setup) ?? -1;
    if (ret != 0) {
      Utils.engine?.onRoomJoined = null;
      callback(ret, 'Join room error $ret');
    }
  }

  String? _media;
}
