import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/ui/loading.dart';
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
      _engine?.onSubRoomBanded = (String roomId) {
        if (_bandedSubRooms.indexOf(roomId) < 0) {
          _bandedSubRooms.add(roomId);
        }
      };
      _engine?.onSubRoomDisband = (String roomId, String userId) {
        _joinedSubRooms.remove(roomId);
        _bandedSubRooms.remove(roomId);
      };
      _engine?.onUserJoined = (String roomId, String userId) {
        _users.removeWhere((user) => user.id == userId);
        _users.add(UserState(roomId, userId));
        onUserListChanged?.call();
      };
      _engine?.onUserOffline = (String roomId, String userId) {
        _users.removeWhere((user) => user.id == userId);
        onUserListChanged?.call();
      };
      _engine?.onUserLeft = (String roomId, String userId) {
        _users.removeWhere((user) => user.id == userId);
        onUserListChanged?.call();
      };
      _engine?.onRemotePublished = (String roomId, String userId, RCRTCMediaType type) {
        UserState? user = _users.firstWhereOrNull((user) => user.id == userId);
        switch (type) {
          case RCRTCMediaType.audio:
            user?.audioPublished = true;
            onUserAudioStateChanged?.call(userId, true);
            break;
          case RCRTCMediaType.video:
            user?.videoPublished = true;
            onUserVideoStateChanged?.call(userId, true);
            break;
          case RCRTCMediaType.audio_video:
            user?.audioPublished = true;
            user?.videoPublished = true;
            onUserAudioStateChanged?.call(userId, true);
            onUserVideoStateChanged?.call(userId, true);
            break;
        }
      };
      _engine?.onRemoteUnpublished = (String roomId, String userId, RCRTCMediaType type) {
        UserState? user = _users.firstWhereOrNull((user) => user.id == userId);
        switch (type) {
          case RCRTCMediaType.audio:
            user?.audioPublished = false;
            user?.audioSubscribed = false;
            onUserAudioStateChanged?.call(userId, false);
            break;
          case RCRTCMediaType.video:
            user?.videoPublished = false;
            user?.videoSubscribed = false;
            onUserVideoStateChanged?.call(userId, false);
            break;
          case RCRTCMediaType.audio_video:
            user?.audioPublished = false;
            user?.videoPublished = false;
            user?.audioSubscribed = false;
            user?.videoSubscribed = false;
            onUserAudioStateChanged?.call(userId, false);
            onUserVideoStateChanged?.call(userId, false);
            break;
        }
      };
      _engine?.onRemoteCustomStreamPublished = (String roomId, String userId, String tag) {
        UserState? user = _users.firstWhereOrNull((user) => user.id == userId);
        user?.customs.removeWhere((custom) => custom.tag == tag);
        user?.customs.add(CustomState(tag));
        onUserCustomStateChanged?.call(userId, tag, true);
      };
      _engine?.onRemoteCustomStreamUnpublished = (String roomId, String userId, String tag) {
        UserState? user = _users.firstWhereOrNull((user) => user.id == userId);
        user?.customs.removeWhere((custom) => custom.tag == tag);
        onUserCustomStateChanged?.call(userId, tag, false);
      };
    } else {
      onUserListChanged = null;
      onUserAudioStateChanged = null;
      onUserVideoStateChanged = null;
      _engine?.onUserJoined = null;
      _engine?.onUserOffline = null;
      _engine?.onUserLeft = null;
      _engine?.onRemotePublished = null;
      _engine?.onRemoteUnpublished = null;
      _engine?.onRemoteCustomStreamPublished = null;
      _engine?.onRemoteCustomStreamUnpublished = null;
      _users.clear();
      _bandedSubRooms.clear();
      _joinedSubRooms.clear();
    }
  }

  static void joinSubRoom(BuildContext context, String roomId) async {
    Loading.show(context);
    _engine?.onSubRoomJoined = (roomId, code, message) {
      _engine?.onSubRoomJoined = null;
      Loading.dismiss(context);
      if (code != 0) {
        '加入$roomId子房间失败, code:$code, message:$message'.toast();
      } else {
        _joinedSubRooms.add(roomId);
        '加入$roomId子房间成功'.toast();
      }
    };
    int code = await _engine?.joinSubRoom(roomId) ?? -1;
    if (code != 0) {
      _engine?.onSubRoomJoined = null;
      Loading.dismiss(context);
      '加入$roomId子房间失败, code:$code'.toast();
    }
  }

  static void clearRoomUser(String roomId, bool disband) {
    if (disband) _bandedSubRooms.remove(roomId);
      _joinedSubRooms.remove(roomId);
    users.removeWhere((user) => user.room == roomId);
    onUserListChanged?.call();
  }

  static RCRTCEngine? get engine {
    return _engine;
  }

  static List<UserState> get users => _users;

  static List<String> get joinedSubRooms => _joinedSubRooms;

  static List<String> get joinableSubRooms {
    List<String> list = [];
    list.addAll(_bandedSubRooms);
    _joinedSubRooms.forEach((roomId) {
      list.remove(roomId);
    });
    return list;
  }

  static Random _random = Random.secure();

  static RCRTCEngine? _engine;

  static Function()? onUserListChanged;
  static Function(String id, bool published)? onUserAudioStateChanged;
  static Function(String id, bool published)? onUserVideoStateChanged;
  static Function(String id, String tag, bool published)? onUserCustomStateChanged;

  static List<UserState> _users = [];

  static List<String> _bandedSubRooms = [];
  static List<String> _joinedSubRooms = [];
}
