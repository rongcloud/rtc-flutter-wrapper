import 'dart:async';

import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/constants.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';

import 'audience_page_contract.dart';

class AudiencePageModel extends AbstractModel implements Model {
  @override
  void subscribe(
    RCRTCMediaType type,
    bool tiny,
    Callback success,
    StateCallback error,
  ) async {
    _unsubscribe(() async {
      Utils.engine?.onLiveMixSubscribed = (type2, code2, message2) {
        if (code2 != 0)
          error(code2, 'Subscribe error $code2.');
        else
          success('Subscribe success.');
      };
      int code = await Utils.engine?.subscribeLiveMix(type, tiny) ?? -1;
      if (code != 0) error(code, 'Subscribe error $code.');
    });
  }

  Future<void> _unsubscribe(Function() next) async {
    Utils.engine?.onLiveMixUnsubscribed = (type, code, message) async {
      next.call();
    };
    int code = await Utils.engine?.unsubscribeLiveMix(RCRTCMediaType.audio_video) ?? -1;
    if (code != 0) {
      next.call();
    }
  }

  @override
  Future<bool> changeSpeaker(bool enable) async {
    return enable;
  }

  @override
  Future<int> exit() async {
    Completer<int> completer = Completer();
    Utils.engine?.onRoomLeft = (int code, String? message) async {
      await Utils.engine?.destroy();
      Utils.engine = null;
      completer.complete(code);
    };
    int code = await Utils.engine?.leaveRoom() ?? -1;
    if (code != 0) {
      await Utils.engine?.destroy();
      Utils.engine = null;
      return code;
    }
    return completer.future;
  }
}
