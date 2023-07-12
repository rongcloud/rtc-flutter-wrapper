import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/constants.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/presenter.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';

abstract class RCView implements IView {
  void onConnected();

  void onConnectError(int code, String? message);
}

abstract class Model implements IModel {
  void subscribe(
    RCRTCMediaType type,
    bool tiny,
    Callback success,
    StateCallback error,
  );

  Future<bool> mute(RCRTCMediaType type, bool mute);

  Future<bool> changeSpeaker(bool enable);

  Future<int> exit();

  void subscribeInnerCDN(Callback success, StateCallback error,);

  Future<int> setLocalLiveMixInnerCdnVideoResolution(RCRTCVideoResolution resolution);

  Future<int> setLocalLiveMixInnerCdnVideoFps(RCRTCVideoFps fps);
}

abstract class Presenter implements IPresenter {
  void subscribe(
    RCRTCMediaType type,
    bool tiny,
  );

  Future<bool> mute(RCRTCMediaType type, bool mute);

  Future<bool> changeSpeaker(bool enable);

  Future<int> exit();

  void subscribeInnerCDN();

  Future<int> setLocalLiveMixInnerCdnVideoResolution(RCRTCVideoResolution resolution);

  Future<int> setLocalLiveMixInnerCdnVideoFps(RCRTCVideoFps fps);
}
