# 融云 Flutter RTCLib

[![GitHub stars](https://img.shields.io/github/stars/rongcloud/rtc-flutter-wrapper.svg)](https://github.com/rongcloud/rtc-flutter-wrapper) [![Pub version](https://img.shields.io/pub/v/rongcloud_rtc_wrapper_plugin.svg)](https://pub.dev/packages/rongcloud_rtc_wrapper_plugin)

本文档主要讲解了如何使用融云  RTC Wrapper Plugin，基于 融云 iOS/Android 平台的  RTCLib  SDK。


[融云 iOS RTCLib 文档](https://docs.rongcloud.cn/ios-rtclib)

[融云 Android RTCLib 文档](https://docs.rongcloud.cn/android-rtclib)

## 准备工作

1. 如果您还没有融云开发者账号，在[融云控制台](https://console.rongcloud.cn/)注册一个。
2. 在控制台，通过**应用配置**>**基本信息**>**App Key**，获取您的 App Key。
3. 在控制台，通过**应用配置**>**音视频服务**>**实时音视频**，开通音视频服务。
4. 通过服务端 API，[获取用户 Token](https://docs.rongcloud.cn/platform-chat-api/user/register)。


## 依赖 RTC Wrapper Plugin

在项目的 `pubspec.yaml` 中写如下依赖：

```
dependencies:
  flutter:
    sdk: flutter
  rongcloud_rtc_wrapper_plugin: 5.24.4
```

iOS 需要在 `Info.plist` 中需要加入对相机和麦克风的权限申请。

```
<key>NSCameraUsageDescription</key>
<string>使用相机</string>
<key>NSMicrophoneUsageDescription</key>
<string>使用麦克风</string>
```
还需要添加字段 `io.flutter.embedded_views_preview` 值为 `YES`。

Android 需要在 AndroidManifest.xml 文件中声明对相机和麦克风的权限。

```
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

## 快速开始

详细的集成步骤、API 使用说明、功能配置等内容，请参考 [融云 RTCLib Flutter 完整开发文档](https://docs.rongcloud.cn/flutter-rtclib/init)。

文档包含以下完整内容：
- [初始化](https://docs.rongcloud.cn/flutter-rtclib/init) - IM SDK 初始化、RTC 引擎创建
- [房间管理](https://docs.rongcloud.cn/flutter-rtclib/room) - 加入房间、离开房间
- [设备管理](https://docs.rongcloud.cn/flutter-rtclib/device) - 摄像头、麦克风控制
- [用户资源管理](https://docs.rongcloud.cn/flutter-rtclib/user) - 发布与订阅资源
- [音视频模式](https://docs.rongcloud.cn/flutter-rtclib/meeting) - 实现音视频会议
- [直播模式](https://docs.rongcloud.cn/flutter-rtclib/live) - 实现低延迟直播
- 完整的 API 参考和错误码说明

## 基本使用示例

### 1. 初始化和连接
```dart
// 初始化 IM SDK
RongIMClient.init(RongAppKey);

// 连接 IM 服务
RongIMClient.connect(IMToken, (code, userId) {});

// 创建 RTC 引擎
engine = await RCRTCEngine.create();
```

### 2. 加入房间
```dart
RCRTCRoomSetup setup = RCRTCRoomSetup.create(
    type: RCRTCMediaType.audio_video,
    role: RCRTCRole.meeting_member,
);
engine.joinRoom(roomId, setup);
```

### 3. 发布和订阅资源
```dart
// 发布本地资源
engine.publish(RCRTCMediaType.audio_video);

// 订阅远端资源
engine.subscribe(userId, type);
```

## 支持

如有任何问题，请通过以下方式获取帮助：
- 查阅[官方完整文档](https://docs.rongcloud.cn/flutter-rtclib)
- [提交工单](https://console.rongcloud.cn/agile/formwork/ticket/create)，联系融云技术支持

------


# Introducing RC RTCLib for Flutter

[![GitHub stars](https://img.shields.io/github/stars/rongcloud/rtc-flutter-wrapper.svg)](https://github.com/rongcloud/rtc-flutter-wrapper) [![Pub version](https://img.shields.io/pub/v/rongcloud_rtc_wrapper_plugin.svg)](https://pub.dev/packages/rongcloud_rtc_wrapper_plugin)

This document mainly explains how to use the RC RTC Wrapper Plugin, which is based on the RC RTCLib SDK for iOS/Android platforms.


[RC iOS RTCLib Documentation](https://docs.rongcloud.io/ios-rtclib)

[RC Android RTCLib Documentation](https://docs.rongcloud.io/android-rtclib)

## Preparations

1. If you don't have a RongCloud developer account yet, register one at [RongCloud Console](https://console.rongcloud.io/).
2. In the console, get your App Key through **Configuration** > **Basic information** > **App key**.
3. In the console, activate the audio and video service by submitting a ticket.
4. Get user Token through server-side API, [register user](https://docs.rongcloud.io/platform-chat-api/user/register).

## Dependencies on RTC Wrapper Plugin

Add the following dependencies to your project's `pubspec.yaml`:

```
dependencies:
  flutter:
    sdk: flutter
  rongcloud_rtc_wrapper_plugin: 5.24.4
```

iOS requires adding camera and microphone permission requests in `Info.plist`.

```
<key>NSCameraUsageDescription</key>
<string>Use camera</string>
<key>NSMicrophoneUsageDescription</key>
<string>Use microphone</string>
```
You also need to add the field `io.flutter.embedded_views_preview` with the value `YES`.

Android needs to declare camera and microphone permissions in the AndroidManifest.xml file.

```
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

## Quick Start

For detailed integration steps, API usage instructions, feature configurations, and more, please refer to [RongCloud RTCLib Flutter Complete Development Documentation](https://docs.rongcloud.io/flutter-rtclib/init).

The documentation includes comprehensive content on:
- [Initialization](https://docs.rongcloud.io/flutter-rtclib/init) - IM SDK initialization, RTC engine creation
- [Room Management](https://docs.rongcloud.io/flutter-rtclib/room) - Join room, leave room
- [Device Management](https://docs.rongcloud.io/flutter-rtclib/device) - Camera, microphone control
- [User Resource Management](https://docs.rongcloud.io/flutter-rtclib/user) - Publish and subscribe resources
- [Audio & Video Mode](https://docs.rongcloud.io/flutter-rtclib/meeting) - Implement audio and video meetings
- [Live Broadcast Mode](https://docs.rongcloud.io/flutter-rtclib/live) - Implement low-latency live streaming
- Complete API reference and error code explanations

## Basic Usage Examples

### 1. Initialize and Connect
```dart
// Initialize IM SDK
RongIMClient.init(RongAppKey);

// Connect to IM service
RongIMClient.connect(IMToken, (code, userId) {});

// Create RTC Engine
engine = await RCRTCEngine.create();
```

### 2. Join Room
```dart
RCRTCRoomSetup setup = RCRTCRoomSetup.create(
    type: RCRTCMediaType.audio_video,
    role: RCRTCRole.meeting_member,
);
engine.joinRoom(roomId, setup);
```

### 3. Publish and Subscribe Resources
```dart
// Publish local resources
engine.publish(RCRTCMediaType.audio_video);

// Subscribe to remote resources
engine.subscribe(userId, type);
```

## Support

For any questions, please get help through:
- Consult the [Official Complete Documentation](https://docs.rongcloud.io/flutter-rtclib)
- [Submit a ticket](https://console.rongcloud.io/agile/formwork/ticket/create) to contact RongCloud technical support
