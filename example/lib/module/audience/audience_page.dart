import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/ui/loading.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/extension.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/router/router.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/widgets/ui.dart';

import 'audience_page_contract.dart';
import 'audience_page_presenter.dart';

class AudiencePage extends AbstractView {
  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends AbstractViewState<AudiencePagePresenter, AudiencePage> implements RCView, RCRTCStatsListener {
  @override
  AudiencePagePresenter createPresenter() {
    return AudiencePagePresenter();
  }

  @override
  void init(BuildContext context) {
    super.init(context);

    _roomId = ModalRoute.of(context)?.settings.arguments as String;

    Utils.engine?.setStatsListener(this);
    Utils.onRemoveUserAudio = (id) {
      _remoteUserAudioStateSetter?.call(() {
        _remoteUserAudioState.remove(id);
      });
    };
    Utils.engine?.onRemoteLiveMixUnpublished = (type) {
      if (mounted) {
        setState(() {
          switch (type) {
            case RCRTCMediaType.video:
              _muteVideo = false;
              break;
            case RCRTCMediaType.audio:
              _muteAudio = false;
              break;
            case RCRTCMediaType.audio_video:
              _muteAudio = false;
              _muteVideo = false;
              break;
          }
        });
      }
    };
    
    Utils.engine?.onLiveMixSeiReceived = (String sei) {
      print('onLiveMixSeiReceived: $sei');
      setState(() {
        _seiText = sei;
      });
    };
    
    Utils.engine?.onRemoteLiveMixInnerCdnStreamPublished = () {
      print('onRemoteLiveMixInnerCdnStreamPublished');
    };
    Utils.engine?.onRemoteLiveMixInnerCdnStreamUnpublished = () {
      print('onRemoteLiveMixInnerCdnStreamUnpublished');
    };
    
  }

  @override
  void dispose() {
    _remoteAudioStatsStateSetter = null;
    _remoteVideoStatsStateSetter = null;
    _remoteUserAudioStateSetter = null;
    _remoteAudioStats = null;
    _remoteVideoStats = null;
    _remoteUserAudioState.clear();
    Utils.engine?.onLiveMixSeiReceived = null;
    Utils.engine?.onRemoteLiveMixInnerCdnStreamUnpublished = null;
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('观看直播'),
          actions: [
            IconButton(
              tooltip: '切为主播',
              icon: Icon(Icons.spatial_audio_off),
              onPressed: _switchToHost,
            ),
            IconButton(
              icon: Icon(_speaker ? Icons.volume_up : Icons.hearing),
              onPressed: () => _changeSpeaker(),
            ),
            IconButton(
              icon: Icon(
                Icons.message,
              ),
              onPressed: () => _showMessagePanel(context),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 170.dp,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          color: Colors.blue,
                          child: Stack(
                            children: [
                              _host ?? Container(),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 5.dp,
                                    top: 5.dp,
                                  ),
                                  child: BoxFitChooser(
                                    fit: _host?.fit ?? BoxFit.cover,
                                    onSelected: (fit) {
                                      setState(() {
                                        _host?.fit = fit;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                '合流',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.dp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Radios(
                                  '音频',
                                  value: RCRTCMediaType.audio,
                                  groupValue: _type,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _type = value;
                                    });
                                  },
                                ),
                                Spacer(),
                                Radios(
                                  '视频',
                                  value: RCRTCMediaType.video,
                                  groupValue: _type,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _type = value;
                                    });
                                  },
                                ),
                                Spacer(),
                                Radios(
                                  '音视频',
                                  value: RCRTCMediaType.audio_video,
                                  groupValue: _type,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _type = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10.dp,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _type != RCRTCMediaType.audio
                                    ? CheckBoxes(
                                        '订阅小流',
                                        checked: _tiny,
                                        onChanged: (checked) {
                                          setState(() {
                                            _tiny = checked;
                                          });
                                        },
                                      )
                                    : Container(),
                                Button(
                                  '订阅',
                                  size: 18.sp,
                                  callback: () => _refresh(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.dp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CheckBoxes(
                                  '静音视频',
                                  checked: _muteVideo,
                                  onChanged: (checked) {
                                    _muteVideoStream();
                                  },
                                ),
                                CheckBoxes(
                                  '静音音频',
                                  checked: _muteAudio,
                                  onChanged: (checked) {
                                    _muteAudioStream();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.dp,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 10.dp,
                                ),
                                Button(
                                  'Reset View',
                                  size: 15.sp,
                                  callback: () => _resetView(),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(height: 10.dp,),
              Container(
                height: 170.dp,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.blue,
                        child: Stack(
                          children: [
                            _innerCDNView ?? Container(),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 5.dp,
                                  top: 5.dp,
                                ),
                                child: BoxFitChooser(
                                  fit: _innerCDNView?.fit ?? BoxFit.cover,
                                  onSelected: (fit) {
                                    setState(() {
                                      _innerCDNView?.fit = fit;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                '融云 CDN 流',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.dp,
                            ),

                            SizedBox(
                              height: 10.dp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Button(
                                  '订阅',
                                  size: 18.sp,
                                  callback: () => _subscribeInnerCDN(),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.dp,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CheckBoxes(
                                  '静音视频',
                                  checked: _muteInnerCDNStream,
                                  onChanged: _muteInnerCDNStreamAction,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.dp,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    value: _cdnVideoFps,
                                    items: videoFpsItems(),
                                    onChanged: (dynamic fps) => _changeInnerCDNFps(fps),
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    value: _cdnVideoResolution,
                                    items: videoResolutionItems(),
                                    onChanged: (dynamic resolution) => _changeInnerCDNResolution(resolution),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20.dp,),
              _seiText.length > 0 ? Container(
                height: 80.dp,
                  child: ListView(
                    children: [
                      Text('收到的SEI内容： \n $_seiText')
                    ],
                  )
              ) : Container(),
              SizedBox(height: 20.dp,),
              StatefulBuilder(builder: (context, setter) {
                _remoteAudioStatsStateSetter = setter;
                return RemoteAudioStatsTable(_remoteAudioStats);
              }),
              StatefulBuilder(builder: (context, setter) {
                _remoteVideoStatsStateSetter = setter;
                return RemoteVideoStatsTable(_remoteVideoStats);
              }),
              StatefulBuilder(builder: (context, setter) {
                _remoteUserAudioStateSetter = setter;
                return Expanded(
                  child: ListView.separated(
                    itemCount: _remoteUserAudioState.keys.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 5.dp,
                        color: Colors.transparent,
                      );
                    },
                    itemBuilder: (context, index) {
                      String userId = _remoteUserAudioState.keys.elementAt(index);
                      int volume = _remoteUserAudioState[userId] ?? 0;
                      return Row(
                        children: [
                          Spacer(),
                          userId.toText(),
                          VerticalDivider(
                            width: 10.dp,
                            color: Colors.transparent,
                          ),
                          '$volume'.toText(),
                          Spacer(),
                        ],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      onWillPop: _exit,
    );
  }

  void _showMessagePanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MessagePanel(_roomId, false);
      },
    );
  }

  void _refresh() async {
    Loading.show(context);
    if (_type == RCRTCMediaType.audio) {
      _host = null;
      await Utils.engine?.removeLiveMixView();
    } else {
      _host = await RCRTCView.create(
        mirror: false,
        onFirstFrameRendered: () {
          print('AudiencePage onFirstFrameRendered');
        },
      );
      if (_host != null) {
        await Utils.engine?.setLiveMixView(_host!);
      }
    }
    presenter.subscribe(_type, _tiny);
    setState(() {});
  }

  void _muteAudioStream() async {
    bool result = await presenter.mute(RCRTCMediaType.audio, !_muteAudio);
    setState(() {
      _muteAudio = result;
    });
  }

  void _muteVideoStream() async {
    bool result = await presenter.mute(RCRTCMediaType.video, !_muteVideo);
    setState(() {
      _muteVideo = result;
    });
  }

  void _switchToHost() async {
    Loading.show(context);
    Utils.engine?.onLiveRoleSwitched = (RCRTCRole role, int code, String? errMsg) {
      Loading.dismiss(context);
      if (code != 0) {
        '切换为主播失败：$code'.toast();
        return;
      }
      Map<String, dynamic> arguments = {
        'id': _roomId,
        'config': Config.config().toJson(),
      };
      Navigator.pushReplacementNamed(
        context,
        RouterManager.HOST,
        arguments: arguments,
      );
    };
    int code = await Utils.engine?.switchLiveRole(RCRTCRole.live_broadcaster) ?? -1;
    if (code != 0) {
      Loading.dismiss(context);
      '切换为主播失败：$code'.toast();
    }
  }

  void _changeSpeaker() async {
    bool result = await presenter.changeSpeaker(!_speaker);
    setState(() {
      _speaker = result;
    });
  }

  void _resetView() async {
    BoxFit? fit = _host?.fit;
    bool? mirror = _host?.mirror;
    _host = null;
    await Utils.engine?.removeLiveMixView();
    _host = await RCRTCView.create(
      fit: fit ?? BoxFit.contain,
      mirror: mirror ?? false,
    );
    if (_host != null) await Utils.engine?.setLiveMixView(_host!);
    setState(() {});
  }

  Future<bool> _exit() async {
    Loading.show(context);
    await Utils.engine?.setStatsListener(null);
    await presenter.exit();
    Loading.dismiss(context);
    Navigator.pop(context);
    return Future.value(false);
  }

  void _subscribeInnerCDN() async {
    BoxFit? fit = _innerCDNView?.fit;
    bool? mirror = _innerCDNView?.mirror;
    _innerCDNView = await RCRTCView.create(
      mirror: mirror ?? false,
      fit: fit ?? BoxFit.cover,
      onFirstFrameRendered: () {
        print('AudiencePage onFirstFrameRendered');
      },
    );
    if (_innerCDNView != null) {
      await Utils.engine?.setLiveMixInnerCdnStreamView(_innerCDNView!);
    }
    presenter.subscribeInnerCDN();
    setState(() {});
  }

  void _changeInnerCDNFps(RCRTCVideoFps fps) async {
    Loading.show(context);
    int code = await presenter.setLocalLiveMixInnerCdnVideoFps(fps);
    Loading.dismiss(context);
    if (code != 0) {
      'changeInnerCDNFps error $code'.toast();
      return;
    }
    setState(() {
      _cdnVideoFps = fps;
    });
  }

  void _changeInnerCDNResolution(RCRTCVideoResolution resolution) async {
    Loading.show(context);
    int code = await presenter.setLocalLiveMixInnerCdnVideoResolution(resolution);
    Loading.dismiss(context);
    if (code != 0) {
      'changeInnerCDNResolution error $code'.toast();
      return;
    }
    setState(() {
      _cdnVideoResolution = resolution;
    });
  }

  void _muteInnerCDNStreamAction(bool checked) async {
    int result = await Utils.engine?.muteLiveMixInnerCdnStream(checked) ?? -1;
    if (result == 0) {
      setState(() {
        _muteInnerCDNStream = checked;
      });
    }
  }

  @override
  void onConnected() {
    Loading.dismiss(context);
    'Subscribe success!'.toast();
  }

  @override
  void onConnectError(int? code, String? message) {
    Loading.dismiss(context);
    'Subscribe error, code = $code, message = $message'.toast();
  }

  @override
  void onNetworkStats(RCRTCNetworkStats stats) {}

  @override
  void onLocalAudioStats(RCRTCLocalAudioStats stats) {}

  @override
  void onLocalVideoStats(RCRTCLocalVideoStats stats) {}

  @override
  void onRemoteAudioStats(String roomId, String userId, RCRTCRemoteAudioStats stats) {}

  @override
  void onRemoteVideoStats(String roomId, String userId, RCRTCRemoteVideoStats stats) {}

  @override
  void onLiveMixAudioStats(RCRTCRemoteAudioStats stats) {
    _remoteAudioStatsStateSetter?.call(() {
      _remoteAudioStats = stats;
    });
  }

  @override
  void onLiveMixVideoStats(RCRTCRemoteVideoStats stats) {
    _remoteVideoStatsStateSetter?.call(() {
      _remoteVideoStats = stats;
    });
  }

  @override
  void onLiveMixMemberAudioStats(String userId, int volume) {
    _remoteUserAudioStateSetter?.call(() {
      _remoteUserAudioState[userId] = volume;
    });
  }

  @override
  void onLiveMixMemberCustomAudioStats(String userId, String tag, int volume) {
    _remoteUserAudioStateSetter?.call(() {
      _remoteUserAudioState['$userId@$tag'] = volume;
    });
  }

  @override
  void onLocalCustomAudioStats(String tag, RCRTCLocalAudioStats stats) {}

  @override
  void onLocalCustomVideoStats(String tag, RCRTCLocalVideoStats stats) {}

  @override
  void onRemoteCustomAudioStats(String roomId, String userId, String tag, RCRTCRemoteAudioStats stats) {}

  @override
  void onRemoteCustomVideoStats(String roomId, String userId, String tag, RCRTCRemoteVideoStats stats) {}

  late String _roomId;
  RCRTCView? _host;
  RCRTCView? _innerCDNView;
  RCRTCMediaType _type = RCRTCMediaType.audio_video;
  bool _tiny = false;
  bool _speaker = false;

  StateSetter? _remoteAudioStatsStateSetter;
  StateSetter? _remoteVideoStatsStateSetter;
  StateSetter? _remoteUserAudioStateSetter;

  RCRTCRemoteAudioStats? _remoteAudioStats;
  RCRTCRemoteVideoStats? _remoteVideoStats;
  Map<String, int> _remoteUserAudioState = {};

  bool _muteAudio = false;
  bool _muteVideo = false;
  bool _muteInnerCDNStream = false;

  RCRTCVideoResolution _cdnVideoResolution = RCRTCVideoResolution.resolution_480_640;
  RCRTCVideoFps _cdnVideoFps = RCRTCVideoFps.fps_15;

  String _seiText = '';
}
