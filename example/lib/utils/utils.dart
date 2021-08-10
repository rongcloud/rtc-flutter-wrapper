import 'dart:math';

import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';

import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/extension.dart';

class Utils {
  static String generateRoomId() {
    int current = _random.nextInt(1000000);
    return '$current'.padLeft(6, '0');
  }

  static set engine(RCRTCEngine? engine) {
    _engine = engine;
    _onSetEngine();
  }

  static void _onSetEngine() {
    if (_engine != null) {
      _engine?.onUserJoined = (String id) {
        _users.removeWhere((user) => user.id == id);
        _users.add(UserState(id));
        onUserJoined?.call(id);
      };
      _engine?.onUserOffline = (String id) {
        _users.removeWhere((user) => user.id == id);
        onUserLeft?.call(id);
      };
      _engine?.onUserLeft = (String id) {
        _users.removeWhere((user) => user.id == id);
        onUserLeft?.call(id);
      };
      _engine?.onRemotePublished = (String id, RCRTCMediaType type) {
        UserState? user = _users.firstWhereOrNull((user) => user.id == id);
        switch (type) {
          case RCRTCMediaType.audio:
            user?.audioPublished = true;
            onUserAudioStateChanged?.call(id, true);
            break;
          case RCRTCMediaType.video:
            user?.videoPublished = true;
            onUserVideoStateChanged?.call(id, true);
            break;
          case RCRTCMediaType.audio_video:
            user?.audioPublished = true;
            user?.videoPublished = true;
            onUserAudioStateChanged?.call(id, true);
            onUserVideoStateChanged?.call(id, true);
            break;
        }
      };
      _engine?.onRemoteUnpublished = (String id, RCRTCMediaType type) {
        UserState? user = _users.firstWhereOrNull((user) => user.id == id);
        switch (type) {
          case RCRTCMediaType.audio:
            user?.audioPublished = false;
            user?.audioSubscribed = false;
            onUserAudioStateChanged?.call(id, false);
            break;
          case RCRTCMediaType.video:
            user?.videoPublished = false;
            user?.videoSubscribed = false;
            onUserVideoStateChanged?.call(id, false);
            break;
          case RCRTCMediaType.audio_video:
            user?.audioPublished = false;
            user?.videoPublished = false;
            user?.audioSubscribed = false;
            user?.videoSubscribed = false;
            onUserAudioStateChanged?.call(id, false);
            onUserVideoStateChanged?.call(id, false);
            break;
        }
      };
    } else {
      onUserJoined = null;
      onUserLeft = null;
      onUserAudioStateChanged = null;
      onUserVideoStateChanged = null;
      _engine?.onUserJoined = null;
      _engine?.onUserOffline = null;
      _engine?.onUserLeft = null;
      _users.clear();
    }
  }

  static RCRTCEngine? get engine {
    return _engine;
  }

  static List<UserState> get users => _users;

  static Random _random = Random.secure();

  static RCRTCEngine? _engine;

  static Function(String id)? onUserJoined;
  static Function(String id)? onUserLeft;
  static Function(String id, bool published)? onUserAudioStateChanged;
  static Function(String id, bool published)? onUserVideoStateChanged;

  static List<UserState> _users = [];
}
