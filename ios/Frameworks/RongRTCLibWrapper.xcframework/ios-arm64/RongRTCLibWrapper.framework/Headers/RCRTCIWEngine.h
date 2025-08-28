//
//  RCRTCIWEngine.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWEngineDelegate.h"
#import "RCRTCIWStatsDelegate.h"
#import "RCRTCIWAudioFrameDelegate.h"
#import "RCRTCIWVideoFrameDelegate.h"
#import "RCRTCIWNetworkProbeDelegate.h"
#import "RCRTCIWEngineSetup.h"
#import "RCRTCIWRoomSetup.h"
#import "RCRTCIWAudioConfig.h"
#import "RCRTCIWVideoConfig.h"
#import "RCRTCIWView.h"
#import "RCRTCIWCustomLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWEngine : NSObject

/*!
 引擎代理
 */
@property (nonatomic, weak) id<RCRTCIWEngineDelegate> engineDelegate;

#pragma mark - 引擎

/*!
 创建引擎
 @param setup 引擎参数
 @discussion
 创建引擎
 */
+ (RCRTCIWEngine *)create:(RCRTCIWEngineSetup *)setup;

+ (RCRTCIWEngine *)create;

/*!
 销毁引擎对象中的资源, 引擎对象除外
 */
- (void)destroy;

#pragma mark - 监听

/*!
 设置状态报表监听
 */
- (NSInteger)setStatsDelegate:(id<RCRTCIWStatsDelegate> _Nullable)delegate;

/*!
 设置本地音频前处理回调
 */
- (NSInteger)setLocalAudioCapturedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate;

/*!
 设置本地音频后处理回调
 */
- (NSInteger)setLocalAudioMixedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate;

/*!
 设置远端音频前处理回调
 */
- (NSInteger)setRemoteAudioReceivedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate
                                     userId:(NSString *)userId;

/*!
 设置本地音频后处理回调
 */
- (NSInteger)setRemoteAudioMixedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate;

/*!
 设置本地视频后处理回调
 */
- (NSInteger)setLocalVideoProcessedDelegate:(id<RCRTCIWSampleBufferVideoFrameDelegate> _Nullable)delegate;

/*!
 设置远端视频后处理回调
 */
- (NSInteger)setRemoteVideoProcessedDelegate:(id<RCRTCIWPixelBufferVideoFrameDelegate> _Nullable)delegate
                                      userId:(NSString *)userId;

/*!
 设置本地自定义视频后处理回调
 */
- (NSInteger)setLocalCustomVideoProcessedDelegate:(id<RCRTCIWSampleBufferVideoFrameDelegate> _Nullable)delegate
                                              tag:(NSString *)tag;

/*!
 设置远端自定义视频后处理回调
 */
- (NSInteger)setRemoteCustomVideoProcessedDelegate:(id<RCRTCIWPixelBufferVideoFrameDelegate> _Nullable)delegate
                                            userId:(NSString *)userId
                                               tag:(NSString *)tag;

/*!
 设置远端自定义音频前处理回调
 */
- (NSInteger)setRemoteCustomAudioReceivedDelegate:(id<RCRTCIWAudioFrameDelegate> _Nullable)delegate
                                           userId:(NSString *)userId
                                              tag:(NSString *)tag;

#pragma mark - 房间
/*!
 加入房间
 @param setup 房间参数
 @discussion
 加入房间
 */
- (NSInteger)joinRoom:(NSString *)roomId
                setup:(RCRTCIWRoomSetup *)setup;

/*!
 离开房间
 */
- (NSInteger)leaveRoom;

#pragma mark - 音视频参数配置
/*!
 设置默认音频参数, 仅供会议用户或直播主播用户使用
 @param config 音频参数
 @discussion
 设置默认音频参数, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)setAudioConfig:(RCRTCIWAudioConfig *)config;

/*!
 设置默认视频大流参数, 仅供会议用户或直播主播用户使用
 @param config 视频参数
 @discussion
 设置默认视频大流参数, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)setVideoConfig:(RCRTCIWVideoConfig *)config;

/*!
 设置默认视频参数, 仅供会议用户或直播主播用户使用
 @param config 视频参数
 @param tiny 是否小流
 @discussion
 设置默认视频参数, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)setVideoConfig:(RCRTCIWVideoConfig *)config
                       tiny:(BOOL)tiny;

#pragma mark - 本地用户发布资源
/*!
 加入房间后, 发布本地资源
 @param type 资源类型
 @discussion
 加入房间后, 发布本地资源
 */
- (NSInteger)publish:(RCRTCIWMediaType)type;

/*!
 加入房间后, 取消发布已经发布的本地资源
 @param type 资源类型
 @discussion
 加入房间后, 取消发布已经发布的本地资源
 */
- (NSInteger)unpublish:(RCRTCIWMediaType)type;

#pragma mark - 会议用户或直播主播用户订阅资源
/*!
 加入房间后, 订阅远端单个用户发布的资源
 @param userId 远端用户UserId
 @param type 资源类型
 @discussion
 加入房间后, 订阅远端单个用户发布的资源
 */
- (NSInteger)subscribe:(NSString *)userId
                  type:(RCRTCIWMediaType)type;

/*!
 加入房间后, 订阅远端单个用户发布的资源
 @param userId 远端用户UserId
 @param type 资源类型
 @param tiny 视频小流, YES:订阅视频小流 NO:订阅视频大流
 @discussion
 加入房间后, 订阅远端单个用户发布的资源
 */
- (NSInteger)subscribe:(NSString *)userId
                  type:(RCRTCIWMediaType)type
                  tiny:(BOOL)tiny;

/*!
 加入房间后, 订阅远端多个用户发布的资源
 @param userIdArray 远端用户UserId数组
 @param type 资源类型
 @discussion
 加入房间后, 订阅远端多个用户发布的资源, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)subscribeWithUserIds:(NSArray <NSString *> *)userIdArray
                             type:(RCRTCIWMediaType)type;

/*!
 加入房间后, 订阅远端多个用户发布的资源
 @param userIdArray 远端用户UserId数组
 @param type 资源类型
 @param tiny 视频小流, YES:订阅视频小流 NO:订阅视频大流
 @discussion
 加入房间后, 订阅远端多个用户发布的资源
 */
- (NSInteger)subscribeWithUserIds:(NSArray <NSString *> *)userIdArray
                             type:(RCRTCIWMediaType)type
                             tiny:(BOOL)tiny;

/*!
 加入房间后, 取消订阅远端单个用户发布的资源
 @param userId 远端用户UserId
 @param type 资源类型
 @discussion
 加入房间后, 取消订阅远端单个用户发布的资源
 */
- (NSInteger)unsubscribe:(NSString *)userId
                    type:(RCRTCIWMediaType)type;

/*!
 加入房间后, 取消订阅远端多个用户发布的资源
 @param userIdArray 远端用户UserId数组
 @param type 资源类型
 @discussion
 加入房间后, 取消订阅远端多个用户发布的资源
 */
- (NSInteger)unsubscribeWithUserIds:(NSArray <NSString *> *)userIdArray
                               type:(RCRTCIWMediaType)type;


#pragma mark - 直播观众用户订阅合流资源
/*!
 订阅主播合流资源, 仅供直播观众用户使用
 @param type 资源类型
 @discussion
 订阅主播合流资源, 仅供直播观众用户使用
 */
- (NSInteger)subscribeLiveMix:(RCRTCIWMediaType)type;

/*!
 订阅主播合流资源, 仅供直播观众用户使用
 @param type 资源类型
 @discussion
 订阅主播合流资源, 仅供直播观众用户使用
 */
- (NSInteger)subscribeLiveMix:(RCRTCIWMediaType)type
                         tiny:(BOOL)tiny;

/*!
 取消订阅主播合流资源, 仅供直播观众用户使用
 @param type 资源类型
 @discussion
 取消订阅主播合流资源, 仅供直播观众用户使用
 */
- (NSInteger)unsubscribeLiveMix:(RCRTCIWMediaType)type;

#pragma mark - 音频设备操作
/*!
 打开/关闭麦克风
 @param enable YES 打开, NO 关闭
 @discussion
 打开/关闭麦克风
 */
- (NSInteger)enableMicrophone:(BOOL)enable;

/*!
 打开/关闭外放
 @param enable YES 打开, NO 关闭
 @discussion
 打开/关闭外放
 */
- (NSInteger)enableSpeaker:(BOOL)enable;

#pragma mark - 麦克风音量设置
/*!
 麦克风的音量
 @param volume 0 ~ 100, 默认值: 100
 @discussion
 麦克风的音量
 */
- (NSInteger)adjustLocalVolume:(NSInteger)volume;

#pragma mark - 摄像头操作
/*!
 打开/关闭摄像头
 @param enable YES 打开, NO 关闭
 @discussion
 打开/关闭摄像头
 */
- (NSInteger)enableCamera:(BOOL)enable;

/*!
 打开/关闭摄像头
 @param enable YES 打开, NO 关闭
 @param camera 摄像头
 @discussion
 打开/关闭摄像头
 */
- (NSInteger)enableCamera:(BOOL)enable camera:(RCRTCIWCamera)camera;

/*!
 切换前后摄像头
 @discussion
 切换前后摄像头
 */
- (NSInteger)switchCamera;

/*!
 获取当前使用摄像头位置
 @discussion
 获取当前使用摄像头位置
 */
- (RCRTCIWCamera)whichCamera;

/*!
 摄像头是否支持区域对焦
 @discussion
 摄像头是否支持手动对焦功能
 */
- (BOOL)isCameraFocusSupported;

/*!
 摄像头是否支持区域测光
 @discussion
 摄像头是否支持手动曝光功能
 */
- (BOOL)isCameraExposurePositionSupported;

/*!
 在指定点区域对焦
 @param point 对焦点，视图上的坐标点
 @discussion
 改变对焦位置
 */
- (NSInteger)setCameraFocusPositionInPreview:(CGPoint)point;

/*!
 在指定点区域测光
 @param point 曝光点，视图上的坐标点
 @discussion
 改变曝光位置
 */
- (NSInteger)setCameraExposurePositionInPreview:(CGPoint)point;

/*!
 摄像头采集方向
 @param orientation 方向, 默认以 AVCaptureVideoOrientationPortrait 角度进行采集
 @discussion
 摄像头采集方向
 */
- (NSInteger)setCameraCaptureOrientation:(RCRTCIWCameraCaptureOrientation)orientation;

#pragma mark - 设置视频View
/*!
 设置本地视频View
 @param view RCRTCIWVideoView对象
 @discussion
 使用 [RCRTCIWVideoView create] 创建的view作为参数
 */
- (NSInteger)setLocalView:(RCRTCIWView *)view;

/*!
 移除本地视频View
 @discussion
 移除本地视频View
 */
- (NSInteger)removeLocalView;

/*!
 设置远端视频View
 @param view RCRTCIWVideoView对象
 @param userId 远端用户Id
 @discussion
 使用 [RCRTCIWVideoView create] 创建的view作为参数
 */
- (NSInteger)setRemoteView:(RCRTCIWView *)view
                    userId:(NSString *)userId;

/*!
 移除远端视频View
 @param userId 远端用户Id
 @discussion
 移除远端视频View
 */
- (NSInteger)removeRemoteView:(NSString *)userId;

/*!
 设置合流视频View
 @param view RCRTCIWVideoView对象
 @discussion
 使用 [RCRTCIWVideoView create] 创建的view作为参数
 */
- (NSInteger)setLiveMixView:(RCRTCIWView *)view;

/*!
 移除合流视频View
 @discussion
 移除合流视频View
 */
- (NSInteger)removeLiveMixView;

#pragma mark - 音视频流控制
/*!
 停止本地音视频数据发送
 @param mute YES: 不发送 NO: 发送
 @discussion
 停止本地音视频数据发送
 */
- (NSInteger)muteLocalStream:(RCRTCIWMediaType)type mute:(BOOL)mute;

/*!
 停止远端用户音视频数据的接收
 @param userId 远端用户Id
 @param type 媒体类型
 @param mute YES: 不接收 NO: 接收
 @discussion
 停止远端用户音视频数据的接收
 */
- (NSInteger)muteRemoteStream:(NSString *)userId
                         type:(RCRTCIWMediaType)type
                         mute:(BOOL)mute;

/*!
 停止所有远端用户音频数据的渲染
 @param mute YES: 不渲染 NO: 渲染
 @discussion
 停止所有远端用户音频数据的渲染
 */
- (NSInteger)muteAllRemoteAudioStreams:(BOOL)mute;

/*!
 停止合流音视频数据的接收
 @param type 媒体类型
 @param mute YES: 不接收 NO: 接收
 @discussion
 停止合流音视频数据的接收
 */
- (NSInteger)muteLiveMixStream:(RCRTCIWMediaType)type
                          mute:(BOOL)mute;


#pragma mark - 直播旁路推流设置
/*!
 设置 CDN 直播推流地址, 仅供直播主播用户使用
 @param url 推流地址
 @discussion
 设置 CDN 直播推流地址, 仅供直播主播用户使用
 */
- (NSInteger)addLiveCdn:(NSString *)url;

/*!
 移除 CDN 直播推流地址, 仅供直播主播用户使用
 @param url 推流地址
 @discussion
 移除 CDN 直播推流地址, 仅供直播主播用户使用
 */
- (NSInteger)removeLiveCdn:(NSString *)url;

#pragma mark - 直播合流设置
/*!
 设置直播合流布局类型, 仅供直播主播用户使用
 @param mode 布局类型
 @discussion
 设置直播合流布局类型, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixLayoutMode:(RCRTCIWLiveMixLayoutMode)mode;

/*!
 设置直播合流布局填充类型, 仅供直播主播用户使用
 @param mode 填充类型
 @discussion
 设置直播合流布局填充类型, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixRenderMode:(RCRTCIWLiveMixRenderMode)mode;

/*!
 设置直播合流布局背景颜色 仅供直播主播用户使用
 @param color 背景颜色, 取值范围: 0x000000 ~ 0xffffff
 @discussion
 设置直播合流布局背景颜色, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixBackgroundColor:(NSUInteger)color;

/*!
 设置直播合流布局背景颜色 仅供直播主播用户使用
 @param red 取值范围: 0 ~ 255
 @param green 取值范围: 0 ~ 255
 @param blue 取值范围: 0 ~ 255
 @discussion
 设置直播合流布局背景颜色, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixBackgroundColorWithRed:(NSUInteger)red
                                        green:(NSUInteger)green
                                         blue:(NSUInteger)blue;

/*!
 设置直播混流布局配置, 仅供直播主播用户使用
 @param layoutArray 混流布局列表
 @discussion
 设置直播混流布局配置, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixCustomLayouts:(NSArray <RCRTCIWCustomLayout *> *)layoutArray;

/*!
 设置直播自定义音频流列表, 仅供直播主播用户使用
 @param userIdArray 音频流列表
 @discussion
 设置直播自定义音频流列表, 仅供直播主播用户使用, 根据输入音频流列表中的流进行混流
 */
- (NSInteger)setLiveMixCustomAudios:(NSArray *)userIdArray;

/*!
 设置直播合流音频码率, 仅供直播主播用户使用
 @param bitrate 音频码率
 @discussion
 设置直播合流音频码率, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixAudioBitrate:(NSInteger)bitrate;

/*!
 设置直播合流大流视频码率, 仅供直播主播用户使用
 @param bitrate 视频码率
 @discussion
 设置直播合流大流视频码率, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixVideoBitrate:(NSInteger)bitrate;

/*!
 设置直播合流视频码率, 仅供直播主播用户使用
 @param bitrate 视频码率
 @param tiny 是否小流
 @discussion
 设置直播合流视频码率, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixVideoBitrate:(NSInteger)bitrate
                               tiny:(BOOL)tiny;

/*!
 设置直播合流大流视频分辨率, 仅供直播主播用户使用
 @param width 视频宽度
 @param height 视频高度
 @discussion
 设置直播合流大流视频分辨率, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixVideoResolution:(NSInteger)width
                                height:(NSInteger)height;

/*!
 设置直播合流视频分辨率, 仅供直播主播用户使用
 @param width 视频宽度
 @param height 视频高度 
 @param tiny 是否小流
 @discussion
 设置直播合流视频分辨率, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixVideoResolution:(NSInteger)width
                                height:(NSInteger)height
                                  tiny:(BOOL)tiny;

/*!
 设置直播合流大流视频帧率, 仅供直播主播用户使用
 @param fps 帧率
 @discussion
 设置直播合流大流视频帧率, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixVideoFps:(RCRTCIWVideoFps)fps;

/*!
 设置直播合流视频帧率, 仅供直播主播用户使用
 @param fps 帧率
 @param tiny 是否小流
 @discussion
 设置直播合流视频帧率, 仅供直播主播用户使用
 */
- (NSInteger)setLiveMixVideoFps:(RCRTCIWVideoFps)fps
                           tiny:(BOOL)tiny;

#pragma mark - 音效操作
/*!
 创建音效文件缓存, 仅供会议用户或直播主播用户使用
 @param url 本地文件地址
 @param effectId 自定义全局唯一音效Id
 @discussion
 创建音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)createAudioEffect:(NSURL *)url
                      effectId:(NSInteger)effectId;

/*!
 释放音效文件缓存, 仅供会议用户或直播主播用户使用
 @discussion
 释放音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)releaseAudioEffect:(NSInteger)effectId;

/*!
 播放音效文件, 仅供会议用户或直播主播用户使用
 @param effectId 自定义全局唯一音效Id
 @param volume 音效文件播放音量
 @param loop 循环播放次数
 @discussion
 播放音效文件, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)playAudioEffect:(NSInteger)effectId
                      volume:(NSUInteger)volume
                        loop:(NSInteger)loop;

/*!
 暂停音效文件播放, 仅供会议用户或直播主播用户使用
 @param effectId 自定义全局唯一音效Id
 @discussion
 暂停音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)pauseAudioEffect:(NSInteger)effectId;

/*!
 暂停全部音效文件播放, 仅供会议用户或直播主播用户使用
 @discussion
 暂停全部音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)pauseAllAudioEffects;

/*!
 恢复音效文件播放, 仅供会议用户或直播主播用户使用
 @param effectId 自定义全局唯一音效Id
 @discussion
 恢复音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)resumeAudioEffect:(NSInteger)effectId;

/*!
 恢复全部音效文件播放, 仅供会议用户或直播主播用户使用
 @discussion
 恢复全部音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)resumeAllAudioEffects;

/*!
 停止音效文件播放, 仅供会议用户或直播主播用户使用
 @param effectId 自定义全局唯一音效Id
 @discussion
 停止音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)stopAudioEffect:(NSInteger)effectId;

/*!
 停止全部音效文件播放, 仅供会议用户或直播主播用户使用
 @discussion
 停止全部音效文件缓存, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)stopAllAudioEffects;

/*!
 设置音效文件播放音量, 仅供会议用户或直播主播用户使用
 @param effectId 自定义全局唯一音效Id
 @param volume 音量 0~100, 默认 100
 @discussion
 设置音效文件播放音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)adjustAudioEffect:(NSInteger)effectId
                        volume:(NSUInteger)volume;

/*!
 获取音效文件播放音量, 仅供会议用户或直播主播用户使用
 @param effectId 自定义全局唯一音效Id
 @discussion
 获取音效文件播放音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)getAudioEffectVolume:(NSInteger)effectId;

/*!
 设置全局音效文件播放音量, 仅供会议用户或直播主播用户使用
 @param volume 音量 0~100, 默认 100
 @discussion
 设置全局音效文件播放音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)adjustAllAudioEffectsVolume:(NSUInteger)volume;

/*!
 获取全局音效文件播放音量, 仅供会议用户或直播主播用户使用
 @discussion
 获取全局音效文件播放音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)getAllAudioEffectsVolume;

#pragma mark - 混音操作
/*!
 开始混音, 仅支持混合本地音频文件数据, 仅供会议用户或直播主播用户使用
 @param url 仅支持本地音频文件
 @param mode 混音行为模式
 @param playback 是否本地播放
 @param loop 循环混音或者播放次数
 
 @discussion
 开始混音, 仅支持混合本地音频文件数据, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)startAudioMixing:(NSURL *)url
                         mode:(RCRTCIWAudioMixingMode)mode
                     playback:(BOOL)playback
                         loop:(NSUInteger)loop;

- (NSInteger)startAudioMixing:(NSURL *)url
                         mode:(RCRTCIWAudioMixingMode)mode
                     playback:(BOOL)playback
                         loop:(NSUInteger)loop
                     position:(CGFloat)position;

/*!
 暂停混音, 仅供会议用户或直播主播用户使用
 @discussion
 暂停混音, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)pauseAudioMixing;

/*!
 恢复混音, 仅供会议用户或直播主播用户使用
 @discussion
 恢复混音, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)resumeAudioMixing;

/*!
 停止混音, 仅供会议用户或直播主播用户使用
 @discussion
 停止混音, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)stopAudioMixing;

/*!
 设置混音输入音量, 包含本地播放和发送音量, 仅供会议用户或直播主播用户使用
 @param volume 音量 0~100, 默认 100
 @discussion
 设置混音输入音量, 包含输入和发送音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)adjustAudioMixingVolume:(NSUInteger)volume;

/*!
 设置混音本地播放音量, 仅供会议用户或直播主播用户使用
 @param volume 音量 0~100, 默认 100
 @discussion
 设置混音本地播放音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)adjustAudioMixingPlaybackVolume:(NSUInteger)volume;

/*!
 获取混音本地播放音量, 仅供会议用户或直播主播用户使用
 @discussion
 获取混音本地播放音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)getAudioMixingPlaybackVolume;

/*!
 设置混音发送音量, 仅供会议用户或直播主播用户使用
 @param volume 音量 0~100, 默认 100
 @discussion
 设置混音发送音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)adjustAudioMixingPublishVolume:(NSUInteger)volume;

/*!
 获取混音发送音量, 仅供会议用户或直播主播用户使用
 @discussion
 获取混音发送音量, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)getAudioMixingPublishVolume;

/*!
 设置混音文件合流进度, 仅供会议用户或直播主播用户使用
 @param position 进度 0~1
 @discussion
 设置混音文件合流进度, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)setAudioMixingPosition:(CGFloat)position;

/*!
 获取音频文件合流进度, 仅供会议用户或直播主播用户使用
 @discussion
 获取音频文件合流进度, 仅供会议用户或直播主播用户使用
 */
- (CGFloat)getAudioMixingPosition;

/*!
 获取音频文件时长, 单位:秒, 仅供会议用户或直播主播用户使用
 @discussion
 获取音频文件时长, 单位:秒, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)getAudioMixingDuration;

#pragma mark - SessionId
/*!
 获取当前房间的 SessionId, 仅在加入房间成功后可获取
 @discussion
 获取当前房间的 SessionId, 仅在加入房间成功后可获取
 每次加入房间所得到的 SessionId 均不同
 */
- (NSString *)getSessionId;

#pragma mark - 自定义视频流
/*!
 从视频文件创建自定义流, 仅供会议用户或直播主播用户使用
 @param url 本地文件地址
 @param tag 自定义流全局唯一标签
 @param replace 是否替换音频流  YES: 替换  NO: 不替换
 @param playback 是否本地回放音频流  YES: 回放  NO: 不回放
 @discussion
 从视频文件创建自定义流, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)createCustomStreamFromFile:(NSURL *)url
                                    tag:(NSString *)tag
                                replace:(BOOL)replace
                               playback:(BOOL)playback;

/*!
 设置自定义流参数, 仅供会议用户或直播主播用户使用
 @param config 视频参数
 @param tag 自定义流标签
 @discussion
 设置自定义流参数, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)setCustomStreamVideoConfig:(RCRTCIWVideoConfig *)config
                                    tag:(NSString *)tag;

/*!
 停止自定义流发送, 仅供会议用户或直播主播用户使用
 @param tag 自定义流标签
 @param mute YES: 不发送 NO: 发送
 @discussion
 静音自定义流, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)muteLocalCustomStream:(NSString *)tag
                              mute:(BOOL)mute;

/*!
 设置自定义流预览窗口, 仅供会议用户或直播主播用户使用
 @param view 预览窗口
 @param tag 自定义流标签
 @discussion
 设置自定义流预览窗口, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)setLocalCustomStreamView:(RCRTCIWView *)view
                                  tag:(NSString *)tag;

/*!
 移除自定义流预览窗口, 仅供会议用户或直播主播用户使用
 @param tag 自定义流标签
 @discussion
 移除自定义流预览窗口, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)removeLocalCustomStreamView:(NSString *)tag;

/*!
 发布自定义流, 仅供会议用户或直播主播用户使用
 @param tag 自定义流标签
 @discussion
 发布自定义流, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)publishCustomStream:(NSString *)tag;

/*!
 取消发布自定义流, 仅供会议用户或直播主播用户使用
 @param tag 自定义流标签
 @discussion
 取消发布自定义流, 仅供会议用户或直播主播用户使用
 */
- (NSInteger)unpublishCustomStream:(NSString *)tag;

/*!
 停止远端用户自定义流数据的接收
 @param userId 远端用户Id
 @param tag 远端自定义流标签
 @param type 远端自定义流类型
 @param mute YES: 不接收 NO: 接收
 @discussion
 停止远端用户自定义流数据的接收
 */
- (NSInteger)muteRemoteCustomStream:(NSString *)userId
                                tag:(NSString *)tag
                               type:(RCRTCIWMediaType)type
                               mute:(BOOL)mute;

/*!
 设置远端自定义流View
 @param view RCRTCIWVideoView对象
 @param userId 远端用户Id
 @param tag 远端自定义流标签
 @discussion
 使用 [RCRTCIWVideoView create] 创建的view作为参数
 */
- (NSInteger)setRemoteCustomStreamView:(RCRTCIWView *)view
                                userId:(NSString *)userId
                                   tag:(NSString *)tag;

/*!
 移除远端自定义流View
 @param userId 远端用户Id
 @param tag 远端自定义流标签
 @discussion
 移除远端自定义流View
 */
- (NSInteger)removeRemoteCustomStreamView:(NSString *)userId
                                      tag:(NSString *)tag;

/*!
 加入房间后, 订阅远端用户发布的自定义流
 @param userId 远端用户UserId
 @param tag 远端自定义流标签
 @param type 远端自定义流类型
 @discussion
 加入房间后, 订阅远端用户发布的自定义流
 */
- (NSInteger)subscribeCustomStream:(NSString *)userId
                               tag:(NSString *)tag
                              type:(RCRTCIWMediaType)type
                              tiny:(BOOL)tiny;

/*!
 加入房间后, 取消订阅远端用户发布的自定义流
 @param userId 远端用户UserId
 @param tag 远端自定义流标签
 @param type 远端自定义流类型
 @discussion
 加入房间后, 取消订阅远端用户发布的自定义流
 */
- (NSInteger)unsubscribeCustomStream:(NSString *)userId
                                 tag:(NSString *)tag
                                type:(RCRTCIWMediaType)type;

#pragma mark - 跨房间连麦

- (NSInteger)requestJoinSubRoom:(NSString *)roomId
                         userId:(NSString *)userId
                     autoLayout:(BOOL)autoLayout
                          extra:(NSString * _Nullable)extra;

- (NSInteger)cancelJoinSubRoomRequest:(NSString *)roomId
                               userId:(NSString *)userId
                                extra:(NSString * _Nullable)extra;

- (NSInteger)responseJoinSubRoomRequest:(NSString *)roomId
                                 userId:(NSString *)userId
                                  agree:(BOOL)agree
                             autoLayout:(BOOL)autoLayout
                                  extra:(NSString *)extra;

- (NSInteger)joinSubRoom:(NSString *)roomId;

- (NSInteger)leaveSubRoom:(NSString *)roomId
                  disband:(BOOL)disband;

#pragma mark - 角色切换

- (NSInteger)switchLiveRole:(RCRTCIWRole)role;

#pragma mark - 内置 cdn

- (NSInteger)enableLiveMixInnerCdnStream:(BOOL)enable;

- (NSInteger)subscribeLiveMixInnerCdnStream;

- (NSInteger)unsubscribeLiveMixInnerCdnStream;

- (NSInteger)setLiveMixInnerCdnStreamView:(RCRTCIWView *)view;

- (NSInteger)removeLiveMixInnerCdnStreamView;
/**
 观众端设置订阅 cdn 流的分辨率
 @param width 宽
 @param height 高
 // 高 x 宽
 // 176x144
 // 180x180
 // 256x144
 // 240x180
 // 320x180
 // 240x240
 // 320x240
 // 360x360
 // 480x360
 // 640x360
 // 480x480
 // 640x480
 // 720x480
 // 848x480
 // 960x720
 // 1280x720
 // 1920x1080
 */
- (NSInteger)setLocalLiveMixInnerCdnVideoResolution:(NSUInteger)width height:(NSUInteger)height;

/**
 观众端 设置订阅 cdn 流的帧率
 @param fps 帧率
 */
- (NSInteger)setLocalLiveMixInnerCdnVideoFps:(RCRTCIWVideoFps)fps;

/*!
 观众端禁用或启用融云内置 CDN 流
 @param mute YES: 停止资源渲染，NO: 恢复资源渲染
 */
- (NSInteger)muteLiveMixInnerCdnStream:(BOOL)mute;

#pragma mark - 水印

/**
 实现为相机/自定义文件/共享桌面采集到的视频流添加水印的功能。每一道视频流水印设置是独立的。
 不支持设置多个水印
 @param image           水印图片
 @param position    水印的位置的系数 取值范围 0 ~ 1
 @param zoom            水印的缩放系数
 SDK 内部会根据视频分辨率计算水印实际的像素位置和尺寸。
 */
- (NSInteger)setWatermark:(UIImage *)image position:(CGPoint)position zoom:(CGFloat)zoom;

/**
 移除水印
 */
- (NSInteger)removeWatermark;

#pragma mark - 设置检测
/**
 麦克风 & 扬声器检测
 @param timeInterval 表示获取本次测试结果的间隔时间。该参数单位为s，取值范围为 [2 10]，小于 2 按 2s 处理，大于 10 按 10s 处理。
 */
- (NSInteger)startEchoTest:(NSInteger)timeInterval;

/**
 停止麦克风 & 扬声器检测
 */
- (NSInteger)stopEchoTest;

#pragma mark - 网络探测

/**
 加入房间前，调用 startNetworkProbe： 开启网络质量探测。开启探测成功后，会通过 onRTCProbeStatus 回调来反馈探测结果。每隔约 2 秒回调一次上下行网络的带宽、丢包、网络抖动和往返时延等数据。
 探测总时长约为 30 秒，30 秒后会自动停止探测并调用 onNetworkProbeCompleted 回调方法通知上层应用探测结束。
 @warning 注意，在探测自动结束 onNetworkProbeCompleted 前，如调用 joinRoom 加房间操作会打断当前正在进行的 RTC 网络探测。
 */
- (NSInteger)startNetworkProbe:(id<RCRTCIWNetworkProbeDelegate> _Nullable)delegate;

/**
 开启探测成功约 30 秒后，会自动停止探测，如果不想等待自动结束，可主动调用 stopNetworkProbe: 方法强制停止探测。
 */
- (NSInteger)stopNetworkProbe;

#pragma mark - SEI

/*!
 开启 SEI 功能

 @param enable YES 开启，NO 不开启，默认 NO

 @discussion 开启 SEI 功能观众身份调用无效，观众不允许发布流，所以不具备 SEI 能力。
 Added from 5.2.5
*/
- (NSInteger)enableSei:(BOOL)enable;

/*!
 发送媒体增强补充信息
 
 @param sei 数据字符
 @discussion 此接口可在开发者推流传输音视频流数据并且[enableSei] 开启SEI 功能的同时，发送流媒体增强补充信息来同步一些其他附加信息。
 一般如同步音乐歌词或视频画面精准布局等场景，可选择使用发送 SEI。当推流方发送 SEI 后，拉流方可通过 RCRTCIWEngineDelegate 监听 [didReceiveSEI] & [didReceiveLiveStreamSEI] 的回调获取 SEI 内容。由于 SEI 信息跟随视频帧，由于网络问题有可能丢帧，因此 SEI 信息也有可能丢，为解决这种情况，应该在限制频率内多发几次。限制频率：1秒钟不要超过30次。SEI 数据长度限制为 4096 字节。
 
 Added from 5.2.5
*/
- (NSInteger)sendSei:(NSString *)sei;

/*!
 预链接到媒体服务器
 @discussion
 预链接到媒体服务器
*/
- (NSInteger)preconnectToMediaServer;

#pragma mark - Version
/*!
 获取当前 SDK 编译版本号
 @discussion
 获取当前 SDK 编译版本号
 */
+ (NSString *)getRongRTCLibWrapperVersion;

@end

NS_ASSUME_NONNULL_END
