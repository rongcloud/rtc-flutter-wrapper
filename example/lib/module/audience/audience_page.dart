import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/ui/loading.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/extension.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/widgets/ui.dart';

import 'audience_page_contract.dart';
import 'audience_page_presenter.dart';

class AudiencePage extends AbstractView {
  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends AbstractViewState<AudiencePagePresenter, AudiencePage> implements View, RCRTCStatsListener {
  @override
  AudiencePagePresenter createPresenter() {
    return AudiencePagePresenter();
  }

  @override
  void init(BuildContext context) {
    super.init(context);

    _roomId = ModalRoute.of(context)?.settings.arguments as String;

    Utils.engine?.setStatsListener(this);
  }

  @override
  void dispose() {
    _remoteAudioStatsStateSetter = null;
    _remoteVideoStatsStateSetter = null;
    _remoteAudioStats = null;
    _remoteVideoStats = null;
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
              icon: Icon(
                Icons.message,
              ),
              onPressed: () => _showMessagePanel(context),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                Spacer(),
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
                Spacer(),
              ],
            ),
            Divider(
              height: 5.dp,
              color: Colors.transparent,
            ),
            _type != RCRTCMediaType.audio
                ? Row(
                    children: [
                      Spacer(),
                      CheckBoxes(
                        '订阅小流',
                        checked: _tiny,
                        onChanged: (checked) {
                          setState(() {
                            _tiny = checked;
                          });
                        },
                      ),
                      Spacer(),
                    ],
                  )
                : Container(),
            _type != RCRTCMediaType.audio
                ? Divider(
                    height: 15.dp,
                    color: Colors.transparent,
                  )
                : Container(),
            Row(
              children: [
                Spacer(),
                Button(
                  '订阅',
                  callback: () => _refresh(),
                ),
                Spacer(),
              ],
            ),
            Divider(
              height: 5.dp,
              color: Colors.transparent,
            ),
            AspectRatio(
              aspectRatio: 3 / 2,
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
            Divider(
              height: 5.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                Spacer(),
                Button(
                  _speaker ? '扬声器' : '听筒',
                  size: 15.sp,
                  callback: () => _changeSpeaker(),
                ),
                Spacer(),
              ],
            ),
            Divider(
              height: 5.dp,
              color: Colors.transparent,
            ),
            StatefulBuilder(builder: (context, setter) {
              _remoteAudioStatsStateSetter = setter;
              return RemoteAudioStatsTable(_remoteAudioStats);
            }),
            StatefulBuilder(builder: (context, setter) {
              _remoteVideoStatsStateSetter = setter;
              return RemoteVideoStatsTable(_remoteVideoStats);
            }),
          ],
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

  void _changeSpeaker() async {
    bool result = await presenter.changeSpeaker(!_speaker);
    setState(() {
      _speaker = result;
    });
  }

  Future<bool> _exit() async {
    Loading.show(context);
    await Utils.engine?.setStatsListener(null);
    await presenter.exit();
    Loading.dismiss(context);
    Navigator.pop(context);
    return Future.value(false);
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
  void onRemoteAudioStats(String userId, RCRTCRemoteAudioStats stats) {
    _remoteAudioStatsStateSetter?.call(() {
      _remoteAudioStats = stats;
    });
  }

  @override
  void onRemoteVideoStats(String userId, RCRTCRemoteVideoStats stats) {
    _remoteVideoStatsStateSetter?.call(() {
      _remoteVideoStats = stats;
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
  RCRTCView? _host;
  RCRTCMediaType _type = RCRTCMediaType.audio_video;
  bool _tiny = false;
  bool _speaker = false;

  StateSetter? _remoteAudioStatsStateSetter;
  StateSetter? _remoteVideoStatsStateSetter;

  RCRTCRemoteAudioStats? _remoteAudioStats;
  RCRTCRemoteVideoStats? _remoteVideoStats;
}
