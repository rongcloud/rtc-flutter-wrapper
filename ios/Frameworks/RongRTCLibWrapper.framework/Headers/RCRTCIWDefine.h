//
//  RCRTCIWDefine.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#ifndef RCRTCIWDefine_h
#define RCRTCIWDefine_h

/*!
 错误码
 */
typedef NS_ENUM(NSInteger, RCRTCIWErrorCode) {
    RCRTCIWErrorCodeSuccess = 0
};

/*!
 音频编码类型
 */
typedef NS_ENUM(NSInteger, RCRTCIWAudioCodecType) {
    RCRTCIWAudioCodecTypePCMU = 0,       // PCMU
    RCRTCIWAudioCodecTypeOPUS = 111      // OPUS
};

/*!
 视频编码类型
 */
typedef NS_ENUM(NSUInteger, RCRTCIWVideoCodecType) {
    RCRTCIWVideoCodecTypeH264      // H264
};

/*!
 设置音频通话质量类型
 */
typedef NS_ENUM(NSInteger, RCRTCIWAudioQuality) {
    RCRTCIWAudioQualitySpeech = 0,         // 人声音质，编码码率最大值为 32Kbps
    RCRTCIWAudioQualityMusic,          // 标清音乐音质，编码码率最大值为 64Kbps
    RCRTCIWAudioQualityMusicHigh      // 高清音乐音质，编码码率最大值为 128Kbps
};

/*!
 设置音频通话模式
 */
typedef NS_ENUM(NSInteger, RCRTCIWAudioScenario) {
    RCRTCIWAudioScenarioDefault = 0,        // 普通通话模式(普通音质模式), 满足正常音视频场景
    RCRTCIWAudioScenarioMusicChatRoom,      // 音乐聊天室模式, 提升声音质量, 适用对音乐演唱要求较高的场景
    RCRTCIWAudioScenarioMusicClassRoom      // 音乐教室模式, 提升声音质量, 适用对乐器演奏音质要求较高的场景
};

/*!
 摄像头
 */
typedef NS_ENUM(NSInteger, RCRTCIWCamera) {
    RCRTCIWCameraNone = -1,
    RCRTCIWCameraFront = 0,      // 前置摄像头
    RCRTCIWCameraBack            // 后置摄像头
};

/*!
 摄像头采集方向
 */
typedef NS_ENUM(NSUInteger, RCRTCIWCameraCaptureOrientation) {
    RCRTCIWCameraCaptureOrientationPortrait = 1,            // 竖直, home 键在下部
    RCRTCIWCameraCaptureOrientationPortraitUpsideDown,      // 顶部向下, home 键在上部
    RCRTCIWCameraCaptureOrientationLandscapeRight,          // 顶部向右, home 键在左侧
    RCRTCIWCameraCaptureOrientationLandscapeLeft            // 顶部向左, home 键在右侧
};

/*!
 音视频类型
 */
typedef NS_ENUM(NSInteger, RCRTCIWMediaType) {
    RCRTCIWMediaTypeAudio = 0,      // 仅音频
    RCRTCIWMediaTypeVideo,          // 仅视频
    RCRTCIWMediaTypeAudioVideo      // 音频 + 视频
};

/*!
 角色类型
 */
typedef NS_ENUM(NSInteger, RCRTCIWRole) {
    RCRTCIWRoleMeetingMember = 0,      // 会议类型房间中用户
    RCRTCIWRoleLiveBroadcaster,        // 直播类型房间中主播
    RCRTCIWRoleLiveAudience            // 直播类型房间中观众
};

/*!
 视频帧率
 */
typedef NS_ENUM(NSInteger, RCRTCIWVideoFps) {
    RCRTCIWVideoFps10,      // 每秒 10 帧
    RCRTCIWVideoFps15,      // 每秒 15 帧
    RCRTCIWVideoFps24,      // 每秒 24 帧
    RCRTCIWVideoFps30       // 每秒 30 帧
};

/*!
 视频分辨率类型
 */
typedef NS_ENUM(NSInteger, RCRTCIWVideoResolution) {
    RCRTCIWVideoResolution176x144,       // 176x144
    RCRTCIWVideoResolution180x180,       // 180x180
    RCRTCIWVideoResolution256x144,       // 256x144
    RCRTCIWVideoResolution240x180,       // 240x180
    RCRTCIWVideoResolution320x180,       // 320x180
    RCRTCIWVideoResolution240x240,       // 240x240
    RCRTCIWVideoResolution320x240,       // 320x240
    RCRTCIWVideoResolution360x360,       // 360x360
    RCRTCIWVideoResolution480x360,       // 480x360
    RCRTCIWVideoResolution640x360,       // 640x360
    RCRTCIWVideoResolution480x480,       // 480x480
    RCRTCIWVideoResolution640x480,       // 640x480
    RCRTCIWVideoResolution720x480,       // 720x480
    RCRTCIWVideoResolution848x480,       // 848x480
    RCRTCIWVideoResolution960x720,       // 960x720
    RCRTCIWVideoResolution1280x720,      // 1280x720
    RCRTCIWVideoResolution1920x1080      // 1920x1080
};

/*!
 视频填充模式
 */
typedef NS_ENUM(NSInteger, RCRTCIWViewFitType) {
    RCRTCIWViewFitTypeFill,         // 拉伸全屏
    RCRTCIWViewFitTypeCover,        // 满屏显示, 等比例填充, 直到填充满整个视图区域, 其中一个维度的部分区域会被裁剪
    RCRTCIWViewFitTypeCenter,       // 完整显示, 填充黑边, 等比例填充, 直到一个维度到达区域边界
};

/*!
 合流布局模式
 */
typedef NS_ENUM (NSInteger, RCRTCIWLiveMixLayoutMode) {
    RCRTCIWLiveMixLayoutModeCustom = 1,          // 自定义布局
    RCRTCIWLiveMixLayoutModeSuspension = 2,      // 悬浮布局
    RCRTCIWLiveMixLayoutModeAdaptive = 3         // 自适应布局
};

/*!
 输出视频流的裁剪模式
 */
typedef NS_ENUM(NSInteger, RCRTCIWLiveMixRenderMode) {
    RCRTCIWLiveMixRenderModeCrop = 1,      // 自适应裁剪
    RCRTCIWLiveMixRenderModeWhole = 2      // 填充
};

/*!
 混音模式
 */
typedef NS_ENUM(NSInteger, RCRTCIWAudioMixingMode) {
    RCRTCIWAudioMixingModeNone,        // 对端只能听见麦克风采集的声音
    RCRTCIWAudioMixingModeMixing,      // 对端能够听到麦克风采集的声音和音频文件的声音
    RCRTCIWAudioMixingModeReplace      // 对端只能听到音频文件的声音
};

/*!
 网络类型
 */
typedef NS_ENUM(NSInteger, RCRTCIWNetworkType) {
    RCRTCIWNetworkTypeUnknown,
    RCRTCIWNetworkTypeWiFi,
    RCRTCIWNetworkTypeMobile
};

/*!
 流类型
 */
typedef NS_ENUM(NSInteger, RCRTCIWStreamType) {
    RCRTCIWStreamTypeNotNormal = -1,
    RCRTCIWStreamTypeNormal = 0,
    RCRTCIWStreamTypeLive,
    RCRTCIWStreamTypeFile,
    RCRTCIWStreamTypeScreen,
    RCRTCIWStreamTypeCDN
};

#endif /* RCRTCIWDefine_h */
