import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/local_storage.dart';
import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import 'global_config.dart';
import 'router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  static Main? _instance;

  static const MethodChannel _channel = MethodChannel('cn.rongcloud.rtc.flutter.demo');
}
