//
//  RCRTCIWEngineSetup.h
//  RongRTCLibWrapper
//
//  Created by RongCloud on 2021/5/19.
//

#import <Foundation/Foundation.h>
#import "RCRTCIWAudioSetup.h"
#import "RCRTCIWVideoSetup.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRTCIWEngineSetup : NSObject

@property (nonatomic, strong) NSString *mediaUrl;

/*!
 连接断开后是否 SDK 内部重连, 默认: NO 不重连
 */
@property (nonatomic, assign) BOOL reconnectable;

/*!
 设置房间统计信息的回调间隔, 单位: 毫秒, 默认: 1000ms(1s)
 注意: interval 值太小会影响 SDK 性能，如果小于 100 配置无法生效
 */
@property (nonatomic, assign) NSInteger statsReportInterval;

/*!
 是否开启媒体流加密 SRTP 功能, 默认: NO 关闭
 注意: 开启该功能会对性能和用户体验有影响, 如果没有该需求请不要打开
 */
@property (nonatomic, assign) BOOL enableSRTP;

/*!
 音频参数
 */
@property (nonatomic, strong) RCRTCIWAudioSetup *audioSetup;

/*!
 视频参数
 */
@property (nonatomic, strong) RCRTCIWVideoSetup *videoSetup;

@end

NS_ASSUME_NONNULL_END
