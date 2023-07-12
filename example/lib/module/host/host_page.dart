import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:path/path.dart' as Path;
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/template/mvp/view.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/ui/loading.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/extension.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/main.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/router/router.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/widgets/ui.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'host_page_contract.dart';
import 'host_page_presenter.dart';

class HostPage extends AbstractView {
  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends AbstractViewState<HostPagePresenter, HostPage> implements RCView, RCRTCStatsListener {
  @override
  HostPagePresenter createPresenter() {
    return HostPagePresenter();
  }

  @override
  void init(BuildContext context) {
    super.init(context);

    Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _roomId = arguments['id'];
    _config = Config.fromJson(arguments['config']);
    _yuv = arguments['yuv'] ?? false;
    _tinyConfig = RCRTCVideoConfig.create(
      minBitrate: 100,
      maxBitrate: 500,
      fps: RCRTCVideoFps.fps_15,
      resolution: RCRTCVideoResolution.resolution_180_320,
    );
    _customConfig = RCRTCVideoConfig.create();

    Utils.engine?.setStatsListener(this);

    Utils.engine?.onSeiReceived = (String roomId, String userId, String sei) {
      print('onSeiReceived: $roomId, $userId, $sei');
    };
  }

  @override
  void dispose() {
    _remotes.clear();
    _remoteCustoms.clear();

    _networkStats = null;
    _localAudioStats = null;
    _localVideoStats.clear();
    _remoteAudioStats.clear();
    _remoteVideoStats.clear();
    _remoteCustomAudioStats.clear();
    _remoteCustomVideoStats.clear();

    _networkStatsStateSetter = null;
    _localAudioStatsStateSetter = null;
    _localVideoStatsStateSetter = null;
    _remoteAudioStatsStateSetters.clear();
    _remoteVideoStatsStateSetters.clear();
    _remoteCustomAudioStatsStateSetters.clear();
    _remoteCustomVideoStatsStateSetters.clear();

    _sendSeiTimer?.cancel();
    _sendSeiTimer = null;

    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            '主播房间：$_roomId',
            style: TextStyle(fontSize: 15.sp),
          ),
          leading: BackButton(),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('跨房间连麦'),
                trailing: Icon(Icons.link),
                onTap: () => _showBandOption(context),
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('第三方CDN'),
                trailing: Icon(Icons.alt_route),
                onTap: _published ? () => _showCDNInfo(context) : null,
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Row(
                  children: [
                    Text('融云内置CDN'),
                    Switch(value: _enableInnerCDN, onChanged: _changeEnableInnerCDN)
                  ],
                ),
                trailing: Icon(Icons.alt_route),
                onTap: null,
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('合流设置'),
                trailing: Icon(Icons.picture_in_picture),
                onTap: _published ? () => _showMixInfo(context) : null,
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('设置水印'),
                trailing: Icon(Icons.image),
                onTap: () => _setWatermark(context),
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('Sei 功能'),
                trailing: Icon(Icons.closed_caption),
                onTap: () => _showSeiConfig(context),
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('切换为观众'),
                trailing: Icon(Icons.groups),
                onTap: () => _switchToAudienceRole(context),
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('聊天室'),
                trailing: Icon(Icons.message),
                onTap: () => _showMessagePanel(context),
              ),
              SizedBox(height: 10.dp,),
              ListTile(
                tileColor: Color(0xFFEEEEEE),
                title: Text('切换音频模式'),
                trailing: Icon(Icons.message),
                onTap: () => _showAudioConfigPanel(context),
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
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
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 170.dp,
                              height: 150.dp,
                              color: Colors.yellow,
                              child: Stack(
                                children: [
                                  _custom ?? Container(),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 5.dp,
                                        top: 5.dp,
                                      ),
                                      child: Text(
                                        '${DefaultData.user!.id.replaceAll('_', '')}Custom',
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
                                        top: 25.dp,
                                      ),
                                      child: BoxFitChooser(
                                        fit: _custom?.fit ?? BoxFit.contain,
                                        onSelected: (fit) {
                                          setState(() {
                                            _custom?.fit = fit;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              width: 10.dp,
                              color: Colors.transparent,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150.dp,
                                  child: '已选文件:\n${_customPath != null ? Path.basename(_customPath!) : null} '.toText(),
                                ),
                                '选择文件'.onClick(() => _selectMovie(context), color: Colors.blue),
                                Row(
                                  children: [
                                    CheckBoxes(
                                      'YUV数据',
                                      enable: _yuv && !_customPublished,
                                      checked: _localYuv,
                                      onChanged: (checked) => setState(() {
                                        _localYuv = checked;
                                      }),
                                    ),
                                    VerticalDivider(
                                      width: 10.dp,
                                      color: Colors.transparent,
                                    ),
                                    Button(
                                      '${_customPublished ? '取消发布' : '发布'}',
                                      size: 15.dp,
                                      callback: () => _customAction(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isDense: true,
                                        value: _customConfig.fps,
                                        items: videoFpsItems(),
                                        onChanged: (dynamic fps) => _changeCustomFps(fps),
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isDense: true,
                                        value: _customConfig.resolution,
                                        items: videoResolutionItems(),
                                        onChanged: (dynamic resolution) => _changeCustomResolution(resolution),
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
                                        value: _customConfig.minBitrate,
                                        items: minVideoKbpsItems(),
                                        onChanged: (dynamic kbps) => _changeCustomMinBitrate(kbps),
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
                                        value: _customConfig.maxBitrate,
                                        items: maxVideoKbpsItems(),
                                        onChanged: (dynamic kbps) => _changeCustomMaxBitrate(kbps),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                    Divider(
                      height: 10.dp,
                      color: Colors.black,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: Utils.users.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 5.dp,
                          color: Colors.transparent,
                        );
                      },
                      itemBuilder: (context, index) {
                        UserState user = Utils.users[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                            fit: _remotes[user.id]?.fit ?? BoxFit.cover,
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
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: user.customs.length,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 5.dp,
                                  color: Colors.transparent,
                                );
                              },
                              itemBuilder: (context, index) {
                                CustomState custom = user.customs[index];
                                String key = '${user.id}${custom.tag}';
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200.dp,
                                      height: 160.dp,
                                      color: Colors.yellow,
                                      child: Stack(
                                        children: [
                                          _remoteCustoms[key] ?? Container(),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 5.dp,
                                                top: 5.dp,
                                              ),
                                              child: Text(
                                                '${user.customs[index].tag}',
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
                                                fit: _remoteCustoms[key]?.fit ?? BoxFit.cover,
                                                onSelected: (fit) {
                                                  setState(() {
                                                    _remoteCustoms[key]?.fit = fit;
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
                                                'YUV数据',
                                                enable: _yuv && !custom.videoSubscribed,
                                                checked: custom.yuv,
                                                onChanged: (checked) => setState(() {
                                                  custom.yuv = checked;
                                                }),
                                              ),
                                              Spacer(),
                                              CheckBoxes(
                                                '订阅视频',
                                                enable: custom.videoPublished,
                                                checked: custom.videoSubscribed,
                                                onChanged: (subscribe) => _changeRemoteCustomVideo(user, custom, subscribe),
                                              ),
                                            ],
                                          ),
                                          VerticalDivider(
                                            width: 2.dp,
                                            color: Colors.transparent,
                                          ),
                                          Row(
                                            children: [
                                              CheckBoxes(
                                                '订阅音频',
                                                enable: custom.audioPublished,
                                                checked: custom.audioSubscribed,
                                                onChanged: (subscribe) => _changeRemoteCustomAudio(user, custom, subscribe),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          StatefulBuilder(builder: (context, setter) {
                                            _remoteCustomAudioStatsStateSetters['${user.id}@${custom.tag}'] = setter;
                                            return RemoteAudioStatsTable(_remoteCustomAudioStats['${user.id}@${custom.tag}']);
                                          }),
                                          StatefulBuilder(builder: (context, setter) {
                                            _remoteCustomVideoStatsStateSetters['${user.id}@${custom.tag}'] = setter;
                                            return RemoteVideoStatsTable(_remoteCustomVideoStats['${user.id}@${custom.tag}']);
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      onWillPop: _exit,
    );
  }

  void _showBandOption(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return JoinSubRoomPanel(
          Utils.engine!,
          _roomId,
          Utils.joinedSubRooms,
          Utils.joinableSubRooms,
        );
      },
    );
  }

  void _showCDNInfo(BuildContext context) async {
    Loading.show(context);
    final String? id = await Utils.engine?.getSessionId();
    if (id?.isEmpty ?? true) return "Session Id is NULL!!".toast();
    Loading.dismiss(context);
    showDialog(
      context: context,
      builder: (context) {
        return CDNConfig(
          id: id!,
          engine: Utils.engine!,
          cdnList: _cdnList
        );
      },
    );
  }

  void _showMixInfo(BuildContext context) {
    List<LiveMixItem> items = [];
    items.add(LiveMixItem(DefaultData.user!.id, null));
    if (_customPublished) {
      items.add(LiveMixItem(DefaultData.user!.id, '${DefaultData.user!.id.replaceAll('_', '')}Custom'));
    }
    Utils.users.forEach((user) {
      items.add(LiveMixItem(user.id, null));
      user.customs.forEach((custom) {
        items.add(LiveMixItem(user.id, custom.tag));
      });
    });
    showDialog(
      context: context,
      builder: (context) {
        return LiveMixPanel(Utils.engine!, _liveMix, items);
      },
    );
  }

  void _setWatermark(BuildContext context) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return Watermark(engine: Utils.engine!);
      },
    );
  }

  void _showSeiConfig(BuildContext context) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return Sei(Utils.engine!, _seiConfig);
        }
    );
  }

  void _switchToAudienceRole(BuildContext context) async {
    Loading.show(context);
    Utils.engine?.onLiveRoleSwitched = (RCRTCRole role, int code, String? errMsg) {
      Loading.dismiss(context);
      if (code != 0) {
        '切换为观众失败：$code - $errMsg'.toast();
        return;
      }
      Navigator.pushReplacementNamed(
        context,
        RouterManager.AUDIENCE,
        arguments: _roomId,
      );
    };
    int code = await Utils.engine?.switchLiveRole(RCRTCRole.live_audience) ?? -1;
    if (code != 0) {
      Loading.dismiss(context);
      '切换失败'.toast();
    }
  }

  void _showMessagePanel(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return MessagePanel(_roomId, true);
      },
    );
  }

  void _showAudioConfigPanel(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AudioConfigPanel(Utils.engine);
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
        Utils.engine?.setLocalView(_local!);
      }
    } else {
      _local = null;
      Utils.engine?.removeLocalView();
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
      '${publish ? 'Publish' : 'Unpublish'} Audio Stream Error - $result'.toast();
      publish = !publish;
    }
    setState(() {
      _config.audio = publish;
      _published = _config.audio || _config.video;
    });
    Loading.dismiss(context);
  }

  void _changeVideo(bool publish) async {
    Loading.show(context);
    int result = await presenter.changeVideo(publish);
    if (result != 0) {
      '${publish ? 'Publish' : 'Unpublish'} Video Stream Error - $result'.toast();
      publish = !publish;
    }
    setState(() {
      _config.video = publish;
      _published = _config.audio || _config.video;
    });
    Loading.dismiss(context);
  }

  void _changeFrontCamera(bool front) async {
    bool result = await presenter.changeFrontCamera(front);
    setState(() {
      _config.frontCamera = result;
    });
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

  void _selectMovie(BuildContext context) async {
    AssetPickerConfig config = const AssetPickerConfig(maxAssets: 1, requestType: RequestType.video);
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(context, pickerConfig: config);
    File? file = await assets?.first.originFile;
    setState(() {
      _customPath = file?.absolute.path;
    });
  }

  void _customAction() {
    if (!_customPublished) {
      if (_customPath?.isEmpty ?? true) {
        return '请选择视频文件！'.toast();
      }
      Loading.show(context);
      presenter.publishCustomVideo(_roomId, _customPath!, _customConfig, _localYuv);
    } else {
      Loading.show(context);
      presenter.unpublishCustomVideo();
    }
  }

  void _changeCustomFps(RCRTCVideoFps fps) async {
    _customConfig.fps = fps;
    await presenter.changeCustomConfig(_customConfig);
    setState(() {});
  }

  void _changeCustomResolution(RCRTCVideoResolution resolution) async {
    _customConfig.resolution = resolution;
    await presenter.changeCustomConfig(_customConfig);
    setState(() {});
  }

  void _changeCustomMinBitrate(int kbps) async {
    _customConfig.minBitrate = kbps;
    await presenter.changeCustomConfig(_customConfig);
    setState(() {});
  }

  void _changeCustomMaxBitrate(int kbps) {
    _customConfig.maxBitrate = kbps;
    presenter.changeCustomConfig(_customConfig);
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

  void _changeRemoteCustomVideo(UserState user, CustomState custom, bool subscribe) async {
    Loading.show(context);
    custom.videoSubscribed = await presenter.changeRemoteCustomVideoStatus(_roomId, user.id, custom.tag, custom.yuv, subscribe);
    String key = '${user.id}${custom.tag}';
    if (custom.videoSubscribed) {
      if (_remoteCustoms.containsKey(key)) _remoteCustoms.remove(key);
      RCRTCView view = await RCRTCView.create(mirror: false);
      _remoteCustoms[key] = view;
      await Utils.engine?.setRemoteCustomStreamView(user.id, custom.tag, view);
    } else {
      if (_remoteCustoms.containsKey(key)) {
        _remoteCustoms.remove(key);
        await Utils.engine?.removeRemoteCustomStreamView(user.id, custom.tag);
      }
    }
    setState(() {});
    Loading.dismiss(context);
  }

  void _changeRemoteCustomAudio(UserState user, CustomState custom, bool subscribe) async {
    Loading.show(context);
    custom.audioSubscribed = await presenter.changeRemoteCustomAudioStatus(_roomId, user.id, custom.tag, subscribe);
    setState(() {});
    Loading.dismiss(context);
  }

  Future<bool> _exit() async {
    Loading.show(context);
    await Main.getInstance().disableLocalCustomYuv();
    await Main.getInstance().disableAllRemoteCustomYuv();
    await Utils.engine?.setStatsListener(null);
    presenter.exit();
    return Future.value(false);
  }

  void _changeEnableInnerCDN(bool enable) async {
    if (!_published) {
      '请先发布视频资源'.toast();
      return;
    }
    Loading.show(context);
    int result = await presenter.enableInnerCDN(enable);
    Loading.dismiss(context);
    if (result == 0) {
      setState(() {
        _enableInnerCDN = enable;
      });
    } else {
      '开关内置CDN error $result'.toast();
    }
  }

  @override
  void onUserListChanged() async {
    await _updateRemoteView();
    setState(() {});
  }

  Future<void> _updateRemoteView() {
    Completer<void> completer = Completer();
    _remotes.clear();
    _remoteCustoms.clear();
    int count = Utils.users.length;
    if (count > 0) {
      Utils.users.forEach((user) async {
        if (user.videoSubscribed) {
          RCRTCView view = await RCRTCView.create(mirror: false);
          Utils.engine?.setRemoteView(user.id, view);
          _remotes[user.id] = view;
        }
        user.customs.forEach((custom) async {
          if (custom.videoSubscribed) {
            RCRTCView view = await RCRTCView.create(mirror: false);
            Utils.engine?.setRemoteCustomStreamView(user.id, custom.tag, view);
            _remoteCustoms['${user.id}${custom.tag}'] = view;
          }
        });
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
  void onCustomVideoPublished() async {
    Loading.dismiss(context);
    _custom = await RCRTCView.create(mirror: false);
    int code = await Utils.engine?.setLocalCustomStreamView('${DefaultData.user!.id.replaceAll('_', '')}Custom', _custom!) ?? -1;
    if (code != 0) '设置自定义视频预览失败, $code'.toast();
    setState(() {
      _customPublished = true;
    });
  }

  @override
  void onCustomVideoPublishedError(int code) {
    Loading.dismiss(context);
    '发布自定义视频失败, $code'.toast();
  }

  @override
  void onCustomVideoUnpublished() async {
    await Main.getInstance().disableLocalCustomYuv();
    Loading.dismiss(context);
    setState(() {
      _custom = null;
      _customPublished = false;
    });
  }

  @override
  void onCustomVideoUnpublishedError(int code) {
    Loading.dismiss(context);
    '取消发布自定义视频失败, $code'.toast();
  }

  @override
  void onUserCustomStateChanged(String id, String tag, bool audio, bool video) async {
    if (!video) {
      await Main.getInstance().disableRemoteCustomYuv(id, tag);
      String key = '$id$tag';
      if (_remoteCustoms.containsKey(key)) {
        _remoteCustoms.remove(key);
        await Utils.engine?.removeRemoteCustomStreamView(id, tag);
      }
    }
    setState(() {});
  }

  @override
  void onReceiveJoinRequest(String roomId, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('收到连麦请求'),
          content: Text('来自$roomId的$userId邀请你一起连麦，是否同意？'),
          actions: [
            TextButton(
              child: Text('同意'),
              onPressed: () => _bandAction(context, roomId, userId, true),
            ),
            TextButton(
              child: Text('拒绝'),
              onPressed: () => _bandAction(context, roomId, userId, false),
            ),
          ],
        );
      },
    );
  }

  void _bandAction(BuildContext context, String roomId, String userId, bool agree) async {
    Navigator.pop(context);
    Loading.show(context);
    int ret = await presenter.responseJoinSubRoom(roomId, userId, agree);
    Loading.dismiss(context);
    if (ret == 0 && agree) {
      Utils.joinSubRoom(context, roomId);
    }
    if (ret != 0) {
      '响应加入子房间请求失败, code:$ret'.toast();
    }
  }

  @override
  void onReceiveJoinResponse(String roomId, String userId, bool agree) {
    if (agree) {
      '$roomId的$userId同意了你的加入申请，正在加入..'.toast();
      Utils.joinSubRoom(context, roomId);
    } else {
      '$roomId的$userId拒绝了你的加入申请'.toast();
    }
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
  void onRemoteAudioStats(String roomId, String userId, RCRTCRemoteAudioStats stats) {
    _remoteAudioStatsStateSetters[userId]?.call(() {
      _remoteAudioStats[userId] = stats;
    });
  }

  @override
  void onRemoteVideoStats(String roomId, String userId, RCRTCRemoteVideoStats stats) {
    _remoteVideoStatsStateSetters[userId]?.call(() {
      _remoteVideoStats[userId] = stats;
    });
  }

  @override
  void onLiveMixAudioStats(RCRTCRemoteAudioStats stats) {}

  @override
  void onLiveMixVideoStats(RCRTCRemoteVideoStats stats) {}

  @override
  void onLiveMixMemberAudioStats(String userId, int volume) {}

  @override
  void onLiveMixMemberCustomAudioStats(String userId, String tag, int volume) {}

  @override
  void onLocalCustomAudioStats(String tag, RCRTCLocalAudioStats stats) {}

  @override
  void onLocalCustomVideoStats(String tag, RCRTCLocalVideoStats stats) {}

  @override
  void onRemoteCustomAudioStats(String roomId, String userId, String tag, RCRTCRemoteAudioStats stats) {
    _remoteCustomAudioStatsStateSetters['$userId@$tag']?.call(() {
      _remoteCustomAudioStats['$userId@$tag'] = stats;
    });
  }

  @override
  void onRemoteCustomVideoStats(String roomId, String userId, String tag, RCRTCRemoteVideoStats stats) {
    _remoteCustomVideoStatsStateSetters['$userId@$tag']?.call(() {
      _remoteCustomVideoStats['$userId@$tag'] = stats;
    });
    Main.getInstance().writeReceiveVideoFps(userId, tag, '${stats.fps}');
    Main.getInstance().writeReceiveVideoBitrate(userId, tag, '${stats.bitrate}');
  }

  final GlobalKey<_HostPageState> _scaffoldKey = new GlobalKey<_HostPageState>();

  late String _roomId;
  late Config _config;
  late RCRTCVideoConfig _tinyConfig;
  bool _published = false;
  RCRTCView? _local;
  Map<String, RCRTCView?> _remotes = {};
  List<CDNInfo> _cdnList = [];

  StateSetter? _networkStatsStateSetter;
  StateSetter? _localAudioStatsStateSetter;
  StateSetter? _localVideoStatsStateSetter;
  Map<String, StateSetter> _remoteAudioStatsStateSetters = {};
  Map<String, StateSetter> _remoteVideoStatsStateSetters = {};
  Map<String, StateSetter> _remoteCustomAudioStatsStateSetters = {};
  Map<String, StateSetter> _remoteCustomVideoStatsStateSetters = {};

  RCRTCNetworkStats? _networkStats;
  RCRTCLocalAudioStats? _localAudioStats;
  Map<bool, RCRTCLocalVideoStats> _localVideoStats = {};
  Map<String, RCRTCRemoteAudioStats> _remoteAudioStats = {};
  Map<String, RCRTCRemoteVideoStats> _remoteVideoStats = {};
  Map<String, RCRTCRemoteAudioStats> _remoteCustomAudioStats = {};
  Map<String, RCRTCRemoteVideoStats> _remoteCustomVideoStats = {};

  LiveMix _liveMix = LiveMix();

  RCRTCView? _custom;
  String? _customPath;
  bool _customPublished = false;
  late RCRTCVideoConfig _customConfig;
  bool _localYuv = false;
  Map<String, RCRTCView?> _remoteCustoms = {};

  bool _yuv = false;

  Timer? _sendSeiTimer;

  bool _enableInnerCDN = false;

  SeiConfig _seiConfig = SeiConfig();
}
