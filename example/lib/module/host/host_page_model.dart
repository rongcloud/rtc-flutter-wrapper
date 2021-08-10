import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/model.dart';
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
    Utils.engine?.onEnableCamera = (bool enable, int code, String? message) {
      Utils.engine?.onEnableCamera = null;
      completer.complete(enable);
    };
    int code = await Utils.engine?.enableCamera(open) ?? -1;
    if (code != 0) {
      Utils.engine?.onEnableCamera = null;
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
    Utils.engine?.onSwitchCamera = (RCRTCCamera camera, int code, String? message) {
      Utils.engine?.onSwitchCamera = null;
      completer.complete(camera == RCRTCCamera.front);
    };
    int code = await Utils.engine?.switchCamera() ?? -1;
    if (code != 0) {
      Utils.engine?.onSwitchCamera = null;
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
