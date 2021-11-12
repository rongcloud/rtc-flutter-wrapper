import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/ui/loading.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/extension.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/global_config.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/router/router.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/widgets/ui.dart';

import 'connect_page_contract.dart';
import 'connect_page_presenter.dart';

class ConnectPage extends AbstractView {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends AbstractViewState<ConnectPagePresenter, ConnectPage> implements View {
  @override
  ConnectPagePresenter createPresenter() {
    return ConnectPagePresenter();
  }

  @override
  void dispose() {
    if (_connected) _disconnect();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'RTC Flutter Demo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outlined,
            ),
            onPressed: () => _showInfo(context),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.dp),
        child: Column(
          children: [
            InputBox(
              hint: 'Input a user name.',
              controller: _userInputController,
            ),
            Divider(
              height: 15.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                Spacer(),
                Button(
                  _connected ? '断开链接' : '链接',
                  callback: () => _connected ? _disconnect() : _connect(),
                ),
                Spacer(),
              ],
            ),
            _connected
                ? Container(
                    padding: EdgeInsets.only(top: 20.dp),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radios(
                              '会议模式',
                              value: RCRTCRole.meeting_member,
                              groupValue: _role,
                              onChanged: (dynamic value) {
                                _inputController.text = '';
                                setState(() {
                                  _role = value;
                                });
                              },
                            ),
                            Spacer(),
                            Radios(
                              '主播模式',
                              value: RCRTCRole.live_broadcaster,
                              groupValue: _role,
                              onChanged: (dynamic value) {
                                _inputController.text = '';
                                setState(() {
                                  _role = value;
                                });
                              },
                            ),
                            Spacer(),
                            Radios(
                              '观众模式',
                              value: RCRTCRole.live_audience,
                              groupValue: _role,
                              onChanged: (dynamic value) {
                                _inputController.text = '';
                                setState(() {
                                  _role = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Divider(
                          height: 15.dp,
                          color: Colors.transparent,
                        ),
                        _buildArea(context),
                        Divider(
                          height: 15.dp,
                          color: Colors.transparent,
                        ),
                        Row(
                          children: [
                            CheckBoxes(
                              'SRTP加密',
                              checked: _srtp,
                              onChanged: (checked) {
                                setState(() {
                                  _srtp = checked;
                                });
                              },
                            ),
                            Spacer(),
                            _role != RCRTCRole.live_audience
                                ? CheckBoxes(
                                    '大小流',
                                    checked: _config.enableTinyStream,
                                    onChanged: (checked) {
                                      setState(() {
                                        _config.enableTinyStream = checked;
                                      });
                                    },
                                  )
                                : Container(),
                            _role != RCRTCRole.live_audience ? Spacer() : Container(),
                          ],
                        ),
                        Divider(
                          height: 15.dp,
                          color: Colors.transparent,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Button(
                              _getAction(),
                              callback: _action,
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    String info = '默认参数: \n'
        'App Key:${GlobalConfig.appKey}\n'
        'Nav Server:${GlobalConfig.navServer}\n'
        'File Server:${GlobalConfig.fileServer}\n'
        'Media Server:${GlobalConfig.mediaServer.isEmpty ? '自动获取' : GlobalConfig.mediaServer}\n';
    if (_connected)
      info += '当前使用: \n'
          'App Key:${DefaultData.user!.key}\n'
          'Nav Server:${DefaultData.user!.navigate}\n'
          'File Server:${DefaultData.user!.file}\n'
          'Media Server:${DefaultData.user!.media!.isEmpty ? '自动获取' : DefaultData.user!.media}\n';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('默认配置'),
          content: SelectableText(
            info,
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _disconnect() {
    presenter.disconnect();
    setState(() {
      _connected = false;
    });
  }

  void _connect() {
    FocusScope.of(context).requestFocus(FocusNode());

    String name = _userInputController.text;

    if (name.isEmpty) return 'User Name Should not be null!'.toast();

    Loading.show(context);
    presenter.login(name);
  }

  String _getHint() {
    switch (_role) {
      case RCRTCRole.meeting_member:
        return 'Meeting id';
      case RCRTCRole.live_broadcaster:
        return 'Room id';
      case RCRTCRole.live_audience:
        return 'Room id';
    }
  }

  Widget _buildArea(BuildContext context) {
    switch (_role) {
      case RCRTCRole.meeting_member:
        return InputBox(
          hint: '${_getHint()}.',
          controller: _inputController,
        );
      case RCRTCRole.live_broadcaster:
        return Column(
          children: [
            InputBox(
              hint: '${_getHint()}.',
              controller: _inputController,
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                Spacer(),
                Radios(
                  '音视频模式',
                  value: RCRTCMediaType.audio_video,
                  groupValue: _type,
                  onChanged: (dynamic value) {
                    setState(() {
                      _type = value;
                    });
                  },
                ),
                Spacer(),
                Radios(
                  '音频模式',
                  value: RCRTCMediaType.audio,
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
          ],
        );
      case RCRTCRole.live_audience:
        return Row(
          children: [
            Expanded(
              child: InputBox(
                hint: '${_getHint()}.',
                controller: _inputController,
              ),
            ),
          ],
        );
    }
  }

  String _getAction() {
    switch (_role) {
      case RCRTCRole.meeting_member:
        return '加入会议';
      case RCRTCRole.live_broadcaster:
        return '开始直播';
      case RCRTCRole.live_audience:
        return '观看直播';
    }
  }

  void _action() {
    String info = _inputController.text;
    if (info.isEmpty) return '${_getHint()} should not be null!'.toast();
    Loading.show(context);
    RCRTCMediaType type = _role == RCRTCRole.live_broadcaster ? _type : RCRTCMediaType.audio_video;
    presenter.action(info, type, _role, _config.enableTinyStream, false, _srtp);
  }

  @override
  void onConnected(String? id) {
    Loading.dismiss(context);
    'IM Connected.'.toast();
    setState(() {
      _connected = true;
    });
  }

  @override
  void onConnectError(int code, String? id) {
    Loading.dismiss(context);
    'IM Connect Error, code = $code'.toast();
    setState(() {
      _connected = false;
    });
  }

  void onDone(String id) {
    Loading.dismiss(context);
    switch (_role) {
      case RCRTCRole.meeting_member:
        _toMeeting(id);
        break;
      case RCRTCRole.live_broadcaster:
        _toHost(id);
        break;
      case RCRTCRole.live_audience:
        _toAudience(id);
        break;
    }
  }

  void _toMeeting(String id) {
    Map<String, dynamic> arguments = {
      'id': id,
      'config': _config.toJson(),
    };
    Navigator.pushNamed(
      context,
      RouterManager.MEETING,
      arguments: arguments,
    );
  }

  void _toHost(String id) {
    Map<String, dynamic> arguments = {
      'id': id,
      'config': _config.toJson(),
    };
    Navigator.pushNamed(
      context,
      RouterManager.HOST,
      arguments: arguments,
    );
  }

  void _toAudience(String id) {
    Navigator.pushNamed(
      context,
      RouterManager.AUDIENCE,
      arguments: id,
    );
  }

  void onError(int code, String? info) {
    Loading.dismiss(context);
    '${_getAction()}失败, Code = $code, Info = $info'.toast();
  }

  TextEditingController _userInputController = TextEditingController();
  TextEditingController _inputController = TextEditingController();

  bool _connected = false;
  RCRTCRole _role = RCRTCRole.meeting_member;
  RCRTCMediaType _type = RCRTCMediaType.audio_video;

  Config _config = Config.config();

  bool _srtp = false;
}
