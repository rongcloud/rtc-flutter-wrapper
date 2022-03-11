import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/constants.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/presenter.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';

abstract class View implements IView {
  void onConnected(String id);

  void onConnectError(int code, String? id);

  void onDone(String id);

  void onError(int code, String? info);
}

abstract class Model implements IModel {
  void load();

  void clear();

  Future<Result> token(String key);

  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
    StateCallback callback,
  );

  void disconnect();

  void action(
    String id,
    RCRTCMediaType type,
    RCRTCRole role,
    bool tiny,
    bool yuv,
    bool srtp,
    StateCallback callback,
  );
}

abstract class Presenter implements IPresenter {
  void clear();

  Future<Result> token(String key);

  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
  );

  void disconnect();

  void action(
    String id,
    RCRTCMediaType type,
    RCRTCRole role,
    bool tiny,
    bool yuv,
    bool srtp,
  );
}
