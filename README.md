# 融云 RTC Wrapper Plugin
[![GitHub stars](https://img.shields.io/github/stars/rongcloud/rtc-flutter-wrapper.svg)](https://github.com/rongcloud/rtc-flutter-wrapper) [![Pub version](https://img.shields.io/pub/v/rongcloud_rtc_wrapper_plugin.svg)](https://pub.dev/packages/rongcloud_rtc_wrapper_plugin)

本文档主要讲解了如何使用融云  RTC Wrapper Plugin，基于 融云 iOS/Android 平台的  RTCLib  SDK

[Flutter 官网](https://flutter.dev/)

[融云 iOS RTC 文档](https://www.rongcloud.cn/docs/ios_rtclib.html)

[融云 Android RTC 文档](https://www.rongcloud.cn/docs/android_rtclib.html)

# 前期准备

## 1 申请开发者账号

[融云官网](https://developer.rongcloud.cn/signup/?utm_source=RTCfluttergithub&utm_term=RTCsign)申请开发者账号

通过管理后台的 "基本信息"->"App Key" 获取 AppKey

通过管理后台的 "IM 服务"—>"API 调用"->"用户服务"->"获取 Token"，通过用户 id 获取 IMToken

## 2 开通音视频服务

管理后台的 "音视频服务"->"服务设置" 开通音视频 RTC 3.0 ，开通两个小时后生效

# 依赖 RTC Wrapper Plugin

在项目的 `pubspec.yaml` 中写如下依赖

```
dependencies:
  flutter:
    sdk: flutter
  rongcloud_rtc_wrapper_plugin: ^5.1.5+2
```

iOS 需要在 Info.plist 中需要加入对相机和麦克风的权限申请

```
<key>NSCameraUsageDescription</key>
<string>使用相机</string>
<key>NSMicrophoneUsageDescription</key>
<string>使用麦克风</string>
```
还需要添加字段 `io.flutter.embedded_views_preview` 值为 `YES`

Android 需要在 AndroidManifest.xml 文件中声明对相机和麦克风的权限

```
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

# 前置接口说明

## 初始化 IM SDK

```dart
RongIMClient.init(RongAppKey);
```

## 连接 IM

```dart
RongIMClient.connect(IMToken, (code, userId) {
});
```

## 创建 RTC 引擎

```dart
engine = await RCRTCEngine.create();
```

# 音视频模式接口说明

## 用户加入房间，渲染并发布资源

### 加入 RTC 房间

```dart
// 设置加入 RTC 房间事件监听
engine.onRoomJoined = (int code, String? message) {
};

// 加入 RTC 房间
RCRTCRoomSetup setup = RCRTCRoomSetup.create(
    type: RCRTCMediaType.audio_video,
    role: RCRTCRole.meeting_member,
);
engine.joinRoom(id, setup);
```

### 采集音频
引擎默认开启音频采集

```dart
engine.enableMicrophone(true);
```

### 采集视频

```dart
engine.enableCamera(true);
```

### 渲染视频

```dart
RCRTCView view = await RCRTCView.create();
engine.setLocalView(view);
```

### 发布资源

```dart
engine.publish(RCRTCMediaType.audio_video);
```

## 渲染远端用户

### 监听远端用户加入的回调

`当用户加入的时候，不要做订阅渲染的处理`，因为此时该用户可能刚加入房间成功，但是尚未发布资源

```dart
engine.onUserJoined = (roomId, userId) {
};
```

### 监听远端用户发布资源的回调

```dart
engine.onRemotePublished = (roomId, userId, type) {

};
```

### 远端用户发布资源后，订阅远端用户资源

```dart
engine.subscribe(userId, type);
```

### 渲染远端用户资源

```dart
RCRTCView view = await RCRTCView.create();
engine.setRemoteView(userId, view);
```

# 直播模式接口说明

## 主播加入房间，渲染并发布资源

### 加入 RTC 房间

```dart
// 设置加入 RTC 房间事件监听
engine.onRoomJoined = (int code, String? message) {
};

// 加入 RTC 房间
RCRTCRoomSetup setup = RCRTCRoomSetup.create(
    type: RCRTCMediaType.audio_video,
    role: RCRTCRole.live_broadcaster,
);
engine.joinRoom(id, setup);
```

### 采集音频
引擎默认开启音频采集

```dart
engine.enableMicrophone(true);
```

### 采集视频

```dart
engine.enableCamera(true);
```

### 渲染视频

```dart
RCRTCView view = await RCRTCView.create();
engine.setLocalView(view);
```

### 发布资源

```dart
engine.publish(RCRTCMediaType.audio_video);
```

## 渲染远端主播

### 监听远端主播加入的回调

`当主播加入的时候，不要做订阅渲染的处理`，因为此时该主播可能刚加入房间成功，但是尚未发布资源

```dart
engine.onUserJoined = (roomId, userId) {
};
```

### 监听远端主播发布资源的回调

```dart
engine.onRemotePublished = (roomId, userId, type) {

};
```

### 远端主播发布资源后，订阅远端主播资源

```dart
engine.subscribe(userId, type);
```

### 渲染远端主播资源

```dart
RCRTCView view = await RCRTCView.create();
engine.setRemoteView(userId, view);
```

## 观众加入房间，订阅并渲染MCU资源

### 加入 RTC 房间

```dart
// 设置加入 RTC 房间事件监听
engine.onRoomJoined = (int code, String? message) {
};

// 加入 RTC 房间
RCRTCRoomSetup setup = RCRTCRoomSetup.create(
    type: RCRTCMediaType.audio_video,
    role: RCRTCRole.live_audience,
);
engine.joinRoom(id, setup);
```

### 监听MCU资源发布回调

```dart
engine.onRemoteLiveMixPublished = (type) {
};
```

### MCU资源发布后，订阅MCU资源

```dart
engine.subscribeLiveMix(type);
```

### 渲染MCU资源

```dart
RCRTCView view = await RCRTCView.create();
engine.setLiveMixView(view);
```

## 观众加入房间，订阅并渲染主播资源

### 加入 RTC 房间

```dart
// 设置加入 RTC 房间事件监听
engine.onRoomJoined = (int code, String? message) {
};

// 加入 RTC 房间
RCRTCRoomSetup setup = RCRTCRoomSetup.create(
    type: RCRTCMediaType.audio_video,
    role: RCRTCRole.live_audience,
);
engine.joinRoom(id, setup);
```

### 监听远端主播加入的回调

`当主播加入的时候，不要做订阅渲染的处理`，因为此时该主播可能刚加入房间成功，但是尚未发布资源

```dart
engine.onUserJoined = (roomId, userId) {
};
```

### 监听远端主播发布资源的回调

```dart
engine.onRemotePublished = (roomId, userId, type) {

};
```

### 远端主播发布资源后，订阅远端主播资源

```dart
engine.subscribe(userId, type);
```

### 渲染远端主播资源

```dart
RCRTCView view = await RCRTCView.create();
engine.setRemoteView(userId, view);
```

# 其他接口

## 离开房间

```dart
engine.leaveRoom();
```

## 销毁引擎

```dart
engine.destroy();
```

