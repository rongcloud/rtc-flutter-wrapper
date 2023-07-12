import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/presenter.dart';
import 'package:flutter/widgets.dart';

import 'audience_page_contract.dart';
import 'audience_page_model.dart';

class AudiencePagePresenter extends AbstractPresenter<RCView, Model> implements Presenter {
  @override
  IModel createModel() {
    return AudiencePageModel();
  }

  @override
  Future<void> init(BuildContext context) async {
    await changeSpeaker(false);
  }

  @override
  void subscribe(
    RCRTCMediaType type,
    bool tiny,
  ) {
    model.subscribe(
      type,
      tiny,
      (_) {
        view.onConnected();
      },
      (code, info) {
        view.onConnectError(code, info);
      },
    );
  }

  @override
  Future<bool> mute(RCRTCMediaType type, bool mute) {
    return model.mute(type, mute);
  }

  @override
  Future<bool> changeSpeaker(bool enable) {
    return model.changeSpeaker(enable);
  }

  @override
  Future<int> exit() {
    return model.exit();
  }

  @override
  void subscribeInnerCDN() {
    model.subscribeInnerCDN((info) {
      view.onConnected();
    }, (code, info) {
      view.onConnectError(code, info);
    });
  }

  @override
  Future<int> setLocalLiveMixInnerCdnVideoResolution(RCRTCVideoResolution resolution) {
    return model.setLocalLiveMixInnerCdnVideoResolution(resolution);
  }

  @override
  Future<int> setLocalLiveMixInnerCdnVideoFps(RCRTCVideoFps fps) {
    return model.setLocalLiveMixInnerCdnVideoFps(fps);
  }

}
