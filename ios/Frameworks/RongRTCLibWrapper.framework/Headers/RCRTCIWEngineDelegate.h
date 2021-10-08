//
//  RCRTCIWEngineDelegate.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/14.
//

#import <RongIMLibCore/RongIMLibCore.h>
#import "RCRTCIWDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCRTCIWEngineDelegate <NSObject>

@optional
#pragma mark - 本地用户房间相关操作回调
/*!
 本地用户加入房间回调
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 本地用户加入房间的回调
 */
- (void)onRoomJoined:(NSInteger)code message:(NSString *)errMsg;

/*!
 本地用户离开房间回调
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 本地用户离开房间回调
 */
- (void)onRoomLeft:(NSInteger)code message:(NSString *)errMsg;

/*!
 本地用户被踢出房间回调
 @param roomId 被踢出的房间
 @param errMsg 返回消息
 @discussion
 本地用户被踢出房间回调
 */
- (void)onKicked:(NSString *)roomId message:(NSString *)errMsg;

/*!
 本地用户操作错误回调
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 本地用户操作错误回调
 */
- (void)onError:(NSInteger)code message:(NSString *)errMsg;

#pragma mark - 本地用户发布本地资源操作回调
/*!
 本地用户发布资源回调
 @param type 媒体类型
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 本地用户发布资源回调
 */
- (void)onPublished:(RCRTCIWMediaType)type
               code:(NSInteger)code
            message:(NSString *)errMsg;

/*!
 本地用户取消发布资源回调
 @param type 媒体类型
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 本地用户取消发布资源回调
 */
- (void)onUnpublished:(RCRTCIWMediaType)type
                 code:(NSInteger)code
              message:(NSString *)errMsg;

#pragma mark - 本地会议用户或直播主播用户订阅资源操作回调
/*!
 订阅远端用户发布的资源操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param type 媒体类型
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 订阅远端用户发布的资源操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onSubscribed:(NSString *)userId
           mediaType:(RCRTCIWMediaType)type
                code:(NSInteger)code
             message:(NSString *)errMsg;

/*!
 取消订阅远端用户发布的资源, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param type 媒体类型
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 取消订阅远端用户发布的资源, 仅供会议用户或直播主播用户使用
 */
- (void)onUnsubscribed:(NSString *)userId
             mediaType:(RCRTCIWMediaType)type
                  code:(NSInteger)code
               message:(NSString *)errMsg;

#pragma mark - 本地观众用户订阅合流资源操作回调
/*!
 订阅合流资源操作回调, 仅供直播观众用户使用
 @param type 媒体类型
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 订阅合流资源操作回调, 仅供直播观众用户使用
 */
- (void)onLiveMixSubscribed:(RCRTCIWMediaType)type
                       code:(NSInteger)code
                    message:(NSString *)errMsg;

/*!
 取消订阅合流资源操作回调, 仅供直播观众用户使用
 @param type 媒体类型
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 取消订阅合流资源操作回调, 仅供直播观众用户使用
 */
- (void)onLiveMixUnsubscribed:(RCRTCIWMediaType)type
                         code:(NSInteger)code
                      message:(NSString *)errMsg;

#pragma mark - 本地用户操作设备回调
/*!
 本地用户开关摄像头操作回调
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 本地用户开关摄像头操作回调
 */
- (void)onEnableCamera:(BOOL)enable
                  code:(NSInteger)code
               message:(NSString *)errMsg;

/*!
 本地用户切换前后置摄像头操作回调
 @param camera 操作摄像头
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 本地用户切换前后置摄像头操作回调
 */
- (void)onSwitchCamera:(RCRTCIWCamera)camera
                  code:(NSInteger)code
               message:(NSString *)errMsg;

#pragma mark - 本地会议用户或直播主播用户收到远端用户第一帧回调
/*!
 收到远端用户第一个音频或视频关键帧回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param type 媒体类型
 @discussion
 收到远端用户第一个音频或视频关键帧回调, 仅供会议用户或直播主播用户使用
 */
- (void)onRemoteFirstFrame:(NSString *)userId type:(RCRTCIWMediaType)type;

#pragma mark - 观众用户收到远端用户第一帧回调
/*!
 收到远端用户第一个音频或视频关键帧回调, 仅供直播观众用户使用
 @discussion
 收到远端用户第一个音频或视频关键帧回调, 仅供直播观众用户使用
 */
- (void)onRemoteLiveMixFirstFrame:(RCRTCIWMediaType)type;

#pragma mark - 本地主播用户设置直播旁路推流操作回调
/*!
 添加旁路推流URL操作回调, 仅供直播主播用户使用
 @param url CDN URL
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 添加旁路推流URL操作回调, 仅供直播主播用户使用
 */
- (void)onLiveCdnAdded:(NSString *)url
                  code:(NSInteger)code
               message:(NSString *)errMsg;

/*!
 移除旁路推流URL操作回调, 仅供直播主播用户使用
 @param url CDN URL
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 移除旁路推流URL操作回调, 仅供直播主播用户使用
 */
- (void)onLiveCdnRemoved:(NSString *)url
                    code:(NSInteger)code
                 message:(NSString *)errMsg;

#pragma mark - 本地主播用户设置直播音视频合流操作回调
/*!
 设置合流布局类型操作回调, 仅供直播主播用户使用
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置合流布局类型操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixLayoutModeSet:(NSInteger)code
                       message:(NSString *)errMsg;
/*!
 设置合流布局填充类型操作回调, 仅供直播主播用户使用
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置合流布局填充类型操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixRenderModeSet:(NSInteger)code
                       message:(NSString *)errMsg;

/*!
 设置合流自定义布局操作回调, 仅供直播主播用户使用
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置合流自定义布局操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixCustomLayoutsSet:(NSInteger)code
                          message:(NSString *)errMsg;

/*!
 设置需要合流音频操作回调, 仅供直播主播用户使用
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置需要合流音频操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixCustomAudiosSet:(NSInteger)code
                         message:(NSString *)errMsg;

/*!
 设置合流音频码率操作回调, 仅供直播主播用户使用
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置合流音频码率操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixAudioBitrateSet:(NSInteger)code
                         message:(NSString *)errMsg;

/*!
 设置默认视频合流码率操作回调, 仅供直播主播用户使用
 @param tiny 是否小流
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置默认视频合流码率操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixVideoBitrateSet:(BOOL)tiny
                            code:(NSInteger)code
                         message:(NSString *)errMsg;

/*!
 设置默认视频分辨率操作回调, 仅供直播主播用户使用
 @param tiny 是否小流
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置默认视频分辨率操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixVideoResolutionSet:(BOOL)tiny
                               code:(NSInteger)code
                            message:(NSString *)errMsg;

/*!
 设置默认视频帧率操作回调, 仅供直播主播用户使用
 @param tiny 是否小流
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 设置默认视频帧率操作回调, 仅供直播主播用户使用
 */
- (void)onLiveMixVideoFpsSet:(BOOL)tiny
                        code:(NSInteger)code
                     message:(NSString *)errMsg;

#pragma mark - 本地会议用户或直播主播用户设置音效操作回调
/*!
 创建音效操作回调, 仅供会议用户或直播主播用户使用
 @param effectId 音效文件ID
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 创建音效操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onAudioEffectCreated:(NSInteger)effectId
                        code:(NSInteger)code
                     message:(NSString *)errMsg;

/*!
 播放音效结束, 仅供会议用户或直播主播用户使用
 @param effectId 返回码
 @discussion
 音效播放结束, 仅供会议用户或直播主播用户使用
 */
- (void)onAudioEffectFinished:(NSInteger)effectId;

#pragma mark - 本地会议用户或直播主播用户设置混音操作回调
/*!
 开始本地音频数据合流操作回调, 仅供会议用户或直播主播用户使用
 @discussion
 开始本地音频数据合流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onAudioMixingStarted;

/*!
 暂停本地音频数据合流操作回调, 仅供会议用户或直播主播用户使用
 @discussion
 暂停本地音频数据合流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onAudioMixingPaused;

/*!
 恢复本地音频数据合流操作回调, 仅供会议用户或直播主播用户使用
 @discussion
 恢复本地音频数据合流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onAudioMixingResume;
/*!
 停止本地音频文件数据合流操作回调, 仅供会议用户或直播主播用户使用
 @discussion
 停止本地音频文件数据合流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onAudioMixingStopped;

/*!
 结束本地音频文件数据合流操作回调, 仅供会议用户或直播主播用户使用
 @discussion
 结束本地音频文件数据合流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onAudioMixingFinished;

#pragma mark - 本地用户收到消息
/*!
 本地用户收到远端用记发送消息
 @param message 消息
 @discussion
 本地用户收到远端用记发送消息
 */
- (void)onMessageReceived:(RCMessage *)message;

#pragma mark - 远端用户房间相关操作回调
/*!
 远端用户加入房间操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @discussion
 远端用户加入房间操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onUserJoined:(NSString *)userId;

/*!
 远端用户离开房间操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @discussion
 远端用户离开房间操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onUserLeft:(NSString *)userId;

/*!
 远端用户因离线离开房间操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @discussion
 远端用户因离线离开房间操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onUserOffline:(NSString *)userId;

#pragma mark - 远端用户发布资源操作回调
/*!
 远端用户发布资源操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param type 媒体类型
 @discussion
 远端用户发布资源操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onRemotePublished:(NSString *)userId
                mediaType:(RCRTCIWMediaType)type;

/*!
 远端用户取消发布资源操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param type 媒体类型
 @discussion
 远端用户取消发布资源操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onRemoteUnpublished:(NSString *)userId
                  mediaType:(RCRTCIWMediaType)type;

#pragma mark - 远端用户发布直播合流操作回调
/*!
 远端用户发布直播资源操作回调, 仅供直播观众用户使用
 @param type 媒体类型
 @discussion
 远端用户发布直播资源操作回调, 仅供直播观众用户使用
 */
- (void)onRemoteLiveMixPublished:(RCRTCIWMediaType)type;

/*!
 远端用户取消发布直播资源操作回调, 仅供直播观众用户使用
 @param type 媒体类型
 @discussion
 远端用户取消发布直播资源操作回调, 仅供直播观众用户使用
 */
- (void)onRemoteLiveMixUnpublished:(RCRTCIWMediaType)type;

#pragma mark - 远端用户开关设备操作回调
/*!
 远端用户开关麦克风或摄像头操作回调
 @param userId 远端用户UserId
 @param type 媒体类型
 @param disabled 是否关闭, YES: 关闭, NO: 打开
 @discussion
 远端用户开关麦克风或摄像头操作回调
 */
- (void)onRemoteStateChanged:(NSString *)userId
                        type:(RCRTCIWMediaType)type
                    disabled:(BOOL)disabled;

#pragma mark - 本地用户发布本地自定义流操作回调
/*!
 本地用户发布本地自定义流操作回调
 @param tag 本地自定义流标签
 @param code 返回码
 @param errMsg 返回信息
 @discussion
 本地用户发布本地自定义流操作回调
 */
- (void)onCustomStreamPublished:(NSString *)tag
                           code:(int)code
                        message:(NSString *)errMsg;

#pragma mark - 本地用户取消发布本地自定义流操作回调
/*!
 本地用户取消发布本地自定义流操作回调
 @param tag 本地自定义流标签
 @param code 返回码
 @param errMsg 返回信息
 @discussion
 本地用户取消发布本地自定义流操作回调
 */
- (void)onCustomStreamUnpublished:(NSString *)tag
                             code:(int)code
                          message:(NSString *)errMsg;

#pragma mark - 本地自定义流发布结束回调
/*!
 本地自定义流发布结束回调
 @param tag 本地自定义流标签
 @discussion
 本地自定义流发布结束回调
 */
- (void)onCustomStreamPublishFinished:(NSString *)tag;

#pragma mark - 远端用户发布自定义流操作回调
/*!
 远端用户发布自定义流操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param tag 自定义流标签
 @discussion
 远端用户发布自定义流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onRemoteCustomStreamPublished:(NSString *)userId
                                  tag:(NSString *)tag;

#pragma mark - 远端用户取消发布自定义流操作回调
/*!
 远端用户取消发布自定义流操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param tag 自定义流标签
 @discussion
 远端用户取消发布自定义流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onRemoteCustomStreamUnpublished:(NSString *)userId
                                    tag:(NSString *)tag;

#pragma mark - 远端用户开关自定义流操作回调
/*!
 远端用户开关自定义流操作回调
 @param userId 远端用户UserId
 @param tag 自定义流标签
 @param disabled 是否关闭, YES: 关闭, NO: 打开
 @discussion
 远端用户开关自定义流操作回调
 */
- (void)onRemoteCustomStreamStateChanged:(NSString *)userId
                                     tag:(NSString *)tag
                                disabled:(BOOL)disabled;

#pragma mark - 本地会议用户或直播主播用户收到远端用户自定义流第一帧回调
/*!
 收到远端用户自定义流第一个关键帧回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param tag 自定义流标签
 @discussion
 收到远端用户自定义流第一个关键帧回调, 仅供会议用户或直播主播用户使用
 */
- (void)onRemoteCustomStreamFirstFrame:(NSString *)userId
                                   tag:(NSString *)tag;

#pragma mark - 本地会议用户或直播主播用户订阅自定义流操作回调
/*!
 订阅远端用户发布的自定义流操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param tag 自定义流标签
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 订阅远端用户发布的自定义流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onCustomStreamSubscribed:(NSString *)userId
                             tag:(NSString *)tag
                            code:(int)code
                         message:(NSString *)errMsg;

#pragma mark - 本地会议用户或直播主播用户取消订阅自定义流操作回调
/*!
 取消订阅远端用户发布的自定义流操作回调, 仅供会议用户或直播主播用户使用
 @param userId 远端用户UserId
 @param tag 自定义流标签
 @param code 返回码
 @param errMsg 返回消息
 @discussion
 取消订阅远端用户发布的自定义流操作回调, 仅供会议用户或直播主播用户使用
 */
- (void)onCustomStreamUnsubscribed:(NSString *)userId
                               tag:(NSString *)tag
                              code:(int)code
                           message:(NSString *)errMsg;

@end

NS_ASSUME_NONNULL_END
