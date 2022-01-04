// import 'package:leak_detector/leak_detector.dart';

import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/local_storage.dart';
import 'package:wakelock/wakelock.dart';

import 'global_config.dart';
import 'router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // LeakDetector().init(maxRetainingPath: 300);
  // LeakDetector().onLeakedStream.listen((event) {
  //   event.retainingPath.forEach((node) => print(node));
  //   showLeakedInfoPage(ContextHolder.currentContext, event);
  // });
  LocalStorage.init().then((value) => runApp(RCRTCFlutter()));
}

class RCRTCFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    Wakelock.enable();

    return MaterialApp(
      navigatorKey: ContextHolder.key,
      title: GlobalConfig.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouterManager.CONNECT,
      routes: RouterManager.initRouters(),
      // navigatorObservers: [
      //   LeakNavigatorObserver(),
      // ],
    );
  }
}

class Main {
  static Main getInstance() {
    if (_instance == null) _instance = Main();
    return _instance!;
  }

  Future<void> openBeauty() async {
    return await _channel.invokeMethod('openBeauty');
  }

  Future<void> closeBeauty() async {
    return await _channel.invokeMethod('closeBeauty');
  }

  Future<void> enableLocalCustomYuv(String rid) async {
    Map<String, dynamic> arguments = {
      'rid': rid,
      'hid': DefaultData.user!.id, // TODO host id
      'uid': DefaultData.user!.id,
      'tag': '${DefaultData.user!.id.replaceAll('_', '')}Custom',
    };
    return await _channel.invokeMethod('enableLocalCustomYuv', arguments);
  }

  Future<void> disableLocalCustomYuv() async {
    return await _channel.invokeMethod('disableLocalCustomYuv');
  }

  Future<void> enableRemoteCustomYuv(String rid, String uid, String tag) async {
    Map<String, dynamic> arguments = {
      'rid': rid,
      'hid': DefaultData.user!.id, // TODO host id
      'uid': uid,
      'tag': tag,
    };
    return await _channel.invokeMethod('enableRemoteCustomYuv', arguments);
  }

  Future<void> disableRemoteCustomYuv(String uid, String tag) async {
    Map<String, dynamic> arguments = {
      'id': uid,
      'tag': tag,
    };
    return await _channel.invokeMethod('disableRemoteCustomYuv', arguments);
  }

  Future<void> disableAllRemoteCustomYuv() async {
    return await _channel.invokeMethod('disableAllRemoteCustomYuv');
  }

  Future<void> writeReceiveVideoFps(String uid, String tag, String fps) async {
    Map<String, dynamic> arguments = {
      'id': uid,
      'tag': tag,
      'fps': fps,
    };
    return await _channel.invokeMethod('writeReceiveVideoFps', arguments);
  }

  Future<void> writeReceiveVideoBitrate(String uid, String tag, String bitrate) async {
    Map<String, dynamic> arguments = {
      'id': uid,
      'tag': tag,
      'bitrate': bitrate,
    };
    return await _channel.invokeMethod('writeReceiveVideoBitrate', arguments);
  }

  Future<void> startAudioRouteing() async {
    return await _channel.invokeMethod('startAudioRouteing');
  }

  Future<void> stopAudioRouteing() async {
    return await _channel.invokeMethod('stopAudioRouteing');
  }

  Future<void> resetAudioRouteing() async {
    return await _channel.invokeMethod('resetAudioRouteing');
  }

  static Main? _instance;

  static const MethodChannel _channel = MethodChannel('cn.rongcloud.rtc.flutter.demo');
}
