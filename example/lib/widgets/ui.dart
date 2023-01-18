import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:context_holder/context_holder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/constants.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/data/data.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/network/network.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/ui/loading.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/frame/utils/extension.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/global_config.dart';
import 'package:rongcloud_rtc_wrapper_plugin_example/utils/utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

List<DropdownMenuItem<RCRTCVideoResolution>> videoResolutionItems() {
  List<DropdownMenuItem<RCRTCVideoResolution>> items = [];
  RCRTCVideoResolution.values.forEach((resolution) {
    items.add(DropdownMenuItem(
      value: resolution,
      child: Text(
        '${ResolutionStrings[resolution.index]}',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  });
  return items;
}

List<DropdownMenuItem<RCRTCVideoFps>> videoFpsItems() {
  List<DropdownMenuItem<RCRTCVideoFps>> items = [];
  RCRTCVideoFps.values.forEach((fps) {
    items.add(DropdownMenuItem(
      value: fps,
      child: Text(
        '${FPSStrings[fps.index]}FPS',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  });
  return items;
}

List<DropdownMenuItem<int>> tinyMinVideoKbpsItems() {
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i < TinyMinVideoKbps.length; i++) {
    items.add(DropdownMenuItem(
      value: TinyMinVideoKbps[i],
      child: Text(
        '${TinyMinVideoKbps[i]}kbps',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  }
  return items;
}

List<DropdownMenuItem<int>> tinyMaxVideoKbpsItems() {
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i < TinyMaxVideoKbps.length; i++) {
    items.add(DropdownMenuItem(
      value: TinyMaxVideoKbps[i],
      child: Text(
        '${TinyMaxVideoKbps[i]}kbps',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  }
  return items;
}

List<DropdownMenuItem<int>> minVideoKbpsItems() {
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i < MinVideoKbps.length; i++) {
    items.add(DropdownMenuItem(
      value: MinVideoKbps[i],
      child: Text(
        '${MinVideoKbps[i]}kbps',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  }
  return items;
}

List<DropdownMenuItem<int>> maxVideoKbpsItems() {
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i < MaxVideoKbps.length; i++) {
    items.add(DropdownMenuItem(
      value: MaxVideoKbps[i],
      child: Text(
        '${MaxVideoKbps[i]}kbps',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  }
  return items;
}

List<DropdownMenuItem<int>> audioKbpsItems() {
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i < AudioKbps.length; i++) {
    items.add(DropdownMenuItem(
      value: AudioKbps[i],
      child: Text(
        '${AudioKbps[i]}kbps',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  }
  return items;
}

class SliderTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 5;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class InputBox extends StatelessWidget {
  InputBox({
    required this.hint,
    required this.controller,
    this.type,
    this.size,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.dp),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type ?? TextInputType.text,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          fontSize: size as double? ?? 20.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: size as double? ?? 20.sp,
            color: Colors.black.withOpacity(0.7),
            decoration: TextDecoration.none,
          ),
          contentPadding: EdgeInsets.only(
            top: 2.dp,
            bottom: 0.dp,
            left: 10.dp,
            right: 10.dp,
          ),
          isDense: true,
        ),
        inputFormatters: formatter,
      ),
    );
  }

  final String hint;
  final TextEditingController controller;
  final TextInputType? type;
  final num? size;
  final List<TextInputFormatter>? formatter;
}

class Button extends StatelessWidget {
  Button(
    this.text, {
    this.size,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.dp),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: size as double? ?? 20.sp,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      onTap: callback,
    );
  }

  final String text;
  final num? size;
  final void Function()? callback;
}

class Radios<T> extends StatelessWidget {
  Radios(
    this.text, {
    this.color = Colors.blue,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            value == groupValue
                ? Icons.radio_button_on
                : Icons.radio_button_off,
            color: color,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
      onTap: () => onChanged(value),
    );
  }

  final String text;
  final Color color;
  final T value;
  final T groupValue;
  final void Function(T value) onChanged;
}

class CheckBoxes extends StatelessWidget {
  CheckBoxes(
    this.text, {
    this.enable = true,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            enable && checked ? Icons.check_box : Icons.check_box_outline_blank,
            color: enable ? Colors.blue : Colors.grey,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              color: enable ? Colors.black : Colors.grey,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
      onTap: () => enable ? onChanged(!checked) : null,
    );
  }

  final String text;
  final bool enable;
  final bool checked;
  final void Function(bool checked) onChanged;
}

extension IconExtension on IconData {
  Widget toWidget() {
    return Icon(this);
  }

  Widget onClick(void Function() onClick) {
    return GestureDetector(
      child: this.toWidget(),
      onTap: onClick,
    );
  }
}

extension StringExtension on String {
  Widget toText({
    Color color = Colors.black,
  }) {
    return Text(
      this,
      softWrap: true,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15.sp,
        color: color,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget toSliderWithStringOnTop({
    required double current,
    double min = 0,
    required double max,
    void Function(double value)? onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          this,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(ContextHolder.currentContext).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.blue.withOpacity(0.1),
            thumbColor: Colors.lightBlue,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 5.dp,
            ),
            trackHeight: 1.dp,
            trackShape: SliderTrackShape(),
            overlayColor: Colors.transparent,
          ),
          child: Slider(
            value: current,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget toSliderWithStringOnLeft({
    required double current,
    double min = 0,
    required double max,
    int flex = 1,
    double divider = 10,
    void Function(double value)? onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        this.toText(),
        VerticalDivider(
          width: divider,
        ),
        Expanded(
          flex: flex,
          child: SliderTheme(
            data: SliderTheme.of(ContextHolder.currentContext).copyWith(
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.blue.withOpacity(0.1),
              thumbColor: Colors.lightBlue,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 5.dp,
              ),
              trackHeight: 1.dp,
              trackShape: SliderTrackShape(),
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              value: current,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget onClick(
    void Function() onClick, {
    Color color = Colors.white,
  }) {
    return GestureDetector(
      child: Text(
        this,
        style: TextStyle(
          fontSize: 15.sp,
          color: color,
          decoration: TextDecoration.none,
        ),
      ),
      onTap: onClick,
    );
  }
}

class NetworkStatsTable extends StatelessWidget {
  NetworkStatsTable(this.stats);

  @override
  Widget build(BuildContext context) {
    if (stats == null) return Container();
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Colors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
      children: [
        TableRow(
          children: [
            Text(
              '网络类型:\n${NetworkTypes[stats!.type.index]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              'IP:${stats!.ip}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              '上行:\n${stats!.sendBitrate}kbps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '下行:\n${stats!.receiveBitrate}kbps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '往返:\n${stats!.rtt}ms',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ],
    );
  }

  final RCRTCNetworkStats? stats;
}

class LocalAudioStatsTable extends StatelessWidget {
  LocalAudioStatsTable(this.stats);

  @override
  Widget build(BuildContext context) {
    if (stats == null) return Container();
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Colors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
      children: [
        TableRow(
          children: [
            Text(
              '音频\n${stats!.bitrate}kbps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '丢包率:${stats!.packageLostRate}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        )
      ],
    );
  }

  final RCRTCLocalAudioStats? stats;
}

class LocalVideoStatsTable extends StatelessWidget {
  LocalVideoStatsTable(this.stats);

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = [];
    stats.forEach((key, value) {
      rows.add(
        TableRow(
          children: [
            Text(
              '${key ? '小流' : '大流'}\n${value.bitrate}kbps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${value.width}x${value.height}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${value.fps}fps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '丢包率:${value.packageLostRate}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      );
    });
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Colors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
      children: rows,
    );
  }

  final Map<bool, RCRTCLocalVideoStats> stats;
}

class RemoteAudioStatsTable extends StatelessWidget {
  RemoteAudioStatsTable(this.stats);

  @override
  Widget build(BuildContext context) {
    if (stats == null) return Container();
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      textDirection: TextDirection.ltr,
      border: TableBorder.all(
        color: Colors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
      children: [
        TableRow(
          children: [
            Text(
              '音频码率',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${stats!.bitrate}kbps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              '音频丢包率',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${stats!.packageLostRate}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ],
    );
  }

  final RCRTCRemoteAudioStats? stats;
}

class RemoteVideoStatsTable extends StatelessWidget {
  RemoteVideoStatsTable(this.stats);

  @override
  Widget build(BuildContext context) {
    if (stats == null) return Container();
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      textDirection: TextDirection.ltr,
      border: TableBorder.all(
        color: Colors.grey,
        width: 1,
        style: BorderStyle.solid,
      ),
      children: [
        TableRow(
          children: [
            Text(
              '视频码率',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${stats!.bitrate}kbps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              '视频帧率',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${stats!.fps}fps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              '视频分辨率',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${stats!.width}x${stats!.height}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Text(
              '视频丢包率',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              '${stats!.packageLostRate}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ],
    );
  }

  final RCRTCRemoteVideoStats? stats;
}

class LiveMixItem {
  LiveMixItem(this.id, this.tag);

  final String id;
  final String? tag;
}

class LiveMixPanel extends StatefulWidget {
  LiveMixPanel(this.engine, this.config, this.items);

  @override
  State<StatefulWidget> createState() => _LiveMixPanelState();

  final RCRTCEngine engine;
  final LiveMix config;
  final List<LiveMixItem> items;
}

class _LiveMixPanelState extends State<LiveMixPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('合流布局面板'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.dp),
        children: [
          '合流模式'.toText(),
          Divider(
            height: 5.dp,
            color: Colors.transparent,
          ),
          Row(
            children: [
              Radios(
                '自定义',
                value: RCRTCLiveMixLayoutMode.custom,
                groupValue: widget.config.mode,
                onChanged: (dynamic mode) {
                  _showMixVideoConfig(context);
                },
              ),
              Spacer(),
              Radios(
                '悬浮',
                value: RCRTCLiveMixLayoutMode.suspension,
                groupValue: widget.config.mode,
                onChanged: (dynamic mode) {
                  widget.engine.setLiveMixLayoutMode(mode);
                  setState(() {
                    widget.config.mode = mode;
                  });
                },
              ),
              Spacer(),
              Radios(
                '自适应',
                value: RCRTCLiveMixLayoutMode.adaptive,
                groupValue: widget.config.mode,
                onChanged: (dynamic mode) {
                  widget.engine.setLiveMixLayoutMode(mode);
                  setState(() {
                    widget.config.mode = mode;
                  });
                },
              ),
            ],
          ),
          Divider(
            height: 5.dp,
            color: Colors.transparent,
          ),
          Row(
            children: [
              Radios(
                '剧中（有黑边）',
                value: RCRTCLiveMixRenderMode.whole,
                groupValue: widget.config.renderMode,
                onChanged: (dynamic mode) {
                  widget.engine.setLiveMixRenderMode(mode);
                  setState(() {
                    widget.config.renderMode = mode;
                  });
                },
              ),
              VerticalDivider(
                width: 10.dp,
              ),
              Radios(
                '裁剪（无黑边）',
                value: RCRTCLiveMixRenderMode.crop,
                groupValue: widget.config.renderMode,
                onChanged: (dynamic mode) {
                  widget.engine.setLiveMixRenderMode(mode);
                  setState(() {
                    widget.config.renderMode = mode;
                  });
                },
              ),
            ],
          ),
          Button(
            '背景颜色设置',
            callback: () {
              _showColorPicker(context);
            },
          ),
          Divider(
            height: 10.dp,
            color: Colors.transparent,
          ),
          Button(
            '视频设置',
            callback: () {
              _showVideoConfig(context, false);
            },
          ),
          Divider(
            height: 10.dp,
            color: Colors.transparent,
          ),
          Button(
            '小视频设置',
            callback: () {
              _showVideoConfig(context, true);
            },
          ),
          Divider(
            height: 10.dp,
            color: Colors.transparent,
          ),
          Button(
            '视频自定义布局',
            callback: () {
              _showMixVideoConfig(context);
            },
          ),
          Divider(
            height: 10.dp,
            color: Colors.transparent,
          ),
          Button(
            '音频设置',
            callback: () {
              _showAudioConfig(context);
            },
          ),
          Divider(
            height: 10.dp,
            color: Colors.transparent,
          ),
          Button(
            '音频自定义合流',
            callback: () {
              _showMixAudioConfig(context);
            },
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setter) {
            return AlertDialog(
              title: Text('选择背景颜色'),
              content: MaterialColorPicker(
                allowShades: false,
                selectedColor: Colors.red,
                colors: [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.yellow,
                ],
                onMainColorChange: (color) {
                  Utils.engine?.setLiveMixBackgroundColor(color![500]!);
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showVideoConfig(BuildContext context, bool tiny) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setter) {
            return AlertDialog(
              title: Text('${tiny ? '小' : ''}视频配置'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      '码率:'.toText(),
                      VerticalDivider(
                        width: 5.dp,
                        color: Colors.transparent,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: true,
                          value: tiny
                              ? widget.config.tinyVideoBitrate
                              : widget.config.videoBitrate,
                          items:
                              tiny ? minVideoKbpsItems() : maxVideoKbpsItems(),
                          onChanged: (dynamic bitrate) {
                            setter(() {
                              if (tiny)
                                widget.config.tinyVideoBitrate = bitrate;
                              else
                                widget.config.videoBitrate = bitrate;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10.dp,
                    color: Colors.transparent,
                  ),
                  Row(
                    children: [
                      '帧率:'.toText(),
                      VerticalDivider(
                        width: 5.dp,
                        color: Colors.transparent,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: true,
                          value: tiny
                              ? widget.config.tinyVideoFps
                              : widget.config.videoFps,
                          items: videoFpsItems(),
                          onChanged: (dynamic fps) {
                            setter(() {
                              if (tiny)
                                widget.config.tinyVideoFps = fps;
                              else
                                widget.config.videoFps = fps;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10.dp,
                    color: Colors.transparent,
                  ),
                  Row(
                    children: [
                      '视频分辨率:'.toText(),
                      VerticalDivider(
                        width: 5.dp,
                        color: Colors.transparent,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: true,
                          value: tiny
                              ? widget.config.tinyVideoResolution
                              : widget.config.videoResolution,
                          items: videoResolutionItems(),
                          onChanged: (dynamic resolution) {
                            setter(() {
                              if (tiny)
                                widget.config.tinyVideoResolution = resolution;
                              else
                                widget.config.videoResolution = resolution;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    widget.engine.setLiveMixVideoBitrate(
                        tiny
                            ? widget.config.tinyVideoBitrate
                            : widget.config.videoBitrate,
                        tiny);
                    widget.engine.setLiveMixVideoFps(
                        tiny
                            ? widget.config.tinyVideoFps
                            : widget.config.videoFps,
                        tiny);
                    widget.engine.setLiveMixVideoResolution(
                      tiny
                          ? widget.config.tinyVideoResolution.width
                          : widget.config.videoResolution.width,
                      tiny
                          ? widget.config.tinyVideoResolution.height
                          : widget.config.videoResolution.height,
                      tiny,
                    );
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMixVideoConfig(BuildContext context) {
    List<RCRTCCustomLayout> layouts = [];
    layouts.addAll(widget.config.layouts);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setter) {
            return Scaffold(
              appBar: AppBar(
                title: Text('自定义视频布局'),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                    ),
                    onPressed: layouts.length < widget.items.length
                        ? () =>
                            _showCustomLayoutConfig(context, setter, layouts)
                        : null,
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(
                              'User id: ${layouts[index].userId}\n'
                              'x: ${layouts[index].x}, y: ${layouts[index].y}\n'
                              'width: ${layouts[index].width}, height: ${layouts[index].height}',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            VerticalDivider(
                              width: 10.dp,
                              color: Colors.transparent,
                            ),
                            Icons.clear.onClick(() {
                              setter(() {
                                layouts.removeAt(index);
                              });
                            }),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 15.dp,
                          color: Colors.transparent,
                        );
                      },
                      itemCount: layouts.length,
                    ),
                  ),
                  Divider(
                    height: 10.dp,
                    color: Colors.transparent,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Button(
                        '提交',
                        callback: () {
                          if (layouts.length > 0) {
                            widget.config.layouts.clear();
                            widget.config.layouts.addAll(layouts);
                            widget.engine.setLiveMixCustomLayouts(layouts);
                            Navigator.pop(context);
                            setState(() {
                              widget.config.mode =
                                  RCRTCLiveMixLayoutMode.custom;
                            });
                          } else {
                            '至少需要一个自定义布局'.toast();
                          }
                        },
                      ),
                      VerticalDivider(
                        width: 10.dp,
                      ),
                      Button(
                        '取消',
                        callback: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                  Divider(
                    height: 10.dp,
                    color: Colors.transparent,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem<LiveMixItem>> _buildUserItems(
      List<RCRTCCustomLayout> layouts) {
    List<DropdownMenuItem<LiveMixItem>> items = [];
    widget.items.forEach((item) {
      if (item.tag != null) {
        if (layouts.indexWhere((layout) => layout.tag == item.tag) < 0) {
          items.add(DropdownMenuItem(
            value: item,
            child: Text(
              '${item.tag}',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ));
        }
      } else {
        if (layouts.indexWhere((layout) => layout.userId == item.id) < 0) {
          items.add(DropdownMenuItem(
            value: item,
            child: Text(
              '${item.id}',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ));
        }
      }
    });
    return items;
  }

  void _showCustomLayoutConfig(BuildContext context, StateSetter setter,
      List<RCRTCCustomLayout> layouts) {
    LiveMixItem? selected;
    TextEditingController videoXInputController = TextEditingController();
    TextEditingController videoYInputController = TextEditingController();
    TextEditingController videoWidthInputController = TextEditingController();
    TextEditingController videoHeightInputController = TextEditingController();

    videoXInputController.text = '0';
    videoYInputController.text = '0';
    videoWidthInputController.text = '180';
    videoHeightInputController.text = '320';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, _setter) {
          return AlertDialog(
            title: Text('视频布局'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton(
                  hint: Text('选择一个用户/自定义流'),
                  value: selected,
                  items: _buildUserItems(layouts),
                  onChanged: (dynamic obj) {
                    _setter(() {
                      selected = obj;
                    });
                  },
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    '视频位置X:'.toText(),
                    VerticalDivider(
                      width: 5.dp,
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: InputBox(
                        hint: '请输入有效数字',
                        controller: videoXInputController,
                        type: TextInputType.number,
                        size: 15.sp,
                        formatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    '视频位置Y:'.toText(),
                    VerticalDivider(
                      width: 5.dp,
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: InputBox(
                        hint: '请输入有效数字',
                        controller: videoYInputController,
                        type: TextInputType.number,
                        size: 15.sp,
                        formatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    '视频宽度:'.toText(),
                    VerticalDivider(
                      width: 5.dp,
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: InputBox(
                        hint: '请输入有效数字',
                        controller: videoWidthInputController,
                        type: TextInputType.number,
                        size: 15.sp,
                        formatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    '视频高度:'.toText(),
                    VerticalDivider(
                      width: 5.dp,
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: InputBox(
                        hint: '请输入有效数字',
                        controller: videoHeightInputController,
                        type: TextInputType.number,
                        size: 15.sp,
                        formatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  String x = videoXInputController.text;
                  String y = videoYInputController.text;
                  String width = videoWidthInputController.text;
                  String height = videoHeightInputController.text;
                  if (selected == null)
                    return 'Please select user or custom stream!'.toast();
                  if (x.isEmpty) return 'X should not be null!'.toast();
                  if (y.isEmpty) return 'Y should not be null!'.toast();
                  if (width.isEmpty) return 'Width should not be null!'.toast();
                  if (height.isEmpty)
                    return 'Height should not be null!'.toast();
                  RCRTCCustomLayout layout = selected!.tag != null
                      ? RCRTCCustomLayout.createCustomStreamLayout(
                          userId: selected!.id,
                          tag: selected!.tag,
                          x: x.toInt,
                          y: y.toInt,
                          width: width.toInt,
                          height: height.toInt,
                        )
                      : RCRTCCustomLayout.create(
                          userId: selected!.id,
                          x: x.toInt,
                          y: y.toInt,
                          width: width.toInt,
                          height: height.toInt,
                        );
                  Navigator.pop(context);
                  setter(() {
                    layouts.add(layout);
                  });
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showAudioConfig(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setter) {
          return AlertDialog(
            title: Text('音频配置'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    '码率:'.toText(),
                    VerticalDivider(
                      width: 5.dp,
                      color: Colors.transparent,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isDense: true,
                        value: widget.config.audioBitrate,
                        items: audioKbpsItems(),
                        onChanged: (dynamic bitrate) {
                          setter(() {
                            widget.config.audioBitrate = bitrate;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  widget.engine
                      .setLiveMixAudioBitrate(widget.config.audioBitrate);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showMixAudioConfig(BuildContext context) {
    Map<String, bool> mixes = {};
    Utils.users.forEach((user) {
      mixes[user.id] = widget.config.audios.contains(user.id);
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setter) {
            return AlertDialog(
              title: Text('选择参与音频合流的用户'),
              content: Container(
                width: 100.dp,
                height: 100.dp,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    String id = mixes.keys.elementAt(index);
                    bool checked = mixes.values.elementAt(index);
                    return CheckBoxes(
                      id,
                      checked: checked,
                      onChanged: (checked) {
                        setter(() {
                          mixes[id] = checked;
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 15.dp,
                      color: Colors.transparent,
                    );
                  },
                  itemCount: mixes.length,
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    widget.config.audios.clear();
                    mixes.forEach((id, mix) {
                      if (mix) widget.config.audios.add(id);
                    });
                    widget.engine.setLiveMixCustomAudios(widget.config.audios);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class JoinSubRoomPanel extends StatelessWidget {
  JoinSubRoomPanel(
    this.engine,
    this.room,
    this.joined,
    this.joinable,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('跨房间连麦'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('已加入的子房间:'),
          joined.length > 0
              ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Text('${joined[index]}'),
                        Spacer(),
                        Button(
                          '离开',
                          callback: () => _left(context, joined[index], false),
                        ),
                        VerticalDivider(
                          width: 10.dp,
                          color: Colors.transparent,
                        ),
                        Button(
                          '离开并解散',
                          callback: () => _left(context, joined[index], true),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 5.dp,
                    );
                  },
                  itemCount: joined.length,
                )
              : Text('暂未加入任何子房间'),
          Divider(
            height: 10.dp,
            color: Colors.blue,
          ),
          Text('申请加入子房间:'),
          Padding(
            padding: EdgeInsets.all(10.dp),
            child: InputBox(
              hint: '输入子房间ID',
              controller: _roomInputController,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.dp),
            child: InputBox(
              hint: '输入子房间用户ID',
              controller: _userInputController,
            ),
          ),
          Row(
            children: [
              Spacer(),
              Button(
                '申请',
                callback: () => _request(context),
              ),
              Spacer(),
            ],
          ),
          Divider(
            height: 10.dp,
            color: Colors.blue,
          ),
          Text('加入已连麦的子房间:'),
          joinable.length > 0
              ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Text('${joinable[index]}'),
                        Button(
                          '加入',
                          callback: () =>
                              Utils.joinSubRoom(context, joinable[index]),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 5.dp,
                    );
                  },
                  itemCount: joinable.length,
                )
              : Text('暂时没有可以直接加入的子房间.'),
        ],
      ),
    );
  }

  void _left(BuildContext context, String roomId, bool disband) async {
    Loading.show(context);
    engine.onSubRoomLeft = (roomId, code, message) {
      engine.onSubRoomLeft = null;
      Loading.dismiss(context);
      if (code != 0) {
        '离开$roomId子房间失败, code:$code, message:$message'.toast();
      } else {
        '离开$roomId子房间成功'.toast();
        Utils.clearRoomUser(roomId, disband);
        Navigator.pop(context);
      }
    };
    int code = await engine.leaveSubRoom(roomId, disband);
    if (code != 0) {
      engine.onJoinSubRoomRequested = null;
      Loading.dismiss(context);
      '离开$roomId子房间失败, code:$code'.toast();
    }
  }

  void _request(BuildContext context) async {
    String rid = _roomInputController.text;
    if (rid.isEmpty) return '子房间ID不能为空'.toast();
    String uid = _userInputController.text;
    if (uid.isEmpty) return '子房间用户ID不能为空'.toast();

    if (room == rid) return '子房间ID不能是当前房间ID'.toast();
    if (joined.indexOf(rid) != -1) return '该子房间已经加入'.toast();
    if (joinable.indexOf(rid) != -1) return '该子房间可直接加入，无需申请'.toast();

    Loading.show(context);
    engine.onJoinSubRoomRequested = (roomId, userId, code, message) {
      engine.onJoinSubRoomRequested = null;
      Loading.dismiss(context);
      if (code != 0) {
        '申请加入$roomId子房间失败, code:$code, message:$message'.toast();
      } else {
        '已提交加入$roomId子房间申请, 等待对方处理'.toast();
      }
    };
    int code = await engine.requestJoinSubRoom(rid, uid);
    if (code != 0) {
      engine.onJoinSubRoomRequested = null;
      Loading.dismiss(context);
      '申请加入$rid子房间失败, code:$code'.toast();
    }
  }

  final String room;
  final List<String> joinable;
  final List<String> joined;
  final RCRTCEngine engine;

  final TextEditingController _roomInputController = TextEditingController();
  final TextEditingController _userInputController = TextEditingController();
}

class CDNConfig extends StatefulWidget {
  CDNConfig({
    required this.id,
    required this.engine,
    required this.cdnList,
  });

  @override
  _CDNConfigState createState() => _CDNConfigState(this);

  final String id;
  final List<CDNInfo> cdnList;
  final RCRTCEngine engine;
}

class _CDNConfigState extends State<CDNConfig> {
  _CDNConfigState(this.widget);

  @override
  void dispose() {
    _token.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('配置CDN'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => _showAddCDN(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20.dp),
        itemCount: widget.cdnList.length,
        itemBuilder: (context, index) {
          CDNInfo cdn = widget.cdnList[index];
          String text =
              'RTMP地址：${cdn.rtmp} \nHLS地址：${cdn.hls} \nFLV地址：${cdn.flv}';
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${index + 1} 播放地址 \n$text',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              VerticalDivider(
                width: 10.dp,
                color: Colors.transparent,
              ),
              Icons.copy.onClick(() {
                Clipboard.setData(ClipboardData(text: text));
                '播放地址已复制到剪切板'.toast();
              }),
              VerticalDivider(
                width: 10.dp,
                color: Colors.transparent,
              ),
              Icons.clear.onClick(() {
                setState(() {
                  widget.engine.removeLiveCdn(cdn.push);
                  widget.cdnList.remove(cdn);
                });
              }),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 15.dp,
            color: Colors.transparent,
          );
        },
      ),
    );
  }

  void _showAddCDN(BuildContext context) async {
    List<CDN> list = await _loadCDNs(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('请选择CDN'),
          content: _buildCDNSelector(context, list),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<CDN>> _loadCDNs(BuildContext context) {
    Loading.show(context);
    Completer<List<CDN>> completer = Completer();
    List<CDN> list = [];
    Http.get(
      '${GlobalConfig.host}/cdns',
      null,
      (error, data) {
        jsonDecode(data).forEach((id, name) {
          list.add(CDN(id, name));
        });
        Loading.dismiss(context);
        completer.complete(list);
      },
      (error) {
        Loading.dismiss(context);
        '获取CDN列表失败'.toast();
        completer.complete(list);
      },
      _token,
    );
    return completer.future;
  }

  Widget _buildCDNSelector(BuildContext context, List<CDN> list) {
    return Container(
      width: 100.dp,
      height: 100.dp,
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return list[index].name.onClick(
            () async {
              CDNInfo? info = await _loadCDN(context, list[index].id);
              if (info == null)
                '获取CDN地址失败'.toast();
              else
                setState(() {
                  widget.engine.addLiveCdn(info.push);
                  widget.cdnList.add(info);
                });
              Navigator.pop(context);
            },
            color: Colors.blue,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 15.dp,
            color: Colors.transparent,
          );
        },
        itemCount: list.length,
      ),
    );
  }

  Future<CDNInfo?> _loadCDN(BuildContext context, String id) async {
    Loading.show(context);
    String? session = await widget.engine.getSessionId();
    Completer<CDNInfo> completer = Completer();
    Http.get(
      '${GlobalConfig.host}/cdn/$id/sealLive/$session',
      null,
      (error, data) {
        Loading.dismiss(context);
        print("CDN = $data");
        completer.complete(CDNInfo.fromJons(jsonDecode(data)));
      },
      (error) {
        Loading.dismiss(context);
        completer.complete(null);
      },
      _token,
    );
    return completer.future;
  }

  final CDNConfig widget;

  final CancelToken _token = CancelToken();
}

class BoxFitChooser extends StatelessWidget {
  BoxFitChooser({
    required this.fit,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: fit,
      items: [
        DropdownMenuItem<BoxFit>(
          value: BoxFit.contain,
          child: Text(
            '自适应',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        DropdownMenuItem<BoxFit>(
          value: BoxFit.cover,
          child: Text(
            '裁剪',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        DropdownMenuItem<BoxFit>(
          value: BoxFit.fill,
          child: Text(
            '填充',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.fitWidth,
        //   child: Text('FitWidth'),
        // ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.fitHeight,
        //   child: Text('FitHeight'),
        // ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.scaleDown,
        //   child: Text('ScaleDown'),
        // ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.none,
        //   child: Text('None'),
        // ),
      ],
      onChanged: (dynamic value) {
        onSelected?.call(value);
      },
    );
  }

  final BoxFit fit;
  final void Function(BoxFit value)? onSelected;
}

class MessagePanel extends StatefulWidget {
  MessagePanel(this.id, this.host);

  @override
  _MessagePanelState createState() => _MessagePanelState(this);

  final String id;
  final bool host;
}

class _MessagePanelState extends State<MessagePanel> {
  _MessagePanelState(this.widget) {
    Utils.imEngine?.onMessageReceived = (
      RCIMIWMessage? message,
      int? left,
      bool? offline,
      bool? hasPackage,
    ) {
      _received(message);
    };
  }

  void _received(RCIMIWMessage? message) {
    if (message == null) return;
    setState(() {
      _messages.add(message);
    });
  }

  @override
  void dispose() {
    Utils.imEngine?.onMessageReceived = null;
    _leave(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息面板'),
      ),
      body: Column(
        children: [
          Divider(
            height: 20.dp,
            color: Colors.transparent,
          ),
          Row(
            children: [
              Spacer(),
              Button(
                '${_joined ? '离开' : '加入'}聊天室',
                callback: () => _action(),
              ),
              Spacer(),
            ],
          ),
          Divider(
            height: 20.dp,
            color: Colors.transparent,
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10.dp),
              itemBuilder: (context, index) {
                return '${_messages[index].senderUserId}${_messages[index].senderUserId == DefaultData.user?.id ? '(我)' : ''}:${(_messages[index] as RCIMIWTextMessage).text}'
                    .toText();
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 15.dp,
                  color: Colors.transparent,
                );
              },
              itemCount: _messages.length,
            ),
          ),
          Divider(
            height: 20.dp,
            color: Colors.transparent,
          ),
          Row(
            children: [
              Spacer(),
              Button(
                '发送消息',
                callback: () => _send(),
              ),
              Spacer(),
            ],
          ),
          Divider(
            height: 20.dp,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  void _action() {
    if (!_joined)
      _join();
    else
      _leave();
  }

  void _join() {
    if (_joined) return;
    setState(() {
      _joined = true;
    });
    Utils.imEngine?.joinChatRoom(widget.id, -1, true);
  }

  void _leave([bool set = true]) {
    if (!_joined) return;
    if (set)
      setState(() {
        _joined = false;
      });
    Utils.imEngine?.leaveChatRoom(widget.id);
  }

  void _send() async {
    if (!_joined) return '请先加入房间'.toast();
    String content = '我是${widget.host ? '主播' : '观众'}';
    RCIMIWTextMessage? message = await Utils.imEngine?.createTextMessage(
        RCIMIWConversationType.chatroom, widget.id, '', content);
    int result = await _sendMessage(message);
    if (result != 0) {
      '发消息接口调用失败'.toast();
    }
  }

  Future<int> _sendMessage(RCIMIWTextMessage? textMessage) async {
    if (textMessage == null) {
      return -1;
    }
    Completer<int> completer = new Completer();
    Utils.imEngine?.onMessageAttached = (RCIMIWMessage? message) {
      completer.complete(0);
      _received(message as RCIMIWTextMessage);
    };
    int code = await Utils.imEngine?.sendMessage(textMessage) ?? -1;
    if (code != 0) {
      return code;
    }
    return completer.future;
  }

  final MessagePanel widget;
  final List<RCIMIWMessage> _messages = [];
  bool _joined = false;
}

class AudioEffectPanel extends StatefulWidget {
  AudioEffectPanel(this.engine);

  @override
  State<StatefulWidget> createState() => _AudioEffectPanelState();

  final RCRTCEngine engine;
}

class _AudioEffectPanelState extends State<AudioEffectPanel> {
  @override
  void initState() {
    _loadEffects();
    super.initState();
  }

  void _loadEffects() async {
    int count = 0;
    widget.engine.onAudioEffectCreated = (id, code, message) {
      count++;
      if (code == 0) {
        _effects.add(_AudioEffect(id, EffectNames[id], 50, 1));
      }
      if (count == EffectNames.length) {
        widget.engine.onAudioEffectCreated = null;
        setState(() {
          _loaded = true;
        });
      }
    };
    for (int i = 0; i < EffectNames.length; i++) {
      widget.engine
          .createAudioEffectFromAssets('assets/audio/effect_$i.mp3', i);
    }
  }

  @override
  void dispose() {
    _releaseEffects();
    super.dispose();
  }

  void _releaseEffects() {
    widget.engine.onAudioEffectCreated = null;
    widget.engine.stopAllAudioEffects();
    _effects.forEach((effect) {
      widget.engine.releaseAudioEffect(effect.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音效面板'),
      ),
      body: _loaded ? _panel(context) : _loading(context),
    );
  }

  Widget _panel(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        _AudioEffect effect = _effects[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VerticalDivider(
              width: 10.dp,
            ),
            effect.name.toText(),
            VerticalDivider(
              width: 10.dp,
            ),
            Expanded(
              flex: 1,
              child: '音量'.toSliderWithStringOnTop(
                current: effect.volume.toDouble(),
                max: 100,
                onChanged: (value) {
                  setState(() {
                    effect.volume = value.toInt();
                  });
                },
              ),
            ),
            VerticalDivider(
              width: 20.dp,
            ),
            Expanded(
              flex: 1,
              child: '循环次数'.toSliderWithStringOnTop(
                current: effect.count.toDouble(),
                min: 1,
                max: 10,
                onChanged: (value) {
                  setState(() {
                    effect.count = value.toInt();
                  });
                },
              ),
            ),
            VerticalDivider(
              width: 10.dp,
            ),
            '播放'.onClick(
              () {
                widget.engine
                    .playAudioEffect(effect.id, effect.volume, effect.count);
              },
              color: Colors.blue,
            ),
            VerticalDivider(
              width: 10.dp,
            ),
            '停止'.onClick(
              () {
                widget.engine.stopAudioEffect(effect.id);
              },
              color: Colors.blue,
            ),
            VerticalDivider(
              width: 10.dp,
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 15.dp,
          color: Colors.transparent,
        );
      },
      itemCount: _effects.length,
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  bool _loaded = false;
  List<_AudioEffect> _effects = [];
}

class _AudioEffect {
  _AudioEffect(this.id, this.name, this.volume, this.count);

  final int id;
  final String name;
  int volume;
  int count;
}

class AudioMixPanel extends StatefulWidget {
  AudioMixPanel(this.engine);

  @override
  State<StatefulWidget> createState() => _AudioMixPanelState();

  final RCRTCEngine engine;
}

class _AudioMixPanelState extends State<AudioMixPanel> {
  @override
  void dispose() {
    widget.engine.stopAudioMixing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('混音面板'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.dp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: _buildMusicChooser(context),
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            '混合模式'.toText(),
            Divider(
              height: 5.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                Spacer(),
                Radios(
                  '不混合',
                  value: RCRTCAudioMixingMode.none,
                  groupValue: mode,
                  onChanged: (dynamic value) {
                    setState(() {
                      mode = value;
                    });
                  },
                ),
                Spacer(),
                Radios(
                  '混合',
                  value: RCRTCAudioMixingMode.mix,
                  groupValue: mode,
                  onChanged: (dynamic value) {
                    setState(() {
                      mode = value;
                    });
                  },
                ),
                Spacer(),
                Radios(
                  '替换',
                  value: RCRTCAudioMixingMode.replace,
                  groupValue: mode,
                  onChanged: (dynamic value) {
                    setState(() {
                      mode = value;
                    });
                  },
                ),
                Spacer(),
              ],
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            '音量'.toSliderWithStringOnLeft(
              current: volume.toDouble(),
              max: 100,
              onChanged: (value) {
                setState(() {
                  volume = value.toInt();
                  widget.engine.adjustAudioMixingVolume(volume);
                });
              },
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                '本端播放'.toText(),
                VerticalDivider(
                  width: 10.dp,
                ),
                Switch(
                  value: playback,
                  onChanged: (on) {
                    setState(() {
                      playback = on;
                    });
                  },
                ),
              ],
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            '本端音量'.toSliderWithStringOnLeft(
              current: playbackVolume.toDouble(),
              max: 100,
              onChanged: (value) {
                setState(() {
                  playbackVolume = value.toInt();
                  widget.engine.adjustAudioMixingPlaybackVolume(playbackVolume);
                });
              },
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            '发布音量'.toSliderWithStringOnLeft(
              current: publishVolume.toDouble(),
              max: 100,
              onChanged: (value) {
                setState(() {
                  publishVolume = value.toInt();
                  widget.engine.adjustAudioMixingPublishVolume(publishVolume);
                });
              },
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            '循环次数'.toSliderWithStringOnLeft(
              current: count.toDouble(),
              min: 1,
              max: 10,
              onChanged: (value) {
                setState(() {
                  count = value.toInt();
                });
              },
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            '混音进度'.toSliderWithStringOnLeft(
              current: position,
              max: 1,
              onChanged: (value) {
                setState(() {
                  position = value;
                });
              },
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                Spacer(),
                '播放'.onClick(
                  () {
                    widget.engine.startAudioMixingFromAssets(
                        path: 'assets/audio/music_$index.mp3',
                        mode: mode,
                        playback: playback,
                        loop: count,
                        position: position);
                    widget.engine.adjustAudioMixingVolume(volume);
                    // 点击播放以音量值播放  滑动单独修改
                    //widget.engine.adjustAudioMixingPlaybackVolume(playbackVolume);
                    //widget.engine.adjustAudioMixingPublishVolume(publishVolume);
                  },
                  color: Colors.black,
                ),
                VerticalDivider(
                  width: 20.dp,
                ),
                '停止'.onClick(
                  () {
                    widget.engine.stopAudioMixing();
                  },
                  color: Colors.black,
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMusicChooser(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Spacer());
    for (int i = 0; i < MusicNames.length; i++) {
      widgets.add(
        Radios(
          MusicNames[i],
          value: i,
          groupValue: index,
          onChanged: (dynamic value) {
            if (index != value) {
              widget.engine.stopAudioMixing();
              setState(() {
                index = value;
              });
            }
          },
        ),
      );
      widgets.add(Spacer());
    }
    return widgets;
  }

  int index = 0;
  RCRTCAudioMixingMode mode = RCRTCAudioMixingMode.mix;
  int volume = 50;
  int publishVolume = 50;
  int playbackVolume = 50;
  bool playback = true;
  int count = 1;
  double position = 0;
}

class EchoTest extends StatefulWidget {
  const EchoTest();

  @override
  State<EchoTest> createState() => _EchoTestState();
}

class _EchoTestState extends State<EchoTest> {
  @override
  void initState() {
    _createEngine();
    super.initState();
  }

  @override
  void dispose() {
    _destroy();
    super.dispose();
  }

  _destroy() async {
    if (_periodicTimer?.isActive ?? false) {
      _periodicTimer!.cancel();
      _periodicTimer = null;
    }
    await _engine?.stopEchoTest();
    _engine?.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('麦克风&扬声器检测'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.dp),
        child: Column(
          children: [
            SizedBox(
              height: 15.dp,
            ),
            Row(
              children: [
                Text(
                  '时间',
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(
                  width: 15.dp,
                ),
                Expanded(
                  child: InputBox(
                    type: TextInputType.number,
                    size: 18.sp,
                    hint: '请输入时间（范围：2s~10s）',
                    controller: _timeInputController,
                    formatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.dp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Button(
                  _start ? '结束检测' : '开始检测',
                  callback: _start ? _stopTest : _startTest,
                ),
              ],
            ),
            SizedBox(
              height: 15.dp,
            ),
            _start && _displayCountdown > 0
                ? Column(
                    children: [
                      Text(
                        '$_displayCountdown',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${_countdown > _timeInputController.text.toInt ? '现在应该能听到刚才的声音' : '请说一些话'}',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _createEngine() async {
    _engine = await RCRTCEngine.create();
  }

  void _startTest() async {
    if (_timeInputController.text.length == 0) {
      '请输入时间'.toast();
      return;
    }
    setState(() {
      _start = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    Loading.show(context);
    int inputTime = _timeInputController.text.toInt;
    if (inputTime < 2) {
      inputTime = 2;
      _timeInputController.text = '2';
    } else if (inputTime > 10) {
      inputTime = 10;
      _timeInputController.text = '10';
    }
    int code = await _engine?.startEchoTest(inputTime) ?? -1;
    Loading.dismiss(context);
    if (code == 0) {
      '已开始'.toast();
    }
    _periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _countdown += 1;
          if (_countdown > inputTime * 2) {
            _countdown = 0;
            _periodicTimer!.cancel();
            _periodicTimer = null;
            return;
          }
          if (_countdown > inputTime) {
            _displayCountdown -= 1;
          } else {
            _displayCountdown += 1;
          }
        });
      },
    );
  }

  Future<void> _stopTest() async {
    if (_periodicTimer?.isActive ?? false) {
      _periodicTimer!.cancel();
      _periodicTimer = null;
    }
    setState(() {
      _start = false;
      _countdown = 0;
      _displayCountdown = 0;
    });
    Loading.show(context);
    int code = await _engine?.stopEchoTest() ?? -1;
    Loading.dismiss(context);
    if (code == 0) {
      '已停止'.toast();
    }
  }

  RCRTCEngine? _engine;
  int _countdown = 0;
  int _displayCountdown = 0;
  bool _start = false;
  Timer? _periodicTimer;
  TextEditingController _timeInputController = TextEditingController();
}

class Watermark extends StatefulWidget {
  const Watermark({required this.engine});

  @override
  State<Watermark> createState() => _WatermarkState();

  final RCRTCEngine engine;
}

class _WatermarkState extends State<Watermark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置水印'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.dp),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40.dp,
                  child: Text('x:'),
                ),
                Slider(value: _x, min: 0.0, max: 1.0, onChanged: _xChanged),
                Text('${_x.toStringAsFixed(1)}'),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 40.dp,
                  child: Text('y:'),
                ),
                Slider(value: _y, min: 0.0, max: 1.0, onChanged: _yChanged),
                Text('${_y.toStringAsFixed(1)}'),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 40.dp,
                  child: Text('zoom:'),
                ),
                Slider(
                    value: _zoom, min: 0.0, max: 1.0, onChanged: _zoomChanged),
                Text('${_zoom.toStringAsFixed(1)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  '设置水印',
                  callback: _setWatermarkAction,
                ),
              ],
            ),
            SizedBox(
              height: 10.dp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  '删除水印',
                  callback: _removeWatermarkAction,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _xChanged(double value) {
    setState(() {
      _x = value;
    });
  }

  void _yChanged(double value) {
    setState(() {
      _y = value;
    });
  }

  void _zoomChanged(double value) {
    setState(() {
      _zoom = value;
    });
  }

  void _setWatermarkAction() async {
    AssetPickerConfig config =
        const AssetPickerConfig(maxAssets: 1, requestType: RequestType.image);
    final List<AssetEntity>? assets =
        await AssetPicker.pickAssets(context, pickerConfig: config);
    File? file = await assets?.first.originFile;
    Loading.show(context);
    int result =
        await _setWatermark(file?.absolute.path ?? '', Point(_x, _y), _zoom);
    Loading.dismiss(context);
    if (result == 0) {
      '设置水印成功'.toast();
    } else {
      '设置水印失败'.toast();
    }
    Navigator.pop(context);
  }

  void _removeWatermarkAction() async {
    Loading.show(context);
    int result = await _removeWaterMark();
    Loading.dismiss(context);
    if (result == 0) {
      '移除水印成功'.toast();
    } else {
      '移除水印失败'.toast();
    }
    Navigator.pop(context);
  }

  Future<int> _setWatermark(
      String imagePath, Point<double> position, double zoom) async {
    Completer<int> completer = Completer();
    widget.engine.onWatermarkSet = (int code, String? message) async {
      widget.engine.onWatermarkSet = null;
      completer.complete(code);
    };
    int code = await widget.engine.setWatermark(imagePath, position, zoom);
    if (code != 0) {
      widget.engine.onWatermarkSet = null;
      return code;
    }
    return completer.future;
  }

  Future<int> _removeWaterMark() async {
    Completer<int> completer = Completer();
    widget.engine.onWatermarkRemoved = (int code, String? message) async {
      widget.engine.onWatermarkRemoved = null;
      completer.complete(code);
    };
    int code = await widget.engine.removeWatermark();
    if (code != 0) {
      widget.engine.onWatermarkRemoved = null;
      return code;
    }
    return completer.future;
  }

  double _x = 0.2;
  double _y = 0.2;
  double _zoom = 0.2;
}

class NetworkProbe extends StatefulWidget {
  const NetworkProbe();

  @override
  State<NetworkProbe> createState() => _NetworkProbeState();
}

class _NetworkProbeState extends State<NetworkProbe>
    implements RCRTCNetworkProbeListener {
  @override
  void initState() {
    _createEngine();
    super.initState();
  }

  @override
  void dispose() {
    _destroy();
    super.dispose();
  }

  _destroy() async {
    await _stopNetworkProbe();
    _engine?.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('网络探测'),
        ),
        body: Container(
          padding: EdgeInsets.all(15.dp),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _started
                      ? Button(
                          '主动结束',
                          callback: _stop,
                        )
                      : Button(
                          '开启探测',
                          callback: _start,
                        )
                ],
              ),
              SizedBox(
                height: 15.dp,
              ),
              _upLinkStats != null && _downLinkStats != null
                  ? Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      children: [
                        TableRow(
                          children: [
                            Text(
                              '上行',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '质量:\n${_getQualityName(_upLinkStats!)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '往返:\n${_upLinkStats?.rtt}ms',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '丢包率:\n${_upLinkStats?.packetLostRate}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(
                              '下行',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '质量:\n${_getQualityName(_downLinkStats!)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '往返:\n${_downLinkStats?.rtt}ms',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '丢包率:\n${_downLinkStats?.packetLostRate}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ));
  }

  void _createEngine() async {
    _engine = await RCRTCEngine.create();
  }

  _start() async {
    Loading.show(context);
    int result = await _startNetworkProbe();
    Loading.dismiss(context);
    if (result == 0) {
      setState(() {
        _started = true;
      });
      '开启成功'.toast();
    } else {
      '开启失败: $result'.toast();
    }
  }

  _stop() async {
    Loading.show(context);
    int result = await _stopNetworkProbe();
    Loading.dismiss(context);
    if (result == 0) {
      setState(() {
        _started = false;
      });
      '停止成功'.toast();
    } else {
      '停止失败: $result'.toast();
    }
  }

  Future<int> _startNetworkProbe() async {
    Completer<int> completer = new Completer();
    _engine?.onNetworkProbeStarted = (int code, String? errMsg) {
      _engine?.onNetworkProbeStarted = null;
      completer.complete(code);
    };
    int code = await _engine?.startNetworkProbe(this) ?? -1;
    if (code != 0) {
      _engine?.onNetworkProbeStarted = null;
      return code;
    }
    return completer.future;
  }

  Future<int> _stopNetworkProbe() async {
    Completer<int> completer = new Completer();
    _engine?.onNetworkProbeStopped = (int code, String? errMsg) {
      _engine?.onNetworkProbeStopped = null;
      completer.complete(code);
    };
    int code = await _engine?.stopNetworkProbe() ?? -1;
    if (code != 0) {
      _engine?.onNetworkProbeStopped = null;
      return code;
    }
    return completer.future;
  }

  @override
  void onNetworkProbeUpLinkStats(RCRTCNetworkProbeStats stats) {
    setState(() {
      _upLinkStats = stats;
    });
  }

  @override
  void onNetworkProbeDownLinkStats(RCRTCNetworkProbeStats stats) {
    setState(() {
      _downLinkStats = stats;
    });
  }

  @override
  void onNetworkProbeFinished(int code, String? errMsg) {
    setState(() {
      _started = false;
    });
  }

  String _getQualityName(RCRTCNetworkProbeStats stats) {
    return stats.qualityLevel.name.replaceAll('quality_', '');
  }

  RCRTCEngine? _engine;
  bool _started = false;
  RCRTCNetworkProbeStats? _upLinkStats;
  RCRTCNetworkProbeStats? _downLinkStats;
}

class Sei extends StatefulWidget {
  const Sei(this.engine, this.config);

  @override
  State<Sei> createState() => _SeiState();

  final SeiConfig config;
  final RCRTCEngine engine;
}

class _SeiState extends State<Sei> {
  @override
  void initState() {
    super.initState();
    widget.engine.onSeiReceived = (String roomId, String userId, String sei) {
      setState(() {
        _receivedSeiText = 'roomId:$roomId, userId:$userId, sei:$sei';
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEI 功能配置'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Padding(
          padding: EdgeInsets.all(10.dp),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '开启 SEI 功能',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(
                    width: 15.dp,
                  ),
                  Switch(
                      value: widget.config.enable, onChanged: _enableSeiAction)
                ],
              ),
              SizedBox(
                height: 10.dp,
              ),
              Row(
                children: [
                  Text(
                    '发送的内容',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(
                    width: 15.dp,
                  ),
                  Expanded(
                    child: InputBox(
                      type: TextInputType.text,
                      size: 18.sp,
                      hint: '发送 sei 的内容',
                      controller: _textInputController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.dp,
              ),
              Row(
                children: [
                  Text(
                    '发送的次数',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(
                    width: 15.dp,
                  ),
                  Expanded(
                    child: InputBox(
                      type: TextInputType.number,
                      size: 18.sp,
                      hint: '发送 sei 的次数（2s 发一次）',
                      controller: _countInputController,
                      formatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.dp,
              ),
              Button(
                _sent ? '取消发送' : '发送',
                callback: _sent ? _cancelSend : _sendSei,
              ),
              SizedBox(
                height: 50.dp,
              ),
              Text(
                '其他主播发送的 SEI 内容',
                style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.dp,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      _receivedSeiText,
                      style: TextStyle(fontSize: 18.sp),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _enableSeiAction(bool enable) async {
    int result = await _enableSei(enable);
    if (result != 0) {
      'sei 开关失败'.toast();
    } else {
      setState(() {
        widget.config.enable = enable;
      });
    }
  }

  Future<int> _enableSei(bool enable) async {
    Completer<int> completer = new Completer();
    widget.engine.onSeiEnabled = (bool enable, int code, String? errMsg) {
      widget.engine.onSeiEnabled = null;
      completer.complete(code);
    };
    int code = await widget.engine.enableSei(enable);
    if (code != 0) {
      widget.engine.onSeiEnabled = null;
      return code;
    }
    return completer.future;
  }

  _sendSei() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String text = _textInputController.text;
    int count = _countInputController.text.toInt;
    if (text.isEmpty || count <= 0) {
      '请填写正确的内容和次数'.toast();
      return;
    }
    widget.config.seiText = text;
    setState(() {
      _sent = true;
    });
    const period = const Duration(seconds: 2);
    Timer.periodic(period, (timer) async {
      _sendSeiTimer = timer;
      count--;
      int sendSeiCode = await Utils.engine?.sendSei(text) ?? -1;
      print('sendSeiCode: $sendSeiCode');
      if (count <= 0) {
        timer.cancel();
        _sendSeiTimer = null;
        setState(() {
          _sent = false;
        });
      }
    });
  }

  _cancelSend() {
    setState(() {
      _sent = false;
    });
    _sendSeiTimer?.cancel();
    _sendSeiTimer = null;
  }

  TextEditingController _textInputController = TextEditingController();
  TextEditingController _countInputController = TextEditingController();

  Timer? _sendSeiTimer;
  bool _sent = false;
  String _receivedSeiText = '';
}

class AudioConfigPanel extends StatefulWidget {
  const AudioConfigPanel(this.engine);

  @override
  State<AudioConfigPanel> createState() => _AudioConfigPanelState();

  final RCRTCEngine? engine;
}

class _AudioConfigPanelState extends State<AudioConfigPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音频配置'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.dp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            '音频质量'.toText(),
            Divider(
              height: 5.dp,
              color: Colors.transparent,
            ),
            Row(
              children: _buildAudioQualityChooser(context),
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            '音频场景'.toText(),
            Divider(
              height: 5.dp,
              color: Colors.transparent,
            ),
            Row(
              children: _buildAudioScenarioChooser(context),
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                Spacer(),
                '确定'.onClick(
                  () {
                    widget.engine?.setAudioConfig(RCRTCAudioConfig.create(
                      quality: _quality,
                      scenario: _scenario,
                    ));
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                ),
                VerticalDivider(
                  width: 20.dp,
                ),
                '取消'.onClick(
                  () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAudioQualityChooser(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Spacer());
    for (int i = 0; i < AudioQualityNames.length; i++) {
      widgets.add(
        Radios(
          AudioQualityNames[i],
          value: RCRTCAudioQuality.values[i],
          groupValue: _quality,
          onChanged: (dynamic value) {
            if (_quality != value) {
              setState(() {
                _quality = value;
              });
            }
          },
        ),
      );
      widgets.add(Spacer());
    }
    return widgets;
  }

  List<Widget> _buildAudioScenarioChooser(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Spacer());
    for (int i = 0; i < AudioScenarioNames.length; i++) {
      widgets.add(
        Radios(
          AudioScenarioNames[i],
          value: RCRTCAudioScenario.values[i],
          groupValue: _scenario,
          onChanged: (dynamic value) {
            if (_scenario != value) {
              setState(() {
                _scenario = value;
              });
            }
          },
        ),
      );
      widgets.add(Spacer());
    }
    return widgets;
  }

  RCRTCAudioQuality _quality = RCRTCAudioQuality.speech;
  RCRTCAudioScenario _scenario = RCRTCAudioScenario.normal;
}
