import 'dart:async';

// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';
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
  Future<Result> token(String key) {
    if (key.isEmpty) key = GlobalConfig.appKey;
    int current = DateTime.now().millisecondsSinceEpoch;
    String id = '${GlobalConfig.prefix}$current';
    // String id = 'SameUser';
    Completer<Result> completer = Completer();
    Http.post(
      GlobalConfig.host + '/token/$id',
      {'key': key},
      (error, data) {
        String? token = data['token'];
        completer.complete(Result(0, token));
      },
      (error) {
        completer.complete(Result(-1, 'Get token error.'));
      },
      tag,
    );
    return completer.future;
  }

  @override
  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
    StateCallback callback,
  ) async {
    if (key.isEmpty) key = GlobalConfig.appKey;
    if (navigate.isEmpty) navigate = GlobalConfig.navServer;
    if (file.isEmpty) file = GlobalConfig.fileServer;
    if (media.isEmpty) media = GlobalConfig.mediaServer;

    RCIMIWEngineOptions options = RCIMIWEngineOptions.create();
    options.naviServer = navigate;
    options.fileServer = file;

    Utils.imEngine = await RCIMIWEngine.create(key, options);

    if (media.isNotEmpty) {
      _media = media;
    }

    Utils.imEngine?.onConnected = (int? code, String? userId,) {
      if (code == 0) {
        User user = User.create(
          userId!,
          key,
          navigate,
          file,
          media,
          token,
        );
        DefaultData.user = user;
      }
      callback(code, userId);
    };
    await Utils.imEngine?.connect(token, 10);
  }

  @override
  void disconnect() {
    Utils.imEngine?.disconnect(false);
    Utils.imEngine?.destroy();
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

    // RCRTCAudioConfig audioConfig = RCRTCAudioConfig.create(
    //     scenario: RCRTCAudioScenario.music_chatroom
    // );
    // await Utils.engine?.setAudioConfig(audioConfig);

    // ------
    await _enableCamera(true);

    await _enableCamera(false);
    // ------


    RCRTCRoomSetup setup = RCRTCRoomSetup.create(mediaType: type, role: role);
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

  _enableCamera(bool enable) async {
    Completer<int> completer = new Completer();
    Utils.engine?.onCameraEnabled = (bool enable, int code, String? errMsg) {
      print('enable = $enable');
      completer.complete(code);
    };
    int code = await Utils.engine?.enableCamera(enable) ?? -1;
    if (code != 0) {
      return code;
    }
    return completer.future;
  }


  String? _media;
}
