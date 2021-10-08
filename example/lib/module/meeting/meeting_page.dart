import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/ui/loading.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/extension.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/main.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/widgets/ui.dart';

import 'meeting_page_contract.dart';
import 'meeting_page_presenter.dart';

class MeetingPage extends AbstractView {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends AbstractViewState<MeetingPagePresenter, MeetingPage> implements View, RCRTCStatsListener {
  @override
  MeetingPagePresenter createPresenter() {
    return MeetingPagePresenter();
  }

  @override
  void init(BuildContext context) {
    super.init(context);

    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _roomId = arguments['id'];
    _config = Config.fromJson(arguments['config']);
    _tinyConfig = RCRTCVideoConfig.create(
      minBitrate: 100,
      maxBitrate: 500,
      fps: RCRTCVideoFps.fps_15,
      resolution: RCRTCVideoResolution.resolution_180_320,
    );

    createView();

    Utils.engine?.setStatsListener(this);
  }

  void createView() async {
    _local = await RCRTCView.create(mirror: true);
    if (_local != null) {
      Utils.engine?.setLocalView(_local!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _remotes.clear();

    _networkStats = null;
    _localAudioStats = null;
    _localVideoStats.clear();
    _remoteAudioStats.clear();
    _remoteVideoStats.clear();

    _networkStatsStateSetter = null;
    _localAudioStatsStateSetter = null;
    _localVideoStatsStateSetter = null;
    _remoteAudioStatsStateSetters.clear();
    _remoteVideoStatsStateSetters.clear();

    Main.getInstance().closeBeauty();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('会议号: $_roomId'),
          actions: [
            IconButton(
              icon: Icon(
                _beauty ? Icons.face_retouching_natural : Icons.face,
              ),
              onPressed: _config.camera ? () => _beautySwitch(context) : null,
            ),
            IconButton(
              icon: Icon(
                Icons.surround_sound,
              ),
              onPressed: _config.audio ? () => _showAudioEffectPanel(context) : null,
            ),
            IconButton(
              icon: Icon(
                Icons.music_note,
              ),
              onPressed: _config.audio ? () => _showAudioMixPanel(context) : null,
            ),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.dp,
                          height: 160.dp,
                          color: Colors.blue,
                          child: Stack(
                            children: [
                              _local ?? Container(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 5.dp,
                                  ),
                                  child: Text(
                                    '${DefaultData.user?.id}',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 15.dp,
                                  ),
                                  child: BoxFitChooser(
                                    fit: _local?.fit ?? BoxFit.contain,
                                    onSelected: (fit) {
                                      setState(() {
                                        _local?.fit = fit;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Row(
                              children: [
                                CheckBoxes(
                                  '采集音频',
                                  checked: _config.mic,
                                  onChanged: (checked) => _changeMic(checked),
                                ),
                                CheckBoxes(
                                  '采集视频',
                                  checked: _config.camera,
                                  onChanged: (checked) => _changeCamera(checked),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CheckBoxes(
                                  '发布音频',
                                  checked: _config.audio,
                                  onChanged: (checked) => _changeAudio(checked),
                                ),
                                CheckBoxes(
                                  '发布视频',
                                  checked: _config.video,
                                  onChanged: (checked) => _changeVideo(checked),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CheckBoxes(
                                  '前置摄像',
                                  checked: _config.frontCamera,
                                  onChanged: (checked) => _changeFrontCamera(checked),
                                ),
                                CheckBoxes(
                                  '本地镜像',
                                  checked: _config.mirror,
                                  onChanged: (checked) => _changeMirror(checked),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Button(
                                  _config.speaker ? '扬声器' : '听筒',
                                  size: 15.sp,
                                  callback: () => _changeSpeaker(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    value: _config.fps,
                                    items: videoFpsItems(),
                                    onChanged: (dynamic fps) => _changeFps(fps),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    value: _config.resolution,
                                    items: videoResolutionItems(),
                                    onChanged: (dynamic resolution) => _changeResolution(resolution),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '码率下限:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    value: _config.minVideoKbps,
                                    items: minVideoKbpsItems(),
                                    onChanged: (dynamic kbps) => _changeMinVideoKbps(kbps),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '码率上限:',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    value: _config.maxVideoKbps,
                                    items: maxVideoKbpsItems(),
                                    onChanged: (dynamic kbps) => _changeMaxVideoKbps(kbps),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.dp),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Spacer(),
                            Text(
                              "小流设置",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.sp,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isDense: true,
                                        value: _tinyConfig.resolution,
                                        items: videoResolutionItems(),
                                        onChanged: (dynamic resolution) => _changeTinyResolution(resolution),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '下限:',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isDense: true,
                                        value: _tinyConfig.minBitrate,
                                        items: tinyMinVideoKbpsItems(),
                                        onChanged: (dynamic kbps) => _changeTinyMinVideoKbps(kbps),
                                      ),
                                    ),
                                    Text(
                                      '上限:',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isDense: true,
                                        value: _tinyConfig.maxBitrate,
                                        items: tinyMaxVideoKbpsItems(),
                                        onChanged: (dynamic kbps) => _changeTinyMaxVideoKbps(kbps),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setter) {
                      _networkStatsStateSetter = setter;
                      return NetworkStatsTable(_networkStats);
                    }),
                    StatefulBuilder(builder: (context, setter) {
                      _localAudioStatsStateSetter = setter;
                      return LocalAudioStatsTable(_localAudioStats);
                    }),
                    StatefulBuilder(builder: (context, setter) {
                      _localVideoStatsStateSetter = setter;
                      return LocalVideoStatsTable(_localVideoStats);
                    }),
                  ],
                ),
              ),
              Divider(
                height: 10.dp,
                color: Colors.black,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: Utils.users.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 5.dp,
                      color: Colors.transparent,
                    );
                  },
                  itemBuilder: (context, index) {
                    UserState user = Utils.users[index];
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.dp,
                          height: 160.dp,
                          color: Colors.blue,
                          child: Stack(
                            children: [
                              _remotes[user.id] ?? Container(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 5.dp,
                                  ),
                                  child: Text(
                                    '${user.id}',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    bottom: 5.dp,
                                  ),
                                  child: Offstage(
                                    offstage: !user.videoPublished,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        '切大流'.onClick(() {
                                          _switchToNormalStream(user.id);
                                        }),
                                        VerticalDivider(
                                          width: 10.dp,
                                          color: Colors.transparent,
                                        ),
                                        '切小流'.onClick(() {
                                          _switchToTinyStream(user.id);
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 15.dp,
                                  ),
                                  child: BoxFitChooser(
                                    fit: _remotes[user.id]?.fit ?? BoxFit.contain,
                                    onSelected: (fit) {
                                      setState(() {
                                        _remotes[user.id]?.fit = fit;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          width: 2.dp,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  CheckBoxes(
                                    '订阅音频',
                                    enable: user.audioPublished,
                                    checked: user.audioSubscribed,
                                    onChanged: (subscribe) => _changeRemoteAudio(user, subscribe),
                                  ),
                                  CheckBoxes(
                                    '订阅视频',
                                    enable: user.videoPublished,
                                    checked: user.videoSubscribed,
                                    onChanged: (subscribe) => _changeRemoteVideo(user, subscribe),
                                  ),
                                ],
                              ),
                              StatefulBuilder(builder: (context, setter) {
                                _remoteAudioStatsStateSetters[user.id] = setter;
                                return RemoteAudioStatsTable(_remoteAudioStats[user.id]);
                              }),
                              StatefulBuilder(builder: (context, setter) {
                                _remoteVideoStatsStateSetters[user.id] = setter;
                                return RemoteVideoStatsTable(_remoteVideoStats[user.id]);
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: _exit,
    );
  }

  void _beautySwitch(BuildContext context) async {
    Loading.show(context);
    if (!_beauty) {
      await Main.getInstance().openBeauty();
    } else {
      await Main.getInstance().closeBeauty();
    }
    setState(() {
      _beauty = !_beauty;
    });
    Loading.dismiss(context);
  }

  void _showAudioEffectPanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AudioEffectPanel(Utils.engine!);
      },
    );
  }

  void _showAudioMixPanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AudioMixPanel(Utils.engine!);
      },
    );
  }

  void _changeMic(bool open) async {
    Loading.show(context);
    bool result = await presenter.changeMic(open);
    setState(() {
      _config.mic = result;
    });
    Loading.dismiss(context);
  }

  void _changeCamera(bool open) async {
    Loading.show(context);
    if (open) {
      _local = await RCRTCView.create(mirror: true);
      if (_local != null) {
        await Utils.engine?.setLocalView(_local!);
      }
    } else {
      _local = null;
      await Utils.engine?.removeLocalView();
    }
    bool result = await presenter.changeCamera(open);
    setState(() {
      _config.camera = result;
    });
    Loading.dismiss(context);
  }

  void _changeAudio(bool publish) async {
    Loading.show(context);
    int result = await presenter.changeAudio(publish);
    if (result != 0) {
      '${publish ? 'Publish' : 'Unpublish'} Audio Stream Error'.toast();
      publish = !publish;
    }
    setState(() {
      _config.audio = publish;
    });
    Loading.dismiss(context);
  }

  void _changeVideo(bool publish) async {
    Loading.show(context);
    int result = await presenter.changeVideo(publish);
    if (result != 0) {
      '${publish ? 'Publish' : 'Unpublish'} Video Stream Error'.toast();
      publish = !publish;
    }
    setState(() {
      _config.video = publish;
    });
    Loading.dismiss(context);
  }

  void _changeFrontCamera(bool front) async {
    Loading.show(context);
    bool result = await presenter.changeFrontCamera(front);
    setState(() {
      _config.frontCamera = result;
    });
    Loading.dismiss(context);
  }

  void _changeMirror(bool mirror) {
    setState(() {
      _config.mirror = mirror;
      _local?.mirror = mirror;
    });
  }

  void _changeSpeaker() async {
    bool result = await presenter.changeSpeaker(!_config.speaker);
    setState(() {
      _config.speaker = result;
    });
  }

  void _changeFps(RCRTCVideoFps fps) {
    _config.fps = fps;
    presenter.changeVideoConfig(_config.videoConfig);
    setState(() {});
  }

  void _changeResolution(RCRTCVideoResolution resolution) async {
    _config.resolution = resolution;
    await presenter.changeVideoConfig(_config.videoConfig);
    setState(() {});
  }

  void _changeMinVideoKbps(int kbps) {
    _config.minVideoKbps = kbps;
    presenter.changeVideoConfig(_config.videoConfig);
    setState(() {});
  }

  void _changeMaxVideoKbps(int kbps) {
    _config.maxVideoKbps = kbps;
    presenter.changeVideoConfig(_config.videoConfig);
    setState(() {});
  }

  void _changeTinyResolution(RCRTCVideoResolution resolution) async {
    _tinyConfig.resolution = resolution;
    setState(() {});
    bool ret = await presenter.changeTinyVideoConfig(_tinyConfig);
    (ret ? '设置成功' : '设置失败').toast();
  }

  void _changeTinyMinVideoKbps(int kbps) async {
    _tinyConfig.minBitrate = kbps;
    setState(() {});
    bool ret = await presenter.changeTinyVideoConfig(_tinyConfig);
    (ret ? '设置成功' : '设置失败').toast();
  }

  void _changeTinyMaxVideoKbps(int kbps) async {
    _tinyConfig.maxBitrate = kbps;
    setState(() {});
    bool ret = await presenter.changeTinyVideoConfig(_tinyConfig);
    (ret ? '设置成功' : '设置失败').toast();
  }

  void _switchToNormalStream(String id) {
    presenter.switchToNormalStream(id);
  }

  void _switchToTinyStream(String id) {
    presenter.switchToTinyStream(id);
  }

  void _changeRemoteAudio(UserState user, bool subscribe) async {
    Loading.show(context);
    user.audioSubscribed = await presenter.changeRemoteAudioStatus(user.id, subscribe);
    setState(() {});
    Loading.dismiss(context);
  }

  void _changeRemoteVideo(UserState user, bool subscribe) async {
    Loading.show(context);
    user.videoSubscribed = await presenter.changeRemoteVideoStatus(user.id, subscribe);
    if (user.videoSubscribed) {
      if (_remotes.containsKey(user.id)) _remotes.remove(user.id);
      RCRTCView view = await RCRTCView.create(mirror: false);
      _remotes[user.id] = view;
      await Utils.engine?.setRemoteView(user.id, view);
    } else {
      if (_remotes.containsKey(user.id)) {
        _remotes.remove(user.id);
        await Utils.engine?.removeRemoteView(user.id);
      }
    }
    setState(() {});
    Loading.dismiss(context);
  }

  Future<bool> _exit() async {
    Loading.show(context);
    await Utils.engine?.setStatsListener(null);
    presenter.exit();
    return Future.value(false);
  }

  @override
  void onUserJoined(String id) async {
    await _updateRemoteView();
    setState(() {});
  }

  @override
  void onUserLeft(String id) async {
    await _updateRemoteView();
    setState(() {});
  }

  Future<void> _updateRemoteView() {
    Completer<void> completer = Completer();
    _remotes.clear();
    int count = Utils.users.length;
    if (count > 0) {
      Utils.users.forEach((user) async {
        if (user.videoSubscribed) {
          RCRTCView view = await RCRTCView.create(mirror: false);
          Utils.engine?.setRemoteView(user.id, view);
          _remotes[user.id] = view;
        }
        count--;
        if (count <= 0) {
          completer.complete();
        }
      });
    } else {
      completer.complete();
    }
    return completer.future;
  }

  @override
  void onUserAudioStateChanged(String id, bool published) {
    setState(() {});
  }

  @override
  void onUserVideoStateChanged(String id, bool published) async {
    if (!published) {
      if (_remotes.containsKey(id)) {
        _remotes.remove(id);
        Utils.engine?.removeRemoteView(id);
      }
    }
    setState(() {});
  }

  @override
  void onExit() {
    Loading.dismiss(context);
    Navigator.pop(context);
  }

  @override
  void onExitWithError(int code) {
    Loading.dismiss(context);
    'Exit with error, code = $code'.toast();
    Navigator.pop(context);
  }

  @override
  void onNetworkStats(RCRTCNetworkStats stats) {
    _networkStatsStateSetter?.call(() {
      _networkStats = stats;
    });
  }

  @override
  void onLocalAudioStats(RCRTCLocalAudioStats stats) {
    _localAudioStatsStateSetter?.call(() {
      _localAudioStats = stats;
    });
  }

  @override
  void onLocalVideoStats(RCRTCLocalVideoStats stats) {
    _localVideoStatsStateSetter?.call(() {
      _localVideoStats[stats.tiny] = stats;
    });
  }

  @override
  void onRemoteAudioStats(String userId, RCRTCRemoteAudioStats stats) {
    _remoteAudioStatsStateSetters[userId]?.call(() {
      _remoteAudioStats[userId] = stats;
    });
  }

  @override
  void onRemoteVideoStats(String userId, RCRTCRemoteVideoStats stats) {
    _remoteVideoStatsStateSetters[userId]?.call(() {
      _remoteVideoStats[userId] = stats;
    });
  }

  @override
  void onLiveMixAudioStats(RCRTCRemoteAudioStats stats) {}

  @override
  void onLiveMixVideoStats(RCRTCRemoteVideoStats stats) {}

  @override
  void onLocalCustomAudioStats(String tag, RCRTCLocalAudioStats stats) {}

  @override
  void onLocalCustomVideoStats(String tag, RCRTCLocalVideoStats stats) {}

  @override
  void onRemoteCustomAudioStats(String userId, String tag, RCRTCRemoteAudioStats stats) {}

  @override
  void onRemoteCustomVideoStats(String userId, String tag, RCRTCRemoteVideoStats stats) {}

  late String _roomId;
  late Config _config;
  late RCRTCVideoConfig _tinyConfig;
  RCRTCView? _local;
  Map<String, RCRTCView?> _remotes = {};

  StateSetter? _networkStatsStateSetter;
  StateSetter? _localAudioStatsStateSetter;
  StateSetter? _localVideoStatsStateSetter;
  Map<String, StateSetter> _remoteAudioStatsStateSetters = {};
  Map<String, StateSetter> _remoteVideoStatsStateSetters = {};

  RCRTCNetworkStats? _networkStats;
  RCRTCLocalAudioStats? _localAudioStats;
  Map<bool, RCRTCLocalVideoStats> _localVideoStats = {};
  Map<String, RCRTCRemoteAudioStats> _remoteAudioStats = {};
  Map<String, RCRTCRemoteVideoStats> _remoteVideoStats = {};

  bool _beauty = false;
}
