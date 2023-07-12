import 'package:flutter/widgets.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/presenter.dart';

import 'connect_page_contract.dart';
import 'connect_page_model.dart';

class ConnectPagePresenter extends AbstractPresenter<RCView, Model> implements Presenter {
  @override
  IModel createModel() {
    return ConnectPageModel();
  }

  @override
  Future<void> init(BuildContext context) async {
    disconnect();
    model.load();
  }

  @override
  void clear() {
    model.clear();
  }

  @override
  Future<Result> token(String key) {
    return model.token(key);
  }

  @override
  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
  ) {
    model.connect(
      key,
      navigate,
      file,
      media,
      token,
      (code, info) {
        if (code != 0)
          view.onConnectError(code, info);
        else
          view.onConnected(info);
      },
    );
  }

  @override
  void disconnect() {
    model.disconnect();
  }

  @override
  void action(
    String info,
    RCRTCMediaType type,
    RCRTCRole role,
    bool tiny,
    bool yuv,
    bool srtp,
  ) {
    model.action(
      info,
      type,
      role,
      tiny,
      yuv,
      srtp,
      (code, info) {
        if (code != 0) {
          view.onError(code, info);
        } else {
          view.onDone(info);
        }
      },
    );
  }
}
