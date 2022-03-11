import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/main.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';

import 'host_page_contract.dart';

class HostPageModel extends AbstractModel implements Model {
  @override
  Future<bool> changeMic(bool open) async {
    if (open) {
      PermissionStatus status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          openAppSettings();
        }
        return false;
      }
    }
    int code = await Utils.engine?.enableMicrophone(open) ?? -1;
    return code != 0 ? !open : open;
  }

  @override
  Future<bool> changeCamera(bool open) async {
    if (open) {
      PermissionStatus status = await Permission.camera.request();
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          openAppSettings();
        }
        return false;
      }
    }
    Completer<bool> completer = Completer();
    Utils.engine?.onCameraEnabled = (bool enable, int code, String? message) {
      Utils.engine?.onCameraEnabled = null;
      completer.complete(enable);
    };
    int code = await Utils.engine?.enableCamera(open) ?? -1;
    if (code != 0) {
      Utils.engine?.onCameraEnabled = null;
      return !open;
    }
    return completer.future;
  }

  @override
  Future<int> changeAudio(bool publish) async {
    int code = -1;
    Completer<int> completer = Completer();
    if (publish) {
      Utils.engine?.onPublished = (RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onPublished = null;
        completer.complete(code);
      };
      code = await Utils.engine?.publish(RCRTCMediaType.audio) ?? -1;
    } else {
      Utils.engine?.onUnpublished = (RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onUnpublished = null;
        completer.complete(code);
      };
      code = await Utils.engine?.unpublish(RCRTCMediaType.audio) ?? -1;
    }
    if (code != 0) {
      Utils.engine?.onPublished = null;
      Utils.engine?.onUnpublished = null;
      return code;
    }
    return completer.future;
  }

  @override
  Future<int> changeVideo(bool publish) async {
    int code = -1;
    Completer<int> completer = Completer();
    if (publish) {
      Utils.engine?.onPublished = (RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onPublished = null;
        completer.complete(code);
      };
      code = await Utils.engine?.publish(RCRTCMediaType.video) ?? -1;
    } else {
      Utils.engine?.onUnpublished = (RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onUnpublished = null;
        completer.complete(code);
      };
      code = await Utils.engine?.unpublish(RCRTCMediaType.video) ?? -1;
    }
    if (code != 0) {
      Utils.engine?.onPublished = null;
      Utils.engine?.onUnpublished = null;
      return code;
    }
    return completer.future;
  }

  @override
  Future<bool> changeFrontCamera(bool front) async {
    Completer<bool> completer = Completer();
    Utils.engine?.onCameraSwitched = (RCRTCCamera camera, int code, String? message) {
      Utils.engine?.onCameraSwitched = null;
      completer.complete(camera == RCRTCCamera.front);
    };
    int code = await Utils.engine?.switchCamera() ?? -1;
    if (code != 0) {
      Utils.engine?.onCameraSwitched = null;
      return !front;
    }
    return completer.future;
  }

  @override
  Future<bool> changeSpeaker(bool open) async {
    int code = await Utils.engine?.enableSpeaker(open) ?? -1;
    return code != 0 ? !open : open;
  }

  @override
  Future<bool> changeVideoConfig(RCRTCVideoConfig config) async {
    int code = await Utils.engine?.setVideoConfig(config) ?? -1;
    return code == 0;
  }

  @override
  Future<bool> changeTinyVideoConfig(RCRTCVideoConfig config) async {
    int code = await Utils.engine?.setVideoConfig(config, true) ?? -1;
    return code == 0;
  }

  @override
  Future<bool> switchToNormalStream(String id) async {
    Completer<bool> completer = Completer();
    Utils.engine?.onSubscribed = (String id, RCRTCMediaType type, int code, String? message) {
      Utils.engine?.onSubscribed = null;
      completer.complete(code == 0);
    };
    int code = await Utils.engine?.subscribe(id, RCRTCMediaType.video, false) ?? -1;
    if (code != 0) {
      Utils.engine?.onSubscribed = null;
      return false;
    }
    return completer.future;
  }

  @override
  Future<bool> switchToTinyStream(String id) async {
    Completer<bool> completer = Completer();
    Utils.engine?.onSubscribed = (String id, RCRTCMediaType type, int code, String? message) {
      Utils.engine?.onSubscribed = null;
      completer.complete(code == 0);
    };
    int code = await Utils.engine?.subscribe(id, RCRTCMediaType.video, true) ?? -1;
    if (code != 0) {
      Utils.engine?.onSubscribed = null;
      return false;
    }
    return completer.future;
  }

  @override
  Future<bool> changeRemoteAudioStatus(String id, bool subscribe) async {
    Completer<bool> completer = Completer();
    int code = -1;
    if (subscribe) {
      Utils.engine?.onSubscribed = (String id, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onSubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      code = await Utils.engine?.subscribe(id, RCRTCMediaType.audio) ?? -1;
    } else {
      Utils.engine?.onUnsubscribed = (String id, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onUnsubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      code = await Utils.engine?.unsubscribe(id, RCRTCMediaType.audio) ?? -1;
    }
    if (code != 0) {
      Utils.engine?.onSubscribed = null;
      Utils.engine?.onUnsubscribed = null;
      return !subscribe;
    }
    return completer.future;
  }

  @override
  Future<bool> changeRemoteVideoStatus(String id, bool subscribe) async {
    Completer<bool> completer = Completer();
    int code = -1;
    if (subscribe) {
      Utils.engine?.onSubscribed = (String id, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onSubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      code = await Utils.engine?.subscribe(id, RCRTCMediaType.video) ?? -1;
    } else {
      Utils.engine?.onUnsubscribed = (String id, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onUnsubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      code = await Utils.engine?.unsubscribe(id, RCRTCMediaType.video) ?? -1;
    }
    if (code != 0) {
      Utils.engine?.onSubscribed = null;
      Utils.engine?.onUnsubscribed = null;
      return !subscribe;
    }
    return completer.future;
  }

  @override
  Future<int> publishCustomVideo(String id, String path, RCRTCVideoConfig config, bool yuv) async {
    Completer<int> completer = Completer();
    String tag = '${DefaultData.user!.id.replaceAll('_', '')}Custom';
    int code = await Utils.engine?.createCustomStreamFromFile(path: path, tag: tag) ?? -1;
    if (code != 0) {
      completer.complete(code);
      return completer.future;
    }
    code = await Utils.engine?.setCustomStreamVideoConfig(tag, config) ?? -1;
    if (code != 0) {
      completer.complete(code);
      return completer.future;
    }
    if (yuv) Main.getInstance().enableLocalCustomYuv(id);
    Utils.engine?.onCustomStreamPublished = (String tag, int code, String? message) {
      Utils.engine?.onCustomStreamPublished = null;
      completer.complete(code);
    };
    code = await Utils.engine?.publishCustomStream(tag) ?? -1;
    if (code != 0) {
      Utils.engine?.onCustomStreamPublished = null;
      completer.complete(code);
      return completer.future;
    }
    return completer.future;
  }

  @override
  Future<int> unpublishCustomVideo() async {
    Completer<int> completer = Completer();
    String tag = '${DefaultData.user!.id.replaceAll('_', '')}Custom';
    Utils.engine?.onCustomStreamUnpublished = (String tag, int code, String? message) {
      Utils.engine?.onCustomStreamUnpublished = null;
      completer.complete(code);
    };
    int code = await Utils.engine?.unpublishCustomStream(tag) ?? -1;
    if (code != 0) {
      Utils.engine?.onCustomStreamUnpublished = null;
      completer.complete(code);
    }
    return completer.future;
  }

  @override
  Future<bool> changeCustomConfig(RCRTCVideoConfig config) async {
    String tag = '${DefaultData.user!.id.replaceAll('_', '')}Custom';
    int code = await Utils.engine?.setCustomStreamVideoConfig(tag, config) ?? -1;
    return code == 0;
  }

  @override
  Future<bool> changeRemoteCustomVideoStatus(String rid, String uid, String tag, bool yuv, bool subscribe) async {
    Completer<bool> completer = Completer();
    int code = -1;
    if (subscribe) {
      Utils.engine?.onCustomStreamSubscribed = (String id, String tag, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onCustomStreamSubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      if (yuv) Main.getInstance().enableRemoteCustomYuv(rid, uid, tag);
      code = await Utils.engine?.subscribeCustomStream(uid, tag, RCRTCMediaType.video, false) ?? -1;
    } else {
      Utils.engine?.onCustomStreamUnsubscribed = (String id, String tag, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onCustomStreamUnsubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      Main.getInstance().disableRemoteCustomYuv(uid, tag);
      code = await Utils.engine?.unsubscribeCustomStream(uid, tag, RCRTCMediaType.video) ?? -1;
    }
    if (code != 0) {
      Utils.engine?.onCustomStreamSubscribed = null;
      Utils.engine?.onCustomStreamUnsubscribed = null;
      return !subscribe;
    }
    return completer.future;
  }

  @override
  Future<bool> changeRemoteCustomAudioStatus(String rid, String uid, String tag, bool subscribe) async {
    Completer<bool> completer = Completer();
    int code = -1;
    if (subscribe) {
      Utils.engine?.onCustomStreamSubscribed = (String id, String tag, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onCustomStreamSubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      code = await Utils.engine?.subscribeCustomStream(uid, tag, RCRTCMediaType.audio, false) ?? -1;
    } else {
      Utils.engine?.onCustomStreamUnsubscribed = (String id, String tag, RCRTCMediaType type, int code, String? message) {
        Utils.engine?.onCustomStreamUnsubscribed = null;
        completer.complete(code != 0 ? !subscribe : subscribe);
      };
      Main.getInstance().disableRemoteCustomYuv(uid, tag);
      code = await Utils.engine?.unsubscribeCustomStream(uid, tag, RCRTCMediaType.audio) ?? -1;
    }
    if (code != 0) {
      Utils.engine?.onCustomStreamSubscribed = null;
      Utils.engine?.onCustomStreamUnsubscribed = null;
      return !subscribe;
    }
    return completer.future;
  }

  @override
  Future<int> responseJoinSubRoom(String rid, String uid, bool agree) async {
    Completer<int> completer = Completer();
    Utils.engine?.onJoinSubRoomRequestResponded = (roomId, userId, agree, code, message) {
      Utils.engine?.onJoinSubRoomRequestResponded = null;
      completer.complete(code);
    };
    int code = await Utils.engine?.responseJoinSubRoomRequest(rid, uid, agree) ?? -1;
    if (code != 0) {
      Utils.engine?.onJoinSubRoomRequestResponded = null;
      return code;
    }
    return completer.future;
  }

  @override
  Future<int> exit() async {
    Completer<int> completer = Completer();
    Utils.engine?.onRoomLeft = (int code, String? message) async {
      Utils.engine?.onRoomLeft = null;
      await Utils.engine?.destroy();
      Utils.engine = null;
      completer.complete(code);
    };
    int code = await Utils.engine?.leaveRoom() ?? -1;
    if (code != 0) {
      Utils.engine?.onRoomLeft = null;
      await Utils.engine?.destroy();
      Utils.engine = null;
      return code;
    }
    return completer.future;
  }
}
